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

#$s0 = index 
#$s1 = option 
#$s2 = node 
#


.globl main
main:
	jal calloc
	
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
	la $a0, hash #loadnig the beginning of the string address to $a0
	li $t1, 0
	#set all spaces allocated to hash to 0
	li $t2, 16
	li $t3, 2
	callocLoop:
		beq $t1,$t2, exitCallocLoop
		lw $t1, 0($a0)
		add  $a0, $t3,$t3 # add 4 to $a0
		addi $t1,$t1,1    # add +1 to $t1
	j callLoop
	exitCallocLoop:
	jr $ra	
		

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
		move $s0, $v0		  # move o valor de $v0 para $s0
		jr $ra			  # retorne a execucao do programa principal
					  # RETORNA em $v0 o resultado do mod
		
			
	

search:

	j callMenu


insert:
	la $a1, hash  # moving address of the beginning of hash to $a0
	
	#use instruction syscall 9 to allocate memory on the heap 
	li $v0, 9   #instruction to allocate memory on the heap 
	la $a0, 12  #tells how much space has to be allocated 
	syscall 
	
	move $s2, $v0 #moving temporary node to $s2 register 
	
	add $t1, $s0, $s0 #multiplying the index by 2x
	add $t1, $t1, $t1 # multiplying the index by 2x again (4x)
	add $a1, $a0, $t1 # getting the address of hash[index]
	
	beq $a1,0,empty #if there is no node(key) inserted on that position of the hash
	j initialized
	
	empty:
		sw $s2, 0($a1) #storing the address of the first node on hash[index]
		li $t1, 0
		sw $t1, 0($s2) #setting node->prev as NULL
		sw $t1, 8($s2) #setting node->next as NULL
		
	
	initialized: # if there is already nodes on that position of the hash
	
	
	
	
	j callMenu


#valor = registar X ; hash - variavel global; listSize - var global ; index - registrador Y
remove:
	j callMenu

#
printHash:
	j callMenu
