STDIN equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

; this is nasm specific macro definition
%macro exit 0
  mov rax, SYS_EXIT ; syscall `sys_exit`
  mov rdi, 0 ; this is like `return 0` i.e. 0 means Success
  syscall
%endmacro

%macro write_out 2
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, %1
  mov rdx, %2
  syscall
%endmacro

%macro print 1
  mov rax, %1
  mov rbx, 0 ; loop counter. After the loop it will contain the length of the string.
%%loop:
  mov cl, [rax]
  cmp cl, 0
  je %%endloop
  inc rax
  inc rbx
  jmp %%loop
%%endloop:

  write_out %1, rbx
  
%endmacro


section .data
  digit:
    db 0, 10
  newline:
    db 10

section .text
  global _start

_start:
  ; Recall that
  ;   rdx 0
  ;   div x
  ; will do the following
  ;   rax <- rax // x
  ;   rdx <- rax %  x

  mov rax, 1236
  mov rbx, 10 

  ; This will print the nat stored in rax in reverse
._loop:
  mov rdx, 0
  div rbx ; for some reason we can't just put constant 10 here
  push rax
  call _print_digit_DL
  pop rax
  cmp rax, 0
  jne ._loop

  call _print_newline



  ; compute
    ; div 10 ; this will divide rax by 10 and store the remainder in rdx

  ; save rax
  ; push rax
  ;   print rdx

  exit

; prints the digit stored in dl
_print_digit_DL:
  add dl, 48
  mov [digit], dl
  write_out digit, 1

  ret

_print_newline:
  write_out newline, 1

  ret

