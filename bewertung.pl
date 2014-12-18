:-[board].
:-[config].

addiereSteinWert(schwarz,Feld,Summand,Summe):-
	brett(Feld,[s|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert(schwarz,Feld,Summand,Summe):-
	brett(Feld,[r|_]),
	config(wert_offizier,Wert),
	Summe is Summand + Wert.

addiereSteinWert(weiss,Feld,Summand,Summe):-
	brett(Feld,[w|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert(weiss,Feld,Summand,Summe):-
	brett(Feld,[g|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert(_,_,Summand,Summand).

addiereRandWert(schwarz,Feld,Summand,Summe):-
	(
          brett(Feld,[s|_]);
          brett(Feld,[r|_])
        ),
	config(wert_rand,Wert),
	Summe is Summand + Wert,
	true.

addiereRandWert(weiss,Feld,Summand,Summe):-
	(
          brett(Feld,[w|_]);
          brett(Feld,[g|_])
        ),
	config(wert_rand,Wert),
	Summe is Summand + Wert,
	true.

addiereRandWert(_,_,Summand,Summand).

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
	addiereSteinWert(Farbe,g7,Zwischen24,Zwischen25),

	addiereRandWert(Farbe,a1,Zwischen25,Zwischen26),
	addiereRandWert(Farbe,a3,Zwischen26,Zwischen27),
	addiereRandWert(Farbe,a5,Zwischen27,Zwischen28),
	addiereRandWert(Farbe,a7,Zwischen28,Zwischen29),
	addiereRandWert(Farbe,c7,Zwischen29,Zwischen30),
	addiereRandWert(Farbe,e7,Zwischen30,Zwischen31),
	addiereRandWert(Farbe,g7,Zwischen31,Zwischen32),
	addiereRandWert(Farbe,g5,Zwischen32,Zwischen33),
	addiereRandWert(Farbe,g3,Zwischen33,Zwischen34),
	addiereRandWert(Farbe,g1,Zwischen34,Zwischen35),
	addiereRandWert(Farbe,e1,Zwischen35,Zwischen36),
	addiereRandWert(Farbe,c1,Zwischen36,Bewertung),!,

	true.
