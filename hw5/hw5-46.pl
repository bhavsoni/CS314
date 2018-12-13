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


sselect(V, [H|T], [H|V1]) :- H<V, sselect(Elem, T, V1).
sselect(V, [V|T], [V|T]).
sselect(V, [H|T], [V,H|T]) :- H > V.
sselect(V, [], [V]).


insert([], X, [X]).
insert([X|Xs], New, Ys) :-
    zcompare(Order, X, New),
    insert(Order, X, New, Xs, Ys).

insert(>, X, New, Xs, [New,X|Xs]).
insert(=, X, _, Xs, [X|Xs]).
insert(<, X, New, Xs, [X|Ys]) :-
    insert(Xs, New, Ys).

insert2(V,[H|T],V1).
insert2(V,[H|T], [H|V1]) :- H<V, insert2(V,T,V1).
insert2(V, [V|T], [V|T]) :- !.
insert2(V, [H|T], [V,H|T]).
insert2(V,[],[V]). 


quicksort([],[]).
quicksort([H|T],Sorted):- pivoting(H,T,L1,L2),quicksort(L1,Sorted1),quicksort(L2,Sorted2),append(Sorted1,[H|Sorted2]).
   
pivoting(H,[],[],[]).
pivoting(H,[X|T],[X|L],G):-X=<H,pivoting(H,T,L,G).
pivoting(H,[X|T],L,[X|G]):-X>H,pivoting(H,T,L,G).