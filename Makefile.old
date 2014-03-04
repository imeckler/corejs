OCAMLC=ocamlfind ocamlc -package js_of_ocaml -package js_of_ocaml.syntax -syntax camlp4o -g

OBJS=time.cmo either.cmo option.cmo core_list.cmo core_array.cmo arrow.cmo inttbl.cmo core_string.cmo core_queue.cmo core.cmo

all: $(OBJS)

time.cmi:
	$(OCAMLC) -c time.mli

time.cmo: time.cmi
	$(OCAMLC) -c time.ml

either.cmo:
	$(OCAMLC) -c either.ml

option.cmo:
	$(OCAMLC) -c option.ml

core_list.cmo: option.cmo either.cmo
	$(OCAMLC) option.cmo either.cmo -c core_list.ml

core_array.cmo:
	$(OCAMLC) -c core_array.ml

arrow.cmo:
	$(OCAMLC) -c arrow.ml

inttbl.cmi:
	$(OCAMLC) -c inttbl.mli

inttbl.cmo: inttbl.cmi
	$(OCAMLC) -c inttbl.ml

core_string.cmo:
	$(OCAMLC) -c core_string.ml

core_queue.cmi:
	$(OCAMLC) core_list.cmo -c core_queue.mli

core_queue.cmo: core_list.cmo core_queue.cmi
	$(OCAMLC) core_list.cmo -c core_queue.ml

core.cmo: time.cmo either.cmo option.cmo core_list.cmo core_array.cmo arrow.cmo core_string.cmo inttbl.cmo core_string.cmo core_queue.cmo
	$(OCAMLC) time.cmo either.cmo option.cmo core_list.cmo core_array.cmo arrow.cmo core_string.cmo inttbl.cmo core_string.cmo core_queue.cmo -c core.ml

#%.cmi: %.mli
###	$(OCAMLC) -c $<

###%.cmo: %.ml
###	$(OCAMLC) -c $<

clean:
	rm *.cmo
	rm *.cmi
