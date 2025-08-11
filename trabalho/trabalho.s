/*
Implementation of the second part of the Assembly final project

Commands to compile and execute the code:
$ as -32 -g trabalho.s -o trabalho.o
$ gcc -m32 trabalho.o -g
$ ./a.out

Suggestions of improviment that I'm not gonna implement, but you can :)
At reading the file
- If the file to read doesn't exist, just jump back to the main menu
- If it does exist, however there's nothing (no data) in it, you should avoid reading the file and just jump back to the main menu
At writing to the file
- If the linked list is empty (no products), do not write!


*/



.section .data
# --- necessary variables ---
    main_menu:           .string "\n\n========================================\n=== CONTROLE DE ESTOQUE ===\n========================================\n1. Inserir Novo Produto\n2. Remover Produto\n3. Atualizar Produto\n4. Consultar Produto\n5. Consulta Financeira\n6. Gerar Relatório\n7. Gravar Registros em Arquivo\n8. Carregar Registros do Arquivo\n0. Sair do Programa\n----------------------------------------\nEscolha uma opção: "
    product_data_fmt:    .asciz "\n-----Produto Info-----\n\nNome do produto: %s\nLote: %d\nTipo: %s\nData de validade: %d/%d/%d\nFornecedor: %s\nQuantidade em estoque: %d\nPreço de compra: %.2f\nPreço de venda: %.2f\n\n"
    product_data_fmt_update:    .asciz "\n-----Produto Info-----\n\nNome do produto: %s\nQuantidade em estoque: %d\nPreço de venda: %.2f\n\n"
    print_all_nodes_fmt: .asciz "%s -> "
    financial_data_fmt:  .asciz "\n-----Financeiro Info-----\nTotal %s: %.2f\n"
    remove_product_menu: .asciz "\n-----Remover Produto-----\n1) Remover por nome de produto\n2) Remover todos os produtos fora da validade\n"
    financial_menu:      .asciz "\n-----Menu Financeiro-----\n1) Ver total comprado\n2) Ver total vendido\n3) Ver lucro total esperado\n"
    report_menu:         .asciz "\nDeseja ver o relatório ordenado por:\n1) Nome\n2) Data de validade\n3) Quantidade em estoque\n"
    format_write_string: .asciz "Nome: %s, Lote: %d, Tipo: %s, Validade: %d/%d/%d, Fornecedor: %s, Quantidade: %d, Valor Compra: %.2f, Valor Venda: %.2f\n"
    format_read_string:  .asciz "Nome: %[^,], Lote: %d, Tipo: %[^,], Validade: %d/%d/%d, Fornecedor: %[^,], Quantidade: %d, Valor Compra: %f, Valor Venda: %f\n"

    # product type array
    produtos_supermercado: .asciz "\n-----TIPOS DE PRODUDOS-----\n1) Carnes\n2) Laticínios\n3) Hortifrúti\n4) Bebidas\n5) Padaria\n6) Congelados\n7) Limpeza\n8) Higiene Pessoal\n9) Mercearia\n10) Pet Shop\n11) Perfumaria\n12) Eletrônicos\n13) Brinquedos\n14) Utilidades Domésticas\n15) Vestuário\n\n"
    items:               .int carne, laticinios, hortifruti, bebidas, padaria, congelados, limpeza, higiene, mercearia, petshop, perfumaria, eletronicos, brinquedos, utilidades, vestuario
    carne:               .asciz "Carnes"
    laticinios:          .asciz "Laticínios"
    hortifruti:          .asciz "Hortifrúti"
    bebidas:             .asciz "Bebidas"
    padaria:             .asciz "Padaria"
    congelados:          .asciz "Congelados"
    limpeza:             .asciz "Limpeza"
    higiene:             .asciz "Higiene Pessoal"
    mercearia:           .asciz "Mercearia"
    petshop:             .asciz "Pet Shop"
    perfumaria:          .asciz "Perfumaria"
    eletronicos:         .asciz "Eletrônicos"
    brinquedos:          .asciz "Brinquedos"
    utilidades:          .asciz "Utilidades Domésticas"
    vestuario:           .asciz "Vestuário"

    filename:            .asciz "estoque.txt"
    fileflags:           .int 577 # O_WRONLY (4) | O_CREAT (512) | O_TRUNC (1) = 577 (em binário)
    filemode:            .int 0644  # value in octal notation => 6 (read + write) = 4 + 2; 4 (read); 4 (read); equivalent permission -rw-r--r--

    option:              .int -1
    # name and supplier are in the .bss section
    lot:                 .int 0
    type_number:         .int 0
    expiry_day:          .int 0
    expiry_month:        .int 0
    expiry_year:         .int 0
    stock_quantity:      .int 0
    purchase_price:      .float 0.0
    sale_price:          .float 0.0
    counter:             .int 0
    total_purchase:      .float 0.0
    total_sale:          .float 0.0
    total_profit:        .float 0.0
    buffer_index:        .int 0
    current_day:         .int 0
    current_month:       .int 0
    current_year:        .int 0


    msg_product_name:        .string "\nDigite o nome do produto: "
    msg_product_lot:         .string "Digite o lote do produto: "
    msg_product_type:        .string "Digite o tipo do produto (1-15): "
    msg_product_expiry_date: .string "Digite a data de validade abaixo\n"
    msg_product_day:         .string "Dia: "
    msg_product_month:       .string "Mês: "
    msg_product_year:        .string "Ano: "
    msg_product_supplier:    .string "Digite o nome do fornecedor: "
    msg_stock_quantity:      .string "Digite a quantidade em estoque: "
    msg_purchase_price:      .string "Digite o valor de compra (em reais): "
    msg_sale_price:          .string "Digite o valor de venda (em reais): "
    msg_user_option:         .string "\nDigite sua opção: "

    msg_new_stock_quantity:  .string "Digite a nova quantidade em estoque: "
    msg_new_sale_price:      .string "Digite o novo valor de venda (em reais): "

    msg_success_insert:  .string "\n[SUCESSO] Produto inserido na lista.\n"
    msg_success_remove:  .string "\n[SUCESSO] Produto removido da lista.\n"
    msg_success_update:  .string "\n[SUCESSO] Produto atualizado.\n"
    msg_success_save:    .string "\n[SUCESSO] Dados salvos em 'estoque.txt'.\n"
    msg_success_load:    .string "\n[SUCESSO] Dados carregados de 'estoque.txt'.\n"
    msg_success_report:  .string "\n[SUCESSO] Relatório gerado.\n"

    msg_list:                 .string "\n----LISTA ORDENADA----\n"
    msg_registration_report:  .string "\n-----RELATÓRIO DE REGISTROS-----\n"
    msg_crud_name:            .string "\nDigite o nome do produto a ser %s: "
    msg_zeros_nodes_present:  .string "\nLista vazia\n"
    msg_total_removed_nodes:  .string "\nFoi excluído %d produto(s) vencido(s) no estoque\n"

    msg_option_total_purchase: .string "comprado (em reais)"
    msg_option_total_sale:     .string "vendido (em reais)"
    msg_option_total_profit:   .string "de lucro esperado obtido (em reais)"

    msg_remove:          .string "removido"
    msg_update:          .string "atualizado"
    msg_consult_product: .string "consultado"

    msg_error_not_found: .string "\n[ERRO] Produto não encontrado.\n"
    msg_error_memory:    .string "\n[ERRO] Falha ao alocar memória.\n"
    msg_error_file_open: .string "\n[ERRO] Não foi possível abrir o arquivo.\n"
    msg_error_file_read: .string "\n[ERRO] Falha ao ler dados do arquivo.\n"
    msg_error_invalid_option: .string "\n[ERRO] Opção inválida. Tente novamente.\n"

    # --- format string required by printf and scanf functions ---
    fmt_string:         .string "%s"
    fmt_float:          .string "%f"
    fmt_decimal1:       .string "%d" 
    fmt_decimal2:       .string " %d"
    fmt_newline:        .string "\n"


    # defining product attributes offsets
    .equ    PRODUCT_SIZE, 44
    .equ    NAME_REF, 0
    .equ    LOT_REF, 4
    .equ    TYPE_REF, 8
    .equ    EXPIRATION_DAY, 12
    .equ    EXPIRATION_MONTH, 16
    .equ    EXPIRATION_YEAR, 20
    .equ    SUPPLIER_REF, 24
    .equ    QUANTITY_REF, 28
    .equ    PURCHASE_REF, 32
    .equ    SALE_REF, 36
    .equ    NEXT_REF, 40
        

.section .bss
    # defining all of the required pointers
    .lcomm name_ptr, 4
    .lcomm type_ptr, 4
    .lcomm supplier_ptr, 4
    .lcomm next_ptr, 4
    .lcomm head_ptr, 4  
    .lcomm product_ptr, 4
    .lcomm restore_ptr, 4
    .lcomm file_ptr,4
    # declaring the variables that need a fixed size not initialized
    product_name:        .space 30
    type_string:         .space 30
    supplier:            .space 30
    node_buffer:         .space 200
    temp_char:           .space 1   
    temp_array:          .space 4000

.section .text
.globl main

main:

    # head = NULL
    movl    $0, head_ptr
    # Get the current date for future use
    call    get_current_date
    # initializing FPU
    finit

    start_point:
        call    read_menu

        movl    option, %eax
        cmpl    $1, %eax
        je      case1
        cmpl    $2, %eax
        je      case2
        cmpl    $3, %eax
        je      case3
        cmpl    $4, %eax
        je      case4
        cmpl    $5, %eax
        je      case5
        cmpl    $6, %eax
        je      case6
        cmpl    $7, %eax
        je      case7
        cmpl    $8, %eax
        je      case8
        cmpl    $0, %eax
        je      exit

        # invalid option
        pushl   $msg_error_invalid_option
        call    printf
        addl    $4, %esp
        jmp     start_point

_exit:
    movl    $1, %eax 
    xorl    %ebx, %ebx
    int     $0x80

case1:
    call    insert_product
    jmp     start_point

case2:
    call    remove_product
    jmp     start_point

case3:
    call    update_product
    jmp     start_point

case4:
    call    product_consult
    jmp     start_point

case5:
    call    financial_consult
    jmp     start_point

case6:
    call    registration_report
    jmp     start_point
    
case7:
    call    write_to_disk
    call    free_linked_list

    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp

    jmp     start_point

case8:
    call    read_from_disk

    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp

    jmp     start_point
    

read_menu:
    pushl   $main_menu
    call    printf
    addl    $4, %esp

    pushl   $option
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # verify scanf return value in %eax
    cmpl    $1, %eax
    je      read_menu_success

    clear_buffer:
        # clear buffer if scanf failed 
        call    getchar
        cmpl    $10, %eax       # 10 = "\n" (verify if buffer is totally cleared)
        jne     clear_buffer

        # assigning a invalid option to the "option" variable
        movl    $-1, option
    
    read_menu_success:
        ret

insert_product:
    call    create_node
    call    input_product_data
    call    fill_node_with_data
    call    insert_node_by_name

    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp
    
    ret

create_node:
    # allocate space for the product node using malloc(PRODUCT_SIZE)
    movl    $PRODUCT_SIZE, %eax
    pushl   %eax
    call    malloc
    addl    $4, %esp
    # Verify malloc return value (it is in eax registor)
    cmpl    $0, %eax
    je      _allocation_failed
    # in case it doesn't fail, just move the address in %eax to product_ptr
    movl    %eax, product_ptr

    # allocate space for product name
    pushl   $20
    call    malloc
    addl    $4, %esp
    cmpl    $0, %eax
    je      _allocation_failed
    movl    %eax, name_ptr

    # allocate space for product type
    pushl   $30
    call    malloc
    addl    $4, %esp
    cmpl    $0, %eax
    je      _allocation_failed
    movl    %eax, type_ptr

    # allocate space for product supplier 
    pushl   $20
    call    malloc
    addl    $4, %esp
    cmpl    $0, %eax
    je      _allocation_failed
    movl    %eax, supplier_ptr


    ret

input_product_data:
    # read name
    pushl   $msg_product_name
    call    printf
    addl    $4, %esp

    # remove [\n] character forgotten in the buffer
    call    getchar
    pushl   stdin
    pushl   $30
    pushl   $product_name
    call    fgets
    addl    $12, %esp

    movl    $product_name, %eax
    pushl   %eax
    call    remove_newline
    addl    $4, %esp

    # read lot
    pushl   $msg_product_lot
    call    printf
    addl    $4, %esp

    pushl   $lot
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # read type
    input_read_type_ip:
        pushl   $produtos_supermercado
        call    printf
        addl    $4, %esp

        pushl   $msg_product_type
        call    printf
        addl    $4, %esp

        pushl   $type_number
        pushl   $fmt_decimal1
        call    scanf
        addl    $8, %esp
        
        movl    type_number, %eax
        subl    $1, %eax

        cmpl     $0, %eax
        jl       input_type_error_ip
        cmpl     $14, %eax
        jg       input_type_error_ip

        movl     items(,%eax,4), %ebx   
        movl     $type_string, %eax      
        pushl    %ebx                    
        pushl    %eax                   
        call     strcpy
        addl     $8, %esp

    # read expiration date
    pushl   $msg_product_expiry_date
    call    printf
    addl    $4, %esp

    # day
    pushl   $msg_product_day
    call    printf
    addl    $4, %esp
    pushl   $expiry_day
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # month
    pushl   $msg_product_month
    call    printf
    addl    $4, %esp
    pushl   $expiry_month
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # year
    pushl   $msg_product_year
    call    printf
    addl    $4, %esp
    pushl   $expiry_year
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # read supplier
    pushl   $msg_product_supplier
    call    printf
    addl    $4, %esp

    # remove [\n] character forgotten in the buffer
    call    getchar
    pushl   stdin
    pushl   $30
    pushl   $supplier
    call    fgets
    addl    $12, %esp

    movl    $supplier, %eax
    pushl   %eax
    call    remove_newline
    addl    $4, %esp

    # read stock quantity
    pushl   $msg_stock_quantity
    call    printf
    addl    $4, %esp

    pushl   $stock_quantity
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # read purchase price
    pushl   $msg_purchase_price
    call    printf
    addl    $4, %esp

    pushl   $purchase_price
    pushl   $fmt_float
    call    scanf
    addl    $8, %esp

    # read sale price
    pushl   $msg_sale_price
    call    printf
    addl    $4, %esp

    pushl   $sale_price
    pushl   $fmt_float
    call    scanf
    addl    $8, %esp


    ret

fill_node_with_data:
    # placing product name in the appropriate location of the node
    movl    product_ptr, %edi
    movl    name_ptr, %eax
    movl    %eax, NAME_REF(%edi)
    pushl   $product_name     
    pushl   %eax
    call    strcpy
    addl    $8, %esp
    
    #  placing product lot
    movl    product_ptr, %edi
    movl    lot, %eax
    movl    %eax, LOT_REF(%edi)

    #  placing product type
    movl    product_ptr, %edi
    movl    type_ptr, %eax
    movl    %eax, TYPE_REF(%edi)
    pushl   $type_string     
    pushl   %eax
    call    strcpy
    addl    $8, %esp

    #  placing product expiration date
    movl    product_ptr, %edi
    movl    expiry_day, %eax
    movl    expiry_month, %ebx
    movl    expiry_year, %ecx
    movl    %eax, EXPIRATION_DAY(%edi)
    movl    %ebx, EXPIRATION_MONTH(%edi)
    movl    %ecx, EXPIRATION_YEAR(%edi)

    #  placing product supplier
    movl    supplier_ptr, %eax
    movl    %eax, SUPPLIER_REF(%edi)
    pushl   $supplier     
    pushl   %eax
    call    strcpy
    addl    $8, %esp

    #  placing product quantity
    movl    product_ptr, %edi
    movl    stock_quantity, %eax
    movl    %eax, QUANTITY_REF(%edi)

    #  placing product purchase price
    movl    purchase_price, %eax
    movl    %eax, PURCHASE_REF(%edi)

    #  placing product sale price
    movl    sale_price, %eax
    movl    %eax, SALE_REF(%edi)

    #  setting product next field with value zero (NULL)
    movl    $0, NEXT_REF(%edi)

    ret

insert_node_by_name:
    # looping through the list
    movl    head_ptr, %eax      # %eax = current node
    movl    %eax, restore_ptr
    movl    $0, %esi            # %esi = previous node (NULL)

    # in case the list is empty, insert as the first node
    cmpl    $0, %eax
    je      set_first

    search_insert_position:
        # compare current node name with new node name using strcmp C function 
        movl    name_ptr, %ebx
        movl    NAME_REF(%eax), %edx
        pushl   %edx
        pushl   %ebx
        call    strcmp 
        addl    $8, %esp

        # %eax receives the return of strcmp
        cmpl    $0, %eax
        # in case %eax < 0. It means new node name is lower than the current node name and it needs to be inserted right before current node
        jl      insert_before

        # restore %eax value
        movl    restore_ptr, %eax

        # in case the insert position isn't found, update current and previous node
        movl    %eax, %esi
        movl    NEXT_REF(%eax), %eax
        movl    %eax, restore_ptr

        # check if end of list has been reached
        cmpl    $0, %eax
        je      insert_at_end
        jmp     search_insert_position
    
    insert_before:
        # restore %eax value
        movl    restore_ptr, %eax

        # new_node->next = current_node
        movl    product_ptr, %edi
        movl    %eax, NEXT_REF(%edi)

        # in case prev_node is NULL, than new_node will be inserted as the first node of the list. So we must update the head pointer
        cmpl    $0, %esi
        je      update_head

        # prev_node->next = new_node
        movl    %edi, NEXT_REF(%esi)
        jmp insertion_success

    update_head:
        movl    %edi, head_ptr
        jmp     insertion_success
    
    insert_at_end:
        # prev_node->next = new_node
        movl    product_ptr, %edi
        movl    %edi, NEXT_REF(%esi)
        # new_node->next = NULL
        movl    $0, NEXT_REF(%edi)
        jmp     insertion_success

    set_first:
        # head_ptr now points to new_node as it is the first node of the list
        movl    product_ptr, %edi
        movl    %edi, head_ptr
        # new_node->next = NULL
        movl    $0, NEXT_REF(%edi)

    insertion_success:
        # print a successful insertion message to the user
        pushl   $msg_success_insert
        call    printf
        addl    $4, %esp

        ret


remove_product:
    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp

    # print the remove product menu options to the user
    pushl   $remove_product_menu
    call    printf
    addl    $4, %esp
    # read option chosen by the user
    pushl   $msg_user_option
    call    printf
    addl    $4, %esp
    pushl   $option
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp
    # compare the options in order to call the right function
    movl    option, %eax
    cmpl    $1, %eax
    je      call_option1_rp
    cmpl    $2, %eax
    je      call_option2_rp
    jmp     input_type_error_rp

    call_option1_rp:
      pushl   $msg_remove
      call    enter_product_name
      addl    $4, %esp
      call    remove_product_by_name
      jmp     end_remove_product

    call_option2_rp:
      call    remove_product_by_date
      jmp     end_remove_product

    end_remove_product:
      movl    head_ptr, %eax
      pushl   %eax
      call    print_all_nodes_by_name
      addl    $4, %esp

      ret




remove_product_by_name:
    movl    head_ptr, %eax      # current node
    movl    %eax, restore_ptr
    movl    $0, %esi            # previous node

    cmpl    $0, %eax
    je      zero_nodes_present_remove

    find_node_to_remove:
        # veriry if the end of the list has been reached
        cmpl    $0, %eax
        je      not_found_node_to_remove

        movl    NAME_REF(%eax), %edi
        pushl   $product_name
        pushl   %edi
        call    strcmp
        addl    $8, %esp
        # If the strings are equal, remove the node
        cmpl    $0, %eax
        je      remove_node

        # restore the current node value (address)
        movl    restore_ptr, %eax
        # update previous and current node
        movl    %eax, %esi
        movl    NEXT_REF(%eax), %eax
        movl    %eax, restore_ptr
        jmp     find_node_to_remove
    remove_node:
        # restore the current node value (address)
        movl    restore_ptr, %eax

        # check if the node to be removed is the first node
        cmpl    $0, %esi
        je      remove_first_node

        # If the node to be removed is not the first node: prev->next = next_node
        movl    NEXT_REF(%eax), %ecx
        movl    %ecx, NEXT_REF(%esi)
        # free the node allocation space
        pushl   %eax
        call    free_node
        addl    $4, %esp
        # print successful message
        pushl   $msg_success_remove
        call    printf
        addl    $4, %esp
        ret
    remove_first_node:
        # head_ptr = current_node->next
        movl    NEXT_REF(%eax), %edx
        movl    %edx, head_ptr
        # free the node allocation space
        pushl   %eax
        call    free_node
        addl    $4, %esp
        # print successful message
        pushl   $msg_success_remove
        call    printf
        addl    $4, %esp
        ret
    zero_nodes_present_remove:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret
    not_found_node_to_remove:
        pushl   $msg_error_not_found
        call    printf
        addl    $4, %esp
        ret

remove_product_by_date:
  movl    head_ptr, %edi  # current node
  movl    $0, %esi        # previous node
  movl    $0, counter     # counter of removed nodes

  cmpl    $0, %edi
  je      zero_nodes_present_remove_by_date

    start_remove_by_date_loop:
        # veriry if the end of the list has been reached
        cmpl    $0, %edi
        je      end_remove_by_date_loop

        movl    EXPIRATION_YEAR(%edi), %eax
        cmpl    current_year, %eax
        jl      remove_node_by_date
        jg      node_not_expired

        # same year, compare month
        movl    EXPIRATION_MONTH(%edi), %eax
        cmpl    current_month, %eax
        jl      remove_node_by_date
        jg      node_not_expired

        # same month, compare day
        movl    EXPIRATION_DAY(%edi), %eax
        cmpl    current_day, %eax
        jl      remove_node_by_date

        movl    %edi, %esi
        movl    NEXT_REF(%edi), %edi
        jmp     start_remove_by_date_loop
  
    node_not_expired:
        # product not expired. Update node
        movl    %edi, %esi             
        movl    NEXT_REF(%edi), %edi    
        jmp     start_remove_by_date_loop

    remove_node_by_date:
        # check if the node to be removed is the first node
        cmpl    $0, %esi
        je      remove_first_node_by_date

        # If the node to be removed is not the first node: prev->next = next_node
        movl    NEXT_REF(%edi), %ecx
        movl    %ecx, NEXT_REF(%esi)
        # save %ecx in the stack
        pushl   %ecx 
        # free the node allocation space
        pushl   %edi
        call    free_node
        addl    $4, %esp
        incl    counter
        # print successful message
        pushl   $msg_success_remove
        call    printf
        addl    $4, %esp
        # update current node (retrieve value from stack to %edi)
        popl    %edi
        jmp     start_remove_by_date_loop
    
    remove_first_node_by_date:
        # head_ptr = current_node->next
        movl    NEXT_REF(%edi), %edx
        movl    %edx, head_ptr
        # free the node allocation space
        pushl   %edi
        call    free_node
        addl    $4, %esp
        incl    counter
        # print successful message
        pushl   $msg_success_remove
        call    printf
        addl    $4, %esp
        # update current and previous node
        movl    head_ptr, %edi
        movl    $0, %esi
        jmp     start_remove_by_date_loop

    end_remove_by_date_loop:
        pushl   counter
        pushl   $msg_total_removed_nodes
        call    printf
        addl    $8, %esp
        ret
    zero_nodes_present_remove_by_date:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

free_node:
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %edx           # fisrt parameter (current node)
    movl    %edx, restore_ptr

    # free name
    movl    NAME_REF(%edx), %ebx
    pushl   %ebx
    call    free
    addl    $4, %esp
    # free type
    movl    restore_ptr, %edx
    movl    TYPE_REF(%edx), %ebx
    pushl   %ebx
    call    free
    addl    $4, %esp
    # free supplier
    movl    restore_ptr, %edx
    movl    SUPPLIER_REF(%edx), %ebx
    pushl   %ebx
    call    free
    addl    $4, %esp
    # free node
    movl    restore_ptr, %edx
    pushl   %edx
    call    free
    addl    $4, %esp

    popl    %ebp
    ret

free_linked_list:
    movl    head_ptr, %edi      # current node

    start_free_list_loop:
        cmpl    $0, %edi
        je      end_free_list_loop

        pushl   %edi
        call    free_node
        addl    $4, %esp

        movl    NEXT_REF(%edi), %edi
        jmp     start_free_list_loop
    
    end_free_list_loop:
        movl    $0, head_ptr
        ret


update_product:

    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp

    pushl   $msg_update
    call    enter_product_name
    addl    $4, %esp

    call    update_product_by_name

    ret

update_product_by_name:
    movl    head_ptr, %eax      # current node
    movl    %eax, restore_ptr

    cmpl    $0, %eax
    je      zero_nodes_present_update

    find_node_to_update:
        # veriry if the end of the list has been reached
        cmpl    $0, %eax
        je      not_found_node_to_update

        movl    NAME_REF(%eax), %edi
        pushl   $product_name
        pushl   %edi
        call    strcmp
        addl    $8, %esp
        # If the strings are equal, update the node
        cmpl    $0, %eax
        je      update_node

        # restore the current node value (address)
        movl    restore_ptr, %eax
        # update current node
        movl    NEXT_REF(%eax), %eax
        movl    %eax, restore_ptr
        jmp     find_node_to_update
    update_node:
        # restore the current node value (address)
        movl    restore_ptr, %eax
        # print the node information to the user
        pushl   %eax
        call    print_product1
        addl    $4, %esp
        # restore the current node value (address)
        movl    restore_ptr, %eax

        # update attributes stock quantity and sale price
        # read new stock quantity
        pushl   $msg_new_stock_quantity
        call    printf
        addl    $4, %esp
        pushl   $stock_quantity
        pushl   $fmt_decimal1
        call    scanf
        addl    $8, %esp

        # read new sale price
        pushl   $msg_sale_price
        call    printf
        addl    $4, %esp
        pushl   $sale_price
        pushl   $fmt_float
        call    scanf
        addl    $8, %esp

        # restore the current node value (address)
        movl    restore_ptr, %eax

        # insert new input values into the node
        # insert stock quantity
        movl    stock_quantity, %ebx
        movl    %ebx, QUANTITY_REF(%eax)

        # insert sale price
        movl    sale_price, %ebx
        movl    %ebx, SALE_REF(%eax)

        # print successful message
        pushl   $msg_success_update
        call    printf
        addl    $4, %esp

        # restore the current node value (address)
        movl    restore_ptr, %eax

        # print new node information to the user
        pushl   %eax
        call    print_product1
        addl    $4, %esp

        ret
    not_found_node_to_update: 
        pushl   $msg_error_not_found
        call    printf
        addl    $4, %esp
        ret
    zero_nodes_present_update:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

product_consult:
    movl    head_ptr, %eax
    pushl   %eax
    call    print_all_nodes_by_name
    addl    $4, %esp

    pushl   $msg_consult_product
    call    enter_product_name
    addl    $4, %esp

    call    product_consult_by_name

    ret

product_consult_by_name:
    movl    head_ptr, %eax      # current node
    movl    %eax, restore_ptr

    cmpl    $0, %eax
    je      zero_nodes_present_consult

    find_node_to_consult:
        # veriry if the end of the list has been reached
        cmpl    $0, %eax
        je      not_found_node_to_consult

        movl    NAME_REF(%eax), %edi
        pushl   $product_name
        pushl   %edi
        call    strcmp
        addl    $8, %esp
        # If the strings are equal, jump to consult_node
        cmpl    $0, %eax
        je      consult_node

        # restore the current node value (address)
        movl    restore_ptr, %eax
        # update current node
        movl    NEXT_REF(%eax), %eax
        movl    %eax, restore_ptr
        jmp     find_node_to_consult
    consult_node:
        # restore the current node value (address)
        movl    restore_ptr, %eax
        # print the node information to the user
        pushl   %eax
        call    print_product2
        addl    $4, %esp
        ret
    not_found_node_to_consult:
        pushl   $msg_error_not_found
        call    printf
        addl    $4, %esp
        ret
    zero_nodes_present_consult:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

financial_consult:
    movl    head_ptr, %edi

    # print the financial menu options to the user
    pushl   $financial_menu
    call    printf
    addl    $4, %esp
    # read option chosen by the user
    pushl   $msg_user_option
    call    printf
    addl    $4, %esp
    pushl   $option
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp

    # set the variables to zero in case of new consultation
    fldz
    fsts    total_purchase
    fstps    total_sale

    cmpl    $0, %edi
    je      zero_nodes_present_financial

    financial_consult_loop:
        # veriry if the end of the list has been reached
        cmpl    $0, %edi
        je      end_finalcial_consult_loop

        # accumulate total_purchase: qnt*purchase_price + total_purchase
        movl    PURCHASE_REF(%edi), %ebx
        movl    QUANTITY_REF(%edi), %eax

        # load quantity into the FPU and convert it to float
        pushl   %eax
        filds   (%esp)
        addl    $4, %esp

        # load purchase_price into the FPU at %st(0), quantity is now at %st(1)
        pushl   %ebx
        flds    (%esp)
        addl    $4, %esp

        fmul    %st(1), %st(0)
        fadds   total_purchase
        fsts    total_purchase

        fstp    %st(0)
        fstp    %st(0)

        # accumulate total_sale
        movl    SALE_REF(%edi), %ebx
        movl    QUANTITY_REF(%edi), %eax

        pushl   %eax
        filds   (%esp)
        addl    $4, %esp

        pushl   %ebx
        flds    (%esp)
        addl    $4, %esp

        fmul    %st(1), %st(0)
        fadds   total_sale
        fsts    total_sale

        fstp    %st(0)
        fstp    %st(0)

        # update current node
        movl    NEXT_REF(%edi), %edi
        jmp     financial_consult_loop
    end_finalcial_consult_loop:
        # calculate total profit = total_sale - total_purchase
        flds    total_purchase
        flds    total_sale
        fsub    %st(1), %st(0)
        fsts    total_profit
        fstp    %st(0)
        fstp    %st(0)
        # print the financial information according to the user option
        movl    option, %eax
        cmpl    $1, %eax
        je      print_total_purchase
        cmpl    $2, %eax
        je      print_total_sale
        cmpl    $3, %eax
        je      print_total_profit
        pushl   $msg_error_invalid_option
        call    printf
        addl    $4, %esp
        jmp     financial_consult

    print_total_purchase:
        flds    total_purchase
        subl    $8, %esp
        fstpl   (%esp)
        pushl   $msg_option_total_purchase
        pushl   $financial_data_fmt
        call    printf 
        addl    $16, %esp
        jmp     return_financial_consult
    print_total_sale:
        flds    total_sale
        subl    $8, %esp
        fstpl   (%esp)
        pushl   $msg_option_total_sale
        pushl   $financial_data_fmt
        call    printf 
        addl    $16, %esp
        jmp     return_financial_consult
    print_total_profit:
        flds    total_profit
        subl    $8, %esp
        fstpl   (%esp)
        pushl   $msg_option_total_profit
        pushl   $financial_data_fmt
        call    printf 
        addl    $16, %esp
    return_financial_consult:
        ret
    zero_nodes_present_financial:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

write_to_disk:
    # this function will deal with system calls to write in an external file
    # open file (system open)
    movl    $5, %eax
    movl    $filename, %ebx
    movl    fileflags, %ecx
    movl    filemode, %edx
    int     $0x80
    movl    %eax, file_ptr

    # loop through the linked list
    movl    head_ptr, %edi          # current node
    
    start_write_loop:
        cmpl    $0, %edi
        je      end_write_loop

        # using sprintf to fill our buffer with the format_string
        movl    SALE_REF(%edi), %eax
        pushl   %eax
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)

        movl    PURCHASE_REF(%edi), %ebx
        pushl   %ebx
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)

        pushl   QUANTITY_REF(%edi)
        pushl   SUPPLIER_REF(%edi)
        pushl   EXPIRATION_YEAR(%edi)
        pushl   EXPIRATION_MONTH(%edi)
        pushl   EXPIRATION_DAY(%edi)
        pushl   TYPE_REF(%edi)
        pushl   LOT_REF(%edi)
        pushl   NAME_REF(%edi)
        pushl   $format_write_string
        pushl   $node_buffer
        call    sprintf
        addl    $56, %esp

        # calculate the string lenght, assign to %edx (requirement for syscall write)
        pushl   $node_buffer
        call    strlen
        addl    $4, %esp            
        movl    %eax, %edx          

        # write to file (syscall write)
        movl    $4, %eax            
        movl    file_ptr, %ebx
        movl    $node_buffer, %ecx
        int     $0x80

        # update current node
        movl    NEXT_REF(%edi), %edi
        jmp     start_write_loop

    end_write_loop:
        # close file (syscall close)
        movl    $6, %eax            
        movl    file_ptr, %ebx
        int     $0x80

        # print successful message
        pushl   $msg_success_save
        call    printf
        addl    $4, %esp

        ret

read_from_disk:
    # Open file (read only)
    movl    $5, %eax       
    movl    $filename, %ebx   
    movl    $0, %ecx          # file flag O_RDONLY
    int     $0x80
    movl    %eax, file_ptr    

    start_read_loop:
        call    read_line

        # Check if end of file has been reached
        cmpl    $0, %eax
        je      end_read_loop

        teste:
        # using sscanf to populate the global variables
        pushl   $sale_price        
        pushl   $purchase_price    
        pushl   $stock_quantity    
        pushl   $supplier 
        pushl   $expiry_year
        pushl   $expiry_month          
        pushl   $expiry_day        
        pushl   $type_string               
        pushl   $lot               
        pushl   $product_name       
        pushl   $format_read_string     
        pushl   $node_buffer       
        call    sscanf
        addl    $48, %esp 

        # recreating the linked list
        call    create_node
        call    fill_node_with_data
        call    insert_node_by_name

        jmp     start_read_loop
    end_read_loop:
        pushl   $msg_success_load
        call    printf
        addl    $4, %esp

        # syscall close file
        movl    $6, %eax
        movl    file_ptr, %ebx
        int     $0x80

        ret

read_line:
    movl    $0, buffer_index

    start_read_line_loop:
        # syscall read
        movl    $3, %eax
        movl    file_ptr, %ebx        
        movl    $temp_char, %ecx        
        movl    $1, %edx              
        int     $0x80

        cmpl    $0, %eax
        je      end_of_file

        # Copy the byte to node_buffer[buffer_index]
        movl    buffer_index, %esi
        movb    temp_char, %al
        movb    %al, node_buffer(%esi)

        # Check if the byte is '\n' (end of line)
        cmpb    $'\n', temp_char
        je      end_read_line_loop

        incl    buffer_index
        jmp     start_read_line_loop   
    end_read_line_loop:
        # Add string terminator '\0'
        movl    buffer_index, %esi
        movb    $0, node_buffer(%esi)
        ret
    end_of_file:
        ret

remove_newline:
    # function responsible for elimination the '\n' character in a string
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %esi

    remove_newline_loop:
        movb    (%esi), %al
        cmpb    $0, %al
        je      end_remove_newline_loop

        cmpb    $'\n', %al
        jne     next_char

        movb    $0, (%esi)
        jmp     end_remove_newline_loop

    next_char:
        incl    %esi
        jmp     remove_newline_loop
    end_remove_newline_loop:
        popl    %ebp
        ret

registration_report:
    # print the registration report menu options to the user
    pushl   $msg_registration_report
    call    printf
    addl    $4, %esp
    pushl   $report_menu
    call    printf
    addl    $4, %esp
    # read option chosen by the user
    pushl   $msg_user_option
    call    printf
    addl    $4, %esp
    pushl   $option
    pushl   $fmt_decimal1
    call    scanf
    addl    $8, %esp
    # compare the options in order to call the right function
    movl    option, %eax
    cmpl    $1, %eax
    je      call_option1_rr
    cmpl    $2, %eax
    je      call_option2_rr
    cmpl    $3, %eax
    je      call_option3_rr
    jmp     input_type_error_rr

    call_option1_rr:
        call    registration_report_by_name
        jmp     end_registration_report
    call_option2_rr:
        call    registration_report_by_date
        jmp     end_registration_report
    call_option3_rr:
        call    registration_report_by_quantity
    end_registration_report:
        pushl   $msg_success_report
        call    printf
        addl    $4, %esp

        ret

registration_report_by_name:
    call print_report_loop_by_name
    ret

registration_report_by_date:
    call    populate_temp_array

    # in case there's zero elements in the list, return
    movl    counter, %eax
    cmpl    $0, %eax
    je      zero_nodes_present_report_by_date

    call    bubble_sort_by_date

    call    print_report_loop

    ret

    zero_nodes_present_report_by_date:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

bubble_sort_by_date:
    # in case there's only one element, the list's already sorted
    movl    counter, %ecx
    cmpl    $1, %ecx
    jle     end_bubble_sort_by_date

    # outer loop for (int i = 0; i < size - 1; i++)
    movl    $0, %edi
    outer_loop_by_date:
        movl    counter, %eax
        decl    %eax
        cmpl    %eax, %edi
        jge     end_bubble_sort_by_date

        # inner loop for (int j = 0; j < size - 1 - i; j++)
        movl    $0, %esi
    inner_loop_by_date:
        movl    counter, %eax
        decl    %eax                  
        subl    %edi, %eax            
        cmpl    %eax, %esi
        jge     inner_loop_end_by_date

        # getting array[j] and array[j+1] products
        movl    temp_array(,%esi,4), %eax
        movl    %esi, %ecx
        incl    %ecx                            
        movl    temp_array(,%ecx,4), %ebx

        # comparing both by expiration dates
        pushl   %ebx
        pushl   %eax
        call    compare_expiration_dates
        addl    $8, %esp

        # in case return > 0, then we swap products 
        cmpl    $0, %eax
        jle     inner_next

        # swaping pointers
        movl    %esi, %ecx
        incl    %ecx
        movl    temp_array(,%esi,4), %eax      # temp = array[j]
        movl    temp_array(,%ecx,4), %ebx      # array[j+1]
        movl    %ebx, temp_array(,%esi,4)      # array[j] = array[j+1]
        movl    %eax, temp_array(,%ecx,4)      # array[j+1] = temp

        inner_next:
            incl    %esi
            jmp     inner_loop_by_date

        inner_loop_end_by_date:
            incl    %edi
            jmp     outer_loop_by_date
    
    end_bubble_sort_by_date:
        ret

compare_expiration_dates:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx
    pushl   %ecx
    
    movl    8(%ebp), %ebx      # produto1
    movl    12(%ebp), %ecx     # produto2
    
    # compare years
    movl    EXPIRATION_YEAR(%ebx), %eax
    movl    EXPIRATION_YEAR(%ecx), %edx
    cmpl    %edx, %eax
    jne     compare_result
    
    # same year, compare months
    movl    EXPIRATION_MONTH(%ebx), %eax
    movl    EXPIRATION_MONTH(%ecx), %edx
    cmpl    %edx, %eax
    jne     compare_result
    
    # same months, compare days
    movl    EXPIRATION_DAY(%ebx), %eax
    movl    EXPIRATION_DAY(%ecx), %edx
    cmpl    %edx, %eax
    
    compare_result:
        # comparison result is in the flags
        jg      greater_than
        jl      less_than
        
        # equal
        movl    $0, %eax
        jmp     compare_end
        
    greater_than:
        movl    $1, %eax
        jmp     compare_end
        
    less_than:
        movl    $-1, %eax
    
    compare_end:
        popl    %ecx
        popl    %ebx
        popl    %ebp
        ret


registration_report_by_quantity:
    call    populate_temp_array

    # in case there's zero elements in the list, return
    movl    counter, %eax
    cmpl    $0, %eax
    je      zero_nodes_present_report_by_quantity

    call    bubble_sort_by_quantity

    call    print_report_loop

    ret

    zero_nodes_present_report_by_quantity:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret

bubble_sort_by_quantity:
    # in case there's only one element, the list's already sorted
    movl    counter, %ecx
    cmpl    $1, %ecx
    jle     end_bubble_sort_by_quantity        
    
    # outer loop (i = 0; i < size-1; i++)
    movl    $0, %edi              
    
    outer_loop:
        movl    counter, %eax
        decl    %eax                  
        cmpl    %eax, %edi
        jge     end_bubble_sort_by_quantity
        
        # inner (j = 0; j < size-1-i; j++)
        movl    $0, %esi              
        
    inner_loop:
        movl    counter, %eax
        decl    %eax                  
        subl    %edi, %eax            
        cmpl    %eax, %esi
        jge     inner_loop_end
        
        # compare array[j] with array[j+1]
        movl    temp_array(,%esi,4), %eax      
        movl    QUANTITY_REF(%eax), %ebx         
        
        movl    %esi, %ecx
        incl    %ecx                             
        movl    temp_array(,%ecx,4), %eax     
        movl    QUANTITY_REF(%eax), %edx        
        
        # in case array[j].quantity > array[j+1].quantity, swap
        cmpl    %edx, %ebx
        jle     no_swap
        
        # swap pointers
        movl    temp_array(,%esi,4), %eax      
        movl    temp_array(,%ecx,4), %ebx      
        movl    %ebx, temp_array(,%esi,4)      
        movl    %eax, temp_array(,%ecx,4)      
        
    no_swap:
        incl    %esi                  
        jmp     inner_loop
        
    inner_loop_end:
        incl    %edi                  
        jmp     outer_loop
        
    end_bubble_sort_by_quantity:
        ret

print_product2:
    # print all values of a especific node
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %edi       # 1st parameter (current node)

    # print the records
    movl    SALE_REF(%edi), %eax
    pushl   %eax
    flds    (%esp)
    addl    $4, %esp
    subl    $8, %esp
    fstpl   (%esp)

    movl    PURCHASE_REF(%edi), %ebx
    pushl   %ebx
    flds    (%esp)
    addl    $4, %esp
    subl    $8, %esp
    fstpl   (%esp)
    
    pushl   QUANTITY_REF(%edi)
    pushl   SUPPLIER_REF(%edi)
    pushl   EXPIRATION_YEAR(%edi)
    pushl   EXPIRATION_MONTH(%edi)
    pushl   EXPIRATION_DAY(%edi)
    pushl   TYPE_REF(%edi)
    pushl   LOT_REF(%edi)
    pushl   NAME_REF(%edi)
    pushl   $product_data_fmt
    call    printf
    addl    $52, %esp

    popl    %ebp
    ret

print_product1:
  # print name, stock quantity and sale_price for the update case
  pushl   %ebp
  movl    %esp, %ebp

  movl    8(%ebp), %edi       # 1st parameter (node_ptr)

  movl    SALE_REF(%edi), %eax
  pushl   %eax
  flds    (%esp)
  addl    $4, %esp
  subl    $8, %esp
  fstpl   (%esp)

  movl    QUANTITY_REF(%edi), %eax
  pushl   %eax
  movl    NAME_REF(%edi), %eax
  pushl   %eax

  pushl   $product_data_fmt_update
  call    printf
  addl    $20, %esp
  popl    %ebp
  ret 

print_all_nodes_by_name:
  pushl   %ebp
  movl    %esp, %ebp

  movl    8(%ebp), %edi           # first parameter (head_ptr)

  pushl   $msg_list
  call    printf
  addl    $4, %esp

  start_print_all_loop:
    # verify if the end of the list has been reached
    cmpl    $0, %edi
    je      end_print_all_loop
    # print the name of current node
    movl    NAME_REF(%edi), %ebx
    pushl   %ebx
    pushl   $print_all_nodes_fmt
    call    printf
    addl    $8, %esp           
    # update current node 
    movl    NEXT_REF(%edi), %edi  
    jmp     start_print_all_loop
  end_print_all_loop:
    pushl   $fmt_newline
    call    printf
    addl    $4, %esp
    popl    %ebp
    ret

print_report_loop_by_name:
    # loop through the linked lista
    movl    head_ptr, %edi          # current node

    cmpl    $0, %edi
    je      zero_nodes_present_report_by_name

    start_report_loop_by_name:
        cmpl    $0, %edi
        je      end_report_loop_by_name

        # print the records
        movl    SALE_REF(%edi), %eax
        pushl   %eax
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)

        movl    PURCHASE_REF(%edi), %ebx
        pushl   %ebx
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)
        
        pushl   QUANTITY_REF(%edi)
        pushl   SUPPLIER_REF(%edi)
        pushl   EXPIRATION_YEAR(%edi)
        pushl   EXPIRATION_MONTH(%edi)
        pushl   EXPIRATION_DAY(%edi)
        pushl   TYPE_REF(%edi)
        pushl   LOT_REF(%edi)
        pushl   NAME_REF(%edi)
        pushl   $format_write_string
        call    printf
        addl    $52, %esp

        # update current node
        movl    NEXT_REF(%edi), %edi
        jmp     start_report_loop_by_name
    end_report_loop_by_name:
        ret
    zero_nodes_present_report_by_name:
        pushl   $msg_zeros_nodes_present
        call    printf
        addl    $4, %esp
        ret 

print_report_loop:
    movl    $0, %esi                    # list index

    start_report_loop:
        movl    counter, %eax
        cmpl    %eax, %esi
        jge     end_report_loop

        movl    temp_array(, %esi, 4), %edi

        # print the records
        movl    SALE_REF(%edi), %eax
        pushl   %eax
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)

        movl    PURCHASE_REF(%edi), %ebx
        pushl   %ebx
        flds    (%esp)
        addl    $4, %esp
        subl    $8, %esp
        fstpl   (%esp)
        
        pushl   QUANTITY_REF(%edi)
        pushl   SUPPLIER_REF(%edi)
        pushl   EXPIRATION_YEAR(%edi)
        pushl   EXPIRATION_MONTH(%edi)
        pushl   EXPIRATION_DAY(%edi)
        pushl   TYPE_REF(%edi)
        pushl   LOT_REF(%edi)
        pushl   NAME_REF(%edi)
        pushl   $format_write_string
        call    printf
        addl    $52, %esp

        incl    %esi
        jmp     start_report_loop
    end_report_loop:
        ret

enter_product_name:
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %edx

    pushl   %edx
    pushl   $msg_crud_name
    call    printf
    addl    $8, %esp

    call    getchar
    pushl   stdin
    pushl   $30
    pushl   $product_name
    call    fgets
    addl    $12, %esp

    movl    $product_name, %eax
    pushl   %eax
    call    remove_newline
    addl    $4, %esp

    popl    %ebp
    ret

get_current_date:
  pushl     %ebp
  movl      %esp, %ebp

  # reserve 4 bytes of space in the stack for timestamp
  subl      $4, %esp
  
  # call time(NULL)
  movl      %ebp, %eax
  subl      $4, %eax
  pushl     %eax
  call      time
  addl      $4, %esp
  
  # leal -4(%ebp), %eax is the same as (movl %ebp, %eax/subl $4, %eax)
  # call localtime(&timestamp)
  leal      -4(%ebp), %eax
  pushl     %eax
  call      localtime
  addl      $4, %esp
  
  # %eax now points to struct tm
  # struct tm { int tm_sec, tm_min, tm_hour, tm_mday, tm_mon, tm_year, ... }
  # Offsets: tm_mday=12, tm_mon=16, tm_year=20
  
  # get day (tm_mday)
  movl 12(%eax), %edx
  movl %edx, current_day
  
  # get month (tm_mon + 1, because tm_mon is 0-11)
  movl 16(%eax), %edx
  incl %edx
  movl %edx, current_month
  
  # get year (tm_year + 1900, because tm_year is since 1900)
  movl 20(%eax), %edx
  addl $1900, %edx
  movl %edx, current_year
  
  movl %ebp, %esp
  popl %ebp
  ret

populate_temp_array:
    # create a temp array that holds all of the node pointers
    movl head_ptr, %edi        # current node
    movl $0, %esi              # array index
    movl $0, counter           # counter now holds the temp array size
    
    populate_loop:
        # check if end of list has been reached
        cmpl $0, %edi              
        je populate_end
        
        # store current node pointer in the temp array
        movl %edi, temp_array(,%esi,4)
        incl %esi                 
        incl counter              
        
        # go to next node
        movl NEXT_REF(%edi), %edi
        jmp populate_loop
    
    populate_end:
        ret

_allocation_failed:
    pushl   $msg_error_memory
    call    printf
    addl    $4, %esp
    jmp     _exit

input_type_error_ip:
    pushl   $msg_error_invalid_option
    call    printf
    addl    $4, %esp
    jmp     input_read_type_ip

input_type_error_rp:
    pushl   $msg_error_invalid_option
    call    printf
    addl    $4, %esp
    jmp     remove_product

input_type_error_rr:
    pushl   $msg_error_invalid_option
    call    printf
    addl    $4, %esp
    jmp     registration_report

