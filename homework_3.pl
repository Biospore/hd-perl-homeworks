#!/usr/bin/perl

use utf8;

use File::Find;
use File::Path qw(make_path);
use File::Copy;

my $fh;
my $target = "";

sub read_config(){
	my $filename = "config";
	if ($ARGV[0]){
		$filename = $ARGV[0];
	}
	open $fh, '<', $filename
		or die "No config file!\n";
}

sub wanted(){
	my $far = substr($File::Find::dir, length($target));
	unless (-d){
		make_path("$target". "/new/" . $far);
	}
	if(-f){
		copy($_, "$target". "/new/" . "$far");
	}
}

sub work(){
	my $flag = 1;
	while (my $line = <$fh>){
		chomp $line;
		if ($flag){
			$target = $line;
			unless (-e "$target/new"){
				make_path("$target/new");
			}
			else{
				if (-e "$line/old"){
					system("rm -r $line/old");
				}
				system("cp -r $line/new $line/old");
				system("rm -r $line/new");
				make_path("$line/new");
			}
			$flag = 0;
		}
		else{
			find(\&wanted, $line);			
		}		
	}
}

read_config();
work();
=pod
config file format:
	path to store
	list
	of
	dirs


=cut
