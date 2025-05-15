/* Desafio: A partir do programa para cálculo das áreas de figuras geométricas, desenvolvido em aula, altere-o para acrescentar o cálculo da área de circunferência. Modifique o que for preciso para atender a este objetivo. Coloque também a opção de “sair” no menu principal, de forma que, se esta opção não for a escolhida, o programa executa novamente.

OBS: Entregue o código fonte na plataforma Moodle. Se o programa não funcionar, faça-o funcionar, pois não adianta entregar o código de uma execução errada. 
*/

// Diogo Felipe Soares da Silva, RA 124771

.section .data

	base:		.int	0
	altura:		.int	0
    raio:       .int    0
    pi:         .int    3
	area:		.int	0
	opcao:		.int	0

	abertura:	.asciz	"\nCalculo de Areas de Figuras Geometricas\n\n"
	abertRet:	.asciz	"\nCalculo da Area do Retangulo\n"
	abertTri:	.asciz	"\nCalculo da Area do Triangulo\n"
    abertCir:   .asciz  "\nCalculo da Area da Circunferencia\n"

	menuOpcao:	.asciz	"\nMenu de Opcao:\n<1> Area do Retangulo\n<2> Area do Triangulo\n<3> Area da Circunferencia\n<4> Finalizar Programa"

    erroOpcao:  .asciz  "\nEntre com um valor valido!\n\n"
    fraseDeFim: .asciz  "\nFinalizando o programa...\n\n"

	pedeBase:	.asciz	"\nDigite o valor da base => "
	pedeAltura:	.asciz	"\nDigite o valor da altura => "
    pedeRaio:   .asciz  "\nDigite o valor do raio =>"
	pedeOpcao:	.asciz	"\nDigite a opcao => "

	mostraRet:	.asciz	"\nArea do Retangulo = %d\n\n"
	mostraTri:	.asciz	"\nArea do Triangulo = %d\n\n"
    mostraCir:  .asciz  "\nArea da Circunferencia = %d\n\n"

	tipoDado:	.asciz	"%d"

.section .text

.globl main

main:

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
    cmpl    $3, %eax
    je _calcCir
    cmpl    $4, %eax
    je _fim

    pushl $erroOpcao
    call printf
	addl	$24, %esp
	jmp	main


_calcRet:
	pushl	$abertRet
	call	printf
	jmp	_cont1

_calcTri:
	pushl	$abertTri
	call	printf
    jmp _cont1

_calcCir:
    pushl $abertCir
    call printf
    jmp _cont2


_cont1:
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

    addl     $28, %esp

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
    jmp	_fim

_cont2:
    pushl   $pedeRaio
    call    printf
    pushl   $raio
    pushl   $tipoDado
    call    scanf

    movl    raio, %eax
    mull    raio          # fazendo raio * raio
    mull    pi
    movl    %eax, area

_mostraCir:
    pushl   area
    pushl   $mostraCir
    call printf

_fim:
    pushl   $fraseDeFim
    call printf
	addl	$12, %esp

	pushl	$0
	call	exit

