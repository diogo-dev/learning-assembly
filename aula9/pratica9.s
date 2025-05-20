/* Desafio: A partir do programa que ordena 3 número, altere-o para ordenar 4 
números usando a mesma metodologia. Modifique o que for preciso para atender 
a este objetivo.
*/

.section .data

	n1:		.int	0
	n2:		.int	0
	n3:		.int	0
	n4:		.int 	0

	tipoN:		.asciz	"%d"

	resp:		.int	0

	tipoC:		.asciz	" %c"

	abertura:	.asciz	"\nPrograma Ordena 4 Numeros\n\n"

	pedeN:		.asciz	"\nDigite o numero %d = > "

	mostraN:	.asciz	"\nNumeros ordenados: %d, %d, %d, %d\n\n"

	perg:		.asciz	"\nDeseja reexecutar <s>/<n>? => "


.section .text

	
.globl main

main:

	pushl	$abertura
	call	printf
	addl    $4, %esp

	pushl	$1
	pushl	$pedeN
	call	printf
	addl    $8, %esp

	pushl	$n1
	pushl	$tipoN
	call	scanf
	addl    $8, %esp

	pushl	$2
	pushl	$pedeN
	call	printf
	addl    $8, %esp

	pushl	$n2
	pushl	$tipoN
	call	scanf
	addl    $8, %esp

	pushl	$3
	pushl	$pedeN
	call	printf
	addl    $8, %esp

	pushl	$n3
	pushl	$tipoN
	call	scanf
	addl    $8, %esp

	pushl	$4
	pushl	$pedeN
	call	printf
	addl    $8, %esp

	pushl	$n4
	pushl	$tipoN
	call	scanf
	addl    $8, %esp

	# inicio das comparacoes
	movl	n1, %eax
	cmpl	n2, %eax
	jg	_n1_n2

_n2_n1:	

	movl	n1, %eax
	cmpl	n3, %eax
	jg	_n2_n1_n3

	movl	n3, %eax
	cmpl	n2, %eax
	jg	_n3_n2_n1

	jmp _n2_n3_n1


_n3_n2_n1:

	movl 	n1, %eax
	cmpl	n4, %eax
	jg		_n3_n2_n1_n4
	
	movl	n2, %eax
	cmpl 	n4, %eax
	jg		_n3_n2_n4_n1

	movl	n3, %eax
	cmpl 	n4, %eax
	jg		_n3_n4_n2_n1

	jmp 	_n4_n3_n2_n1

_n1_n2:

	movl	n2, %eax
	cmpl	n3, %eax
	jg	_n1_n2_n3

	movl	n3, %eax
	cmpl	n1, %eax
	jg	_n3_n1_n2

	jmp _n1_n3_n2

_n3_n1_n2:

	movl 	n2, %eax
	cmpl	n4, %eax
	jg		_n3_n1_n2_n4
	
	movl	n1, %eax
	cmpl 	n4, %eax
	jg		_n3_n1_n4_n2

	movl	n3, %eax
	cmpl 	n4, %eax
	jg		_n3_n4_n1_n2

	jmp 	_n4_n3_n1_n2


_n2_n1_n3:

	movl 	n3, %eax
	cmpl	n4, %eax
	jg		_n2_n1_n3_n4
	
	movl	n1, %eax
	cmpl 	n4, %eax
	jg		_n2_n1_n4_n3

	movl	n2, %eax
	cmpl 	n4, %eax
	jg		_n2_n4_n1_n3

	jmp 	_n4_n2_n1_n3

_n2_n3_n1:

	movl 	n1, %eax
	cmpl	n4, %eax
	jg		_n2_n3_n1_n4
	
	movl	n3, %eax
	cmpl 	n4, %eax
	jg		_n2_n3_n4_n1

	movl	n2, %eax
	cmpl 	n4, %eax
	jg		_n2_n4_n3_n1

	jmp 	_n4_n2_n3_n1

_n1_n2_n3:

	movl 	n3, %eax
	cmpl	n4, %eax
	jg		_n1_n2_n3_n4
	
	movl	n2, %eax
	cmpl 	n4, %eax
	jg		_n1_n2_n4_n3

	movl	n1, %eax
	cmpl 	n4, %eax
	jg		_n1_n4_n2_n3

	jmp 	_n4_n1_n2_n3

_n1_n3_n2:

	movl 	n2, %eax
	cmpl	n4, %eax
	jg		_n1_n3_n2_n4
	
	movl	n3, %eax
	cmpl 	n4, %eax
	jg		_n1_n3_n4_n2

	movl	n1, %eax
	cmpl 	n4, %eax
	jg		_n1_n4_n3_n2

	jmp 	_n4_n1_n3_n2

_n1_n2_n3_n4:
    pushl   n1
    pushl   n2
    pushl   n3
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n1_n2_n4_n3:
    pushl   n1
    pushl   n2
    pushl   n4
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim
	
_n1_n3_n2_n4:
    pushl   n1
    pushl   n3
    pushl   n2
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n1_n3_n4_n2:
    pushl   n1
    pushl   n3
    pushl   n4
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n1_n4_n2_n3:
    pushl   n1
    pushl   n4
    pushl   n2
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n1_n4_n3_n2:
    pushl   n1
    pushl   n4
    pushl   n3
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n1_n3_n4:
    pushl   n2
    pushl   n1
    pushl   n3
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n1_n4_n3:
    pushl   n2
    pushl   n1
    pushl   n4
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n3_n1_n4:
    pushl   n2
    pushl   n3
    pushl   n1
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n3_n4_n1:
    pushl   n2
    pushl   n3
    pushl   n4
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n4_n1_n3:
    pushl   n2
    pushl   n4
    pushl   n1
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n2_n4_n3_n1:
    pushl   n2
    pushl   n4
    pushl   n3
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n1_n2_n4:
    pushl   n3
    pushl   n1
    pushl   n2
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n1_n4_n2:
    pushl   n3
    pushl   n1
    pushl   n4
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n2_n1_n4:
    pushl   n3
    pushl   n2
    pushl   n1
    pushl   n4
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n2_n4_n1:
    pushl   n3
    pushl   n2
    pushl   n4
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n4_n1_n2:
    pushl   n3
    pushl   n4
    pushl   n1
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n3_n4_n2_n1:
    pushl   n3
    pushl   n4
    pushl   n2
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n1_n2_n3:
    pushl   n4
    pushl   n1
    pushl   n2
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n1_n3_n2:
    pushl   n4
    pushl   n1
    pushl   n3
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n2_n1_n3:
    pushl   n4
    pushl   n2
    pushl   n1
    pushl   n3
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n2_n3_n1:
    pushl   n4
    pushl   n2
    pushl   n3
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n3_n1_n2:
    pushl   n4
    pushl   n3
    pushl   n1
    pushl   n2
    pushl   $mostraN
    call    printf
	jmp 	_fim

_n4_n3_n2_n1:
    pushl   n4
    pushl   n3
    pushl   n2
    pushl   n1
    pushl   $mostraN
    call    printf
	jmp 	_fim

_fim:

	pushl	$perg
	call	printf

	pushl	$resp
	pushl	$tipoC
	call	scanf

	addl	$32, %esp

	movl	resp, %eax
	cmpl	$'s', %eax
	je	main
	
	pushl	$0
	call	exit



