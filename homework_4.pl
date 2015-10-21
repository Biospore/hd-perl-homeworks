#!/usr/bin/perl

use File::stat;

my $filename = $ARGV[0];
if (not -e $filename){
	die "No file input!\n";
}

my $size = stat($filename)->size;

sub readID3v1(){
	my $lsize = $size - 128;
	my $data;
	my $title;
	my $artist;
	my $album;
	my $year;
	my $comment;
	my $genre;
	open my $fh, '+<', $filename
		or die "Error occured when opening file '$filename'!\n";
	seek $fh, $lsize, 0;

	read $fh, $data, 3;
	print "ID3v1:\n";

	read $fh, $title, 30;
	print "\tTitle:\t\t".$title."\n";

	read $fh, $artist, 30;
	print "\tArtist:\t\t".$artist."\n";

	read $fh, $album, 30;
	print "\tAlbum:\t\t".$album."\n";

	read $fh, $year, 4;
	print "\tYear:\t\t".$year."\n";

	read $fh, $comment, 30;
	print "\tComment:\t".$comment."\n";

	read $fh, $genre, 1;
	print "\tGenre:\t\t".ord($genre)."\n";
	print "\nDo you want to change ID3v1?(y|n)\n";
	my $answ = <STDIN>;
	chomp $answ;
	if ($answ eq "y" or $answ eq "Y"){
		seek $fh, $lsize, 0;
		print $fh "TAG";
		changeField("Title", 30, $fh);
		changeField("Artist", 30, $fh);
		changeField("Album", 30, $fh);
		changeField("Year", 4, $fh);
		changeField("Comment", 30, $fh);
		changeField("Genre", 1, $fh);
	}
	close $fh;

}

sub changeField(){
	my ($field, $length, $fh) = @_;
	print "Change field '$field'?(y|n)\n";
	my $answ = <STDIN>;
	chomp $answ;
	if ($answ eq "y" or $answ eq "Y"){
		my $newField = readSTD($length);
		print $fh $newField;
	}
	else{
		seek $fh, $length, 1;
	}
}

sub readSTD(){
	my ($length) = @_;
	my $varchar = <STDIN>;
	if ($length == 1){
		$varchar = chr(int($varchar));
	}
	chomp $varchar;
	my $len = length($varchar);
	if ($len < $length){
		$varchar = $varchar . chr(0) x ($length - $len);
	}
	elsif ($len > $length){
		$varchar = substr $varchar, 0, $length;
	}
	return $varchar;	
}

readID3v1();

