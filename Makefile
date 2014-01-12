OCAMLC=ocamlfind ocamlc -package js_of_ocaml -package js_of_ocaml.syntax -syntax camlp4o -c

all: core

core: array list option either arrow inttbl queue
	ocamlfind ocamlc -package js_of_ocaml -c either.cmo option.cmo list.cmo array.cmo arrow.cmo inttbl.cmo core.ml

arrow:
	ocamlfind ocamlc -package js_of_ocaml -c arrow.ml

option:
	ocamlfind ocamlc -package js_of_ocaml -c option.ml

either:
	ocamlfind ocamlc -package js_of_ocaml -c either.ml

array:
	ocamlfind ocamlc -package js_of_ocaml -c core_array.ml

list: either
	ocamlfind ocamlc -package js_of_ocaml -c either.cmo core_list.ml

queue: list
	$(OCAMLC) core_list.cmo core_queue.mli core_queue.ml

inttbl:
	ocamlfind ocamlc -package js_of_ocaml -c inttbl.mli inttbl.ml

clean:
	rm *.cmo
	rm *.cmi
