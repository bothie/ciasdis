

ASSEMBLER
1278 ORG
\ Here it all starts
\ Fasten Your Seat Belts (tm)
    CLD,                  \ First instruction
    MOV, X| T| DI'| MEM| XXX L,
:QQQ
    POP|ES,
    ADD, B| F| AL'| D0| [SI]
    MOV, X| T| DI'| MEM| XXX L,
\ XXX is a target for backward jumps:
:RRR
        DB  1 ^C &C  65 65 80
        DW  1 ^C &C  65 65 80
        DL  1 ^C &C  65 65 80
:XXX
    MOV, X| T| DI'| MEM| QQQ L,
    JMP, XXX RL,
    JMP, XXX _AP_ 4 + - (RL,)
    JMP, XXX 1- RL,
    JMPS, XXX RB,
    JMPS, XXX 1- RB,
    JMP, YYY RL,
    JMP, YYY 1- RL,
    JMPS, YYY RB,
    JMPS, YYY 1- RB,
    LEA, AX'| DB| [AX +4* AX] 0 B,
\ YYY is a target for forward jumps:
:YYY

PREVIOUS
