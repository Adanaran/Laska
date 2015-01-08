% Problembeschreibung: Kanten zw. unmittelbarem Vorgänger- und Nachfolger-Knoten.
% n(A,B) drückt aus, dass Knoten B der unmittelbare Nachfolger von Knoten A nach
% Anwendung einer Regel ist.
% In einer realen Problemstellung werden diese Fakten durch die aufzustellenden
% Problem relevanten Regeln während der Durchführung der Suche (= Aufbau des
% expliziten Graphen) generiert.
n(a,b).
n(a,c).
n(a,d).
n(b,e).
n(b,f).
n(b,g).
n(d,h).
n(d,i).
n(f,j).
n(g,k).
n(g,l).
n(h,m).
% Knoten, die die Endebedingung erfüllen, werden explizit festgelegt.
ziel(h).
ziel(l).

% Für alle Suchverfahren, außer Minimax und Alpha-Beta, wird als Aufruf angenommen
%
% ?- verfahren(a,L).
%
% Dabei ist für 'verfahren' der jeweilige Prädikatname einzusetzen. 'a' ist der
% Wurzelknoten des oben definierten Suchbaumes, L der zu ermittelnde Lösungspfad.

% Tiefensuche (prinzipiell)
% Für einen gegebenen Knoten gibt es einen Lösungspfad, wenn
% der Knoten selbst die Endebedingung erfüllt, oder
% ein unmittelbarer Nachfolger des Knotens zum Lösungspfad gehört.
depth0(N,[N]) :-
	ziel(N).
depth0(N,[N|L]) :-
	n(N,N1),
	depth0(N1,L).

% Wenn Zyklen im Graphen auftreten (können),
n1(A,B) :- n(A,B).
n1(j,f).
% wird ein Mechanismus zur Zyklenerkennung benötigt.
depth1(N,L) :-
	depthfirst([],N,L).
depthfirst(P,N,[N|P]) :-
	ziel(N).
depthfirst(P,N,L) :-
	n1(N,N1),
	\+ member(N1,P),
	depthfirst([N|P],N1,L).

% Wenn infinite Zweige im Graphen auftreten (können),
% wird die maximale Suchtiefe begrenzt.
depth2(N,L) :-
	depthfirst_maxdepth(N,L,2).	% Beispiel: Begrenzung auf Suchtiefe 2
depthfirst_maxdepth(N,[N],_) :-
	ziel(N).
depthfirst_maxdepth(N,[N|S],M) :-
	M > 0,
	n(N,N1),
	M1 is M - 1,
	depthfirst_maxdepth(N1,S,M1).

% Probleme mit der Begrenzung der Suchtiefe:
% bei zu niedriger Suchtiefe wird keine Lösung ermittelt,
% bei zu hoher Begrenzung wird die Suche zu aufwendig.
% Ansatz: depth first iterative deepening (prinzipiell)
dfid(N,L) :-
	pfad(N,G,L),
	ziel(G).
pfad(N,N,[N]).
pfad(N0,Nn,[Nn|P]) :-
	pfad(N0,N,P),
	n1(N,Nn),
	\+ member(Nn,P).

% Breitensuche (prinzipiell)
% Alle potentiellen Lösungspfade werden in einem Schritt ermittelt.
% Ist der Kopf des ersten (nächsten) Lösungspfades (in umgedrehter Reihenfolge) ein Zielknoten,
% so ist der zugehörige Pfad eine Lösung.
% Anderenfalls wird der Pfad entfernt und alle unmittelbaren Nachfolger zu den Lösungskandidaten
% (entspricht der Menge 'open' des Pseudocode-Suchschemas 'graph-search') hinzugefügt.
breadth(N,L) :-
	breadthfirst([[N]],L).
breadthfirst([[N|P]|_],[N|P]) :-
	ziel(N).
breadthfirst([P|P1],L) :-
	extend(P,Pn),
	append(P1,Pn,P2),
	breadthfirst(P2,L).
extend([N|P],Pn) :-	% bagof ist ein Built-In Prädikat; ermittelt alle Nachfolger als Liste
	bagof([Nn,N|P],(n1(N,Nn),\+ member(Nn,[N|P])),Pn), !.
extend(_,[]).	% Blattknoten, d.h. keine Nachfolger

% Best-First-Search (prinzipiell, vereinfacht, bedingt lauffähig)
% mit dem A*-Algorithmus f(n) = g(n) + h(n)
% Erforderliche Problem spezifische Erweiterungen / Ergänzungen:
% Kanten sind mit Kosten belegt (g-Anteil), h(N,H) liefert heuristische Schätzung
% der Kosten vom Knoten N zu einem Zielknoten
n2(A,B,1) :- n1(A,B).	% Beispiel: Einheitskosten
h(a,2).
h(b,2).
h(c,3).
h(d,1).
h(e,2).
h(f,3).
h(g,1).
h(h,0).	% Schätzung, nicht deterministischer Wert
h(i,2).
h(j,4).
h(k,2).
h(l,0).	% Schätzung, nicht deterministischer Wert
h(m,1).
% Ein Knoten, der die Endebedingung erfüllt, beendet die Suche (deterministisch).
% Der Knoten mit den besten Gesamtkosten wird expandiert.
best(N,L) :-
	bestfirst([],N,L).
bestfirst(P,N,[N|P]) :-
	ziel(N).
bestfirst(P,N,L) :-
	findall([F,Nn],(n2(N,Nn,G),\+ member(Nn,P),h(Nn,H),F is G + H),Pn),
	msort(Pn,Ps),
	merge(P,Ps,[[Hf,Hn]|Pp]),
	bestfirst([[Hf,Hn]|Pp],Hn,L).

% Iterative-Deepening A* (prinzipiell, nicht direkt lauffähig)
% Ablauf wird gesteuert durch Verschieben einer Schranke (Kosten),
% Suche wird durchgeführt mit depth-first.
% Wie häufig in Prolog, verläuft "das Ganze" rückwärts, deshalb Initialisierung mit 99999.
idastern(S,L) :-	% S = Startknoten, L = Lösung
	retract(schranke(_)), fail
	;
	asserta(schranke(0)),
	idastern0(S,L).
idastern0(S,L) :-
	retract(schranke(Sch)),
	asserta(schranke(99999)),
	f(S,F),			% F = f(S) = f(n) = g(n) + h(n)
	df([S],F,Sch,L)		% depth-first
	;
	schranke(Sn),
	Sn < 99999,
	idastern0(S,L).
df([N|Ns],F,Sch,[N|Ns]) :-	% Suche mit depth-first bis zur Schranke Sch
	F =< Sch,
	ziel(N).
df([N|Ns],F,Sch,L) :-
	F =< Sch,
	n1(N,N1), \+ member(N1,Ns),
	f(N1,F1),
	df([N1,N|Ns],F1,Sch,L).
df(_,F,Sch,_) :-
	F > Sch,
	neue_schranke(F).

% Für die Algorithmen Minimax und Alpha-Beta wird von der bisherigen Aufrufkonvention
% abgewichen. Das jeweils erste Prädikat ist das Startprädikat, P = 'a' entspräche der
% vorherigen Auswahl, gesucht ist jedoch die beste Nachfolger-Position (ein Knoten, kein Pfad).

% Minimax-Algorithmus (prinzipiell, nicht direkt lauffähig)
minimax(P,B,V) :-	% P = (aktuelle) Position mit Minimax-Wert V, B = Position nach bestem Zug
	nn(P,L), !,	% L = Liste der unmittelbaren Nachfolger von P (aus legalen Zügen)
	best(L,B,V)	% Besten Nachfolger ermitteln
	;
	statBw(P,V).	% P ist Blattknoten mit statischer Bewertung V
best([P],P,V) :-
	minimax(P,_,V), !.
best([P1|L],Pm,Vm) :-
	minimax(P1,_,V1),
	best(L,P2,V2),
	besser(P1,V1,P2,V2,Pm,Vm).	% Pm ist von P1 und P2 die bessere Position mit Vm
				% Wg. der besseren Lesbarkeit der beiden Klauseln, werden die
				% "Singleton" Warnungen ([P1], [P0, V0]) nicht eliminiert
besser(P0,V0,P1,V1,P0,V0) :-	% P0 ist besser als P1
	min_am_zug(P0),		% in der Folgeposition ist MIN am Zug,
	V0 > V1, !		% aus Sicht des Vorgängers jedoch MAX ...
	;
	max_am_zug(P0),		% ... und umgekehrt
	V0 < V1, !.
besser(P0,V0,P1,V1,P1,V1).	% P1 ist besser als P0

% Alpha-Beta-Algorithmus (prinzipiell, nicht direkt lauffähig)
% Die beiden Werte A und B legen zwei Schranken fest, die
% den minimalen garantierten, und
% den höchsten, zu erhoffenden
% Gewinn in der jeweiligen Position angeben.
% Die Sichten der Spieler MIN und MAX sind stets gegensätzlich,
% deshalb vertauschen sich A und B bei Wechsel der Sicht.
% Auf Basis der Schranken kann die Suche vorzeitig abgebrochen werden,
% ohne das Gesamtergebnis zu verschlechtern.
alphabeta(P,A,B,G,V) :-	% G ist eine "gute" Position mit Wert V, der Schranken A und B erfüllt
	nn(P,L), !,	% Liste der Nachfolger-Positionen aus legalen Zügen
	beste(L,A,B,G,V)	% finde G aus L
	;
	statBw(P,V).	% statische Bewertung
beste([P|L],A,B,Pg,Vg) :-
	alphabeta(P,A,B,_,V),
	gutgenug(L,A,B,P,V,Pg,Vg).
gutgenug([],_,_,P,V,P,V) :- !.	% Knoten ist einziger Kandidat
gutgenug(_,A,B,P,V,P,V) :-
	min_am_zug(P), V > B, !
	;			% Bewertung erreicht einen der Grenzwerte
	max_am_zug(P), V < A, !.
gutgenug(L,A,B,P,V,Pg,Vg) :-
	neueAB(A,B,P,V,An,Bn),	% "verschiebe" A, B
	beste(L,An,Bn,P1,V1),
	besser(P,V,P1,V1,Pg,Vg).
neueAB(A,B,P,V,V,B) :-
	min_am_zug(P), V > A, !.
neueAB(A,B,P,V,A,V) :-
	max_am_zug(P), V < B, !.
neueAB(A,B,_,_,A,B).

% Quellen
% überwiegend sind die dargestellten Programme / Algorithmen entnommen aus:
% Bratko: Prolog programming for artificial intelligence, Addison-Wesley, 2001 (3rd ed.)
% ergänzende Angaben lieferten:
% Clocksin, Mellish: Programming in Prolog - Using the ISO Standard,
%   Springer, 2003 (5th edition)
% Kaindl: Problemlösen durch heuristische Suche in der Artificial Intellgence,
%   Springer, 1988
