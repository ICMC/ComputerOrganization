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
#   Endereco que aponta para o no <=> endereco que aponta para o primeiro byte do no
#   Caso algum endereco seja 0, isso indica que essa parte do no nao aponta para lugar nenhum (ponteiro = NULL)
#	+----------+
#	|   PREV   | endereco do no anterior na lista - acessado por 0($rX)
#	+----------+
#       |     N    | elemento presente no no - acessado por 4($rX)
#	+----------+
#	|   NEXT   | endereco do proximo no na lista - acessado por 8($rX)
#	+----------+

### REGISTRADORES "GLOBAIS" (operacoes com eles são indicadas com "RegGlobal")
#   Registradores no formato $sX sao usados para guardar valores globais no programa
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
	number: 	.asciiz "Type a number (-1 to exit): "
	
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
		lw $t0, 8($t0)			# REGISTRADOR $t0: endereco do proximo no da lista (aux = aux->prox)
		j searchLoop			# volte ao inicio do loop, para testar um novo no
					
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
