O7CI := result/bs-o7c

O7C := result/o7c

SING_O7 := singularity/definition
SING_C := singularity/implementation
SING_BS := singularity/bootstrap

SELF := result/self

SRC := $(filter-out $(wildcard source/VFileStream.*.ob07),$(wildcard source/*.ob07))
#SANITIZE := -ftrapv -fsanitize=undefined -fsanitize=address
SANITIZE := -ftrapv -fsanitize=undefined
WARN := -Wall -Wno-parentheses -Wno-pointer-sign
DEBUG := -g
OPTIM := -O1
CC_OPT:= $(WARN) $(OPTIM) $(DEBUG)

RM := trash

TESTS := $(addprefix result/test/,$(basename $(notdir $(wildcard test/source/*.ob07))))

result/o7c : $(patsubst source/%.ob07,result/%.c, $(SRC)) Makefile
	$(O7CI) source/Translator.ob07 result/Translator.c source $(SING_O7)
	$(CC) $(CC_OPT) $(SANITIZE) -Iresult -I$(SING_C) result/*.c $(SING_C)/*.c -o $@

result/%.c : source/%.ob07 Makefile $(O7CI)
	@mkdir -p result
	$(O7CI) $< $(basename $@) source $(SING_O7)

result/bs-o7c:
	@mkdir -p result
	$(CC) $(CC_OPT) -I$(SING_BS) $(SING_BS)/*.c -o $@

result/test/% : test/source/%.ob07 always
	@mkdir -p result/test
	$(O7C) $< $@.c $(SING_O7) test/source
	$(CC) $@.c $(SING_C)/*.c -I $(SING_C) -o $@
	$@

$(SELF)/%.c : source/%.ob07 Makefile
	@mkdir -p $(SELF)
	$(O7C) $< $(basename $@) source $(SING_O7)

$(SELF)/o7c : result/o7c $(patsubst source/%.ob07,$(SELF)/%.c, $(SRC)) Makefile
	$(O7C) source/Translator.ob07 $(SELF)/Translator.c source $(SING_O7)
	$(CC) $(CC_OPT) $(SANITIZE) -I$(SELF) -I$(SING_C) $(SELF)/*.c $(SING_C)/*.c -o $@

self : $(SELF)/o7c
	make test O7C:=-$(SELF)/o7c

self-full : result/self/o7c
	make self O7C:=-result/self/o7c SELF:=result/self2

test : result/o7c result/test/RecordExt $(TESTS)

clean :
	-$(RM) result

.PHONY : clean test self always self-full
