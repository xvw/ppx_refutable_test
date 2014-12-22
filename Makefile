.PHONY : ppx clean

SRC    = src
BIN    = bin
EXA    = examples
PACK   = -package compiler-libs.common -linkpkg
OPT    = ocamlopt
CC     = ocamlc -I $(SRC) 
FIND   = ocamlfind

ifeq ($(TEST), yes)
	PPX = -ppx $(BIN)/ppx_test.native
else ifeq ($(TEST), no) 
	PPX = -ppx $(BIN)/ppx_no_test.native
endif

ifeq ($(DSOURCE), yes)
	SOURCE = -dsource
endif

ppx : ppx_no_test.native ppx_test.native

%.native : $(SRC)/%.ml
	$(FIND) $(OPT) $(PACK) $(<) -o $(BIN)/$(@)

mini_unit :
	$(CC) $(SRC)/$(@).mli
	$(CC) $(SRC)/$(@).ml

# example compilation
example% : $(EXA)/example%.ml ppx mini_unit
	$(CC) $(PPX) $(SOURCE) mini_unit.cmo $(<) -o $(BIN)/$(@)

clean : 
	rm -rf $(BIN)/*
