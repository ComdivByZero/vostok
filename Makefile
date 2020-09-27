# Makefile is deprecated, use source/make.mod

OST := result/ost

SING_BS := bootstrap

SELF := result/v1

SRC := $(wildcard source/*.mod)
SANITIZE := -fsanitize=undefined -fsanitize=address -fsanitize-undefined-trap-on-error -static-libasan -DO7_LSAN_LEAK_IGNORE
SANITIZE_TEST := $(SANITIZE)
O7_OPT := -DO7_MEMNG_MODEL=O7_MEMNG_NOFREE
#O7_OPT := -DO7_MEMNG_MODEL=O7_MEMNG_COUNTER
LD_OPT := -lm
WARN := -Wall -Wno-parentheses
DEBUG := -g
OPTIM := -O1
OPT :=
CC_OPT:= $(WARN) $(OPTIM) $(DEBUG) $(O7_OPT) $(OPT)

RM := trash

TESTS := $(addprefix result/test/,$(basename $(notdir $(wildcard test/source/*.mod))))

result/ost : result/bs-ost $(SRC) Makefile
	-rm -rf result/v0
	$< to-bin Translator.Go $@ -i singularity/definition -c $(SING_BS)/singularity -m source -m library -t result/v0 -cc "$(CC) $(CC_OPT) $(SANITIZE) $(LD_OPT)"

result/bs-ost:
	@mkdir -p result
	$(CC) $(CC_OPT) $(SANITIZE) -I$(SING_BS) -I$(SING_BS)/singularity $(SING_BS)/*.c $(SING_BS)/singularity/*.c -o $@

result/test/% : always
	@mkdir -p result/test
	-rm -rf $@.src
	$(OST) to-bin $(@F).Go $@ -infr . -m test/source -m example -memng counter -t $@.src -cc "$(CC) -g $(SANITIZE_TEST) $(LD_OPT) $(OPT)"
	$@

test : $(OST) $(TESTS)

$(SELF)/ost : $(OST) $(SRC) Makefile
	-rm -rf $(SELF)
	$(OST) to-bin Translator.Go $@ -infr . -m source -t $(SELF) -cc "$(CC) $(CC_OPT) $(SANITIZE) $(LD_OPT)"

self : $(SELF)/ost
	+make test OST:=$(SELF)/ost

self-full : result/v1/ost
	+make self OST:=$< SELF:=result/v2

help :
	@echo "Help in English:\n\
	   make help-en\n\
	Основные цели Makefile:\n\
	   result/ost - цель по умолчанию, сбор транслятора через bootstrap\n\
	   test       - прогон тестов первичным транслятором\n\
	   self       - сбор транслятора им самим и прогон тестов\n\
	   self-full  - сбор транслятора версией, полученной от self и прогон тестов\n\
	   clean      - удаление всех результатов\n\
	Основные переменные-параметры:\n\
	   CC       - компилятор C\n\
	   SANITIZE - опции компиляторов gcc-v5 и clang для контроля корректности\n\
	   OPTIM    - уровень оптимизации\n\
	   OPT      - дополнительные опции компилятора\n\
	Пример сбора транслятора без опций -fsanitize с помощью tcc:\n\
	   make CC:=tcc SANITIZE:=\n\
	"

help-en :
	@echo "Main targets of Makefile:\n\
	   result/ost - default target, build translator by bootstrap\n\
	   test       - tests by 1st generation translator\n\
	   self       - build itself then tests\n\
	   self-full  - build translator by 2nd generation translator then tests\n\
	   clean      - remove all builded results\n\
	Main variables-options:\n\
	   CC       - C compiler\n\
	   SANITIZE - options of gcc-v5 and clang for correctness control\n\
	   OPTIM    - optimization level\n\
	   OPT      - extra compiler's options\n\
	Example of build translator without -fsanitize by Tiny C:\n\
	   make CC:=tcc SANITIZE:=\n\
	"

clean :
	-$(RM) result

.PHONY : clean test self always self-full help
