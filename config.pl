% config.pl
% Autor: Dan Sörgel, Tim Röhrig, Malte Ahlering
%
% Stellt einstellbare Konfigurationswerte für die Bewertungsfunktion und
% die KI bereit.

%------------------------------------------------------------------------
% config(?key,?Value).
%  Gibt in Value die eingetragenen Werte von key wieder. Als key sind
%  folgende Werte zulässig:
%  - wert_bauer            : Wert eines einfachen Bauerns.
%  - wert_offizier	   : Wert eines Offizieres.
%  - wert_rand             : Wert eines Randfeldes.
%  - wert_doppelTurm       : Wert eines Turmes, dessen erster
%			     und zweiter Stein dem selben Spieler
%			     gehören.
%  - wert_zug              : Wert eines einfachen Zuges.
%  - wert_befreibarerTürme : Wert eines Turmes, der befreit werden kann.
%  - wert_sieg             : Wert eines Siegbrettes.
%  - max_tiefe_KI          : Maximale Suchtiefe in Halbzügen der KI

config(wert_bauer,1).
config(wert_offizier,3).
config(wert_rand,1).
config(wert_doppelTurm,2).
config(wert_zug,1).
config(wert_befreibarerTürme,3).
config(wert_sieg,10000).
config(max_tiefe_ki,8).

% ------------------------------------------------------------------------
%  config(wert_SprungLänge_x,?Länge,?Wert).
%   Gibt den Wert eines Zuges von Länge in Wert wieder.

config(wert_SprungLänge_x,1,5):-!.
config(wert_SprungLänge_x,2,10):-!.
config(wert_SprungLänge_x,3,30):-!.
config(wert_SprungLänge_x,4,60):-!.
config(wert_SprungLänge_x,_,100).

% ------------------------------------------------------------------------
%  ki(?Farbe).
%   Gibt die Farbe der KI zurück.
:- dynamic ki/1.

