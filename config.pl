config(wert_bauer,1).
config(wert_offizier,3).
config(wert_rand,1).
config(wert_doppelTurm,2).
config(wert_zug,1).
config(wert_befreibarerTürme,3).
config(wert_sieg,10000).
config(max_tiefe_ki,8).

config(wert_SprungLänge_x,1,5):-!.
config(wert_SprungLänge_x,2,10):-!.
config(wert_SprungLänge_x,3,30):-!.
config(wert_SprungLänge_x,4,60):-!.
config(wert_SprungLänge_x,_,100).

:- dynamic ki/1.

