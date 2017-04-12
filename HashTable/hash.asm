# referencia nesses slides : http://courses.cs.vt.edu/cs2506/Fall2014/Notes/L04.MIPSAssemblyOverview.pdf


.data
 	hash:    .space 64 #alocando memoria pra uma array com 16 posicoes de 4 bytes (endereco tem 4bytes)
 	listSize:.space 64 #vector de 16 posicoes pra armazernar o tamanha de cada lista encadeada
 	#hash:   .word 16  mesma coisa que  .space 64
.align 0  
 	menu:	.asciiz "1. Insert Key\n2. Remove Key\n3. Search Key\n4. Print Hash\n5. Exit \n"
	option: .asciiz "What option: \n"
	notValid: .asciiz "Option not valid! \n" 
.text
# node:   prev (4bytes)
#         valor (4bytes)
#         next  (4bytes)

#usar variaveis para programar, nao armazenar valores nos registradores.
#Leve em conta que

#chamar menu

#ler opcao na main; guarda opcao em um reg Z
#ler valor na main; guardar em um reg X
#calcular index; guardar valor em um reg Y

#fazer um loop pra chamar a funcao de acordo com a escolha do usuario
	

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                                 IMPORTANTE!!!
# usar registradores de $s0 ate $s7 pra salvar valores importantes temporarios
#
# $s0 - Index, mod da funcao hash
# $s1 - opcao do Menu 
# $s2 - 
# $s3 - 
# $s4 -
# $s5 -
# $s6 -
# $s7 - 

#---------------------------------------------------------------------------------
#---------------------------------------------------------------------------------


.globl main
main:
	callMenu:
		jal printMenu 
	
	loop_option:
		
		beq $s1, 1, insert
		
		beq $s1, 2, remove 
		
		beq $s1, 3, search 
		
		beq $s1, 4, printHash
		
		beq $s1, 5, exit_loop
		
		li $v0, 4
		la $a0, notValid
		syscall
		
		j callMenu 
  #
	exit_loop:




calloc:

# $s1 =  returns option
printMenu:
	li $v0, 4 		# system call code for printing string = 4
	la $a0, menu		# load address of string to be printed into $a0
	syscall 
	
	#asking what option
	li $v0, 4
	la $a0, option
	syscall 
	

	li $v0, 5 #reading an interger 
	syscall 
	
	move $s1, $v0
	jr $ra		
	
# $a0 = numero
# $s0 = retorna mod
hashFunc:
	
	li $a1, 16			  # $a1 = 16, 16 eh o valor do mod, usado na comparacao
	li $a2, -16			  # $a2 = -16, usado na subtracao
	
	mod_startloop:	
		blt $a0, $a1, mod_endloop # caso o numero ($a0) for menor que o mod ($a1),
					  # termine o loop
		add $a0, $a0, $a2	  # $a0 = $a0 + $a2; numero = numero + (-16)
		j mod_startloop		  # recomeca o loop
		
	mod_endloop:
		add $v0, $zero, $a0	  # $v0 = $zero + $a0; index = 0 + result; index = result;
		move $s0, $v0		  # movendo valor de $v0 para $s0
		jr $ra			  # retorne a execucao do programa principal
					  # RETORNA em $v0 o resultado do mod
		
			
	

# $a0 = numero a ser buscado
# $v0 = retorno da busca (0 = não esta na tabela, 1 = esta na tabela)
search:
	# ENCONTRAR LISTA DE COLISOES A BUSCAR O ELEMENTO
	jal hashFunc			# chama função hash, que retorna o index em $s0
	la $t0, hash			# REGISTER $t0: endereço da primeira posição da hash
	
	add $s0, $s0, $s0		# multiplicando o hash index ($s0) por 2
	add $s0, $s0, $s0		# multiplicando o hash index ($s0) por 2
					# agora, com o index multiplicado por 4 (numero de bytes no int),
					# eh possivel acessar esse campo na tabela hash
					
	add $t0, $t0, $s0		# soma o numero de bytes a andar a partir do ponteiro
					# do inicio da tabela hash
					# REGISTER $t0: endereco da posicao index da hash (hash[index])
		
	# comeca a busca pelo elemento na lista de colisoes indicada por hash[index]		
	searchLoop:
		# CHECAR A VALIDADE DO NÓ ATUAL	
		beq $t0, $zero,	searchNotFound	# caso ele tenha encontrado um no vazio na lista
						# antes de encontrar o elemento ou a lista esteja
						# vazia, o elemento nao foi encontrado
		
		# CHECAR SE O ELEMENTO PROCURADO ESTÁ NO NÓ ATUAL
		lw $t1, 4($t0)			# REGISTER $t1: elemento do nó atual
		beq $t1, $a0, searchFound	# caso o elemento do no atual seja igual ao
						# elemento buscado, o elemento foi encontrado
		
		# MOVIMENTACAO SEQUENCIAL PELA LISTA			
		lw $t1, 8($t0)			# REGISTER $t1: endereço do próximo nó da lista
		move $t1, $t0			# REGISTER $t0: endereco do nó atual agora é o próximo
						# assim, é possivel percorrer a lista nó a nó
		j searchLoop			# volte ao inicio do loop, para testar um novo nó
					
	searchNotFound:
		li $v0, 0		# colocando 0 em $v0 para indicar que o elemento nao esta na tabela hash
		jr $ra			# retorna a execucao do programa principal
					# RETORNA $v0 = 0, para indicar que o numero nao foi achado
					
	searchFound:
		li $v0, 1		# colocando 1 em $v0 para indicar que o elemento esta na tabela hash
		jr $ra			# retorna a execucao do programa principal
					# RETORNA $v0 = 1, para indicar que o numero foi achado
	
#s1 = index 
insert:
	
	j callMenu


#valor = registar X ; hash - variavel global; listSize - var global ; index - registrador Y
remove:
	j callMenu

#
printHash:
	j callMenu
