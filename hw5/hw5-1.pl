:- use_module(library(clpfd)).

tree(nil).
tree(b(L,_,R)) :- trene(L), trene(R).

mirror(nil,nil).
mirror(b(L1,_,R1),b(L2,_,R2)) :- mirror(L1,R2), mirror(R1,L2).
