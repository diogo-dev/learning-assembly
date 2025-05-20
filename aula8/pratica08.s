.section .data

    n1: .int 0
    n2: .int 0
    n3: .int 0
    opcao: .int 0

    abertura: .asciz "Ordena 3 números"

    pedeN1: .asciz "\nDigite o valor de n1 => "
    pedeN2: .asciz "\nDigite o valor de n2 => "
    pedeN3: .asciz "\nDigite o valor de n3 => "
    pergunta: .asciz "\nDigite\n<1> para Sair\n<2> para Continuar\n"
    
    resultado: .asciz "\nA ordenação dos 3 números ficou: %d %d %d\n"

    tipoDado: .asciz "%d"

.section .text

.globl main

main: 

    pushl $abertura
    call printf

    pushl $pedeN1
    call printf
    pushl $n1
    pushl $tipoDado
    call scanf

    pushl $pedeN2
    call printf
    pushl $n2
    pushl $tipoDado
    call scanf

    pushl $pedeN3
    call printf
    pushl $n3
    pushl $tipoDado
    call scanf
    
    # inicio das comparacoes
    movl n1, %eax
    cmpl n2, %eax
    # n2 > n1
    jl n2_n1
    # n1 > n2
    jmp n1_n2

n1_n2:
    movl n3, %ecx
    cmpl n1, %ecx
    # n1 > n3
    jl n1_n2_n3
    # n3 > n1 -> (n3, n1, n2)
    jmp _print4

n2_n1:
    #Comparando n2 e n3 
    
    movl n3, %eax
    cmpl n2, %eax
    # n2 > n3 
    jl n2_n1_n3 
    # n3 > n2 -> (n3,n2,n1)
    jmp _print1


n2_n1_n3:
    #Comparando n1 e n3, com n2 sendo o maior

    movl n3, %ecx
    cmpl n1, %ecx
    # n1 > n3 -> (n2, n1, n3)
    jl _print2
    # n3 > n1 -> (n2, n3, n1)
    jmp _print3

n1_n2_n3:
    #Compara n2 e n3, com n1 sendo o maior.

    movl n2, %ecx
    cmpl n3, %ecx
    # n3 > n2 -> (n1, n3, n2)
    jl _print5
    # n2 > n3 -> (n1, n2, n3)
    jmp _print6

_print1:
    # n3, n2, n1
    pushl n3
    pushl n2
    pushl n1
    pushl $resultado
    call printf
    jmp _exit

_print2:

    pushl n2
    pushl n1
    pushl n3
    pushl $resultado
    call printf
    jmp _exit

_print3:

    pushl n2
    pushl n3
    pushl n1
    pushl $resultado
    call printf
    jmp _exit
    
_print4:

    pushl n3
    pushl n1
    pushl n2
    pushl $resultado
    call printf
    jmp _exit

_print5:

    pushl n1
    pushl n3
    pushl n2
    pushl $resultado
    call printf
    jmp _exit

_print6:

    pushl n1
    pushl n2
    pushl n3
    pushl $resultado
    call printf
    jmp _exit

_exit:
    pushl $pergunta
    call printf
    pushl $opcao
    pushl $tipoDado
    call scanf
    movl opcao, %eax
    cmpl $2, %eax
    je main

    movl $1, %eax          
    xorl %ebx, %ebx         
    int $0x80 
