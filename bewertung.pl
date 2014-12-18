:-[board].

addiereSteinWert(schwarz,Feld,Summand,Summe):-
	brett(Feld,[s|_]),
	Summe is Summand + 1.

addiereSteinWert(schwarz,Feld,Summand,Summe):-
	brett(Feld,[r|_]),
	Summe is Summand + 3.

addiereSteinWert(weiss,Feld,Summand,Summe):-
	brett(Feld,[w|_]),
	Summe is Summand + 1.

addiereSteinWert(weiss,Feld,Summand,Summe):-
	brett(Feld,[g|_]),
	Summe is Summand + 3.

addiereSteinWert(_,_,Summand,Summand).


% Startprädikat bewerte(+farbe,-bewertung).
% Bewertet das aktuelle Brett
bewerte(Farbe,Bewertung):-
	%Steinsumme berechnen
	addiereSteinWert(Farbe,a1,0,Zwischen1),
	addiereSteinWert(Farbe,a3,Zwischen1,Zwischen2),
	addiereSteinWert(Farbe,a5,Zwischen2,Zwischen3),
	addiereSteinWert(Farbe,a7,Zwischen3,Zwischen4),
	addiereSteinWert(Farbe,b2,Zwischen4,Zwischen5),
	addiereSteinWert(Farbe,b4,Zwischen5,Zwischen6),
	addiereSteinWert(Farbe,b6,Zwischen6,Zwischen7),
	addiereSteinWert(Farbe,c1,Zwischen7,Zwischen8),
	addiereSteinWert(Farbe,c3,Zwischen8,Zwischen9),
	addiereSteinWert(Farbe,c5,Zwischen9,Zwischen10),
	addiereSteinWert(Farbe,c7,Zwischen10,Zwischen11),
	addiereSteinWert(Farbe,d2,Zwischen11,Zwischen12),
	addiereSteinWert(Farbe,d4,Zwischen12,Zwischen13),
	addiereSteinWert(Farbe,d6,Zwischen13,Zwischen14),
	addiereSteinWert(Farbe,e1,Zwischen14,Zwischen15),
	addiereSteinWert(Farbe,e3,Zwischen15,Zwischen16),
	addiereSteinWert(Farbe,e5,Zwischen16,Zwischen17),
	addiereSteinWert(Farbe,e7,Zwischen17,Zwischen18),
	addiereSteinWert(Farbe,f2,Zwischen18,Zwischen19),
	addiereSteinWert(Farbe,f4,Zwischen19,Zwischen20),
	addiereSteinWert(Farbe,f6,Zwischen20,Zwischen21),
	addiereSteinWert(Farbe,g1,Zwischen21,Zwischen22),
	addiereSteinWert(Farbe,g3,Zwischen22,Zwischen23),
	addiereSteinWert(Farbe,g5,Zwischen23,Zwischen24),
	addiereSteinWert(Farbe,g7,Zwischen24,Bewertung),!.
