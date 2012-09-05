reset:
MOV 0xFFFFFFFF,SP  ; Initialize stack

; Generic sanity checks
; - All registers
MOV 0x01010101, R1
MOV R1,R2
MOV R2,R3
MOV R3,R4
MOV R4,R5
MOV R5,R6
MOV R6,R7
MOV R7,R8
MOV R8-R1,R1
BR NZ,fail

; By instruction 
; Test ALU path (0x0)
MOV 0x00f0f0f0,R1
MOV 0x0f0f0f0f,R2
MOV 0x00000001,R3
MOV R1,R7       ; Comparison tests, zero and sign flags
MOV R1-R7,R8    
BR NZ,fail
MOV R1-R7,R8    
BR S,fail
MOV R7+R3,R7
MOV R1-R7,R8
BR Z,fail
MOV R1-R7,R8
BR NS,fail
MOV R7-R1,R8
BR S,fail
MOV R7-R1,R8
BR Z,fail
; ...

; Test Immediate (0x1)

; Test indirect loads/stores (0x2/0x3)
; Assume we have at least 256 words of memory incl. stack
MOV 0x00101010,R1
MOV 0x00000001,R2
MOV R1,[R2]
MOV [R2],R3
MOV R3-R1,R9
BR NZ,fail
; ...
 
pass:
MOV 0xAAAAAAAA,R1
JMP pass

fail:
MOV 0xBBBBBBBB,R1
JMP fail
