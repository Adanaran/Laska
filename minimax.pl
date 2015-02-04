% minimax.pl
% Autor: Malte Ahlering
%
% Enthält Prädikate zu Suchverfahren nach MiniMax - Prinzip auf Grundlage
% von Prof. Dr.-Ing Uwe Meyer.

% Ermittelt, ob der Min-SPieler am Zug ist.
min_am_zug([Farbe|_]):-
	\+ki(Farbe).

% Ermittelt, ob der Max-Spieler am Zug ist.
max_am_zug([Farbe|_]):-
	ki(Farbe).

% Minimax-Algorithmus, Abbruchbedingung wenn die maximale Suchtiefe erreicht ist.
minimax(P,P,V,T):-
	config(max_tiefe_ki,T),
	siegWertung(P,V),!.

% Minimax-Algorithmus.
% P = (aktuelle) Position mit Minimax-Wert V
% B = Position nach bestem Zug
% T = aktuelle Tiefe
minimax(P,B,V,T) :-
% L = Liste der unmittelbaren Nachfolger von P
%     (aus legalen Zuegen)
	listeVBretter(P,L),

% Besten Nachfolger ermitteln
	best(L,B,V,T).

% Minimax-Algorithmus, Abbruchbedingung keine weiteren Zugmöglichkeiten.
minimax(P,P,V,_):-
	siegWertung(P,V).

% Bestimmt die beste Position, hier: nur eine Position vorhanden.
% P = einzig mögliche Position mit Minimax-Wert V
% T = aktuelle Tiefe
best([P],P,V,T) :-
	T1 is T + 1,
	minimax(P,_,V,T1), !.

% Betsimmt die beste Position aus den möglichen Nachfolgern.
% Pm ist von P1 und P2 die bessere Position mit Vm
best([P1|L],Pm,Vm,T) :-
	T1 is T + 1,
	minimax(P1,_,V1,T1),
	best(L,P2,V2,T),
	besser(P1,V1,P2,V2,Pm,Vm).

% Ermittelt, dass P0 besser ist als P1 (_).
% V0 und V1 sind Minimax-Werte von P0 bzw. P1.
besser(P0,V0,_,V1,P0,V0) :-
% in der Folgeposition ist MIN am Zug,
	min_am_zug(P0),
% aus Sicht des Vorgaengers jedoch MAX ...
	V0 > V1, !;
% ... und umgekehrt
	max_am_zug(P0),
	V0 < V1, !.

% Ermittelt, dass P1 besser ist als P0 (_).
besser(_,_,P1,V1,P1,V1).
