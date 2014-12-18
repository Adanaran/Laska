:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

:- dynamic
	zugmöglichkeit/2.
:- dynamic
	sprungmöglichkeit/2.

züge(Farbe,_) :-
	retractall(sprungmöglichkeit(_,_)),
	write('Mögliche Züge werden berechnet... '),
	nl,
	sprünge(Farbe),
	fail.

züge(Farbe,_) :-
	retractall(zugmöglichkeit(_,_)),
	züg(Farbe),
	fail.

züge(_,_) :-
	write('Berechnung abgeschlossen'),
	nl,
	(
	sprungmöglichkeit(S,Z),
	write(S),write(Z),nl,fail
        );
	(
	zugmöglichkeit(S2,Z2),
	write(S2),write(Z2),nl,fail
	).

züge(_,Liste) :-
	(listeSprünge([],Liste),
	 \+Liste == [],
	 write(Liste)
	),
	!;
	(
	    listeZüge([],Liste2),
	    write(Liste2),
	    Liste = Liste2
	),
	!.

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


sprünge(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	opponent(Head,Opp),
	brett(OFeld,[Opp|_]),
	(
	    nachbarn(LFeld,OFeld,FFeld);
	    nachbarn(FFeld,OFeld,LFeld)
	),
	assert(sprungmöglichkeit(FFeld,LFeld)).

züg(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	(
	    nachbarn(LFeld,FFeld,_);
	    nachbarn(FFeld,LFeld,_)
	),
	assert(zugmöglichkeit(FFeld,LFeld)).



zieh :-
	ziehen(schwarz,e3d4),
	ziehen(weiss,c5e3),
	schreibeBrett(schwarz),!.

