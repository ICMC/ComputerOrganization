.data 
.align 0 
	string1: 	.asciiz "palavra"
	string2:	.asciiz "palavra"
	true: 		.asciiz "strings are equal"
	false: 		.asciiz "strings are NOT equal"
	
.text 
.globl main 

main:
#String Compare 

	la $t0, string1
	la $t1, string2 
	
	
	
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