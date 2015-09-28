#!/usr/local/bin/perl

#Чтение с потока ввода.
$a = <STDIN>;
print "\nINPUT:\t$a";
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
				#Костыль для 'просмотра' элемента на вершине стека.
				#Необходим для выкидывания из стека
				#всех операторов с >= приоритетом и
				#их записи в результирующий стек.
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
#Сброс остатка стека в результирующий стек.
foreach $e (@stack){
	push @stack2, $e;
}
#Вывод обратной польской нотации (RPN).
print "RPN:\t";
foreach $s (@stack2){
	print $s;
}
print "\n";

#Замена символа '^' на символы '**', т.к. в синтаксисе языка '^' - xor.
$a =~ s/\^/\*\*/;
#Расчет выражения.
$d = eval($a);
print "RESULT:\t$d\n";
