package Koha::BackgroundJob::BatchDeleteItem;

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

=head1 NAME

Koha::BackgroundJob::BatchDeleteItem - Background job derived class to process item deletion in batch

=cut

use Modern::Perl;
use JSON qw( encode_json decode_json );
use List::MoreUtils qw( uniq );
use Try::Tiny;

use Koha::DateUtils qw( dt_from_string );
use Koha::Items;

use base 'Koha::BackgroundJob';

=head1 API

=head2 Class methods

=head3 job_type

Return the job type 'batch_item_record_deletion'.

=cut

sub job_type {
    return 'batch_item_record_deletion';
}

=head3 process

    Koha::BackgroundJobs->find($id)->process(
        {
            record_ids => \@itemnumbers,
            deleted_biblios => 0|1,
        }
    );

Will delete all the items that have been passed for deletion.

When deleted_biblios is passed, if we deleted the last item of a biblio,
the bibliographic record will be deleted as well.

The search engine's index will be updated according to the changes made
to the deleted bibliographic recods.

The generated report will be:
  {
    deleted_itemnumbers => \@list_of_itemnumbers,
    not_deleted_itemnumbers => \@list_of_itemnumbers,
    deleted_biblionumbers=> \@list_of_biblionumbers,
  }

=cut

sub process {
    my ( $self, $args ) = @_;

    if ( $self->status eq 'cancelled' ) {
        return;
    }

    # FIXME If the job has already been started, but started again (worker has been restart for instance)
    # Then we will start from scratch and so double delete the same records

    my $job_progress = 0;
    $self->started_on(dt_from_string)->progress($job_progress)
      ->status('started')->store;

    my @record_ids     = @{ $args->{record_ids} };
    my $delete_biblios = $args->{delete_biblios};

    my $report = {
        total_records => scalar @record_ids,
        total_success => 0,
    };
    my @messages;
    my $schema = Koha::Database->new->schema;
    my ( @deleted_itemnumbers, @not_deleted_itemnumbers,
        @deleted_biblionumbers );

    try {
        my $schema = Koha::Database->new->schema;
        $schema->txn_do(
            sub {
                my (@biblionumbers);
                for my $record_id ( sort { $a <=> $b } @record_ids ) {

                    last if $self->get_from_storage->status eq 'cancelled';

                    my $item = Koha::Items->find($record_id) || next;

                    my $return = $item->safe_delete;
                    unless ( ref($return) ) {

                        # FIXME Do we need to rollback the whole transaction if a deletion failed?
                        push @not_deleted_itemnumbers, $item->itemnumber;
                        push @messages,
                          {
                            type         => 'error',
                            code         => 'item_not_deleted',
                            itemnumber   => $item->itemnumber,
                            biblionumber => $item->biblionumber,
                            barcode      => $item->barcode,
                            title        => $item->biblio->title,
                            reason       => $return,
                          };

                        next;
                    }

                    push @deleted_itemnumbers, $item->itemnumber;
                    push @biblionumbers,       $item->biblionumber;

                    $report->{total_success}++;
                    $self->progress( ++$job_progress )->store;
                }

                # If there are no items left, delete the biblio
                if ( $delete_biblios && @biblionumbers ) {
                    for my $biblionumber ( uniq @biblionumbers ) {
                        my $items_count =
                          Koha::Biblios->find($biblionumber)->items->count;
                        if ( $items_count == 0 ) {
                            my $error = C4::Biblio::DelBiblio( $biblionumber,
                                { skip_record_index => 1 } );
                            unless ($error) {
                                push @deleted_biblionumbers, $biblionumber;
                            }
                        }
                    }

                    if (@deleted_biblionumbers) {
                        my $indexer = Koha::SearchEngine::Indexer->new(
                            { index => $Koha::SearchEngine::BIBLIOS_INDEX } );

                        $indexer->index_records( \@deleted_biblionumbers,
                            'recordDelete', "biblioserver", undef );
                    }
                }
            }
        );
    }
    catch {

        warn $_;

        push @messages,
          {
            type  => 'error',
            code  => 'unknown',
            error => $_,
          };

        die "Something terrible has happened!"
          if ( $_ =~ /Rollback failed/ );    # Rollback failed
    };

    $report->{deleted_itemnumbers}     = \@deleted_itemnumbers;
    $report->{not_deleted_itemnumbers} = \@not_deleted_itemnumbers;
    $report->{deleted_biblionumbers}   = \@deleted_biblionumbers;

    my $job_data = decode_json $self->data;
    $job_data->{messages} = \@messages;
    $job_data->{report}   = $report;

    $self->ended_on(dt_from_string)->data( encode_json $job_data);
    $self->status('finished') if $self->status ne 'cancelled';
    $self->store;
}

=head3 enqueue

    Koha::BackgroundJob::BatchDeleteItem->new->enqueue(
        {
            record_ids => \@itemnumbers,
            deleted_biblios => 0|1,
        }
    );

Enqueue the job.

=cut

sub enqueue {
    my ( $self, $args ) = @_;

    # TODO Raise exception instead
    return unless exists $args->{record_ids};

    my @record_ids = @{ $args->{record_ids} };
    my $delete_biblios = $args->{delete_biblios} || 0;

    $self->SUPER::enqueue(
        {
            job_size => scalar @record_ids,
            job_args => {
                record_ids     => \@record_ids,
                delete_biblios => $delete_biblios,
            }
        }
    );
}

1;
