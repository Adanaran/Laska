:-[laskazug].
feld(a1,1).
feld(a3,2).
feld(a5,3).
feld(a7,4).
feld(b2,5).
feld(b4,6).
feld(b6,7).
feld(c1,8).
feld(c3,9).
feld(c5,10).
feld(c7,11).
feld(d2,12).
feld(d4,13).
feld(d6,14).
feld(e1,15).
feld(e3,16).
feld(e5,17).
feld(e7,18).
feld(f2,19).
feld(f4,20).
feld(f6,21).
feld(g1,22).
feld(g3,23).
feld(g5,24).
feld(g7,25).

turmAufFeld(Brett, Koordinate, Turm) :-
	feld(Koordinate,Index),
	nth1(Index,Brett,Turm).

virtualisiereBrett([Farbe|P]) :-
	farbe(Farbe),
	findall(Turm, brett(_,Turm),P).


% ------------------------------------------------------------------------
%  virtuellZiehen(+Farbe,+Zugfolge).
virtuellZiehen(Farbe,Zugfolge):-
	atom_length(Zugfolge,L),
	L >= 4,
	0 is L mod 2,
	virtuellZug(Farbe,Zugfolge,L), !,
	true.

virtuellZiehen(_,_):-
	nl,write('Ung�ltige Eingabe!'),nl,nl,
	true.

virtuellZug(Farbe,Zugfolge,4):-
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,

	true.
