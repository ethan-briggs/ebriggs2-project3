.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
	# main() prolog
	addi sp, sp, -24
	sw ra, 20(sp)
	la a3, sekret_fn

	# main() body
	la a0, prompt
	call puts

	mv a0, sp
	call gets

	mv a0, sp
	call puts

	# main() epilog
	lw ra, 20(sp)
	addi sp, sp, 24
	ret

.space 12288

sekret_fn:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, sekret_data
	call puts
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

##############################################################
# Add your implementation of puts() and gets() below here
##############################################################

	#  Read up to 100 characters from the terminal (stdin)
getchar:
    addi sp, sp, -1
    li a7, __NR_READ
    mv a1, sp
    li a0, STDIN
    li a2, 1
    ecall
    blt a0, zero, error_occured
    lbu a0, 0(sp)
    addi sp, sp, 1
    ret
    
    
	# Write the prompt to the terminal (stdout)
putchar:
    addi sp, sp, -1
    sb a0, 0(sp)
    li a7, __NR_WRITE
    li a2, 1
    mv a1, sp
    li a0, STDOUT
    ecall
    blt a0, zero, error_occured
    lbu a0, 0(sp)
    addi sp, sp, 1
    ret
    
    
error_occured: 
    addi sp, sp, 1
    ret
    
    
gets:
     addi sp, sp, -16
     sw s0, 8(sp)
     sw s1, 4(sp)
     sw s2, 0(sp)
     sw ra, 12(sp)
     mv s0, a0
     mv s1, a0
     li s2, 10
     
gets_loop:
     call getchar
     blt a0, zero, end
     sb a0, 0(s1)
     addi a4, s1, 1
     bne a0, s2, same
     sb zero, 0(s1)
     sub a0, s0, a4
     
end: 
     lw ra,12(sp)
     lw s0, 8(sp)
     lw s1, 4(sp)
     lw s2, 0(sp)
     addi sp, sp, 16
     mv a0, s0
     ret
     
puts:
     addi sp, sp, -8
     sw ra, 0(sp)
     sw s0, 4(sp)
     mv s0, a0
    
     
puts_loop: 
     lbu a0, 0(s0)
     beqz a0, puts_loop_complete
     addi s0, s0, 1
     call putchar
     j puts_loop
     
puts_loop_complete:
     li a0, 10
     call putchar
     lw s0, 4(sp)
     lw ra, 0(sp)
     addi sp, sp, 8
     ret
     
same: 
     mv s1, a4
     j gets_loop



.data
prompt:   .ascii  "Enter a message: "
prompt_end:

.word 0
sekret_data:
.word 0x73564753, 0x67384762, 0x79393256, 0x3D514762, 0x0000000A
