use utf8;
package Koha::Schema::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::Category

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<categories>

=cut

__PACKAGE__->table("categories");

=head1 ACCESSORS

=head2 categorycode

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 10

=head2 description

  data_type: 'longtext'
  is_nullable: 1

=head2 enrolmentperiod

  data_type: 'smallint'
  is_nullable: 1

=head2 enrolmentperioddate

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 upperagelimit

  data_type: 'smallint'
  is_nullable: 1

=head2 dateofbirthrequired

  data_type: 'tinyint'
  is_nullable: 1

=head2 finetype

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 bulk

  data_type: 'tinyint'
  is_nullable: 1

=head2 enrolmentfee

  data_type: 'decimal'
  is_nullable: 1
  size: [28,6]

=head2 overduenoticerequired

  data_type: 'tinyint'
  is_nullable: 1

=head2 issuelimit

  data_type: 'smallint'
  is_nullable: 1

=head2 reservefee

  data_type: 'decimal'
  is_nullable: 1
  size: [28,6]

=head2 hidelostitems

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 category_type

  data_type: 'varchar'
  default_value: 'A'
  is_nullable: 0
  size: 1

=head2 BlockExpiredPatronOpacActions

  accessor: 'block_expired_patron_opac_actions'
  data_type: 'tinyint'
  default_value: -1
  is_nullable: 0

=head2 default_privacy

  data_type: 'enum'
  default_value: 'default'
  extra: {list => ["default","never","forever"]}
  is_nullable: 0

=head2 checkprevcheckout

  data_type: 'varchar'
  default_value: 'inherit'
  is_nullable: 0
  size: 7

=head2 reset_password

  data_type: 'tinyint'
  is_nullable: 1

=head2 change_password

  data_type: 'tinyint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "categorycode",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 10 },
  "description",
  { data_type => "longtext", is_nullable => 1 },
  "enrolmentperiod",
  { data_type => "smallint", is_nullable => 1 },
  "enrolmentperioddate",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "upperagelimit",
  { data_type => "smallint", is_nullable => 1 },
  "dateofbirthrequired",
  { data_type => "tinyint", is_nullable => 1 },
  "finetype",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "bulk",
  { data_type => "tinyint", is_nullable => 1 },
  "enrolmentfee",
  { data_type => "decimal", is_nullable => 1, size => [28, 6] },
  "overduenoticerequired",
  { data_type => "tinyint", is_nullable => 1 },
  "issuelimit",
  { data_type => "smallint", is_nullable => 1 },
  "reservefee",
  { data_type => "decimal", is_nullable => 1, size => [28, 6] },
  "hidelostitems",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "category_type",
  { data_type => "varchar", default_value => "A", is_nullable => 0, size => 1 },
  "BlockExpiredPatronOpacActions",
  {
    accessor      => "block_expired_patron_opac_actions",
    data_type     => "tinyint",
    default_value => -1,
    is_nullable   => 0,
  },
  "default_privacy",
  {
    data_type => "enum",
    default_value => "default",
    extra => { list => ["default", "never", "forever"] },
    is_nullable => 0,
  },
  "checkprevcheckout",
  {
    data_type => "varchar",
    default_value => "inherit",
    is_nullable => 0,
    size => 7,
  },
  "reset_password",
  { data_type => "tinyint", is_nullable => 1 },
  "change_password",
  { data_type => "tinyint", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</categorycode>

=back

=cut

__PACKAGE__->set_primary_key("categorycode");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2019-11-14 19:54:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S27IIpck3Qk7chcNM8PW3w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
