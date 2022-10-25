.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

brainfuck:
	# Prologue
	pushq %rbp
	movq %rsp, %rbp

	pushq %r12 # programIndex
	pushq %r13 # currentCharacter
	pushq %r14 # pointer
	pushq %r15 # memoryBase

	# Variable initialization
	movq %rdi, %r12
	movq $1, %r13
	movq $0, %r14

	movq $30000, %rdi
	movq $1, %rsi
	call calloc
	movq %rax, %r15

brainfuck_loop:
	cmpq $0, %r13
	je brainfuck_loop_end

	movq (%r12), %r13
	incq %r12

	cmpq $43, %r13 # ascii +
	je case_plus

	cmpq $45, %r13 # ascii -
	je case_minus

	cmpq $62, %r13 # ascii >
	je case_greater

	cmpq $60, %r13 # ascii <
	je case_less

	cmpq $91, %r13 # ascii [
	je case_open

	cmpq $93, %r13 # ascii ]
	je case_close

	cmpq $46, %r13 # ascii .
	je case_dot

	cmpq $44, %r13 # ascii ,
	je case_comma

	jmp brainfuck_loop

	case_plus:
		incb (%r15, %r14, 1)
		jmp brainfuck_loop

	case_minus:
		decb (%r15, %r14, 1)
		jmp brainfuck_loop
		
	case_greater:
		incq %r14
		jmp brainfuck_loop

	case_less:
		decq %r14
		jmp brainfuck_loop

	case_open:
		movq (%r15, %r14, 1), %rax
		movq $1, %rcx

		cmpq $0, %rax
		je skip_loop

		enter_loop:
			decq %r12
			pushq %r12
			incq %r12
			jmp brainfuck_loop

		skip_loop:
			movq (%r12), %r13
			incq %r12

			cmpq $91, %r13 # ascii [
			je open_bracket

			cmpq $93, %r13 # ascii ]
			je closed_bracket

			cmpq $0, %rcx
			je found_matching

			jmp skip_loop
			open_bracket:
				incq %rcx
			closed_bracket:
				decq %rcx
			found_matching:
				jmp brainfuck_loop		

	case_close:
		jmp brainfuck_loop

	case_dot:
		jmp brainfuck_loop

	case_comma:
		jmp brainfuck_loop

brainfuck_loop_end:

	popq %r15 # memoryBase
	popq %r14 # pointer
	popq %r13 # currentCharacter
	popq %r12 # programIndex
	
	movq %rbp, %rsp
	popq %rbp
	ret
