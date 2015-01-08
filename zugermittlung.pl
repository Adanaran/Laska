:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].
:-[virtualBoard].

testbrett :-
retractall(brett(_,_)),
assert(brett(a1,[w])),
assert(brett(a3,[])),
assert(brett(a5,[])),
assert(brett(a7,[])),
assert(brett(b2,[s])),
assert(brett(b4,[])),
assert(brett(b6,[])),
assert(brett(c1,[])),
assert(brett(c3,[])),
assert(brett(c5,[])),
assert(brett(c7,[])),
assert(brett(d2,[s])),  % diese drei Felder
assert(brett(d4,[])), % (12, 13 und 14)
assert(brett(d6,[])), % sind anfangs (normalerweise) unbesetzt
assert(brett(e1,[])),
assert(brett(e3,[])),
assert(brett(e5,[])),
assert(brett(e7,[])),
assert(brett(f2,[])),
assert(brett(f4,[])),
assert(brett(f6,[])),
assert(brett(g1,[])),
assert(brett(g3,[])),
assert(brett(g5,[])),
assert(brett(g7,[])).
%%	Testbrett f�r den Fall dass Sondersituationen gebaut werden
%	m�ssen.
%	Und das ganz bequem einkommentierbar :D
%
%	Aktuell: Test von Mehrfachspr�ngen mit einem Offizier �ber
%	Offiziere und Gegner.
%
%:-testbrett.

zieh :-
	ziehen(schwarz,e3d4),
	ziehen(weiss,c5e3),
	ziehen(weiss, b6c5),
	ziehen(weiss, c1d2),
	ziehen(weiss, b2c1),
	schreibeBrett(schwarz),!.

:- dynamic
	zugm�glichkeit/2.
:- dynamic
	sprungm�glichkeit/2.

z�ge(P,_) :-
	retractall(sprungm�glichkeit(_,_)),
	write('M�gliche Z�ge: '),
	nl,
	spr�nge(P,FFeld, SFeld,�bersprungen),
	folgespr�nge(P,FFeld,SFeld,[�bersprungen]),
	filterSpr�nge(SFeld),
	fail.

z�ge(P,_) :-
	retractall(zugm�glichkeit(_,_)),
	\+sprungm�glichkeit(_,_),
	ermittleZug(P),
	fail.

z�ge(_,Liste) :-
	listeSpr�nge([],Liste),
	\+Liste == [],
	write(Liste),!;
	listeZ�ge([],Liste),
	write(Liste),!.

listeSpr�nge(ListeVorhanden, ListeErgebnis) :-
	sprungm�glichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeSpr�nge(ListeNeu,ListeErgebnis).

listeSpr�nge(L,L).

listeZ�ge(ListeVorhanden, ListeErgebnis) :-
	zugm�glichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeZ�ge(ListeNeu,ListeErgebnis).

listeZ�ge(L,L).

spr�nge([Farbe|Brett], FFeld, LFeld, OFeld) :-
	selbst(Farbe,FFeld,Head),               %Ermittle die aktuell belegten Felder der Farbe und deren oberste Steine
	sprungnachbarn(Head,LFeld,OFeld,FFeld), %Ermittle m�gliche Spr�nge �ber Gegner auf Leerfelder
	turmAufBrett(Brett, LFeld,[]),                        %Pr�fe ob das Sprungziel leer ist
	opponent(Opp,Head),                     %Ermittle die Art der obersten Steine des Gegners
	turmAufBrett(Brett, OFeld,[Opp|_]),			%Pr�fe ob der zu �berspringende Stein ein gegnerischer ist
	assert(sprungm�glichkeit(FFeld,LFeld)). %Merke die Sprungm�glichkeit

filterSpr�nge(SFeld) :-
	sprungm�glichkeit(UrsprungsFeld, Ziel),
	\+ Ziel == SFeld,
	filterSprung(UrsprungsFeld, Ziel, SFeld).

filterSprung(U, Z1, Z2):-
	 sub_atom(Z1,_,_,_,Z2),
	 retractall(sprungm�glichkeit(U, Z2)),
	 filterSpr�nge(Z1),
	 fail.

folgespr�nge([Farbe|Brett],StartFeld,ZielFelder,FeldListe) :-
	selbst(Farbe,StartFeld,Head),
	sub_atom(ZielFelder,_,2,0,ZielFeld),
	sprungnachbarn(Head,LFeld,OFeld,ZielFeld),
	(
	    turmAufBrett(Brett,LFeld,[]);
	    LFeld == StartFeld
	),
	opponent(Opp,Head),
	turmAufBrett(Brett, OFeld,[Opp|_]),
	\+member(OFeld, FeldListe),
	atom_concat(ZielFelder,LFeld,ZFeld),
	append(FeldListe,[OFeld],ListeNeu),
	assert(sprungm�glichkeit(StartFeld,ZFeld)),
	folgespr�nge(Farbe, StartFeld, ZFeld, ListeNeu).

folgespr�nge(_,_,_,_).

%%	Definiert einen m�glichen Sprung vom UrsprungsFeld �ber das
%	MittelFeld zum Zielfeld in Abh�ngigkeit der (Kopfstein-)Farbe,
%	um R�ckw�rtsspr�nge einzuschr�nken.
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

ermittleZug([Farbe|Brett]) :-
	turmAufFeld(Brett,LFeld,[]),
	selbst(Farbe,FFeld,Head),
	(
	    (
	    \+Head == w,
	    nachbarn(LFeld,FFeld,_)
	)
	    ;
	    (
	    \+Head == s,
	    nachbarn(FFeld,LFeld,_)
	    )

	),
	assert(zugm�glichkeit(FFeld,LFeld)).
