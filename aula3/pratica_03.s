.section .data
    saida: .asciz "Soma: %d + %d + %d = %d\n"
    n1: .int 10
    n2: .int 25
    n3: .int 5
    v1: .int 10, 5, 5

.section .bss
    #reservando 4 bytes para o rótulo res
    .lcomm resultado, 4

.section .text
.globl _start

_start:
    # somando os valores e gardando na variável resultado
    movl n3, %eax
    addl n2, %eax
    addl n1, %eax
    movl %eax, resultado

    # empilhando os valores na pilha (stack) para exibir a msg na tela
    pushl resultado
    pushl n3
    pushl n2
    pushl n1
    pushl $saida

    # chamando o printf
    call printf
    # desempilhando os valores da pilha -> 5 valores = 5*4 (bytes) = 20
    addl $20, %esp

_soma_vetor:
    # somando os valores contidos no vetor v1 e armazenando em 'resultado'
    movl $v1, %edi
    movl (%edi), %eax
    addl $4, %edi
    addl (%edi), %eax
    add $4, %edi
    addl (%edi), %eax
    movl %eax, resultado

    # empilhando os valores na pilha (stack) para exibir a msg na tela
    pushl resultado
    pushl (%edi)   # imprimi o 3 valor do vetor
    pushl -4(%edi) # imprimi o 2 valor do vetor
    pushl -8(%edi) # imprimi o 1 valor do vetor
    pushl $saida

    # chamando printf
    call printf
    # desempilhando os valores da pilha
    addl $20, %esp

    # encerrado o programa
    pushl $0
    call exit
    





