.data 
	array: .word 8,9,2,0,1,5,4 
.align 0 
	endln: .asciiz "\n"
.text 

.globl main 


main: 
	jal print 
	li $t0, 7
	li $t2, 0 
	
	
	outterLoop:
	beq $t0,$t2, endOutLoop
		addi $t2, $t2, 1 #i++
		li $t3, 0
		la $t4, array
			
		innerLoop:
		beq $t3, $t0, outterLoop
				
			addi $t3, $t3, 1  # j++
			move $t5, $t4
			addi $t5, $t5, 4 
			
			lw $a0,($t4) 
			lw $a1, ($t5) 
				
			ble $a0,$a1, addArray
					
				#swap 
				sw $a0, ($t5)
				sw $a1, ($t4)
				
				addi $t4, $t4, 4 	
			j innerLoop
			
			addArray:
				addi $t4, $t4, 4 
				j innerLoop	
				
	endOutLoop:
	jal print 
        j endSort
        

print: 
	
	la $s1, array
	li $t0, 0
	li $t1, 7
	
	loopPrint:
		beq $t0,$t1, endPrint
		addi $t0, $t0, 1 
		lw $a0,($s1)
		li $v0,1
		syscall 
		
		addi $s1,$s1, 4
		
		j loopPrint
	endPrint: 
	li $v0, 4 
	la $a0, endln 
	syscall 
	jr $ra 
	
endSort:
	