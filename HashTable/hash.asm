# referencia nesses slides : http://courses.cs.vt.edu/cs2506/Fall2014/Notes/L04.MIPSAssemblyOverview.pdf


.data
 	hash:    .space 64 #alocando memoria pra uma array com 16 posicoes de 4 bytes (endereco tem 4bytes)
 	listSize:.space 64 #vector de 16 posicoes pra armazernar o tamanha de cada lista encadeada
 	#hash:   .word 16  mesma coisa que  .space 64
.align 0  
 	menu:		.asciiz "1. Insert Key\n2. Remove Key\n3. Search Key\n4. Print Hash\n5. Exit \n"
	option: 	.asciiz "What option: \n"
	notValid: 	.asciiz "Option not valid! \n" 
	inexistent: 	.asciiz "Value not found on the hash!\n"
	number: 	.asciiz "what number: \n"
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
# $s4 - number provided by the user 
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
	
	li $v0, 4
	la $a0, number 
	syscall 
	
	li $v0, 5 
	syscall 
	
	move $s4, $v0
	
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
		
		# CHECAR SE O ELEMENTO PROCURADO EST�? NO NÓ ATUAL
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

	jal hashFunc #chama funcao hash -> obtenho index endereco ta no s0

	li $v0, 5 #reading an interger ( cade o syscall ? porque esta lendo uma interger???)

	la $a1, hash  # moving address of the beginning of hash to $a0
	mul $t1, $s0, 4 #s0 tem valor do index (x4, pois um int tem 4 bytes)
	add $a1, $a1, $t1 # atribui a a1 a posicao da hash que o novo no sera inserido

	la $a2, listSize # encontra posicao do vetor com o tamanho de cada lista
	add $a2, $a2, $t1	
	
	jal search # verifica se ainda  nao existe no com esse valor
	
	beq $s1, -1, checkEmpty # se ainda nao existir o valor lido, cria no
	

	checkEmpty: #nome dessa tag esta ambigua, parece que esta verificando se nao existe nenhum node 

		# create new node
		#use instruction syscall 9 to allocate memory on the heap 
		li $v1, 9   #instruction to allocate memory on the heap 
		la $a0, 12  #tells how much space has to be allocated  (4 next, 4 previous, 4 int)
		syscall
		move 4($a0), $v0 #atribui valor lido a new_node->value

		move $s2, $v1 #moving temporary node to $s2 register 	
		
		beq $a2, 0, insertFirstNode #check if the list is null
		
# node:   prev (4bytes)
#         valor (4bytes)
#         next  (4bytes)

	insertNode:

		move $t6, $a1 #movind the address of the first node on hash[index]
		ble 4($a0), 4($t6), insertBeginning #(brench if less or equal) if the new node's position is the begining
		j loopFindPosition
	
	insertBeginning:
		
		move $a1, $a0 # novo no se torna primeiro da lista
		la 8($a1), $t6 #  novo_no->next = ex_primeiro da lista
		la 0($t6), $a1 # ex primeiro no->previous = novo no
		add $a2, $a2, 1 # soma 1 no listSize (conta elementos das listas)
		j call menu
		
	loopFindPosition:
	
		ble 4($a0), 4($t6), insertMidle #(brench if less or equal) if new node < aux
		beq $t1,$t6, insertEnd #if node-> next == NULL exit loop 
		la $t6, 8($t6) #acessing node->next  
		j loopFindEnd
	
	inserMidle:
		
		la 0($a0), 0($t6) #new_node->prev = aux->prev
		la 0($t6), $a0 # aux->prev = new_node
		la 8($a0), $t6 # new_node->next = aux

		j callMenu

	insertEnd:

		la 0($a0), $t6 #new_node->prev = aux
		la 8($t6), $a0 #aux->next = new_node
		

	insertFirstNode:
		sw $s2, ($a1) #storing the address of the first node on hash[index]
		li $t1, 0
		sw $t1, 0($s2) #setting node->prev as NULL
		sw $v0, 4($s2) #setting node->value
		sw $t1, 8($s2) #setting node->next as NULL
		
		add $a2, $a2, 1 # soma 1 no listSize (conta elementos das listas)
	
		j callMenu		


#s0 == index 
remove:	
	jal hashFunc #chama funcao hash -> obtenho index endereco ta no s0
	jal search # verifica se ainda  nao existe no com esse valor
	beq $s1, -1, printNotFound # se ainda nao existir o valor lido, cria no
	
	li $t2, 4  
	mul $t1, $s1, $t2 #multiplying the index by 4 to find the "Real index" on the hash 
			  #Another possibility is to change the hashFunc to return the mod multiplied by 4 , which will be the real address 
	
	la $t3, hash     #loading address of hash to $t3

	add $t3, $t3, $t2 #adding the index to the hash address to get to the address where is the node to be deleted. 
	
	#loop to find the node to be deleted on the linked list 
	
	move $t4, $t3 
	
	FindNode: 
		lw $t5, 4($t4) 
		beq $t5, $s4, deleteNode
		la $t4, 8($t4) # $t4 = $t4->next 
		j FindNode 
	
	deleteNode:
		lw $t1, 0($t4) 
		li $t2, 0
		
		beq $t1, $t2, firstNode #id node->prev == 0 then it's the first node to be deleted 
		
		lw $t1, 8($t4)
		beq $t1, $t2, lastNode
		
		
		#middle node:
		la $t2, 0($t4)  # getting address of the previous node of the one is being deleted 
		la $t5, 8($t2)  # getting address to node-> next
		lw $t5, $t1 	# setting the next node to be the next of the one is being deleted 
		la $t6, 0($t1)  # getting the address where is stored the address of the previous node 
		lw $t6, $t2     # setting the previous node to be the previous node of the deleted one 
		j callMenu 
		
		
		firstNode:
			lw $t1, 8($t4) # $t1 = $t4 -> next 
			beq $t1, $t2, unique #its the unique node on the list because node->next ==0 
			la $t5, 0($t1) # $t5 = $t1->prev 
			lw $t5, 0      # $t5 = $t1->prev = 0 
			lw $t3, $t5    #hash[index] = next node of the one that is being deleted from the front 
			
			j callMenu
			 	
		unique: 
			lw $t3, 0 #sets zero to the hash[index] , meaning that there is no node in there 
			j callMenu 
			
		lastNode:
			la $t1, 0($t4) #address of nodeDelete->prev =  $t1
			la $t1, 8($t1) # address of  $t1->next 
			lw $t1, 0      # set $t1->next == 0 == NULL
			j callMenu 
	
	printNotFound:
		li $vi, 4
		la $a0, inexistent #prints that the value does not exists on the hash
		syscall 
		
		j callMenu #returns to menu 
	

#
printHash:
	j callMenu
