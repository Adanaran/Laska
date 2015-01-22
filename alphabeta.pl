% Alpha-Beta-Algorithmus (prinzipiell, nicht direkt lauffähig)
% Die beiden Werte A und B legen zwei Schranken fest, die
% den minimalen garantierten, und
% den höchsten, zu erhoffenden
% Gewinn in der jeweiligen Position angeben.
% Die Sichten der Spieler MIN und MAX sind stets gegensätzlich,
% deshalb vertauschen sich A und B bei Wechsel der Sicht.
% Auf Basis der Schranken kann die Suche vorzeitig abgebrochen werden,
% ohne das Gesamtergebnis zu verschlechtern.
%
% G ist eine "gute" Position mit Wert V, der Schranken A und B erfüllt
%
%
%
%

alphabeta(P,_,_,P,V,T):-
	config(max_tiefe_ki,T),
	siegWertung(P,V),!.

alphabeta(P,A,B,G,V,T) :-
	% Liste der Nachfolger-Positionen aus legalen Zügen
	listeVBretter(P,L),
	% finde G aus L
	beste(L,A,B,G,V,T);
	siegWertung(P,V).

alphabeta(P,_,_,P,V,_):-
	siegWertung(P,V).

beste([P],_,_,P,V,0) :-
	siegWertung(P,V), !.

beste([P|L],A,B,Pg,Vg,T) :-
	T1 is T + 1,
	alphabeta(P,A,B,_,V,T1),
	gutgenug(L,A,B,P,V,Pg,Vg,T).

% Knoten ist einziger Kandidat
gutgenug([],_,_,P,V,P,V,_) :- !.

% Bewertung erreicht einen der Grenzwerte
gutgenug(_,A,B,P,V,P,V,_) :-
	min_am_zug(P), V > B, !;
	max_am_zug(P), V < A, !.

gutgenug(L,A,B,P,V,Pg,Vg,T) :-
	% "verschiebe" A, B
	neueAB(A,B,P,V,An,Bn),
	beste(L,An,Bn,P1,V1,T),
	besser(P,V,P1,V1,Pg,Vg).

neueAB(A,B,P,V,V,B) :-
	min_am_zug(P), V > A, !.

neueAB(A,B,P,V,A,V) :-
	max_am_zug(P), V < B, !.

neueAB(A,B,_,_,A,B).
