all: core

core: array list option either arrow
	ocamlfind ocamlc -package js_of_ocaml -c either.cmo option.cmo list.cmo array.cmo arrow.cmo core.ml

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

clean:
	rm *.cmo
	rm *.cmi
