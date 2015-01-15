% ------------------------------------------------------------------------
%  gegner(+Selbst,-Gegner).
%   Gibt den Gegenspieler von Selbst in Gegner zurück.

gegner(weiss,schwarz).
gegner(schwarz,weiss).

% ------------------------------------------------------------------------
% ermittleSprungLänge(+Zug,-Länge).
%  Gibt die Länge von Zug in Anzahl der Bewegungen des Steines zurück.

ermittleSprungLänge(Zug,Länge):-
	atom_length(Zug,Atom_länge),
	Länge is ((Atom_länge - 4) / 2) + 1.

% ------------------------------------------------------------------------
%  turmZwischen(+P,+Start,+Ziel,-Turm)
%   Gibt in Turm den Turm zwischen Start und Ziel zurück.
turmZwischen([_|Brett],Start,Ziel,Turm):-
	feldZwischen(Start,Ziel,Zwischen),
	turmAufFeld(Brett,Zwischen,Turm).

% ------------------------------------------------------------------------
%  feldZwischen(+Start,+Ziel,-FeldZwischen).
%   Gibt das Feld zwischen Start und Ziel zurück.

feldZwischen(Start,Ziel,FeldZwischen):-
	sub_atom(Start,0,1,_,BStart),
	sub_atom(Start,1,1,_,AStart),
	sub_atom(Ziel,0,1,_,BZiel),
	sub_atom(Ziel,1,1,_,AZiel),
	buchstabeZwischen(BStart,BZiel,BZwischen),
	atom_number(AStart, ZStart),
	atom_number(AZiel, ZZiel),
	ZZwischen is (ZStart + ZZiel)/2,
	atomic_concat(BZwischen,ZZwischen,FeldZwischen).

% ------------------------------------------------------------------------
%  buchstabeZwischen(+ersterBuchstabe,+zweiterBuchstabe,-BuchstabeZwische
%  n)
%   Gibt den Buchstaben zwischen ersterBuchstabe und zweiterBuchstabe
%   zurück.
buchstabeZwischen('a','c','b').
buchstabeZwischen('b','d','c').
buchstabeZwischen('c','e','d').
buchstabeZwischen('d','f','e').
buchstabeZwischen('e','g','f').

buchstabeZwischen('c','a','b').
buchstabeZwischen('d','b','c').
buchstabeZwischen('e','c','d').
buchstabeZwischen('f','d','e').
buchstabeZwischen('g','e','f').

% ------------------------------------------------------------------------
%  istZug(+Zug)
%   Kann unifziziert werden, wenn Zug ein einfacher Zug ohne Schlag ist.
istZug(Zug):-
	sub_atom(Zug,1,1,_,A1),
	sub_atom(Zug,3,1,_,A2),
	atom_number(A1, Z1),
	atom_number(A2, Z2),
	Diff is Z1 - Z2,
	1 is abs(Diff).


