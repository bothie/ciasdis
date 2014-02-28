( $Id$ )
( Copyright{2000}: Albert van der Horst, HCC FIG Holland by GNU Public License)
 ASSEMBLER DEFINITIONS HEX

\ Instructions that are in all Pentium's, but not in i386.

\ Morebad bits ...
(  FP:        10,0000 FP-specific   20,0000 Not FP                      )
(  second op 100,0000 integer op    20,0000 FP operand                  )
                                HEX
\ 0F prefix
0 0 0 T!        0100 080F 2 2FAMILY, INVD, WBINVD,
0 0 0 AA0F 2PI RSM,
0 0 0 0B0F 2PI Illegal-1,
0 0 0 B90F 2PI Illegal-2,
0112 0 0700 C80F 2PI BSWAP,
0 0 0 T!        0100 300F 3 2FAMILY, WRMSR, RDTSC, RDMSR,
04,1400 0 FF0100  T!  1000 B00F 2 3FAMILY, CMPXCHG, XADD,

\ 0F prefix with mod r/m byte: 0F01 grp7 / 0FC7 grp 8
0 0 0 38010F 3PI INVLPG,
0022 0 C70000 08C70F 3PI CMPXCHG8B,

\ ######################### FP #############################################

(  Allow m|   40,0000 not allowed   80,0000 is |m                       )
(  memory    100,0000 fp           200,0000 int                         )
\ Floating point registers.
0010,0112 0 07 T!
   01 00 8 FAMILY|R ST0| ST1| ST2| ST3| ST4| ST5| ST6| ST7|
0110,0022 0 0400 T!       0400 00 2 FAMILY|R s| d|     \ Single/Double 16/32
0210,0022 0 0400 T!       0400 00 2 FAMILY|R |32 |16   \ memory int
\ Abormal: ST0 is the second operand
0010,0000 0 0008 T!       0008 00 2 FAMILY|R n| a|     \ Normal abnormal 
0050,0112 0 04C0 00C0 FIR u| \ 2th register not modified, ST0 begets result
0090,0112 0 04C0 04C0 FIR m| \ 2th register modified, begets result

0110,0000 0 C704 T!      0800 00D8 2 2FAMILY, FADD, FMUL,
0150,0000 0 C704 T!      0800 10D8 2 2FAMILY, FCOM, FCOMP,
0110,0000 0 CF04 T!      1000 20D8 2 2FAMILY, FSUB, FDIV,
0110,0022 0 C704 T!      0800 10D9 2 2FAMILY, FST, FSTP,
0010,0022 0 C700 T!      0800 20D9 4 2FAMILY, FLDENV, FLDCW, FSTENV, FSTCW,
0150,0000 0 C704 00D9 2PI FLD,
0010,0112 0 0700 C8D9 2PI FXCH,
0 0 0 D0D9 2PI FNOP,
0 0 0 T!
0100 E0D9 6 2FAMILY, FCHS, FABS, -- -- FTST, FXAM,
0100 E8D9 7 2FAMILY, FLD1, FLDL2T, FLDL2E, FLDPI, FLDLG2, FLDLN2, FLDZ,
0100 F0D9 8 2FAMILY, F2XM1, FYL2X, FPTAN, FPATAN, FXTRACT, FPREM1, FDECSTP, FINCSTP,
0100 F8D9 8 2FAMILY, FPREM, FYL2XP1, FSQRT, FSINCOS, FRNDINT, FSCALE, FSIN, FCOS,

0210,0022 0 C704 T!     0800 00DA 4 2FAMILY, FIADD, FIMUL, FICOM, FICOMP,
0210,0022 0 CF04 T!     1000 20DA 2 2FAMILY, FISUB, FIDIV,
0 0 0 E9DA 2PI FUCOMPP,
0210,0022 0 C704 T!     0800 00DB 4 2FAMILY, FILD, -- FIST, FISTP,
0010,0022 0 C700 T!     1000 28DB 2 2FAMILY, FLD|e, FSTP|e,
0 0 0 E2DB 2PI FCLEX,           0 0 0 E3DB 2PI FINIT,

0010,0022 0 C700 T!     0800 20DD 4 2FAMILY, FRSTOR, -- FSAVE, FSTSW,
0010,0112 0 0700 T!     0800 C0DD 6 2FAMILY, FFREE, -- FST|u, FSTP|u, FUCOM, FUCOMP,

0010,0112 0 0700 T!      0800 C0DE 2 2FAMILY, FADDP, FMULP,
0010,0112 0 0F00 T!      1000 E0DE 2 2FAMILY, FSUBP, FDIVP,
0 0 0 D9DE 2PI FCOMPP,

0010,0022 0 C700 T!     0800 20DF 4 2FAMILY, FBLD, FILD|64, FBSTP, FISTP|64,
0 0 0 E0DF 2PI FSTSW|AX,

PREVIOUS DEFINITIONS DECIMAL
          EXIT
