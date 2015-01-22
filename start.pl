:- [config].
:- [utils].
:- [boardimproved].
:- [virtualboard].
:- [laskazug].
:- [zugermittlung].
:- [bewertung].
:- [lki].
:- [minimax].

dialog :-
	farbe(Farbe),
	schreibeBrett(Farbe),
	echtZ�ge(Farbe,Z�ge),
	\+sieg(Farbe,Z�ge,' kann nicht mehr ziehen.'),
	zugAuswahl(Farbe,Z�ge),
	fail.

dialogKI(Farbe) :-
	retractall(ki(_)),
	assert(ki(Farbe)),
	farbe(Spieler),
	virtualisiereBrett(P),
	schreibeBrett(Spieler),
	echtZ�ge(Spieler,Z�ge),
	\+sieg(Spieler,Z�ge,' kann nicht mehr ziehen.'),
	zugDurchf�hren(Farbe,Spieler,P,Z�ge),
	fail.
