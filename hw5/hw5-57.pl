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


xsselect(X,[],[X]).
xsselect(New,[X|Xs], Ys) :- 
	zcompare(Order, X, New),
	xsselect(Order,X,New,Xs,Ys).
xsselect(>, X, New, Xs, [New,X|Xs]).
xsselect(=, X, _, Xs, [X|Xs]).
xsselect(<, X, New, Xs, [X|Ys]) :-
    xsselect(New, Xs, Ys).

sselect(X, [], [X]).
sselect(X, [Y|Rest], [X,Y|Rest]) :-
    X @< Y, !.
sselect(X, [Y|Rest0], [Y|Rest]) :-
    sselect(X, Rest0, Rest).
