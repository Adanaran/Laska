:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

:- dynamic
	zugm�glichkeit/2.
:- dynamic
	sprungm�glichkeit/2.

z�ge(Farbe,_) :-
	retractall(sprungm�glichkeit(_,_)),
	write('M�gliche Z�ge werden berechnet... '),
	nl,
	spr�nge(Farbe),
	fail.

z�ge(Farbe,_) :-
	retractall(zugm�glichkeit(_,_)),
	z�g(Farbe),
	fail.

z�ge(_,_) :-
	write('Berechnung abgeschlossen'),
	nl,
	(
	sprungm�glichkeit(S,Z),
	write(S),write(Z),nl,fail
        );
	(
	zugm�glichkeit(S2,Z2),
	write(S2),write(Z2),nl,fail
	).

z�ge(_,Liste) :-
	(listeSpr�nge([],Liste),
	 \+Liste == [],
	 write(Liste)
	),
	!;
	(
	    listeZ�ge([],Liste2),
	    write(Liste2),
	    Liste = Liste2
	),
	!.

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


spr�nge(Farbe) :-
	selbst(Farbe,FFeld,Head),
	brett(LFeld,[]),
	opponent(Head,Opp),
	brett(OFeld,[Opp|_]),
	(
	    (
	    \+Head == w,
	    nachbarn(LFeld,OFeld,FFeld)
	)
	    ;
	    (
	    \+Head == s,
	    nachbarn(FFeld,OFeld,LFeld)
	    )
	),
	assert(sprungm�glichkeit(FFeld,LFeld)).

z�g(Farbe) :-
	brett(LFeld,[]),
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



zieh :-
	ziehen(schwarz,e3d4),
	ziehen(weiss,c5e3),
	schreibeBrett(schwarz),!.

