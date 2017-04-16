.data 
	array: .word 7,5,2,1,1,3,4 
.align 0 

.text 

.globl main 


main: 
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
	
	
	