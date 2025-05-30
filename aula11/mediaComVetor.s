# mostrar a media da turma
# mostrar numero de aprovados
# mostrar o numero de reprovados
# mostrar a maior nota
# mostrar a menor nota

# lembrando que as notas variam de 0 até 10
# vamos inicializar a maior nota com 0 e a menor com 10 para realizar as devidas comparações

# Diogo Felipe Soares da Silva, RA:124771

# rode o código com os seguintes comandos:
# as -32 -g mediaComVetor.s -o mediaComVetor.o
# gcc -m32 -gstabs mediaComVetor.o -o mediaComVetor
# ./mediaComVetor

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
    n_aprovados:    .asciz  "\nO numero de aprovados foi: %d\n"
    n_reprovados:   .asciz  "\nO numero de reprovados foi: %d\n"
    valor_gerado:   .asciz  "\nValor Gerado: %d"
    pulalinha:      .asciz  "\n\n\n"

    erro_msg:      .asciz "Erro: Falha na alocacao de memoria!\n"
    tempo_erro_msg:.asciz "Erro: Falha ao obter tempo!\n"

    tipoNumero:     .asciz  "%d"

.section .bss
    # Variável para armazenar o ponteiro do vetor
    .lcomm vetor_ptr, 4
    # O vetor poderia ser definido também por meio da diretiva:
    # .lcomm vetor, 40 (sendo 10 alunos. Ou seja, 4*10 = 40)

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

    # plantando a semente na funcao srand
    pushl $0              
    call time               # O valor retornado esta em eax
    addl $4, %esp           

    cmpl $0, %eax          
    je   _tempo_falhou      

    pushl %eax              
    call srand              
    addl $4, %esp         

    # criando o tamanho do espaço que sera alocado no malloc: 4*qnt_alunos bytes
    movl    qnt_alunos, %eax
    movl    $4, %ebx
    mull    %ebx
    # chamando o malloc, com o argumento sizeof(int*qnt_alunos)
    pushl   %eax
    call    malloc
    addl    $4, %esp
    # Verificar o retorno do malloc
    cmpl    $0, %eax
    je      _alocacao_falhou
    # senão falhou, basta mover o endereço de %eax para vetor_ptr e o vetor está pronto para ser usado
    movl    %eax, vetor_ptr

    movl    vetor_ptr, %edi
    movl    $0, %ecx            # contador do loop

_preencher_vetor:
    cmpl    qnt_alunos, %ecx
    jge      _fim_preencher_vetor

    # gerando o valor aleatorio que sera armazenado em %eax
    call rand

    # colocar aqui o limite para a geracao dos numero aleatorios
    # (rand() % 10) + 1     (notas de 1 ate 10)
    # lembrando que o resto de uma divisao fica em %edx
    movl    $0, %edx
    movl    $10, %ebx
    divl    %ebx
    incl    %edx

    movl    %edx, nota_atual
    pushl   nota_atual
    pushl   $valor_gerado
    call    printf
    addl    $8, %esp

    # restaurar o valor de %edx modificado pelo printf()
    movl    nota_atual, %edx

    # usando uma variável para contador, pois rand() modifica o valor de ecx
    movl    contador, %ecx

    # colocar o valor no vetor
    movl    %edx, (%edi, %ecx, 4) # Move EAX para (EDI + ECX * 4) => vet[ecx] = edx

    # incrementa 'contador' que nesse caso eh o ecx
    incl    contador
    movl    contador, %ecx
    jmp     _preencher_vetor

_fim_preencher_vetor:
    movl    $0, contador
    movl    contador, %ecx

    movl    vetor_ptr, %edi

    pushl   $pulalinha
    call    printf
    addl    $4, %esp

_mostra_elementos_vetor:
    cmpl    qnt_alunos, %ecx
    jge     _fim_mostrar_elementos
    
    #printando o valor gerado (lembrar que printf modifica o valor dos registradores)
    movl    (%edi, %ecx, 4), %eax
    movl    %eax, nota_atual
    pushl   nota_atual
    pushl   $valor_gerado
    call    printf
    addl    $8, %esp

    incl    contador
    movl    contador, %ecx
    jmp     _mostra_elementos_vetor

_fim_mostrar_elementos:
    movl    $0, contador
    movl    contador, %ecx
    movl    vetor_ptr, %edi

_identificar_maior_menor:
    cmpl    qnt_alunos, %ecx
    jge     _fim_maior_menor
    movl    (%edi, %ecx, 4), %eax

    cmpl    n_maior, %eax
    jg      _encontrou_maior
    cmpl    n_menor, %eax
    jl      _encontrou_menor

_volta1:
    incl    contador
    movl    contador, %ecx
    jmp     _identificar_maior_menor

_encontrou_maior:
    movl    %eax, n_maior
    jmp     _volta1
_encontrou_menor:
    movl    %eax, n_menor
    jmp     _volta1

_fim_maior_menor:
    pushl   $pulalinha
    call    printf
    addl    $4, %esp

    pushl   n_maior
    pushl   $maior_nota
    call    printf
    addl    $8, %esp

    pushl   n_menor
    pushl   $menor_nota
    call    printf
    addl    $8, %esp

    movl    $0, contador
    movl    contador, %ecx
    movl    vetor_ptr, %edi

_identificar_aprovados_reprovados:
    cmpl    qnt_alunos, %ecx
    jge     _fim_aprovados_reprovados

    movl    (%edi, %ecx, 4), %eax
    
    cmpl    $6, %eax
    jge     _encontrou_aprovado
    # _encontrou_reprovado
    incl    reprovados

_volta2:
    incl    contador
    movl    contador, %ecx
    jmp     _identificar_aprovados_reprovados

_encontrou_aprovado:
    incl    aprovados
    jmp     _volta2

_fim_aprovados_reprovados:
    pushl   $pulalinha
    call    printf
    addl    $4, %esp

    pushl   aprovados
    pushl   $n_aprovados
    call    printf
    addl    $8, %esp

    pushl   reprovados
    pushl   $n_reprovados
    call    printf
    addl    $8, %esp

    movl    $0, contador
    movl    contador, %ecx
    movl    vetor_ptr, %edi


_calcula_media:
    cmpl    qnt_alunos, %ecx
    jge     _fim_calcula_media

    movl    (%edi, %ecx, 4), %eax
    addl    soma, %eax
    movl    %eax, soma
    
    incl    contador
    movl    contador, %ecx
    jmp     _calcula_media
    
_fim_calcula_media:
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
    jmp     _exit
    
_alocacao_falhou:
    pushl   $erro_msg
    call    printf
    addl    $4, %esp
    jmp     _exit

_tempo_falhou:
    pushl   $erro_msg
    call    printf
    addl    $4, %esp
    jmp     _exit

_exit:
    pushl	$0
	call	exit
