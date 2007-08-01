package Imager::Search;

use 5.005;
use strict;

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.05';
}





#####################################################################
# Main Methods

=pod

=head2 find

The C<find> method compiles the search and target images in memory, and
executes a single search, returning the position of the first match as a
L<Imager::Match::Occurance> object.

=cut

sub find {
	my $self  = shift;

	# Load the strings.
	# Do it by reference entirely for performance reasons.
	# This avoids copying some potentially very large string.
	my $small = '';
	my $big   = '';
	$self->_small_string( \$small );
	$self->_big_string( \$big );

	# Run the search
	my @match = ();
	my $bpp   = $self->bytes_per_pixel;
	while ( scalar $big =~ /$small/gs ) {
		my $p = $-[0];
		push @match, Imager::Match::Occurance->from_position($self, $p / $bpp);
		pos $big = $p + 1;
	}
	return @match;
}

=pod

=head2 find_first

The C<find_first> compiles the search and target images in memory, and
executes a single search, returning the position of the first match as a
L<Imager::Match::Occurance> object.

=cut

sub find_first {
	my $self  = shift;

	# Load the strings.
	# Do it by reference entirely for performance reasons.
	# This avoids copying some potentially very large string.
	my $small = '';
	my $big   = '';
	$self->_small_string( \$small );
	$self->_big_string( \$big );

	# Run the search
	my $bpp = $self->bytes_per_pixel;
	while ( scalar $big =~ /$small/gs ) {
		my $p = $-[0];
		return Imager::Match::Occurance->from_position($self, $p / $bpp);
	}
	return undef;
}

1;