.data 
	str1: 		.space 20
	str2: 		.space 20
.align 0 
	
	input1 :	.asciiz "type string 1: \n" 
	input2:         .asciiz "\n type string 2: \n" 
	string1: 	.asciiz "palavra"
	string2:	.asciiz "palavra"
	true: 		.asciiz "strings are equal"
	false: 		.asciiz "strings are NOT equal"
	
.text 
.globl main 

main:
#String Compare 
	
	li $v0, 4 # printing string 
	la $a0, input1 
	syscall
	
	li $v0, 8 #reading string
	la $a0, str1 #buffer  
	li $a1, 19 #saying the max size of the string 
	syscall 
	
	li $v0, 4 # printing string 
	la $a0, input2 
	syscall
	
	li $v0, 8 #reading string
	la $a0, str2 #buffer  
	li $a1, 19 #saying the max size of the string 
	syscall 
	
	la $t0, str1
	la $t1, str2 
	
	
	
        loop:
        	lb $s0, 0($t0)
        	lb $s1, 0($t1)
        	bne $s0, $s1, notEqual 
 
        	beq $s0, 0, Equal
        	
        	add $t0,$t0, 1 
        	add $t1, $t1, 1 
        	
        	j loop
        	
       Equal :
       		li $v0, 4 		# system call code for printing strings
		la $a0, true 		# load address of string to be printed into $a0
		syscall 
		
		j end
       notEqual:
       		li $v0, 4 		# system call code for printing string 
		la $a0, false		# load address of string to be printed into $a0
		syscall 
		
       end: