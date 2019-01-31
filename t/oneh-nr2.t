use strict;
use warnings;
use PDL;
use PDL::NiceSlice;
use PDL::Complex;
use Photonic::Geometry::FromB;
use Photonic::LE::NR2::OneH;

use Test::More tests => 4;

#my $pi=4*atan2(1,1);

sub agree {    
    my $a=shift;
    my $b=shift//0;
    return (($a-$b)*($a-$b))->sum<=1e-7;
}

#Check haydock coefficients for simple 1D system
my $B=zeroes(11)->xvals<5; #1D system
my $g=Photonic::Geometry::FromB->new(B=>$B, Direction0=>pdl([1]));
my $o=Photonic::LE::NR2::OneH->new(geometry=>$g);
$o->iterate;
ok(agree(pdl($o->current_a), $g->f), "1D a_0");
ok(agree(pdl($o->next_b2), $g->f*(1-$g->f)), "1D b_1^2");
$o->iterate;
ok(agree(pdl($o->current_a), 1-$g->f), "1D a_1");
ok(agree(pdl($o->next_b2), 0), "1D b_2^2");
