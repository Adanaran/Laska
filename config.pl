config(wert_bauer,1).
config(wert_offizier,3).
config(wert_rand,1).
config(wert_doppelTurm,1).
config(wert_zug,1).
config(wert_befreibarerT�rme,1).
config(wert_sieg,10000).
config(max_tiefe_ki,2).

config(wert_SprungL�nge_x,1,2):-!.
config(wert_SprungL�nge_x,2,5):-!.
config(wert_SprungL�nge_x,3,10):-!.
config(wert_SprungL�nge_x,4,20):-!.
config(wert_SprungL�nge_x,_,40).

:- dynamic ki/1.

