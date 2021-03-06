# $Id$
# Copyright(2000): Albert van der Horst, HCC FIG Holland by GNU Public License
#
# This defines the usage of ciforth to build assemblers and reverse
# engineering tools.

# FIXME: Bear with me. This was adapted from the Makefile of ciforth
# and contains a lot of stuff that has to be cleaned out.
# It distracts but does no harm, other than that non-assembler targets
# don't build.

#.SUFFIXES:
#.SUFFIXES:.bin.asm.v.o.c

# Applicable suffixes : * are generated files
# + are generated files if they are mentionned on the next line
#
#* .dvi .tex .ps : as usual (See TeX)
#   menu.texinfo gloss.texinfo
# .frt : text file : contains blocks in an \n separated stream
#* .bin : a binary image without header

# ALL FILES STARTING IN ``ci86'' (OUTHER ``ci86.gnr'') ARE GENERATED

# The following directory are supposedly in line with the
# Debian FHS directory philosophy.
INSTALLDIR=/
INSTALLED_LAB=$(INSTALLDIR)/usr/lib/ciasdis.lab
INSTALLED_BIN=$(INSTALLDIR)/usr/bin/ciasdis



ASTARGETS= cias cidis ciasdis test.bin test2.bin test2.asm

# Generic source for assembler
# Include two pass, reverse engineering.
ASSRC= \
access.frt   \
aswrap.frt   \
asgen.frt    \
ciasdis.frt  \
crawl.frt    \
labelas.frt  \
labeldis.frt \
tools.frt    \
# That's all folks!

# Extra source for MS os.
ASSRCCLUDGE= \
cias.frt \
cidis.frt \
# That's all folks!

TESTTARGETS= \
testset386   \
testset386a  \
testset6809  \
testset8080  \
testset8086  \
testsetalpha   \
testsetpentium \
# That's all folks!

# Plug ins for stand alone assembler
PGSRC= \
as6809s.frt \
as80.frt        \
asi86.frt       \
asi386.frt      \
asalpha.frt     \
# That's all folks!

# Other Forth source.
#   Quick reference sheet generator
#   Complete small, stand alone assemblers
UNPSRC= \
ps.frt    \
ass.frt  \
#as6809s.frt \
# That's all folks!

# Consult files for general use
CUL= \
elf.cul \
exeheader.cul \
# That's all folks!

# Documentation files and archives
# Formally forth.lab is for error messages, but
# you can load debug tools from it too.
DOC = \
COPYING   \
forth.lab      \
cul.5           \
ciasdis.1          \
README.assembler \
assembler.itxt  \
p0.asi386.ps    \
p0F.asi386.ps   \
qr8086.ps       \
qr8080.ps       \
# That's all folks!

# Test files for assemblers.
TESTAS= \
testset8080     \
testset8086     \
testset386      \
testset386a     \
testsetpentium  \
testset6809     \
testsetalpha    \
asm386endtest   \
# That's all folks!

# Test files for reverse engineering and two pass.
TESTRV= \
test.asm        \
test.cul        \
lina405         \
linacrawl.cul   \
lina405equ.cul  \
lina405.cul     \
# That's all folks!

# Test output references
TESTREF=        \
lina405.asm     \
# That's all folks!

RELEASEASSEMBLER=      \
Makefile        \
$(ASSRC)        \
$(PGSRC)        \
$(UNPSRC)       \
$(CUL)          \
$(DOC)          \
$(TESTRV)         \
# That's all folks!

RELEASECONTENT = \
COPYING   \
README.assembler \
ciasdis.1          \
cul.5           \
$(ASSRC)        \
# That's all folks!

BINRELEASE = \
COPYING   \
README.assembler \
ciasdis.1          \
cul.5           \
ciasdis         \
ciasdis.lab       \
# That's all folks!

# 4.0 ### Version : an official release 4.0
# Left out : beta, revision number is taken from rcs e.g. 3.154
VERSION=  # Because normally VERSION is passed via the command line.

TEMPFILE=/tmp/ciforthscratch

MASK=FF
PREFIX=0
TITLE=QUICK REFERENCE PAGE FOR 80386 ASSEMBLER
TESTTARGETS= test.bin lina405.asm rf751.asm rf751.cul
DEBIANFILES=control

# How to check out, anything
%:RCS/%,v
        co -r$(RCSVERSION) $<

# Install a configured binary.
install_bin: ciasdis
        mkdir -p $(INSTALLDIR)/usr/bin
        echo '"/usr/lib/ciasdis.lab" BLOCK-FILE \$\!' \
         '"'$(INSTALLED_BIN)'"' SAVE-SYSTEM BYE |\
        ciasdis

install:  default control ciasdis.1 cul.5 install_bin
        mkdir -p $(INSTALLDIR)/DEBIAN
        cp -f control $(INSTALLDIR)/DEBIAN
        mkdir -p $(INSTALLDIR)/usr/lib
        cp ciasdis.lab  $(INSTALLED_LAB)
        mkdir -p $(INSTALLDIR)/usr/share/man/man1
        mkdir -p $(INSTALLDIR)/usr/share/man/man5
        cp -f ciasdis.1 $(INSTALLDIR)/usr/share/man/man1
        cp -f cul.5 $(INSTALLDIR)/usr/share/man/man5
        find $(INSTALLDIR) -type d | xargs chmod 755
        find $(INSTALLDIR) -type f | xargs chmod 644
        chmod 755 $(INSTALLDIR)/usr/bin/ciasdis
        gzip -9 -r $(INSTALLDIR)/usr/share/man

# If tests fails, test targets must be inspected.
.PRECIOUS: rf751.asm lina405.asm test.bin

.PHONY: RELEASE default all clean releaseproof zip regressiontest debian
# Default target for convenience
default : ciasdis ciasdis.lab
ci86.$(s).bin :

# Some of these targets make no sense and will fail
all: regressiontest

clean: testclean asclean install_clean; rcsclean

install_clean:
        rm -r $(INSTALLDIR)

#Install it. To be run as root
debian: ciasdis ciasdis.1 cul.5
        ./ciasdis -i $(INSTALLDIR)/usr/bin/ciasdis  $(INSTALLDIR)/usr/lib/ciasdis.lab
        cp cias.1 $(INSTALLDIR)/usr/share/man/man1
        cp cul.5 $(INSTALLDIR)/usr/share/man/man5

# Get the library file that is used while compiling.
ciasdis.lab : ; echo 'BLOCK-FILE $$@ GET-FILE "'$@'" PUT-FILE'|lina

# Make a source distribution.
srczip : $(RELEASECONTENT) ; echo ciasdis-dev-$(VERSION).tar.gz $+ | xargs tar -cvzf
# Make a normal, binary distribution.
zip : $(BINRELEASE) ; echo ciasdis-$(VERSION).tar.gz $+ | xargs tar -cvzf

testclean: ; rm -f $(TESTTARGETS)

asclean: ; rm -f $(ASTARGETS)

releaseproof : ; for i in $(RELEASECONTENT); do  rcsdiff -w $$i ; done

# WARNING : the generation of postscript and pdf use the same files
# for indices, but with different content.

# Using the elective screen requires the exact library coming
# with the assembler!
%.ps : asgen.frt %.frt ps.frt ; \
    ( \
        cat $+ ;\
        echo 'PRELUDE' ;\
        echo 'HEX $(MASK) MASK ! $(PREFIX) PREFIX ! DECIMAL ' ;\
        echo ' "$(TITLE)"   TITLE $$!' ;\
        echo ' QUICK-REFERENCE BYE' \
    )|\
    lina -e |\
    sed '1,/SNIP TILL HERE/d' |\
    sed '/SI[MB]/d' |\
    sed '/OK/d' >p$(PREFIX).$@

qr8080.ps       :; make as80.ps TITLE='QUICK REFERENCE PAGE FOR 8080 ASSEMBLER'; mv p0.as80.ps $@
qr8086.ps       :; make asi86.ps TITLE='QUICK REFERENCE PAGE FOR 8086 ASSEMBLER'; mv p0.asi86.ps $@
p0.asi386    :; make asi386.ps PREFIX=0 MASK=FF
p0F.asi386.ps   :; make asi386.ps PREFIX=0F MASK=FFFF
p0F.asiP.ps   :; make asiP.ps PREFIX=0F MASK=FFFF

x : ; echo $(RELEASECONTENT)
y : ; echo $(RELEASECONTENT) |\
sed -e's/\<ci86\.//g' |\
sed -e's/\<gnr\>/ci86.gnr/' |\
sed -e's/ \([^ .]\{1,8\}\)[^ .]*\./ \1./g'

ci86.lina.s :

# ------------------- TARGET TESTS ---------------------------------
# All the test<target> assemble a testset<target> with virtually
# all combinations of instructions, then disassemble then compared.
# A previous diff file is in RCS

testasalpha: asgen.frt asalpha.frt testsetalpha ; \
        echo INCLUDE asgen.frt INCLUDE asalpha.frt INCLUDE testsetalpha |\
        lina -e |\
        sed '1,/TEST STARTS HERE/d' |\
        sed 's/^[0-9A-F \.,]*://' >$@ ;\
        diff -w $@ testsetalpha >$@.diff ;\
        rcsdiff -bBw -r$(RCSVERSION) $@.diff

testas6809: asgen.frt as6809.frt testset6809 ; \
        echo INCLUDE asgen.frt INCLUDE as6809.frt INCLUDE testset6809 |\
        lina -e |\
        sed '1,/TEST STARTS HERE/d' |\
        sed 's/^[0-9A-F \.,]*://' >$@ ;\
        diff -w $@ testset6809 >$@.diff ;\
        rcsdiff -bBw -r$(RCSVERSION) $@.diff

testas80: asgen.frt as80.frt testset8080 ; \
    echo INCLUDE asgen.frt INCLUDE as80.frt INCLUDE testset8080 |\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8080 >$@.diff ;\
    rcsdiff -bBw $@.diff

testas86: asgen.frt asi86.frt testset8086 ; \
    echo INCLUDE asgen.frt INCLUDE asi86.frt INCLUDE testset8086 |\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset8086 >$@.diff ;\
    rcsdiff -bBw $@.diff

testas386: asgen.frt asi386.frt testset386 ; \
    echo INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE testset386 |\
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386 >$@.diff ;\
    rcsdiff -bBw $@.diff

# This is limited to pentium instructions common to all pemtiums,
# excluded those tested by testas386
testaspentium: asgen.frt asi386.frt asipentium.frt testsetpentium ; \
    echo INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE asipentium.frt INCLUDE testsetpentium | \
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testsetpentium >$@.diff ;\
    rcsdiff -bBw $@.diff

# Special test to exercise otherwise hidden instructions.
testas386a: asgen.frt asi386.frt testset386a ; \
    echo INCLUDE asgen.frt INCLUDE asi386.frt INCLUDE testset386a | \
    lina -e|\
    sed '1,/TEST STARTS HERE/d' |\
    sed '/^OK$$/d' |\
    sed 's/^[0-9A-F \.,]*://' >$@       ;\
    diff -w $@ testset386a >$@.diff ;\
    rcsdiff -bBw $@.diff

# ------------------- TARGET TESTS ---------------------------------

# Do all tests applicable to Pentium
testallpentium : testas386 testas386a testaspentium

testasses : testasalpha testas6809 testas80 testas86 testallpentium

test386: asgen.frt asi386.frt ; \
    echo INCLUDE asgen.frt INCLUDE asi386.frt ASSEMBLER HEX BITS-32   SHOW-ALL|\
    lina -e|\
    sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
    sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
    sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
    sed 's/~SIB|   14 SIB,,/[AX +1* BX]/'|\
    grep -v ciforth >$@;\
    rcsdiff -bBw -r$(RCSVERSION) $@

test386.diff: test386 ; \
    cat testset386 >tempie;\
    diff -w $+ tempie >$@ ;\
    rcsdiff -bBw -r$(RCSVERSION) $@

testinstructionsets : test386.diff

# There is a problem here: SHOW-ALL shows almost nothing
# because asi386.frt is not loaded.
# testpentium: asgen.frt asipentium.frt ; \
#     (cat $+;echo ASSEMBLER HEX SHOW-ALL)|\
#     lina -e|\
#     sed 's/~SIB|   10 SIB,,/[DX +1* DX]/' |\
#     sed 's/~SIB|   18 SIB,,/[DX +1* BX]/' |\
#     sed 's/~SIB|   1C SIB,,/[AX +1* 0]/' |\
#     sed 's/~SIB|   14 SIB,,/[AX +1* BX]/' >$@       ;\
#     diff -w $@ testsetpentium >$@.diff ;\
#     diff $@.diff testresults

test386-16: asgen.frt asi386.frt ; \
    echo INCLUDE asgen.frt INCLUDE asi386.frt | \
    echo ASSEMBLER HEX BITS-16   SHOW-ALL)|\
    lina -e >$@       ;
#   diff -w $@ testset386 >$@.diff ;\
#   diff $@.diff testresults

# As by : make RELEASE VERSION=1-0-0
RELEASE: $(RELEASEASSEMBLER) cias ciasdis cidis $(ASSRCCLUDGE) ;\
    echo ciasdis-$(VERSION).tgz $+ | xargs tar cfz

# Preliminary until it is clear whether we want other disassemblers.
# Note: this will copy forth.lab to the local directory.
ciasdis : forth.lab $(ASSRC) asi386.frt asipentium.frt ; lina -c ciasdis.frt
cias : ciasdis ; ln -f ciasdis cias
cidis : ciasdis ; ln -f ciasdis cidis

test.bin : ciasdis cidis cias test.asm test.cul
        ciasdis -a test.asm test.bin
        ciasdis -d test.bin test.cul > test2.asm
        ciasdis -a test2.asm test2.bin
        diff test2.bin test.bin
        rcsdiff -r$(RCSVERSION) test.bin
        rcsdiff -b -B -r$(RCSVERSION) test2.asm
        cias test.asm test.bin
        cidis test.bin test.cul > test2.asm
        cias test2.asm test2.bin
        diff test2.bin test.bin
        rcsdiff -r$(RCSVERSION) test.bin
        rcsdiff -b -B -r$(RCSVERSION) test2.asm

lina405.asm : ciasdis lina405 lina405equ.cul lina405.cul
        chmod +w lina405
        ciasdis -d lina405 lina405.cul >$@
        ciasdis -a $@ lina405
        rcsdiff -r$(RCSVERSION) lina405
        rcsdiff -b -B -r$(RCSVERSION) $@

# Test case, reverse engineer retroforth version 7.5.1.
rf751.cul : ciasdis rf751 rf751equ.cul rfcrawl.cul elf.cul
        chmod +w rf751
        echo FETCH rf751 INCLUDE rfcrawl.cul | ciasdis >$@
        rcsdiff -bBw -r$(RCSVERSION) $@

rf751.asm : ciasdis rf751 rf751equ.cul rf751.cul
        chmod +w rf751
        ciasdis -d rf751 rf751.cul >$@
        rcsdiff -bBw -r$(RCSVERSION) $@
        ciasdis -a $@ rf751
        rcsdiff -r$(RCSVERSION) rf751

%.bin : %.asm ; ciasdis -a $< $@

cidis386.zip : $(ASSRC) asi386.frt asipentium.frt ;  zip $@ $+

testciasdis : test.bin lina405.asm rf751.asm

# -----------------
regressiontest : testasses testciasdis testinstructionsets
