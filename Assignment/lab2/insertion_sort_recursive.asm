.data
	space: .asciiz " "
	newline: .asciiz "\n"
.text
	

.globl main

main:
	#start with create array to stack in main
	#array need 12 values.in the way to handle all we need
	#to init 48 address of stack to store all of value
	
	addiu $sp, $sp, -48 #change stack pointer to maintain new array
	
	#load 4 first array a[0] a[1] a[2] a[3]
	addi $t0, $zero, 132470
	addi $t1, $zero, 3245453
	addi $t2, $zero, 73245
	addi $t3, $zero, 93245
	#store into below of stack
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	#same at upper
	addi $t0, $zero, 80324542
	addi $t1, $zero, 244
	addi $t2, $zero, 2
	addi $t3, $zero, 66
	
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)
	
	addi $t0, $zero, 236
	addi $t1, $zero, 327
	addi $t2, $zero, 236
	addi $t3, $zero, 21544
	#last store
	sw $t0, 32($sp)
	sw $t1, 36($sp)
	sw $t2, 40($sp)
	sw $t3, 44($sp)
	#inorder to use new print_array(arr,n)
	#send of first address of array in this progaram 8($fp)
	# N is immedient
	move $t4, $sp #move sp to $t0
	addi $t5, $zero, 12 #t1 is 12 of n
	
	addiu $sp, $sp, -8 #create stack of aurgment and store
	sw $t5, 4($sp) #store n feor new function
	sw $t4, 0($sp) #store addr of a[0]
	
	jal PA #function print array
	
	jal ISR #function InsertionSort
	
	jal PA #function print array

EXIT:
	addi $v0, $zero, 10 #exit
	syscall

	
ISR:
	#create new frame for insertionSortRecursive
	addiu $sp, $sp, -8
	sw $ra, 4($sp) #store address of $ra
	sw $fp, 0($sp) #store address of $fp
	move $fp ,$sp
	
	lw $s0, 12($fp) #n
	lw $s1, 8($fp) #addr
	
	addi $s2, $zero, 1 #1
	slt $s3, $s2, $s0 # 1 < n ?1
ISR_IF:

	bne $s3, $zero, ISR_ELSE #if n > 1 
	lw $ra, 4($sp) #load ra 
	lw $fp, 0($sp) #load fp
	addiu $sp, $sp, 8
	jr $ra
	
ISR_ELSE:
	addiu $s0, $s0, -1 #n-1
	
	addiu $sp, $sp, -8 #create empty new stack
	
	sw $s0, 4($sp) #stack n-1 to a[1]
	sw $s1, 0($sp) #stack arr to a[2]
	
	jal ISR #recustion inserctionSort(arr,n-1)
	
	lw $s0, 4($sp) #load n-1
	lw $s1, 0($sp) #load arr
	addiu $sp, $sp 8 #return stack 
	
	#last = arr[n-1]
	sll $s2, $s0, 2 #(n-1)*4 to make offset
	addu $s2, $s2, $s1 #arr+offset
	lw $s3, 0($s2) #load arr[n-1] $s3 = last
	
	addiu $s4, $s0, -1 #j = n-2 $s4 = n-2 = j
 	
 
ISR_WHILE_HEAD:
 	
 	
 	sll $s2, $s4, 2 #get j*4 for make offset
 	addu $s2, $s2 ,$s1 #addr + offset to make arr[j]
 	lw $s5, 0($s2) #load arr[j]
 	
 	slt $s6, $s4, $zero #j < 0 ?0
 	slt $s7, $s3, $s5 #last < arr[j] ?1
 	
 	not $s6, $s6 #check if j >= 0
 	and $s7, $s6, $s7 #j>=0 && last < arr[j]
 	
 	beq $s7, $zero, ISR_WHILE_EXIT
 	#we know that $s5 is arr[j]
 	#we must to store it in to arr[j+1]
 	#s4 = j
 	addi $s6, $s4, 1 #j+1
 	sll $s6, $s6, 2 #(j*4) to make offset
 	addu $s6, $s6, $s1 #addr + offset to make arr[j+1]
 	
 	sw $s5, 0($s6) #arr[j+1] = arr[j]
 	
 	addi $s4, $s4, -1 #j--
 	j ISR_WHILE_HEAD
 	
ISR_WHILE_EXIT:
	
	addi $s6, $s4, 1 #j+1
 	sll $s6, $s6, 2 #(j*4) to make offset
 	addu $s6, $s6, $s1 #addr + offset to make arr[j+1]
	
	sw $s3, 0($s6) #arr[j+1] = last
	
	lw $ra, 4($sp) #load ra 
	lw $fp, 0($sp)
	
	addiu $sp, $sp 8 #return stack 
	
	jr $ra #back to that we come
PA:
	#create new frame for print function
	#we need to store $fp and $ra from frame after
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	move $fp, $sp
	
	lw $s0 12($fp) #n
	lw $s1 8($fp) #addr
	
	addi $s2, $zero, 0 #init i

PA_FOR_HEAD:

	slt $s3, $s2, $s0 #check variable i < n
	beq $s3, $zero, PA_FOR_EXIT #if i<n ?0 to EXIT
	sll $s4, $s2, 2 #i*4
	
	addu $s4, $s4, $s1 #addr + offset i
	lw $s5, 0($s4)
	
	addi $v0, $zero, 1 #start to print int
	move $a0, $s5 #load value of arr[i] to $a0
	syscall #print
	
	addi $v0 $zero, 4 #start to print str of space
	la $a0, space #load " "
	syscall
	
	addi $s2, $s2, 1 #i++
	j PA_FOR_HEAD #jump to head to check condition again
	
PA_FOR_EXIT:

	addi $v0 $zero, 4 #start to print str of \n
	la $a0, newline #load '\n'
	syscall #print
	
	lw $ra, 4($sp) #load ra 
	lw $fp, 0($sp)
	addiu $sp, $sp 8 #return stack 
	
	jr $ra #back to that we come
	
	
	
	
	
	
	



