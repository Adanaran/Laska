% config.pl
% Autor: Dan S�rgel, Tim R�hrig, Malte Ahlering
%
% Stellt einstellbare Konfigurationswerte f�r die Bewertungsfunktion und
% die KI bereit.

%------------------------------------------------------------------------
% config(?key,?Value).
%  Gibt in Value die eingetragenen Werte von key wieder. Als key sind
%  folgende Werte zul�ssig:
%  - wert_bauer            : Wert eines einfachen Bauerns.
%  - wert_offizier	   : Wert eines Offizieres.
%  - wert_rand             : Wert eines Randfeldes.
%  - wert_doppelTurm       : Wert eines Turmes, dessen erster
%			     und zweiter Stein dem selben Spieler
%			     geh�ren.
%  - wert_zug              : Wert eines einfachen Zuges.
%  - wert_befreibarerT�rme : Wert eines Turmes, der befreit werden kann.
%  - wert_sieg             : Wert eines Siegbrettes.
%  - max_tiefe_KI          : Maximale Suchtiefe in Halbz�gen der KI

config(wert_bauer,1).
config(wert_offizier,3).
config(wert_rand,1).
config(wert_doppelTurm,2).
config(wert_zug,1).
config(wert_befreibarerT�rme,3).
config(wert_sieg,10000).
config(max_tiefe_ki,8).

% ------------------------------------------------------------------------
%  config(wert_SprungL�nge_x,?L�nge,?Wert).
%   Gibt den Wert eines Zuges von L�nge in Wert wieder.

config(wert_SprungL�nge_x,1,5):-!.
config(wert_SprungL�nge_x,2,10):-!.
config(wert_SprungL�nge_x,3,30):-!.
config(wert_SprungL�nge_x,4,60):-!.
config(wert_SprungL�nge_x,_,100).

% ------------------------------------------------------------------------
%  ki(?Farbe).
%   Gibt die Farbe der KI zur�ck.
:- dynamic ki/1.

