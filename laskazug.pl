:- dynamic
	fehler/2.
fehler(nein,weiss).	% Schwarz beginnt das Spiel, s.u.!!

:- ['board.pl'].

dialog :-
	farbe(Farbe),
	schreibeBrett(Farbe),
	read(Zugfolge),
	ziehen(Farbe,Zugfolge),
	fail.
farbe(F) :- fehler(ja,F).
farbe(schwarz) :- fehler(nein,weiss).
farbe(weiss) :- fehler(nein,schwarz).
farbe(F) :- farbe(F).
ziehen(Farbe,Zugfolge) :-
	atom_length(Zugfolge,L),
	L >= 4,
	0 is L mod 2,
	zug(Farbe,Zugfolge,L), !.
ziehen(Farbe,_) :-
	nl,write('Ungültige Eingabe!'),nl,nl,
	retract(fehler(_,_)),asserta(fehler(ja,Farbe)).
zug(Farbe,Zugfolge,4) :-
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,
	selbst(Farbe,FeldA,Kopf),
	( testMove(Farbe,Kopf,FeldA,FeldZ), move(FeldA,FeldZ)
	; testJump(Farbe,Kopf,FeldA,FeldZ,M), jump(FeldA,M,FeldZ)
	), !.

zug(Farbe,Zugfolge,Zuglänge) :-
	ZL is Zuglänge-4,
	ZL2 is Zuglänge-2,
	sub_atom(Zugfolge,ZL,2,_,FeldA),
	sub_atom(Zugfolge,ZL2,2,_,FeldZ),
	zug(Farbe,Zugfolge,ZL2),
	FeldA \== FeldZ,
	selbst(Farbe,FeldA,Kopf),
	testJump(Farbe,Kopf,FeldA,FeldZ,M), jump(FeldA,M,FeldZ),
	!.

demo :-
	schreibeBrett(schwarz),write(e3d4),nl,
	selbst(schwarz,e3,KopfS1),
	e3 \== d4,
	testMove(schwarz,KopfS1,e3,d4),
	move(e3,d4),
	schreibeBrett(weiss),write(c5e3),nl,
	selbst(weiss,c5,KopfW),
	c5 \== e3,
	testJump(weiss,KopfW,c5,e3,M1),
	jump(c5,M1,e3),
	schreibeBrett(schwarz),write(f2d4),nl,
	selbst(schwarz,f2,KopfS2),
	f2 \== d4,
	testJump(schwarz,KopfS2,f2,d4,M2),
	jump(f2,M2,d4),
	schreibeBrett(weiss),!.

selbst(schwarz,Feld,s) :-
	brett(Feld,[s|_]).
selbst(schwarz,Feld,r) :-
	brett(Feld,[r|_]).
selbst(weiss,Feld,w) :-
	brett(Feld,[w|_]).
selbst(weiss,Feld,g) :-
	brett(Feld,[g|_]).
opponent(w,s).
opponent(w,r).
opponent(g,s).
opponent(g,r).

opponent(s,w).
opponent(s,g).
opponent(r,w).
opponent(r,g).

testMove(schwarz,Kopf,FeldA,FeldZ) :-
	( nachbarn(FeldZ,FeldA,_)
	; Kopf == r, nachbarn(FeldA,FeldZ,_)
	),
	brett(FeldZ,[]).
testMove(weiss,Kopf,FeldA,FeldZ) :-
	( nachbarn(FeldA,FeldZ,_)
	; Kopf == g, nachbarn(FeldZ,FeldA,_)
	),
	brett(FeldZ,[]).

move(FeldA,FeldZ) :-
	retract(brett(FeldA,Stapel)),
	assertz(brett(FeldA,[])),
	retract(brett(FeldZ,[])),
	asserta(brett(FeldZ,Stapel)).

testJump(schwarz,Kopf,FeldA,FeldZ,M) :-
	( nachbarn(FeldZ,M,FeldA)
	; Kopf == r, nachbarn(FeldA,M,FeldZ)
	),
	brett(M,[Mkopf|_]),
	opponent(Kopf,Mkopf),
	brett(FeldZ,[]).
testJump(weiss,Kopf,FeldA,FeldZ,M) :-
	( nachbarn(FeldA,M,FeldZ)
	; Kopf == g, nachbarn(FeldZ,M,FeldA)
	),
	brett(M,[Mkopf|_]),
	opponent(Kopf,Mkopf),
	brett(FeldZ,[]).

jump(FeldA,M,FeldZ) :-
	retract(brett(FeldA,StapelA)),
	assertz(brett(FeldA,[])),
	retract(brett(M,[KopfM|RestM])),
	asserta(brett(M,RestM)),
	retract(brett(FeldZ,[])),
	append(StapelA,[KopfM],StapelZ),
	asserta(brett(FeldZ,StapelZ)).
