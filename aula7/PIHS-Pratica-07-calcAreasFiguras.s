/* Programa que calcula as areas de retangulos e triangulos
   conforme dados fornecidos pelo usuario. Um menu de opcoes
   eh apresentado ao usuario
*/

.section .data

	base:		.int	0
	altura:		.int	0
	area:		.int	0
	opcao:		.int	0

	abertura:	.asciz	"\nCalculo de Areas de Figuras Geometricas\n\n"
	abertRet:	.asciz	"\nCalculo da Area do Retangulo\n"
	abertTri:	.asciz	"\nCalculo da Area do Triangulo\n"

	menuOpcao:	.asciz	"\nMenu de Opcao:\n<1> Area do Retangulo\n<2> Area do Triangulo"

	pedeBase:	.asciz	"\nDigite o valor da base => "
	pedeAltura:	.asciz	"\nDigite o valor da altura => "
	pedeOpcao:	.asciz	"\nDigite a opcao => "


	mostraRet:	.asciz	"\nArea do Retangulo = %d\n\n"
	mostraTri:	.asciz	"\nArea do Triangulo = %d\n\n"

	tipoDado:	.asciz	"%d"

.section .text

.globl _start

_start:

	pushl	$abertura
	call	printf

	pushl	$menuOpcao
	call	printf

	pushl	$pedeOpcao
	call	printf
	pushl	$opcao
	pushl	$tipoDado
	call	scanf

	movl	opcao, %eax
	cmpl	$1, %eax
	je	_calcRet
	cmpl	$2, %eax
	je	_calcTri

	addl	$20, %esp
	jmp	_start


_calcRet:

	pushl	$abertRet
	call	printf
	jmp	_cont

_calcTri:
	pushl	$abertTri
	call	printf


_cont:
	pushl	$pedeBase
	call	printf
	pushl	$base
	pushl	$tipoDado
	call	scanf

	pushl	$pedeAltura
	call	printf
	pushl	$altura
	pushl	$tipoDado
	call	scanf

	movl	base, %eax
	mull	altura		# multiplica %eax pelo operando e coloca o resultado em %edx:%eax
	movl	%eax, area

	movl	opcao, %ecx
	cmpl	$1, %ecx
	je	_mostraRet

	movl	$0, %edx
	movl	$2, %ebx
	divl	%ebx		# divide o par %edx:%eax e coloca o resultado em %eax
	movl	%eax, area

_mostraTri:

	pushl	area
	pushl	$mostraTri
	call	printf
	jmp	_fim

_mostraRet:

	pushl	area
	pushl	$mostraRet
	call	printf


_fim:

	addl	$56, %esp

	pushl	$0
	call	exit

/* Desafio: A partir do programa para cálculo das áreas de figuras geométricas, desenvolvido em aula, altere-o para acrescentar o cálculo da área de circunferência. Modifique o que for preciso para atender a este objetivo. Coloque também a opção de “sair” no menu principal, de forma que, se esta opção não for a escolhida, o programa executa novamente.

OBS: Entregue o código fonte na plataforma Moodle. Se o programa não funcionar, faça-o funcionar, pois não adianta entregar o código de uma execução errada. 
*/