#!/usr/bin/perl

use File::stat;

my $bsize = 256;
my $buf = "";
my $buf2 = "";

my $filename = $ARGV[0];
if (not -e $filename){
	die "No file input!\n";
}
my $size = stat($filename)->size;

if ($size < 256){
	print reverse <>;
}

else{	
	open $fh, '<', $filename
		or die "Error occured when opening file '$filename'!\n";
	seek ($fh, $size, 0);
	my $flag = 0;
	my @tmp;
	my $readed;
	while ($size > 0){
		@tmp = mreadblock(); 
		$readed = pop @tmp;

		foreach my $k(reverse @tmp){
			print $k."\n";;
		}
		$size -= $readed;
	}
	print $buf2."\n";
	close $fh;
}

sub mreadblock(){
	my $flag = 1;
	my $data = "";
	my $rsize = ($bsize, $size)[$bsize > $size];
	seek ($fh, ($size- $rsize), 0);
	read $fh, $data, $rsize;
	my @res;
	my @tmp;
	my $buft = $buf2;
	$buf2 = "";
	foreach my $i (split //, $data){
		if ($i ne "\n"){
			push @tmp, $i;
		}
		else{
			if ($flag){
				$flag = 0;
				$buf2 = join "", @tmp;
			}
			else{
				push @res, (join "", @tmp);
			}
			@tmp = ();
		}
	}

	$buf = "";
	$buf = join "", @tmp;
	push @res, $buf.$buft;
	push @res, $rsize;
	return @res;
}
