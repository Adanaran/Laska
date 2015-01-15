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
%%	Testbrett f�r den Fall dass Sondersituationen gebaut werden
%	m�ssen.
%	Und das ganz bequem einkommentierbar :D
%
%	Aktuell: Test von Offizierswerdung per Zug und Sprung beider
%	Seiten.
%
%:-testbrett.

%%---------------------------------------------------------------------
% Zieht automatisch und ohne Beachtung der Regeln einige Z�ge.
%
% Vorraussetzung f�r den Aufruf ist die Ausgangsstellung auf dem
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
	zugm�glichkeit/2.
:- dynamic
	sprungm�glichkeit/2.


listeVBretter(P,ListeVBretter):-
	z�ge(P,Zugliste),
	listeVBretter(P,ListeVBretter,Zugliste),!.

listeVBretter(P,ListeNeu,[Zug|Restz�ge]) :-
	virtuellZiehen(P,Zug,PRes),
	listeVBretter(P,Liste,Restz�ge),
	append(PRes,[Zug],PmitZug),
	append(Liste,[PmitZug],ListeNeu).

listeVBretter(_,[],[]).



%% --------------------------------------------------------------------
% z�ge(+P,-Zugliste).
%
% Ermittelt auf Grundlage eines virtuellen Brettes alle m�glichen
% erlaubten Z�ge des entsprechenden Spielers. Die Liste der Z�ge wird in
% Zugliste zur�ckgeschrieben.
%
% Sprungermittlung
z�ge(P,_) :-
	retractall(sprungm�glichkeit(_,_)),
	write('M�gliche Z�ge: '),
	nl,
	ermittleSprung(P,FFeld, SFeld,�bersprungen),
	ermittleFolgesprung(P,FFeld,SFeld,[�bersprungen]),
	filterSpr�nge(SFeld),
	fail.

% Zugermittlung
z�ge(P,_) :-
	retractall(zugm�glichkeit(_,_)),
	\+sprungm�glichkeit(_,_),
	ermittleZug(P),
	fail.

% Auflistung der Ergebnispr�dikate (und Ausgabe)
z�ge(_,Liste) :-
	listeSpr�nge([],Liste),
	\+Liste == [],
	write(Liste),!;
	listeZ�ge([],Liste),
	write(Liste),!.

%% --------------------------------------------------------------------
% echtZ�ge(+Farbe,-Zugliste).
%
% Ermittelt auf Grundlage des aktuellen Brettes alle m�glichen
% erlaubten Z�ge des �bergebenen Spielers. Die Liste der Z�ge wird in
% Zugliste zur�ckgeschrieben.
%
% Wird von laskazug.pl verwendet um Sieg durch Zugmangel zu ermitteln
% und das Zugmen� zu bef�llen.
%
%%

% Sprungermittlung
echtZ�ge(Farbe,_):-
	retractall(sprungm�glichkeit(_,_)),
	ermittleEchtSprung(Farbe,FFeld, SFeld,�bersprungen),
	ermittleEchtFolgesprung(Farbe,FFeld,SFeld,[�bersprungen]),
	filterSpr�nge(SFeld),
	fail.

% Zugermittlung
echtZ�ge(Farbe,_):-
	retractall(zugm�glichkeit(_,_)),
	\+sprungm�glichkeit(_,_),
	ermittleEchtZug(Farbe),
	fail.

% Auflistung der Ergebnispr�dikate
echtZ�ge(_,Liste):-
	listeSpr�nge([],Liste),
	\+Liste == [],!;
	listeZ�ge([],Liste),
	!.

%% -----------------------------------------------------------------------
% listeSpr�nge(+ListeVorhanden, -ListeErgebnis).
%
% Sammelt alle gefundenen Sprungm�glichkeiten in einer Liste und gibt
% diese zur�ck.
%
%%
listeSpr�nge(ListeVorhanden, ListeErgebnis) :-
	sprungm�glichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeSpr�nge(ListeNeu,ListeErgebnis).
listeSpr�nge(L,L).

%% -----------------------------------------------------------------------
% listeZ�ge(+ListeVorhanden, -ListeErgebnis).
%
% Sammelt alle gefundenen Zugm�glichkeiten in einer Liste und gibt
% diese zur�ck.
%
%%
listeZ�ge(ListeVorhanden, ListeErgebnis) :-
	zugm�glichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeZ�ge(ListeNeu,ListeErgebnis).
listeZ�ge(L,L).

%% -----------------------------------------------------------------------
% ermittleZug(+VirtuellesBrett).
%
% Ermittelt ausgehen von aktuell belegten SpielerFeldern alle m�glichen
% Z�ge.
%
% Gefundene Z�ge werden als Pr�dikat
% zugm�glichkeit(spielerFeld,zielFeld) gespeichert.
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
	assert(zugm�glichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleEchtZug(+Farbe).
%
% Ermittelt ausgehen vom aktuellen Brett und der �bergebenen
% Spielerfarbe alle m�glichen Z�ge.
%
% Gefundene Z�ge werden als Pr�dikat
% zugm�glichkeit(spielerFeld,zielFeld) gespeichert.
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
	assert(zugm�glichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleSprung(+VirtuellesBrett, -SpielerFeld, -LeerFeld, -GegnerFeld).
%
% Ermittelt ausgehen von aktuell belegten SpielerFeldern alle m�glichen
% Spr�nge �ber GegnerFelder auf LeerFelder.
%
% Gefundene Sprungm�glichkeiten werden als Pr�dikat
% sprungm�glichkeit(spielerFeld,zielFeld) gespeichert.
%
%%
ermittleSprung([Farbe|Brett], FFeld, LFeld, OFeld) :-
	virtuellSelbst(Farbe,Brett,FFeld,Head),
	sprungnachbarn(Head,LFeld,OFeld,FFeld),
	opponent(Opp,Head),
	turmAufFeld(Brett, OFeld,[Opp|_]),
	turmAufFeld(Brett, LFeld,[]),
	assert(sprungm�glichkeit(FFeld,LFeld)).

%% -----------------------------------------------------------------------
% ermittleEchtSprung(+Farbe, -SpielerFeld, -LeerFeld, -GegnerFeld).
%
% Ermittelt ausgehen vom aktuellen Brett und der �bergebenen
% Spielerfarbe alle m�glichen Spr�nge �ber
% GegnerFelder auf LeerFelder.
%
% Gefundene Sprungm�glichkeiten werden als Pr�dikat
% sprungm�glichkeit(spielerFeld,zielFeld) gespeichert.
%
%%
ermittleEchtSprung(Farbe, FFeld, LFeld, OFeld) :-
	selbst(Farbe,FFeld,Head),               %Ermittle die aktuell belegten Felder der Farbe und deren oberste Steine
	sprungnachbarn(Head,LFeld,OFeld,FFeld), %Ermittle m�gliche Spr�nge �ber Gegner auf Leerfelder
	brett(LFeld,[]),                        %Pr�fe ob das Sprungziel leer ist
	opponent(Opp,Head),                     %Ermittle die Art der obersten Steine des Gegners
	brett(OFeld,[Opp|_]),			%Pr�fe ob der zu �berspringende Stein ein gegnerischer ist
	assert(sprungm�glichkeit(FFeld,LFeld)). %Merke die Sprungm�glichkeit

%% -----------------------------------------------------------------------
% ermittleFolgesprung(+VirtuellesBrett, +StartFeld, +ZielFelder,
% +FeldListe).
%
% Ermittelt alle m�glichen Folgespr�nge �ber GegnerFelder auf
% LeerFelder auf Basis des �bergebenen virtuellen Brettes.
%
% Neue Gefundene Sprungm�glichkeiten werden als Pr�dikat
% sprungm�glichkeit(spielerFeld,zielFelder) gespeichert, wobei
% zielFelder auch alle Zwischenfelder enth�lt.
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
	assert(sprungm�glichkeit(StartFeld,ZFeld)),
	ermittleFolgesprung(Farbe, StartFeld, ZFeld, ListeNeu).
ermittleFolgesprung(_,_,_,_).

%% -----------------------------------------------------------------------
% ermittleEchtFolgeSprung(+Farbe, +StartFeld, +ZielFelder, +FeldListe).
%
% Ermittelt alle m�glichen Folgespr�nge �ber GegnerFelder auf
% LeerFelder auf Basis des aktuellen Brettes.
%
% Neue Gefundene Sprungm�glichkeiten werden als Pr�dikat
% sprungm�glichkeit(spielerFeld,zielFelder) gespeichert, wobei
% zielFelder auch alle Zwischenfelder enth�lt.
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
	assert(sprungm�glichkeit(StartFeld,ZFeld)),
	ermittleEchtFolgesprung(Farbe, StartFeld, ZFeld, ListeNeu).
ermittleEchtFolgesprung(_,_,_,_).

%% ------------------------------------------------------------------------
% sprungnachbarn(+Head, +ZielFeld, +MittelFeld, +UrsprungsFeld) :-
%
% Definiert einen m�glichen Sprung vom UrsprungsFeld �ber das MittelFeld
% zum Zielfeld in Abh�ngigkeit der (Kopfstein-)Farbe, um R�ckw�rtsspr�nge einzuschr�nken.
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
% filterSpr�nge(+SFeld,).
%
% Filtert die gefundenen Sprungm�glichkeiten, damit bei Mehrfachspr�ngen
% immer bis zum Ende gesprungen wird, indem Spr�nge, die auf
% Zwischenzielen enden entfernt werden.
%
%%
filterSpr�nge(SFeld) :-
	sprungm�glichkeit(UrsprungsFeld, Ziel),
	\+ Ziel == SFeld,
	filterSpr�nge(UrsprungsFeld, Ziel, SFeld).
filterSpr�nge(U, Z1, Z2):-
	 sub_atom(Z1,_,_,_,Z2),
	 retractall(sprungm�glichkeit(U, Z2)),
	 filterSpr�nge(Z1),
	 fail.
