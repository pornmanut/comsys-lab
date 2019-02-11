# RANGE 255
# N 1000

.data

prompt: .asciiz "Sorted string is "
newline: .asciiz "\n"

str: 	.byte 'c', 'a', 'd', 'l', 'j', 'g' ,'a', 'r', 'h', 't', 'o' ,'x'
		.byte 'A', 'H', 'd', 'g', 'd', 's', 'J', 'K', 'h', 'Y', 'E', 'a'
		.byte 's', 'd', 'u', 'w', 'B', 'R', 'L', 's', 'd', 'g', 'H', 'o'
		.byte 'p','t', 'x', 'n', 'a', 's', 'e', 'u', 'r', 'h'

blankspace: .space 4 #make barrier between str and output 
output: .space  1000 #output[N]



countsz: .word 255 #range

.align 2 #force alignment 2^2 = 4
count: .space 1024 #count[range+1] 

.text



.globl main

main:
	add $t0, $zero, $zero # initialize i in $t0 = 0
	la $s0, count #load address of count[] to $a0
	lw $s1, countsz #range
	la $s2, str #load str
	la $s3, output #load output
	addi $s5, $zero, 1 #number 1
	addi $t9, $s1, 1 #range+1

	#initialize count array as 0
for_zero:
	sll $t1, $t0, 2 #make offset of int to set zero of count
	
	add $t8, $s0, $t1 #next address of count find by ptr(i*4)
	sw $zero, ($t8) #count[i] = 0
	
	addi $t0, $t0, 1 # count i++

	slt $t1, $t0, $t9 # x if i < range+1 ? 1:0
	bne $t1, $zero, for_zero # x != 0 jump to for_zero

	#store count of each characher
	add $t0, $zero, $zero #set i=0
	lb $t1, 0($s2) #load first char from str[]
for_string:
	
	sll $t7, $t1, 2 #get str[] and str*4 to find next address of count
	add $t8, $s0, $t7 #next address of count[] find by ptr(str[i]*4)
	lw $t2, ($t8) #load count[] and backup in $t2

	addi $t2, $t2, 1 #++count[]
	sw $t2, ($t8)  #store back to what where it come from
	
	addi $t0, $t0, 1 #i++

	add $t9, $s2, $t0 #next address of str[] find by ptr(i)
	lb $t1, 0($t9) #load char from str[]
	bne $t1, $zero, for_string #if we load char str[] if not find then exit loop


	#change count[i] so that count[i] now contains actual
	#position of this character in output array
	add $t0, $zero, $zero #set i-1 = 0
	addi $t1, $zero, 1 #set i = 1
for_before:

	sll $t7, $t0, 2 #(i-1)*4	
	sll $t8, $t1, 2 #i*4

	add $t2, $s0, $t7 #address of count[i-1]
	lw $t4, ($t2) #load count[i-1]

	add $t3, $s0, $t8 #address of count[i]
	lw $t5, ($t3) #load count[i]

	add $t6, $t4, $t5 #count[i-1]+count[i]
	sw $t6, ($t3) #count[i] = count[i-1]+count[i]

	addi $t0, $t0, 1 #(i-1)++
	addi $t1, $t1, 1 #i++

	slt $t9, $s1, $t1 #range < i
	beq $t9, $zero, for_before #if range < i return to for_before loop

	#build the output character array
for_build:
	add $t0, $zero, $zero #set i=0
	lb $t7, ($s2) #load first str[i]
	beq $t7, $zero, out_build #if str[i] == null jump out of loop
in_build:
	sll $t1 ,$t7 ,2 # str[i]*4
	add $t9 ,$s0 ,$t1 #address of count[str[i]]
	lw $t2, ($t9) #load count[str[i]]
	sub $t2, $t2, $s5 #count[str[i]]-1

	add $t3, $s3 ,$t2 #load address of output[count[str[i]-1]]
	sb $t7, ($t3) #store output[count...] = str[i]

	sw $t2, ($t9) #store count[str[i]] = count[str[i]]-1

	addi $t0, $t0, 1 #i++
	add $t8, $s2, $t0 #load address of next str[i]
	lb $t7, ($t8) #str[i]
	bne $t7, $zero, in_build
out_build:
for_pirnt:
	add $t0, $zero, $zero #set i=0
	lb $t8, ($s3) #load first str[i]
	beq $t8, $zero, out_print
in_print:
	add $t1, $s2, $t0 #address of str[i]
	add $t2, $s3, $t0 #address of output[i]

	lb $t3, ($t2) #load output[i]
	sb $t3, ($t1) #store at str[i]

	addi $t0, $t0, 1 #i++
	lb $t8, ($t1) #load next str[i]
	bne $t8, $zero, in_print
out_print:
	li $v0, 4 #print str

	la $a0, prompt #load prompt
	syscall #print

	la $a0, str #print sort str
	syscall #print

	la $a0, newline #load newline
	syscall #print
exit:
	li $v0, 10 #return 0
	syscall

