#!/usr/bin/perl

use File::stat;

my $bsize = 5;

my $filename = $ARGV[0];
if (not -e $filename){
	die "No file input!\n";
}
my $size = stat($filename)->size;



if ($size < 1){
	print reverse <>;
}
else{
    open $fh, '<', $filename
		or die "Error occured when opening file '$filename'!\n";
	seek ($fh, $size, 0);

    my @tmp;
    while ($size > 0){
        my $rsize = ($bsize, $size)[$bsize > $size];
        @tmp = mreadblock($rsize, $fh, @tmp);

        $size -= $rsize;
    }
    print join /''/, reverse @tmp;
    print "\n";

}

print $rsize;

sub mreadblock(){
    my $data = '';
    my $flag = 1;
    my ($rsize, $fh, @buf) = @_;
    seek ($fh, $size-$rsize, 0);
    read $fh, $data, $rsize;
    my @tmp = reverse split //, $data;

    for $key (@tmp){
        if ($key eq "\n"){
            print join /''/, reverse @buf;
            print "\n";            
            @buf = ();

        }
        else {
            push @buf, $key;
        }
    }
    return @buf;
}
=comm
else{
	open $fh, '<', $filename
		or die "Error occured when opening file '$filename'!\n";
	seek ($fh, $size, 0);
	my $flag = 0;
	my @tmp;
	my $readed;
	my @res;
	while ($size > 0){
		@tmp = mreadblock();
		$readed = pop @tmp;
		push @res, @tmp;

		$size -= $readed;
	}
	foreach $line (@res){
		print $line;
	}
	print $buf2."\n";
	close $fh;
}

sub mreadblock(){
	my $flag = 0;
	my $data = "";
	my $rsize = ($bsize, $size)[$bsize > $size];
	seek ($fh, ($size- $rsize), 0);
	read $fh, $data, $rsize;
	my @res;
	my @tmp;
	$buf2 = "";
	print $data."\t-\n";
	foreach my $i (split //, $data){
		push @tmp, $i;
		if ($i eq "\n"){
			$buf = (join "", @tmp).$buf;
			print "3\n";
			push @res, $buf;
			$buf = "";
			@tmp = ();
			$flag = 1;
		}
	}
	if ($flag){
		$buf = (join "", @tmp).$buf;
		$buft = pop @res;
		push @res, $buf.$buft;
	}
	$buf = (join "", @tmp).$buf;
	print $buf."\t2\n";
	push @res, $rsize;
	return @res;
}
=cut
