package Photonic::Geometry;
$Photonic::Geometry::VERSION='0.010';
use warnings;
use strict;
use Carp;

my @implementations=qw(FromB FromImage2D);
sub new {
    my $self=shift;
    croak "Use a specific implementation:" .
	join ", ", map {"Photonic::Geometry::" . $_} @implementations;
}
    
1;

=head1 NAME

Photonic::Geometry

=head1 VERSION

version 0.010

=head1 SYNOPSIS

use Photonic::Geometry::FromB;
my $g1=Photonic::Geometry::FromB->new(B=>$pdl);
use Photonic::Geometry::FromImage2D;
my $g2=Photonic::Geometry::FromImage2D->new(path=>$filename);

=head1 DESCRIPTION

Create a geometry object used in several modules of Photonic. 
This is a stub. You should choose a specific implementation. Currently
you could use 

=over 4

=item L<Photonic::Geometry::FromB>

Initialize the geometry from a characteriztic function

=item L<Photonic::Geometry::FromImage2D>

Initialize the geometry from a 2D black and white image.

=back

Consult the documentation of each implementation.

=cut
