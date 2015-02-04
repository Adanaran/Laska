% alphabeta.pl
% Autor: Malte Ahlering
%
% Enth�lt das Suchverfahren nach Alphabeta f�r die KI - Prinzip auf Grundlage
% von Prof. Dr.-Ing Uwe Meyer.
%
% Die beiden Werte A und B legen zwei Schranken fest, die
% den minimalen garantierten, und
% den h�chsten, zu erhoffenden
% Gewinn in der jeweiligen Position angeben.
% Die Sichten der Spieler MIN und MAX sind stets gegens�tzlich,
% deshalb vertauschen sich A und B bei Wechsel der Sicht.
% Auf Basis der Schranken kann die Suche vorzeitig abgebrochen werden,
% ohne das Gesamtergebnis zu verschlechtern.
%
% G ist eine "gute" Position mit Wert V, der Schranken A und B erf�llt

% AlphaBeta-Algorithmus, Abbruchbedingung, wenn maximale SUchtiefe erreicht ist.
alphabeta(P,_,_,P,V,T):-
	config(max_tiefe_ki,T),
	siegWertung(P,V),!.

% AlphaBeta-Algorithmus.
% P = aktuelle Position,
% A,B = Schranken f�r AlphaBeta
% G = gute Position mit Bewertung V
% T = aktuelle Suchtiefe
alphabeta(P,A,B,G,V,T) :-
	% Liste der Nachfolger-Positionen aus legalen Z�gen
	listeVBretter(P,L),
	% finde G aus L
	beste(L,A,B,G,V,T);
	siegWertung(P,V).

% AlphaBeta-ALgorithmus, Abbruchbedingung keine weietren Zugm�glichkeiten.
alphabeta(P,_,_,P,V,_):-
	siegWertung(P,V).

% Ermittelt die beste Position aus den M�glichkeiten.
% Pg ist die beste Zugm�chkeit aus P und L mit Wertung Vg
% T = aktuelle Suchtiefe
beste([P|L],A,B,Pg,Vg,T) :-
	T1 is T + 1,
	alphabeta(P,A,B,_,V,T1),
	gutgenug(L,A,B,P,V,Pg,Vg,T).

% Ermittle ob Knoten gut genug f�r AlphaBeta-Schranke ist, Knoten ist einziger Kandidat.
gutgenug([],_,_,P,V,P,V,_) :- !.

% Ermittle ob Knoten gut genug f�r AlphaBeta-Schranke ist, Bewertung erreicht einen der Grenzwerte.
gutgenug(_,A,B,P,V,P,V,_) :-
	min_am_zug(P), V > B, !;
	max_am_zug(P), V < A, !.

% Ermittle ob Knoten gut genug f�r AlphaBeta-Schranke ist.
% L = Nachfolgepositionen
% A,B = Schranken f�r AlphaBeta
% P = aktuelle Zugm�glichkeit mit Wertung V
% Pg = bessere Zugm�glichkeit mit Wertung Pv
% T = aktuelle Suchtiefe
gutgenug(L,A,B,P,V,Pg,Vg,T) :-
	% "verschiebe" A, B
	neueAB(A,B,P,V,An,Bn),
	beste(L,An,Bn,P1,V1,T),
	besser(P,V,P1,V1,Pg,Vg).

% Aktualisierung der Schrankenwerte f�r Min-Spieler.
% A,B = Schranken f�r AlphaBeta
% P = aktuelle Zugm�glichkeit mit Wertung V
neueAB(A,B,P,V,V,B) :-
	min_am_zug(P), V > A, !.

% Aktualisierung der Schrankenwerte f�r Max-Spieler.
neueAB(A,B,P,V,A,V) :-
	max_am_zug(P), V < B, !.

% Aktualisierung der Schrankenwerte, Abbruchbedingung: Werte bleiben gleich.
neueAB(A,B,_,_,A,B).
