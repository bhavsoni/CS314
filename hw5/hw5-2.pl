:- use_module(library(clpfd)).

tree(nil).
tree(b(L,_,R)) :- trene(L), trene(R).

mirror(b(L1,_,R1), b(R2,_,L2)).
mirror(b(L1,_,R1), R) :- R = (mirror(L1,R2), mirror(R1,L2)).

