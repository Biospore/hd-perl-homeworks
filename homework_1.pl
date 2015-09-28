#!/usr/local/bin/perl

$a = <STDIN>;
print "\nINPUT:\t$a";
my @stack;
my @stack2;
%prior = (
	'(' => 0,
	')' => 1,
	'+' => 2,
	'-' => 2,
	'*' => 3,
	'/' => 3,
	'^' => 4,
);

foreach $l (split //, $a){
	if ($l eq '('){
		push @stack, $l;
	}
	elsif ($l eq ')'){
		my $d = pop @stack;
		while ($d ne '('){
			push @stack2, $d;
			$d = pop@stack;
		}
	}
	elsif ($l eq '*' or $l eq '/' or $l eq '^' or $l eq '-' or $l eq '+'){
		if (@stack.length != 0){
			my $r = pop @stack;
			push @stack, $r; 
			while ($prior{$l} <= $prior{$r}){
				pop @stack;
				push @stack2, $r; 
				$r = pop @stack;
				push @stack, $r;
			}

		}
		push @stack, $l;
	}
	elsif ($l eq "\n"){
		print "\n";
	}
	else{
		push @stack2, $l;
	}
}
foreach $e (@stack){
	push @stack2, $e;
}
print "RPN:\t";
foreach $s (@stack2){
	print $s;
}
print "\n";

$a =~ s/\^/\*\*/;
$d = eval($a);
print "RESULT:\t$d\n";


