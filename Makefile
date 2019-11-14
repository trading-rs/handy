.PHONY:
	init
	build
	install
	example
	clean

init:
	opam switch create . 4.08.1
	opam install merlin ocp-indent dune utop
	opam pin add merlin-lsp.dev https://github.com/ocaml/merlin.git

build:
	dune build @install

install:
	opam install --deps-only .

example:
	dune exec examples/mock_client.exe

lsp:
	opam exec -- ocamlmerlin-lsp

clean:
	dune clean
	rm -rf handy.opam
