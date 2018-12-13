likes(anne, john).
likes(john, mary).
likes(john,jasmine).
likes(jasmine, george).

jealous(Jealous, Person) :-
	likes(Jealous, P),
	likes(P, Person).

parent(kim, mary).
parent(marge, kim).
parent(marge, john).
parent(ester, marge).
parent(albert, marge).
parent(albert, jack). 

grandparent(GP, GC) :-
	parent(GP, P),
	parent(P, GC).

greatgrandparent(GGP, GGC) :-
	parent(GGP, GP),
	parent(GP, P),
	parent(P, GGC).

ancestor(X,Y) :-
	parent(X,Y).
ancestor(X,Y) :-
	parent(X,Z),
	ancestor(Z,Y).