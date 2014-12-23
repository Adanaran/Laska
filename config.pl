config(wert_bauer,1).
config(wert_offizier,3).
config(wert_rand,1).
config(wert_doppelTurm,1).
%config(strafe_gegnerZüge,2).

config(wert_ZugLänge_x,1,1):-!.
config(wert_ZugLänge_x,2,3):-!.
config(wert_ZugLänge_x,3,6):-!.
config(wert_ZugLänge_x,4,9):-!.
config(wert_ZugLänge_x,_,10).

