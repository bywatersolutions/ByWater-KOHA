use utf8;
package Koha::Schema::Result::Branch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::Branch

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<branches>

=cut

__PACKAGE__->table("branches");

=head1 ACCESSORS

=head2 branchcode

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 10

=head2 branchname

  data_type: 'longtext'
  is_nullable: 0

=head2 branchaddress1

  data_type: 'longtext'
  is_nullable: 1

=head2 branchaddress2

  data_type: 'longtext'
  is_nullable: 1

=head2 branchaddress3

  data_type: 'longtext'
  is_nullable: 1

=head2 branchzip

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 branchcity

  data_type: 'longtext'
  is_nullable: 1

=head2 branchstate

  data_type: 'longtext'
  is_nullable: 1

=head2 branchcountry

  data_type: 'mediumtext'
  is_nullable: 1

=head2 branchphone

  data_type: 'longtext'
  is_nullable: 1

=head2 branchfax

  data_type: 'longtext'
  is_nullable: 1

=head2 branchemail

  data_type: 'longtext'
  is_nullable: 1

=head2 branchreplyto

  data_type: 'longtext'
  is_nullable: 1

=head2 branchreturnpath

  data_type: 'longtext'
  is_nullable: 1

=head2 branchurl

  data_type: 'longtext'
  is_nullable: 1

=head2 issuing

  data_type: 'tinyint'
  is_nullable: 1

=head2 branchip

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=head2 branchprinter

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 branchnotes

  data_type: 'longtext'
  is_nullable: 1

=head2 opac_info

  data_type: 'mediumtext'
  is_nullable: 1

=head2 geolocation

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 marcorgcode

  data_type: 'varchar'
  is_nullable: 1
  size: 16

=head2 pickup_location

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "branchcode",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 10 },
  "branchname",
  { data_type => "longtext", is_nullable => 0 },
  "branchaddress1",
  { data_type => "longtext", is_nullable => 1 },
  "branchaddress2",
  { data_type => "longtext", is_nullable => 1 },
  "branchaddress3",
  { data_type => "longtext", is_nullable => 1 },
  "branchzip",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "branchcity",
  { data_type => "longtext", is_nullable => 1 },
  "branchstate",
  { data_type => "longtext", is_nullable => 1 },
  "branchcountry",
  { data_type => "mediumtext", is_nullable => 1 },
  "branchphone",
  { data_type => "longtext", is_nullable => 1 },
  "branchfax",
  { data_type => "longtext", is_nullable => 1 },
  "branchemail",
  { data_type => "longtext", is_nullable => 1 },
  "branchreplyto",
  { data_type => "longtext", is_nullable => 1 },
  "branchreturnpath",
  { data_type => "longtext", is_nullable => 1 },
  "branchurl",
  { data_type => "longtext", is_nullable => 1 },
  "issuing",
  { data_type => "tinyint", is_nullable => 1 },
  "branchip",
  { data_type => "varchar", is_nullable => 1, size => 15 },
  "branchprinter",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "branchnotes",
  { data_type => "longtext", is_nullable => 1 },
  "opac_info",
  { data_type => "mediumtext", is_nullable => 1 },
  "geolocation",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "marcorgcode",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "pickup_location",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</branchcode>

=back

=cut

__PACKAGE__->set_primary_key("branchcode");

=head1 RELATIONS

=head2 branch_item_rules

Type: has_many

Related object: L<Koha::Schema::Result::BranchItemRule>

=cut

__PACKAGE__->has_many(
  "branch_item_rules",
  "Koha::Schema::Result::BranchItemRule",
  { "foreign.branchcode" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 branches_overdrive

Type: might_have

Related object: L<Koha::Schema::Result::BranchesOverdrive>

=cut

__PACKAGE__->might_have(
  "branches_overdrive",
  "Koha::Schema::Result::BranchesOverdrive",
  { "foreign.branchcode" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 branchtransfers_frombranches

Type: has_many

Related object: L<Koha::Schema::Result::Branchtransfer>

=cut

__PACKAGE__->has_many(
  "branchtransfers_frombranches",
  "Koha::Schema::Result::Branchtransfer",
  { "foreign.frombranch" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 branchtransfers_tobranches

Type: has_many

Related object: L<Koha::Schema::Result::Branchtransfer>

=cut

__PACKAGE__->has_many(
  "branchtransfers_tobranches",
  "Koha::Schema::Result::Branchtransfer",
  { "foreign.tobranch" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 collections

Type: has_many

Related object: L<Koha::Schema::Result::Collection>

=cut

__PACKAGE__->has_many(
  "collections",
  "Koha::Schema::Result::Collection",
  { "foreign.colBranchcode" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 default_branch_circ_rule

Type: might_have

Related object: L<Koha::Schema::Result::DefaultBranchCircRule>

=cut

__PACKAGE__->might_have(
  "default_branch_circ_rule",
  "Koha::Schema::Result::DefaultBranchCircRule",
  { "foreign.branchcode" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 items_holdingbranches

Type: has_many

Related object: L<Koha::Schema::Result::Item>

=cut

__PACKAGE__->has_many(
  "items_holdingbranches",
  "Koha::Schema::Result::Item",
  { "foreign.holdingbranch" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 items_homebranches

Type: has_many

Related object: L<Koha::Schema::Result::Item>

=cut

__PACKAGE__->has_many(
  "items_homebranches",
  "Koha::Schema::Result::Item",
  { "foreign.homebranch" => "self.branchcode" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2019-11-14 19:54:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e/GXDjByh7cxhB9VAi+NUg

__PACKAGE__->add_columns(
    '+pickup_location' => { is_boolean => 1 }
);

sub koha_objects_class {
    'Koha::Libraries';
}

1;
