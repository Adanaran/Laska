% bewertung.pl
% Autor: Dan Sörgel
%
% Enthält Prädikate zur Ermittlung einer Bewertung virtueller Bretter.
% Die KI verwendet dabei das Prädikat siegWertung\2.

%----------------------------------------------------------------
% addiereSteinWert(+P,+Feld,+Summand,?Summe).
%  Addiert den Wert des Steines auf Feld von P, wenn es ein Stein von
%  P(Farbe) ist, auf Summand und gibt das Ergbnis in Summe zurück.
%  Sollte auf dem Feld kein Stein von Farbe geben, wird Summe als
%  Summand zurückgegeben.

addiereSteinWert([schwarz|Brett],Feld,Summand,Summe):-
	turmAufFeld(Brett,Feld,[s|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert([schwarz|Brett],Feld,Summand,Summe):-
	turmAufFeld(Brett,Feld,[r|_]),
	config(wert_offizier,Wert),
	Summe is Summand + Wert.

addiereSteinWert([weiss|Brett],Feld,Summand,Summe):-
	turmAufFeld(Brett,Feld,[w|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert([weiss|Brett],Feld,Summand,Summe):-
	turmAufFeld(Brett,Feld,[g|_]),
	config(wert_bauer,Wert),
	Summe is Summand + Wert.

addiereSteinWert(_,_,Summand,Summand).

%----------------------------------------------------------------
% addiereRandWert(+P,+Feld,+Summand,?Summe).
%  Addiert für die Randfelder extra Werte hinzu, da diese unschlagbar
%  sind. Es wird in Summand der Wert eines Randfeldes Feld addiert,
%  wenn es von einem Stein von Farbe besetzt ist. Das Ergebnis wird
%  in Summe hinterlegt. Sollte das Feld un- oder falsch besetzt sein,
%  wird Summand als Summe zurückgegeben.

addiereRandWert([schwarz|Brett],Feld,Summand,Summe):-
	(
          turmAufFeld(Brett,Feld,[s|_]);
          turmAufFeld(Brett,Feld,[r|_])
	),
	config(wert_rand,Wert),
	Summe is Summand + Wert.

addiereRandWert([weiss|Brett],Feld,Summand,Summe):-
	(
          turmAufFeld(Brett,Feld,[w|_]);
          turmAufFeld(Brett,Feld,[g|_])
	),
	config(wert_rand,Wert),
	Summe is Summand + Wert.

addiereRandWert(_,_,Summand,Summand).

% ------------------------------------------------------------------
%  addiereTurmWert(+P,+Feld,+Summand,?Summe).
%   Addiert für den Turm auf Feld, dessen erste und zweiter Stein vom
%   Spieler Farbe ist den Wert für Doppeltürme auf Summand und gibt das
%   Ergebnis in Summe zurück. Wenn das feld leer oder kein Turm hält
%   oder falscher Farbe ist, wird Summand als Summe zurückgegeben.

addiereTurmWert([schwarz|Brett],Feld,Summand,Summe):-
	(
          turmAufFeld(Brett,Feld,[s,s|_]);
          turmAufFeld(Brett,Feld,[s,r|_]);
          turmAufFeld(Brett,Feld,[r,r|_]);
          turmAufFeld(Brett,Feld,[r,s|_])
	),
	config(wert_doppelTurm,Wert),
	Summe is Summand + Wert.

addiereTurmWert([weiss|Brett],Feld,Summand,Summe):-
	(
          turmAufFeld(Brett,Feld,[w,w|_]);
          turmAufFeld(Brett,Feld,[w,g|_]);
          turmAufFeld(Brett,Feld,[g,g|_]);
          turmAufFeld(Brett,Feld,[g,w|_])
        ),
	config(wert_doppelTurm,Wert),
	Summe is Summand + Wert.

addiereTurmWert(_,_,Summand,Summand).

% ------------------------------------------------------------------------
%  ermittleÜbersprungWert(+P,+Zug,?Wert).
%   Gibt den Wert in Wert zurück, den ein übersprungener Turm hat.
%   Türme, die befreit werden, sind wertvoller.

ermittleÜbersprungWert(P,Zug,Wert):-
	sub_atom(Zug,0,2,_,F1),
	sub_atom(Zug,2,2,_,F2),
	turmZwischen(P,F1,F2,[H1,H2|_]),
	(
	    (H1 == w,H2 == s);
	    (H1 == g,H2 == s);
	    (H1 == w,H2 == r);
	    (H1 == w,H2 == s);

	    (H1 == s,H2 == w);
	    (H1 == r,H2 == w);
	    (H1 == s,H2 == g);
	    (H1 == r,H2 == g)
	),
	config(wert_befreibarerTürme,Wert),!.

ermittleÜbersprungWert(_,_,0).

% ------------------------------------------------------------------------
%  summiereZugWerte(+P,+ListeVonZügen,?Wert).
%   Summiert die Werte der Züge in ListeVonZügen auf und gibt das
%   Ergebnis in Wert zurück.

summiereZugWerte(_,[],0).

summiereZugWerte(P,[H|T],Wert):-
	summiereZugWerte(P,T,Rest),
	istZug(H),
	config(wert_zug,WertZug),
	Wert is Rest + WertZug,!.

summiereZugWerte(P,[H|T],Wert):-
	summiereZugWerte(P,T,Rest),
	ermittleSprungLänge(H,Länge),
	ermittleÜbersprungWert(P,H,ÜberWert),
	config(wert_SprungLänge_x,Länge,WertSprung),
	Wert is Rest + WertSprung + ÜberWert,!.

% ------------------------------------------------------------------------
%  addiereEigeneZüge(+P,+Farbe,+Summand,?Summe).
%   Addiert für jeden eigenen möglichen Zug dessen Zugwert von
%   Summand und wird in Summe gespeichert. Wenn es keine Feindzüge gibt,
%   wird Summand in Summe gespeichert.

addiereEigeneZüge(P,Summand,Summe):-
	züge(P,Züge),
	summiereZugWerte(P,Züge,Wert),
	Summe is Summand + Wert.

% ------------------------------------------------------------------------
%  addiereSiegWertung(+P,+Summand,?Summe).
%   Addiert die Bewertung für ein Siegbrett, wenn der Gegener keine Züge
%   mehr auf P hat.

addiereSiegWertung([schwarz|Brett],Summand,Summe):-
	append([weiss],Brett,PGegner),
	züge(PGegner,Liste),
	Liste == [],
	config(wert_sieg,Wert),
	Summe is Summand + Wert,!,
	true.

addiereSiegWertung([weiss|Brett],Summand,Summe):-
	append([schwarz],Brett,PGegner),
	züge(PGegner,Liste),
	Liste == [],
	config(wert_sieg,Wert),
	Summe is Summand + Wert,!,
	true.

addiereSiegWertung(_,Summand,Summand).

% ---------------------------------------------------------------
%  Startprädikat bewerte(+P,?Bewertung).
%   Bewertet das P und bindet das Ergebnis an Bewertung

bewerte(P,Bewertung):-
	%Steinsumme berechnen - Mehr Steine sind immer gut
	addiereSteinWert(P,a1,0,Zwischen1),
	addiereSteinWert(P,a3,Zwischen1,Zwischen2),
	addiereSteinWert(P,a5,Zwischen2,Zwischen3),
	addiereSteinWert(P,a7,Zwischen3,Zwischen4),
	addiereSteinWert(P,b2,Zwischen4,Zwischen5),
	addiereSteinWert(P,b4,Zwischen5,Zwischen6),
	addiereSteinWert(P,b6,Zwischen6,Zwischen7),
	addiereSteinWert(P,c1,Zwischen7,Zwischen8),
	addiereSteinWert(P,c3,Zwischen8,Zwischen9),
	addiereSteinWert(P,c5,Zwischen9,Zwischen10),
	addiereSteinWert(P,c7,Zwischen10,Zwischen11),
	addiereSteinWert(P,d2,Zwischen11,Zwischen12),
	addiereSteinWert(P,d4,Zwischen12,Zwischen13),
	addiereSteinWert(P,d6,Zwischen13,Zwischen14),
	addiereSteinWert(P,e1,Zwischen14,Zwischen15),
	addiereSteinWert(P,e3,Zwischen15,Zwischen16),
	addiereSteinWert(P,e5,Zwischen16,Zwischen17),
	addiereSteinWert(P,e7,Zwischen17,Zwischen18),
	addiereSteinWert(P,f2,Zwischen18,Zwischen19),
	addiereSteinWert(P,f4,Zwischen19,Zwischen20),
	addiereSteinWert(P,f6,Zwischen20,Zwischen21),
	addiereSteinWert(P,g1,Zwischen21,Zwischen22),
	addiereSteinWert(P,g3,Zwischen22,Zwischen23),
	addiereSteinWert(P,g5,Zwischen23,Zwischen24),
	addiereSteinWert(P,g7,Zwischen24,Zwischen25),

	%Randfelder berechnen - Diese sind als Defenive gut
	addiereRandWert(P,a1,Zwischen25,Zwischen26),
	addiereRandWert(P,a3,Zwischen26,Zwischen27),
	addiereRandWert(P,a5,Zwischen27,Zwischen28),
	addiereRandWert(P,a7,Zwischen28,Zwischen29),
	addiereRandWert(P,c7,Zwischen29,Zwischen30),
	addiereRandWert(P,e7,Zwischen30,Zwischen31),
	addiereRandWert(P,g7,Zwischen31,Zwischen32),
	addiereRandWert(P,g5,Zwischen32,Zwischen33),
	addiereRandWert(P,g3,Zwischen33,Zwischen34),
	addiereRandWert(P,g1,Zwischen34,Zwischen35),
	addiereRandWert(P,e1,Zwischen35,Zwischen36),
	addiereRandWert(P,c1,Zwischen36,Zwischen37),

	%Türme die beim Schlag die Farbe nicht wechseln sind gut
	addiereTurmWert(P,a1,Zwischen37,Zwischen38),
	addiereTurmWert(P,a3,Zwischen38,Zwischen39),
	addiereTurmWert(P,a5,Zwischen39,Zwischen40),
	addiereTurmWert(P,a7,Zwischen40,Zwischen41),
	addiereTurmWert(P,b2,Zwischen41,Zwischen42),
	addiereTurmWert(P,b4,Zwischen42,Zwischen43),
	addiereTurmWert(P,b6,Zwischen43,Zwischen44),
	addiereTurmWert(P,c1,Zwischen44,Zwischen45),
	addiereTurmWert(P,c3,Zwischen45,Zwischen46),
	addiereTurmWert(P,c5,Zwischen46,Zwischen47),
	addiereTurmWert(P,c7,Zwischen47,Zwischen48),
	addiereTurmWert(P,d2,Zwischen48,Zwischen49),
	addiereTurmWert(P,d4,Zwischen49,Zwischen50),
	addiereTurmWert(P,d6,Zwischen50,Zwischen51),
	addiereTurmWert(P,e1,Zwischen51,Zwischen52),
	addiereTurmWert(P,e3,Zwischen52,Zwischen53),
	addiereTurmWert(P,e5,Zwischen53,Zwischen54),
	addiereTurmWert(P,e7,Zwischen54,Zwischen55),
	addiereTurmWert(P,f2,Zwischen55,Zwischen56),
	addiereTurmWert(P,f4,Zwischen56,Zwischen57),
	addiereTurmWert(P,f6,Zwischen57,Zwischen58),
	addiereTurmWert(P,g1,Zwischen58,Zwischen59),
	addiereTurmWert(P,g3,Zwischen59,Zwischen60),
	addiereTurmWert(P,g5,Zwischen60,Zwischen61),
	addiereTurmWert(P,g7,Zwischen61,Zwischen62),

	%Eigene Züge addieren
	addiereEigeneZüge(P,Zwischen62,Zwischen63),

	%Siegbrett werten
	addiereSiegWertung(P,Zwischen63,Bewertung),!,

	true.

% ------------------------------------------------------------------------
%  Startprädikat siegWertung(+P,?Wertung).
%   Gibt die Bewertung für die aktuelle Situation für beide Partein
%   wieder. Dabei wird die Differenz zwischen der weissen und der
%   schwarzen Wertung gegeben. Dabei hängt die Interpretation des
%   Wertes von der Seite ab, die die KI spielt. Aus Sicht der KI ist
%   eine Bewertung gegen +Unendlich gut, für den Gegner der KI ist eine
%   Bewertung gegen -Unendlich gut.

siegWertung([_|Brett],Wertung):-
	ki(F),
	gegner(F,G),
	append([F],Brett,IchBrett),
	append([G],Brett,GegnerBrett),
	bewerte(GegnerBrett,GegnerWert),
        bewerte(IchBrett,IchWert),
	Wertung is IchWert - GegnerWert.
