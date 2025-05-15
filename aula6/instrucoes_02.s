.section .data

    saida: .asciz "Teste %d: Resultado = Hex: %X Dec: %d\n\n"
    saida2: .asciz "Teste %d: Quoc > Hex: %X Dec: %d e Resto > Hex: %X Dec: %d\n\n"
    saida3: .asciz "Teste %d: Resultado = Hex: %X:%X\n\n"

.section .text
.globl main

main:
    # TESTES DE ADICAO
teste1:
    movl $0x12340000, %eax  # 305.397.760 em decimal
    movl $0x00005678, %ebx  #      22.136 em decimal
    addl %ebx, %eax         # %eax ← %eax + %ebx
    pushl %eax
    pushl %eax
    pushl $1
    pushl $saida
    call printf
    addl $16, %esp

teste2:
    movl $0xCFFF1234, %eax  # -805.367.244 em decimal
    movl $0xDFFF5678, %ebx  # -536.914.312 em decimal
    addl %ebx, %eax         # %eax ← %eax + %ebx
    pushl %eax
    pushl %eax
    pushl $2
    pushl $saida
    call printf
    addl $16, %esp

teste3:
    movl $0x11001234, %eax  # 285.217.332 em decimal
    movl $0x00114321, %ebx  #   1.131.297 em decimal
    addw %bx, %ax           # %ax <- %ax + %bx
    pushl %eax
    pushl %eax
    pushl $3
    pushl $saida
    call printf
    addl $16, %esp

teste4:
    movl $0xFFFFF456, %eax  # -2986 em decimal
    movl $0xFFFFFCBB, %ebx  #  -837 em decimal
    addw %bx, %ax           # %ax <- %ax + %bx : -3.823
    pushl %eax
    pushl %eax
    pushl $4
    pushl $saida
    call printf
    addl $16, %esp

teste5:
    movl $0x11005534, %eax  # 285.234.484 em decimal
    movl $0x0011AA21, %ebx  #   1.157.665 em decimal
    addb %bl, %al           # %al <- %al + %bl
    pushl %eax
    pushl %eax
    pushl $5
    pushl $saida
    call printf
    addl $16, %esp

teste6:
    movl $0xFFFFFF56, %eax  # -170 em decimal
    movl $0xFFFFFFBB, %ebx  #  -69 em decimal
    addb %bl, %al           # %al <- %al + %bl
    pushl %eax
    pushl %eax
    pushl $6
    pushl $saida
    call printf
    addl $16, %esp

teste7:
    movl $0x11005534, %eax  # 285.234.484 em decimal
    movl $0x0011AA21, %ebx  #   1.157.665 em decimal
    addb %bh, %ah           # %ah <- %ah + %bh
    pushl %eax
    pushl %eax
    pushl $7
    pushl $saida
    call printf
    addl $16, %esp

teste8:
    movl $0xFFFFFF56, %eax  # -170 em decimal
    movl $0xFFFFFFBB, %ebx  #  -69 em decimal
    addb %bh, %ah           # %ah <- %ah + %bh
    pushl %eax
    pushl %eax
    pushl $8
    pushl $saida
    call printf
    addl $16, %esp

    # TESTES DE SUBTRACAO
teste9:
    movl $0x12345678, %eax  # 305.419.896
    movl $0x02040608, %ebx  #  33.818.120
    subl %ebx, %eax         # %eax ← %eax - %ebx
    pushl %eax
    pushl %eax
    pushl $9
    pushl $saida
    call printf
    addl $16, %esp

teste10:
    movl $-1412627919, %eax
    movl $-2627000, %ebx
    subl %ebx, %eax         # %eax <- %eax - %ebx
    pushl %eax
    pushl %eax
    pushl $10
    pushl $saida
    call printf
    addl $16, %esp

teste11:
    movl $0x12345678, %eax  # 305.419.896
    movl $0x02040608, %ebx  #  33.818.120
    subw %bx, %ax           # %ax ← %ax - %bx
    pushl %eax
    pushl $11
    pushl $saida
    call printf
    addl $16, %esp

teste12:
    movl $-0x1234ABFF, %eax # -305.441.791 (dec) ou EDCB5401 (cp2)
    movl $-0xABFF, %ebx     #      -44.031 (dec) ou FFFF5401 (cp2)
    subw %bx, %ax           # %ax <- %ax - %bx
    pushl %eax
    pushl %eax
    pushl $12
    pushl $saida
    call printf
    addl $16, %esp

teste13:
    movl $0x12345678, %eax  # 305.419.896
    movl $0x02040608, %ebx  # 33.818.120
    subb %bl, %al           # %al ← %al - %bl
    pushl %eax
    pushl %eax
    pushl $13
    pushl $saida
    call printf
    addl $16, %esp

teste14:
    movl $-0x1234ABFF, %eax # -305.441.791 (dec) ou EDCB5401 (cp2)
    movl $-0xABFF, %ebx     #      -44.031 (dec) ou FFFF5401 (cp2)
    subb %bl, %al           # %al ← %al - %bl
    pushl %eax
    pushl %eax
    pushl $14
    pushl $saida
    call printf
    addl $16, %esp

teste15:
    movl $0x12345678, %eax  # 305.419.896
    movl $0x02040608, %ebx  #  33.818.120
    subb %bh, %ah           # %ah ← %ah - %bh
    pushl %eax
    pushl %eax
    pushl $15
    pushl $saida
    call printf
    addl $16, %esp

teste16:
    movl $-0x1234ABFF, %eax # -305.441.791 (dec) ou EDCB5401 (cp2)
    movl $-0xABFF, %ebx     #      -44.031 (dec) ou FFFF5401 (cp2)
    subb %bh, %ah           # %ah ← %ah - %bh
    pushl %eax
    pushl %eax
    pushl $16
    pushl $saida
    call printf
    addl $16, %esp

    # Incremento
teste17:
    movl $0xA4, %eax
    incl %eax               # %eax ← %eax + 1
    incw %ax                # %ax ← %ax + 1
    incb %al                # %al ← %al + 1
    pushl %eax
    pushl %eax
    pushl $17
    pushl $saida
    call printf
    addl $16, %esp

    # Decremento
teste18:
    movl $0xA4, %eax
    decl %eax               # %eax ← %eax - 1
    decw %ax                # %ax ← %ax - 1
    decb %al                # %al ← %al - 1
    pushl %eax
    pushl %eax
    pushl $18
    pushl $saida
    call printf
    addl $16, %esp

    # TESTES DE DIVISAO -> SEMPRE O QUOCIENTE FICA EM %eax E O RESTO EM %edx
    # Lembrando que quando a divisao envolve um valor negativo (podendo ser divisor ou dividendo)
    # Usamos a instrucao idiv(l,w,b), caso contrario, usamos div(l,w,b)

    # Dividindo 64 por 32 bit, ambos positivos. Gerando dado de 32 bits
teste19:
    movl $0x0000A4C8, %edx
    movl $0x00001234, %eax
    movl $0xA4C80, %ebx
    divl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $19
    pushl $saida2
    call printf
    add $24, %esp

    # Dividindo 64 por 32 bits, sendo dividendo positivo e divisor negativo.
teste20:
    movl $0x0000A4C8, %edx
    movl $0x00001234, %eax
    movl $-0xA4C80, %ebx
    idivl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $20
    pushl $saida2
    call printf
    add $24, %esp

    # Dividindo 64 por 32 bits, sendo dividendo negativo e divisor positivo.
teste21:
    movl $-0x0000A4C8, %edx
    subl $1, %edx           # anulamos o cp2 e apenas mantemos o cp1
    movl $-0x00001234, %eax
    movl $0xA4C80, %ebx
    idivl %ebx              # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $21
    pushl $saida2
    call printf
    add $24, %esp

    # Dividindo 32 por 32, ambos positivos. E gerando um dado de 32
teste22:
    movl $0, %edx           # Zerando o valor de %edx, visto que o dado eh de 32bits
    movl $0x24682467, %eax
    movl $2, %ebx
    divl %ebx               # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $22
    pushl $saida2
    call printf
    add $24, %esp

    # Dividindo 32 por 32, sendo dividendo positivo e divisor negativo.
teste23:
    movl $0, %edx
    movl $0x24682467, %eax
    movl $-2, %ebx
    idivl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $23
    pushl $saida2
    call printf
    add $24, %esp

    pushl $0
    call exit
