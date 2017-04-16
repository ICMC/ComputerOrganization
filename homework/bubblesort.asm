.data 
	array: .word 7,5,2,1,1,3,4 
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
			addi $t2, $t2, 1
			li $t3, 0
			innerLoop:
 
				beq $t3, $t0, outterLoop
				la $t4, array
				mul $t5, $t3, 4 
				addi $t3, $t3, 1  # j++
				add $t5, $t4, $t5 #address of array[j]
				add $t6, $t5, 4   #address of array[j+1]
				lw $a0,($t5) 
				lw $a1, ($t6) 
				
				ble $a0,$a1, innerLoop
				
				#swap 
				sw $a0, ($t5)
				sw $a2, ($t6)
				
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
	