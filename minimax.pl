:- dynamic
	count/1.

count(0).

min_am_zug(weiss).

max_am_zug(schwarz).

% P = (aktuelle) Position mit Minimax-Wert V,
% B = Position nach bestem Zug
minimax(P,B,V) :-
% L = Liste der unmittelbaren Nachfolger von P
%     (aus legalen Zuegen)

	count(C),
	config(max_tiefe_ki,M),
	C < M,
	retractall(count(_)),
	C1 is C + 1,
	assert(count(C1)),

	listeVBretter(P,L),
	nl,nl,nl,
	write('L ist'),nl,writeListOfList(L),
	nl,nl,nl,
	!,

% Besten Nachfolger ermitteln
	best(L,B,V),

	nth0(26,B,Z),
	nl,nl,nl,
	write('V:'),write(V),nl,
	write('B:'),write(B),nl,
	write('Zug:'),write(Z),nl,
	nl,nl,nl;

% P ist Blattknoten mit statischer Bewertung V
	siegWertung(P,V),

	nth0(26,B,Z),
	nl,nl,nl,
	write('V:'),write(V),nl,
	write('B:'),write(B),nl,
	write('Zug:'),write(Z),nl,
	nl,nl,nl.

best([P],P,V) :-
	minimax(P,_,V), !.

% Pm ist von P1 und P2 die bessere Position mit Vm
best([P1|L],Pm,Vm) :-
	minimax(P1,_,V1),
	best(L,P2,V2),
	besser(P1,V1,P2,V2,Pm,Vm).

% P0 ist besser als P1
besser(P0,V0,_,V1,P0,V0) :-
% in der Folgeposition ist MIN am Zug,
	min_am_zug(P0),
% aus Sicht des Vorgaengers jedoch MAX ...
	V0 > V1, !;
% ... und umgekehrt
	max_am_zug(P0),
	V0 < V1, !.

% P1 ist besser als P0
besser(_,_,P1,V1,P1,V1).
