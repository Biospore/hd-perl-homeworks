#!/usr/bin/perl

use File::stat;

my $filename = $ARGV[0];
if (not -e $filename){
	die "No file input!\n";
}
my $size = stat($filename)->size;
if ($size <= 256){
	print reverse <>;
}
else{	
	open $fh, '<', $filename
		or die "Error occured when opening file '$filename'!\n";
	seek ($fh, $size, 0);
	my $flag = 0;
	my @res;
	my $readed;
	while ($size > 0){
		@res = mreadline(); 
		$readed = pop @res;
		my $rt = join "", reverse @res;
		if ($rt ne ""){
			print $rt."\n";
		}
		elsif ($flag){
			print "\n";	
		}
		else{
			$flag = 1;
		}
		$size -= $readed;
	}
	close $fh;
}

sub mreadline(){
	my $data = "";
	$i = 1;
	my @res;
	while ($data ne "\n" && $size - $i >=0){
		seek ($fh, ($size - $i), 0);
		$i++;
		read $fh, $data, 1;
		if ($data ne "\n"){
			push @res, $data;
		}
	}
	push @res, ($i - 1);
	return @res;
}
