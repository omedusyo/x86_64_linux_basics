SYS_EXIT equ 60

section .data

; 64 bit var
qVar1:
  dq 170000000
qVar2:
  dq 90000000
qResult:
  dq 0

test:
  dd 0x120000ab

; ab, 00, 00, 12

; string
str:
  db "hello, world", 10, 0

section .text
  global _start

_start:

  mov rax, 0xff00aa00110012cd
  push rax
  push 5
  push 6
  pop rax
  pop rbx
  pop rcx

  ; wResult <- wVar1 + wVar2
  mov rax, qword [qVar1]
  add rax, qword [qVar2]
  mov qword [qResult], rax

  mov rbx, 3
  mov rcx, 4
  call pyth

  mov rbx, str
  call strlen

last:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall

square_rax:
  mul rax
  ret

; rbx, rcx
; output in rax
pyth:
  mov rax, rbx
  call square_rax
  mov rbx, rax

  mov rax, rcx
  call square_rax
  add rax, rbx

  ret

; assume the address of the string is in rbx
; out: rax will contain the length of the string
strlen:
  mov rax, 0
.loop:
  mov cl, byte [rbx]
  cmp cl, 0
  je .end
  inc rax
  inc rbx
  jmp .loop
.end:

  ret


