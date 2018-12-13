:- use_module(library(clpfd)).

tree(nil).
tree(b(L,_,R)) :- tree(L), tree(R).

mirror(nil).
mirror(b(L,_,R)) :- mir(L,R).

mir(nil,nil).
mir(b(L1,_,R1), b(L2,_,R2)) :- mir(L1,R2), mir(R1,L2).

echo([], []).
echo([X|Xs], [X,X|Ys]) :- echo(Xs, Ys).

unecho([],[]).
unecho([X],[X]).
unecho([X,X|Xs],Zs) :- unecho([X|Xs],Zs).
unecho([X,Y|Ys],[X|Zs]) :- X \= Y, unecho([Y|Ys],Zs).

slist([]).
slist([_]).
slist([X,Y|Z]) :- X =< Y, slist([Y|Z]). 

ssselect(X,[X|T],T).
ssselect(I, [H|T], [H|R]) :- ssselect(I,T,R).  

