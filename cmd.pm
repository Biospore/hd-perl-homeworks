#!/usr/bin/perl
package cmd;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 0.01;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(ls bashcall);
%EXPORT_TAGS = ( DEFAULT => [qw(&ls), qw(&bashcall)]
                );

my $logfile = " >> log.txt && echo '\n' >>log.txt";
my $getdate = "date >> log.txt";


sub bashcall {
    my $cmd = shift;
    if ($cmd ne ''){
    my $add = "echo 'Command:\t $cmd' >> log.txt && echo 'Output:' >> log.txt";
    system($getdate);
    system($add);
    system($cmd.$logfile);
    }
}

1;
