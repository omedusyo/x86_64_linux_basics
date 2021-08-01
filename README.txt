Going through https://www.youtube.com/playlist?list=PLetF-YjXm-sCH6FrTz4AQhfH6INDQvQSn

```
nasm -f elf64 -o app.o 0_hello.asm
ld app.o -o app
./app
```


Linux x86_64 calling convention

* Stack is orginized into frames
* each function call gets its own frame
* `rbp` points to the top of the current stack frame,
  `rsp` points to the bottom of the current stack frame
* call instruction pushes rip onto the stack and then
  jumps to the function code
* ret pops rip from the stack and returns to the caller
* How to maintain the register state across all of those function calls?
  Suppose function A calls function B. Who is responsible
  for saving the state of the registers, the caller of the one who is called?
  x86_64 linux convention:
    a mix of both... some of the registers have to be saved by the caller and some by the one who is called
    * The only registers the the one who is called has to save are
        `rbx, rbp, r12` (if he uses them ofcourse)
    * All other registers are the responsibility of the caller
* See https://wiki.osdev.org/System_V_ABI for more details
* High level explanation at https://www.youtube.com/watch?v=wt7a5BOztuM

