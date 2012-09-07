; Recursive fibonacci:
MOV 0xFFFFFFFF,SP  ; Initialize stack

MOV 0x00000004,R1
CALL recfibonacci
halt:
JMP halt


; Param and result in R1
recfibonacci:
PUSH R8
PUSH R2
MOV 0x00000002,R2
MOV R1-R2,R8
BR NS, recfibnonout
POP R8
POP R2
RET ; If n==0 or n==1 return n
recfibnonout:
; Recurse n-1 and n-2
MOV 0x00000001,R2
PUSH R3
PUSH R4
MOV R1-R2,R3
MOV R3,R1
CALL recfibonacci ; R1 <- F(N-1)
MOV R1,R4
MOV R3-R2,R1
CALL recfibonacci ; R1 <- F(N-2)
MOV R1+R4,R1 ; R1 <- F(N-2) + F(N-1)
POP R4
POP R3
POP R2
POP R8
RET