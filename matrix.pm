#!/usr/bin/perl
package matrix;
use overload '*' => \&mul;
use Data::Dumper;

sub new{
    my $class = shift;
    my $value = shift;
    my $length = 0;
    my $rows = @$value;
    for $row (@$value){
        if ($length == 0){
            $length = @$row;
        }
        else {
            if ($length != @$row) {
                die "Not a valid matrix";
            }
        }
    }
    my $self = {
                value => $value,
                cols  => $length,
                rows  => $rows
                };
    return bless $self, $class;
}

sub get_size{
    my $self = shift;
    return ($self->{rows}, $self->{cols});
}

sub show{
    my $self = shift;
    my $value = $self->{value};
    for my $row (@$value){
        for my $col (@$row){
            print "$col\t";
        }
        print "\n";
    }
}

sub mul{
    my ($self, $other, undef) = @_;
    my $first = $self->{value};
    my $second = $other->{value};
    my ($rowf, $colf) = ($self->{rows}, $self->{cols});
    my ($rows, $cols) = $other->get_size();
    die "Matrix 1 has $colf columns and Matrix 2 has $rows rows\n".
    "Cannot multiply\n" unless ($colf==$rows);
    my $result;
    for (my $i=0; $i<$rowf ;$i++) {
        for (my $j=0;$j<$cols;$j++) {
            my $sum=0;
            for (my $k=0;$k<$colf;$k++) {
                $sum+=$first->[$i][$k] * $second->[$k][$j];
            }
            $result->[$i][$j]=$sum;
        }
    }
    return matrix->new($result);
}

1;
