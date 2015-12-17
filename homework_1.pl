#!/usr/bin/perl


use utf8;

#Чтение с потока ввода.

close(STDERR);

if (@ARGV){
	$a  = join "", @ARGV;
}
else{
	$a = <>;
	chomp $a;
	$a =~ s/\s//g;
}

my $co = 0;
my $si = 0;
foreach $l (split //, $a){
	if ($l eq '('){
		$si ++;
		$co += 1;
	}
	elsif ($l eq ')'){
		if ($co == 0){
			print "Input error found.\n";
			exit 1;
		}
		$co -= 1;
	}
}

if ($co != 0){
	print "Input error found.\n";
	exit 1;
}
print "\nINPUT:\t$a\n";

#Резервирование двух списков.
my @stack;
my @stack2;
#Резервирование словаря для приоритеттов операторов.
%prior = (
	'(' => 0,
	')' => 1,
	'+' => 2,
	'-' => 2,
	'*' => 3,
	'/' => 3,
	'^' => 4,
);

=pod

Собственно сам алгоритм построения RPN, с использованием списков как стеков.
Введенная строка бьется на символы, по которым итерируется программа.
Т.к. в прочитанной строке содержится символ перевода строки,
есть соответствующий блок условия, отсекающий перевод строки.
Алгоритм поиска RPN: https://en.wikipedia.org/wiki/Reverse_Polish_notation

=cut


#Разбиение строки на символы + итерирование.
foreach $l (split //, $a){

	if ($l eq '('){
		push @stack, $l;

	}
	elsif ($l eq ')'){


		push @stack2, ' ';
		my $d = pop @stack;
		while ($d ne '('){
			push @stack2, $d;
			push @stack2, ' ';
			$d = pop @stack;
		}
	}
	elsif ($l eq '*' or $l eq '/' or $l eq '^' or $l eq '-' or $l eq '+'){
		push @stack2, ' ';
		if (scalar @stack != 0){
			my $r = pop @stack;
			push @stack, $r;
			while ($prior{$l} <= $prior{$r}){
				#Костыль для 'просмотра' элемента на вершине стека.
				#Необходим для выкидывания из стека
				#всех операторов с >= приоритетом и
				#их записи в результирующий стек.
				pop @stack;
				push @stack2, $r;
				push @stack2, ' ';
				$r = pop @stack;
				push @stack, $r;

			}
		}
		push @stack, $l;
	}
	else{
		push @stack2, $l;
	}
}
#Сброс остатка стека в результирующий стек.
foreach $e (reverse @stack){
	push @stack2, ' ';
	push @stack2, $e;
}

#Вывод обратной польской нотации (RPN).
print "RPN:\t";
print @stack2;
print "\n";

#Замена символа '^' на символы '**', т.к. в синтаксисе языка '^' - xor.

$r = $a;
$a =~ s/\^/\*\*/g;
#Расчет выражения.
$d = eval($a);
if ($d != ""){
	print "EVAL_RESULT:\t$d\n";
}
else{
	print "EvalError!\n";
	exit 1;
}



my @stack3;
my $answ = 0;

foreach $e (split / /, join '', @stack2){
	if ($e eq '*' or $e eq '/' or $e eq '^' or $e eq '-' or $e eq '+'){
		#Если попался оператор, извлекаем 2 операдна и вычисляем операцию.
		$r1 = pop @stack3;
		$r2 = pop @stack3;
		if ($e eq "^"){
			$tmp = $r2**$r1;
		}
		elsif ($e eq "*"){
			$tmp = $r2*$r1;
		}
		elsif ($e eq "/"){
			$tmp = $r2/$r1;
		}
		elsif ($e eq "-"){
			$tmp = $r2-$r1;
		}
		elsif ($e eq "+"){
			$tmp = $r2+$r1;
		}
		else{
			$tmp = 0;
		}
#		$tmp = eval($r2.$e.$r1);
		push @stack3, $tmp;
		$answ = $tmp;
	}
	#Сделано для исключения пустых символов.
	elsif ($e eq ""){
	}
	else{
		push @stack3, $e;
	}
}
print "RPN_RESULT:\t$answ\n";

=comm
sub degree(){
	my ($left, $right) = @_;
	my $const = $left;
	while ($right > 1){
		$left *= $const;
		$right -= 1;
	}
	return $left;
}
=cut
