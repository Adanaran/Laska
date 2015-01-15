%:-[laskazug].
%:-[utils].

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

	brett(a1,Turm1),
	append([],[Turm1],P2),
	brett(a3,Turm2),
	append(P2,[Turm2],P3),
	brett(a5,Turm3),
	append(P3,[Turm3],P4),
	brett(a7,Turm4),
	append(P4,[Turm4],P5),

	brett(b2,Turm5),
	append(P5,[Turm5],P6),
	brett(b4,Turm6),
	append(P6,[Turm6],P7),
	brett(b6,Turm7),
	append(P7,[Turm7],P8),

	brett(c1,Turm8),
	append(P8,[Turm8],P9),
	brett(c3,Turm9),
	append(P9,[Turm9],P10),
	brett(c5,Turm10),
	append(P10,[Turm10],P11),
	brett(c7,Turm11),
	append(P11,[Turm11],P12),

	brett(d2,Turm12),
	append(P12,[Turm12],P13),
	brett(d4,Turm133),
	append(P13,[Turm133],P14),
	brett(d6,Turm13),
	append(P14,[Turm13],P15),

	brett(e1,Turm14),
	append(P15,[Turm14],P16),
	brett(e3,Turm15),
	append(P16,[Turm15],P17),
	brett(e5,Turm16),
	append(P17,[Turm16],P18),
	brett(e7,Turm17),
	append(P18,[Turm17],P19),

	brett(f2,Turm18),
	append(P19,[Turm18],P20),
	brett(f4,Turm19),
	append(P20,[Turm19],P21),
	brett(f6,Turm20),
	append(P21,[Turm20],P22),

	brett(g1,Turm21),
	append(P22,[Turm21],P23),
	brett(g3,Turm22),
	append(P23,[Turm22],P24),
	brett(g5,Turm23),
	append(P24,[Turm23],P25),
	brett(g7,Turm24),
	append(P25,[Turm24],P),!.

% ------------------------------------------------------------------------
%  virtuellZiehen(+P,+Zugfolge,-PRes).
%   Zieht eine Zugfolge auf P und bindet das Ergebnis an PRes.

virtuellZiehen([Farbe|Brett],Zugfolge,PResOffizier):-
	atom_length(Zugfolge,L),
	L >= 4,
	0 is L mod 2,
	virtuellZug(Brett,Farbe,Zugfolge,L,PRes), !,
	offizier(PRes,Zugfolge,L,PResOffizier),
	true.

virtuellZiehen(_,_,_):-
	nl,write('Ung¸ltige Eingabe!'),nl,nl,
	true.

% ------------------------------------------------------------------------
%

offizier([schwarz|Brett],Zugfolge,N,PRes):-
	NStart is N - 2,
	sub_atom(Zugfolge,NStart,N,_,FeldEnde),
	feld(FeldEnde,Index),
	nth0(Index,Brett,[w|_]),

	nth1(Index,Brett,[_|TurmOhneKopf],BrettRest),
	append([g],TurmOhneKopf,TurmMitKopf),
	nth1(Index,BrettRes,TurmMitKopf,BrettRest),

	append([schwarz],BrettRes,PRes),

	true.

offizier([weiss|Brett],Zugfolge,N,PRes):-
	NStart is N - 2,
	sub_atom(Zugfolge,NStart,N,_,FeldEnde),
	feld(FeldEnde,Index),
	nth0(Index,Brett,[w|_]),

	nth1(Index,Brett,[_|TurmOhneKopf],BrettRest),
	append([r],TurmOhneKopf,TurmMitKopf),
	nth1(Index,BrettRes,TurmMitKopf,BrettRest),

	append([weiss],BrettRes,PRes),

	true.

offizier(P,_,_,P).


% ------------------------------------------------------------------------
%  virtuellZug(+Brett,+Farbe,+Zugfolge,+L‰nge,-Ergebnis)
%   F¸hrt die Zugfolge von Farbe auf Brett mit der L‰nge aus und gibt
%   das resultierende virtuelle Brett zur¸ck.

%Z‹GE
virtuellZug(Brett,schwarz,Zugfolge,4,PRes):-
	istZug(Zugfolge),
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,
	turmAufFeld(Brett,FeldZ,[]),
	(
	    turmAufFeld(Brett,FeldA,[s|_]);
	    turmAufFeld(Brett,FeldA,[r|_])
	),
	feld(FeldA,IndexA),
	feld(FeldZ,IndexZ),

	nth1(IndexA,Brett,Turm,PRest),
	nth1(IndexA,P2,[],PRest),

	nth1(IndexZ,P2,_,PRest2),
	nth1(IndexZ,[_|BrettRes],Turm,PRest2),
	append([weiss],BrettRes,PRes).

virtuellZug(Brett,weiss,Zugfolge,4,PRes):-
	istZug(Zugfolge),
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,
	turmAufFeld(Brett,FeldZ,[]),
	(
	    turmAufFeld(Brett,FeldA,[w|_]);
	    turmAufFeld(Brett,FeldA,[g|_])
	),
	feld(FeldA,IndexA),
	feld(FeldZ,IndexZ),

	nth1(IndexA,Brett,Turm,PRest),
	nth1(IndexA,P2,[],PRest),

	nth1(IndexZ,P2,_,PRest2),
	nth1(IndexZ,[_|BrettRes],Turm,PRest2),
	append([schwarz],BrettRes,PRes).

%SPR‹NGE_EINFACH
virtuellZug(Brett,schwarz,Zugfolge,4,PRes):-
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,
	turmAufFeld(Brett,FeldZ,[]),
	(
	    turmAufFeld(Brett,FeldA,[s|_]);
	    turmAufFeld(Brett,FeldA,[r|_])
	),
	append([schwarz],Brett,P),
	(
	    turmZwischen(P,FeldA,FeldZ,[w|_]);
	    turmZwischen(P,FeldA,FeldZ,[g|_])
	),
	feld(FeldA,IndexA),
	feld(FeldZ,IndexZ),
	feldZwischen(FeldA,FeldZ,Feld‹),
	feld(Feld‹,Index‹),

	nth1(IndexA,Brett,TurmZiehend,BrettRest),
	nth1(IndexA,Brett2,[],BrettRest),

	nth1(Index‹,Brett2,[KopfGeschlagen|RestGeschlagen],BrettRest2),
	append(TurmZiehend,[KopfGeschlagen],TurmZiehendMitKopf),
	nth1(Index‹,Brett3,RestGeschlagen,BrettRest2),

	nth1(IndexZ,Brett3,_,BrettRest3),
	nth1(IndexZ,BrettRes,TurmZiehendMitKopf,BrettRest3),
	append([weiss],BrettRes,PRes).

virtuellZug(Brett,weiss,Zugfolge,4,PRes):-
	sub_atom(Zugfolge,0,2,_,FeldA),
	sub_atom(Zugfolge,2,2,_,FeldZ),
	FeldA \== FeldZ,
	turmAufFeld(Brett,FeldZ,[]),
	(
	    turmAufFeld(Brett,FeldA,[w|_]);
	    turmAufFeld(Brett,FeldA,[g|_])
	),
	append([weiss],Brett,P),
	(
	    turmZwischen(P,FeldA,FeldZ,[s|_]);
	    turmZwischen(P,FeldA,FeldZ,[r|_])
	),
	feld(FeldA,IndexA),
	feld(FeldZ,IndexZ),
	feldZwischen(FeldA,FeldZ,Feld‹),
	feld(Feld‹,Index‹),

	nth1(IndexA,Brett,TurmZiehend,BrettRest),
	nth1(IndexA,Brett2,[],BrettRest),

	nth1(Index‹,Brett2,[KopfGeschlagen|RestGeschlagen],BrettRest2),
	append(TurmZiehend,[KopfGeschlagen],TurmZiehendMitKopf),
	nth1(Index‹,Brett3,RestGeschlagen,BrettRest2),

	nth1(IndexZ,Brett3,_,BrettRest3),
	nth1(IndexZ,BrettRes,TurmZiehendMitKopf,BrettRest3),
	append([schwarz],BrettRes,PRes).

%SPR‹NGE_MEHRFACH
virtuellZug(Brett,Farbe,Zugfolge,N,PRes):-
	sub_atom(Zugfolge,0,4,_,Zug1),
	NNeu is N - 2,
	sub_atom(Zugfolge,2,NNeu,_,ZugRest),
	virtuellZug(Brett,Farbe,Zug1,4,[_|NeuBrett]),
	virtuellZug(NeuBrett,Farbe,ZugRest,NNeu,PRes).



