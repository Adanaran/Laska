:-[board].
:-[config].
:-[lki].

%----------------------------------------------------------------
% addiereSteinWert(+Farbe,+Feld,+Summand,-Summe).
%  Addiert den Wert des Steines auf Feld, wenn es ein Stein von Farbe
%  ist, auf Summand und gibt das Ergbnis in Summe zurück. Sollte auf dem
%  Feld kein Stein von Farbe geben, wird Summe als Summand
%  zurückgegeben.

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

%----------------------------------------------------------------
% addiereRandWert(+Farbe,+Feld,+Summand,-Summe).
%  Addiert für die Randfelder extra Werte hinzu, da diese unschlagbar
%  sind. Es wird in Summand der Wert eines Randfeldes Feld addiert,
%  wenn es von einem Stein von Farbe besetzt ist. Das Ergebnis wird
%  in Summe hinterlegt. Sollte das Feld un- oder falsch besetzt sein,
%  wird Summand als Summe zurückgegeben.

addiereRandWert(schwarz,Feld,Summand,Summe):-
	(
          brett(Feld,[s|_]);
          brett(Feld,[r|_])
        ),
	config(wert_rand,Wert),
	Summe is Summand + Wert.

addiereRandWert(weiss,Feld,Summand,Summe):-
	(
          brett(Feld,[w|_]);
          brett(Feld,[g|_])
        ),
	config(wert_rand,Wert),
	Summe is Summand + Wert.

addiereRandWert(_,_,Summand,Summand).

% ------------------------------------------------------------------
%  addiereTurmWert(+Farbe,+Feld,+Summand,-Summe).
%   Addiert für den Turm auf Feld, dessen erste und zweiter Stein vom
%   Spieler Farbe ist den Wert für Doppeltürme auf Summand und gibt das
%   Ergebnis in Summe zurück. Wenn das feld leer oder kein Turm hält
%   oder falscher Farbe ist, wird Summand als Summe zurückgegeben.

addiereTurmWert(schwarz,Feld,Summand,Summe):-
	(
          brett(Feld,[s,s|_]);
          brett(Feld,[s,r|_]);
          brett(Feld,[r,r|_]);
          brett(Feld,[r,s|_])
        ),
	config(wert_doppelTurm,Wert),
	Summe is Summand + Wert.

addiereTurmWert(weiss,Feld,Summand,Summe):-
	(
          brett(Feld,[w,w|_]);
          brett(Feld,[w,g|_]);
          brett(Feld,[g,g|_]);
          brett(Feld,[g,w|_])
        ),
	config(wert_doppelTurm,Wert),
	Summe is Summand + Wert.

addiereTurmWert(_,_,Summand,Summand).

% ------------------------------------------------------------------------
%  subtrahiere(+Farbe,+Summand,-Summe).
%   Subtrahiert für jeden feindlich möglichen Zug wird von Summand die
%   Strafe für jeden möglichen Feindzug abgezogen und in Summe
%   gespeichert. Wenn es keine Feindzüge gibt, wird Summand in Summe
%   gespeichert.

subtrahiereGegnerZüge(schwarz,Summand,Summe):-
	züge(weiss,Züge),
	length(Züge,Anzahl_Züge),
	config(strafe_gegnerZüge,Strafe),
	Summe is Summand - (Anzahl_Züge * Strafe),
	true.

subtrahiereGegnerZüge(weiss,Summand,Summe):-
	züge(schwarz,Züge),
	length(Züge,Anzahl_Züge),
	config(strafe_gegnerZüge,Strafe),
	Summe is Summand - (Anzahl_Züge * Strafe),
	true.

%---------------------------------------------------------------
%  Startprädikat bewerte(+Farbe,-Bewertung).
%   Bewertet das aktuelle Brett von Farbe und bindet das Ergebnis an
%   Bewertung

bewerte(Farbe,Bewertung):-
	%Steinsumme berechnen - Mehr Steine sind immer gut
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

	%Randfelder berechnen - Diese sind als Defenive gut
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
	addiereRandWert(Farbe,c1,Zwischen36,Zwischen37),

	%Türme die beim Schlag die Farbe nicht wechseln sind gut
	addiereTurmWert(Farbe,a1,Zwischen37,Zwischen38),
	addiereTurmWert(Farbe,a3,Zwischen38,Zwischen39),
	addiereTurmWert(Farbe,a5,Zwischen39,Zwischen40),
	addiereTurmWert(Farbe,a7,Zwischen40,Zwischen41),
	addiereTurmWert(Farbe,b2,Zwischen41,Zwischen42),
	addiereTurmWert(Farbe,b4,Zwischen42,Zwischen43),
	addiereTurmWert(Farbe,b6,Zwischen43,Zwischen44),
	addiereTurmWert(Farbe,c1,Zwischen44,Zwischen45),
	addiereTurmWert(Farbe,c3,Zwischen45,Zwischen46),
	addiereTurmWert(Farbe,c5,Zwischen46,Zwischen47),
	addiereTurmWert(Farbe,c7,Zwischen47,Zwischen48),
	addiereTurmWert(Farbe,d2,Zwischen48,Zwischen49),
	addiereTurmWert(Farbe,d4,Zwischen49,Zwischen50),
	addiereTurmWert(Farbe,d6,Zwischen50,Zwischen51),
	addiereTurmWert(Farbe,e1,Zwischen51,Zwischen52),
	addiereTurmWert(Farbe,e3,Zwischen52,Zwischen53),
	addiereTurmWert(Farbe,e5,Zwischen53,Zwischen54),
	addiereTurmWert(Farbe,e7,Zwischen54,Zwischen55),
	addiereTurmWert(Farbe,f2,Zwischen55,Zwischen56),
	addiereTurmWert(Farbe,f4,Zwischen56,Zwischen57),
	addiereTurmWert(Farbe,f6,Zwischen57,Zwischen58),
	addiereTurmWert(Farbe,g1,Zwischen58,Zwischen59),
	addiereTurmWert(Farbe,g3,Zwischen59,Zwischen60),
	addiereTurmWert(Farbe,g5,Zwischen60,Zwischen61),
	addiereTurmWert(Farbe,g7,Zwischen61,Zwischen62),

	%Züge des Gegners rausrechnen
	subtrahiereGegnerZüge(Farbe,Zwischen62,Bewertung),!,

	true.
