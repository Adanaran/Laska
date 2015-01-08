statBw(h,3).
statBw(i,-2).
statBw(j,4).
statBw(k,9).
statBw(l,-2).
statBw(m,-1).
statBw(n,4).
statBw(o,-5).

nn(a,[b,c]).
nn(b,[d,e]).
nn(c,[f,g]).
nn(d,[h,i]).
nn(e,[j,k]).
nn(f,[l,m]).
nn(g,[n,o]).

min_am_zug(b).
min_am_zug(b).
min_am_zug(h).
min_am_zug(i).
min_am_zug(j).
min_am_zug(k).
min_am_zug(l).
min_am_zug(m).
min_am_zug(n).
min_am_zug(o).

max_am_zug(a).
max_am_zug(d).
max_am_zug(e).
max_am_zug(f).
max_am_zug(g).

% P = (aktuelle) Position mit Minimax-Wert V,
% B = Position nach bestem Zug
minimax(P,B,V) :-
% L = Liste der unmittelbaren Nachfolger von P
%     (aus legalen Zuegen)
	nn(P,L), !,
% Besten Nachfolger ermitteln
	best(L,B,V);
% P ist Blattknoten mit statischer Bewertung V
	statBw(P,V).

best([P],P,V) :-
	minimax(P,_,V), !.

% Pm ist von P1 und P2 die bessere Position mit Vm
% Wg. der besseren Lesbarkeit der beiden Klauseln, werden die
% "Singleton" Warnungen ([P1], [P0, V0]) nicht eliminiert
best([P1|L],Pm,Vm) :-
	minimax(P1,_,V1),
	best(L,P2,V2),
	besser(P1,V1,P2,V2,Pm,Vm).

% P0 ist besser als P1
besser(P0,V0,P1,V1,P0,V0) :-
% in der Folgeposition ist MIN am Zug,
	min_am_zug(P0),
% aus Sicht des Vorgaengers jedoch MAX ...
	V0 > V1, !;
% ... und umgekehrt
	max_am_zug(P0),
	V0 < V1, !.

% P1 ist besser als P0
besser(P0,V0,P1,V1,P1,V1).
