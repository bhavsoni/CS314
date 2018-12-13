:- use_module(library(clpfd)).

edge(a,b).
edge(a,c).
edge(b,d).
edge(c,d).
edge(d,e).
edge(f,g).


connected(V,V).
connected(V1, V2) :-
	edge(V1,U),
	connected(U,V2).


