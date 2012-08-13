"""
    Simple, grammarless assembler for XENTRAL CPU
"""
import sys
import argparse
import re


labelre = re.compile("([A-Z,a-z][A-Z,a-z,0-9]*):$")
statementre = re.compile("([A-Z,a-z]{2,4})")

def parser(src):
    """
        Iterator that yields statements
    """
    with open(src,'r') as f:
        for line in f:
            line = line.strip()
            # ignore everything after '#'
            line = line.split("#")[0].strip()
            # 
            # At the moment there are three acceptable line compositions:
            # 1) A statement
            # 2) A label
            # 3) Nothing (just a comment or an empty line)
            if not line:
                # case 3)
                continue
            mo = labelre.match(line)
            if mo:
                # case 2)
                yield "LABEL", mo.group(1)
                continue
            if statementre.match(line):
                # case 1)
                parts = line.split()
                opcode = parts[0]
                rest = "".join(parts[1:])
                operands = rest.split(',')
                yield "STATEMENT", (opcode, operands)
                continue
            # If we get here: trouble!
            raise SyntaxError

busre = re.compile("((R\d)(\+|-|&|\|)(R\d))|((-|~|)(R\d))$")
busindirectre = re.compile("\[(((R\d)(\+|-|&|\|)(R\d))|((-|~|)(R\d)))\]$")
busindirect2re = re.compile("\[(((R\d)(\+|-|&|\|)(R\d))|((-|~|)(R\d)))\]((\+|-|&|\|)(R\d))?$")

operand_type_re = [
    ("IMM",re.compile("0x[0-9,a-f,A-F]+$")),
    ("R",re.compile("(R\d|SP)$")),
    ("LBL",re.compile("([A-Z,a-z][A-Z,a-z,0-9]*)$")),
    ("B",busre),
    ("BI", busindirectre),
    ("BI2", busindirect2re),
]
            

def operand_type(operand):
    """
        Determine operand type
    """
    for code, opre in operand_type_re:
        if opre.match(operand):
            return code
    raise SyntaxError
    


def encode_register(reg):
    return int(reg[1])


operation_code = {
    "&":0x0,
    "|":0x1,
    "^":0x2,
    "+":0x5,
    "-":0x6,
    "U~":0x7, # Unary
    "U-":0x8,
    "U":0xA,
}

def movBR(operands):
    inst = 0x0000
    mo = busre.match(operands[0])
    
    # Unary or binary?
    if mo.group(1):
        # Binary    
        inst += operation_code[mo.group(3)] << 12 # OP
        inst += encode_register(mo.group(2)) << 8 # LD1
        inst += encode_register(mo.group(4)) << 4 # LD2
        inst += encode_register(operands[1])      # DR3
        return inst
    else:
        # Unary        
        inst += operation_code["U"+mo.group(6)] << 12 # OP
        inst += encode_register(mo.group(7)) << 8 # LD1
        inst += encode_register(operands[1])      # DR3
        return inst
        
def movBI2R(operands):
    inst = 0x20000000
    mo = busindirect2re.match(operands[0])

    # Destination register
    inst += encode_register(operands[1])      # DR3
   
    # Main adressing group (Bottom ALU)
    # Unary or binary?
    if mo.group(2):
        # Binary    
        inst += operation_code[mo.group(4)] << 12 # OP
        inst += encode_register(mo.group(3)) << 8 # LD1
        inst += encode_register(mo.group(5)) << 4 # LD2
    else:
        # Unary        
        inst += operation_code["U"+mo.group(7)] << 12 # OP
        inst += encode_register(mo.group(8)) << 8 # LD1

    # Content adjust group, (Top ALU)
    if mo.group(9):
        inst += operation_code[mo.group(10)] << 24 # OP
        inst += encode_register(mo.group(11)) << 16 # LD1
        

    return inst


def movBBI(operands):
    inst = 0x30000000
      
    # Source
    # Value group (Top ALU)
    mo = busre.match(operands[0])
    
    # Unary or binary?
    if mo.group(1):
        # Binary    
        inst += operation_code[mo.group(3)] << 24 # OP
        inst += encode_register(mo.group(2)) << 20 # LD1
        inst += encode_register(mo.group(4)) << 16 # LD2
    else:
        # Unary        
        inst += operation_code["U"+mo.group(6)] << 24 # OP
        inst += encode_register(mo.group(7)) << 20 # LD1
    
    # Destination
    # Main adressing group (Bottom ALU)
    mo = busindirectre.match(operands[1])   
    
    # Unary or binary?
    if mo.group(2):
        # Binary    
        inst += operation_code[mo.group(4)] << 12 # OP
        inst += encode_register(mo.group(3)) << 8 # LD1
        inst += encode_register(mo.group(5)) << 4 # LD2
    else:
        # Unary        
        inst += operation_code["U"+mo.group(7)] << 12 # OP
        inst += encode_register(mo.group(8)) << 8 # LD1
    
    return inst
    
    mo = busindirect2re.match(operands[0])
    print operands
    print mo.groups()
    print mo.group(0)

    # Destination register
    inst += encode_register(operands[1])      # DR3
   
    # Main adressing group (Bottom ALU)
    # Unary or binary?
    if mo.group(2):
        # Binary    
        inst += operation_code[mo.group(4)] << 12 # OP
        inst += encode_register(mo.group(3)) << 8 # LD1
        inst += encode_register(mo.group(5)) << 4 # LD2
    else:
        # Unary        
        inst += operation_code["U"+mo.group(7)] << 12 # OP
        inst += encode_register(mo.group(8)) << 8 # LD1

    # Content adjust group, (Top ALU)
    if mo.group(9):
        inst += operation_code[mo.group(10)] << 24 # OP
        inst += encode_register(mo.group(11)) << 16 # LD1
        

    return inst


def movIMMR(operands):
    inst = 0x10000000
    inst += int(operands[0],16) << 4
    inst += encode_register(operands[1])      # DR3
    return inst
    
def movINDR(operands):
    print operands
    pass

def jmpIMM(operands):
    inst = 0xf0000000
    inst += operands[0]
    return inst

assemblers = {
    ("MOV","R","R"):movBR,
    ("MOV","B","R"):movBR,
    ("MOV","BI","R"):movBI2R,
    ("MOV","BI2","R"):movBI2R,
    ("MOV","B","BI"):movBBI,
    ("MOV","IMM","R"):movIMMR,
    ("JMP","IMM"):jmpIMM,
}

def assemble(src):
    """
        Basic two-pass assemble cycle
    """
    program = []
    labels = {}
    usedlabels = []
    
    # PASS ONE
    
    for parseresult in parser(src):
        rtype, res = parseresult
        if rtype == "STATEMENT":
            # Add the statement to the program
            opcode, operands = res
            sig = [opcode]
            for operand in operands:
                sig.append(operand_type(operand))
            if "LBL" in sig:
                # handle label
                usedlabels.append((len(program),sig, operands))
                program.append(0xdeadbeef)
            else:
                inst = assemblers[tuple(sig)](operands)
                program.append(inst)
        elif rtype == "LABEL":
            # Store the label location
            labels[res] = len(program)

    print ["%08x" % i for i in program]

    # PASS TWO
    for address, sig, operands in usedlabels:
        # perform label address replacement
        for i,t in enumerate(sig[1:]):
            if t == "LBL":
                sig[i+1] = "IMM"
                operands[i] = labels[operands[i]]
        inst = assemblers[tuple(sig)](operands)
        program[address] = inst
    
    print ["%08x" % i for i in program]


def main():
    parser = argparse.ArgumentParser(description='Assembler for XENTRAL CPU.')
    parser.add_argument('src', metavar='source.asm', type=unicode, nargs=1,
                       help='the file to assemble')

    args = parser.parse_args()
    src = args.src[0]
    assemble(src)
    
    
    
if __name__=="__main__":
    main()