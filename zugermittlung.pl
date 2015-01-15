%:-[laskazug].
%:-retractall(brett(_,_)).
%:-[laskazug].
%:-[virtualBoard].

testbrett :-
retractall(brett(_,_)),
assert(brett(a1,[])),
assert(brett(a3,[])),
assert(brett(a5,[])),
assert(brett(a7,[])),
assert(brett(b2,[s])),
assert(brett(b4,[])),
assert(brett(b6,[w])),
assert(brett(c1,[])),
assert(brett(c3,[])),
assert(brett(c5,[s])),
assert(brett(c7,[])),
assert(brett(d2,[])),  % diese drei Felder
assert(brett(d4,[])), % (12, 13 und 14)
assert(brett(d6,[])), % sind anfangs (normalerweise) unbesetzt
assert(brett(e1,[])),
assert(brett(e3,[])),
assert(brett(e5,[w])),
assert(brett(e7,[])),
assert(brett(f2,[w])),
assert(brett(f4,[])),
assert(brett(f6,[s])),
assert(brett(g1,[])),
assert(brett(g3,[])),
assert(brett(g5,[])),
assert(brett(g7,[])).
%%	Testbrett für den Fall dass Sondersituationen gebaut werden
%	müssen.
%	Und das ganz bequem einkommentierbar :D
%
%	Aktuell: Test von Offizierswerdung per Zug und Sprung beider
%	Seiten.
%
%:-testbrett.

%%---------------------------------------------------------------------
% Zieht automatisch und ohne Beachtung der Regeln einige Züge.
%
% Vorraussetzung für den Aufruf ist die Ausgangsstellung auf dem
% Spielbrett stehen zu haben.
%%
zieh :-
	ziehen(schwarz,e3d4),ziehen(weiss,c5e3),
	ziehen(schwarz,f2d4),ziehen(weiss,b6c5),
	ziehen(schwarz,d4b6),ziehen(weiss,a7c5),
	ziehen(schwarz,e1d2),ziehen(weiss,c3e1),
	ziehen(schwarz,e3d2),ziehen(weiss,c1e3),
	ziehen(schwarz,f4d2),ziehen(weiss,b2c1),
	ziehen(schwarz,d2c3),
	schreibeBrett(schwarz),!.

:- dynamic
	zugmöglichkeit/2.
:- dynamic
	sprungmöglichkeit/2.


listeVBretter(P,ListeVBretter):-
	züge(P,Zugliste),
	listeVBretter(P,ListeVBretter,Zugliste),!.

listeVBretter(P,ListeNeu,[Zug|Restzüge]) :-
	virtuellZiehen(P,Zug,PRes),
	listeVBretter(P,Liste,Restzüge),
	append(PRes,[Zug],PmitZug),
	append(Liste,[PmitZug],ListeNeu).

listeVBretter(_,[],[]).



%% --------------------------------------------------------------------
% züge(+P,-Zugliste).
%
% Ermittelt auf Grundlage eines virtuellen Brettes alle möglichen
% erlaubten Züge des entsprechenden Spielers. Die Liste der Züge wird in
% Zugliste zurückgeschrieben.
%
% Sprungermittlung
züge(P,_) :-
	retractall(sprungmöglichkeit(_,_)),
	write('Mögliche Züge: '),
	nl,
	ermittleSprung(P,FFeld, SFeld,Übersprungen),
	ermittleFolgesprung(P,FFeld,SFeld,[Übersprungen]),
	filterSprünge(SFeld),
	fail.

% Zugermittlung
züge(P,_) :-
	retractall(zugmöglichkeit(_,_)),
	\+sprungmöglichkeit(_,_),
	ermittleZug(P),
	fail.

% Auflistung der Ergebnisprädikate (und Ausgabe)
züge(_,Liste) :-
	listeSprünge([],Liste),
	\+Liste == [],
	write(Liste),!;
	listeZüge([],Liste),
	write(Liste),!.

%% --------------------------------------------------------------------
% echtZüge(+Farbe,-Zugliste).
%
% Ermittelt auf Grundlage des aktuellen Brettes alle möglichen
% erlaubten Züge des übergebenen Spielers. Die Liste der Züge wird in
% Zugliste zurückgeschrieben.
%
% Wird von laskazug.pl verwendet um Sieg durch Zugmangel zu ermitteln
% und das Zugmenü zu befüllen.
%
%%

% Sprungermittlung
echtZüge(Farbe,_):-
	retractall(sprungmöglichkeit(_,_)),
	ermittleEchtSprung(Farbe,FFeld, SFeld,Übersprungen),
	ermittleEchtFolgesprung(Farbe,FFeld,SFeld,[Übersprungen]),
	filterSprünge(SFeld),
	fail.

% Zugermittlung
echtZüge(Farbe,_):-
	retractall(zugmöglichkeit(_,_)),
	\+sprungmöglichkeit(_,_),
	ermittleEchtZug(Farbe),
	fail.

% Auflistung der Ergebnisprädikate
echtZüge(_,Liste):-
	listeSprünge([],Liste),
	\+Liste == [],!;
	listeZüge([],Liste),
	!.

%% -----------------------------------------------------------------------
% listeSprünge(+ListeVorhanden, -ListeErgebnis).
%
% Sammelt alle gefundenen Sprungmöglichkeiten in einer Liste und gibt
% diese zurück.
%
%%
listeSprünge(ListeVorhanden, ListeErgebnis) :-
	sprungmöglichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeSprünge(ListeNeu,ListeErgebnis).
listeSprünge(L,L).

%% -----------------------------------------------------------------------
% listeZüge(+ListeVorhanden, -ListeErgebnis).
%
% Sammelt alle gefundenen Zugmöglichkeiten in einer Liste und gibt
% diese zurück.
%
%%
listeZüge(ListeVorhanden, ListeErgebnis) :-
	zugmöglichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeZüge(ListeNeu,ListeErgebnis).
listeZüge(L,L).

%% -----------------------------------------------------------------------
% ermittleZug(+VirtuellesBrett).
%
% Ermittelt ausgehen von aktuell belegten SpielerFeldern alle möglichen
% Züge.
%
% Gefundene Züge werden als Prädikat
% zugmöglichkeit(spielerFeld,zielFeld) gespeichert.
%
%%
ermittleZug([Farbe|Brett]) :-
	virtuellSelbst(Farbe,Brett,FFeld,Head),
	(
	    (
	    \+Head == w,
	    nachbarn(LFeld,FFeld,_),
	    turmAufFeld(Brett,LFeld,[])
	)
	    ;
	    (
	    \+Head == s,
	    nachbarn(FFeld,LFeld,_),
	    turmAufFeld(Brett,LFeld,[])
	    )

	),
	assert(zugmöglichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleEchtZug(+Farbe).
%
% Ermittelt ausgehen vom aktuellen Brett und der übergebenen
% Spielerfarbe alle möglichen Züge.
%
% Gefundene Züge werden als Prädikat
% zugmöglichkeit(spielerFeld,zielFeld) gespeichert.
%
ermittleEchtZug(Farbe) :-
	selbst(Farbe,FFeld,Head),
	(
	    (
	    \+Head == w,
	    nachbarn(LFeld,FFeld,_),
	    brett(LFeld,[])
	)
	    ;
	    (
	    \+Head == s,
	    nachbarn(FFeld,LFeld,_),
	    brett(LFeld,[])
	    )

	),
	assert(zugmöglichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleSprung(+VirtuellesBrett, -SpielerFeld, -LeerFeld, -GegnerFeld).
%
% Ermittelt ausgehen von aktuell belegten SpielerFeldern alle möglichen
% Sprünge über GegnerFelder auf LeerFelder.
%
% Gefundene Sprungmöglichkeiten werden als Prädikat
% sprungmöglichkeit(spielerFeld,zielFeld) gespeichert.
%
%%
ermittleSprung([Farbe|Brett], FFeld, LFeld, OFeld) :-
	virtuellSelbst(Farbe,Brett,FFeld,Head),
	sprungnachbarn(Head,LFeld,OFeld,FFeld),
	opponent(Opp,Head),
	turmAufFeld(Brett, OFeld,[Opp|_]),
	turmAufFeld(Brett, LFeld,[]),
	assert(sprungmöglichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleEchtSprung(+Farbe, -SpielerFeld, -LeerFeld, -GegnerFeld).
%
% Ermittelt ausgehen vom aktuellen Brett und der übergebenen
% Spielerfarbe alle möglichen Sprünge über
% GegnerFelder auf LeerFelder.
%
% Gefundene Sprungmöglichkeiten werden als Prädikat
% sprungmöglichkeit(spielerFeld,zielFeld) gespeichert.
%
%%
ermittleEchtSprung(Farbe, FFeld, LFeld, OFeld) :-
	selbst(Farbe,FFeld,Head),               %Ermittle die aktuell belegten Felder der Farbe und deren oberste Steine
	sprungnachbarn(Head,LFeld,OFeld,FFeld), %Ermittle mögliche Sprünge über Gegner auf Leerfelder
	brett(LFeld,[]),                        %Prüfe ob das Sprungziel leer ist
	opponent(Opp,Head),                     %Ermittle die Art der obersten Steine des Gegners
	brett(OFeld,[Opp|_]),			%Prüfe ob der zu überspringende Stein ein gegnerischer ist
	assert(sprungmöglichkeit(FFeld,LFeld)). %Merke die Sprungmöglichkeit

%% -----------------------------------------------------------------------
% ermittleFolgesprung(+VirtuellesBrett, +StartFeld, +ZielFelder,
% +FeldListe).
%
% Ermittelt alle möglichen Folgesprünge über GegnerFelder auf
% LeerFelder auf Basis des übergebenen virtuellen Brettes.
%
% Neue Gefundene Sprungmöglichkeiten werden als Prädikat
% sprungmöglichkeit(spielerFeld,zielFelder) gespeichert, wobei
% zielFelder auch alle Zwischenfelder enthält.
%
%%
ermittleFolgesprung([Farbe|Brett],StartFeld,ZielFelder,FeldListe) :-
	virtuellSelbst(Farbe,Brett,StartFeld,Head),
	sub_atom(ZielFelder,_,2,0,ZielFeld),
	sprungnachbarn(Head,LFeld,OFeld,ZielFeld),
	(
	    turmAufFeld(Brett,LFeld,[]);
	    LFeld == StartFeld
	),
	opponent(Opp,Head),
	turmAufFeld(Brett, OFeld,[Opp|_]),
	\+member(OFeld, FeldListe),
	atom_concat(ZielFelder,LFeld,ZFeld),
	append(FeldListe,[OFeld],ListeNeu),
	assert(sprungmöglichkeit(StartFeld,ZFeld)),
	ermittleFolgesprung(Farbe, StartFeld, ZFeld, ListeNeu).
ermittleFolgesprung(_,_,_,_).

%% -----------------------------------------------------------------------
% ermittleEchtFolgeSprung(+Farbe, +StartFeld, +ZielFelder, +FeldListe).
%
% Ermittelt alle möglichen Folgesprünge über GegnerFelder auf
% LeerFelder auf Basis des aktuellen Brettes.
%
% Neue Gefundene Sprungmöglichkeiten werden als Prädikat
% sprungmöglichkeit(spielerFeld,zielFelder) gespeichert, wobei
% zielFelder auch alle Zwischenfelder enthält.
%
%%
ermittleEchtFolgesprung(Farbe,StartFeld,ZielFelder,FeldListe) :-
	selbst(Farbe,StartFeld,Head),
	sub_atom(ZielFelder,_,2,0,ZielFeld),
	sprungnachbarn(Head,LFeld,OFeld,ZielFeld),
	(
	    brett(LFeld,[]);
	    LFeld == StartFeld
	),
	opponent(Opp,Head),
	brett(OFeld,[Opp|_]),
	\+member(OFeld, FeldListe),
	atom_concat(ZielFelder,LFeld,ZFeld),
	append(FeldListe,[OFeld],ListeNeu),
	assert(sprungmöglichkeit(StartFeld,ZFeld)),
	ermittleEchtFolgesprung(Farbe, StartFeld, ZFeld, ListeNeu).
ermittleEchtFolgesprung(_,_,_,_).

%% ------------------------------------------------------------------------
% sprungnachbarn(+Head, +ZielFeld, +MittelFeld, +UrsprungsFeld) :-
%
% Definiert einen möglichen Sprung vom UrsprungsFeld über das MittelFeld
% zum Zielfeld in Abhängigkeit der (Kopfstein-)Farbe, um Rückwärtssprünge einzuschränken.
%
%%
sprungnachbarn(Head, ZielFeld, MittelFeld, UrsprungsFeld) :-
	((
	    \+Head == w,
	    nachbarn(ZielFeld,MittelFeld,UrsprungsFeld)
	  )
	 ;
	  (
	    \+Head == s,
	    nachbarn(UrsprungsFeld,MittelFeld,ZielFeld)
	)).

%% -----------------------------------------------------------------------
% filterSprünge(+SFeld,).
%
% Filtert die gefundenen Sprungmöglichkeiten, damit bei Mehrfachsprüngen
% immer bis zum Ende gesprungen wird, indem Sprünge, die auf
% Zwischenzielen enden entfernt werden.
%
%%
filterSprünge(SFeld) :-
	sprungmöglichkeit(UrsprungsFeld, Ziel),
	\+ Ziel == SFeld,
	filterSprünge(UrsprungsFeld, Ziel, SFeld).
filterSprünge(U, Z1, Z2):-
	 sub_atom(Z1,_,_,_,Z2),
	 retractall(sprungmöglichkeit(U, Z2)),
	 filterSprünge(Z1),
	 fail.
