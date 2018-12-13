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

sxselect(A, [A|B], B).
sxselect(A, [B,C|D], [B|E]) :-sxselect(A, [C|D], E).


sxxselect(X, [X|Tail], Tail).
sxxselect(Elem, [Head|Tail], [Head|Rest]) :-
    sxxselect(Elem, Tail, Rest).



insert([], X, [X]).
insert([X|Xs], New, Ys) :-
    zcompare(Order, X, New),
    insert(Order, X, New, Xs, Ys).

insert(>, X, New, Xs, [New,X|Xs]).
insert(=, X, _, Xs, [X|Xs]).
insert(<, X, New, Xs, [X|Ys]) :-
    insert(Xs, New, Ys).

sselect(X,[],[X]).
sselect(New,[X|Xs], Ys) :- 
	compare(Order, X, New),
	sselect(Order,X,New,Xs,Ys).
sselect(>, X, New, Xs, [New,X|Xs]).
sselect(=, X, _, Xs, [X|Xs]).
sselect(<, X, New, Xs, [X|Ys]) :-
    sselect(New, Xs, Ys).



xxsselect(ELEMENT, [], [ELEMENT]).

xxsselect(ELEMENT, [HEAD|TAIL], [ELEMENT|LIST]) :-
   ELEMENT =< HEAD, sselect(HEAD, TAIL, LIST).

xxsselect(ELEMENT, [HEAD|TAIL], [HEAD|LIST]) :-
   ELEMENT > HEAD, sselect(ELEMENT, TAIL, LIST).


quicksort([],[]).
quicksort([H|T],Sorted):- pivoting(H,T,L1,L2),quicksort(L1,Sorted1),quicksort(L2,Sorted2),append(Sorted1,[H|Sorted2]).
   
pivoting(H,[],[],[]).
pivoting(H,[X|T],[X|L],G):-X=<H,pivoting(H,T,L,G).
pivoting(H,[X|T],L,[X|G]):-X>H,pivoting(H,T,L,G).