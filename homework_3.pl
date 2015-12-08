#!/usr/bin/perl

use utf8;

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

sub work(){
	my $flag = 1;
	while (my $line = <$fh>){
		chomp $line;
		if ($flag){
			$target = $line;

			unless(-e "$target/new"){
				mkdir("$target/new");
			} else{
				if (-e "$target/old"){
#					system("rm -r $line/old");
					rmdir ("$target/old")
				}
				rename ("$target/new", "$target/old");
				deldir ("$target/old");                    
#				system("cp -r $line/new $line/old");
#				system("rm -r $line/new");
				mkdir("$target/new");
			}
			$flag = 0;
		} else{
			my @tmp = split('/', $line);
			my $destf = pop @tmp;
			mkdir ("$target/new/$destf");
			copydirstruct($line, $target."/new/".$destf);
		}

	}
}

sub deldir {
    my $dirtodel = pop;
    my $sep = '/';
    opendir(DIR, $dirtodel);
    my @files = readdir(DIR);
    closedir(DIR);
    @files = grep { !/^\.{1,2}/ } @files;
    @files = map { $_ = "$dirtodel$sep$_"} @files;
    @files = map { (-d $_)?deldir($_):unlink($_) } @files;
    rmdir($dirtodel);
}

sub copydirstruct(){
	my ($from, $to) = @_;
	opendir $dh, $from
		or die "Error while opening '$from'\n";
	my @stack;
	while (readdir $dh){
		chomp;
		if (-d $from.'/'.$_ and $_ ne "." and $_ ne ".."){
			mkdir ("$to/$_");
#			print "Created path: '$to/$_'\n";
#			print "Stacked: '$_'\n";
			push @stack, $_;
		}elsif (-f $from.'/'.$_){
			copyfile("$from/$_", "$to/$_");
#			print "Copied to file: '$to/$_'\n";
		}
	}
	foreach $path (@stack){
#		print "Recursively on $path\n";
		copydirstruct($from."/".$path, $to."/".$path);
	}
}

sub copyfile(){
	my ($from, $to) = @_;
	open my $fhfrom, '<', $from
		or die "Error while opening '$from'\n";
	open my $fhto, '>', $to
		or die "Error while opening '$to'\n";
	while (<$fhfrom>){
		print $fhto $_;
	}
	close $fhfrom;
	close $fhto;
}


read_config();
work();
=pod


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
				rename("$line/new", "$line/old");

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
#=pod
config file format:
	path to store
	list
	of
	dirs


=cut
