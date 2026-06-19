# Deep Dive - Requirements

### Underwater View
- Gegner abzuschießen bringt Punkte

- Gegnern auszuweichen birgt keine Nachteile

- Das U-Boot hat zu beginn 3 HP (Leben)

- HP werden als Symbole (Herzen) auf dem Screen angezeigt

- Später im Spielverlauf gibt es die Möglichkeit, die maximale anzahl an hp permanent mit power-ups zu erhöhen

- Optional: Mini-Boss nach einer gewissen Zeit
- Optional: Special Gegner, der leuchtet und nur sehr schnell an dir Vorbeiziehen will. Beim Kill gibt es Punkte x10 
- Optional: Power-Ups spawnen zufällig (schneller schießen, temp mehr hp, unverwundbarkeit, etc. ) 

### Submarine View

- Die Linke Seite des Screens stell den Innenraum des U-Boots dar

- Im Innenraum gibt es die Möglichkeit, das U-Boot und die Fähigkeiten zu reparieren

- Die Fähigkeiten des U-Boots sind
	- Waffen (Torpedo)
	- Schild
	- Sonar
	- Motor (aufsteigen, abtauchen)
- Fähigkeiten können nur repariert werden, wenn sie auch kaputt sind

- HP des U-Boots können nur wiederhergestellt werden, wenn sie unter der maximalen Anzahl sind

- Es kann nur 1 HP pro Reparatur wiederhergestellt werden

- Periodisch fallen Fähigkeiten zufällig aus, was durch die Anzahl an HP beeinflusst wird (weniger HP -> mehr Ausfälle)

- Der Motor fällt zwar seltener aus, dafür ist die Reparatur dann top prio (Bewegungsunfähigkeit)

- Fähigkeiten fallen mit der Zeit häufiger aus

- Der Motor hat eine HP-Bar, die mit der Zeit abnimmt

- Ab < 50 % HP des Motors nimmt die Bewegungsgeschwindigkeit des U-Boots entsprechend der HP-Bar des Motors ab 

- Optional: Anwesenheit des Ingenieurs im Sektor der Fähigkeit gibt einen Boost für die Fähigkeit

- Optional: Zufällig (5% Chance), das U-Boot ein Leck hat, was repariert werden muss

### Extras

- Das U-Boot hat pro Sekunde eine 0.0000(...)01% Chance instant kaputt zu gehen
- Optional: Es gibt Pfützen im Innenraum, durch die man durchlaufen kann



