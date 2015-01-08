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
%%	Testbrett für den Fall dass Sondersituationen gebaut werden
%	müssen.
%	Und das ganz bequem einkommentierbar :D
%
%	Aktuell: Test von Mehrfachsprüngen mit einem Offizier über
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
	zugmöglichkeit/2.
:- dynamic
	sprungmöglichkeit/2.

züge(P,_) :-
	retractall(sprungmöglichkeit(_,_)),
	write('Mögliche Züge: '),
	nl,
	sprünge(P,FFeld, SFeld,Übersprungen),
	folgesprünge(P,FFeld,SFeld,[Übersprungen]),
	filterSprünge(SFeld),
	fail.

züge(P,_) :-
	retractall(zugmöglichkeit(_,_)),
	\+sprungmöglichkeit(_,_),
	ermittleZug(P),
	fail.

züge(_,Liste) :-
	listeSprünge([],Liste),
	\+Liste == [],
	write(Liste),!;
	listeZüge([],Liste),
	write(Liste),!.

listeSprünge(ListeVorhanden, ListeErgebnis) :-
	sprungmöglichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeSprünge(ListeNeu,ListeErgebnis).

listeSprünge(L,L).

listeZüge(ListeVorhanden, ListeErgebnis) :-
	zugmöglichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeZüge(ListeNeu,ListeErgebnis).

listeZüge(L,L).

sprünge([Farbe|Brett], FFeld, LFeld, OFeld) :-
	selbst(Farbe,FFeld,Head),               %Ermittle die aktuell belegten Felder der Farbe und deren oberste Steine
	sprungnachbarn(Head,LFeld,OFeld,FFeld), %Ermittle mögliche Sprünge über Gegner auf Leerfelder
	turmAufBrett(Brett, LFeld,[]),                        %Prüfe ob das Sprungziel leer ist
	opponent(Opp,Head),                     %Ermittle die Art der obersten Steine des Gegners
	turmAufBrett(Brett, OFeld,[Opp|_]),			%Prüfe ob der zu überspringende Stein ein gegnerischer ist
	assert(sprungmöglichkeit(FFeld,LFeld)). %Merke die Sprungmöglichkeit

filterSprünge(SFeld) :-
	sprungmöglichkeit(UrsprungsFeld, Ziel),
	\+ Ziel == SFeld,
	filterSprung(UrsprungsFeld, Ziel, SFeld).

filterSprung(U, Z1, Z2):-
	 sub_atom(Z1,_,_,_,Z2),
	 retractall(sprungmöglichkeit(U, Z2)),
	 filterSprünge(Z1),
	 fail.

folgesprünge([Farbe|Brett],StartFeld,ZielFelder,FeldListe) :-
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
	assert(sprungmöglichkeit(StartFeld,ZFeld)),
	folgesprünge(Farbe, StartFeld, ZFeld, ListeNeu).

folgesprünge(_,_,_,_).

%%	Definiert einen möglichen Sprung vom UrsprungsFeld über das
%	MittelFeld zum Zielfeld in Abhängigkeit der (Kopfstein-)Farbe,
%	um Rückwärtssprünge einzuschränken.
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
	assert(zugmöglichkeit(FFeld,LFeld)).
