#!/usr/bin/perl

my %words;
my $filename = shift
    or die "No arguments!\n";
open my $fh, '<', $filename
    or die "Can't locate file: $filename\n";

while (<$fh>){
    chomp;
    $_ =~ s/[,\.]/ /g;
    foreach my $word (split /\s+/, $_){
        if ($word ne ''){
            $words{lc $word}++;
        }
    }
}
close $fh;
foreach my $word (sort {$words{$b} <=> $words{$a}} keys %words){

    printf "%-16s\t%s\n", $word, $words{$word};
}
