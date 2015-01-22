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
