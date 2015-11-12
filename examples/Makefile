OCAMLC = ocamlc -ppx ../ppx_refutable_test.native

ifeq ($(DSOURCE), yes)
	SOURCE = -dsource
endif

sample1:
	$(OCAMLC) $(SOURCE) sample1.ml -o sample1.byte

sample1-std:
	ocamlc $(SOURCE) sample1.ml -o sample1.byte

clean:
	rm -rf *~
	rm -rf \#*
	rm -rf *.cm*
	rm -rf *.byte
