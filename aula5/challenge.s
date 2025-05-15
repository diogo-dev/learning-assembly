# DESAFIO
#Leia um dado inteiro de 32 bits. Interprete esse dado como sendo 2 dados de 16 bits concatenados.
#Some essas duas metades e armazene como um dado de 32 bits. Mostre o resultado na tela. Multiplique esse
#resultado por uma potência de 2 (2 elevado a n), sendo n lido do usuário. Mostre o resultado. Use o
#registrador %cl para armazenar o n.

# Comandos para executar o código
# as --32 -gstabs challenge.s -o challenge.o
# gcc -m32 challenge.o -o challenge -lc

.section .data
    saida1: .asciz "Primeira metade (16 bits low): %d\n\n"
    saida2: .asciz "Segunda metado (16 bits high): %d\n\n" 
    saida3: .asciz "Soma: %d\n\n"
    valor_reg: .asciz "O valor contido no registrador eh (hexadecimal): %X\n"
    valor_reg2: .asciz "\nO valor contido no registrador eh (inteiro): %d\n"
    string_entrada: .asciz "\nEntre com o valor da potencia de 2 (n): "
    formato: .asciz "%d"
    # Esse valor representa o sequinte valor em hexadecimal: AAAABBBB
    # AAAA = 43690
    # BBBB = 48059
    num: .int 2863315899
    n: .int 0

.section .text
.globl main

main:
    movl num, %ebx
    pushl %ebx
    pushl $valor_reg
    call printf
    addl $8, %esp

    # somando as metades do registrador
part1:
    xorl %eax, %eax       # Setando %eax para 0
    addw %bx, %ax
    movl %eax, num       # backup do eax
    pushl %eax
    pushl $saida1
    call printf

deslocamento:
    shrl $16, %ebx
    pushl %ebx
    pushl $saida2
    call printf

    movl num, %eax     # restaurando o valor de eax
    addl %ebx, %eax
    movl %eax, num      # colocando o valor calculado em num
    pushl num
    pushl $saida3
    call printf

    movl num, %eax
    pushl num          # monstrando resultado na tela
    pushl $valor_reg
    call printf

    addl $32, %esp

    # pegando o valor de n do usuario
    pushl $string_entrada
    call printf
    pushl $n
    pushl $formato
    call scanf
    addl $12, %esp
    # passando o valor de n para %cl
    movl n, %eax
    movb %al, %cl

    xorb %dl, %dl    # Iniciando o valor do meu contador com 0
    movl $1, %eax    # eax = 2^n
    subb $1, %cl     # diminui o valor de %cl para o loop dar a qnt de voltar corretas
    
start_loop:
    shll $1, %eax   # faz shift left do registrador %eax n vezes = 2^n
    cmpb %cl, %dl
    je end_loop

    incb %dl
    jmp start_loop

end_loop:
    imul num, %eax  # multiplica os valores de num e 2^n
    pushl %eax      # mostra o resultado para o usuario
    pushl $valor_reg2
    call printf 
    addl $8, %esp

    # Finalizando o programa
    pushl $0
    call exit   

 