#!/usr/bin/perl

use matrix;

my $obj1 = matrix->new([
            [1, 1, 1],
            [2, 2, 2],
            [3, 3, 3],
            [4, 4, 4],
            [4, 4, 4],
            [4, 4, 4]
            ]);
my $obj2 = matrix->new([
            [2, 2, 2, 2],
            [3, 3, 3, 3],
            [4, 4, 4, 4]
            ]);
my @size = $obj1->get_size();
my $obj3 = $obj1 * $obj2;
$obj3->show();
