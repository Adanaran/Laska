:-[laskazug].
:-retractall(brett(_,_)).
:-[laskazug].

züge(Farbe) :-
	write('Mögliche Züge: '),
	nl,
	sprünge(Farbe).
züge(Farbe) :-
	züg(Farbe).


sprünge(Head) :-
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
	write(' über '),
	write(OFeld).

züg(Head) :-
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

