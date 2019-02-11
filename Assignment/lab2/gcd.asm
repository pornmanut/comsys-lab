.data
#make some text for print
prompt1: .asciiz "gcd of "
prompt2: .asciiz " and "
prompt3: .asciiz " is "
newline: .asciiz "\n"


.text

#start from main
.globl main


main:
	addi $t0, $zero, 1890 #m = 1890
	addi $t1, $zero, 3315 #n = 3315
	addi $sp, $sp -8 #add more space to stack 2 int
	sw $t0, 4($sp) #store m to arug 1
	sw $t1, 0($sp) #store n to arug 2
	
	jal gcd #load function of gcd
	
	#don't need to $t0 and $t1 back from send
	addi $sp, $sp 8 #back from gcd
	move $t2, $v0 #move v0 to $t2
print:
	addi $v0, $zero, 4 #print str
	la $a0, prompt1
	syscall
	
	addi $v0, $zero, 1 #print m
	move $a0, $t0
	syscall
	
	addi $v0, $zero, 4 #print str
	la $a0, prompt2
	syscall
	
	addi $v0, $zero, 1 #print n
	move $a0, $t1
	syscall
	
	addi $v0, $zero, 4 #print str
	la $a0, prompt3
	syscall
	addi $v0, $zero, 1 #print gcd result
	move $a0, $t2
	syscall
	addi $v0, $zero, 4 #print newline of str
	la $a0, newline
	syscall
exit:
	addi $v0, $zero, 10 #exit
	syscall #syscall
	
gcd:
	#gcd function
	addi $sp, $sp, -8 #add more stack space to store $ra and $fp
	sw $ra, 4($sp)
	sw $fp, 0($sp)
	move $fp, $sp #set $fp = new $sp
	lw $a0, 12($fp) #load m from below frame that store from before gcd
	lw $a1, 8($fp) #load n like upper
	beq $a0, $a1, L1 #m==n  
	sub $s1, $a0, $a1 #m-n $s1
	sub $s2, $a1, $a0 #n-m $s2
	slt $s0, $a0, $a1 #m<=n
	bne $s0, $zero, L3 #else reject to L3
L2:
	addi $sp, $sp -8 #add more stack space to store new arugment for next gcd
	sw $s1, 4($sp) #load arugment m-n for next gcd
	sw $a1, 0($sp) #load argument n for next gcd
	jal gcd #load new gcd
	jal return #if gcd comeback get return
L3:
	addi $sp, $sp -8 #add more stack space to store new argment for next gcd
	sw $a0, 4($sp) #load arugment m for next gcd
	sw $s2, 0($sp) #load arugment n-m for next gcd
	jal gcd #load new gcd
	jal return #if gcd comeback get return 

return:
	#recusrive back
	addi $sp, $sp, 8 #decrease stack space from load new argument
	
	lw $ra 4($fp) #load $ra from stack space that store from head of gcd
	lw $fp 0($fp) #$fp same at $ra
	addi $sp, $sp 8 #decrease stack space to go to before frame to comeback
	jr $ra #load address of before gcd or main
L1:
	#last case
	lw $v0, 12($fp) #load m
	lw $ra, 4($fp) #load $ra from before gcd
	lw $fp, 0($fp) #load $fp from before gcd
	addi $sp, $sp, 8 #return stack space
	jr $ra #return to gcd

	
