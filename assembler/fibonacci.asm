reset:
MOV 0x0000001,R1  ; Initialize 
MOV 0x0000001,R2
lbl1:
MOV R1+R2,R3    ; Calculate the next fibonacci number
MOV R2,R1       ; Shift the result into the proper registers.
MOV R3,R2
JMP lbl1