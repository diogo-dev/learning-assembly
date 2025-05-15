# compilar: as -32 praticab_03.s -o praticab_03.o
# linkagem: ld -m elf_i386 praticab_03.o -l c -dynamic-linker /lib/ld-linux.so.2 -o praticab_03

.section .data
    abertura: .asciz "\nPrograma para Somar 3 Numeros\n"
    saida: .asciz "Soma: %d + %d - %d + %d - %d = %d\n"
    peden1: .asciz "\nEntre com o valor de n1 = "
    peden2: .asciz "\nEntre com o valor de n2 = "
    peden3: .asciz "\nEntre com o valor de n3 = "
    peden4: .asciz "\nEntre com o valor de n4 = "
    peden5: .asciz "\nEntre com o valor de n5 = "
    formato: .asciz "%d" # usado pelo scanf para saber o tipo do dado
    # a ser lido

    n1: .int 0
    n2: .int 0
    n3: .int 0
    n4: .int 0
    n5: .int 0
    res: .int 0

.section .text
.globl _start

_start:
    pushl $abertura
    call printf

    # Entrada de n1
    pushl $peden1   # empilhando endereço de mensagem
    call printf     # exibindo a msg na tela
    pushl $n1       # empilha o endereço da variável a ser lida 
    pushl $formato  # empilha o formato do dado a ser lido
    call scanf      # chama scanf para fazer a leitura na variável

    # Entrada de n2
    pushl $peden2
    call printf
    pushl $n2
    pushl $formato
    call scanf

    # Entrada de n3
    pushl $peden3
    call printf
    pushl $n3
    pushl $formato
    call scanf

    # Entrada de n4
    pushl $peden4
    call printf
    pushl $n4
    pushl $formato
    call scanf

    # Entrada de n5
    pushl $peden5
    call printf
    pushl $n5
    pushl $formato
    call scanf

_calculando_dados:
    # fazendo o cálculo: n1 + n2 - n3 + n4 - n5
    movl n1, %eax
    addl n2, %eax
    subl n3, %eax
    addl n4, %eax
    subl n5, %eax
    movl %eax, res

_imprime_resultado:
    pushl res
    pushl n5
    pushl n4
    pushl n3
    pushl n2
    pushl n1
    pushl $saida
    call printf
    addl $92, %esp   # 23 * 4 = 92

    pushl $0
    call exit
