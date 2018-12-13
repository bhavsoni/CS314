:- use_module(library(clpfd)).

tree(nil).
tree(b(L,_,R)) :- tree(L), tree(R).


mirror(nil,nil).
mirror(b(L1,X,R1), b(L2,X,R2)) :- mirror(L1,R2), mirror(R1,L2).

echo([], []).
echo([X|Xs], [X,X|Ys]) :- echo(Xs, Ys).

unecho([],[]).
unecho([X],[X]).
unecho([X,X|Xs],Zs) :- unecho([X|Xs],Zs),!.
unecho([X,Y|Ys],[X|Zs]) :- X \= Y, !, unecho([Y|Ys],Zs).

slist([]).
slist([_]).
slist([X,Y|Z]) :- X =< Y, slist([Y|Z]). 


sselect(X,[],[X]).
sselect(New,[X|Xs], Ys) :- 
	zcompare(Order, X, New),
	sselect(Order,X,New,Xs,Ys).
sselect(<, X, New, Xs, [New,X|Xs]).
sselect(=, X, _, Xs, [X|Xs]).
sselect(>, X, New, Xs, [X|Ys]) :-
    sselect(New, Xs, Ys).

