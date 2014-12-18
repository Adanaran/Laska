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
	write(S),write(Z),nl
        );
	(
	zugm�glichkeit(S2,Z2),
	write(S2),write(Z2),nl
	),
	fail.

z�ge(_,Liste) :-
	listeZ�ge([],Liste),!.

listeZ�ge(ListeVorhanden, ListeErgebnis) :-
	zugm�glichkeit(S,Z),
	atom_concat(S,Z,Zug),
	\+member(Zug,ListeVorhanden),
	append(ListeVorhanden, [Zug], ListeNeu),
	listeZ�ge(ListeNeu,ListeErgebnis).

listeZ�ge(ListeVorhanden,ListeVorhanden).

spr�nge(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	opponent(Head,Opp),
	brett(OFeld,[Opp|_]),
	(
	    nachbarn(LFeld,OFeld,FFeld);
	    nachbarn(FFeld,OFeld,LFeld)
	),
	assert(sprungm�glichkeit(FFeld,LFeld)).

z�g(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	(
	    nachbarn(LFeld,FFeld,_);
	    nachbarn(FFeld,LFeld,_)
	),
	assert(zugm�glichkeit(FFeld,LFeld)).



zieh :-
	ziehen(schwarz,e3d4),
	ziehen(weiss,c5e3),
	schreibeBrett(schwarz),!.

