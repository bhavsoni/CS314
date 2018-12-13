%path/5 works for all modes A-F

:- use_module(library(lists)).


path(Rel, S, T, P, N) :-
	path0(Rel, S, T, [S], X),
	reverse(X, P),
	length(P, N).

path0(Rel, S, T, P,[T|P]) :- 
	call(Rel, S, T).
path0(Rel, S, T, Exclude, P) :-
	call(Rel, S, Y),          
	not(member(Y,Exclude)),
	path0(Rel, Y, T, [Y|Exclude], P).