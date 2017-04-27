# CODIGO ASSEMBLY PARA O CALCULO DO FATORIAL NAO RECURSIVO
#
#void main()  {
#int n, fat, cont;
#
#   n = 1;
#
#   printf("Digite um numero para o fatorial:");
#   scanf("%d", &n);
#
#   fat = 1;
#   cont = n;
#   while (cont > 1)	{
#	fat = fat * cont--;
#   }
#
#   printf("O fatorial de %d eh: %d", n, fat);
#   getch();
#
#}
#
#
	.data		# inicia o segmento de dados
	.align 0	# determina o alinhamento dos bytes (2 elevado a 0)
strinicio:
	.asciiz "Digite um numero para o fatorial: "
strresp:
	.asciiz "O fatorial de "
strresp2:
	.asciiz " eh :"


	.text		# inicia o segmento de texto
	.globl main	# determina que o identificador main � global

main:
	li $v0, 4		# codigo da chamada de sistema que imprime string
	la $a0, strinicio	# string a ser impressa
	syscall		# chamada do sistema operacional

	li $v0, 5		# codigo da chamada de sistema que le um inteiro
	syscall			# chamada do sistema operacional

	#add $t3, $zero, $v0	# salva o valor inteiro lido em $t3  (EH O VALOR DE N)
	move $t3, $v0

	addi $t4, $zero, 1	# atribui 1 ao registrador $t4  (EH O FAT RECEBENDO 1)
	#add $t5, $zero, $t3     # move o valor de N para cont
	move $t5, $t3
	addi $t6, $zero, 1	# atribui 1 ao registrador $t6. Usado na repeticao como parada

loopfat:			# loop para o calculo do fatorial 
	ble $t5, $t6, endloop   # condicional que marca o inicio do while

	mul $t4, $t4, $t5	# fat = fat * cont
        addi $t5, $t5, -1	# cont--
   	j loopfat

endloop:
	# impressao do resultado

	li $v0, 4		# codigo da chamada de sistema que imprime string
	la $a0, strresp		# string de resposta a ser impressa
	syscall			# chamada do sistema operacional

	li $v0, 1		# codigo da chamada de sistema que imprime um inteiro
	move $a0, $t3		# inteiro a ser impresso
	syscall			# chamada do sistema operacional

	li $v0, 4		# codigo da chamada de sistema que imprime string
	la $a0, strresp2	# string de resposta a ser impressa
	syscall			# chamada do sistema operacional

	li $v0, 1		# codigo da chamada de sistema que imprime um inteiro
	move $a0, $t4		# inteiro a ser impresso
	syscall			# chamada do sistema operacional

	li $v0, 10		# codigo da chamada de sistema que sai do programa (exit)
	syscall			# chamada do sistema operacional
