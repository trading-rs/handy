.PHONY:
	init
	build
	install
	example
	clean

init:
	opam switch create . 4.08.1
	opam install merlin ocp-indent dune utop

build:
	dune build @install

install:
	opam install --deps-only .

example:
	dune exec examples/mock_client.exe

clean:
	dune clean
	rm -rf handy.opam
