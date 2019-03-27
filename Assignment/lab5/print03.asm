li $a0, 3 #acc <- 3
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 7 #acc <- 7
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 5 #acc <- 5
lw $t1, 4($sp)
add $a0, $a0, $t1 #acc <- acc + top_of_stack
addiu $sp, $sp, 4 #pop
lw $t1, 4($sp)
add $a0, $a0, $t1 #acc <- acc + top_of_stack
addiu $sp, $sp, 4 #pop
li $v0, 1 #for printing an integer result
syscall #for printing an integer result
li $v0, 10 #for correct exit (or temrination)
syscall #for correct exit (or temrination)
