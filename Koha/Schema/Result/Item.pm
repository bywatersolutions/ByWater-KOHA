use utf8;
package Koha::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::Item

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<items>

=cut

__PACKAGE__->table("items");

=head1 ACCESSORS

=head2 itemnumber

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 biblionumber

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 biblioitemnumber

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 barcode

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 dateaccessioned

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 booksellerid

  data_type: 'longtext'
  is_nullable: 1

=head2 homebranch

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 price

  data_type: 'decimal'
  is_nullable: 1
  size: [8,2]

=head2 replacementprice

  data_type: 'decimal'
  is_nullable: 1
  size: [8,2]

=head2 replacementpricedate

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 datelastborrowed

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 datelastseen

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 stack

  data_type: 'tinyint'
  is_nullable: 1

=head2 notforloan

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 damaged

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 damaged_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 itemlost

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 itemlost_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 withdrawn

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 withdrawn_on

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 itemcallnumber

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 coded_location_qualifier

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 issues

  data_type: 'smallint'
  is_nullable: 1

=head2 renewals

  data_type: 'smallint'
  is_nullable: 1

=head2 reserves

  data_type: 'smallint'
  is_nullable: 1

=head2 restricted

  data_type: 'tinyint'
  is_nullable: 1

=head2 itemnotes

  data_type: 'longtext'
  is_nullable: 1

=head2 itemnotes_nonpublic

  data_type: 'longtext'
  is_nullable: 1

=head2 holdingbranch

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 paidfor

  data_type: 'longtext'
  is_nullable: 1

=head2 timestamp

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 location

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 permanent_location

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 onloan

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 cn_source

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 cn_sort

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ccode

  data_type: 'varchar'
  is_nullable: 1
  size: 80

=head2 materials

  data_type: 'mediumtext'
  is_nullable: 1

=head2 uri

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 itype

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 more_subfields_xml

  data_type: 'longtext'
  is_nullable: 1

=head2 enumchron

  data_type: 'mediumtext'
  is_nullable: 1

=head2 copynumber

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 stocknumber

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 new_status

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "itemnumber",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "biblionumber",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "biblioitemnumber",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "barcode",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "dateaccessioned",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "booksellerid",
  { data_type => "longtext", is_nullable => 1 },
  "homebranch",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "price",
  { data_type => "decimal", is_nullable => 1, size => [8, 2] },
  "replacementprice",
  { data_type => "decimal", is_nullable => 1, size => [8, 2] },
  "replacementpricedate",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "datelastborrowed",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "datelastseen",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "stack",
  { data_type => "tinyint", is_nullable => 1 },
  "notforloan",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "damaged",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "damaged_on",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "itemlost",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "itemlost_on",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "withdrawn",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "withdrawn_on",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "itemcallnumber",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "coded_location_qualifier",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "issues",
  { data_type => "smallint", is_nullable => 1 },
  "renewals",
  { data_type => "smallint", is_nullable => 1 },
  "reserves",
  { data_type => "smallint", is_nullable => 1 },
  "restricted",
  { data_type => "tinyint", is_nullable => 1 },
  "itemnotes",
  { data_type => "longtext", is_nullable => 1 },
  "itemnotes_nonpublic",
  { data_type => "longtext", is_nullable => 1 },
  "holdingbranch",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "paidfor",
  { data_type => "longtext", is_nullable => 1 },
  "timestamp",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "location",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "permanent_location",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "onloan",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "cn_source",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "cn_sort",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ccode",
  { data_type => "varchar", is_nullable => 1, size => 80 },
  "materials",
  { data_type => "mediumtext", is_nullable => 1 },
  "uri",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "itype",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "more_subfields_xml",
  { data_type => "longtext", is_nullable => 1 },
  "enumchron",
  { data_type => "mediumtext", is_nullable => 1 },
  "copynumber",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "stocknumber",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "new_status",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</itemnumber>

=back

=cut

__PACKAGE__->set_primary_key("itemnumber");

=head1 UNIQUE CONSTRAINTS

=head2 C<itembarcodeidx>

=over 4

=item * L</barcode>

=back

=cut

__PACKAGE__->add_unique_constraint("itembarcodeidx", ["barcode"]);

=head1 RELATIONS

=head2 biblioitemnumber

Type: belongs_to

Related object: L<Koha::Schema::Result::Biblioitem>

=cut

__PACKAGE__->belongs_to(
  "biblioitemnumber",
  "Koha::Schema::Result::Biblioitem",
  { biblioitemnumber => "biblioitemnumber" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 biblionumber

Type: belongs_to

Related object: L<Koha::Schema::Result::Biblio>

=cut

__PACKAGE__->belongs_to(
  "biblionumber",
  "Koha::Schema::Result::Biblio",
  { biblionumber => "biblionumber" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 branchtransfers

Type: has_many

Related object: L<Koha::Schema::Result::Branchtransfer>

=cut

__PACKAGE__->has_many(
  "branchtransfers",
  "Koha::Schema::Result::Branchtransfer",
  { "foreign.itemnumber" => "self.itemnumber" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 holdingbranch

Type: belongs_to

Related object: L<Koha::Schema::Result::Branch>

=cut

__PACKAGE__->belongs_to(
  "holdingbranch",
  "Koha::Schema::Result::Branch",
  { branchcode => "holdingbranch" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "CASCADE",
  },
);

=head2 homebranch

Type: belongs_to

Related object: L<Koha::Schema::Result::Branch>

=cut

__PACKAGE__->belongs_to(
  "homebranch",
  "Koha::Schema::Result::Branch",
  { branchcode => "homebranch" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "CASCADE",
  },
);

=head2 old_issues

Type: has_many

Related object: L<Koha::Schema::Result::OldIssue>

=cut

__PACKAGE__->has_many(
  "old_issues",
  "Koha::Schema::Result::OldIssue",
  { "foreign.itemnumber" => "self.itemnumber" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 old_reserves

Type: has_many

Related object: L<Koha::Schema::Result::OldReserve>

=cut

__PACKAGE__->has_many(
  "old_reserves",
  "Koha::Schema::Result::OldReserve",
  { "foreign.itemnumber" => "self.itemnumber" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2019-11-14 19:54:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:I1nlgkObeyILVnBKrLGM9g

__PACKAGE__->belongs_to( biblioitem => "Koha::Schema::Result::Biblioitem", "biblioitemnumber" );

__PACKAGE__->belongs_to(
  "biblio",
  "Koha::Schema::Result::Biblio",
  { biblionumber => "biblionumber" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

use C4::Context;
sub effective_itemtype {
    my ( $self ) = @_;

    my $pref = C4::Context->preference('item-level_itypes');
    if ( $pref && $self->itype() ) {
        return $self->itype();
    } else {
        warn "item-level_itypes set but no itemtype set for item (".$self->itemnumber.")"
          if $pref;
        return $self->biblioitemnumber()->itemtype();
    }
}

1;
