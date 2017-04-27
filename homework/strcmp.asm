.data 
.align 0 
	string1: 	.asciiz "palavra"
	string2:	.asciiz "word"
	true: 		.asciiz "strings are equal"
	false: 		.asciiz "strings are NOT equal"
	
.text 
.globl main 

#String Compare 

	la $t0, string1
	la $t1, string2 
	
	
	
        loop:
        	lw $s0, 0($t0)
        	lw $s1, 0($t1)
        	bne $s0, $s1, notEqual 
 
        	beq $s0, 0, Equal
        	
        	add $t0,$t0, 1 
        	add $t1, $t1, 1 
        	
        	j loop
        	
       Equal :
       
       notEqual: