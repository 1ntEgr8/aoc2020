#!/usr/bin/perl

use strict;
use warnings;

my @start_input = (11,18,0,20,1,7,16);
my @test_start_input = (3,1,2);

my $turn = 1;
my $last_spoken;

sub enumerate {
    my $data = shift;
    my @enumeration = map [ $_, $data->[$_] ], 0 .. @$data-1;
    return @enumeration
}

sub spoken_twice {
    my ($val, $hash) = @_;

    return exists($hash->{$val}) 
        && $hash->{$val}->[0] != $hash->{$val}->[1];
}

sub part1 {
    my ($input, $till) = @_;

    # process start input
    my %seen = ();
    my @enumeration = enumerate($input);
    for my $el (@enumeration) {
        $seen{$el->[1]} = [$turn, $turn];
        $turn += 1;
    }
    
    $last_spoken = $input->[-1];
    
    # repeat un $till
    while ($turn <= $till) {
        if (spoken_twice($last_spoken, \%seen)) {
            $last_spoken = 
                $seen{$last_spoken}->[0] - $seen{$last_spoken}->[1]; 
        } else {
            $last_spoken = 0;
        }
        
        if (!exists($seen{$last_spoken})) {
            $seen{$last_spoken} = [$turn, $turn];
        }

        $seen{$last_spoken}[1] = $seen{$last_spoken}[0];
        $seen{$last_spoken}[0] = $turn;
        
        $turn += 1;
    }
    print $last_spoken, "\n";
}

# part1 (\@start_input, 2020);
part1 (\@start_input, 30000000); # this takes a while to run :(
