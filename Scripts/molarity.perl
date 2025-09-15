#!/usr/sbin/perl
$molar = $ARGV[0];
$box_x = $ARGV[1];
$box_y = $ARGV[2];
$box_z = $ARGV[3];
$box_a = $ARGV[4];
$box_b = $ARGV[5];
$box_g = $ARGV[6];
if ($box_x == 0) {
printf("Usage: molarity box-x box-y box-z alpha beta gamma\n");
die;
}
if ($box_y == 0) {
$box_y = $box_x;
}
if ($box_z == 0) {
$box_z = $box_x;
}
if ($box_a == 0) {
$box_a = 90.0;
}
if ($box_b == 0) {
$box_b = $box_a;
}
if ($box_g == 0) {
$box_g = $box_a;
}
$torad = 2 * 3.141592654 / 360.0;
$rad_a = $box_a * $torad;
$rad_b = $box_b * $torad;
$rad_g = $box_g * $torad;
$angles = 1 - cos($rad_a)*cos($rad_a) - cos($rad_b)*cos($rad_b) - cos($rad_g)*cos($rad_g);
$angles += 2 * cos($rad_a)*cos($rad_b)*cos($rad_g);
$angles = sqrt($angles);
$volume = $box_x * $box_y * $box_z * $angles;
$molecules = 6.022 * $volume * $molar / 10000;
printf(" MOLARITY = %8.3f\n", $molar);
printf(" Box size = %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n", $box_x, $box_y, $box_z, $box_a, $box_b, $box_g);
printf(" Volume = %8.3f\n", $volume);
printf("\n %8.3f molecules are necessary to make a molarity of %6.2f M\n\n", $molecules, $molar);
#http://archive.ambermd.org/200907/0332.html
