.data

printA: .asciiz "Sum a = "
printB: .asciiz "Sum b = "
newline: .asciiz "\n"

arrayA: .word 0 ,1 ,2 , 3 ,4 ,5 ,6 ,7 ,8 ,9 ,10 ,11 ,12 ,13 ,14 ,15 ,16 ,17 ,18 ,19 
arrayB: .word 0x7fffffff, 0x7ffffffe, 0x7ffffffd, 0x7ffffffc, 0x7ffffffb, 0x7ffffffa ,0x7ffffff9 ,0x7ffffff8, 0x7ffffff7, 0x7ffffff6
.text

.globl main

main:
	add $t0, $zero, $zero #sum
	add $t1, $zero, $zero #i
loop:
	sll $t2, $t1, 2
	lw $t3, arrayA($t2)
	add $t0, $t0, $t3
	addi $t1, $t1, 1
	slti $t2, $t1, 20
	bne $t2, $zero, loop
end:
	li $v0, 4
	la $a0, printA
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, newline
	syscall

main2:
	add $t0, $zero, $zero #sum
	add $t1, $zero, $zero #i
loop2:
	sll $t2, $t1, 2
	lw $t3, arrayB($t2)
	addu $t0, $t0, $t3
	addi $t1, $t1, 1
	slti $t2, $t1, 10
	bne $t2, $zero, loop2
end2:
	li $v0, 4
	la $a0, printB
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
exit:
	li $v0, 10
	syscall
