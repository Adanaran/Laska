% start.pl
% Autor: Tim Röhrig
%
% Initial einzubindende Datei, die die anderen Dateien in der richtigen
% Reihenfolge einbindet. Zusätzlich werden Startprädikate für ein
% Laska-Spiel alleine oder gegen die KI angeboten.

:- [config].
:- [utils].
:- [boardimproved].
:- [virtualboard].
:- [laskazug].
:- [zugermittlung].
:- [bewertung].
:- [lki].
:- [minimax].
:- [alphabeta].

dialog :-
	farbe(Farbe),
	schreibeBrett(Farbe),
	echtZüge(Farbe,Züge),
	\+sieg(Farbe,Züge,' kann nicht mehr ziehen.'),
	zugAuswahl(Farbe,Züge),
	fail.

dialogKI(Farbe) :-
	retractall(ki(_)),
	assert(ki(Farbe)),
	farbe(Spieler),
	virtualisiereBrett(P),
	schreibeBrett(Spieler),
	echtZüge(Spieler,Züge),
	\+sieg(Spieler,Züge,' kann nicht mehr ziehen.'),
	zugDurchführen(Farbe,Spieler,P,Züge),
	fail.
