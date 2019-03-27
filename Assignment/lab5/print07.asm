li $a0, 6 #acc <- 6
sw $a0, 0($sp) #push acc
addiu $sp, $sp, -4
li $a0, 2 #acc <- 2
lw $t1, 4($sp)
 #load top_of_stackdiv $t1, $a0 #acc <- acc / top_of_stack
mflo $a0 #move from register low
addiu $sp, $sp, 4 #pop
li $v0, 1 #for printing an integer result
syscall #for printing an integer result
li $v0, 10 #for correct exit (or temrination)
syscall #for correct exit (or temrination)
