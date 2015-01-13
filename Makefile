.PHONY : ppx clean

SRC    = src
BIN    = bin
EXA    = examples
PACK   = -package compiler-libs.common -linkpkg
OPT    = ocamlopt
CC     = ocamlc -I $(SRC) 
FIND   = ocamlfind
OUNIT  = -package oUnit -linkpkg -g
CCUNIT = ocamlc $(PPX) -o $(BIN)/test $(OUNIT)

ifeq ($(TEST), yes)
	PPX = -ppx $(BIN)/ppx_test.native
else ifeq ($(TEST), no) 
	PPX = -ppx $(BIN)/ppx_no_test.native
endif

ifeq ($(DSOURCE), yes)
	SOURCE = -dsource
endif

make_dir :
	mkdir -p $(BIN)

ppx : ppx_no_test.native ppx_test.native

mini_unit : 
	$(CC) $(SRC)/mini_unit.mli
	$(CC) $(SRC)/mini_unit.ml

%.native : $(SRC)/%.ml make_dir
	$(FIND) $(OPT) $(PACK) $(<) -o $(BIN)/$(@)

# example compilation
example% : $(EXA)/example%.ml ppx mini_unit make_dir
	$(CC) $(PPX) $(SOURCE) mini_unit.cmo $(<) -o $(BIN)/$(@)

clean : 
	rm -rf $(BIN)/*

# OUnit example :
OUnit_example : ppx
	$(FIND) $(CCUNIT) $(SOURCE) $(EXA)/exampleOunit.ml
