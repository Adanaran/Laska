:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

z�ge(Farbe) :-
	write('M�gliche Z�ge: '),
	nl,
	spr�nge(Farbe).
z�ge(Farbe) :-
	z�g(Farbe).


spr�nge(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	opponent(Head,Opp),
	brett(OFeld,[Opp|_]),
	(
	    nachbarn(LFeld,OFeld,FFeld);
	    nachbarn(FFeld,OFeld,LFeld)
	),
	write(FFeld),
	write('-->'),
	write(LFeld),
	write(' �ber '),
	write(OFeld).

z�g(Head) :-
	brett(LFeld,[]),
	brett(FFeld,[Head|_]),
	(
	    nachbarn(LFeld,FFeld,_);
	    nachbarn(FFeld,LFeld,_)
	),
	write(FFeld),
	write('-->'),
	write(LFeld).


zieh :-
	ziehen(schwarz,e3d4),
	ziehen(weiss,c5e3),
	schreibeBrett(schwarz),!.

