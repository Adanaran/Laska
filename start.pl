% start.pl
% Autor: Tim R�hrig
%
% Initial einzubindende Datei, die die anderen Dateien in der richtigen
% Reihenfolge einbindet. Zus�tzlich werden Startpr�dikate f�r ein
% Laska-Spiel alleine oder gegen die KI angeboten.

:- [config].
:- [utils].
:- [boardimproved].
:- [virtualboard].
:- [laskazug].
:- [zugermittlung].
:- [bewertung].
:- [minimax].
:- [alphabeta].

%% --------------------------------------------------------------------
% dialog.
% Startet den Standarddialog f�r ein Zwei-Personen-Spiel ohne KI.
%
dialog :-
	farbe(Farbe),
	schreibeBrett(Farbe),
	echtZ�ge(Farbe,Z�ge),
	\+sieg(Farbe,Z�ge,' kann nicht mehr ziehen.'),
	zugAuswahl(Farbe,Z�ge),
	fail.
%% --------------------------------------------------------------------
% dialogKI(+Farbe).
% Startet den Standarddialog f�r ein Ein-Personen-Spiel mit KI.
% Die KI bekommt hierbei die �bergebene Farbe zugeschrieben.
%
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
