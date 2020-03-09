# Robert Leung
# rjleung
# 111750515

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
get_adfgvx_coords:
li $v0, -200
li $v1, -200

bltz $a0, invalid_coords
bgt $a1, 5, invalid_coords

beq $a0, 0, A1
beq $a0, 1, D1
beq $a0, 2, F1
beq $a0, 3, G1
beq $a0, 4, V1
beq $a0, 5, X1

A1:
li $v0, 65
j index2
D1:
li $v0, 68
j index2
F1:
li $v0, 70
j index2
G1:
li $v0, 71
j index2
V1:
li $v0, 86
j index2
X1:
li $v0, 88

index2:
beq $a1, 0, A2
beq $a1, 1, D2
beq $a1, 2, F2
beq $a1, 3, G2
beq $a1, 4, V2
beq $a1, 5, X2

A2:
li $v1, 65
j coords_done
D2:
li $v1, 68
j coords_done
F2:
li $v1, 70
j coords_done
G2:
li $v1, 71
j coords_done
V2:
li $v1, 86
j coords_done
X2:
li $v1, 88

coords_done:
jr $ra

invalid_coords:
li $v0, -1
li $v1, -1

jr $ra

# Part II
search_adfgvx_grid:
li $v0, -200
li $v1, -200

li $t0, 0 #row

search_row_loop:
bge $t0, 6, search_not_valid

li $t1, 0 #column

search_column_loop:
bge $t1, 6, search_next_row

lbu $t2, 0($a0)
beq $t2, $a1, search_found

addi $t1, $t1, 1
addi $a0,$a0, 1
j search_column_loop

search_next_row:
addi $t0, $t0, 1
j search_row_loop

search_found:
move $v0, $t0
move $v1, $t1
jr $ra

search_not_valid:
li $v0, -1
li $v1, -1
jr $ra

# Part III
map_plaintext:
li $v0, -200
li $v1, -200

addi $sp, $sp, -16
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2

map_loop:
lbu $t0, 0($s1) # plaintext character
beqz $t0, map_loop_done

move $a0, $s0 # adfgvx_grid
move $a1, $t0 # character
jal search_adfgvx_grid

move $a0, $v0 # row index
move $a1, $v1 # column index
jal get_adfgvx_coords

sb $v0, 0($s2)
sb $v1, 1($s2)
addi $s2, $s2, 2 # move 2 spaces in buffer
addi $s1, $s1, 1 # move to next character in plaintext
j map_loop

map_loop_done:

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
addi $sp, $sp, 16

jr $ra

# Part IV
swap_matrix_columns:
li $v0, -200
li $v1, -200

lw $t4, 0($sp) # fifth argument

blez $a1, swap_matrix_invalid
blez $a2, swap_matrix_invalid
bltz $a3, swap_matrix_invalid
bltz $t4, swap_matrix_invalid
bge $a3, $a2, swap_matrix_invalid
bge $t4, $a2, swap_matrix_invalid

addi $sp, $sp, -28
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
#sw $s6, 28($sp)
#sw $s7, 32($sp)

move $s0, $a0 # matrix
move $s1, $a1 # num rows
move $s2, $a2 # num columns
move $s3, $a3 # col1
lw $s4, 28($sp) # col2

li $s5, 0 # row count

swap_columns_loop:
beq $s5, $s1, swap_columns_done

mul $t0, $s5, $s2 # row_index * num_cols = row 
add $t1, $t0, $s3 # col1 character index
add $t2, $t0, $s4 # col2 character index

add $t9, $s0, $t1
lbu $t9, 0($t9) # char1

add $t8, $s0, $t2
lbu $t8, 0($t8) # char2

add $t7, $s0, $t1 
sb $t8, 0($t7) # store char2 at char1 index

add $t7, $s0, $t2
sb $t9, 0($t7) # store char1 at char2 index

addi $s5, $s5, 1
j swap_columns_loop


swap_columns_done:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
#lw $s6, 28($sp)
#lw $s7, 32($sp)
addi $sp, $sp, 28

li $v0, 0
jr $ra

swap_matrix_invalid:
li $v0, -1
jr $ra

# Part V
key_sort_matrix:
li $v0, -200
li $v1, -200

addi $sp, $sp, -32
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)

move $s0, $a0 # matrix
move $s1, $a1 # num rows
move $s2, $a2 # num columns
move $s3, $a3 # key
lw $s4, 32($sp) # key element size

li $s6, 0 # unsorted = 0

bubble_sort_loop:
beq $s6, 1, key_sort_done
li $s5, 0 # key index
li $s6, 1 # sorted = 1

swap_loop:
addi $t9, $s2, -1 # length - 1
bge $s5, $t9, bubble_sort_loop # stop before last index

beq $s4, 1, byte_offset # words if element size is 4

li $t9, 4
mul $t9, $t9, $s5 # 4 * index
move $t8, $s3 # key
add $t8, $t8, $t9 # offset address by key index * 4 (words)
j continue_swap

byte_offset:
move $t8, $s3 # key
add $t8, $t8, $s5 # offset address by key index

continue_swap:
beq $s4, 4, word_swap # words if element size is 4

lb $t0, 0($t8)
lb $t1, 1($t8)

ble $t0, $t1, less_than

li $s6, 0 # 0 = unsorted

move $t3, $t0 # save first char in $t3
sb $t1, 0($t8) # char2 to char1
sb $t3, 1($t8) # char1 to char2

move $a0, $s0 # matrix
move $a1, $s1 # num rows
move $a2, $s2 # num cols
move $a3, $s5 # col1

addi $t4, $s5, 1 # col2
addi $sp, $sp, -4
sw $t4, 0($sp) # store 5th arg on stack

jal swap_matrix_columns

addi $sp, $sp, 4 # restore stack pointer

j less_than

word_swap:
lw $t0, 0($t8)
lw $t1, 4($t8)
ble $t0, $t1, less_than

li $s6, 0 # 0 = unsorted

move $t3, $t0 # save first word in $t3
sw $t1, 0($t8) # word2 to word1
sw $t3, 4($t8) # word1 to word2

move $a0, $s0 # matrix
move $a1, $s1 # num rows
move $a2, $s2 # num cols
move $a3, $s5 # col1

addi $t4, $s5, 1 # col2
addi $sp, $sp, -4
sw $t4, 0($sp) # store 5th arg on stack

jal swap_matrix_columns

addi $sp, $sp, 4 # restore stack pointer

less_than:
addi $s5, $s5, 1
j swap_loop


key_sort_done:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
addi $sp, $sp, 32

jr $ra


# Part IV
transpose:
li $v0, -200
li $v1, -200

blez $a2, transpose_invalid
blez $a3, transpose_invalid

addi $sp, $sp, -28
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)

move $s0, $a0 # matrix src
move $s1, $a1 # matrix dest
move $s2, $a2 # rows
move $s3, $a3 # cols

li $s4, 0 # row index
li $s5, 0 # col index

transpose_loop:
bge $s4, $s2, transpose_done
li $s5, 0 # reset col index

transpose_column_loop:
bge $s5, $s3, next_transpose_loop
mul $t9, $s4, $s3 # row index * num cols
add $t9, $t9, $s5 # + col index = 2D array location in src
add $t9, $t9, $s0 # add to src address

lb $t0, 0($t9)

mul $t9, $s5, $s2 # col index * num rows
add $t9, $t9, $s4 # + row index = 2D array location in dest
add $t9, $t9, $s1 # add to dest address

sb $t0, 0($t9)

addi $s5, $s5, 1 # increment col index
j transpose_column_loop

next_transpose_loop:
addi $s4, $s4, 1 # increment row index
j transpose_loop

transpose_done:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
addi $sp, $sp, 28

li $v0, 0
jr $ra

transpose_invalid:
li $v0, -1
jr $ra

# Part VII
encrypt:
li $v0, -200
li $v1, -200

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)

move $s0, $a0 # grid
move $s1, $a1 # plaintext
move $s2, $a2 # keyword
move $s3, $a3 # cipher

li $s5, 0 # keyword length counter
move $t0, $s2 # keyword

keyword_length_loop:
lbu $t1, 0($t0)
beqz $t1, keyword_length_done

addi $s5, $s5, 1
addi $t0, $t0, 1

j keyword_length_loop

keyword_length_done:

li $t9, 0 # plainttext length counter
move $t0, $s1 # plaintext

plaintext_length_loop:
lbu $t1, 0($t0)
beqz $t1, plaintext_length_done

addi $t9, $t9, 1
addi $t0, $t0, 1

j plaintext_length_loop

plaintext_length_done:
li $t8, 2
mul $t9, $t9, $t8 # multiply length by 2 to get mapped length

div $t9, $s5 # mapped_length mod keyword_length (remainder used know length of allocated space for asteriks)
mfhi $t0

mflo $s6 # this is the row length if remainder is 0 (will need later)

beq $t0, 0, remainder_zero # if remainder zero, don't add on anything (grid will have no ateriks)

sub $t0, $s5, $t0 # keyword_length - modded_value = number of asteriks
addi $s6, $s6, 1 # add 1 to row number if there is remainder (extra row)

remainder_zero:

add $s7, $t9, $t0 # allocated space length (store in $s7, will need later to add null terminator)

move $a0, $s7
li $v0, 9
syscall # allocate space for mapped plaintext

move $s4, $v0 # address of allocated space

li $t9, 0 # asterik loop counter

asterik_loop:
bge $t9, $s7, asterik_loop_done

li $t0, '*'
sb $t0, 0($v0) 

addi $t9, $t9, 1
addi $v0, $v0, 1

j asterik_loop

asterik_loop_done:

move $a0, $s0 # grid
move $a1, $s1 # plaintext
move $a2, $s4 # destination

jal map_plaintext

move $a0, $s4 # mapped matrix
move $a1, $s6 # rows
move $a2, $s5 # columns
move $a3, $s2 # keyword

addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp) # 5th argument: key element size

jal key_sort_matrix

addi $sp, $sp, 4

move $a0, $s4 # key sorted matrix
move $a1, $s3 # cipher destination
move $a2, $s6 # rows
move $a3, $s5 # columns

jal transpose

add $s3, $s3, $s7 # offset to get to end of matrix string
li $t0, 0
sb $t0, 0($s3)

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
lw $s7, 32($sp)
addi $sp, $sp, 36

jr $ra

# Part VIII
lookup_char:
li $v0, -200
li $v1, -200

beq $a1, 'A', A_row
beq $a1, 'D', D_row
beq $a1, 'F', F_row
beq $a1, 'G', G_row
beq $a1, 'V', V_row
beq $a1, 'X', X_row
j invalid_lookup

A_row:
li $t0, 0
j column_lookup

D_row:
li $t0, 1
j column_lookup

F_row:
li $t0, 2
j column_lookup

G_row:
li $t0, 3
j column_lookup

V_row:
li $t0, 4
j column_lookup

X_row:
li $t0, 5
j column_lookup

column_lookup:
beq $a2, 'A', A_column
beq $a2, 'D', D_column
beq $a2, 'F', F_column
beq $a2, 'G', G_column
beq $a2, 'V', V_column
beq $a2, 'X', X_column
j invalid_lookup

A_column:
li $t1, 0
j complete_lookup

D_column:
li $t1, 1
j complete_lookup

F_column:
li $t1, 2
j complete_lookup

G_column:
li $t1, 3
j complete_lookup

V_column:
li $t1, 4
j complete_lookup

X_column:
li $t1, 5
j complete_lookup

complete_lookup:
li $t9, 6 # col_length
mul $t0, $t0, $t9 # row_index * col_length
add $t0, $t0, $t1 # + col_index

add $t0, $a0, $t0 # offset matrix address to index

lbu $t0, 0($t0)

lookup_done:
li $v0, 0
move $v1, $t0
jr $ra

invalid_lookup:
li $v0, -1
jr $ra

# Part IX
string_sort:
li $v0, -200
li $v1, -200

li $t0, 0 # string length counter
move $t1, $a0 # string

string_length_loop:
lbu $t9, 0($t1)
beqz $t9, string_length_done

addi $t0, $t0, 1
addi $t1, $t1, 1

j string_length_loop

string_length_done:

li $t9, 0 # 0 = unsorted

string_bubble_sort_loop:
beq $t9, 1, string_sort_done
li $t8, 0 # key index
li $t9, 1 # sorted = 1

string_swap_loop:
addi $t7, $t0, -1 # length - 1
bge $t8, $t7, string_bubble_sort_loop # stop before last index

move $t6, $a0 # string
add $t6, $t6, $t8 # offset address by string index

lb $t1, 0($t6)
lb $t2, 1($t6)

ble $t1, $t2, string_less_than

li $t9, 0 # 0 = unsorted

move $t3, $t1 # save first char in $t3
sb $t2, 0($t6) # char2 to char1
sb $t3, 1($t6) # char1 to char2

string_less_than:
addi $t8, $t8, 1
j string_swap_loop

string_sort_done:
jr $ra

# Part X
decrypt:
li $v0, -200
li $v1, -200

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)

move $s0, $a0 # adfgvx_grid
move $s1, $a1 # ciphertext
move $s2, $a2 # keyword
move $s3, $a3 # plaintext

li $s5, 0 # keyword length counter
move $t0, $s2 # keyword

key_length_loop:
lbu $t1, 0($t0)
beqz $t1, key_length_done

addi $s5, $s5, 1
addi $t0, $t0, 1
j key_length_loop

key_length_done:
move $a0, $s5
li $v0, 9
syscall # allocate space on heap for keyword

add $t0, $v0, $s5 # offset to end
li $t1, 0
sb $t1, 0($t0) # add null terminator to end of heap_keyword

move $s4, $v0 # heap_keyword

move $t0, $s2 # original
move $t1, $v0 # copy

copy_keyword_loop:
lbu $t2, 0($t0)
beqz $t2, copy_keyword_done

sb $t2, 0($t1)

addi $t0, $t0, 1
addi $t1, $t1, 1

j copy_keyword_loop

copy_keyword_done:
move $a0, $s4
jal string_sort # sort heap_keyword

move $a0, $s5
li $v0, 9
syscall # allocate space on heap for keyword indices

move $s5, $v0 # heap_keyword_indices

move $t0, $s2 # original key
move $t1, $s4 # sorted heap_keyword
li $t9, 0 # sorted heap_keyword index counter

key_indices_loop:
li $t8, 0 # original keyword index counter (restore)
move $t0, $s2 # original key (restore)
lbu $t2, 0($t1) # sorted character
beqz $t2, key_indices_done

keyword_loop:
lbu $t3 0($t0) # original character

beq $t3, $t2, found_key_index

addi $t8, $t8, 1 # increment original key index 
addi $t0, $t0, 1 # increment original key array
j keyword_loop

found_key_index:
add $t4, $s5, $t9 # offset by sorted character position
sb $t8, 0($t4)

next_key_index:
addi $t9, $t9, 1 
addi $t1, $t1, 1 # increment sorted heap_keyword array
j key_indices_loop

key_indices_done:

li $t9, 0 # key_length
move $t0, $s2 # keyword

key_length_loop2:
lbu $t1, 0($t0)
beqz $t1, key_length_done2

addi $t9, $t9, 1
addi $t0, $t0, 1
j key_length_loop2

key_length_done2:

li $s6, 0 # cipher_length
move $t0, $s1 # cipher

cipher_length_loop:
lbu $t1, 0($t0)
beqz $t1, cipher_length_done

addi $s6, $s6, 1
addi $t0, $t0, 1
j cipher_length_loop

cipher_length_done:

div $s6, $t9 # divide by keyword length (row length)
mflo $t7 # column length of matrix

move $a0, $s6
li $v0, 9
syscall # allocate space for transposed matrix on heap (heap_ciphertext_array)

move $s7, $v0

move $a0, $s1 # matrix (cipher)
move $a1, $s7 # transpose dest
move $a2, $t9 # rows
move $a3, $t7 #columns

addi $sp, $sp, -8
sw $t9, 0($sp)
sw $t7, 4($sp)

jal transpose

lw $t9, 0($sp)
lw $t7, 4($sp)
addi $sp, $sp, 8

move $a0, $s7 # heap_ciphertext_array
move $a1, $t7 # rows
move $a2, $t9 # columns
move $a3, $s5 # heap_indices_array
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)

jal key_sort_matrix

addi $sp, $sp, 4

li $s1, 0 # ciphertext index t0
move $s2, $s7 # ciphertext t1
move $s4, $s3 # plaintext location t9

lookup_char_loop:
lbu $t2, 0($s2) # first letter 
beqz $t2, lookup_loop_done 
beq $t2, '*', lookup_loop_done

lbu $t3, 1($s2) # second letter
move $a0, $s0
move $a1, $t2
move $a2, $t3

jal lookup_char

sb $v1, 0($s4)

addi $s2, $s2, 2
addi $s4, $s4, 1

j lookup_char_loop

lookup_loop_done:

li $t0, 0
sb $t0, 0($s4)

lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
lw $s7, 32($sp)
addi $sp, $sp, 36

jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
