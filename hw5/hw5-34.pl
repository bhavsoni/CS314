:- use_module(library(clpfd)).

tree(nil).
tree(b(L,_,R)) :- tree(L), tree(R).

mirror(nil,nil).
mirror(b(L1,_,R1), b(L2,_,R2)) :- mirror(L1,_,R2), mirror(R1,_,L2).

