# Instituto de Ciencias Matematicas e de Computacao - ICMC/USP
# SSC0112 - Organizacao de Computadores Digitais I
# Turma B - Profa. Sarita Mazzini Bruschi
# 1o Trabalho Pratico: Tabela Hash em Assembly MIPS

# Alunos:
# (4624650) Anna Paula Pawlicka Maule
# (9778619) Beatriz Campos de Almeida de C. Monteiro
# (9763039) Gabriel Toschi de Oliveira
# (9791048) Marcelo de Moraes Carvalho da Silva

### FORMATO DE UM NO DAS LISTAS ENCADEADAS
#   Endereco que aponta para o no <=> endereco que aponta para o primeiro byte do no.
#   Caso algum endereco seja 0, isso indica que essa parte do no nao aponta para lugar nenhum (ponteiro = NULL).
#   Cada no tem 12 bytes, 4 bytes para cada um de seus elementos.
#	+----------+
#	|   PREV   | endereco do no anterior na lista - acessado por 0($rX)
#	+----------+
#       |     N    | elemento presente no no - acessado por 4($rX)
#	+----------+
#	|   NEXT   | endereco do proximo no na lista - acessado por 8($rX)
#	+----------+

### REGISTRADORES "GLOBAIS" (operacoes com eles são indicadas com "RegGlobal")
#   Registradores no formato $sX sao usados para guardar valores globais no programa:
#   --- $s0: indice hash do numero atual, multiplicado por 4 (para permitir um enderecamento a byte facilitado)
#   --- $s1: opcao escolhida no Menu
#   --- $s2: endereco do no encontrado pela ultima busca (caso seja 0, o elemento nao foi encontrado)
#   --- $s3: posicao do elemento encontrado pela ultima busca (caso seja -1, o elemento nao foi encontrado)
#   --- $s4: numero digitado pelo usuario, a ser usado nas funcoes

.data
 	hash:    .space 64 	# Tabela Hash, com 16 posicoes (16 * 4 bytes = 64 bytes)

.align 0  			# alinhando as declaracoes a 2^0 = byte

	# strings para compor o Menu 
 	menu:		.asciiz "1. Insert Key\n2. Remove Key\n3. Search Key\n4. Print Hash\n5. Exit \n"
	option: 	.asciiz "Choose an option: "
	opNotValid: 	.asciiz "Option not valid!\n"
	numNotValid:	.asciiz "Number not valid!\n"
	number: 	.asciiz "Type a number (-1 returns to menu): "
	
	# strings para funcao de Insercao (insert)
	alreadyExists:	.asciiz "This value already is on the hash.\n"
	
	# strings para funcao de Remocao (remove)
	inexistent: 	.asciiz "This value hasn't found on the hash.\n"
	
	# strings para funcao de Busca (search)
	search1:	.asciiz "The element "
	search2: 	.asciiz " is on hash index "
	periodEnter:	.asciiz ".\n"
	
	# strings para funcao de Impressao (printHash)
	space:		.asciiz " "
	enter:		.asciiz "\n"
	separator:	.asciiz ": "

.text	
.globl main 	# main eh a primeira funcao a ser executada no programa

#########################################################################################################		

main:		# FUNCAO: main | funcao principal, controla o fluxo do programa
		jal calloc		# zere toda a tabela hash
					# agora, todos os ponteiros presentes na hash apontam para lugar nenhum

callMenu:	# chama as operacoes de imprimir menu/entradas e controle de opcoes
		j printMenu		# imprima o menu e leia as entradas do usuario

loop_option:	### SUBFUNCAO: loop_option | controle de fluxo para funcoes do programa
		beq $s1, 1, insert	# Insercao: caso a opcao seja 1, insira o numero digitado pelo usuario
		beq $s1, 2, remove 	# Remocao: caso a opcao seja 2, remova o numero digitado pelo usuario
		beq $s1, 3, search 	# Busca: caso a opcao seja 3, procure o numero digitado pelo usuario na hash
		beq $s1, 4, printHash	# Impressao: caso a opcao seja 4, imprima a hash completa		
		beq $s1, 5, exitProgram # Sair: caso a opcao seja 5, termine o programa

exitProgram:	# termina a execucao do programa
		li $v0, 10		# CHAMADA DE SISTEMA: exit (fim de execucao)
		syscall

#########################################################################################################

calloc:		# FUNCAO: calloc | zera todos os espacos da tabela hash
		la $a0, hash		# REGISTRADOR $a0: ponteiro auxiliar que percorre a tabela hash
		li $t1, 0		# REGISTRADOR $t1: contador 0..16 para contar quantos espacos da hash foram zerados
		li $t2, 16		# REGISTRADOR $t2: limite para andar na tabela hash (16 posicoes)

callocLoop:	# comeca a percorrer cada posicao da hash para zerar
		beq $t1, $t2, exitCallocLoop	# caso o contador tenha chegado ao limite, saia do loop
		
		sw $zero, 0($a0)	# zere a posicao apontada atualmente pelo ponteiro auxiliar $a0
		addi $a0, $a0, 4 	# adicione 4 no ponteiro auxiliar, $a0 aponta agora para o proximo espaco da hash
		addi $t1, $t1, 1    	# adicione 1 no contador de espacos percorridos
		j callocLoop		# recomece o loop
	
exitCallocLoop: # fim do loop, todos os espacos da tabela hash estao zerados
		jr $ra			# retorne ao fluxo normal do codigo
		
#########################################################################################################

printMenu:	# FUNCAO: printMenu | imprime o Menu na tela e le as entradas do usuario
		li $v0, 4 		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, menu		# Impressao: opcoes do menu
		syscall 
	
readOption:	# comeca a ler uma opcao, digitada pelo usuario
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, option		# Impressao: "escolha uma opcao"
		syscall 
	
		li $v0, 5 		# CHAMADA DE SISTEMA: read integer (ler inteiro)
		syscall 		# Leitura: opcao escolhida pelo usuario
	
		move $s1, $v0 		# movendo opcao lida para $s1 (RegGlobal)
	
		# testando se a opcao digitada eh valida
		# controlando fluxo, caso precise ser um lido um numero alem da opcao
		beq $s1, 1, readNumber 	# Insercao precisa ler um numero
		beq $s1, 2, readNumber 	# Remocao precisa ler um numero
		beq $s1, 3, readNumber 	# Busca precisa ler um numero
		beq $s1, 4, loop_option # Impressao NAO precisa ler numero, va direto ao controle de opcoes
		beq $s1, 5, loop_option # Sair NAO precisa ler numero, va direto ao controle de opcoes
	
		# caso nao tenha ocorrido desvio no codigo, a opcao eh invalida
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, opNotValid	# Impressao: "opcao invalida"
		syscall 
	
		j readOption		# volte e peca para ser digitada uma nova opcao
		
readNumber:	### SUBFUNCAO: readNumber | ciclo de leitura de numeros para as funcoes do programa
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, number		# Impressao: "digite um numero"
		syscall
	
		li $v0, 5		# CHAMADA DE SISTEMA: read integer (ler inteiro)
		syscall			# Leitura: numero digitado pelo usuario
	
		move $s4, $v0		# movendo numero digitado para $s4 (RegGlobal)

		beq $s4, -1, callMenu 		# caso o numero digitado seja -1, chame novamente o menu para troca de opcao
		blt $s4, $zero, invalidNumber 	# caso o numero seja negativo, o numero eh invalido
	
		# o numero digitado eh valido para uso nas funcoes
		jal hashFunc 		# calculando indice hash para o numero lido, armazena em $s0 (RegGlobal)
		j loop_option		# va ao controle de opcoes
	
invalidNumber:	# caso o numero digitado seja invalido
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, numNotValid	# Impressao: "numero invalido"
		syscall
		
		j readNumber		# volte e peca para ser digitado um novo numero
		
#########################################################################################################

hashFunc:	# FUNCAO: hashFunc | funcao hash, resto da divisao dos numeros inseridos pelo usuario
		li $a1, 16		# REGISTRADOR $a1 = 16, 16 eh o valor do mod, usado na comparacao para fim do loop
		li $a2, -16		# REGISTRADOR $a2 = -16, usado na subtracao do numero
		move $a0, $s4		# REGISTRADOR $a0 = auxiliar que recebe numero digitado pelo usuario
		
mod_startloop:	# inicia o loop de subtracoes sucessivas para calcular o mod
		blt $a0, $a1, mod_endloop # caso o numero ($a0) for menor que o mod ($a1), saia o loop
		add $a0, $a0, $a2	  # $a0 = $a0 + $a2 <=> numero = numero + (-16), numero eh subtraido em 16
		j mod_startloop		  # recomece o loop
	
mod_endloop:	# fim do loop, mod do numero digitado ja foi calculado
		move $s0, $a0		# movendo indice hash para $s0 (RegGlobal)
		
		add $s0, $s0, $s0	# multiplicando o hash index ($s0) por 2, somando ele a si mesmo
		add $s0, $s0, $s0	# multiplicando o hash index ($s0) por 2, somando ele a si mesmo
		
		# com o indice multiplicado por 4, eh possivel acessar, de forma facil e direta, a posicao dele
		# ao soma-lo com o endereco do primeiro byte da tabela hash
		jr $ra			# retorne ao fluxo normal do codigo

#########################################################################################################

search:		# FUNCAO: search | procura um numero na tabela hash para o usuario ou outra funcao do programa

		# encontra o endereco da posicao da tabela hash corresponde ao numero buscado
		la $t0, hash		# REGISTRADOR $t0: endereco do inicio da tabela hash			
		add $t0, $t0, $s0	# soma o numero de bytes a andar a partir do inicio da hash
					# REGISTRADOR $t0: endereco da posicao da hash indicada pelo indice (hash[index])
		lw $t0, 0($t0)		# le o primeiro no da lista encadeada, que esta em hash[index]
					# REGISTRADOR $t0: endereco do primeiro no da lista apontada por hash[index]				

	
							
searchLoop: 	# comeca a percorrer os nos da lista, procurando pelo numero	
		# checa se eh um no valido (diferente de NULL/zero)
		beq $t0, $zero,	searchNotFound	# caso ele tenha encontrado um no vazio na lista antes de encontrar
						# o elemento ou a lista esteja vazia, o elemento nao foi encontrado
	
		# checa se o numero procurado esta dentro do no atual
		lw $t1, 4($t0)			# REGISTRADOR $t1: elemento do no atual
		beq $t1, $s4, searchFound	# caso o elemento do no atual seja igual ao elemento buscado, 
						# o elemento foi encontrado
		
		# caso nao tenha encontrado o numero, movimente-se para o proximo no da lista			
		lw $t0, 8($t0)		# REGISTRADOR $t0: endereco do proximo no da lista (aux = aux->prox)
		j searchLoop		# volte ao inicio do loop, para testar um novo no

		
									
searchNotFound:	# toda a lista foi percorrida e o numero nao foi encontrado
		li $s2, 0		# $s2 aponta para um no invalido, para indicar que a busca falhou (RegGlobal)			
		li $s3, -1		# $s3 recebe -1, para indicar que o numero nao foi achado (RegGlobal)

		beq $s1, 3, searchPrint # caso o comando seja de busca, tambem imprima o resultado			
		jr $ra			# caso nao seja, retorne ao fluxo normal do codigo para a funcao que a chamou


												
searchFound:	# o numero foi encontrado na lista
		move $s2, $t0		# $s2 aponta para o no onde o numero foi encontrado (RegGlobal)				
		move $s3, $s0		# $s3 recebe indice hash em $s0, multiplicado previamente por 4 (RegGlobal)
		div $s3, $s3, 4		# o valor de $s3 eh dividido por 4, mantendo o intervalo 0..15 (RegGlobal)
					
		beq $s1, 3, searchPrint # caso o comando seja de busca, tambem imprima o resultado
		jr $ra			# caso nao seja, retorne ao fluxo normal do codigo para a funcao que a chamou
	
		
				
searchPrint:
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, search1 	# Impressao: "o elemento "...
		syscall
		
		li $v0, 1		# CHAMADA DE SISTEMA: print integer (imprimir inteiro)
		move $a0, $s4   	# Impressao: elemento buscado pelo usuario
		syscall
		
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, search2 	# Impressao: ..." esta no indice hash "...
		syscall
		
		li $v0, 1		# CHAMADA DE SISTEMA: print integer (imprimir inteiro)
		move $a0, $s3  		# Impressao: indice hash do elemento encontrado
		syscall
		
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, periodEnter 	# Impressao: ...".\n" (ponto final + quebra de linha)
		syscall
		
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero

#########################################################################################################

insert:		# FUNCAO: insert | insere um novo numero na tabela hash, de forma ordenada

		la $a1, hash  		# REGISTRADOR $a1: endereco do inicio da tabela hash
		add $a1, $a1, $s0 	# soma o numero de bytes a andar a partir do inicio da hash
					# REGISTRADOR $a1: endereco da posicao da hash indicada pelo indice (hash[index])
	
		jal search 		# procura o numero a ser inserido na tabela hash, resultado em $s2 e $s3 (RegGlobal)
		beq $s2, 0, insertStart # caso o valor ainda nao exista, comece a insercao do numero
	
		# o numero a ser inserido ja esta presente na tabela hash
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, alreadyExists 	# Impressao: "esse numero ja esta na tabela hash"
		syscall 
	
		j readNumber  		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero



insertStart: 	# inicio do processo de insercao do numero na hash

		# alocando um novo espaco de memoria para ser um novo no de lista encadeada
		li $v0, 9   		# CHAMADA DE SISTEMA: sbrk (alocacao de memoria heap)
		li $a0, 12  		# Alocando 12 bytes = tamanho de um no de lista encadeada
		syscall
		
		move $t7, $v0  		# REGISTRADOR $t7: endereco do novo no da lista (novo_no)
		sw $s4, 4($t7) 		# colocando o numero digitado pelo usuario dentro do no (novo_no->n)
		
		lw $t6, 0($a1) 		# le o primeiro no da lista encadeada, que esta em hash[index]
					# REGISTRADOR $t6: endereco do primeiro no da lista apontada por hash[index]
					# $t6 funciona como um ponteiro auxiliar, para percorrer a lista (aux_no)
					
		beq $t6, 0, insertFirst # caso a lista esteja vazia, insira o novo no como primeiro (e unico) da lista



insertNode:	# controla o fluxo de insercao de um no, caso a lista nao esteja vazia
		move $t5, $s4		# REGISTRADOR $t5: numero presente no novo no, digitado pelo usuario
		lw $t4, 4($t6) 		# REGISTRADOR $t4: numero presente dentro do no auxiliar
		
		ble $t5, $t4, insertBeginning 	# caso o numero do novo no seja menor que o primeiro numero da lista,
						# o novo no deve ser inserido no comeco da lista
						
		j loopFindPosition		# caso nao seja, comece a percorrer a lista em busca da posicao correta
	
	
	
insertBeginning: # insere o novo no, com o numero digitado pelo usuario, no comeco da lista e atualiza a tabela hash
		
		sw $zero, 0($t7)	# novo no nao tem nos anteriores (novo_no->prev = NULL)
		sw $t6, 8($t7)		# novo no tem como proximo o antigo comeco da lista (novo_no->next = aux_no)
		sw $t7, 0($t6)		# antigo comeco da lista tem como anterior o novo no (aux_no->prev = novo_no)
		sw $t7, ($a1) 		# tabela hash passa a apontar para o novo no, o novo comeco da lista
		
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero
	
	
			
loopFindPosition: # loop para percorrer a lista e encontrar a posicao em que deve ficar o novo no
		lw $t4, 4($t6)			# REGISTRADOR $t4: numero presente dentro do no auxiliar
		ble $t5, $t4, insertMiddle 	# caso o novo no tenha um numero menor que o auxiliar,
						# insira-o no meio da lista, entre dois outros nos
						
		lw $t3, 8($t6)			# REGISTRADOR $t3: o proximo no, a partir do no auxiliar atual (aux_no->next)
		beq $zero, $t3, insertEnd  	# caso nao exista um proximo no para percorrer a lista,
						# o novo no deve ser inserido ao final da lista, como ultimo no
						
		lw $t6, 8($t6) 		# atualiza no_aux ($t6) com o endereco do proximo no da lista 
		j loopFindPosition	# volte ao inicio do loop, para testar um novo no


		
insertMiddle: 	# insere o novo no, com o numero digitado pelo usuario, no meio da lista, entre dois outros nos
		lw $t3, 0($t6) 		# REGISTRADOR $t3: o no anterior ao no auxiliar atual (aux_no->prev)
		sw $t7, 8($t3) 		# o no a frente do anterior do auxiliar, agora, eh o novo no (aux_no->prev->next = novo_no)
		sw $t3, 0($t7) 		# o anterior ao novo no, agora, eh o anterior do auxiliar (novo_no->prev = aux_no->prev)
		sw $t6, 8($t7)		# o proximo ao novo no, agora, eh o auxiliar (novo_no->next = aux_no)
		sw $t7, 0($t6) 		# o anterior ao no auxiliar, agora, eh o novo no (aux_no->prev = novo_no)
		
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero 



insertEnd:	# insere o novo no, com o numero digitado pelo usuario, ao final da lista, como o ultimo no
		# o no auxiliar (aux_no), neste caso, aponta para o antigo ultimo no da lista
		sw $zero, 8($t7) 	# o novo no nao tem um proximo no, ja que eh o ultimo (novo_no->next = NULL)
		sw $t7, 8($t6) 		# o proximo no do no auxiliar, agora, eh o novo (aux_no->next = novo_no)
		sw $t6, 0($t7) 		# o anterior ao novo no, agora, eh o no auxiliar (novo_no->prev = aux_no)
				
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero  
	
	
					
insertFirst:	# insere o novo no, com o numero digitado pelo usuario, como primeiro no de uma lista ate entao vazia
		sw $t7, ($a1) 		# posicao correspondente da hash, agora, aponta para o novo no (hash[index] = novo_no)
		sw $zero, 0($t7) 	# o novo no nao tem um no anterior, ja que eh o unico (novo_no->prev = NULL)
		sw $zero, 8($t7) 	# o novo no nao tem um proximo no, ja que eh o unico (novo_no->next = NULL)
		
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero

#########################################################################################################

remove:		# FUNCAO | remove: remove um numero da tabela hash, mantendo as listas ordenadas
		jal search 			# procura o numero a ser inserido na hash, resultado em $s2 e $s3 (RegGlobal)
		beq $s2, 0, printNotFound 	# caso o numero nao exista, o elemento nao pode ser removido
	
		la $t3, hash     	# REGISTRADOR $t3: endereco do inicio da tabela hash
		add $t3, $t3, $s0 	# soma o numero de bytes a andar a partir do inicio da hash
					# REGISTRADOR $t3: endereco da posicao da hash indicada pelo indice (hash[index])
	
				
						
deleteNode:	# controla o fluxo de remocao de um no, caso o elemento esteja na lista
		lw $t1, 0($s2) 			# REGISTRADOR $t1: no anterior ao no que vai ser removido (rem_no->prev)
		beq $t1, $zero, firstNode 	# caso o no anterior ($t1) nao exista, o no a ser removido
						# eh o primeiro no da lista, hash tambem deve ser atualizada
		
		lw $t1, 8($s2)			# REGISTRADOR $t1: proximo no ao no que vai ser removido (rem_no->next)
		beq $t1, $zero, lastNode	# caso o proximo no ($t1) nao exista, o no a ser removido
						# eh o ultimo no da lista
		
		# o no a ser removido esta no meio da lista, entre dois outros nos
		lw $t2, 0($s2)  	# REGISTRADOR $t2: no anterior ao no que vai ser removido (rem_no->prev)
		lw $t5, 8($s2)  	# REGISTRADOR $t5: proximo no ao no que vai ser removido (rem_no->next)
		
		sw $t2, 0($t5) 		# o proximo no aponta, como anterior, o anterior do removido
					# (rem_no->next->prev = rem-no->prev) 
				
		sw $t5, 8($t2)  	# o no anterior aponta, como proximo, ao proximo do removido
					# (rem_no->prev->next = rem_no->next)
					
		# nenhum no da lista aponta mais para o elemento buscado, o no buscado foi removido da lista                       	
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero		

	
			
firstNode:	# o no a ser removido eh o primeiro da lista, hash tambem deve ser atualizada
		lw $t1, 8($s2) 		# REGISTRADOR $t1: proximo no ao no que vai ser removido (rem_no->next)  
		beq $t1, $zero, unique 	# caso nao exista um proximo no, o no a ser removido, alem de primeiro,
					# eh o unico no da lista, sua unica ligacao esta na tabela hash
			
		sw $zero, 0($t1)      	# o proximo ao no a ser removido, agora, eh o primeiro no da lista e,
					# portanto, nao tem no anterior (rem_no->next->prev = NULL) 
		sw $t1, 0($t3)    	# alem disso, a hash deve apontar para ele como novo primeiro no da lista
					# tambem (hash[index] = rem_no->next) 

		# nenhum no da lista, nem a hash, apontam mais para o elemento buscado, o no buscado foi removido da lista                       	
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero	



unique: 	# o no a ser removido nao eh so o primeiro da lista, como tambem o unico no da lista
		sw $zero, 0($t3) 	# como o unico no da lista esta sendo removido, a hash nao deve mais
					# apontar para nenhum no (hash[índex] = NULL)
		
		# a hash nao aponta mais para o elemento buscado, o no buscado foi removido da lista                       	
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero	



lastNode:	# o no a ser removido eh o ultimo da lista
		lw $t1, 0($s2) 		# REGISTRADOR $t1: no anterior ao no que vai ser removido (rem_no->prev)
		
		sw $zero, 8($t1)	# o anterior ao no a ser removido, agora, eh o ultimo no da lista e,
					# portanto, nao tem um proximo no (rem_no->prev->next = NULL)
		
		# nenhum no da lista aponta mais para o elemento buscado, o no buscado foi removido da lista                       	
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero

	 	 
	
printNotFound:
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, inexistent 	# Impressao: "esse numero nao esta na tabela hash"
		syscall 
		
		j readNumber		# retorna ao fluxo normal do codigo, pedindo ao usuario um novo numero

#########################################################################################################

printHash:	# FUNCAO | printHash: imprime toda a tabela hash e suas listas encadeadas de colisoes	
		la $t0, hash  		# REGISTRADOR $t0: endereco do inicio da tabela hash
		li $t1, 0 		# REGISTRADOR $t1: contador de indices percorridos da hash, vai de 0 a 16
		li $t8, 16    		# REGISTRADOR $t8: recebe 16 para saber quando o contador $t1 chegou ao limite
	
	
	
printStartLoop:	# inicia o loop que percorre cada indice da hash
		beq $t1, $t8, printEnd	# caso o contador tenha chegado ao limite = 16, o loop termina
		
		lw $t3, 0($t0) 		# REGISTRADOR $t3: no auxiliar para andar na lista de cada posicao da hash
				
		# mostra na tela o indice da hash cuja lista vai ser impressa
		li $v0, 1		# CHAMADA DE SISTEMA: print integer (imprimir inteiro)
		move $a0, $t1		# Impressao: posicao da hash cuja lista vai ser impressa
		syscall
		
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, separator	# Impressao: separador de indices (dois-pontos + espaco) ": "
		syscall
		
		
		
printList:	# inicia o loop que imprime cada no de uma lista da hash
		beq $t3, $zero, printListEnd	# caso o no auxiliar esteja apontando para nada, a lista acabou, fim de loop
		
		lw $t4, 4($t3) 		# REGISTRADOR $t4: numero contido dentro do no auxiliar
		li $v0, 1		# CHAMADA DE SISTEMA: print integer (imprimir inteiro)
		move $a0, $t4 		# Impressao: numero contido dentro do no auxiliar
		syscall
			
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, space		# Impressao: separador de numeros (espaco) " "
		syscall
			
		lw $t3, 8($t3) 	     	# no auxiliar recebe o valor do proximo no, andando na lista
		j printList		# volte ao inicio do loop, para imprimir um novo no
		
		
		
printListEnd:	# loop de impressao de numeros terminados, toda a lista foi impressa
		li $v0, 4		# CHAMADA DE SISTEMA: print string (imprimir string)
		la $a0, enter		# Impressao: quebra de linha "\n"
		syscall

		addi $t1, $t1, 1 	# aumenta o contador de indices percorridos em 1
		addi $t0, $t0, 4	# aumenta o ponteiro para a hash em 4 bytes, acessando o proximo indice
		j printStartLoop	# volte ao inicio do loop, para imprimir uma nova lista, de um novo indice



printEnd: 	# loop de impressao de listas/indicas terminado, toda a hash foi impressa
		j callMenu 		# retorna ao fluxo normal do codigo, pedindo ao usuario uma nova opcao

#########################################################################################################