package Koha::Template::Plugin::ItemTypes;

# Copyright ByWater Solutions 2012

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

use Modern::Perl;

use Template::Plugin;
use base qw( Template::Plugin );

use Koha::ItemTypes;

our %itemtypes;


sub GetDescription {
    my ( $self, $itemtypecode, $want_parent ) = @_;
    %itemtypes = map { $_->{itemtype} => $_ } @{Koha::ItemTypes->search_with_localization()->unblessed} unless %itemtypes;
    my $itemtype = $itemtypes{$itemtypecode};
    return q{} unless $itemtype;
    my $parent;
    $parent = $itemtypes{$itemtype->{parent_type}} if $want_parent;
    return $parent ? $parent->{translated_description} . "->" . $itemtype->{translated_description} : $itemtype->{translated_description};
}

sub Get {
    return Koha::ItemTypes->search_with_localization->unblessed;
}

1;
