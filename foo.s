        .intel_syntax noprefix                          #

        .text                                           # начинает секцию

        .section        .rodata                         # .rodata

.LC0:
	.string	"Incorrect value %c, ASCII: %d"		# .LC0: "Incorrect value %c, ASCII: %d"

.LC1:
	.string	"ASCII:%d CHAR:%c COUNT:%d\n"		# .LC1: "ASCII:%d CHAR:%c COUNT:%d\n"
	
	.text						# секция с кодом
	.globl	main
	.type	main, @function
main:
        push    rbp                                     # сохраняем rbp на стек
        mov     rbp, rsp                                # rbp := rsp
        sub     rsp, 1536                               # rsp -= 1536
        mov     r12d, 0                   # rbp[-12] = 0 (unsigned int i = 0)
        jmp     .L2
.L3:
        mov     eax, r12d		                # eax := i
        mov     DWORD PTR -1536[rbp+rax*4], 0           # alphabet[i] = 0
        add     r12d, 1			                # i++
.L2:
        cmp     r12d, 127                 		# cmp i, 127
        jbe     .L3
        mov     DWORD PTR -1496[rbp], -1                # alphabet[10] = -1
        mov     rdx, QWORD PTR stdin[rip]               # rdx = stdin
        lea     rax, -1024[rbp]                         # eax := &(-1024 на стеке) - line
        mov     esi, 1000                               # esi := 1000(MAXLINE)
        mov     rdi, rax                                # rdi := rax
        call    fgets@PLT                               # fgets(line, MAXLINE, stdin)
	lea	rax, -1024[rbp]				# rax := rbp[-1024] 
	mov	QWORD PTR -8[rbp], rax			# p = line
	jmp	.L4
.L6:
	mov	rax, QWORD PTR -8[rbp]			# rax := *p
	movzx	eax, BYTE PTR [rax]			# eax := p
	test	al, al					# if ((int)*p > 127)
	jns	.L5
	mov	rax, QWORD PTR -8[rbp]			# /
	movzx	eax, BYTE PTR [rax]			# | *p 
	movzx	edx, al					# |
	mov	rax, QWORD PTR -8[rbp]			# |
	movzx	eax, BYTE PTR [rax]			# | (int)*p
	movzx	eax, al					# |
	mov	esi, eax				# \
	lea	rax, .LC0[rip]				# rax := .LC0
	mov	rdi, rax				# rdi := "Incorrect value %c, ASCII: %d", *p, (int)*p)"
	mov	eax, 0					# eax := 0 
	call	printf@PLT				# print(rdi)
.L5:
	mov	rax, QWORD PTR -8[rbp]			# /
	movzx	eax, BYTE PTR [rax]			# |
	movzx	eax, al					# | rdx := (int)*p 
	movsx	rdx, eax				# \
	mov	edx, DWORD PTR -1536[rbp+rdx*4]		# edx = alphabet[(int)*p]
	add	edx, 1					# edx++;
	cdqe
	mov	DWORD PTR -1536[rbp+rax*4], edx		# alphabet[(int)*p] = edx
	add	QWORD PTR -8[rbp], 1			# p++
.L4:
	mov	rax, QWORD PTR -8[rbp]			# rax := *p
	movzx	eax, BYTE PTR [rax]			# eax = p
	test	al, al					# if((int)*p > 127)
	jne	.L6
	mov	r13d, 0					# i = 0
	jmp	.L7
.L9:
	mov	eax, r13d 				# eax := i
	mov	eax, DWORD PTR -1536[rbp+rax*4]		# eax := alphabet[i]
	test	eax, eax				# if (alphabet[i]!=0)
	je	.L8
	mov	eax, r13d				# eax := i
	mov	ecx, DWORD PTR -1536[rbp+rax*4]		# ecx := alphabet[i]
	mov	edx, r13d				# edx := i
	mov	esi, r13d				# esi := i
	lea	rdi ,.LC1[rip]				# rdi := "ASCII:%d CHAR:%c COUNT:%d\n", i, i, alphabet[i]);
	mov	eax, 0					# eax := 0
	call	printf@PLT				# printf("ASCII:%d CHAR:%c COUNT:%d\n", i, i, alphabet[i]);        
.L8:
	add	r13d, 1					# i++
.L7:
	cmp	r13d, 127				# cmp i, 127
	jbe	.L9
	mov	eax, 0					# return 0

	leave						# /
	ret						# \выход из функции
