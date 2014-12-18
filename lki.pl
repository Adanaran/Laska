:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

:- dynamic
	zugmöglichkeit/2.
:- dynamic
	sprungmöglichkeit/2.



züge(Farbe) :-
	retractall(sprungmöglichkeit(_,_)),
	write('Mögliche Züge werden berechnet... '),
	nl,
	sprünge(Farbe),fail.

züge(Farbe) :-
	retractall(zugmöglichkeit(_,_)),
	züg(Farbe),fail.

züge(_) :-
	write('Berechnung abgeschlossen'),nl,
	(
	sprungmöglichkeit(S,Z),
	write(S),write(Z)
        );
	zugmöglichkeit(S2,Z2),
	write(S2),write(Z2),nl,fail.

züge(_) :- true.

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

