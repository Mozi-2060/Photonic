package Photonic::CharacteristicFunctions;
$Photonic::CharacteristicFunctions::VERSION = '0.008';
use Carp;
BEGIN {
    require Exporter;
    @ISA=qw(Exporter);
    @EXPORT_OK=qw(triangle isosceles ellipse );
}
use PDL::Lite;
use PDL::NiceSlice;
use PDL::Constants qw(PI);
use feature qw(say);
use warnings;
use strict;

sub ellipse { #f y e determinan univocamente el problema  general de inclusion
              #eliptica con e=zeta_y/zeta_x en una celda cuadrada
    my $N=shift;
    my $ff=shift;
    my $e=shift;
    my $a=PDL->pdl(1,1);
    my $z=PDL->zeroes(2*$N+1,2*$N+1); #change to admit arbitrary lattice
    my $r=$z->PDL::ndcoords-PDL->pdl($N,$N);
    if(($e>=1.0 && $ff<PI/(4.0*$e)) || ($e<=1.0 && $ff<PI*$e/4.0)){
	$a=sqrt($ff/PI)*(PDL->pdl(1.0/sqrt($e),sqrt($e))); 
	$a*=2*$N+1;
    }else{croak "filling fraction very large: overlaping of ellipses ! \n"}
    my $t=($r->((1))/$a->((1)))**2+($r->((0))/$a->((0)))**2<=1.0;
    return $t;
}

sub triangle { #smooth triangle for testing
    my $N=shift;
    my $r0=shift; #radio relativo nominal
    my $deltar=shift; #fluctuaciones
    my $theta0=shift;
    
    my $z=PDL->zeroes(2*$N+1,2*$N+1); #change to admit arbitrary lattice
    my $r=$z->PDL::ndcoords-PDL->pdl($N,$N);
    my $theta=atan2($r->((1)), $r->((0)));
    my $q=$z->PDL::rvals;
    #my $t=$q<(.75+.20*cos(3*$theta))*$N;
    my $t=$q<($r0+$deltar*cos(3*($theta-$theta0)))*$N;
    return $t;
}

sub isosceles { #smooth isoceles triangle for testing
    my $N=shift;
    my $r0=shift; #radio relativo nominal
    my $delta2=shift; #fluctuaciones en 2 theta
    my $delta3=shift; #fluctuaciones en 3 theta
    my $theta0=shift;
    
    my $z=PDL->zeroes(2*$N+1,2*$N+1); #change to admit arbitrary lattice
    my $r=$z->PDL::ndcoords-PDL->pdl($N,$N);
    my $theta=atan2($r->((1)), $r->((0)));
    my $q=$z->PDL::rvals;
    #my $t=$q<(.75+.20*cos(3*$theta))*$N;
    my $t=$q<($r0+$delta2*cos(2*($theta-$theta0))
	         +$delta3*cos(3*($theta-$theta0)))*$N;
    return $t;
}

1;

__END__

=head1 NAME

Photonic::CharacteristicFunctions

=head1 VERSION

version 0.008

=head1 SYNOPSIS

   use Photonic::CharacteristicFuncions qw(triangle isosceles ellipse)
   my $e=ellipse($N, $ff, $e);
   my $t=triangle($N, $r0, $deltar, $theta0);
   my $i=isosceles($N, $r0, $delta2, $delta3, $theta0);

=head1 DESCRIPTION

Provide a few characteristic functions that may be used in Photonic
calculations.  

=head1 EXPORTABLE FUNCTIONS

=over 4

=item * ellipse($N, $ff, $e)

returns an ellipse in a square lattice of side (2*$N+1)x(2*$N+1) with
filling fraction $ff and quotient between Y and X axes $e.

=item * triangle($N, $r0, $deltar, $theta0)

returns a smooth pear shaped triangle in a square lattice of side
(2*$N+1)x(2*$N+1) with border
r(theta)=$r0+$deltar*cos(3*(theta-$theta0)) 
in polar coordinates

=item * isosceles($N, $r0, $delta2, $delta3, $theta0)

returns a smooth pear shaped triangle in a square lattice of side
(2*$N+1)x(2*$N+1) with border
=r(theta)=$r0+$delta2*cos(2*(theta-$theta0))+$delta3*cos(3*(theta-$theta0)) 
in polar coordinates

=back

=cut
   
