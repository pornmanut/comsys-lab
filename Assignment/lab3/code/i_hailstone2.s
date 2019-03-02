main:
	#init
	addu $sp, $zero, $zero
	addu $ra, $zero, $zero 
	
	
	addiu $sp, $sp, -4 #for n arugment
	#you can change this line to whatever you want
	addiu $t0, $zero, 2
	sw $t0, 0($sp)
	
	jal HAILSTONE
	
	addiu $sp, $sp, 4 #set stack back
	
	j EXIT
#HAILSTONE need one arugment hailstone(int n)
HAILSTONE:
	addiu $sp, $sp, -8
	sw $ra, 4($sp) #store add address of$ra
	sw $fp, 0($sp) #store address of $fp
	addu $fp, $sp, $zero
	
	lw $s0, 8($fp) #load arugment n
	addiu $s1, $zero, 1
	#we will use i store at $s2
	addu $s2, $zero, $zero
	#check n != 1
WHILE:
	beq $s0, $s1, WHILE_OUT
WHILE_IN:	
	 #n!=1 WHITE_IN:WHILE_OUT
	addiu $s2, $s2, 1 #i+i+1
	#n %2 == n&1
	andi $s3, $s0, 1 #n&1 == n%2
	bne $s3, $zero, ELSE #if(n%2)==0
IF:
	#n/2
	sra $s0, $s0, 1 #n = n/2
	j WHILE
ELSE:
	addu $s4, $s0, $s0 #$s4 = 2*n
	addu $s0, $s0, $s4 #n = 2*n +n = 3*n
	addiu $s0, $s0, 1 #n = 3*n+1
	j WHILE

WHILE_OUT:
	lw $ra, 4($sp)
	lw $fp, 0($sp)
	addiu $sp, $sp, 8
	addu $a0, $s2, $zero #return i
	jr $ra
	
EXIT:
	#just exit we must use syscall
	#but it can't
	#we will just move a0 to t0
	addu $t0, $a0, $zero
