:- use_module(library(pio)).

lines([]) --> (call(eos), !).
lines([Line|Lines]) --> (line(Line), lines(Lines)).

eos([], []).

line([]) --> (( "\n" ; call(eos) ), !).
line([L|Ls]) --> ([L], line(Ls)).

:- op(255, xfx, -->).
dcg_handler(P1-->Q1, (P :- Q)) :- left_side(P1, S1, S, P), right_side(Q1, S1, S, Q2), flatten(Q2, Q).
left_side((Nt, T), S1, S, P) :- !, not(var(Nt)), is_list(T), expand(Nt, S1, S2, P), append(T, S1, S2).
left_side(Nt, S1, S, P) :- not(var(Nt)), expand(Nt, S1, S2, P).
right_side((X2, X3), S1, S, P) :- !, right_side(X2, S1, S2, P2), right_side(X3, S2, S, P3), and(P2, P3, P).
right_side(!, S, S, !) :- !.
right_side(T, S1, S, true) :- is_list(T), !, append(T, S, S1).
right_side(X, S1, S, P) :- expand(X, S1, S, P).
expand(X, S1, S, P) :- X=..[F|A], append(A,[S1,S], Ax), P=..[F|Ax].
and(true, P, P) :- !.
and(P, true, P) :- !.
and(P, Q, (P,Q)).
is_list([]) :- !.
is_list([_|_]).
flatten(A,A) :- var(A), !.
flatten((A, B), C) :- !, flatten1(A, C, R), flatten(B, R).
flatten(A, A).
flatten1(A, (A, R), R) :- var(A), !.
flatten1((A, B), C, R) :- !, flatten1(A, C, R1), flatten1(B, R1, R).
flatten1(A, (A, R), R).
