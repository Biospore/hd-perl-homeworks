#!/usr/bin/perl

my $filename = shift
    or die "No arguments!\n";
open my $fh, '<', $filename
    or die "Can't locate file: $filename\n";

my $mails;


while (<$fh>){
    chomp;
    $_ =~ /.*mailto:([a-zA-Z0-9\-\_]+\@[0-9a-zA-Z]+\.[a-z]+).+([-+]\w+)/g;
    if ($1 ne ''){
        $mails{$1} = $2;
    }
}
foreach my $mail (keys %mails){
    print "$mail\t->\t$mails{$mail}\n";
}
close $fh;
