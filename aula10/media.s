# mostrar a media da turma
# mostrar numero de aprovados
# mostrar o numero de reprovados
# mostrar a maior nota
# mostrar a menor nota

# lembrando que as notas variam de 0 até 10
# vamos inicializar a maior nota com 0 e a menor com 10 para realizar as devidas comparações


# Diogo Felipe Soares da Silva, RA:124771

.section .data

    qnt_alunos:     .int    0
    contador:       .int    0
    nota_atual:     .int    0
    soma:           .int    0
    media:          .int    0
    aprovados:      .int    0
    reprovados:     .int    0
    n_maior:        .int    0
    n_menor:        .int    10

    string_entrada: .asciz  "\nDigite o numero de alunos da sala: "
    nota_entrada:   .asciz  "\nDigite a nota (%d): "
    media_total:    .asciz  "\nA media de notas da turma foi de: %d\n"
    maior_nota:     .asciz  "\nA maior nota foi de: %d\n"
    menor_nota:     .asciz  "\nA menor nota foi de: %d\n"
    n_aprovados:    .asciz  "\n O numero de aprovados foi: %d\n"
    n_reprovados:   .asciz  "\n O numero de reprovados foi: %d\n"

    tipoNumero:     .asciz  "%d"



.section .text
.globl main

main:
    pushl   $string_entrada
    call    printf
    addl    $4, %esp

    pushl   $qnt_alunos
    pushl   $tipoNumero
    call    scanf
    addl    $8, %esp

_receber_notas:
    movl    contador, %eax
    cmpl    qnt_alunos, %eax
    je      _calcula_media

    # lendo a nota atual
    movl    contador, %eax
    incl    %eax
    pushl   %eax
    pushl   $nota_entrada
    call    printf
    addl    $8, %esp
    pushl   $nota_atual
    pushl   $tipoNumero
    call    scanf
    addl    $8, %esp

    # acumulando o valor da soma das notas (soma <- soma + nota_atual)
    movl    nota_atual, %eax
    addl    soma, %eax
    movl    %eax, soma

    # fazendo as comparacoes
    # reprovados
    movl    nota_atual, %eax
    cmpl    $6, %eax
    jl      _reprovado_encontrado
    # aprovados
    jge     _aprovado_encontrado
_aprovado:
    # maior
    movl    nota_atual, %eax
    cmpl    n_maior, %eax
    jg      _maior_encontrado
_maior:
    cmpl    n_menor, %eax
    jl      _menor_encontrado
_menor:
    # incrementa 'contador', decrementa 'qnt_alunos'
    movl    contador, %eax
    incl    %eax
    movl    %eax, contador

    jmp     _receber_notas


_reprovado_encontrado:
    movl    reprovados, %eax
    incl    %eax
    movl    %eax, reprovados
    jmp _aprovado

_aprovado_encontrado:
    movl    aprovados, %eax
    incl    %eax
    movl    %eax, aprovados
    jmp _aprovado

_maior_encontrado:
    movl    %eax, n_maior
    jmp     _maior

_menor_encontrado:
    movl    %eax, n_menor
    jmp     _menor


_calcula_media:
    movl    $0, %edx
    movl    soma, %eax
    movl    qnt_alunos, %ebx
    divl    %ebx
    movl    %eax, media

    # mostrar media na tela
    pushl   media
    pushl   $media_total
    call    printf
    addl    $8, %esp

    pushl   n_maior
    pushl   $maior_nota
    call    printf
    addl    $8, %esp

    pushl   n_menor
    pushl   $menor_nota
    call    printf
    addl    $8, %esp

    pushl   aprovados
    pushl   $n_aprovados
    call    printf
    addl    $8, %esp

    pushl   reprovados
    pushl   $n_reprovados
    call    printf
    addl    $8, %esp

_exit:
    pushl	$0
	call	exit
