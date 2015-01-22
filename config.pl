%% Config-Block für weiss %%

config(wert_bauer,BWert):-
	fehler(nein,schwarz),
%	config(wert_bauer,weiss,BWert),!.
	BWert is 3,!.
config(wert_offizier,OWert):-
	fehler(nein,schwarz),
	OWert is 3,!.
config(wert_rand,RWert):-
	fehler(nein,schwarz),
	RWert is 1,!.
config(wert_doppelTurm,DTWert):-
	fehler(nein,schwarz),
	DTWert is 1,!.
config(wert_zug,ZWert):-
	fehler(nein,schwarz),
	ZWert is 1,!.
config(wert_befreibarerTürme,BTWert):-
	fehler(nein,schwarz),
	BTWert is 1,!.
config(wert_sieg,WSieg):-
	fehler(nein,schwarz),
	WSieg is 10000,!.

%% Config-Block für schwarz %%

config(wert_bauer,BWert):-
	BWert is 1.
config(wert_offizier,OWert):-
	OWert is 50.
config(wert_rand,RWert):-
	RWert is 5.
config(wert_doppelTurm,DTWert):-
	DTWert is 10.
config(wert_zug,ZWert):-
	ZWert is 0.
config(wert_befreibarerTürme,BTWert):-
	BTWert is 10.
config(wert_sieg,WSieg):-
	WSieg is 10000.

config(max_tiefe_ki,6).
config(max_tiefe_ab_ki,8).

config(wert_SprungLänge_x,1,SL1):-
	fehler(nein,schwarz),
	SL1 is 2,!.
config(wert_SprungLänge_x,1,SL1):-
	SL1 is 2.
config(wert_SprungLänge_x,2,SL2):-
	fehler(nein,schwarz),
	SL2 is 5,!.
config(wert_SprungLänge_x,2,SL2):-
	SL2 is 5.
config(wert_SprungLänge_x,3,SL3):-
	fehler(nein,schwarz),
	SL3 is 10,!.
config(wert_SprungLänge_x,3,SL3):-
	SL3 is 10.
config(wert_SprungLänge_x,4,SL4):-
	fehler(nein,schwarz),
	SL4 is 20,!.
config(wert_SprungLänge_x,4,SL4):-
	SL4 is 20.
config(wert_SprungLänge_x,_,SLX):-
	fehler(nein,schwarz),
	SLX is 40,!.
config(wert_SprungLänge_x,_,SLX):-
	SLX is 40.

:- dynamic ki/1.

