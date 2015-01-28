% Werte schwarz %%
config(wert_bauer,schwarz,3).
config(wert_offizier,schwarz,10).
config(wert_rand,schwarz,5).
config(wert_doppelTurm,schwarz,10).
config(wert_zug,schwarz,5).
config(wert_befreibarerT�rme,schwarz,1).
config(wert_sieg,schwarz,10000).

% Werte weiss %%
config(wert_bauer,weiss,1).
config(wert_offizier,weiss,1).
config(wert_rand,weiss,1).
config(wert_doppelTurm,weiss,1).
config(wert_zug,weiss,1).
config(wert_befreibarerT�rme,weiss,1).
config(wert_sieg,weiss,10000).


config(max_tiefe_ki,6).
config(max_tiefe_ab_ki,10).


%Config-Block f�r weiss %%

config(wert_bauer,BWert):-
	fehler(nein,schwarz),
	config(wert_bauer,weiss,BWert),!.
config(wert_offizier,OWert):-
	fehler(nein,schwarz),
	config(wert_offizier,weiss,OWert),!.
config(wert_rand,RWert):-
	fehler(nein,schwarz),
	config(wert_rand,weiss,RWert),!.
config(wert_doppelTurm,DTWert):-
	fehler(nein,schwarz),
	config(wert_doppelTurm,weiss,DTWert),!.
config(wert_zug,ZWert):-
	fehler(nein,schwarz),
	config(wert_zug,weiss,ZWert),!.
config(wert_befreibarerT�rme,BTWert):-
	fehler(nein,schwarz),
	config(wert_befreibarerT�rme,weiss,BTWert),!.
config(wert_sieg,WSieg):-
	fehler(nein,schwarz),
	config(wert_sieg,weiss,WSieg),!.

%% Config-Block f�r schwarz %%

config(wert_bauer,BWert):-
	config(wert_bauer,schwarz,BWert).
config(wert_offizier,OWert):-
	config(wert_offizier,schwarz,OWert).
config(wert_rand,RWert):-
	config(wert_rand,schwarz,RWert).
config(wert_doppelTurm,DTWert):-
	config(wert_doppelTurm,schwarz,DTWert).
config(wert_zug,ZWert):-
	config(wert_zug,schwarz,ZWert).
config(wert_befreibarerT�rme,BTWert):-
	config(wert_befreibarerT�rme,schwarz,BTWert).
config(wert_sieg,WSieg):-
	config(wert_sieg,schwarz,WSieg).

config(wert_SprungL�nge_x,1,SL1):-
	fehler(nein,schwarz),
	SL1 is 2,!.
config(wert_SprungL�nge_x,1,SL1):-
	SL1 is 2.
config(wert_SprungL�nge_x,2,SL2):-
	fehler(nein,schwarz),
	SL2 is 5,!.
config(wert_SprungL�nge_x,2,SL2):-
	SL2 is 5.
config(wert_SprungL�nge_x,3,SL3):-
	fehler(nein,schwarz),
	SL3 is 10,!.
config(wert_SprungL�nge_x,3,SL3):-
	SL3 is 10.
config(wert_SprungL�nge_x,4,SL4):-
	fehler(nein,schwarz),
	SL4 is 20,!.
config(wert_SprungL�nge_x,4,SL4):-
	SL4 is 20.
config(wert_SprungL�nge_x,_,SLX):-
	fehler(nein,schwarz),
	SLX is 40,!.
config(wert_SprungL�nge_x,_,SLX):-
	SLX is 40.

:- dynamic ki/1.

