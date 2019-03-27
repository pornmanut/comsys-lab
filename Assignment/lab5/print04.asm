li $a0, 12 #acc <- 12
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 3 #acc <- 3
lw $t1, 4($sp)
mult $a0, $t1 #acc <- acc * top_of_stack
mflo $a0 #move from register low
addiu $sp, $sp, 4 #pop
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 2 #acc <- 2
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 7 #acc <- 7
lw $t1, 4($sp)
add $a0, $a0, $t1 #acc <- acc + top_of_stack
addiu $sp, $sp, 4 #pop
lw $t1, 4($sp)
div $a0, $t1 #acc <- acc / top_of_stack
mflo $a0 #move from register low
addiu $sp, $sp, 4 #pop
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 5 #acc <- 5
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 2 #acc <- 2
lw $t1, 4($sp)
div $a0, $t1 #acc <- acc % top_of_stack
mfhi $a0 #move from register high
addiu $sp, $sp, 4 #pop
lw $t1, 4($sp)
sub $a0, $a0, $t1 #acc <- acc - top_of_stack
addiu $sp, $sp, 4 #pop
li $v0, 1 #for printing an integer result
syscall #for printing an integer result
li $v0, 10 #for correct exit (or temrination)
syscall #for correct exit (or temrination)
