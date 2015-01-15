min_am_zug([weiss|_]).

max_am_zug([schwarz|_]).

minimax(P,P,V,2):-
	siegWertung(P,V).

% P = (aktuelle) Position mit Minimax-Wert V,
% B = Position nach bestem Zug
minimax(P,B,V,T) :-
% L = Liste der unmittelbaren Nachfolger von P
%     (aus legalen Zuegen)

	listeVBretter(P,L),!,

	nl,nl,nl,
	write('L ist'),nl,writeListOfList(L),
	nl,nl,nl,

% Besten Nachfolger ermitteln
	best(L,B,V,T),

	nth0(26,B,Z),
	nl,nl,nl,
	write('V:'),write(V),nl,
	write('B:'),write(B),nl,
	write('Zug:'),write(Z),nl,
	nl,nl,nl. %;

% P ist Blattknoten mit statischer Bewertung V
%	siegWertung(P,V).

best([P],P,V,T) :-
	T1 is T + 1,
	minimax(P,_,V,T1), !.

% Pm ist von P1 und P2 die bessere Position mit Vm
best([P1|L],Pm,Vm,T) :-
	T1 is T + 1,
	minimax(P1,_,V1,T1),
	best(L,P2,V2,T),
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
