%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Beispiel einer Ausgaberoutine für das Laska-Spiel
%
% U. Meyer, Okt. 2008
%
%
% Angenommen wird ein Spiel auf einem Schachbrett,
% gespielt wird auf den Feldern einer Farbe, die
% Felder der anderen Farbe gehören nicht zum Spielfeld.
%
% Demonstriert werden auch verschiedene Programmiertechniken
% in Prolog.
%
% Überarbeitet durch T. Röhrig
%
% Die Ausgabe der Felder wurde von write()-Ausgaben auf
% ansi_format() umgestellt, um das Bord besser darzustellen.
% Außerdem wurde die maximale Turmhöhe um einen Gefangengen erhöht.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Fakten zur Repräsentation benutzter Felder in der
% Ausgangsstellung: brett(Zeile,Spalte,Farbe)
%
:- dynamic
	brett/2.
:- retractall(brett(_,_)).
brett(a1,[w]).
brett(a3,[w]).
brett(a5,[w]).
brett(a7,[w]).
brett(b2,[w]).
brett(b4,[w]).
brett(b6,[w]).
brett(c1,[w]).
brett(c3,[w]).
brett(c5,[w]).
brett(c7,[w]).
brett(d2,[]). % diese drei Felder
brett(d4,[]). % (12, 13 und 14)
brett(d6,[]). % sind anfangs unbesetzt
brett(e1,[s]).
brett(e3,[s]).
brett(e5,[s]).
brett(e7,[s]).
brett(f2,[s]).
brett(f4,[s]).
brett(f6,[s]).
brett(g1,[s]).
brett(g3,[s]).
brett(g5,[s]).
brett(g7,[s]).
% Benachbarte Felder
nachbarn(a1,b2,c3).
nachbarn(a3,b2,c1).
nachbarn(a3,b4,c5).
nachbarn(a5,b4,c3).
nachbarn(a5,b6,c7).
nachbarn(a7,b6,c5).
nachbarn(b2,c1,x).
nachbarn(b2,c3,d4).
nachbarn(b4,c3,d2).
nachbarn(b4,c5,d6).
nachbarn(b6,c5,d4).
nachbarn(b6,c7,x).
nachbarn(c1,d2,e3).
nachbarn(c3,d2,e1).
nachbarn(c3,d4,e5).
nachbarn(c5,d4,e3).
nachbarn(c5,d6,e7).
nachbarn(c7,d6,e5).
nachbarn(d2,e1,x).
nachbarn(d2,e3,f4).
nachbarn(d4,e3,f2).
nachbarn(d4,e5,f6).
nachbarn(d6,e5,f4).
nachbarn(d6,e7,x).
nachbarn(e1,f2,g3).
nachbarn(e3,f2,g1).
nachbarn(e3,f4,g5).
nachbarn(e5,f4,g3).
nachbarn(e5,f6,g7).
nachbarn(e7,f6,g5).
nachbarn(f2,g1,x).
nachbarn(f2,g3,x).
nachbarn(f4,g3,x).
nachbarn(f4,g5,x).
nachbarn(f6,g5,x).
nachbarn(f6,g7,x).

hinweisfarbe(yellow).

% Hauptprozedur
schreibeBrett(Farbe) :-
	schreibeKopfFußLeer,
	schreibeKopfFuß,
	schreibeZeilen([g,f,e,d,c,b,a],Farbe),
	retract(fehler(_,_)),
	asserta(fehler(nein,Farbe)).

schreibeKopfFußLeer :-
	ansi_format([bg(white)],'                                                                                   ',[]),
	nl.
schreibeKopfFuß :-
	ansi_format([bg(white)],'        1          2          3          4          5          6          7        ',[]),
	nl.


% Ausgabe der Zeilen des Spielbretts
schreibeZeilen([],Farbe):- % Fusszeile unter dem Brett
	schreibeKopfFuß,
	schreibeKopfFußLeer,
	write(Farbe),write(' am Zug  ==> ').
schreibeZeilen([Zeile|T],Farbe) :- % 3-Felder-Reihen
	member(Zeile,[b,d,f]),
	schreibeFüllzeile3,
	schreibeFüllzeile3,
	upcase_atom(Zeile,Upper),
	ansi_format([bg(white)],' ~w ',[Upper]),
	schreibeZellen(Zeile,[x,2,x,4,x,6,x]),
	schreibeZeilen(T,Farbe),
	!.
schreibeZeilen([Zeile|T],Farbe) :- % 4-Felder-Reihen
	schreibeFüllzeile4,
	schreibeFüllzeile4,
	upcase_atom(Zeile,Upper),
	ansi_format([bg(white)],' ~w ',[Upper]),
	schreibeZellen(Zeile,[1,x,3,x,5,x,7]),
	schreibeZeilen(T,Farbe).

schreibeFüllzeile3 :-
	ansi_format([bg(white)],'   ',[]),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	ansi_format([bg(white)],'   ',[]),
	nl.

schreibeFüllzeile4 :-
	ansi_format([bg(white)],'   ',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	write('           '),
	ansi_format([bg(white)],'   ',[]),
	nl.


% Ausgabe der Felder (und horizontalen Trennzeilen)
schreibeZellen(Zeile,[]) :- % Trennzeile
	hinweisfarbe(Color),
	upcase_atom(Zeile,Upper),
	(   member(Zeile,[b,d,f]),
	    ansi_format([bg(white)],' ~w ',[Upper]),
	    nl,
	    schreibeFüllzeile3,
	    ansi_format([bg(white)],'   ',[]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w2', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w4', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w6', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([bg(white)],'   ',[])
	    ;
	    ansi_format([bg(white)],' ~w ',[Upper]),
	    nl,
	    schreibeFüllzeile4,
	    ansi_format([bg(white)],'   ',[]),
	    ansi_format([fg(Color)], '         ~w1', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w3', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w5', [Zeile]),
	    ansi_format([bg(black)],'XXXXXXXXXXX',[]),
	    ansi_format([fg(Color)], '         ~w7', [Zeile]),
	    ansi_format([bg(white)],'   ',[])

	),
	nl.
schreibeZellen(Zeile,[x|T]) :- % nicht genutztes "Zwischenfeld"
	ansi_format([bg(black)],'XXXXXXXXXXX',[]), % (auf einem Schachbrett die Felder einer Farbe)
	schreibeZellen(Zeile,T).
schreibeZellen(Zeile,[Spalte|T]) :-	% genutztes Spielfeld
	atom_concat(Zeile,Spalte,Feld),	% Feldbezeichner
	brett(Feld,Stapel),		% was liegt auf dem Feld?
	schreibeFeld(Stapel),		% Säule ausgeben
	schreibeZellen(Zeile,T).

schreibeFeld([]) :- % unbesetztes Feld (anfangs sind das 12, 13, 14)
	write('           ').
schreibeFeld([Kopf|Rest]) :-   % besetztes Feld
	kopfsymbol(Kopf,Symb),
	concat_atom(Rest,Gefangene),
	ansi_format([], '~w~w', [Symb,Gefangene]),% Schreibt das Kopfsymbol groß und hängt die Gefangenen an
	atom_length(Gefangene,Len),
	Leer is 10 - Len,
	fuellen(Leer,Fueller),
	write(Fueller).   % Leerzeichen für alle Pos. < 11

% Umwandlung in Großbuchstaben per Fakten
kopfsymbol(w,'W').
kopfsymbol(s,'S').
kopfsymbol(g,'G').
kopfsymbol(r,'R').

% Leerzeichen zum Auffüllen in gleicher Weise
fuellen(0,'').
fuellen(1,' ').
fuellen(2,'  ').
fuellen(3,'   ').
fuellen(4,'    ').
fuellen(5,'     ').
fuellen(6,'      ').
fuellen(7,'       ').
fuellen(8,'        ').
fuellen(9,'         ').
fuellen(10,'          ').
