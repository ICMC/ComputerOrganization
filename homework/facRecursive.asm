# inteiro positivo n. (Ex: 0! = 1;  3! = 3*2*1 = 6) */
# c�digo em C
#
# #include <stdio.h>
# #include <conio.h>

# int fatorial(int K)
# {
#    if (K==0)
#         return(1);
#
#    return(fatorial(K-1)*K);
# }
#
# void main()
# {
#  	int K=3;
#
#  	printf("O fatorial de %d e' %d\n", K, fatorial(K));
#
#    getch();
# }
#*******************************************************************
            .data
            .align 0
strfat:     .asciiz "O fatorial de "
streh:      .asciiz " eh "

            .text
            .globl main   
main:       li $a0, 6          # $a0 tem o valor a ser calculado o fatorial
            la $s0, strfat     # salva em $s0 o endereco de strfat para impressao
            la $s1, streh      # salva em $s1 o endereco de streh  para impressao

            jal  fatorial		# chama a funcao fatorial
            move $t1, $v0       # salva em $t1 o resultado do fatorial

            move $t0, $a0       # salva em $t0 o valor sobre o qual foi calculado o fatorial

			li $v0, 4              # c�digo da rotina para impress�o da string
            move $a0, $s0       # obtem endereco de strfat para impressao
            syscall             # impress�o da string strfat

            li $v0, 1           # c�digo da rotina para impress�o do inteiro
            move  $a0, $t0      # $a0 recebe o num. sobre o qual foi calculado o fatorial
            syscall

            li $v0, 4                  # c�digo da rotina para impress�o da string
            move $a0, $s1        # obtem endereco de streh para impressao
            syscall

            li $v0, 1               # c�digo da rotina para impress�o do inteiro
            move  $a0, $t1     # $a0 recebe resultado do fatorial para impressao
            syscall

            li $v0, 10           # fim do programa
            syscall

            #******************************************************************
            # aqui termina a fun��o principal (main). Comeca a fun��o fatorial
            #******************************************************************

fatorial:   addi $sp, $sp,-8   # decrementa $sp de acordo com o numero de registradores salvos
            sw $a0, 4($sp)     # salva $a0 na pilha
            sw $ra, 0($sp)     # salva $ra na pilha

            beq $a0, $zero, retorna1   # retorna o valor 1 para a funcao chamadora

            addi $a0, $a0, -1   # decrementa $a0 em 1 unidade
            jal fatorial        # chama funcao fatorial com k-1 como argumento
            addi $a0, $a0, 1    # incrementa $a0 em 1 unidade

			mult $v0, $a0		#   
			mflo $v0			# $v0 = fatorial(k-1)*k

            j retornafat        # salta a atribuicao de 1 para o resultado

retorna1:
			addi $v0, $zero, 1  # atribui 1 como valor de retorno

retornafat: 
			lw $a0, 4($sp)      # recupera $a0 da pilha
            lw $ra, 0($sp)      # recupera $ra da pilha
            addi $sp, $sp, 8	# decrementa $sp de acordo com o numero de registradores salvos
            jr $ra              # retorna para quem chamou a funcao fatorial
			#*********************************************************************
