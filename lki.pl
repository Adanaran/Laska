:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

:- dynamic
	zugm�glichkeit/2.
:- dynamic
	sprungm�glichkeit/2.



z�ge(Farbe) :-
	retractall(sprungm�glichkeit(_,_)),
	write('M�gliche Z�ge werden berechnet... '),
	nl,
	spr�nge(Farbe),fail.

z�ge(Farbe) :-
	retractall(zugm�glichkeit(_,_)),
	z�g(Farbe),fail.

z�ge(_) :-
	write('Berechnung abgeschlossen'),nl,
	(
	sprungm�glichkeit(S,Z),
	write(S),write(Z)
        );
	zugm�glichkeit(S2,Z2),
	write(S2),write(Z2),nl,fail.

z�ge(_) :- true.

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

