# referencia nesses slides : http://courses.cs.vt.edu/cs2506/Fall2014/Notes/L04.MIPSAssemblyOverview.pdf


.data
 	hash:    .space 64 #alocando memoria pra uma array com 16 posicoes de 4 bytes (endereco tem 4bytes)

.align 0  
 	menu:		.asciiz "1. Insert Key\n2. Remove Key\n3. Search Key\n4. Print Hash\n5. Exit \n"
	option: 	.asciiz "Choose an option: "
	opNotValid: 	.asciiz "Option not valid!\n"
	numNotValid:	.asciiz "Number not valid!\n"
	inexistent: 	.asciiz "This value hasn't found on the hash.\n"
	search1:	.asciiz "The element "
	search2: 	.asciiz " is on hash index "
	alreadyExists:	.asciiz "This value already is on the hash.\n"
	number: 	.asciiz "Insert another number (-1 returns to menu):\n"
	delete:		.asciiz "Remove another number (-1 returns to menu): \n"
	wNumber:        .asciiz "What number?\n"
	space:		.asciiz " "
	enter:		.asciiz "\n"
	periodEnter:	.asciiz ".\n"
	separator:	.asciiz ": "
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
# $s0 - Index, mod da funcao hash, multiplicado por 4 (enderecamento a byte)
# $s1 - opcao do Menu 
# $s2 - noh encontrado pela busca
# $s3 - posicao da hash do no da ultima busca (-1 se nao foi encontrado)
# $s4 - number provided by the user 
# $s5 -
# $s6 -
# $s7 - 

#---------------------------------------------------------------------------------
#---------------------------------------------------------------------------------

.globl main
main:
	callMenu:
		j printMenu 
	
	loop_option:
		
		beq $s1, 1, insert
		
		beq $s1, 2, remove 
		
		beq $s1, 3, search 
		
		beq $s1, 4, printHash
		
		beq $s1, 5, exitProgram
			
	exitProgram:
		li $v0, 10
		syscall

calloc:
	la $a0, hash #loadnig the beginning of the string address to $a0
	li $t0, 0
	li $t1, 0
	#set all spaces allocated to hash to 0
	li $t2, 16
	li $t3, 2
	callocLoop:
	
		beq $t1,$t2, exitCallocLoop
			sw $zero, 0($a0)
			add  $a0, $t3,$t3 # add 4 to $a0
			addi $t1,$t1,1    # add +1 to $t1
		j callocLoop
	exitCallocLoop:
	jr $ra	
		

# $s1 =  returns option
printMenu:
	li $v0, 4 		# system call code for printing string = 4
	la $a0, menu		# load address of string to be printed into $a0
	syscall 
	
readOption:
	#asking what option
	li $v0, 4
	la $a0, option
	syscall 
	
	li $v0, 5 #reading an interger 
	syscall 
	
	move $s1, $v0 #moving op to $s1
	
	# testando para ver se a opcao eh valida
	beq $s1, 4, loop_option # print nao precisa ler numero
	beq $s1, 5, loop_option # sair nao precisa ler numero
	
	li $v0, 4
	la $a0, wNumber
	syscall
	
	beq $s1, 1, readNumber # insercao precisa ler um numero
	beq $s1, 2, readNumber # remocao precisa ler um numero
	beq $s1, 3, readNumber # busca precisa ler um numero
	
	# caso o beq nao tenha ocorrido, opcao eh invalida
	li $v0, 4
	la $a0, opNotValid
	syscall 
	
	j readOption
		
		
readNumber:
	
	li $v0, 5	# read a number typed by the user
	syscall
	
	move $s4, $v0	# REGISTER $s4: numero digitado pelo usuario

	beq $s4, -1, callMenu 	# troque de operacao, chame novamente o menu
	blt $s4, $zero, invalidNumber # checa se o numero eh inteiro positivo
	
	# numero valido
	jal hashFunc # calculating hash index for the input number
	             # $s0 have the index
	j loop_option	# chame a operacao pedida pelo usuario
	
	invalidNumber:
		li $v0, 4
		la $a0, numNotValid
		syscall
		
		j readNumber


	
# $s4 = numero
# $s0 = retorna mod
hashFunc:
	
	li $a1, 16			  # $a1 = 16, 16 eh o valor do mod, usado na comparacao
	li $a2, -16			  # $a2 = -16, usado na subtracao
	move $a0, $s4		          # $a0 = numero digitado pelo usuario
	
	mod_startloop:	
		blt $a0, $a1, mod_endloop # caso o numero ($a0) for menor que o mod ($a1),
					  # termine o loop
		add $a0, $a0, $a2	  # $a0 = $a0 + $a2; numero = numero + (-16)
		j mod_startloop		  # recomeca o loop
		
	mod_endloop:
		move $s0, $a0		  # movendo valor de $a0 para $s0
		
		add $s0, $s0, $s0		# multiplicando o hash index ($s0) por 2
		add $s0, $s0, $s0		# multiplicando o hash index ($s0) por 2
						# agora, com o index multiplicado por 4 (numero de bytes no int),
						# eh possivel acessar esse campo na tabela hash
		
		jr $ra			  # retorne a execucao do programa principal
					  # RETORNA em $s0 o resultado do mod
	

# $s4 = numero a ser buscado
# $s2 = retorna endereco do no encontrado pela busca
# caso nao encontre, retorne 0 em $s2
search:
	# EMPILHA ARGUMENTOS
	addi $sp, $sp, -8		# aumenta tamanho da pilha em 8 bytes
	sw $s4, 4($sp)			# salva na STACK: 4($sp) = $s4 = numero a ser buscado
	sw $ra, 0($sp)			# salva na STACK: 0($sp) = $ra = endereco de retorno da funcao

	# ENCONTRAR LISTA ENCADEADA A BUSCAR O ELEMENTO
	la $t0, hash			# lendo endereco do inicio da tabela hash			
	add $t0, $t0, $s0		# soma o numero de bytes a andar a partir do ponteiro
					# do inicio da tabela hash
					# REGISTER $t0: endereco da posicao index da hash (hash[index])
					
	lw $t0, 0($t0)			# le o primeiro no da lista encadeada, que esta em hash[index]
					# REGISTER $t0: endereco do primeiro no da lista apontada por hash[index]				
		
	# INICIA BUSCA NA LISTA ENCADEADA PELO ELEMENTO PROCURADO		
	searchLoop:
		# CHECAR A VALIDADE DO NO ATUAL	
		beq $t0, $zero,	searchNotFound	# caso ele tenha encontrado um no vazio na lista
						# antes de encontrar o elemento ou a lista esteja
						# vazia, o elemento nao foi encontrado
		
		# CHECAR SE O ELEMENTO PROCURADO ESTA NO NO ATUAL
		lw $t1, 4($t0)			# REGISTER $t1: elemento do no atual
		beq $t1, $s4, searchFound	# caso o elemento do no atual seja igual ao
						# elemento buscado, o elemento foi encontrado
		
		# MOVIMENTACAO SEQUENCIAL PELA LISTA			
		lw $t0, 8($t0)			# REGISTER $t1: endereco do proximo no da lista
						# assim, eh possivel percorrer a lista no a no
		j searchLoop			# volte ao inicio do loop, para testar um novo no
					
	searchNotFound:
		li $s2, 0		# colocando 0 em $s2 para indicar que o elemento esta em um no invalido
					# RETORNA $s2 = 0, para indicar que o numero nao foi achado
					
		li $s3, -1		# colocando -1 em $s3 para indicar que o elemento nao esta na hash
					# RETORNA $s3 = -1, para indicar que o numero nao foi achado

		beq $s1, 3, searchPrint # caso o comando seja de busca, imprima o resultado			
		
		j searchReturn		# inicia retorno da funcao
						
	searchFound:
		move $s2, $t0		# colocando o endereco do no buscado em $s2
					# RETORNA $s2 = $t0, para indicar o no onde esta o numero procurado
					
		move $s3, $s0		# $s3 recebe o index da tabela hash, multiplicado por 4
		div $s3, $s3, 4		# RETORNA $s3 = $s0 / 4, para indicar o indice da hash onde esta o numero buscado
					
		beq $s1, 3, searchPrint # caso o comando seja de busca, imprima o resultado
		
		j searchReturn		# inicia retorno da funcao
		
	searchPrint:
		li $v0, 4
		la $a0, search1 # print "The element "...
		syscall
		
		li $v0, 1
		move $a0, $s4   # print the element searched by the user
		syscall
		
		li $v0, 4
		la $a0, search2 # print ..." is on hash index "...
		syscall
		
		li $v0, 1
		move $a0, $s3   # print the hash index, search result
		syscall
		
		li $v0, 4
		la $a0, periodEnter # print ...".\n"
		syscall
		
		j searchReturn
		
	searchReturn:
		lw $s4, 4($sp)		# recupere da STACK: $a0 = numero a ser buscado
		lw $ra, 0($sp)		# recupere da STACK: $ra = endereco de retorno da funcao
		addi $sp, $sp, 8	# retorna pilha ao tamanho original
		
		beq $s1, 3, readNumber  # caso o comando seja de busca, retorne ao menu de leitura de numeros
		jr $ra			# caso nao seja, continue o fluxo do codigo
	
#s1 = index 
insert:

	la $a1, hash  # moving address of the beginning of hash to $a0
	add $a1, $a1, $s0 # atribui a a1 a posicao da hash que o novo no sera inserido
	
	jal search # verifica se ainda  nao existe no com esse valor
	
	beq $s2, 0, isntInHashYet # se ainda nao existir o valor lido, cria no
	
	# ja existe o valor lido
	li $v0, 4
	la $a0, alreadyExists #prints that the value exists on the hash
	syscall 
	
	j endInsert  

	isntInHashYet: 

		# create new node
		#use instruction syscall 9 to allocate memory on the heap 
		li $v0, 9   #instruction to allocate memory on the heap 
		li $a0, 12  #tells how much space has to be allocated  (4 next, 4 previous, 4 int)
		syscall
		
		move $t7, $v0  # address of the new node is moved to $t7 
		sw $s4, 4($t7) # sets nodes value to the value that $s4 contains new_node->n
		
		lw $t6, ($a1) #sets $t6 the content of $a1
		beq $t6, 0, insertFirstNode #check if the list is null
		
# node:   prev (4bytes)
#         valor (4bytes)
#         next  (4bytes)

	insertNode:
		lw $t5, 4($t7)# gets value of new node
		lw $t4, 4($t6) # get content of the hash in the auxiliar node
		ble $t5, $t4, insertBeginning #(brench if less or equal) if the new node's position is the begining
		j loopFindPosition
	
	insertBeginning:
		
		sw $zero, 0($t7) # new-node->prev = NULL
		sw $t6, 8($t7)#  novo_no->next = ex_primeiro da lista
		sw $t7, 0($t6)# ex primeiro no->previous = novo no
		sw $t7, ($a1) #storing the address of the first node on hash[index]
		
		j endInsert 
		
	loopFindPosition:
	
		lw $t4, 4($t6)		   # pegando o n do no auxiliar atual
		ble $t5, $t4, insertMiddle #(brench if less or equal) if new node < aux
		lw $t3, 8($t6)		   # pegando o proximo do no auxiliar atual
		beq $zero,$t3, insertEnd   #if node-> next == NULL exit loop 
		lw $t6, 8($t6) #acessing node->next  
		j loopFindPosition
	
	insertMiddle: 
		lw $t3, 0($t6) #get aux->prev
		sw $t7, 8($t3) #aux->prev->next = new_node
		sw $t3, 0($t7) # new-node->prev = aux->prev
		sw $t6, 8($t7)#  new_node->next = aux
		sw $t7, 0($t6) # aux->prev = new_node
		
		j endInsert 

	insertEnd:
		sw $zero, 8($t7) #new_node->next = NULL
		sw $t7, 8($t6) # aux->next = new_node
		sw $t6, 0($t7) # new-node->prev = aux
				
		j endInsert 
		
	insertFirstNode:
		
		sw $t7, ($a1) #storing the address of the first node on hash[index]
		sw $zero, 0($t7) #setting node->prev as NULL
		sw $zero, 8($t7) #setting node->next as NULL
		
		j endInsert
		
	endInsert:
		li $v0, 4
		la $a0, number
		syscall
		
		j readNumber
			

#s0 == index 
#s2 - node returned by the search()
remove:	

	jal search # verifica se ainda  nao existe no com esse valor
	beq $s2, 0, printNotFound # se ainda nao existir o valor lido, printe uma mensagem
	
	la $t3, hash     #loading address of hash to $t3

	add $t3, $t3, $s0 #adding the index to the hash address to get to the address where is the node to be deleted. 
	
	#$s4 contains value to be deleted 
	move $t4, $s2 
	
	deleteNode:
		lw $t1, 0($s2) 
		beq $t1, $zero, firstNode #id node->prev == 0 then it's the first node to be deleted 
		
		lw $t1, 8($s2)
		beq $t1, $zero, lastNode
		
		# exemple of linked list : a<->b<->c
		# b is being deleted 
		#middle node:
		lw $t2, 0($s2)  # geting the address of node 'a' 
		lw $t5, 8($s2)  # getting address of node 'c'
		
		sw $t2, 0($t5) 	# previous of node 'c' is node 'a'
		sw $t5, 8($t2)  # next of node 'a' is node 'c' 
	                        # this way completing the deletion of node 'b'
		j endRemove  
	
		# exemple of linked list: (head)->a->b->c
		# 'a' is being deleted 
		firstNode:
			lw $t1, 8($s2) # $t1 = a->next  
			beq $t1, $zero, unique #its the unique node on the list because node->next ==0 
			
			la $t5, 0($t1) # $t5 = b->prev 
			sw $zero, 0($t5)      # $t5 = b->prev = 0 
			sw $t5, 0($t3)    #hash[index] = next node of the one that is being deleted from the front 

			j endRemove 
			 	
		unique: 
			sw $zero, 0($t3) #sets zero to the hash[index] , meaning that there is no node in there 
			j endRemove 
		
		# exemple of linked list: (head)->a->b->c	
		# 'c' is being deleted 
		lastNode:
			
			lw $t1, 0($s2) # $t1 = c->prev  
			la $t1, 8($t1) # $t1 =  b->next  
			sw $zero , 0($t1)     # b->next = 0
			j endRemove  
	
	printNotFound:
		li $v0, 4
		la $a0, inexistent #prints that the value does not exists on the hash
		syscall 
		
	
	endRemove:
		li $v0, 4
		la $a0, delete 
		syscall
		
		j readNumber #returns to menu

	
		      
#loop que percorre a hash 
printHash:	
		la $t0, hash  #endereco da primeria posicao de hash em $t0
		li $t1, 0 #t1 variavel contadora (i), vai ate 16(numero de posicoes na hash), para percorrer a hash
		li $t8, 16    #usado para comparacao
		      #for(i=0; i<16; i++)
	
	printStartLoop:
		beq $t1, $t8, printEnd	#sai caso $t1 == 16
		lw $t3, 0($t0) #recebe o endereco da primeiro no     
				
		#printa a posição na hash
		move $a0, $t1
		li $v0, 1
		syscall
		#printa os dois pontos e o espaço ": "
		la $a0, separator
		li $v0, 4
		syscall
		
		#loop que imprime os valores contidos na lista
		printList:
			#t3 = variavel que percorre os valores da lista
			beq $t3, $zero, printListEnd #caso o valor seja NULL
			lw $t4, 4($t3) #$t4 recebe o valor contido no nó
		
			move $a0, $t4 		     #coloca o valor contido no nó em $a0, para realizar o print
			li $v0, 1		     #print int
			syscall
			
			#printa o espaco entre os numeros
			la $a0, space
			li $v0, 4
			syscall
			
			lw $t3, 8($t3) 	     #$t3 recebe o endereco do next, do prox no da lista
			j printList		     #volta para o inicio do loop
		printListEnd:		   	     #fim do loop de leitura da lista
		#printa o \n 
		la $a0, enter
		li $v0, 4
		syscall

		addi $t1, $t1, 1 	#i++
		addi $t0, $t0, 4	#t0 move para o proximo HEAD da Hash
		j printStartLoop	#volta para o inicio do loop
	printEnd: 
	
	j callMenu
