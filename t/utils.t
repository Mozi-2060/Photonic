use strict;
use warnings;
use PDL;
use Photonic::Utils;
Photonic::Utils->import(@Photonic::Utils::EXPORT_OK);
use Test::More;
use lib 't/lib';
use TestUtils;

my $x = zeroes(11)->r2C;
$x->slice('0') .= 1;
my $single_complex_1 = $x;
my $got = HProd($x, $x);
ok approx($got, r2C(1)), 'HProd' or diag "got:$got";
$got = EProd($x, $x);
ok approx($got, r2C(1)), 'EProd' or diag "got:$got";

$x = zeroes(1, 11)->r2C;
$x->slice(':,0') .= 1;
$got = MHProd($x, $x, ones(1, 1, 11));
ok approx($got, r2C(1)), 'MHProd' or diag "got:$got";

$x = zeroes(2, 11)->r2C;
$x->slice(':,0') .= 1/sqrt(2);
$got = SProd($x, $x);
ok approx($got, r2C(1)), 'SProd' or diag "got:$got";

$x = zeroes(1, 2, 11)->r2C;
$x->slice(':,:,0') .= 1/sqrt(2);
$got = VSProd($x, $x);
ok approx($got, r2C(1)), 'VSProd' or diag "got:$got";

$got = lentzCF(
  pdl('[21+32i 23+34i]')/11,
  pdl('[-1 -8.7603535536828499e-17-1.98347107438017i]'),
  2,
  1e-7,
);
my $expected = czip 1.4688427299703299, 2.6112759643916901;
ok approx($got, $expected), 'lentzCF' or diag "got: $got, expected $expected";

$expected = czip -1.2045454545454499, -0.79545454545454497;
$got = lentzCF(
  $expected,
  czip(-1, -0.247933884297521),
  1,
  1e-7,
);
ok approx($got, $expected), 'lentzCF' or diag "got: $got, expected $expected";

$expected = pdl <<'EOF';
[
 [
  [
   [ 0  1  2  3  0  1  2  3  0  1  2  3]
   [ 4  5  6  7  4  5  6  7  4  5  6  7]
   [ 8  9 10 11  8  9 10 11  8  9 10 11]
   [12 13 14 15 12 13 14 15 12 13 14 15]
   [ 0  1  2  3  0  1  2  3  0  1  2  3]
   [ 4  5  6  7  4  5  6  7  4  5  6  7]
   [ 8  9 10 11  8  9 10 11  8  9 10 11]
   [12 13 14 15 12 13 14 15 12 13 14 15]
   [ 0  1  2  3  0  1  2  3  0  1  2  3]
   [ 4  5  6  7  4  5  6  7  4  5  6  7]
   [ 8  9 10 11  8  9 10 11  8  9 10 11]
   [12 13 14 15 12 13 14 15 12 13 14 15]
  ]
  [
   [16 17 18 19 16 17 18 19 16 17 18 19]
   [20 21 22 23 20 21 22 23 20 21 22 23]
   [24 25 26 27 24 25 26 27 24 25 26 27]
   [28 29 30 31 28 29 30 31 28 29 30 31]
   [16 17 18 19 16 17 18 19 16 17 18 19]
   [20 21 22 23 20 21 22 23 20 21 22 23]
   [24 25 26 27 24 25 26 27 24 25 26 27]
   [28 29 30 31 28 29 30 31 28 29 30 31]
   [16 17 18 19 16 17 18 19 16 17 18 19]
   [20 21 22 23 20 21 22 23 20 21 22 23]
   [24 25 26 27 24 25 26 27 24 25 26 27]
   [28 29 30 31 28 29 30 31 28 29 30 31]
  ]
 ]
 [
  [
   [32 33 34 35 32 33 34 35 32 33 34 35]
   [36 37 38 39 36 37 38 39 36 37 38 39]
   [40 41 42 43 40 41 42 43 40 41 42 43]
   [44 45 46 47 44 45 46 47 44 45 46 47]
   [32 33 34 35 32 33 34 35 32 33 34 35]
   [36 37 38 39 36 37 38 39 36 37 38 39]
   [40 41 42 43 40 41 42 43 40 41 42 43]
   [44 45 46 47 44 45 46 47 44 45 46 47]
   [32 33 34 35 32 33 34 35 32 33 34 35]
   [36 37 38 39 36 37 38 39 36 37 38 39]
   [40 41 42 43 40 41 42 43 40 41 42 43]
   [44 45 46 47 44 45 46 47 44 45 46 47]
  ]
  [
   [48 49 50 51 48 49 50 51 48 49 50 51]
   [52 53 54 55 52 53 54 55 52 53 54 55]
   [56 57 58 59 56 57 58 59 56 57 58 59]
   [60 61 62 63 60 61 62 63 60 61 62 63]
   [48 49 50 51 48 49 50 51 48 49 50 51]
   [52 53 54 55 52 53 54 55 52 53 54 55]
   [56 57 58 59 56 57 58 59 56 57 58 59]
   [60 61 62 63 60 61 62 63 60 61 62 63]
   [48 49 50 51 48 49 50 51 48 49 50 51]
   [52 53 54 55 52 53 54 55 52 53 54 55]
   [56 57 58 59 56 57 58 59 56 57 58 59]
   [60 61 62 63 60 61 62 63 60 61 62 63]
  ]
 ]
]
EOF
$got = tile(sequence(4, 4, 2, 2), 3, 3);
ok all(approx($got, $expected)), 'tile' or diag "got: $got, expected $expected";

$got = [mvN(ones(2,1,11), 0, 0, -1)->dims];
is_deeply $got, [1,11,2], 'mvN small 1 to -1' or diag explain $got;
my $data = ones(1,2,3,4,5,6);
is_deeply [mvN($data, 1, 1, -1)->dims], [1,3,4,5,6,2], 'mvN 1 to -1';
is_deeply [mvN($data, 0, -1, -1)->dims], [1,2,3,4,5,6], 'mvN no-op if 0,-1';
is_deeply [mvN($data, 0, 2, 1)->dims], [1,2,3,4,5,6], 'mvN no-op if dest within start/end';
is_deeply [mvN($data, 1, 2, 5)->dims], [1,4,5,6,2,3], 'mvN to 5';
is_deeply [mvN($data, 1, 2, -1)->dims], [1,4,5,6,2,3], 'mvN to -1';
is_deeply [mvN($data, 1, 2, 4)->dims], [1,4,5,2,3,6], 'mvN to 4';
is_deeply [mvN($data, 1, 2, 1)->dims], [1,2,3,4,5,6], 'mvN to within start/end=no-op';
is_deeply [mvN(ones(1,4,5,6,2,3), -2, -1, 1)->dims], [1,2,3,4,5,6], 'mvN with negative start/end';

$expected = pdl(<<'EOF');
[
 [ [ 0 -4.3260582e-17+6.1800832e-18i ] ]
 [ [ 0 -5.9528635e-17+2.4920212e-17i ] ]
 [ [ 0 -2.7186406e-17+6.2313278e-17i ] ]
 [ [ 0 -1.2929662e-17+5.3169197e-17i ] ]
 [ [ 0 1.3401775e-17+1.10965e-16i ] ]
 [ [ 0 1.5419056e-16+6.9763677e-17i ] ]
 [ [ 0  1.2848911e-16-1.1014649e-16i ] ]
 [ [ 0 -1.8204495e-17-1.1027889e-16i ] ]
 [ [ 0  -2.729985e-17-4.7422124e-17i ] ]
 [ [ 0 -4.3546668e-17-5.2208553e-17i ] ]
 [ [ 0 -6.4125149e-17-7.2553859e-18i ] ]
]
EOF
$got = RtoG(pdl(<<'EOF'), 2, 1);
[
 [ [ 0 0 ] ]
 [ [ 0 -7.9823116e-17+1.1403302e-17i ] ]
 [ [ 0  4.1596509e-17-5.9423584e-18i ] ]
 [ [ 0 -2.9756908e-17+4.2509868e-18i ] ]
 [ [ 0  2.4722933e-17-3.5318475e-18i ] ]
 [ [ 0 0 ] ]
 [ [ 0 0 ] ]
 [ [ 0 0 ] ]
 [ [ 0 0 ] ]
 [ [ 0 0 ] ]
 [ [ 0 0 ] ]
]
EOF
ok all(approx($got, $expected)), 'RtoG' or diag "got: $got, expected $expected";

$expected = pdl(<<'EOF');
[
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0 -7.5890335e-17+1.0841476e-17i ] ]
 [ [ 0  4.5529289e-17-6.5041841e-18i ] ]
 [ [ 0 -2.5824128e-17+3.6891611e-18i ] ]
 [ [ 0  2.8655713e-17-4.0936733e-18i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
 [ [ 0  3.9327802e-18-5.6182574e-19i ] ]
]
EOF
$got = GtoR(pdl(<<'EOF'), 2, 1);
[
 [ [ 0 0 ] ]
 [ [ 0 -5.9528635e-17+2.4920212e-17i ] ]
 [ [ 0 -2.7186406e-17+6.2313278e-17i ] ]
 [ [ 0 -1.2929662e-17+5.3169197e-17i ] ]
 [ [ 0 1.3401775e-17+1.10965e-16i ] ]
 [ [ 0 1.5419056e-16+6.9763677e-17i ] ]
 [ [ 0  1.2848911e-16-1.1014649e-16i ] ]
 [ [ 0 -1.8204495e-17-1.1027889e-16i ] ]
 [ [ 0  -2.729985e-17-4.7422124e-17i ] ]
 [ [ 0 -4.3546668e-17-5.2208553e-17i ] ]
 [ [ 0 -6.4125149e-17-7.2553859e-18i ] ]
]
EOF
ok all(approx($got, $expected)), 'GtoR' or diag "got: $got, expected $expected";

$expected = pdl(<<'EOF');
[
  [0 5 10 0 5 10 0 5 10]
  [0 0 0 5 5 5 10 10 10]
  [0 0 0 0 0 0 0 0 0]
  [0 0 0 0 0 0 0 0 0]
]
EOF
$got = pdl(vectors2Dlist(pdl(<<'EOF'), 0, 5));
[
 [
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
 ]
 [
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
 ]
 [
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
 ]
 [
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
 ]
 [
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
 ]
 [
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
 ]
 [
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
 ]
 [
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
 ]
 [
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
 ]
 [
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
 ]
 [
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
  [    0.5751249    0.81806562]
  [    0.2656728    0.96406326]
  [2.2330872e-15             1]
  [   -0.2656728    0.96406326]
  [   -0.5751249    0.81806562]
 ]
 [
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
  [  -0.34115881    0.94000567]
  [ -0.030418434   -0.99953725]
  [-2.453355e-15            -1]
  [  0.030418434   -0.99953725]
  [   0.34115881    0.94000567]
 ]
 [
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
  [ 2.2231984e-15             -1]
  [ 7.4694778e-15             -1]
  [ 1.2043164e-15             -1]
  [-8.4014982e-15             -1]
  [-6.6911796e-16             -1]
 ]
 [
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
  [   0.34115881    0.94000567]
  [  0.030418434   -0.99953725]
  [8.8386295e-16            -1]
  [ -0.030418434   -0.99953725]
  [  -0.34115881    0.94000567]
 ]
 [
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
  [    -0.5751249     0.81806562]
  [    -0.2656728     0.96406326]
  [-1.9584407e-15              1]
  [     0.2656728     0.96406326]
  [     0.5751249     0.81806562]
 ]
]
EOF
ok all(approx($got, $expected)) or diag "got: $got, expected $expected";

$data = pdl(<<'EOF');
[
 0.72727273
 1733.403-2.8318751e-28i
 3466.0788
]
EOF
$got = tensor($data, [lu_decomp(pdl('[[1 0 0] [0.5 1 0.5] [0 0 1]]')->r2C)], 2, 2);
$expected = pdl(<<'EOF');
[
 [
  0.72727273
  -3.6365e-05-2.8318751e-28i
 ]
 [
  -3.6365e-05-2.8318751e-28i
  3466.0788
 ]
]
EOF
ok all(approx($got, $expected)), 'tensor' or diag "got: $got, expected $expected";

$data = pdl(<<'EOF');
[
 [
      0.67272727-0.10909091i
  -1.3253896e-09+1.7631692e-09i
 ]
 [
  -1.3253896e-09+1.7631692e-09i
        -153.825-1737.5269i
 ]
]
EOF
$got = wave_operator($data, 2);
$expected = pdl(<<'EOF');
[
 [
      1.4483986+0.23487544i
  1.1625849e-12+1.4461083e-12i
 ]
 [
   1.1625849e-12+1.4461083e-12i
  -5.0556058e-05+0.00057105487i
 ]
]
EOF
ok all(approx($got, $expected)), 'wave_operator' or diag "got: $got, expected $expected";

$data = pdl(<<'EOF');
[
 [ 1]
 [ 1]
 [ 1]
 [ 1]
 [ 1]
 [ 1]
 [-1]
 [-1]
 [-1]
 [-1]
 [-1]
]
EOF
$got = apply_longitudinal_projection($single_complex_1, $data, 1, (zeroes(11)->xvals<5)->r2C);
$expected = pdl(<<'EOF');
[
     0.45454545
     0.13268118-0.29053126i
   -0.031023048-0.035802506i
     0.10498734-0.030827064i
   0.0076895443-0.053481955i
    0.058392258+0.037526426i
   -0.058392258+0.037526426i
  -0.0076895443-0.053481955i
    -0.10498734-0.030827064i
    0.031023048-0.035802506i
    -0.13268118-0.29053126i
]
EOF
ok all(approx($got, $expected)), 'apply_longitudinal_projection' or diag "got:$got\nexpected:$expected";

$data = pdl q[[1 0][0.70710678 0.70710678][0 1]];
$got = make_dyads(2, $data);
$expected = pdl(<<'EOF');
[
 [  1   0   0]
 [0.5   1 0.5]
 [  0   0   1]
]
EOF
ok all(approx($got, $expected)), 'make_dyads' or diag "got:$got\nexpected:$expected";

is_deeply triangle_coords(3, 1)->unpdl, [[0,0], [0,1], [0,2], [1,1], [1,2], [2,2]], 'triangle_coords with diag';
is_deeply triangle_coords(3)->unpdl, [[0,1], [0,2], [1,2]], 'triangle_coords without diag';

$got = [dummyN(sequence(2, 3), 3, 0, 4)->dims];
is_deeply $got, [4, 4, 4, 2, 3], 'dummyN' or diag explain $got;
$got = [dummyN(sequence(2, 3), 3, 1, 4)->dims];
is_deeply $got, [2, 4, 4, 4, 3], 'dummyN' or diag explain $got;
$got = [dummyN(sequence(2, 3), 3, -1, 4)->dims];
is_deeply $got, [2, 3, 4, 4, 4], 'dummyN at -1' or diag explain $got;
$got = [dummyN(sequence(2, 3), 3, -2, 4)->dims];
is_deeply $got, [2, 4, 4, 4, 3], 'dummyN at -2' or diag explain $got;

my $s1 = pdl '[ [0 0] [0 1] [1 1] ]';
$got = cartesian_product($s1, sequence(2));
$expected = pdl '[
  [0 0 0]
  [0 1 0]
  [1 1 0]
  [0 0 1]
  [0 1 1]
  [1 1 1]
]';
ok all(approx($got, $expected)), 'cartesian_product 2x3,2' or diag "got:$got\nexpected:$expected";
$got = cartesian_product(sequence(2), $s1);
$expected = pdl '[
  [0 0 0]
  [1 0 0]
  [0 0 1]
  [1 0 1]
  [0 1 1]
  [1 1 1]
]';
ok all(approx($got, $expected)), 'cartesian_product 2,2x3' or diag "got:$got\nexpected:$expected";
$got = cartesian_product(sequence(2), sequence(3));
$expected = pdl '[
  [0 0]
  [1 0]
  [0 1]
  [1 1]
  [0 2]
  [1 2]
]';
ok all(approx($got, $expected)), 'cartesian_product 2,3' or diag "got:$got\nexpected:$expected";
$got = cartesian_product($s1, sequence(2)->dummy(0, 2));
$expected = pdl '[
  [0 0 0 0]
  [0 1 0 0]
  [1 1 0 0]
  [0 0 1 1]
  [0 1 1 1]
  [1 1 1 1]
]';
ok all(approx($got, $expected)), 'cartesian_product 2x3,2x2' or diag "got:$got\nexpected:$expected";

done_testing;
