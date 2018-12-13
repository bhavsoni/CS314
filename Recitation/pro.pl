:- use_module(library(clpfd)).

edge(a,b).
edge(a,c).
edge(b,d).
edge(c,d).
edge(d,e).
edge(f,g).

friend(alice, bob).
friend(bob, carol).
friend(carol, daniel).
friend(carol, eve).
friends(A,B) :- friend(A,B); friend(B,A).

is_a(parallelogram, quadrilateral).
is_a(trapezoid, quadrilateral).
is_a(rhombus, parallelogram).
is_a(rectangle, parallelogram).
is_a(square, rhombus).
is_a(square, rectangle).

connected(V,V).
connected(V1, V2) :-
	edge(V1,U),
	connected(U,V2).

connected2(Rel, V,V).
connected2(Rel, V1, V2) :-
	call(Rel, V1, U),
	connected2(U,V2).

parent(a,b).
parent(a,c).
parent(b,d).
parent(c,d).
parent(d,e).
parent(f,g).

ancestor(A,B):-
	parent(A,B).
ancestor(A,B) :-
	parent(A,C),
	ancestor(C,B).


transit(Rel,A,B) :-
	call(Rel,A,B).
transit(Rel,A,B) :-
	call(Rel,A,C),
	transit(Rel,C,B).

transit2(Rel,A,B) :-
	call(Rel, A,C),
	(C=B; transit2(Rel, C, B)).





path(Rel, S, T, P, N):-
	call(Rel, S, T),
	length(P,N).
path(Rel, S, T, P, N) :-
	call(Rel,S,X),
	length(P,N),
	path(Rel, X, S, P, N).



follows_tx(A, B) :- follows(A, B, []).
follows(A, B, Seen) :-
    not_member(B, Seen),
    follows(A, B).
follows(A, B, Seen) :-
    follows(A, X),
    not_member(X, Seen),
    follows(X, B, [A|Seen]).

not_member(_, []).
not_member(X, [H|T]) :- dif(X, H), not_member(X, T).
