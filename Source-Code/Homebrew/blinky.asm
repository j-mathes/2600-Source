; asmsyntax=asmM6502

; *************************************************************
; **                                                         **
; **   Copyright © Jan Hermanns 2013 All Rights Reserved.    **
; **                                                         **
; **   COMMERCIAL USE OF THIS FILE IS NOT ALLOWED WITHOUT    **
; **   EXPRESS AND PRIOR WRITTEN CONSENT OF THE AUTHOR.      **
; **                                                         **
; *************************************************************

;{{{
; You need a working installation of DASM in order to compile this file.
;
; To compile the NTSC version you need to do this:
;   dasm blinky.asm -f3 -oBlinky_NTSC.bin -DNTSC=1 -I<path_to_include_files>
; 
; To compile the PAL version:
;   dasm blinky.asm -f3 -oBlinky_PAL.bin -I<path_to_include_files>
;
; The -I option specifies where "vcs.h" and "macro.h" are located on your
; computer. You can omit the -I option, if you copy both files in the same
; directory as "blinky.asm".
;
; Example: To compile the NTSC Version on my computer I need to do this:
;
;   dasm blinky.asm -f3 -oBlinky_NTSC.bin -DNTSC=1 -I/home/hermanns/dasm/
;}}}

;{{{
; TODOs
; + Namen der Bad-Guys: Tooby, Bolly, Shooty. Name des Spielers Blinky
; - Springen "entprellen"
; - Darstellung der Leben sieht kommisch aus, beim Wechsel von 5 zu 4 Leben
; + Probleme mit Kollisionsabfrage oben reproduzieren (moeglicherweise
;   wenn Level gerade gescrollt wird)
; + Goldstuecke zaehlen
; + Farben fuer Titelscreen, Next Level, und Endscreen konstant weiss machen
; + Farbe fuer LEVEL5
; + Platz schaffen, fuer LEVEL-Tabelle
; + Startposition von LEVEL3 veraendern
; + Sound der Gegner disablen, wenn sie nicht mehr sichtbar sind
; + Perfect nur anzeigen bei perfektem Spiel
; + Es gibt immer noch ein Problem beim Aufprallen des Balls, wenn der
;   Level gerade gescrollt wird (das lag an der Normalisierung der Y-Koordinate)
; + Screenflash bei Extraleben 
; + Sound-FX fuer Level-Ende (oder zumindest alle Sounds abstellen)
; + Warteanimation verfeinern (Blinky sollte mit dem Fuss tippen)
; + Codierung der Leveldaten kann effizienter gestaltet werden (z.B.
;   X/Y-Startposition des Spielers in einem statt zwei Bytes) => WONTFIX -
;   lohnt sich nicht
; + Sound-FX fuer Schuss (Laser-Sound)
; + Diamant (WONTFIX - zu wenig Platz!)
; + Variable fuer gravitation einsparen
; + PAL-Version
; + Sound-FX bei Verlust eines Lebens
; + INITxSND Routinen refactoren
; + Dokumentieren, wie man das Problem nachstellen kann, dass zuviele 
;   Scanlines verbraucht werden. Danach mit aelterer Version testen, um zu
;   schauen, ob es am Sound liegt.
; + Hintergrundfarbe immer schwarz (d.h. diese Farbinformation aus den
;   Level-Daten entfernen)
; + LOV3MACHINE Sprites entfernen
; + Der Ball "verspringt" manchmal
; + Springen auch mit Feuerknopf
; + Naechster Level laden
; + Manchaml wird das Gold fuer kurze Zeit falsch (oben) angezeigt
; + Gold einsammeln (Lebensanzeige umfaerben, ggf. Leben addieren)
; + Schwarzer Hintergrund fuer Lebensanzeige
; + Titelscreen
; + Langsamer sterben
; + Lebensanzeige
; + Man scheint immer direkt zweimal hintereinander zu sterben
; + Warum werden manchmal zuviele Scanlines verbraucht (breakif { _scan > $105 })
; + Enemy-Sprite soll nicht so "tief" im Playfield versinken
; + Exit soll pulsieren
; + Ball verschwindet manchmal
; + Beim Scrollen werden 286 Scanlines verbraucht
; + "Doppel" Ball
; + "Doppel" Schlauch
; + Kollisionsabfrage fuer "Doppel-Schlauch"
; + Level Exit mittels Ball-Sprite 
; + Gold zentrieren 
; + Schuss zentrieren
; + Kollisionsabfragebug "Schlauch-Umkehr"
;}}}

   IFCONST NTSC
         echo "---------- NTSC Version ------------------------------"
   ELSE
         echo "---------- PAL Version -------------------------------"
   ENDIF

; --------------------------------------------------------------------------- 
   processor 6502

   include "vcs.h"
   include "macro.h"

;{{{
; ----- G L O S S A R -------------------------------------------------------
;
; Level-Daten: Damit sind saemtliche Daten eines Levels gemeint. 
;   Die Level-Daten enthalten also neben den Positionen der Gegner/Objekt 
;   auch die Spielfeld-Daten und die Farbinformationen. Wie die
;   Level-Daten im Detail aufgebaut sind ist im Kommentar der NEWLEVEL
;   Subroutine genau beschrieben.
;
; Spielfeld-Daten: Damit sind (in Abgrenzung zu den Level-Daten) nur
;   die Daten gemeint die noetig sind, um das Spielfeld anzuzeigen
;   (technisch gesehen sind das also die Daten mit denen die logischen
;   Spielfeld-Register beladen werden).
;
; Blockreihe: Ein Spielfeld ist aus Blockreihen aufgebaut. Eine
;   Blockreihe besteht aus 16 Bloecken, die beliebig an-/ausgeschaltet
;   sein koennen. D.h. jede Blockreihe eines Spielfelds kann durch 2 Bytes
;   definiert werden. Auf dem Bildschirm wird immer ein Ausschnitt von 11
;   Blockreihen eines Spielfelds dargestellt, der dann nach Bedarf nach
;   unten gescrollt wird, bis das Ende eines Spielfelds erreicht ist.
;}}}

;{{{
; ----- C o n s t a n t s ------------------------------------------------------

ENDSCREEN            = $FB00
TITLE_PAGE_1         = $FC00
TITLE_PAGE_2         = $FD00
SPRITE_PAGE          = $FE00
PFDATA               = $FF00
RNDSEED              = $15
DISABLED             = $FF
   IFCONST NTSC
HERO_ACCEL_X         = 8
HERO_ACCEL_Y_LSB     = 120
HERO_ACCEL_Y_MSB     = 2
BALL_ACCEL_Y_LSB     = 200 
BALL_ACCEL_Y_MSB     = 2 
TUBE_ANIM_SPEED      = 3
ANIM_SPEED           = 4
BALL_ANIM_SPEED      = 4
GRAVITY_CONST_FALL   = $B0 ; Gravitation beim Fallen
GRAVITY_CONST_RISE   = $E6 ; Gravitation des Balls beim Aufsteigen
VERT_BLANK_TIM64T    = 43
LIFEBAR_TIM64T       = 19
TEXT_OFFSET_TIM64T   = 229 ;(192*76) / 64 == 228
OVRSCBEG_TIM64T      = 35  ;(30*76) / 64 == 35 
TITLSCRN_TIM64T      = 50
TITLSCRN_COLOR       = $24
LEVELEND_TIM64T      = 70
ENDSCRN_TIM64T       = 60
   ELSE
HERO_ACCEL_X         = 9
HERO_ACCEL_Y_LSB     = 120
HERO_ACCEL_Y_MSB     = 2
BALL_ACCEL_Y_LSB     = 220
BALL_ACCEL_Y_MSB     = 2
TUBE_ANIM_SPEED      = 2
ANIM_SPEED           = 3
BALL_ANIM_SPEED      = 3
GRAVITY_CONST_FALL   = $8C ; Gravitation beim Fallen
GRAVITY_CONST_RISE   = $E4 ; Gravitation des Balls beim Aufsteigen
VERT_BLANK_TIM64T    = 53
LIFEBAR_TIM64T       = 40
TEXT_OFFSET_TIM64T   = 255 ; (228*76) / 64 == 271 > 255
OVRSCBEG_TIM64T      = 42  ; (36*76) / 64 == 42
TITLSCRN_TIM64T      = 47
TITLSCRN_COLOR       = $44
LEVELEND_TIM64T      = 70
ENDSCRN_TIM64T       = 60
   ENDIF
DEATH_ANIM_SPEED     = 3
BLINKING_SPEED       = 6      ; Blinzel-Geschindigkeit
FOOTIP_SPEED         = 10

TRAP_SPEED           = 2      

SPRITE_HEIGHT        = 8
GRAVITY_CONST_JUMP   = %11110000 ; Gravitation beim Springen
VERT_BLK_RES         = 11      ; Anzahl der Baender (d.h. der Blockreihen)
BLK_HEIGHT           = 16     ; Hoehe eines Bandes in Anzahl Scanlines 
SCROLL_SPEED         = 3                ; Higher = Slower (Min=1)
NEW_GAME             = %00000100
NEW_GAME_STARTED     = %11111011
X_MOT_STOP_THR       = $31    ; Schwellwert fuer schnelles Abbremsen
PFREGS               = 12
THREE_COPIES_CLOSE   = %00000011   
MAXLIVES             = 6

MAXGOLD              = 17
LASTLEVEL            = 5   ; Levels fangen bei 0 an

; Das lost-a-life Flag zeigt an, dass der Spieler waehrend des Spiels
; mindestens schon ein Leben verloren hat. Wir benoetigen diese Information im
; Endscreen, um ggf. das Perfect (alle Goldstuecke wurden eingesammelt und kein
; Leben verloren) anzuzeigen.
LOST_A_LIFE          = %10000000

; Hiermit kann das Bit der Variable flag freigestellt werden, das
; anzeigt ob das Spielfeld gerade gescrollt wird.
;
SCROLL_FLAG_MASK     = %00001000 
DISABLE_SCROLL_FLAG  = %11110111

DEATH_FLAG_MASK      = %01000000
DISABLE_DEATH_FLAG   = %10111111

LVLEND_FLAG_MASK     = %00000010
DISABLE_LVLEND_FLAG  = %11111101

BALLSIZ_FLAG_MASK    = %00110000
DISABLE_BALLSIZ_FALG = %11001111
MAX_BALLSIZE         = %00110000
BALLSIZE_INCREMENT   = %00010000

; 
; Raender fuer Spielfeldbegrenzungen
;
LEFT_MARGIN    = 1  ;16
RIGHT_MARGIN   = 149;83;149  ; (160 / 2) + (SPRITE_WIDTH / 2) = 84

;
; Der Trick ist hier, dass der Zustand mit dem Offset des Hero-Sprites 
; in der SPRITE_PAGE uebereinstimmt.
; Auch die Anordnung der Sprites (und damit die Ordnung der folgenden
; Konstanten) machen wir uns zu Nutze (in der Abfrage der vertikalen
; Joystick-Position.
; 
HERO_WAITING         = %11100000
HERO_FALLING         = %00010000
HERO_WALKING         = %00001110
HERO_JUMPING         = %00000001

; Die folgende Konstante zeigt auf das letzte Sprite der "Gehen"-Animation
BEGIN_WALKING_ANIM   = %00000010
END_WALKING_ANIM     = %00001000

BEGIN_WAITING_ANIM   = %00100000
BLINK_WAITING_ANIM   = %01000000


; Mit dieser Konstante koennen die Bits, des enemyState freigestellt werden,
; die Auskunft darueber geben, welcher Enemy dargestellt werden soll.
ENEMY_TYPE_MASK      = %11100000

; Mit dieser Konstante koennen die Bits, des enemyState freigestellt werden,
; die Auskunft ueber die aktuelle Animationsphase des Enemys geben.
ENEMY_ANIM_MASK      = %00000111

; Durch ver-unden des enemyState mit dieser Konstante, wird die Animation 
; zurueckgesetzt.
ENEMY_CLEAR_ANIM     = %11111000

; Mit dieser Konstante kann das Bit des enemyState freigestellt werden,
; das Auskunft darueber gibt, in welche horizontale Richtung sich der Enemy 
; bewegt.
ENEMY_H_DIR_MASK     = %00001000

ENEMY_TUBE           = %01100000    ; Schlauch
ENEMY_BALL           = %00100000    ; Ball
NO_ENEMY             = %00000000    ; kein Gegner aktiv

; Mit dieser Konstante kann das Bit des enemyState freigestellt werden,
; das Auskunft darueber gibt, ob der Ball gerade am ""auftitschen" ist (d.h. ob
; gerade die Animation laeuft).
ENEMY_V_DIR_MASK  = %00010000

; Der Tube hat zwar nur 7 Animationsphasen, aber wir zaehlen dessen Phasen
; beginnend bei 1.
TUBE_BEGIN_ANIM      = %00000001
TUBE_END_ANIM        = %00000111

; Der Ball hat nur 3 Animationsphasen, wir zaehlen beginnend bei 1
BALL_BEGIN_ANIM      = %00000001
BALL_END_ANIM        = %00000100


ENEMY_DIR_LEFT       = %00001000
ENEMY_DIR_RIGHT      = %00000000
BALL_IS_BOUNCING     = %11101111
ENEMY_FALLING        = %00010000

SWCHA_P0_UP         = %00010000
ENABLE_SWCHA_P0_UP  = %11101111
SWCHA_P0_NO_MOVE    = %11110000

;
; Die folgenden Konstanten geben an, welche Art von Objekt/Gegner von der 
; Routine NEXTENEM positioniert werden muss.
;
BALL_1   = ENEMY_BALL
BALL_2   = %01000000
TUBE_1   = ENEMY_TUBE
TUBE_2   = %10000000
TRAP     = %10100000
GOLD     = %11000000
DOOR     = %11100000

;
; Konstanten fuer Audio-Ausgabe
;
SND0_MASK      = %00001111 ; Wert durch VerANDen freistellen
SND1_MASK      = %11110000 ; Wert durch VerANDen freistellen

CLEAR_SND0     = %11110000 ; Wert durch VerANDen loeschen
CLEAR_SND1     = %00001111 ; Wert durch VerANDen loeschen

BALL_SOUND   = %00000001 ; Wert duch VerORen setzen
TUBE_SOUND   = %00000010 ; Wert duch VerORen setzen
GOLD_SOUND   = %00010000 ; Wert duch VerORen setzen
EXTRA_SOUND  = %00100000 ; Wert duch VerORen setzen
LASER_SOUND  = %01000000 ; Wert duch VerORen setzen
;}}}

;{{{
; ----- V a r i a b l e s ------------------------------------------------------

	SEG.U VARS 
	ORG $80

pf1l     ds PFREGS
pf2l     ds PFREGS 
pf0r     ds PFREGS 
pf1r     ds PFREGS 
pf2r     ds PFREGS 
scroll   ds 1

; Der levelptr zeigt auf die Spielfeld-Daten und muesste daher
; korrekterweise besser pfptr heissen.
;
levelptr          ds 2

; Der levelptroff wird jedesmal gesetzt, wenn neue Level-Daten geladen
; werden. Er gibt an, wie weit die Spielfeld-Daten des Levels vom Anfang
; der Speicherseite (auf der sich die Spielfeld-Daten befinden) entfernt
; sind. Damit kann man dann relativ einfach die aktuelle Level-Position
; ausrechnen, indem den levelptroff vom LSB des levelptr subtrahiert
; (das ist natuerlich vereinfacht ausgedrueckt, weil hier noch nicht
; beachtet wird, dass jede Blockreihe eines Levels durch zwei Bytes
; definiert wird).
;
levelptroff       ds 1

heroState         ds 1  
heroX             ds 2  
heroY             ds 2  
enemyX            ds 2  
enemyY            ds 2  
heroSpeedX        ds 2  
heroSpeedY        ds 2  
enemySpeedY       ds 2

; D5-D7: Geben Auskunft darueber, welcher Enemy dargestellt werden soll.
; D0-D2: Enthaelt die Animationsphase
;
enemyState        ds 1  

enemyposptr       ds 2
goldcoord         ds 2     ; X/Y Koordinate fuer Goldstuecke
trapcoord         ds 2     ; X/Y Koordinate fuer Schuesse
doorcoord         ds 2     ; X/Y Koordinate fuer Levelausgaenge
exitAnimTimer     ds 1
heroAnimTimer     ds 1  
enemyAnimTimer    ds 1  

; Bit D0 (Trap-Flag) wird verwendet, als Richtungsindikator fuer die Trap
; Bit D1 (Levelend-Flag) zeigt an, ob der Spieler gerade ein Level beendet hat
; Bit D2 zeigt an, dass ein neues Spiel gestartet wurde
; Bit D3 zeigt an, ob das Spielfeld gerade gescrollt wird
; Bits D4,D5 (Ballsize-Flag) werden als Ball-Size verwendet (um den Exit
; zu animieren).
; Bit D6 (Death-Flag) zeigt an, ob der Spieler gerade ein Leben verloren hat
flag              ds 1

; Die folgenden Variablen duerfen waehrend eines Spiels (d.h. wenn ein
; neuer Level geladen wird oder der Spieler ein Leben verloren hat)
; *nicht* geloescht werden.
;
PERSIST
level             ds 1        ; D0-D3 zeigt, welcher Level gerade gespielt wird
lives             ds 1
; D7    wird als Lost-a-Life Flag verwendet
; D0-D6 werden als Zaehler fuer die eingesammelten Goldstueck verwendet
goldcnt           ds 1        
rnd               ds 1        ; Koennte man auch wiederherstellen...

; Damit waehrend des Spiel-Kernals die SPRITE6 Routine verwendet werden
; kann, muessen die folgenden Register (waehrend der Ausfuehrung von
; SPRITE6) zwischengespeichert werden:
;
;     REFP0  (1 Bit) 
;     REFP1  (1 Bit) 
;     NUSIZ1 (5 Bit) 
;     COLUP0 (7 Bit) 
;     COLUP1 (7 Bit)
;
; Das NUSIZ0 Register muss uebrigens nichts zwischengespeichert werden,
; da es waehrend des Spiels immer einen Konstanten Wert von %00010000
; hat (da der Spieler immer "normal" dargestellt wird und das Gold
; immer 2 clocks breit ist).
;
NUSIZ1_COPY          ds 1
COLUP0_REFP0_COPY    ds 1        ; D0: REFP0, D1-D7: COLUP0
COLUP1_REFP1_COPY    ds 1        ; D0: REFP1, D1-D7: COLUP1

; Die folgenden Variablen werden nur temporaer bei der Benutzung der
; SPRITE6 Routine benoetigt.
;
sprite6_ptr1        ds 2
sprite6_ptr2        ds 2
sprite6_ptr3        ds 2
sprite6_ptr4        ds 2
sprite6_ptr5        ds 2
sprite6_ptr6        ds 2
sprite6_height      ds 1
sprite6_color       ds 1
temp                ds 2  
   
; Die folgenden Variablen werden fuer die Erzeugung der Audiosignale
; benoetigt.
;
freq0    ds 1  ; Aktuelle Frequenz fuer Audiokanal 0
vol0     ds 1  ; Aktuelle Lautstaerke von Audiokanal 0
freq1    ds 1  ; Aktuelle Frequenz fuer Audiokanal 1
vol1     ds 1  ; Aktuelle Lautstaerke von Audiokanal 1
sounds   ds 1  ; D0-D3 Sound fuer Audiokanal 0 
               ; D4-D7 Sound fuer Audiokanal 1

free1    ds 1  ; Hier ist noch ein freies Byte
free2    ds 1  ; Hier ist noch ein freies Byte

   ; Die 6 Bytes freies RAM koennen nicht genutzt werden, da sie als
   ; Stack verwendet werden.
   ;
	echo ($100 - *) , "bytes of RAM left. Stack needs 6 Bytes."
;}}}

;{{{
; ----- A l i a s e s ----------------------------------------------------------

; In dieser Variable wird kurzfristig der Zustand des Joysticks
; zwischengespeichert.
joystick          = sprite6_ptr1

; Die Spielfeld-Farbe waehrend der "Sterben" Animation.
death             = enemyAnimTimer

; Der Timer fuer die Animation beim Verlust eines Lebens kann sich nicht
; mit dem exitAnimTimer ins Gehege kommen
;
deathAnimTimer    = exitAnimTimer

; Der Timer fuer die Darstellung des "NEXT LEVEL" Text kann sich nicht
; mit dem exitAnimTimer ins Gehege kommen
;
levelendAnimTimer = exitAnimTimer

; Der Timer fuer zum Entprellen des Feuerknopfs nach der Darstellung des
; End-Screens kann sich nicht mit dem exitAnimTimer ins Gehege kommen
;
fireDebounceTimer = exitAnimTimer

; Die folgenden beiden Pointer werden pro Frame immer neu gesetzt und
; nur im Hauptkernal verwendet und koennen sich daher nicht mit den
; sprite6_ptr Variablen ins Gehege kommne.
;
enemySpritePtr    = sprite6_ptr1
heroSpritePtr     = sprite6_ptr2

; Die Variablen pos1..pos4 werden nur temporaere beim Laden einer neuen
; Blockreihe verwendet und koennen sich daher mit den sprite6_ptr
; Variablen nicht ins Gehege kommen.
;
pos1              = sprite6_ptr1
pos2              = sprite6_ptr1 + 1
pos3              = sprite6_ptr2
pos4              = sprite6_ptr2 + 1

goldX             =  goldcoord
goldY             =  goldcoord + 1
trapX             =  trapcoord
trapY             =  trapcoord + 1
doorX             =  doorcoord
doorY             =  doorcoord + 1

xHeroLSB          =  heroX          ; Subpixelposition
xHeroMSB          =  heroX + 1      ; Pixelposition
yHeroLSB          =  heroY          ; Subpixelposition
yHeroMSB          =  heroY + 1      ; Pixelposition


xEnemyLSB         =  enemyX         ; Subpixelposition
xEnemyMSB         =  enemyX + 1     ; Pixelposition
yEnemyLSB         =  enemyY         ; Subpixelposition
yEnemyMSB         =  enemyY + 1     ; Pixelposition

xSpeedLSB         =  heroSpeedX      
xSpeedMSB         =  heroSpeedX + 1
ySpeedLSB         =  heroSpeedY
ySpeedMSB         =  heroSpeedY + 1

; Waehrend der Warte-Animation werden die Variablen fuer die horizontale
; Geschwindigkeit als Timer benutzt.
;
bored             =  xSpeedMSB
footimer          =  xSpeedLSB

blinktimer        =  heroAnimTimer

yEnemySpeedLSB    =  enemySpeedY
yEnemySpeedMSB    =  enemySpeedY + 1

tempLSB           =  temp
tempMSB           =  temp + 1
temp1             =  tempLSB
temp2             =  tempMSB
blockHeightCnt    =  temp + 1
;}}}

         SEG
         ORG $F000
   
RESET    CLEAN_START

         LDA   #RNDSEED
         STA   rnd

         JSR   VSYN_VBL
         JMP   TITLSCRN

;{{{
; MOVSPRIT - Horizontale Spritepositionierung
;
; Die folgende Routine positioniert das, im X-Register uebergebene Sprite
; horizontal, an die im Aku angegebene X-Position.
;
; ACHTUNG: Da diese Routine im Timing sehr kritisch ist, muss dafuer
; gesorgt sein, dass sie vollstaendig auf nur einer Speicherseite
; untergebracht ist.
;
MOVSPRIT SUBROUTINE
         CLC
         ADC   #4
         CMP   #$A0
         BCC   .skipwrp
         SBC   #$A0
.skipwrp EOR   #$FF           ;2 0-159 is now 255-96 
         CLC                  ;2
         STA   WSYNC          ;3 begin line 1 
.divloop ADC   #15            ;2
         BCC   .divloop       ;54 max 
         SBC   #7             ;2 
         ASL                  ;2 
         ASL                  ;2 
         ASL                  ;2 
         ASL                  ;2 -Shift left 4 places 
         STA   HMP0,X         ;4     68 
         STA   RESP0,X        ;4     72 
         STA   WSYNC          ;3
         RTS                  ;6
;}}}

;{{{
; SPRITE6 - Diese Routine dient dazu 6 verschiedene Sprites
; nebeneinander darzustellen. Sie ist dazu gedacht innerhalb eines
; Kernals aufgerufen zu werden. 
;
; Dazu muessen vor dem Aufruf allerdings die Variablen
; sprite6_ptr1...sprite6_ptr6 mit den Adressen der darzustellenden Sprites
; beladen werden und die Variable sprite6_height gesetzt werden (das
; impliziert natuerlich, dass alle 6 Sprites die gleiche Hoehe haben).
;
; ACHTUNG: Da diese Routine im Timing sehr kritisch ist, muss dafuer
; gesorgt sein, dass sie vollstaendig auf nur einer Speicherseite
; untergebracht ist.
;
SPRITE6  subroutine
         LDA   sprite6_color        ; Farbe der 6 Sprites setzen
         STA   COLUP0
         STA   COLUP1

         LDA   #THREE_COPIES_CLOSE  ; 
         STA   NUSIZ0
         STA   NUSIZ1

         LDA   #0                   ; Alle relevanten Sprite-Register
         STA   GRP0                 ; zuruecksetzen...
         STA   GRP1
         STA   GRP0
         STA   REFP0
         STA   REFP1
         STA   HMP1

         STA   WSYNC                ; Jetzt geht's los, Timing ist gefragt ;-)
         PHA                        ; 3 Prozessorzyklen verbraten...
         PLA                        ; 4 Prozessorzyklen verbraten...
         LDA   #1                   
         STA   VDELP0               
         STA   VDELP1               
         LDX   #4                   
.waste   DEX                        
         BNE   .waste               
         STA   RESP0                
         STA   RESP1                
         LDA   #$F0                 
         STA   HMP0                 
         STA   WSYNC                
         STA   HMOVE                  
         DEC   sprite6_height              
.loop    LDY   sprite6_height              
         LDA   (sprite6_ptr1),y       
         STA   GRP0                   
         STA   WSYNC
         LDA   (sprite6_ptr2),y     
         STA   GRP1                   
         LDA   (sprite6_ptr3),y     
         STA   GRP0                   
         LDA   (sprite6_ptr4),y     
         STA   temp         
         LDA   (sprite6_ptr5),y     
         TAX                        
         LDA   (sprite6_ptr6),y    
         TAY                        
         LDA   temp         
         STA   GRP1                   
         STX   GRP0                   
         STY   GRP1                   
         STA   GRP0                   
         DEC   sprite6_height              
         BPL   .loop              

         LDA   NUSIZ1_COPY          ; Jetzt alle relevanten Sprite-Register 
         STA   NUSIZ1               ; wiederherstellen...
         LDA   COLUP0_REFP0_COPY
         STA   COLUP0
         ASL
         ASL
         ASL
         STA   REFP0
         LDA   COLUP1_REFP1_COPY
         STA   COLUP1
         ASL
         ASL
         ASL
         STA   REFP1

         LDA   #0                     
         STA   GRP0
         STA   GRP1
         STA   GRP0
         RTS
;}}}

;{{{
; OVRSVBL - Leitet den Overscan ein und wartet diesen ab. Danach wird der
; Vertical-Sync ausgefuehrt und der Timer fuer den Vertical-Blank gesetzt.
OVRSVBL subroutine
         JSR   OVRSCBEG       ; Overscan einleiten
         JSR   OVRSCEND       ; und abwarten...
         JSR   VSYN_VBL
         RTS
;}}}

;{{{
; VSYN_VBL - Fuehrt zunaechst einen Vertical-Sync aus und setzt dann den Timer
; fuer den Vertical-Blank.
VSYN_VBL subroutine
         VERTICAL_SYNC
         LDA   #VERT_BLANK_TIM64T   ; Timer fuer Vertical-Blank
         STA   TIM64T               ; setzen.
         RTS
;}}}

GAMELOOP 

         JSR   VSYN_VBL
         
;{{{
; NEWGAME - Ggf. wird ein neues Spiel initialisiert
;
NEWGAME  subroutine
         LDA   flag              ; Flag laden und pruefen, ob ein
         AND   #NEW_GAME         ; neues Spiel gestartet werden soll?
         BEQ   .resume           ; Nein, altes Spiel fortsetzen...
         LDA   flag              ; Ja, daher Flag umbiegen
         AND   #NEW_GAME_STARTED
         STA   flag
         LDA   #3                ; Spieler beginnt mit 3 Leben.
         STA   lives
         LDA   #0                
         STA   goldcnt           ; Gold-Counter auf null setzen
         STA   level             ; 1.Level laden
         JMP   NEWLEVEL
.resume
;}}}

;{{{
; VISIBLE - Befinden sich die Trap, Gold, Door und Gegner noch im
; sichtbaren Bereich oder muessen sie disabled werden?
;
; Der sichtbare Bereich sind die 176 Scanlines (BLK_HEIGHT *
; VERT_BLK_RES) oberhalb der Lebensanzeige (die Y-Koordinate 176
; befindet sich uebrigens am oberen Bildschirmrand, weil der Kernal
; runterzaehlt).
;
; Ob ein Objekt/Gegener vom Kernal angezeigt wird oder nicht, haengt
; lediglich von seiner Y-Koordinate ab (liegt diese im Intervall
; [0..176], dann zeigt der Kernal es an). D.h. die einzige Moeglichkeit
; ein Objekt/Gegner auszuschalten liegt darin dafuer zu sorgen, dass
; seine Y-Koordinate groesser als 176 ist.
;
; Als oberen Schwellwert benutzen wir allerdings nicht 176, sondern 190
; und zwar weil es vorkommen kann, dass ein Ball ganz oben am Bildschirm
; dargestellt wird und nach dem Aufprellen dann (fuer kurze Zeit) eine
; Y-Koordinate erreichen kann, die ausserhalb des sichtbaren Bereichs
; liegt. Wuerden wir in diesem Fall 176 als Grenze ansetzen, wuerde der
; Ball nur einmal aufprellen und dann disabled werden.
;
; Auch die Y-Koordinaten von "ausgeschalteten" Objekten/Gegnern werden
; von der SCRLDOWN Routine stur dekrementiert. Wir muessen also
; auch dafuer sorgen, dass die Y-Koordinaten von "ausgeschalteten"
; Objekten/Gegnern nicht soweit dekrementiert werden, dass sie in den
; sichtbaren Bereich gelangen und dann faelschlicherweise angezeigt
; werden (aus diesem Grund setzen wir die Y-Koordinate "ausgeschalteten"
; Objekten/Gegnern immer auf $FF).
;
; Fuer den unteren Schwellwert nehmen wir uebrigens 4 anstatt 0, da es
; andernfalls zu Darstellungsproblemen bei Lebensanzeige kommt.
;
VISIBLE  subroutine
         LDA   #4
         LDX   #190        
         LDY   #DISABLED
         CMP   trapY
         BCC   .chktra2       ; Branch if (4 < trapY)
         STY   trapY
.chktra2 CPX   trapY
         BCS   .chkgold       ; Branch if (177 >= trapY)
         STY   trapY 
.chkgold CMP   goldY
         BCC   .chkgol2
         STY   goldY
.chkgol2 CPX   goldY
         BCS   .chkdoor
         STY   goldY
.chkdoor CMP   doorY
         BCC   .chkdoo2
         STY   doorY
.chkdoo2 CPX   doorY
         BCS   .chkenem
         STY   doorY
.chkenem CMP   yEnemyMSB
         BCC   .chkene2
         STY   yEnemyMSB
.chkene2 CPX   yEnemyMSB
         BCS   .endchk
         STY   yEnemyMSB
         INY                        ; Y := 0
         STY   yEnemySpeedMSB       
         STY   yEnemySpeedLSB
         STY   enemyState
.endchk
;}}}

;{{{
; VITALCHK - Prueft, ob der Spieler gestorben ist.
; Wenn das der Fall ist, dann Blenden wir den Spielfeld langsam aus.
; freq
VITALCHK subroutine
         BIT   flag                 ; Death-Flag laden und freistellen.
         BVC   .vital               ; Ist der Spieler gestorben?
         DEC   deathAnimTimer       ; Ja, naechster Farbwechsel faellig?
         BNE   .contdie             ; Nein, also Routine beenden.
         LDX   #DEATH_ANIM_SPEED    ; Ja, also erstmal Timer 
         STX   deathAnimTimer       ; resetten dann Sound-FX 
         LDX   freq1                ; Frequenz fuer Audiokanal 1 laden
         INX                        ; Jetzt wird der Frequenz-Wert 
         INX                        ; erhoeht, dadurch wird eine tiefere
         STX   freq1                ; Frequenz gewaehlt 
         STX   AUDF1                ; und abgespielt.
         LDA   death                ; Farbe des Spielfelds
         STA   COLUPF               ; wechseln
         DEC   death                ; Noch ein Farbwechsel? 
         BNE   .contdie             ; Ja
         LDA   flag                 ; Nein, daher
         AND   #DISABLE_DEATH_FLAG  ; Death-Flag ausschalten
         STA   flag
         LDA   #0                   ; Und Audiokanal 1 ganz leise
         STA   AUDV1                ; drehen.
         DEC   lives                ; Hat der Spieler noch Leben uebrig?
         BNE   .loadlev             ; Ja, also aktuellen Level neu laden.
         JMP   TITLSCRN             ; Nein, daher zum Titel-Screen
.loadlev JMP   NEWLEVEL    
.contdie JMP   PREKERN          
.vital
;}}}

         LDA   #0           
         STA   COLUBK

         JSR   LEVELEND
         JSR   NEXTENEM
         JSR   JOYHORIZ

         LDA   heroState
         AND   #HERO_WAITING        ; Ist der Spieler am Warten?
         BNE   JOYUP                ; Ja, also direkt zur Joystick-Abfrage

         JSR   STOPWALK
         JSR   FRICTION

;{{{
; MOVHORIZ - Hier wird die horizontale Geschwindigkeit zur X-Position des
; Spielers addiert, um die neue horizontale Spielerpostion auszurechnen.
;
MOVHORIZ subroutine
         LDX   #<heroX
         LDA   xSpeedLSB
         LDY   xSpeedMSB
         JSR   ADD16
;
; Pruefen, dass der Spieler nicht die linke bzw. rechte
; Spielfeldbegrenzung ueberschreitet. Ansonsten Position des Spielers
; "korrigieren".
;
         LDA   #LEFT_MARGIN   ; Konstante fuer linke Spielfeldbegrenzung
         CMP   xHeroMSB       ; mit aktueller X-Position vergleichen.
         BCC   .chkrght       ; Ist die aktuelle X-Pos kleiner als erlaubt?
         STA   xHeroMSB       ; Ja, also X-Position "limitieren".
.chkrght LDA   #RIGHT_MARGIN  ; Konstante fuer rechte Spielfeldbegrenzung 
         CMP   xHeroMSB       ; mit aktueller X-Position vergleichen.
         BCS   .skip          ; Ist die aktuelle X-Pos groesser als erlaubt?
         STA   xHeroMSB       ; Ja, also X-Position "limitieren".
;
; Unabhaengig davon, ob die Position des Spielers korrigiert wurde, pruefen
; wir, ob der Spieler mit einer Wand kollidiert ist.
;
.skip    LDA   xSpeedMSB      ; Geschwindigkeit laden.
         BMI   .chkwest       ; Bewegt sich der Spieler nach links?
         JSR   CHKEAST        ; Nein, daher Kollision auf rechter Seite pruefen
         JMP   .end           ; Routine beenden.
.chkwest JSR   CHKWEST        ; Ja, Kollision auf linker Seite pruefen.
.end
;}}}

;{{{
; JOYUP - In der folgenden Joystick-Abfrage ueberpruefen wir, ob der
; Joystick nach oben gedrueckt wurde bzw. der Spieler den Joystick immer
; noch nach oben gedrueckt haelt, um einen Sprung zu initiieren bzw.
; fortzusetzen.
;
; Ein Sprung kann nur aus dem gehenden- bzw. wartenden Zustand heraus gemacht
; werden (bei der Ueberpruefung des Zustands machen wir uns folgende Tatsache
; zu Nutze:
;  HERO_JUMPING < HERO_WALKING < HERO_WAITING
;
JOYUP    subroutine
         LDA   #HERO_FALLING        ; Spielerzustand ueberpruefen
         CMP   heroState            ; Ist der Spieler am "Fallen"?
         BEQ   .newypos             ; Ja, dann Routine ueberspringen
         LDA   joystick             ; Nein, also Joystick Zustand ueberpruefen
         AND   #SWCHA_P0_UP         ; Wurde der Joystick nach oben gedrueckt?
         BNE   .stopjmp             ; Nein, puefen ob Sprung abgebrochen wurde
         LDA   heroState            ; Ja, also pruefen ob der Spieler
         AND   #HERO_WAITING        ; bisher "gewartet" hat?
         BEQ   .walk                ; Nein, hat nicht gewartet
         LDA   #0                   ; Ja, hat gewartet dabei wurden diese beiden
         STA   xSpeedLSB            ; Variablen als Counter "missbraucht" und
         STA   xSpeedMSB            ; muessen deshalb neu initialisiert werden.
.walk    LDA   #HERO_JUMPING
         CMP   heroState            ; "Geht" oder "Wartet" der Spieler? 
         BEQ   .isfall              ; Nein, "Springen" Initialis. nicht noetig
         STA   heroState            ; Ja, also Zustand auf "Springen" aendern
         LDA   #HERO_ACCEL_Y_LSB    ; und
         STA   ySpeedLSB            ; vertikale 
         LDA   #HERO_ACCEL_Y_MSB    ; Geschwindigkeit 
         STA   ySpeedMSB            ; initialisieren.
         BNE   .newypos             ; Ist effektiv ein Branch-Always
.isfall  LDA   ySpeedMSB            ; Bewegt sicher der Spieler nach unten?
         BMI   .falling             ; Ja, daher Zustand "Fallen" initialisieren.
         BPL   .newypos             ; Nein, direkt neu Y-Position ausrechnen.
.stopjmp LDA   #HERO_JUMPING        ; Joystick wurde nicht nach oben gedrueckt.
         CMP   heroState            ; Ist der Spieler derzeit am "Springen"?
         BNE   .newypos             ; Nein, direkt neue Y-Position ausrechnen.
.falling JSR   FALLING              ; Zustand "Fallen" initialisieren.
.newypos LDY   ySpeedMSB            ; Neue Y-Position ausrechnen.
         LDA   ySpeedLSB
         LDX   #<heroY
         JSR   ADD16
;}}}

         JSR   GRAVITAT
         JSR   CHKSOUTH             

;{{{
; COLISION - Die folgende Routine prueft, ob der Gegner ins "Nichts"
; gefallen ist, ob es eine Kollision mit einem Gegner bzw. dem Schuss
; gab oder ob ein Goldstueck eingesammelt wurde.
;
COLISION subroutine
         LDA   #8                ; Ist der Spieler ins "Nichts" 
         CMP   yHeroMSB          ; gefallen?
         BCS   .death            ; Ja.
         LDA   CXPPMM            ; Nein, aber gab es vielleicht eine
         ORA   CXM1P             ; Kollision mit dem Gegner oder
         AND   #%10000000        ; dem Schuss?
         BEQ   .nodeath          ; Nein, aber vielleicht hat er Gold gesammelt
.death   LDA   flag              ; Spieler hat gerade ein Leben verloren,
         ORA   #DEATH_FLAG_MASK  ; daher das Death-Flag
         STA   flag              ; setzen und
         LDA   goldcnt           ; Da der Spieler ein Leben verloren hat, 
         ORA   #LOST_A_LIFE      ; muessen wir in jedem Fall das Lost-a-Life
         STA   goldcnt           ; Flag setzen.
         LDA   #$0E              ; und die Variable fuer den Farbwechsel 
         STA   death             ; waehrend des "Sterbens" initialisieren.
         STA   AUDV1             ; $0E ist ja fast maximale Lautstaerke ;-)
         LDX   #0                ; Damit die SOUNDDRV Routine nicht 
         STX   sounds            ; ausgefuehrt wird, sounds Variable resetten.
         STX   AUDV0             ; Anderen Audiokanal stumm schalten.
         STX   freq1             ; Hoechste Frequenz (0) setzen.
         LDA   #4                ; Jetzt noch das 4te Instrument
         STA   AUDC1             ; fuer Audiokanal 1 setzen.
.nodeath LDA   CXM0P             ; Hat der Spieler vielleicht 
         AND   #%01000000        ; ein Goldstueck eingesammelt?
         BEQ   .chkexit          ; Nein, aber vielleicht Levelausgang erreicht
         LDA   #$FF              ; Ja, daher dieses Goldstueck 
         STA   goldY             ; nicht mehr darstellen.
         JSR   INITGSND          ; Sound-FX initialisieren
         INC   goldcnt           ; Gold-Counter aktualisieren
         LDA   goldcnt           ; Fuer 4 Goldstuecke gibt es ein Extraleben
         AND   #%00000011        ; Ist ein Extraleben faellig?
         BNE   .end              ; Nein, Routine beenden
         JSR   INITESND
         LDX   lives             ; Life-Counter laden
         CPX   #MAXLIVES         ; Maximale Anzahl leben schon erreicht?
         BEQ   .end              ; Ja, Routine beenden
         INX                     ; Nein, daher Leben erhoehen
         STX   lives             ; und Life-Counter aktualisieren
         LDX   #$0E              ; Screen-Flash
         STX   COLUBK
.chkexit BIT   CXP0FB            ; Hat der Spieler den Levelausgang erreicht?
         BVC   .end              ; Nein, Routine beenden.
         LDA   #0                ; Ja, also erstmal Ton stumm schalten
         STA   AUDV0          
         STA   AUDV1         
         LDA   level             ; Wurde vielleicht gerade das 
         CMP   #LASTLEVEL        ; letzte Level beendet?
         BNE   .nextlev          ; Nein, daher naechstes Level laden
         JMP   ENDSCRN           ; Ja, also Abschlussmeldung anzeigen
.nextlev LDA   flag              ; Ja, also das Levelend-Flag
         ORA   #LVLEND_FLAG_MASK ; setzen
         STA   flag
         LDA   #$60              ; Und den Animationstimer fuer die
         STA   levelendAnimTimer ; Zwischensequenz initialisieren.
.end     
;}}}

         JSR   CHKNORTH

;{{{
; WAITANIM - Die folgende Routine sorgt dafuer, dass in die "Warten"
; Animation gewechselt wird, wenn sich der Spieler nicht bewegt. Und das
; der Spieler waehrend der "Warten" Animation zufaellig blinzelt.
;
WAITANIM subroutine
         LDA   heroState            ; Ist der Spieler bereits
         AND   #HERO_WAITING        ; am Warten?
         BNE   .wait                ; Ja, also Initialisierung ueberspringen.
         LDA   xSpeedLSB            ; Wenn sowohl die vertiakle- als auch die 
         ORA   xSpeedMSB            ; horizontale Geschwindigkeit d. Spielers 0 
         ORA   ySpeedLSB            ; ist, bewegt sich d. Spieler offensichtlich
         ORA   ySpeedMSB            ; nicht und wir wechseln zur Warte-Animation
         BNE   WALKANIM             ; Waren alle Werte 0?
         LDA   #BEGIN_WAITING_ANIM  ; Ja, also (neuen) Warte-Zustand
         STA   heroState            ; setzen
         LDA   rnd                  ; Wir merken uns die aktuelle Zufallszahl,
         STA   bored                ; fuer den Beginn der Fusstipp-Animation.
         JSR   NEXTRND              ; rnd auf "naechste" Zufallszahl setzen
.wait    DEC   blinktimer           ; Ist der Blinzel-Timer abgelaufen?
         BNE   .bored               ; Nein, also direkt zum Fusstippen
         LDA   #BLINKING_SPEED      ; Ja, also Blinzel-Timer
         STA   blinktimer           ; resetten.
         JSR   NEXTRND              ; Naechste Zufallszahl ermitteln
         AND   #%00001111           ; Sind die letzten vier Bits null?
         BNE   .noblink             ; Nein, also nicht blinzeln.
         LDA   heroState            ; Spieler-Zustand laden 
         ORA   #%01000000           ; Blinzel-Bit D6 einschalten
         BNE   .update              ; und Zustand aktualisieren (branch-always)
.noblink LDA   heroState            ; Spieler-Zustand laden 
         AND   #%10111111           ; Blinzel-Bit D6 ausschalten
.update  STA   heroState            ; und Zustand aktualisieren.
.bored   LDA   bored                ; Fusstipp-Animation schon am Laufen?
         BEQ   .chkfoot             ; Ja, also Fusstipp-Timer pruefen
         CMP   rnd                  ; Nein, also pruefen ob Wartezeit jetzt um? 
         BNE   .end                 ; Nein, also (noch) nicht mit Fuss tippen
         LDA   #0                   ; Ja, also Fusstipp-Animation starten, indem
         STA   bored                ; bored auf null gesetzt wird.
.chkfoot DEC   footimer             ; Ist der Fusstipp-Timer abgelaufen?
         BNE   .end                 ; Nein, also restl Schritte ueberspringen.
         LDA   #FOOTIP_SPEED        ; Ja, also
         STA   footimer             ; Timer resetten.
         LDA   heroState            ; Spieler-Zustand laden
         ASL                        ; Ist "Fusstip"-Bit D7 gesetzt?
         BCS   .unsetd7             ; Ja, also Bit ausschalten
         SEC                        ; Nein, also Bit einschalten
         BCS   .setd7               ; und setzen (branch-always)
.unsetd7 CLC                        ; Vorbereitung "Fusstip"-Bit ausschalten
.setd7   ROR                        ; Carray-Bit ins "Fusstip"-Bit D7 schieben
         STA   heroState            ; Zustand aktualisieren.
.end     JMP   ENDANIM              ; Naechste Routine ueberspringen.
;}}}

;{{{
; WALKANIM - Die folgende Routine sorgt dafuer, dass fuer die
; "Gehen"-Animation das richtige Sprite gesetzt ist.
;
WALKANIM subroutine
         LDA   heroState         ; Pruefen, ist der Spieler 
         AND   #HERO_WALKING     ; gerade am "Gehen"?
         BEQ   ENDANIM           ; Nein, also Animationsphase ueberspringen
         DEC   heroAnimTimer     ; Muss neue Animationsphase gezeichnet werden?
         BNE   ENDANIM           ; Nein, dann weiter mit bisheriger Animphase
         LDX   #ANIM_SPEED       ; Ja, neue Animationsphase beginnen
         STX   heroAnimTimer     ; Animationstimer reset
         CMP   #END_WALKING_ANIM ; Sind wir am Ende aller Animationsphasen?
         BNE   .next             ; Nein, dann Sprite fuer naechste Phase laden.
         LDA   #0                ; Ja, also Index "vor" erstes Sprite setzen.
.next    CLC                     ; Sprite-Index um eine Stelle verschieben,durch
         ADC   #2                ; Addition von 2 (die Positionen "0000XXX0" 
         STA   heroState         ; haben die Werte 2,4,6,8).
;}}}

ENDANIM
 
;{{{
; ANIMEXIT - Der Ausgang eines Levels wird durch das Ball-Sprite
; dargestellt. Damit man den Ausgang besser erkennen kann, wird das
; Ball-Sprite animiert (die Animation besteht aber nur darin, dass das
; Ball-Sprite in der Groesse veraendert wird). Die folgende Routine
; sorgt fuer die beschriebene Animation.
;
ANIMEXIT subroutine
         DEC   exitAnimTimer        ; Naechste Animationsphase faellig?
         BNE   .end                 ; Nein, also Routine beenden.
         LDA   #ANIM_SPEED          ; Ja, also erstmal Timer 
         STA   exitAnimTimer        ;  resetten.
         LDY   flag                 ; flag laden und in Y zwischenspeichern
         TYA                        ; Ballsize-Flag
         AND   #BALLSIZ_FLAG_MASK   ;  freistellen.
         CMP   #MAX_BALLSIZE        ; Ist die maximale Ballsize erreicht?
         BEQ   .reset               ; Ja, also Ballsize zuruecksetzen
.noreset TYA                        ; Nein, also Ballsize erhoehen und zwar
         CLC                        ; immer um 16 (denn so erhaelt man die
         ADC   #BALLSIZE_INCREMENT  ; Werte 16 (D4), 32(D5) und 48(D4 und D5)
         BNE   .setval              ; branch-always
.reset   TYA                        ; Wert fuer Ballsize-Flag zuruecksetzen
         AND   #DISABLE_BALLSIZ_FALG; d.h. D4 und D5 auf 0 setzen.
.setval  STA   flag                 ; Ballsize-Flags aktualisieren.
         AND   #BALLSIZ_FLAG_MASK   ; Im CTRLPF Register nur die Bits fuer
         STA   CTRLPF               ; Ballsize setzen.
.end     
;}}}
 
;{{{
; MOVETRAP - Hiermit wird die Trap bewegt und zwar immer alternierend
; von links nach rechts. Dazu wird nur das Bit D0 der Variable `flag'
; veraendert. Die anderen Bits bleiben unberuehrt.
;
MOVETRAP subroutine
         LDY   trapY             ; Diese Routine nur ausfuehren, wenn die
         CPY   #DISABLED         ; Trap sichtbar ist.
         BEQ   .end              ; Nicht sichtbar, deshalb Routine beenden.
         LDA   flag              ; Trap-Flag (D0) laden 
         LSR                     ; und freistellen.
         LDA   trapX             ; Addition vorbereiten. Veraendert Carry nicht
         BCS   .left             ; Bei Bewegung nach links ist Carry gesetzt.
         ADC   #TRAP_SPEED       ; X-Koord. erhoehen. CLC nicht notwendig.
         STA   trapX             ; X-Koordinate der Trap aktualisieren.
         CMP   #152              ; Sind wir am rechten Rand angelangt?
         BCC   .end              ; Nein, also Routine beenden.
         JSR   INITLSND          ; Ja, also Laser-Sound initialisieren
         INC   flag              ; und Richtung wechseln.
         BNE   .end              ; branch-always
.left    SBC   #TRAP_SPEED       ; Subtraktion durchfuehren (Carry ist gesetzt)
         STA   trapX             ; X-Koordinate der Trap aktualisieren.
         CMP   #3                ; Sind wir am linken Rand?
         BCS   .end              ; Nein, also Routine beenden
         JSR   INITLSND          ; Ja, also Laser-Sound initialisieren
         DEC   flag              ; und Richtung wechseln
.end
;}}}

;{{{
; PREKERN - Hier werden die Vorbereitungen fuer die Ausfuehrung des
; Kernals getroffen, wie z.B. das Positionieren der Sprites und das
; Beladen der Sprite-Pointer.
;
PREKERN  subroutine
 
; Dieser Kommentar bezieht sich nur auf die beiden nachfolgenden
; Statements. Damit das Enemy-Sprite nicht so "tief" im Playfield
; versinkt, wenden wir einen kleinen Hack an: Vor dem Setzen des
; Enemy-Sprite-Pointers, erhoehen wir die Y-Position des Enemy-Sprites
; um 2 Einheiten. Nach Beendigung des Kernals ziehen wir diese
; 2 Einheiten wieder ab. Damit hat die Anpassung der Y-Koordinate
; nur Einfluss auf die Darstellung des Enemy-Sprites; alles andere
; -insbesondere die Kollisionsabfrage- bleibt davon unberuehrt.
;
         INC   yEnemyMSB           
         INC   yEnemyMSB           

         STA   CXCLR             ; Kollisionsregister loeschen 

         LDA   #%00010000        ; Der Spieler (P0) wird normal dargestellt,
         STA   NUSIZ0            ; das Gold (M0) soll 2 clocks breit sein.

         LDA   #>Sprites         ; Sprite des Spieler in den Sprite-Pointer
         STA   heroSpritePtr + 1 ; laden.
         JSR   LOADHERO       

         LDX   #heroSpritePtr    ; Sprite-Pointer entsprechend der
         LDY   yHeroMSB          ; Y-Koordinate des Spielers entsprechend
         JSR   ADJUST            ; positionieren

         LDA   yHeroMSB
         JSR   VERTADJ
         STY   VDELP0

         LDX   #HMP0-HMP0
         LDA   xHeroMSB
         JSR   MOVSPRIT

         LDA   #>Enemy
         STA   enemySpritePtr + 1
         JSR   LOADENMY

         LDX   #enemySpritePtr
         LDY   yEnemyMSB
         JSR   ADJUST

         LDX   yEnemyMSB
         TXA
         LDX   #enemySpritePtr
         JSR   VERTADJ
         STY   VDELP1

         LDX   #HMP1-HMP0
         LDA   xEnemyMSB
         JSR   MOVSPRIT

         LDX   #HMM0-HMP0
         LDA   goldX
         JSR   MOVSPRIT

         LDX   #HMM1-HMP0
         LDA   trapX
         JSR   MOVSPRIT

         LDX   #HMBL-HMP0
         LDA   doorX
         JSR   MOVSPRIT
   
         STA   WSYNC
         STA   HMOVE
         JSR   VBLNKEND
;}}}

;{{{
; KERNAL - Hier wird der Bildschirm gezeichnet (Hintergrund, Sprites,
; Missels, Ball)
;
KERNAL   subroutine
   IFNCONST NTSC
         LDX   #18 
.pal     STA   WSYNC
         DEX
         BNE   .pal
   ENDIF
         LDA   scroll
         STA   blockHeightCnt    ;     Blockreihe initialisieren.
         LDA   #0                ;     Enemy-Sprite-Daten fuer ersten Durchlauf
         STA   temp
         LDY   #178              ;     Y enthaelt immer die aktuelle Scanline
.kernal  LDX   #ENABL            ;2 58
         TXS                     ;2 60
         LDX   temp              ;2 62
         DEY                     ;2 64 Scanlinecounter aktualisieren.
         DEY                     ;2 66
         BEQ   .endKERN          ;2 68
         STA   WSYNC             ;3 71 Naechste Scanline beginnen
         STA   GRP1              ;3 3  Enemy-Sprite zeichen; triggert u.U. GRP0
         CPY   doorY             ;3 6
         PHP                     ;3 9
         CPY   trapY             ;3 12
         PHP                     ;3 15
         NOP                     ;2 17 Synchronisieren
         LDA   pf1l,X            ;4 21    
         STA   PF1               ;3 24    
         LDA   pf2l,X            ;4 28    
         STA   PF2               ;3 31
         LDA   pf0r,X            ;4 35
         STA   PF0               ;3 38
         LDA   pf1r,X            ;4 42
         STA   PF1               ;3 45
         LDA   pf2r,X            ;4 49
         STA   PF2               ;3 52
         STX   temp              ;3 55 Index des aktuell. Band zwischenspeichern
         LDX   #0                ;2 57 In der naechsten Scanline, soll das
         STX   PF0               ;3 60 Spielfeld deaktiviert werden.
         CPY   goldY             ;3 63
         PHP                     ;3 66
         TYA                     ;2 68 Vorbereitungen fuer SKPHERO
         SEC                     ;2 70 in der naechsten Scanline.
         STX   PF1               ;3 73 Spielfeld in naechster Scanline deaktiv
         STA   WSYNC             ;3 76 Naechste Scanline beginnen.
         STX   PF2               ;3 3  Spielfeld deaktivieren
         SBC   yHeroMSB          ;3 6    
         ADC   #SPRITE_HEIGHT*2  ;2 8
         BCC   .skphero          ;2 10
         LDA   (heroSpritePtr),y ;6 16
.cont1   STA   GRP0              ;3 19
         TYA                     ;2 21
         SEC                     ;2 23
         SBC   yEnemyMSB         ;3 26
         ADC   #SPRITE_HEIGHT*2  ;2 28
         BCC   .skpenem          ;2 30
         LDA   (enemySpritePtr),y;6 36
.cont2   DEC   blockHeightCnt    ;5 41 Counter fuer innere Schleife dekremntrn
         BNE   .kernal           ;2 43 Ggf. naechste Zeile des aktuellen Bands?
         INC   temp              ;5 48 Nein, also Index f akt. Band dekremntrn
         LDX   #BLK_HEIGHT/2     ;2 50 Zaehler fuer die Zeilen der naechsten 
         STX   blockHeightCnt    ;3 53 Blockreihe initialisieren.
         BNE   .kernal           ;3 56 branch-always
.skphero LDA   #0
         BEQ   .cont1
.skpenem LDA   #0
         BEQ   .cont2 
.endKERN STY   WSYNC 
;}}}

;{{{
; LIFEBAR - Stellt die Lebensanzeige am unteren Bildschirmrand dar.
; Wir befinden uns gerade bei Scanline 216, d.h. bei NTSC haben wir noch
; genau 13 (= 262-216-30-3) Scanlines Zeit.
;
LIFEBAR
         LDA   #LIFEBAR_TIM64T
         STA   TIM64T            ; Timer fuer Scanlines setzen

         DEC   yEnemyMSB         ; Die 2 Einheiten, die wir fuer die bessere
         DEC   yEnemyMSB         ; Darstellung addiert haben, wieder abziehen

         LDA   #3
         STA   sprite6_height
         LDA   goldcnt
         AND   #%00000011
         TAX
         LDA   #GOLDCOL,X
         STA   sprite6_color
         LDA   #>SPRITE_PAGE     ; Basisadresse der Sprite-Speicherseite laden
         LDY   #<LOSTLIFE        ; Index Adresse des LOSTLIFE-Sprite laden.
         LDX   #10               ; Jetzt alle Sprite6-Pointer mit den 
.setptr  STA   sprite6_ptr1+1,X  ; Sprite-Daten des LOSTLIFE-Sprites befuellen
         STY   sprite6_ptr1,X    
         DEX
         DEX
         BPL   .setptr           
         LDA   lives
         ASL
         TAX
         LDA   #<LIFE 
.setlife STA   sprite6_ptr1-2,X
         DEX
         DEX
         BNE   .setlife
         DEX                     ; $00 - 1 == $FF
         TXS                     ; Stackpointer wiederherstellen
         JSR   SPRITE6
.waitend LDA   INTIM
         BNE   .waitend
;}}}

OVERSCAN JSR   OVRSCBEG
 
         BIT   flag           ; Hat der Spieler gerade ein Leben verloren? 
         BVC   MOVENEMY       ; Nein, ganz normal weitermachen.
         JMP   END            ; Ja, daher (insbesondere) SOUNDDRV Routine
                              ; ueberspringen (der "Sterbe-Sound" wird *nicht*
                              ; von der SOUNDDRV Routine gespielt, sondern von
                              ; der VITALCHK Routine), damit waehrend des
                              ; Sterbens keine anderen Geraeusche gespielt
                              ; werden.

;{{{
; MOVENEMY - Bewegt die Gegner 
; Die folgende Routine schaut nach, ob und wenn ja welcher Gegener
; (Ball oder Schlauch) gerade aktiv ist und ruft dann die entsprechende
; Routine zum Bewegen des Gegners auf.
;
MOVENEMY subroutine
         BIT   flag                 ; Death-Flag laden.Stirbt Spieler gerade?
         BVS   .noenemy             ; Ja, also Routinen ueberspringen.
         LDA   enemyState           ; Nein, daher Gegner-Typ freistellen.
         AND   #ENEMY_TYPE_MASK     ; Ist ein Gegner z.Zt. aktiv?
         BEQ   .noenemy             ; Nein, daher Routinen ueberspringen
         CMP   #ENEMY_TUBE          ; Ist ein Schlauch gegner aktiv?
         BCS   MOVETUBE             ; Ja, also zur Schlauch-Routine.
         BCC   MOVEBALL             ; Nein, daher zur Ball-Routine.
.noenemy JMP   NOENEMY              ; Ziel ist zu weit weg fuer einen Branch.
;}}}

;{{{
; MOVEBALL - In der folgenden Routine wird der Ball-Gegner animiert.
;
; Wenn der Ball mit dem Boden kollidiert, startet die Animation (der
; Ball wird erst zusammengedrueckt und dehnt sich dann wieder auf).
; Erst nach Ende der Animation, wird die vertikale Geschwindigkeit
; gesetzt (so dass der Ball wieder eine Aufwaertsbewegung macht) und die
; vertikale Richtung wird wieder auf "am Fallen" gestellt, damit wir
; erst wieder in die Animation laufen, wenn der Ball das naechste mal
; wieder mit dem Boden kollidiert (d.h. die vertikale Richtung wird hier
; eher als Flag verwendet und nicht als Richtungsangabe).
;
MOVEBALL subroutine
         LDA   enemyState
         AND   #ENEMY_V_DIR_MASK    ; Ist der Ball gerade am auftitschen?
         BNE   .noanim              ; Nein, also keine Animation zeichnen
         DEC   enemyAnimTimer       ; Ja, muss neue Animphase gezeichnet werden?
         BNE   .end                 ; Nein, also Routine beenden.
         LDA   #BALL_ANIM_SPEED     ; Ja, also erstmal den
         STA   enemyAnimTimer       ;  Animationstimer resetten.
         LDA   enemyState
         TAY
         AND   #ENEMY_ANIM_MASK     ; Aktuelle Animationsphase freistellen
         CMP   #BALL_END_ANIM       ; Sind wir bei der letzten Animationsphase?
         BCC   .noreset             ; Nein, direkt naechste Animphase setzen.
         LDA   #BALL_ACCEL_Y_LSB    ; Ja, daher vertikale Geschwindigkeit
         STA   yEnemySpeedLSB       ;  initialisieren, damit der Ball eine 
         LDX   #BALL_ACCEL_Y_MSB    ;  Aufwaertsbewegung macht. 
         STX   yEnemySpeedMSB        
         TYA   
         AND   #ENEMY_CLEAR_ANIM    ; Animation auf Anfang stellen.
         ORA   #ENEMY_FALLING       ; Vertikale Richtung "umdrehen".
         TAY
.noreset INY                        ; Animationsphase erhoehen.
         STY   enemyState           ; Neuen Zustand setzen.
         BNE   .end                 ; branch-always

.noanim  LDY   yEnemySpeedMSB       ; Faellt oder steigt der Ball?
         BMI   .falling             ; Ball faellt
         LDA   #GRAVITY_CONST_RISE  ; Ball steigt

.nocoll  LDY   #$FF                 ; Gravitation auf Fallgeschwindigkeit 
         LDX   #<enemySpeedY        ; anwenden.
         JSR   ADD16      
         LDY   yEnemySpeedMSB       ; Neue Y-Koordinate ausrechnen 
         LDA   yEnemySpeedLSB       
         LDX   #<enemyY             
         JSR   ADD16
         JMP   NOENEMY              ; Routine beenden

.falling BIT   CXP1FB               ; Hat der Ball den Boden beruehrt?
         BMI   .coll                ; Ja
         LDA   #GRAVITY_CONST_FALL  ; Nein, also Gravitationskonstante laden
         BNE   .nocoll              ; branch-always

.coll    LDA   enemyState           ; Ja, daher Zustand auf "auftitschen" 
         AND   #BALL_IS_BOUNCING    ; setzen
         STA   enemyState           
         JSR   INITBSND             ; Bounce-Sound soll abgespielt werden

.end     JMP   NOENEMY 
;}}}
 
;{{{
; MOVETUBE - behandelt die horizontale Bewegung des Schlauch-Gegners.
;
; Der Schlauch geht so lange in eine Richtung, bis er auf eine Wand
; oder einen Abgrund trifft. Wenn das passiert wechselt er die
; Bewegungsrichtung.
;
; Wir muessen bei der Pruefung, ob der Schlauch rechts runterfallen
; wuerde, beruecksichtigen, ob es sich um einen einzelnen Schlauch oder
; um einen Doppel-Schlauch handelt.
;
MOVETUBE subroutine
         DEC   enemyAnimTimer       ; Muss neue Animphase gezeichnet werden?
         BNE   NOENEMY              ; Nein, also Routine beenden.
         LDA   #TUBE_ANIM_SPEED     ; Ja, also erstmal den
         STA   enemyAnimTimer       ;  Animationstimer resetten.
         LDA   enemyState           ; Zustand in Akku
         AND   #ENEMY_ANIM_MASK     ; Aktuelle Animationsphase freistellen
         CMP   #TUBE_END_ANIM       ; Sind wir bei der letzten Animationsphase?
         BCC   .dontmov             ; Nein, also Schlauch nicht bewegen.
         LDA   enemyState           ; Zustand in Akku
         AND   #ENEMY_H_DIR_MASK    ; Bit f. horiztl Bewegungsricht freistellen
         CMP   #ENEMY_DIR_LEFT      ; bewegt sich der Schlauch nach links?
         BCC   .movrght             ; Nein, nach rechts.
         LDA   #$FC                 ; Gibt es eine Kollision zwischen PF und
         LDY   #$EF                 ; (x-4, y-17)? Wenn nicht wuerde der
         JSR   ENEMYPF              ; Schlauch links runter fallen.
         BEQ   .chgdir              ; Keine Kollision, daher Richtung aendern.
         LDA   #$FF                 ; Gibt es eine Kollision zwischen PF und
         LDY   #$F8                 ; (x, y-8)? Wenn ja, ist der Schlauch gegen
         JSR   ENEMYPF              ; die linke Wand gelaufen.
         BNE   .chgdir              ; Ja, Kollision daher Richtung aendern.
         LDA   xEnemyMSB            ; Nein, also Schlauch nach links bewegen,
         SEC                        ; (d.h. 4 von der X-Koordinate des 
         SBC   #4                   ; Schlauchs subtrahieren).
         STA   xEnemyMSB            ;
         JMP   .reset               ; Animationsphase resetten
.movrght LDY   #8                   ; Abhaengig davon, ob es sich um einen 
         BIT   enemyState           ; Einzel- oder um einen Doppel-Schlauch
         BPL   .tube_1              ; handelt, muessen fuer die Kollisionsabfr
                                    ; entweder 8 (einzel) oder 40 (doppel)
                                    ; zur X-Koordinate addiert werden. Da wir
         LDY   #40                  ; den Wert in zwei Abfragen brauchen, wird 
.tube_1  STY   temp1                ; er zwischengespeichert.
         TYA                        ; Gibt es eine Kollision zwischen PF und
         LDY   #$EF                 ; (x+8, y-17)? Wenn nicht wuerde der
         JSR   ENEMYPF              ; Schlauch rechts runter fallen.
         BEQ   .chgdir              ; Keine Kollision, daher Richtung aendern.
         LDA   temp1                ; Gibt es eine Kollision zwischen PF und
         LDY   #$F8                 ; (x+8, y-8)? Wenn ja, ist der Schlauch 
         JSR   ENEMYPF              ; gegen die rechte Wand gelaufen.
         BNE   .chgdir              ; Ja, Kollision daher Richtung aendern.
         LDA   xEnemyMSB            ; Nein, daher Schlauch nach rechts bewegen,
         CLC                        ; (d.h. 4 zu der X-Koordinate des
         ADC   #4                   ; Schlauchs addieren).
         STA   xEnemyMSB            ;
         JMP   .reset               ; Animationsphase resetten
.chgdir  LDA   enemyState           ; Zustand in Akku
         EOR   #ENEMY_H_DIR_MASK    ; Bewegungsrichtung invertieren
         STA   enemyState           ; Neuen Zustand speichern
.reset   LDA   enemyState           ; Zustand in Akku
         AND   #ENEMY_CLEAR_ANIM    ; Animation auf Anfang setzen
         BNE   .setstat             ; branch-always
.dontmov LDY   enemyState           ; Zustand laden
         INY                        ; Animationsphase erhoehen.
         TYA                        ; Zustand in Akku
.setstat TAY                        ; Neuen Zustand zwischenspeichern
         STA   enemyState           ; Zustand mit neuer Animphase updaten.
         AND   #ENEMY_ANIM_MASK     ; Aktuelle Animationsphase freistellen
         CMP   #4                   ; Muss die Blickrichtung umgedreht werden?
         TYA                        ; Zustand wiederherstellen.
         BCS   .noinver             ; Nein, Blickricht bleibt Bewegungsrichtung
         EOR   #ENEMY_H_DIR_MASK    ; Ja, Blickricht entgegen Bewegungsrichtung
.noinver STA   REFP1                ; Hier interessiert nur Bit D3.
         LDX   #COLUP1_REFP1_COPY   ; REFP1 Wert nach COLUP1_REFP1_COPY 
         JSR   COPYREFP             ; uebertragen.
;}}}
NOENEMY

;{{{
; SCRLCHK - Prueft, ob das Level gescrollt werden muss.
; Wenn die Y-Koordinate des Spielers einen gewissen Schwellwert
; ueberschritten hat, dann muessen wir das Level nach unten scrollen.
;
SCRLCHK  subroutine
         LDA   flag              
         AND   #SCROLL_FLAG_MASK ; Sind wir bereits am Scrollen? 
         BNE   .down             ; Ja, daher einfach weiter scrollen.
         JSR   LEVELPOS          ; Nein, aber sind wir am Ende des Levels?
         BEQ   .end              ; Ja, Routine direkt beenden. 
         LDA   heroState         ; Nein, daher pruefen
         CMP   #HERO_JUMPING     ;  ob der Spieler gerade springt?
         BNE   .end              ; Nein, nicht "am Springen", Routine beenden.
         LDA   yHeroMSB          ; Ja, Spieler springt. Hat die Y-Koordinate
         CMP   #$64              ;  den Schwellwert ueberschritten?
         BCC   .end              ; Nein, Routine beenden.
         LDA   flag              ; Ja, also Scroll-Flag laden
         ORA   #SCROLL_FLAG_MASK ; Scroll-Flag einschalten
         STA   flag              ; und aktualisieren.
.down    JSR   SCRLDOWN          ; Level nach unten scrollen.
.end     
;}}}

;{{{
; SOUNDDRV - Soundtreiber Routine
; Diese Routine entscheidet auf Basis der Variable `sounds' welche
; Sounderzeugungs-Routine fuer Audiokanal 1 bzw. Audiokanal 2
; ausgefuehrt werden muss. Die jeweilige Sounderzeugungs-Routine
; erzeugt dann neue Werte fuer Frequenz und Lautstaerke, die dann vom
; Soundtreiber im entsprechenden Audiokanal gesetzt werden.
;
; Es wird davon ausgegangen, dass das jeweilige Instrument sich
; waehrend des Abspielens eines Sounds nicht aendert und daher bei der
; Initialisierung fuer eine Sounderzeugungs-Routine bereits gesetzt
; werden kann (andernfalls muesste man sich auch das Instrument in einer
; Variablen merken). Muss waehrend des Abspielens eines Sounds doch das
; Instrument gewechselt werden, so muss die Sounderzeugungs-Routine sich
; selber darum kuemmern.
;
SOUNDDRV subroutine
         LDA   sounds         ; Alle zu spielenden Sounds laden
         AND   #SND0_MASK     ; und die fuer Kanal 0 freistellen
         CMP   #BALL_SOUND    ; Muss der Ball-Sound gespielt werden?
         BNE   .tubesnd       ; Nein, naechsten Sound pruefen
         JMP   BALLSND        ; Ja, Ball-Sound abspielen
.tubesnd CMP   #TUBE_SOUND    ; Muss der Tube-Sound gespielt werden?
         BNE   .chan1         ; Nein, also weiter mit Sounds von Kanal 1
         JMP   TUBESND        ; Ja, also Tube-Sound abspielen
AUDIO0   LDA   vol0           ; Lautstaerke fuer Kanal 0 laden
         STA   AUDV0          ; und setzen.
         LDA   freq0          ; Frequenz fuer Kanal 0 laden
         STA   AUDF0          ; und setzen.
.chan1   LDA   sounds         ; Alle zu spielenden Sounds laden
         AND   #SND1_MASK     ; und die fuer Kanal 1 freistellen
         CMP   #EXTRA_SOUND   ; Muss der Extraleben-Sound gespielt werden?
         BNE   .goldsnd       ; Nein, naechsten Sound pruefen.
         JMP   EXTRASND       ; Ja, Extraleben-Sound abspielen.
.goldsnd CMP   #GOLD_SOUND    ; Muss der Gold-Sound gespielt werden?
         BNE   .lasrsnd       ; Nein, naechsten Sound pruefen.
         JMP   GOLDSND        ; Ja, Gold-Sound abspielen.
.lasrsnd CMP   #LASER_SOUND   ; Muss der Laser-Sound gespielt werden?
         BNE   .end           ; Nein, also Routine beenden.
         JMP   LASERSND       ; Ja, also Laser-Sound abspielen.
AUDIO1   LDA   vol1           ; Lautstaerke fuer Kanal 1 laden
         STA   AUDV1          ; und setzen.
         LDA   freq1          ; Frequenz fuer Kanal 1 laden
         STA   AUDF1          ; und setzen.
.end     
;}}}

END      JSR   OVRSCEND
         JMP   GAMELOOP         

;{{{ 
; EXTRASND - Sound-FX fuer Extraleben
;
EXTRASND subroutine
         LDA   vol1        
         BEQ   .goldsnd   
         DEC   vol1        
         INC   freq1
         JMP   AUDIO1
.goldsnd JSR   INITGSND
         ;JMP   GOLDSND ; Fall-through code
;}}}

;{{{ 
; GOLDSND - Sound-FX fuer das Einsammeln eines Goldstuecks 
;
; TODO: Falls diese Routine verschoben wird, muss das "JMP GOLDSND" am
; Ende des EXTRASND wieder einkommentiert werden.
;
GOLDSND subroutine
         LDA   vol1        ; Lautstaerke fuer Audiokanal 0
         BEQ   .end        ; Ist die Lautstaerke 0?
         DEC   vol1        ; Nein, also Lautstaerke dekrementieren.
         DEC   freq1       ; Frequenz fuer Audiokanal 0 dekrementieren.
         DEC   freq1       ; Frequenz fuer Audiokanal 0 dekrementieren.
.end     JMP   AUDIO1
;}}}

;{{{ 
; BALLSND - Spielt den Soundeffekt fuer das Aufprallen des Balls ab
; Anmerkung: Der Sound kann verlaengert werden, in dem man erst nach
; Ablauf eines Timers (z.B. der Animationstimer des Balls:
; enemyAnimTime) mit dem Dekrementieren der Lautstaerke und der Frequenz
; beginnt.
;
BALLSND subroutine
         LDA   vol0        ; Lautstaerke fuer Audiokanal 0
         BEQ   .end        ; Ist die Lautstaerke 0?
         DEC   vol0        ; Nein, also Lautstaerke dekrementieren.
         DEC   freq0       ; Frequenz fuer Audiokanal 0 dekrementieren.
.end     JMP   AUDIO0
;}}}

;{{{ 
; TUBESND - Spielt den Soundeffekt, wenn der Schlauch-Gegner einen
; Schritt macht.
;
TUBESND subroutine
         LDA   vol0        ; Lautstaerke fuer Audiokanal 0
         BEQ   .end        ; Ist die Lautstaerke 0?
         DEC   vol0        ; Nein, also Lautstaerke dekrementieren.
         DEC   freq0       ; Frequenz fuer Audiokanal 0 dekrementieren.
.end     JMP   AUDIO0
;}}}

;{{{
; JOYHORIZ - passt die horizontale Geschwindigkeit des Spielers an.
; Wurde der Joystick nach rechts bewegt, so wird die horizontale
; Geschwindigkeitskonstante HERO_ACCEL_X zur derzeitigen Geschwindigkeit
; dazu addiert. Wurde der Joystick nach links bewegt, so wird
; diese subtrahiert (durch Addition des 2er Komplements der
; Geschwindigkeitskonstante HERO_ACCEL_X).
;
JOYHORIZ SUBROUTINE
         LDA   SWCHA               ; Joystick Zustand in Akku laden
         LDX   INPT4               ; Wurde der Feuerknopf gedrueckt?
         BMI   .nofire             ; Nein
         AND   #ENABLE_SWCHA_P0_UP ; Ja, also Joystick nach oben faken.
.nofire  STA   joystick            ; Joystick Status zwischenspeichern 
         CMP   #%11000000          ; Joystick links oder rechts gedrueckt?
         BCS   .return             ; Nein, dann horiz Joystick-Check ueberspr
         LDA   heroState           ; Ja, Spielerzustand ueberpruefen
         AND   #HERO_WAITING       ; "Wartet" der Spieler?
         BEQ   .skipini            ; Nein, also direkt zur Joystick-Abfrage
         LDA   #BEGIN_WALKING_ANIM ; Ja, also Spielerzustand auf "Gehen"
         STA   heroState           ; setzen 
         LDA   #0                  ; Beim Warten wurden die folgenden beiden
         STA   xSpeedLSB           ; Variablen als Counter "missbraucht", 
         STA   xSpeedMSB           ; deshalb neu initialisieren.
.skipini LDY   #0                  ; Y enthaelt MSB fuer Geschwindigkeitsaddtion
         BIT   joystick            ; D7 ins S-Flag schieben
         BMI   .joyleft            ; Joystick nach rechts (d.h. ist D7=0)?
         LDA   #HERO_ACCEL_X       ; Ja, also Geschwindgkeitskonstante addieren
         STY   REFP0               ; D3=0 andere egal, Spieler guckt nach rechts
         BNE   .skpjoyl            ; Wird immer ausgefuehrt, da hier A!=0
.joyleft                           ; Joyst wurde offensichtl nach links gedruckt
         DEY                       ; Y=ff setzen, wegen 2er Komplement
         LDA   #-HERO_ACCEL_X      ; 2er Kompl. der Geschwindigkeitskonstante
         STY   REFP0               ; D3=1 andere egal, Spieler guckt nach links
.skpjoyl STY   temp                ; REFP0 merken fuer COLUP0_REFP0_COPY
         LDX   #<heroSpeedX        ; Alles fuer Geschwindigkeitsaddition vorber
         JSR   ADD16               ; Neue Geschwindigkeit ausrechnen
         LDA   temp                ; Jetzt noch den in temp zwischengesp
         LDX   #COLUP0_REFP0_COPY  ; REFP0 Wert nach COLUP0_REFP0_COPY 
         JSR   COPYREFP            ; uebertragen.
.return  RTS                          
;}}}

;{{{
; COPYREFP - Diese Routine dient dazu das D0 Bit der COLUP0_REFP0_COPY
; bzw. COLUP1_REFP1_COPY Variable entsprechend zu setzen. Dazu muss im
; Akku der Wert des REFP0 bzw. REFP1 Registers uebergeben werden. Und im
; X-Register die Adresse von COLUP0_REFP0_COPY bzw. COLUP1_REFP1_COPY.
;
COPYREFP subroutine
         AND   #%00001000             ; D3 des REFPx freistellen
         BEQ   .norefl                ; Ist das Reflect-Bit D3 gesetzt?
         LDA   $00,X                  ; Ja, deshalb COLUPx_REFPx_COPY laden
         ORA   #%00000001             ; und D0 einschalten.
         BNE   .setval                ; branch-always
.norefl  LDA   $00,X                  ; Nein, deshalb COLUPx_REFPx_COPY laden
         AND   #%11111110             ; und D0 ausschalten.
.setval  STA   $00,X                  ; COLUPx_REFPx_COPY aktualisieren
         RTS  
;}}}

;{{{
; STOPWALK - Wir wollen die Auslaufphase verkuerzen (z.B. wenn der
; Joystick nur kurz in eine Richtung gedrueckt wurde). D.h. wenn der
; Joystick gerade nicht nach links oder rechts gedrueckt wird, und die
; horizontale Geschwindigkeit einen Schwellwert unterschreitet, wird sie
; direkt auf 0 gesetzt.
;
STOPWALK subroutine
         LDA   joystick         ;3 Joystick-Zustand laden.
         CMP   #%11000000       ;2 Joystick links oder rechts gedrueckt?
         BCC   .dontstp         ;3 Ja, deswegen nicht abbremsen.
         LDX   xSpeedLSB        ;3 Momentane Geschwindigkeit in X und
         LDA   xSpeedMSB        ;3 A laden.
         BPL   .notneg          ;3 Bewegt sich der Spieler momentan nach links?
         EOR   #$FF             ;2 Ja, daher aktuelle Geschwindigkeit durch 
         TAY                    ;2 bilden des 2er Komplements "normalisieren".
         TXA                    ;2 Wir muessen dafuer sorgen, dass das 
         EOR   #$FF             ;2 (normalisierte) LSB der aktuellen 
         TAX                    ;2 Geschwindigkeit in X landet und *danach* 
         TYA                    ;2 das (normalisierte) MSB in A. 
.notneg  BNE   .dontstp         ;3 Ist MSB>0 (dann sind wir sowieso zu schnell)?
         CPX   #X_MOT_STOP_THR  ;2 Nein, MSB=0 also LSB u Schwellwrt vergleichen
         BCS   .dontstp         ;3 Wurde des Schwellwert unterschritten?
         STA   xSpeedMSB        ;3 Ja, also Geschwindigkeit auf 0 setzen (in A 
         STA   xSpeedLSB        ;3 steht ja noch die 0)
.dontstp RTS                    ;6
                                ;=49
;}}}

;{{{
; FRICTION - Damit die Steuerung des Spielers sich natuerlicher
; anfuehlt, berechnen wir die Reibung und subtrahieren diese von der
; aktuellen horizontalen Geschwindigkeit des Spielers. Das sorgt zum
; einen dafuer, dass es eine Hoechstgeschwindigkeit gibt und zum
; anderen, dass die Geschwindigkeit allmaehlig abgebremst wird, wenn der
; Joystick weder nach links noch nach rechts bewegt wurde.
;
; Es wird ein kleiner Bruchteil (hier 1/32) der aktuellen
; Geschwindigkeit berechnet und von eben dieser (der aktuellen
; Geschwindigkeit) subtrahiert. Da dieser Bruchteil irgendwann ungefaehr
; identisch mit Geschwindigkeitskonstante HERO_ACCEL_X ist, wird die
; Hoechstgeschwindigkeit limitiert, da die Addition der zuvor hinzu
; addierten Geschindigkeitskonstante ja dadurch aufgehoben wird.
;                      
FRICTION SUBROUTINE
         LDY   #1           ;2
         STY   temp1        ;3
         DEY                ;2
         LDA   xSpeedMSB    ;3
         BMI   .negativ     ;3
         ORA   xSpeedLSB    ;2
         BEQ   .end         ;3
         STY   temp1        ;3
         DEY                ;2
.negativ LDA   xSpeedMSB    ;3
         STA   temp2        ;3
         LDA   xSpeedLSB    ;3
         LDX   #5           ;2 =34
.div32   LSR   temp2        ;5
         ROR                ;2
         DEX                ;2
         BNE   .div32       ;3 =34 + (12*5) = 94
         EOR   #$FF         ;2
         CLC                ;2
         ADC   temp1        ;3
         LDX   #<heroSpeedX ;2
         JSR   ADD16        ;6 +26
.end     RTS                ;6
                            ;= 141
;}}}

;{{{
; CHKEAST - prueft, ob der Spieler beim "sich nach rechts bewegen" mit
; dem Spielfeld kollidiert ist. Dazu wird die "Ost"-Koordinate (x+7, y-8)
; des Spielers ueberprueft.
; Wenn eine Kollision stattgefunden hat, wird die Geschwindigkeit des Spielers
; gedrosselt und die X-Koordinate wird auf den naechst niedrigeren durch 4
; teilbaren Wert gesetzt.
;
CHKEAST  SUBROUTINE
         LDA   #7          ; Gibt es eine Kollision zwischen
         LDY   #$F8        ; (x+7, y-8) und dem Spielfeld?
         JSR   HEROPF
         BEQ   .end        ; Nein, kein Anpassungen noetig.
         LDA   xHeroMSB          
         AND   #%11111100  ; Horizontale Position wird auf naechst niedrigere,
         STA   xHeroMSB    ;  durch vier teilbare Position gesetzt. 
.end     RTS
;}}}

;{{{
; CHKWEST - prueft, ob der Spieler beim "sich nach links bewegen" mit
; dem Spielfeld kollidiert ist. Dazu wird die "West"-Koordinate (x, y-8)
; des Spielers ueberprueft.
; Wenn eine Kollision stattgefunden hat, wird die Geschwindigkeit des Spielers
; getrosselt und die X-Koordinate wird auf den naechst hoeheren durch 4
; teilbaren Wert gesetzt.
; Wenn eine Kollision stattgefunden hat ist das Zero-Flag geloescht. Wenn
; keine Kollision stattgefunden hat ist das Zero-Flag gesetzt.
;
CHKWEST  SUBROUTINE
         LDA   #0                ; Gibt es eine Kollision zwischen
         LDY   #$F8              ; (x, y-8) und dem Spielfeld?
         JSR   HEROPF
         BEQ   .end              ; Nein, also sind keine Anpassungen noetig.
         LDA   xHeroMSB          ; Ja. Ist die momentane X-Koordinate
         AND   #%00000011        ;  glatt durch 4 teilbar? 
         BEQ   .end              ; Ja, also momentane X-Koordinate uebernehmen.
         LDA   xHeroMSB          ; Nein, daher zur X-Koordinate
         CLC                     ;  4 addieren  
         ADC   #4                ;  und auf naechsten,
         AND   #%11111100        ;  durch 4 teilbaren Wert, runden.
         STA   xHeroMSB          ; Die neue X-Koordinate uebernehmen.
.end     RTS
;}}}

;{{{
; CHKSOUTH - prueft, ob der Spieler beim Springen "unten" mit dem Spielfeld
; kollidiert ist. Dazu werden die "Sued"-Koordinaten (x+2, y-16) und 
; (x+6, y-16) des Spielers ueberprueft.
; Hat eine Kollision stattgefunden, so wird ggf. der "Fallen" Zustand
; beendet. und die Y-Koordinate wird auf den naechst hoeheren, durch
; BLK_HEIGHT teilbaren Wert gesetzt.
;
CHKSOUTH SUBROUTINE
         LDA   heroState            
         AND   #HERO_JUMPING        ; Springt der Spieler?
         BNE   .end                 ; Ja, also Routine direkt beenden.
         LDA   #2                   ; Gibt es eine Kollision zwischen 
         LDY   #$F0                 ;  dem Spielfeld und (x+2, y-16)?
         JSR   HEROPF
         BNE   .skip                ; Ja, also 2.Check ueberspringen.
         LDA   #6                   ; Nein, also 2.Koordinate pruefen. 
.simple  LDY   #$F0                 ;  Gibt es eine Kollision zwischen 
         JSR   HEROPF               ;  (x+6, y-16) und dem Spielfeld?
         BEQ   .end                 ; Nein auch hier nicht, Routine beenden.
.skip    LDA   yHeroMSB             ; Ja, also Y-Koordinate auf naechst
         CLC                        ;  hoeheren durch 16 (=BLK_HEIGHT)
         ADC   #16                  ;  teilbaren Wert setzen.
         AND   #%11110000
         STA   yHeroMSB
         LDA   #0                   ; Fallgeschwindigkeit auf 0 setzen.
         STA   ySpeedLSB
         STA   ySpeedMSB
         LDA   heroState            ; War der Spieler 
         AND   #HERO_FALLING        ;  im Zustand "Fallen"?
         BEQ   .end                 ; Nein, Routine beenden
         LDA   #BEGIN_WALKING_ANIM  ; Ja, daher den "Gehen" Zustand 
         STA   heroState            ;  initialisieren.
.end     RTS
;}}}

;{{{
; CHKNORTH - prueft, ob der Spieler beim Springen "oben" mit dem
; Spielfeld kollidiert ist. Dazu werden die "Nord"-Koordinaten (x+2,
; y) und (x+6, y) des Spielers ueberprueft. Hat eine Kollision
; stattgefunden, so wird der "Fallen" Zustand gesetzt und die
; Y-Koordinate wird auf den naechst niedrigeren, durch BLK_HEIGHT
; teilbaren Wert gesetzt.
;
CHKNORTH SUBROUTINE
         LDA   heroState            
         AND   #HERO_JUMPING  ; Springt der Spieler?
         BEQ   .end           ; Nein, also Routine direkt beenden.
         LDA   #2             ; Gibt es eine Kollision zwischen 
         LDY   #0             ; (x+2, y) und Spieldfeld?
         JSR   HEROPF
         BNE   .setstat       ; Ja, also Check fuer 2.Koordinate ueberspringen.
         LDA   #6             ; Nein, also pruefen, ob 2.Koordinate  
.simple  LDY   #0             ; (x+6, y) und Spieldfeld kollidieren?
         JSR   HEROPF
         BEQ   .end           ; Nein auch hier nicht, also Routine beenden.
.setstat LDA   yHeroMSB       ; Ja, also Y-Koordinate auf naechst niedrigeren
         AND   #%11110000     ;  durch BLK_HEIGHT teilbaren Wert setzen...
         STA   yHeroMSB
         JSR   FALLING        ; FALLING liefert im Akku den Wert HERO_FALLING
.end     RTS
;}}}

;{{{
; FALLING - Setzt die Fallgeschwindigkeit auf 0 und den Zustand des Spielers
; auf "Fallen".
;
FALLING  subroutine
         LDA   #0
         STA   ySpeedMSB
         STA   ySpeedLSB
         LDA   #HERO_FALLING
         STA   heroState
         RTS
;}}}

;{{{
; VERTADJ - passt die vertikale Positionierung des uebergebenen Sprites
; an.
;
; Im X-Register wird die Adresse des LSB des Sprite-Pointers erwartet.
; Im Akku wird die Y-Koordinate (Wert des MSB) des Sprites uebergeben.
;
; Die Routine gibt im Y-Register den Wert zurueck, der dann in das
; entsprechende VDELPx Register gesetzt werden kann.
;
VERTADJ  subroutine
         LDY   #0
         LSR
         BCC   .skip
         SEC
         LDA   $00,x
         SBC   #1
         STA   $00,x
         LDA   $01,x
         SBC   #0
         STA   $01,x
         INY
.skip    RTS
;}}}

;{{{
; ADJUST - Passt die Adresse des Sprite-Pointers an die Y-Koordinate des
; Sprites an. Im Akku wird der Offset des Sprites auf der SPRITE_PAGE
; erwartet. Im X-Register wird die Adresse des LSB des Sprite-Pointers
; erwartet. Im Y-Register wird die Y-Koordinate des Sprites erwartet.
;
ADJUST   subroutine
         STY   temp1           
         SEC                  ; Die Y-Koordinate wird 
         SBC   temp1          ;  subtrahiert vom
         STA   $00,x          ;  LSB des Sprite-Pointers.
         LDA   $01,x          ; Vielleicht gab es einen Uebertrag,
         SBC   #0             ;  der subtrahiert werden muss vom 
         STA   $01,x          ;  MSB des Sprite-Pointers.
         LDY   #0
         LDA   #SPRITE_HEIGHT*2
         JSR   ADD16 
         RTS
;}}}

;{{{
; LOADENMY - Abhaengig von der Variable `enemyState', wird der Akku mit
; der Sprite-Nr. des entsprechenden Gegner-Sprites beladen.
;
LOADENMY subroutine
         LDA   enemyState              ; Zustand laden
         TAX                           ; und kurz in X zwischenspeichern.
         AND   #ENEMY_ANIM_MASK        ; Animationsphase freistellen
         TAY                           ; und in Y sichern.
         TXA                           ; Zustand wiederherstellen, 
         AND   #ENEMY_TYPE_MASK        ; um Gegner zu ermitteln.
         CMP   #ENEMY_TUBE             ; Handelt es sich um den Schlauch?
         BCS   .tube                   ; Ja, daher Sprite-Pointer nicht anpassen
         TYA                           ; Nein, daher Pointer fuer 
         CLC                           ; Sprite-Index Tabelle 
         ADC   #7                      ; um die Anzahl von Animationsphasen
         TAY                           ; des Schlauchs verschieben.
.tube    LDA   .enemtbl,y              ; Sprite-Index aus Tabelle lesen
         CMP   #$50                    ; Mittlere Schlauch-Animationsphase?
         BNE   .end                    ; Nein, also Wert direkt zurueckgeben.
         PHA                           ; Ja, also Wert zwischenspeichern
         JSR   INITTSND                ; Sound-FX fuer Schlauch initialisieren
         PLA                           ; Wert wiederherstellen.
.end     RTS                           ; Wert zurueckgeben.
.enemtbl hex   3031404150414031        ; Indizes fuer Schlauch Animationsphasen
         hex   51707170                ; Indizes fuer Ball Animationsphasen
;}}}

;{{{
; LOADHERO - Abhaengig von der Variable `heroState', wird der Akku mit
; einem Wert beladen, der als LSB des `heroSpritePtr' gesetzt werden
; muss.
;
LOADHERO subroutine
         LDA   heroState
         CMP   #%00100000
         BCC   .nowait
         CLC
         ROL
         ROL
         ROL
         ROL
         TAY
         LDA   .waittbl,y
         RTS
.nowait  AND   #HERO_WALKING
         BEQ   .nowalk
         LSR   
         TAY
         LDA   .walktbl,y
         RTS
.nowalk  LDA   #$00        ; Sprite-Adresse fuer Jumping/Falling-Sprite
         RTS
.walktbl hex   0010112021     ; Sprite Indizes fuer die "Gehen"-Animation.
.waittbl hex   0060006100800081 ; Sprite Indizes fuer die "Warten"-Animation.
;}}}

;{{{
; ADD16 - Addiert zwei 16-Bit Zahlen im "Little-Endian" Format. Die
; Adresse des 1.Summanden (LSB) wird im X-Register uebergeben. Das LSB
; des 2.Summanden wird im Akku uebergeben, das MSB des 2.Summand wird im
; Y-Register uebergeben.
; Das Ergebnis der Addition wird in die Adresse des 1.Summanden
; geschrieben. Bei einem Ueberlauf ist das Carry-Flag gesetzt.
;
ADD16    subroutine
         CLC           ;2
         ADC   $00,x   ;4 LSB des 1.Summand zu Akku addieren
         STA   $00,x   ;4 Ergebnis im LSB des 1.Summanden sichern
         TYA           ;2 MSB des 2.Summand in Akku laden
         ADC   $01,x   ;4 MSB 1.Summand zu Akku addieren
         STA   $01,x   ;4 Ergebnis im MSB des 1.Summanden sichern
         RTS           ;6
                       ;= 26
;}}}

;{{{
; NEWLEVEL - Laedt die Daten eines Levels ab der Adresse, die in
; der Variable `temp' uebergeben wurde.
; D.h. der Spieler wird positioniert, die Spielfeld-Daten werden
; geladen, die Farben werden gesetzt, usw.
; Ein kompletter Level ist wie folgt aufgebaut (ACHTUNG es ist
; unbedingt erforderlich, dass sich *alle* Daten eines Levels auf der
; gleichen Speicherseite befinden):
;
;     +-----+---------+----------------------------------+
;     | Pos | Groesse | Beschreibung                     |
;     +-----+---------+----------------------------------+
;     | 1   | 1 Byte  | X-Koordinate des Spielers        |
;     | 2   | 1 Byte  | 1 Byte Y-Koordinate des Spielers |
;     | 3   | 1 Byte  | Farbe des Spielers               |
;     | 4   | 1 Byte  | Farbe der Gegner                 |
;     | 5   | 1 Byte  | Farbe des Levels                 |
;     | 6   | 1 Byte  | Wert fuer levelptroff            |
;     | 7   | 1 Byte  | levelptr Initialwert (zeigt auf  |
;     |     |         | das Ende der Spielfeld-Daten)    |
;     | 8   | n Bytes | Positionen von Gegnern/Objekten  |
;     | 9   | m Bytes | Spielfeld-Daten                  |
;     +-----+-------+------------------------------------+
;
; Diese Routine geht davon aus, dass sie waehrend des Vertical-Blanks
; aufgerufen wurde.
; Diese Routine muss mittels JMP angesprungen werden *nicht* JSR,
; weil sie am Ende kein RTS ausfuehrt, sondern zur Erzeugung des
; Overscan-Signals springt.
;
NEWLEVEL subroutine
         STY   CXCLR                ; Kollisionsregister loeschen
         LDA   #0                   ; Alle volatilen Variablen 
         LDX   #PERSIST-$80         ; im RAM loeschen.
.clearam STA   $7F,x                ; $80 - $1 == $7F
         DEX
         BNE   .clearam
         LDA   #ANIM_SPEED          ; Saemtliche Animations-Timer 
         STA   heroAnimTimer        ; initialisieren    
         STA   enemyAnimTimer
         STA   exitAnimTimer
         JSR   FALLING              ; "Fallen"-Zustand initialisieren
         LDA   level                ; Nun den temp-Pointer mit der
         ASL                        ; Adresse der Leveldaten des 
         TAY                        ; aktuellen Levels beladen.
         LDA   LVPTRS,Y
         STA   temp
         INY
         LDA   LVPTRS,Y
         STA   temp+1
         LDY   #0                   ; Index-Register setzen
         LDA   (temp),Y             ; X-Koordinate der Spielfigur
         STA   xHeroMSB             ; initialisieren. 
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   (temp),Y             ; Y-Koordinate der Spielfigur
         STA   yHeroMSB             ; initialisieren.
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   (temp),Y             ; Farbe des Spielers laden.
         STA   COLUP0_REFP0_COPY    ; Farbe des Spielers zwischenspeichern
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   (temp),Y             ; Farbe der Gegner laden.
         STA   COLUP1_REFP1_COPY    ; Farbe des Gegners zwischenspeichern
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   (temp),Y             ; Farbe des Levels setzen.
         STA   COLUPF                
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   (temp),Y             ; Wert fuer levelptroff setzen.
         STA   levelptroff 
         INY                        ; Pointer auf naechstes Byte setzen.
         LDA   tempMSB              ; Die MSBs der Pointer schonmal mit
         STA   enemyposptr+1        ; der entsprechenden Page initialisieren.
         STA   levelptr+1
         LDA   (temp),Y             ; Initialwert fuer levelptr setzen.
         STA   levelptr
         INY                        ; Pointer auf naechstes Byte setzen.
         TYA                        ; Zum Index (der bei null begonnen hat)
         CLC                        ; wird noch der "Abstand" zum Beginn
         ADC   tempLSB              ; der aktuellen Speicherseite addiert.
         STA   enemyposptr          ; Jetzt LSB der Positionstabelle setzen.
.waitvbl LDA   INTIM                ; Ist der Vertical-Blank schon vorbei?
         BNE   .waitvbl             ; Nein, also weiter warten...
         STA   WSYNC        
         STA   VBLANK               ; Enable beam/stop VBLANK

         LDA   #TEXT_OFFSET_TIM64T  ; Timer fuer NTSC/PAL Bild 
         STA   TIM64T               ; bestuecken, um
         JSR   LOADPF               ; zeitintensives Laden der Spielfeld-Daten
         LDA   #8                   ; waehrend des NTSC/PAL Bilds 
         STA   scroll               ; durchzufuehren.
.waittv  LDA   INTIM                ; Timer checken, NTSC/PAL-Bild vorbei?
         BNE   .waittv              ; Nein, also weiter warten

   IFNCONST NTSC              ; Den Timer konnten wir ja nur mit dem maximal
         JSR   WAITPAL        ; Wert 255 bestuecken, so dass noch 14 Scanlines
   ENDIF                      ; gefehlt haben, die warten wir noch ab.

         JMP   OVERSCAN             ; Ja, also Overscan einleiten
;}}}

;{{{
; NEXTRND - Erzeugt eine neue Zufallszahl und gibt diese im Aku zurueck.
;
NEXTRND  subroutine
         LDA rnd
         LSR
         BCC .skipeor
         EOR #$B4
.skipeor STA rnd
         RTS
;}}}

;{{{
; LEVELPOS - Berechnet die Levelposition (bildlich gesprochen die
; "obere" Levelposition), d.h. es wird Berechnet, welcher Ausschnitt
; des Spielfelds gerade angezeigt wird. Die Position wird im Akku
; zurueckgeliefert.
;
LEVELPOS subroutine
         LDA   levelptr          ; Zunaechst muss vom levelprt
         SEC                     ; der Level-speziefische Offset subtrahiert
         SBC   levelptroff       ; werden. Danach muessen wir diesen
         LSR                     ; "normalisierten" Wert noch durch 2 teilen,
         RTS                     ; da jede Blockreihe durch 2 Bytes defniert 
                                 ; wird.
;}}}

;{{{
; NEXTENEM - Laedt ggf. den naechsten Gegner bzw. das naechste Objekt.
; Guckt in der Tabelle mit den Positionen der Gegner nach, ob ein neuer Gegner
; positioniert werden muss.
; Jede Position besteht aus 2 Bytes. Das 1.Byte beschreibt die logische 
; Y-Koordinate des Gegners, das 2.Byte beschreibt in den Bits D7,D6,D5 welcher
; Gegner bzw. welches Objekt positioniert werden soll und in den verbleibenden
; Bits D4,D3,D2,D1,D0 die logische X-Koordinate.
; Die Positionierung kann uebrigens nur erfolgen, wenn das Level nicht gerade
; gescrollt wird.
;
NEXTENEM subroutine
         JSR   LEVELPOS          ;6 Die "obere" Levelposition laden.
         LDX   #0                ;2 Index initialisieren.
         CMP   (enemyposptr,X)   ;6 Ist "obere" Levelpos > logische Y-Koord?
         BCS   .end              ;3 Ja, daher Routine beenden.
         CLC                     ;2 Nein, daher naechste Pruefung.
         ADC   #11               ;2 Ist die "untere" Levelposition
         TAY                     ;2 Fuer Umrechnung zwischenspeichern.
         CMP   (enemyposptr,X)   ;6 kleiner als die logische Y-Koordinate?
         BCC   .end              ;3 Ja, daher Routine beenden.
         LDA   flag              ;3 Nein, aber wird Spielfeld gerade 
         AND   #SCROLL_FLAG_MASK ;  gescrollt?
         BNE   .end              ;3 Ja, daher Rouine beenden.
         TYA                     ;2 Logische Y-Koordinate in konkrete 
         SEC                     ;2 Screen-Koordinate umrechnen, indem die 
         SBC   (enemyposptr,X)   ;6 logische Y-Koordinate von der 
         ASL                     ;2 unteren Levelposition subtrahiert- 
         ASL                     ;2 und mit 16 multipliziert wird.
         ASL                     ;2
         ASL                     ;2
         TAY                     ;2 Ergebnis im Y-Register sichern.
         INC   enemyposptr       ;5 Pointer auf 2.Byte setzen.
         LDA   (enemyposptr,X)   ;6 Gegner/Objekt 
         AND   #%11100000        ;2 Typ freistellen
         PHA                     ;3 und auf dem Stack sichern.
         LDA   (enemyposptr,X)   ;6 Logische X-Koordinate 
         AND   #%00011111        ;2 freistellen
         ASL                     ;2 und mit 4 multiplizieren.
         ASL                     ;2
         CLC                     ;2 Die 4 Bits des ungenutzten PF0L-Registers 
         ADC   #16               ;2 durch Addition von 16 kompensieren.
         TAX                     ;2 Ergebnis im X-Register sichern.
         INC   enemyposptr       ;5 Pointer auf naechste Position setzen.
         PLA                     ;4 Gegner/Objekt Typ in Akku laden.
         CMP   #TRAP             ;2
         BNE   .gold             ;3
         LDA   #trapcoord        ;2
         JSR   SAVCOORD          ;6
         LDX   #%00110000        ;2 Ein Schuss soll immer 8 Pixel breit sein.
         BNE   .nusiz1           ;3 branch-always
.gold    CMP   #GOLD             ;2
         BNE   .door             ;3
         LDA   #goldcoord        ;2
         JSR   SAVCOORD          ;6
         RTS                     ;6
.door    CMP   #DOOR             ;2
         BNE   .tubebal          ;3
         LDA   #doorcoord        ;2
         JSR   SAVCOORD          ;6
         RTS                     ;6
.tubebal STX   xEnemyMSB         ;3 +15
         STY   yEnemyMSB         ;3
; Achtung hier wird der Wert fuer den Schuss ueberschrieben, daher NUSIZ1 merken
; und hier nur die untersten drei Bits veraendern
         LDX   #%00110000        ;2 Wir muessen den Wert fuer NUSIZ1 
         STA   enemyState        ;3 abhaengig davon setzen, ob es sich um einen
         CMP   #BALL_1           ;2 einzelnen Ball/Schlauch handelt (0) 
         BEQ   .nusiz1           ;3 oder um einen Doppel-Ball/Schlauch (2).
         CMP   #TUBE_1           ;2 Dabei muessen wir natuerlich beachten, dass
         BEQ   .nusiz1           ;3 Ein Schuss immer 8 Pixel breit ist.
         LDX   #%00110010        ;2
.nusiz1  STX   NUSIZ1            ;3
         STX   NUSIZ1_COPY       ;3
.end     RTS                     ;6
;}}}

;{{{
; SAVCOORD - Speichert den Wert im X-Register an die Adresse im Akku.
; Subtrahiert 6 zum Wert im Y-Register und speichert diesen an die
; nachfolgende Adresse.
;
SAVCOORD subroutine
         STA   temp1
         TXA   
         LDX   temp1
         STA   $00,X
         INX
         TYA
         SEC 
         SBC   #6
         STA   $00,X
         RTS
 ;}}}

;{{{
; ENEMYPF - Die folgende Routine prueft, ob es eine Kollision zwischen
; dem Gegner und dem Spielfeld gibt. Zu diesem Zweck wird die Routine
; CHKPFCOL mit den Werten Werten (xEnemyMSB + Akku) und (yEnemyMSB +
; Y-Register) aufgerufen.
; 
ENEMYPF  subroutine
         CLC
         ADC   xEnemyMSB
         TAX
         TYA
         CLC
         ADC   yEnemyMSB
         JSR   CHKPFCOL
         RTS
 ;}}}

;{{{
; HEROPF - Die folgende Routine prueft, ob es eine Kollision zwischen
; dem Spieler und dem Spielfeld gibt. Zu diesem Zweck wird die Routine
; CHKPFCOL mit den Werten Werten (xHeroMSB + Akku) und (yHeroMSB +
; Y-Register) aufgerufen.
; 
HEROPF   subroutine
         CLC
         ADC   xHeroMSB
         TAX
         TYA
         CLC
         ADC   yHeroMSB
         JSR   CHKPFCOL
         RTS
 ;}}}

;{{{
; CHKPFCOL - Prueft, ob der uebergebene Punkt mit dem Spielfeld
; kollidiert. Die X-Koordinate des Punkts wird im X-Register uebergeben,
; die Y-Koordinate im Akkumulator. Bei einer Kollision ist das Zero-Flag
; *nicht* gesetzt (d.h. gesetztes Zero-Flag bedeutet, dass es keine
; Kollision gab)!
;
CHKPFCOL subroutine
         TAY                     ; Y-Koordinate zwischenspeichern
         LDA   flag              ; Scroll-Flag laden  
         AND   #SCROLL_FLAG_MASK ; und freistellen
         CMP   #SCROLL_FLAG_MASK ; Wird das Level gerade gescrollt?
         TYA                     ; vorher Y-Koordinate wiederherstellen
         BCC   .noscrol          ; Nein, Level wird nicht gescrollt.
         LDA   scroll         ; "Scroll-Offset" mit zwei 
         ASL                  ; multiplizieren.
         STA   temp           ; Den Scroll-Offset von 16 (=BLK_HEIGHT)  
         LDA   #BLK_HEIGHT    ; subtrahieren.
         SEC
         SBC   temp
         STA   temp
         TYA                  ; Den ausgerechneten Wert von anfangs uebergebenen
         SEC                  ; Y-Koordinate subtrahieren.
         SBC   temp
.noscrol CPX   #144           ;2 Ist die X-Koordinate >= 144 ?
         BCS   .end           ;2 Ja, also kann es keine Kollision geben.
         CPX   #16            ;2 Ist die X-Koordinate < 16
         BCC   .end           ;2 Ja, also kann es keine Kollision geben.
         CMP   #$B0           ;2 Ist die Y-Koordinate >= 176 ?
         BCS   .end           ;2 Ja, also kann es keine Kollision geben.
         LSR                  ;2 Die Y-Koordinate wird durch 16 geteilt
         LSR                  ;2 (Hoehe einer Blockreihe).
         LSR                  ;2
         LSR                  ;2 
         CLC                  ;2 Da die niedrigsten Blockreihen die hoechsten
         ADC   #-10           ;2 Y-Koordinaten haben, muessen wir den Index 
         EOR   #$FF           ;2 "umdrehen" indem wir 10-index rechnen (hier
         TAY                  ;2 mittels 2er-Komplement). Im Y-Register steht
         INY                  ;2 jetzt der Offset fuer die pfXX-Variablen.
         TXA                  ;2 X-Koordinate in Akku laden
         CMP   #48            ;2 Ist die X-Koordinate < 48?
         BCS   .pf2l          ;  Nein, naechster Check.
         SEC                  ;  Ja, also erstmal 16 subtrahieren (das pf1l
         SBC   #16            ;  bildet die Koordinaten [16-48] ab).
         LDX   pf1l,Y         ;  PF-Register laden.
         JMP   .chkpf1
.pf2l    CMP   #80            ;  Ist die X-Koordinate < 80?
         BCS   .pf0r          ;  Nein, naechster Check.
         SEC                  ;  Ja, also erstmal 48 subtrahieren (das pf2l
         SBC   #48            ;  bildet die Koordinaten [48-80] ab).
         LDX   pf2l,Y         ;  Inhalt d PF-Regs laden, da PF2 von Natur aus
         JMP   .check         ;  schon umgedreht ist, direkt zur Kollisionsabfr
.pf0r    CMP   #96            ;  Ist die X-Koordinate < 96?
         BCS   .pf1r          ;  Nein, naechster Check.
         SEC                  ;  Ja, daher 80 subtrahieren (das pf0r bildet die
         SBC   #80            ;  Koordinaten [80-96] ab, ist ja nur 4-Bit breit)
         LDX   pf0r,Y         ;  Inhalt des PF-Registers laden.
         TAY                  ;  (x-80) im Y-Register zwischenspeichern.
         TXA                  ;  Wert des PF-Registers in Akku laden.
         LSR                  ;  Da vom PF0 nur die Bits D4-D7 verwendet werden
         LSR                  ;  sorgen wir dafuer, dass diese in die Bits D0-D3
         LSR                  ;  verschoben werden (umgedreht ist das PF0 ja von
         LSR                  ;  Natur aus).
         TAX                  ;  Das "verschobene" PF-Register in X laden.
         TYA                  ;  Die "normalisierte" X-Koord wiederherstellen.
         JMP   .check         ;  Kollisionsabfrage durchfuehren.
.pf1r    CMP   #128           
         BCS   .pf2r 
         SEC
         SBC   #96
         LDX   pf1r,Y
.chkpf1  LSR                  ;  Die "normalisierte" X-Koordinate wird durch 4
         LSR                  ;  (Breite eines Blocks) geteilt. Da das PF1-Reg
         CLC                  ;  von links nach rechts angezeigt wird, drehen
         ADC   #-7            ;  wir die Bitreihenfolge um, in dem wir 7-x
         EOR   #$FF           ;  Rechnen (hier mittels 2er-Komplement).
         TAY  
         INY
         TXA
         AND   .bitmask,Y
         RTS
.pf2r    CMP   #144
         BCS   .end
         SEC
         SBC   #128
         LDX   pf2r,Y
.check   LSR                  ;  Die "normalisierte" X-Koordinate wird durch 4
         LSR                  ;  (Breite eines Blocks) geteilt. Dadurch wissen
         TAY                  ;  wir, welches Bit wir ueberpruefen muessen, um
         TXA                  ;  rauszufinden, ob es eine Kollision gab.
         AND   .bitmask,Y     
         RTS
.end     LDA   #0
         RTS
.bitmask .byte #%00000001
         .byte #%00000010
         .byte #%00000100
         .byte #%00001000
         .byte #%00010000
         .byte #%00100000
         .byte #%01000000
         .byte #%10000000
;}}}

;{{{
; SCRLDOWN - 
;
SCRLDOWN subroutine
         DEC   yHeroMSB          ;5
         DEC   yHeroMSB          ;5
         DEC   yEnemyMSB         ;5
         DEC   yEnemyMSB         ;5
         DEC   goldY             ;5
         DEC   goldY             ;5
         DEC   trapY             ;5
         DEC   trapY             ;5
         DEC   doorY             ;5
         DEC   doorY             ;5
         LDA   #BLK_HEIGHT/2     ;2
         CMP   scroll            ;3
         BNE   .skip             ;2
         LDA   #0                ;2
         STA   scroll            ;3
         JSR   SCRLBLKR          ;6    +587
         JSR   BLOCKROW          ;6    +643
         JSR   CONVTOPF          ;6    +59
.skip    INC   scroll            ;5
         LDA   scroll            ;3
         CMP   #BLK_HEIGHT/2     ;2
         BNE   .end              ;2
         LDA   flag                 ; Scroll-Flag ausschalten
         AND   #DISABLE_SCROLL_FLAG
         STA   flag
.end     RTS                     ;6    103
;}}}

;{{{
; BLOCKROW - Laedt die naechste Blockreihe
;
; Die Spielfelddaten sind im Speicher zeilenweise abgelegt (mit Zeile ist hier
; eine Blockreihe gemeint). Dabei steht die oberste Blockreihe am Anfang des
; Speichers und die unterste Blockreihe (dort wo das Level beginnt) am Ende.
; D.h. die Spielfelddaten muessen von hinten nach vorne ausgelesen werden.
;
; Eine Blockreihe besteht aus 32 Bits, allerdings verwenden wir nur die halbe
; Aufloesung (d.h. jeder Block einer Blockreihe ist 2 Bit breit). Dadurch kann
; eine Blockreihe durch genau zwei Bytes definiert werden.
;
; Die folgende Routine laedt die beiden Bytes, die hinter dem `levelptr' 
; stehen, verdoppelt jedes Bit, und schiebt die Bits in die temporaeren 
; Variablen pos1, pos2, pos3 und pos4.
;
BLOCKROW subroutine
         LDY   #2             ; Index fuer levelptr initialisieren.
         LDA   #8             ; Bit-Counter initialisieren und in 
         STA   temp1          ; temp1 ablegen.
         LDA   (levelptr),Y   ; 1.Level-Byte laden.
.loop1   LSR                  ; Carry-Flag mit aktuellem Bit bestuecken.
         PHP                  ; Carry-Bit auf dem Stack sichern.
         ROR   pos3           ; Carry-Bit in die temporaeren Variablen 
         ROR   pos4           ; pos3 und pos4 schieben.
         PLP                  ; Carry-Bit wiederherstellen und nochmal 
         ROR   pos3           ; in die temporaeren Variablen pos3 und pos4
         ROR   pos4           ; schieben (ein Block ist immer 2 Bit breit).
         DEC   temp1          ; Haben wir alle Bits verdoppelt?
         BNE   .loop1         ; Nein, weiter mit naechstem Bit.
         LDA   #8             ; Ja, Bit-Counter fuer naechstes Level-Byte
         STA   temp1          ; initialisieren und in temp1 ablegen.
         DEY                  ; Naechstes Level-Byte laden.
         LDA   (levelptr),Y   ; 
.loop2   LSR                  ; Carry-Flag mit aktuellem Bit bestuecken.
         PHP                  ; Carry-Bit auf dem Stack sichern.
         ROR   pos1           ; Carry-Bit in die temporaeren Variablen
         ROR   pos2           ; pos1 und pos2 schieben.
         PLP                  ; Carry-Bit wiederherstellen und nochmal in
         ROR   pos1           ; die temporaeren Variablen pos1 und pos2 
         ROR   pos2           ; schieben.
         DEC   temp1          ; Haben wir alle Bits verdoppelt?
         BNE   .loop2         ; Nein, weiter mit naechstem Bit.
         DEC   levelptr       ; Ja, daher levelptr 2 Bytes Richtung
         DEC   levelptr       ; Anfang verschieben.
         RTS
;}}}

;{{{
; LOADPF - Laedt einen kompletten Spielfeld-Ausschnitt
;
LOADPF  subroutine
        LDA   #PFREGS-1
        STA   temp2
.loop   JSR   SCRLBLKR
        JSR   BLOCKROW
        JSR   CONVTOPF
        DEC   temp2
        BNE   .loop
        RTS
;}}}

;{{{
; SCRLBLKR - Diese Routine scrollt das Spielfeld nach oben. Zu diesem
; Zweck werden saemtliche Blockreihen eine Position nach unten kopiert.
;
SCRLBLKR subroutine
         LDX   #10         ;2 Initialisierung Quellindex
         LDY   #11         ;2 Initialisierung Zielindex
.loop    LDA   pf1l,X      ;4 
         STA   pf1l,Y      ;5
         LDA   pf2l,X      ;4
         STA   pf2l,Y      ;5
         LDA   pf0r,X      ;4
         STA   pf0r,Y      ;5
         LDA   pf1r,X      ;4
         STA   pf1r,Y      ;5
         LDA   pf2r,X      ;4
         STA   pf2r,Y      ;5
         DEX               ;2
         DEY               ;2  (11*52) + 10 = 582
         BNE   .loop       ;3/2
         RTS               ;6
;}}}

;{{{
; CONVTOPF - Die logischen Grafiken in pos1..pos4 werden in die
; technischen Register pf1l..pf2r geschrieben.
;
; +----------+----------+----------+----------+
; |   pos1   |   pos2   |   pos3   |   pos4   |
; +----------+----------+----------+----------+
; |   pf1l   |   pf2l   | pf0r|  r1fp   | pf2r|
; +----------+----------+----------+----------+
;    
; Zu beachten ist, dass das Hi-Nibble von pos4 als Hi-Nibble von
; pf1r verwendet wird und das Lo-Nibble von pos3 als Lo-Nibble von
; pf1r verwendet wird (wird im Diagramm durch die spiegelverkehrte
; Schreibweise von pf1r angedeutet).
;
CONVTOPF subroutine
         LDA   pos1
         STA   pf1l
         LDA   pos2
         STA   pf2l
         LDA   pos3
         AND   #%11110000
         STA   pf0r
         LDA   pos3
         AND   #%00001111
         STA   pf1r
         LDA   pos4
         AND   #%11110000
         ORA   pf1r
         STA   pf1r
         LDA   pos4
         AND   #%00001111
         STA   pf2r
         RTS
;}}}

;{{{
; VBLNKEND - Wartet auf das Ende des Vertical-Blank
;
VBLNKEND subroutine
         LDA   INTIM          ; Timer checken, Vertical-Blank schon vorbei?
         BNE   VBLNKEND       ; Nein, also weiter warten
         STA   WSYNC        
         STA   VBLANK         ; Enable beam/stop VBLANK
         RTS
;}}}

;{{{
; OVRSCEND - Wartet auf das Ende der Overscan-Periode
; 
OVRSCEND subroutine
         LDA   INTIM             ; Timer checken, ist Overscan schon vorbei?
         BNE   OVRSCEND          ; Nein, also weiter warten
         STA   WSYNC             
         RTS
;}}}

;{{{
; OVRSCBEG - Leitet die Overscan-Periode ein
; 
OVRSCBEG subroutine
         LDA   #$42           ; Overscan einleiten
         LDA   #%01000010
         STA   VBLANK
         LDA   #OVRSCBEG_TIM64T            
         STA   TIM64T         ; Timer setzen
         RTS
;}}}

;{{{
; TITLEPTR - setzt die sprite6-Pointer fuer den Titelbildschirm.
; Die Basisadresse der Speicherseite auf der sich die Sprite-Daten
; befinden, werden im Y-Register uebergeben.
; Der Index auf die Daten des 6ten Sprites werden im Akku uebergeben.
; Die Hoehe der Sprites wird in der Variablen sprite6_height uebergeben.
;
TITLEPTR subroutine
         LDX   #10               
.setptr  STA   sprite6_ptr1,X    
         STY   sprite6_ptr1+1,X  
         SEC 
         SBC   sprite6_height
         DEX
         DEX
         BPL   .setptr           
         RTS
;}}}

;{{{
; TITLSCRN - Diese Routine zeigt den Titel-Screen solange an, bis der
; Feuerknopf gedrueckt wurde
;
TITLSCRN subroutine
         JSR   VBLNKEND                ; und abwarten... 

         LDA   #TEXT_OFFSET_TIM64T     ; Timer fuer NTSC/PAL Bild
         STA   TIM64T                  ; bestuecken

         LDY   #TITLSCRN_TIM64T        ; Einige Scanlines abwarten,  
.wait    STA   WSYNC                   ; bevor wir den Text angezeigen... 
         DEY                  
         BNE   .wait

         LDA   #$0F           
         STA   sprite6_color
         LDA   #32            ; Jetzt die "BLINKY goes up" Grafik 
         STA   sprite6_height ; anzeigen.
         LDY   #>TITLE_PAGE_1 ; Dazu die Basisadresse der Speicherseite
         LDA   #<BLINKY6      ; und die Index-Adresse des letzten der 6 Sprites
         JSR   TITLEPTR       ; laden.
         JSR   SPRITE6

         LDA   #5             ; Jetzt die "MMXII" Grafik
         STA   sprite6_height ; anzeigen.
         LDY   #>TITLE_PAGE_2 ; Dazu die Basisadresse der Speicherseite
         LDA   #<MMXII6       ; und die Index-Adresse des letzten der 6 Sprites
         JSR   TITLEPTR       ; laden.
         JSR   SPRITE6
         LDA   #TITLSCRN_COLOR
         STA   sprite6_color
         LDA   #5             ; Jetzt die "Jan Hermanns" Grafik
         STA   sprite6_height ; anzeigen.
         LDY   #>TITLE_PAGE_1 ; Dazu die Basisadresse der Speicherseite
         LDA   #<JAN6         ; und die Index-Adresse des letzten der 6 Sprites
         JSR   TITLEPTR       ; laden.
         JSR   SPRITE6


.waittv  LDA   INTIM          ; Timer checken, NTSC/PAL-Bild vorbei?
         BNE   .waittv        ; Nein, also weiter warten...

   IFNCONST NTSC              ; Den Timer konnten wir ja nur mit dem maximal
         JSR   WAITPAL        ; Wert 255 bestuecken, so dass noch 14 Scanlines
   ENDIF                      ; gefehlt haben, die warten wir noch ab.
         JSR   OVRSVBL

         LDA   fireDebounceTimer ; Ist der Feuerknopf "entprellt"? 
         BEQ   .chkfire          ; Ja, also Feuerknopf ueberpruefen. 
         DEC   fireDebounceTimer ; Nein, Timer weiter runterzaehlen.
         BPL   TITLSCRN          ; branch-always

.chkfire LDA   INPT4          ; Wurde der Feuerknopf gedrueckt?
         BMI   TITLSCRN       ; Nein, weiter Titelbild anzeigen.
         LDA   flag           ; Im flag signalisieren, dass ein neues
         ORA   #NEW_GAME      ; Spiel gestartet werden soll.
         STA   flag
         JMP   NEWGAME
;}}}

;{{{
; LEVELEND - Kuemmert sich um die Darstellung, wenn der Spieler gerade
; ein Level erfolgreich beendet hat. Zwischen zwei Levels wird naemlich
; fuer kurze Zeit der Text "NEXT LEVEL" in der Mitte des Bildschirms
; eingeblendet.
;
LEVELEND subroutine
         LDA   flag                 ; Levelend-Flag laden und 
         AND   #LVLEND_FLAG_MASK    ; freistellen. Level beendet?
         BNE   .showtxt             ; Ja, also "NEXT LEVEL" anzeigen.
         RTS                        ; Nein, also Routine beenden.

.showtxt LDA   #0                   ; Sound leise drehen
         STA   AUDV0
         STA   AUDV1

         JSR   VBLNKEND             ; Vertical-Blank abwarten... 

         LDA   #TEXT_OFFSET_TIM64T     ; Timer fuer NTSC/PAL Bild 
         STA   TIM64T                  ; bestuecken.

         LDY   #LEVELEND_TIM64T        ; Jetzt einige Scanlines abwarten,
.wait    STA   WSYNC                   ; bevor der Text angezeigt wird...
         DEY                         
         BNE   .wait

         LDA   levelendAnimTimer    ; Wenn der Timer den Wert $0F erreicht 
         CMP   #$0F                 ; hat, dann benutzen wir in als Farbe,
         BCC   .setcolo             ; um einen Fade-Out Effekt zu erzeugen.
         LDA   #$0F
.setcolo STA   sprite6_color        
         LDA   #5
         STA   sprite6_height
         LDY   #>TITLE_PAGE_1       ; Basisadresse der Speicherseite
         LDA   #<NL6                ; Index Adresse des letzten Sprites setzen
         JSR   TITLEPTR             ; Jetzt die 6 Sprite-Ptr setzen und 
         JSR   SPRITE6              ; dann die "NEXT LEVEL" Sprites anzeigen

.waittv  LDA   INTIM                ; Timer checken, NTSC/PAL-Bild vorbei?
         BNE   .waittv              ; Nein, also weiter warten...

   IFNCONST NTSC           ; Den Timer konnten wir ja nur mit dem maximal
         JSR   WAITPAL     ; Wert 255 bestuecken, so dass noch 14 Scanlines
   ENDIF                   ; gefehlt haben, die warten wir noch ab.

         JSR   OVRSVBL 

         DEC   levelendAnimTimer       ; Ist der Animations-Timer abgelaufen?
         BNE   .showtxt                ; Nein, also Text weiterhin anzeigen
         LDA   flag                    ; Ja, daher Levelend-Flag
         AND   #DISABLE_LVLEND_FLAG    ; ausschalten
         STA   flag
         INC   level                   ; und den naechsten Level
         JMP   NEWLEVEL                ; laden...
;}}}

;{{{ 
; WAITPAL - Diese Routine wartet genau 13 Scanlines ab.
WAITPAL subroutine
         LDY   #13            
.loop    STA   WSYNC         
         DEY       
         BNE   .loop
         RTS
;}}}

;{{{ 
; Setup Routinen fuer Sounds auf Audiokanal 0
; INITBSND - Setup fuer Ball-Sound Routine
; INITTSND - Setup fuer Tube-Sound Routine
;
INITBSND subroutine
         LDA   #BALL_SOUND
         STA   temp
         LDA   #12
         LDX   #%00011111  
         LDY   #15
         BNE   .setregs       ; branch-always

INITTSND LDA   #TUBE_SOUND
         STA   temp
         LDA   #8
         LDX   #%00001111
         LDY   #4

.setregs STA   AUDC0
         STX   freq0
         STY   vol0
         LDA   sounds
         AND   #CLEAR_SND0
         ORA   temp
         STA   sounds
         RTS
;}}}

;{{{ 
; Setup Routinen fuer Sounds auf Audiokanal 1
; INITLSND - Setup fuer Laser-Sound Routine
; INITGSND - Setup fuer Gold-Sound Routine
; INITESND - Setup fuer Extraleben-Sound Routine
;
INITLSND subroutine
         LDA   #LASER_SOUND
         STA   temp
         LDX   #%00001111  
         LDY   #9
         BNE   .setregs       ; branch-always

INITGSND LDA   #GOLD_SOUND
         STA   temp
         LDX   #%00001111  
         LDY   #10
         BNE   .setregs       ; branch-always

INITESND LDA   #EXTRA_SOUND
         STA   temp
         LDX   #0
         LDY   #10

.setregs LDA   #4             ; LASER-, GOLD- u EXTRA-Snd verw. gleiches Instr.
         STA   AUDC1
         STX   freq1
         STY   vol1
         LDA   sounds
         AND   #CLEAR_SND1
         ORA   temp
         STA   sounds
         RTS
;}}}

;{{{ 
; LASERSND - Spielt den Soundeffekt fuer den Schuss ab.
;
LASERSND subroutine
         LDA   vol1        ; Lautstaerke fuer Audiokanal 0
         BEQ   .end        ; Ist die Lautstaerke 0?
         DEC   vol1        ; Nein, also Lautstaerke dekrementieren.
         INC   freq1       ; Frequenz fuer Audiokanal 0 inkrementieren.
         INC   freq1       ; Frequenz fuer Audiokanal 0 inkrementieren.
.end     JMP   AUDIO1
;}}}

   echo "Free mem before ENDSCREEN [", *, "-", ENDSCREEN, "] =", (ENDSCREEN - *), "bytes" 

         ORG ENDSCREEN

;{{{
; Wendet die Gravitation auf die Spielfigur an. Ist die Spielfigur
; am Springen, benutzen wir einen niedrigeren Gravitationswert (das
; ist zwar physikalisch voelliger Bloedsinn, fuehlt sich aber bei der
; Steuerung der Figur besser an).
;
GRAVITAT subroutine
         LDA   ySpeedMSB            ; Aktuelle Fallgeschindigkeit laden.
         CMP   #$F9                 ; Ist die max Fallgeschwindigkeit erreicht?
         BMI   .nospeed             ; Ja, also Geschwdk. so lassen wie sie ist
         LDA   #GRAVITY_CONST_FALL  ; "default" Gravitationswert laden.
         LDX   #HERO_JUMPING        ; Spielerzustand ueberpruefen
         CPX   heroState            ; Ist der Spieler am Springen?
         BNE   .skip                ; Nein, also "default" Gravitation benutzen
         LDA   #GRAVITY_CONST_JUMP  ; Ja, also niedrigere Gravitation verwenden
.skip    LDY   #$FF                 ; Von der Fallgeschwindigkeit
         LDX   #<heroSpeedY         ; des Spielers
         JSR   ADD16                ; die Gravitation subtrahieren.
.nospeed RTS
;}}}

;{{{
; ENDSCREEN Grafiken
;
ENDSCR1  .byte #%01000100
         .byte #%01001010
         .byte #%01001010
         .byte #%10101010
         .byte #%10100100
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%01100100
         .byte #%10001010
         .byte #%10001010
         .byte #%10001010
         .byte #%01100100

         .byte #%01100010
         .byte #%10100010
         .byte #%10100010
         .byte #%10100010
         .byte #%10100011
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%10100110
         .byte #%10101010
         .byte #%10101010
         .byte #%10101000
         .byte #%11000110

         .byte #%10101010
         .byte #%10101010
         .byte #%10101110
         .byte #%10101010
         .byte #%01000100
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%10101010
         .byte #%10101010
         .byte #%11001110
         .byte #%10101010
         .byte #%11000100

         .byte #%11001110
         .byte #%10101000
         .byte #%10101100
         .byte #%10101000
         .byte #%11001110
         .byte #%00000000
         .byte #%00000000
         .byte #%00000001
         .byte #%01001100
         .byte #%01000010
         .byte #%01000100
         .byte #%01001000
         .byte #%11100110

         .byte #%00100100
         .byte #%00100100
         .byte #%00100100
         .byte #%00100100
         .byte #%00101110
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%10000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

ENDSCR6  .byte #%10000000
         .byte #%00000000
         .byte #%10000000
         .byte #%10000000
         .byte #%10000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

         .byte #%11111111
         .byte #%10011110
         .byte #%10011110
         .byte #%10000010
         .byte #%10011010
         .byte #%10000010
         .byte #%11111111

         .byte #%11111111
         .byte #%00001001
         .byte #%01111001
         .byte #%00011000
         .byte #%01111001
         .byte #%00001000
         .byte #%11111111

         .byte #%11111111
         .byte #%10100111
         .byte #%01100111
         .byte #%00100000
         .byte #%10100111
         .byte #%00100000
         .byte #%11111111

         .byte #%11111111
         .byte #%10000010
         .byte #%10011110
         .byte #%10000010
         .byte #%10011110
         .byte #%10000010
         .byte #%11111111

         .byte #%11111111
         .byte #%00001110
         .byte #%01111110
         .byte #%01111110
         .byte #%01111110
         .byte #%00001000
         .byte #%11111111

PERFECT6 .byte #%11110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%00010000
         .byte #%11110000
;}}}

;{{{
; LEVEL4
   IFCONST NTSC
LEVEL4   hex 3050FF0802  ; 5
   ELSE
LEVEL4   hex 30502F0802  ; 5
   ENDIF
         hex A9            ; 1 ($A9 == (5 + 1 + 1 + 20 - 2) + 144)
         hex F8            ; 1 ($F8 == (5 + 1 + 1 + 20 + 77) + 144) 
         hex 25DC23B81D6617DB17A2123212C40AA208DC04FE ; 20
         hex 0000000000000000000000001A961FFF1FFF94A294A28002FFEE000200330037
         hex 003F520073001300FFC8FFC8FFC8FFFE8002A56BBFFF8000E00000000000
         hex 1F400000001200130013A553FF53FF42FFFF 
;}}}

   echo "Free mem before TITLE_PAGE_1 [", *, "-", TITLE_PAGE_1, "] =", (TITLE_PAGE_1 - *), "bytes" 

;{{{
; ----- T I T E L - S C R E E N - G F X --------------------------------------

         ORG TITLE_PAGE_1

         .byte #%11111111
         .byte #%11100000
         .byte #%11100110
         .byte #%11100100
         .byte #%11100111
         .byte #%11100000
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%11111111
         .byte #%11111111
         .byte #%11111111
         .byte #%11100011
         .byte #%11100001
         .byte #%11100001
         .byte #%11100011
         .byte #%11111111
         .byte #%11111111
         .byte #%11111111
         .byte #%11100011
         .byte #%11100001
         .byte #%11100011
         .byte #%11111111
         .byte #%11111111
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

         .byte #%11111111
         .byte #%10000010
         .byte #%10011010
         .byte #%10011010
         .byte #%10011010
         .byte #%10000010
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%00011111
         .byte #%00011111
         .byte #%00011111
         .byte #%10011110
         .byte #%11011110
         .byte #%11111110
         .byte #%11111110
         .byte #%11111110
         .byte #%11011110
         .byte #%10011110
         .byte #%00011110
         .byte #%10011110
         .byte #%11011110
         .byte #%11011110
         .byte #%11011110
         .byte #%11011110
         .byte #%10011110
         .byte #%00011110
         .byte #%00011110
         .byte #%00011110
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

         .byte #%11111111
         .byte #%00001000
         .byte #%01111111
         .byte #%00011000
         .byte #%01111001
         .byte #%00001000
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%11111111
         .byte #%11111111
         .byte #%11111111
         .byte #%00000111
         .byte #%00000111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110111
         .byte #%00000111
         .byte #%00000111
         .byte #%01110111
         .byte #%01110111
         .byte #%01110000

         .byte #%11111111
         .byte #%00111111
         .byte #%10111111
         .byte #%00111111
         .byte #%11111111
         .byte #%00111111
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00001110
         .byte #%00001110
         .byte #%00011110
         .byte #%00011110
         .byte #%00011110
         .byte #%00011110
         .byte #%00111110
         .byte #%00111110
         .byte #%01101110
         .byte #%01101110
         .byte #%01101110
         .byte #%01101110
         .byte #%11001110
         .byte #%11001110
         .byte #%10001110
         .byte #%10001110
         .byte #%10001110
         .byte #%10001110
         .byte #%00001110
         .byte #%00001110
         .byte #%00000000

         .byte #%11111111
         .byte #%10000010
         .byte #%10011010
         .byte #%10011010
         .byte #%10011010
         .byte #%10011010
         .byte #%11111111
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%11100111
         .byte #%11100111
         .byte #%11101110
         .byte #%11101110
         .byte #%11101100
         .byte #%11111100
         .byte #%11111001
         .byte #%11111001
         .byte #%11111101
         .byte #%11101111
         .byte #%11101111
         .byte #%11101110
         .byte #%11101110
         .byte #%11100111
         .byte #%11100111
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

BLINKY6  .byte #%11111110
         .byte #%01111110
         .byte #%01111110
         .byte #%00001110
         .byte #%01101110
         .byte #%00001110
         .byte #%11111110
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%01110000
         .byte #%11111000
         .byte #%11011000
         .byte #%11011100
         .byte #%11011100
         .byte #%10001100
         .byte #%10001110
         .byte #%10001110
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000
         .byte #%00000000

         .byte #%00000101
         .byte #%00000101
         .byte #%00000101
         .byte #%00000101
         .byte #%00000110

         .byte #%01110101
         .byte #%01000101
         .byte #%01100010
         .byte #%01000101
         .byte #%01110101

         .byte #%00100000
         .byte #%00100000
         .byte #%00100000
         .byte #%00100000
         .byte #%01110000

         .byte #%11101110
         .byte #%10001000
         .byte #%10001100
         .byte #%10001000
         .byte #%10001110

         .byte #%01001110
         .byte #%10101000
         .byte #%10101100
         .byte #%10101000
         .byte #%10101110

NL6      .byte #%11100000
         .byte #%10000000
         .byte #%10000000
         .byte #%10000000
         .byte #%10000000

JAN1     .byte #%01001010
         .byte #%10101010
         .byte #%00101110
         .byte #%00101010
         .byte #%01100100

JAN2     .byte #%10100001
         .byte #%10100001
         .byte #%10100001
         .byte #%10100001
         .byte #%11000001

JAN3     .byte #%01011101
         .byte #%01010001
         .byte #%11011001
         .byte #%01010001
         .byte #%01011101

JAN4     .byte #%01010101
         .byte #%01010101
         .byte #%10010101
         .byte #%01010101
         .byte #%10011010

JAN5     .byte #%01010101
         .byte #%01010101
         .byte #%01110101
         .byte #%01010101
         .byte #%00100110

JAN6     .byte #%01010110
         .byte #%01010001
         .byte #%01010010
         .byte #%01010100
         .byte #%01100011

;LOV3MA_1 .byte #%11100110
;         .byte #%10001001
;         .byte #%10001001
;         .byte #%10001001
;         .byte #%10000110
;
;LOV3MA_2 .byte #%00010011
;         .byte #%00101000
;         .byte #%01001001
;         .byte #%01001000
;         .byte #%01001011
;
;LOV3MA_3 .byte #%10010001
;         .byte #%01010001
;         .byte #%10010101
;         .byte #%01011011
;         .byte #%10010001
;
;LOV3MA_4 .byte #%01010011
;         .byte #%01010100
;         .byte #%01110100
;         .byte #%01010100
;         .byte #%00100011
;
;LOV3MA_5 .byte #%01001010
;         .byte #%01001010
;         .byte #%01111010
;         .byte #%01001010
;         .byte #%01001010
;
;LOV3MA_6 .byte #%10010111
;         .byte #%10010100
;         .byte #%10110110
;         .byte #%11010100
;         .byte #%10010111
;}}}

;{{{
; Die folgende Tabelle enthaelt die 4 Farben in denen die Lebensanzeige
; dargestellt wird (abhaengig davon wieviel Gold der Spieler
; eingesammelt hat).
;
   IFCONST NTSC
GOLDCOL  hex 1B43C686
   ELSE
GOLDCOL  hex 2F6252D2
   ENDIF
;}}}
    
   echo "Free mem before TITLE_PAGE_2 [", *, "-", TITLE_PAGE_2, "] =", (TITLE_PAGE_2 - *), "bytes" 

         ORG TITLE_PAGE_2

;{{{
; ENDSCRN - Diese Routine zeigt den End-Screen solange an, bis der
; Feuerknopf gedrueckt wurde
;
ENDSCRN  subroutine
         JSR   VBLNKEND                ; und abwarten... 

         LDA   #TEXT_OFFSET_TIM64T     ; Timer fuer NTSC/PAL Bild
         STA   TIM64T                  ; bestuecken

         LDY   #ENDSCRN_TIM64T         ; Jetzt einige Scanlines abwarten
.wait    STA   WSYNC                   ; bevor der Text angezeigt wird...
         DEY                   
         BNE   .wait

         LDA   #$0F
         STA   sprite6_color
         LDA   #13
         STA   sprite6_height
         LDY   #>ENDSCREEN    ; Basisadresse der Speicherseite
         LDA   #<ENDSCR6      ; Index Adresse des letzten der 6 Sprites
         JSR   TITLEPTR
         JSR   SPRITE6
         
         LDA   goldcnt         ; Hat der Spieler ein perfektes Spiel gespielt
         CMP   #MAXGOLD        ; (alles Gold gesammelt u kein Leben verloren)?
         BNE   .waittv         ; Nein

         LDA   #7             ; Ja, daher PERFECT anzeigen
         STA   sprite6_height
         LDY   #>ENDSCREEN    ; Basisadresse der Speicherseite
         LDA   #<PERFECT6     ; Index Adresse des letzten der 6 Sprites
         JSR   TITLEPTR
         JSR   SPRITE6

.waittv  LDA   INTIM          ; Timer checken, NTSC/PAL-Bild vorbei?
         BNE   .waittv        ; Nein, also weiter warten...

   IFNCONST NTSC              ; Den Timer konnten wir ja nur mit dem maximal
         JSR   WAITPAL        ; Wert 255 bestuecken, so dass noch 14 Scanlines
   ENDIF                      ; gefehlt haben, die warten wir noch ab.

         JSR   OVRSVBL

         LDA   INPT4          ; Wurde der Feuerknopf gedrueckt?
         BMI   ENDSCRN        ; Nein, weiter Endbild anzeigen.
         LDA   #20
         STA   fireDebounceTimer
         JMP   TITLSCRN       ; Ja, also Titelbild anzeigen.
;}}}

;{{{
; ----- MMXII --------------------------------------------------------

   .byte #%00000000
   .byte #%00000000
   .byte #%00000000
   .byte #%00000000
   .byte #%00000000

   .byte #%00000101
   .byte #%00000101
   .byte #%00000101
   .byte #%00000101
   .byte #%00000110

   .byte #%01010101
   .byte #%01010101
   .byte #%01010101
   .byte #%01010101
   .byte #%10011010

   .byte #%01010111
   .byte #%01010010
   .byte #%00100010
   .byte #%01010010
   .byte #%01010111

   .byte #%11000000
   .byte #%10000000
   .byte #%10000000
   .byte #%10000000
   .byte #%11000000

MMXII6   .byte #%00000000
   .byte #%00000000
   .byte #%00000000
   .byte #%00000000
   .byte #%00000000
;}}}

         ORG $FD8A   ; Das ist noetig wegen PAL/NTSC

;{{{
; LEVEL2
   IFCONST NTSC
LEVEL2   hex 5930FFA8A2  ; 5
   ELSE
LEVEL2   hex 59302F9892  ; 5
   ENDIF
         hex 9D          ; 1 (5 + 1 + 1 + 14 - 2) + 138
         hex F4          ; 1 (5 + 1 + 1 + 14 + 85) + 138
         hex 216921C516BB15C3146909D403E1 ; 14
         hex 00000000000000000000A5788000800280038000800080CC80008000F1008000
         hex 800080CC80028003801380338FFFC002E002FFFE8002800280038013B737
         hex 80028002E0028002FF0280378037803788FFF002F002F002FFFF
;}}}


   echo "Free mem before SPRITE_PAGE [", *, "-", SPRITE_PAGE, "] =", (SPRITE_PAGE - *), "bytes" 

         ORG SPRITE_PAGE

;{{{
; ----- S P R I T E S --------------------------------------------------------
Sprites
	.byte #%10000000     ; FE00 JumpingHeroSprite 
	.byte #%01111000     ; FE01 WaitingHeroSprite
	.byte #%11100000
	.byte #%00110000
	.byte #%00111100
	.byte #%00110000
	.byte #%00110100
	.byte #%00110000
	.byte #%00110000
	.byte #%01111000
	.byte #%01110000
	.byte #%01001000
	.byte #%01111000
	.byte #%01111000
	.byte #%00110000
	.byte #%00100000
	.byte #%00110000     ; FE10 WalkingHeroSprite 1
	.byte #%01100000     ; FE11 WalkingHeroSprite 2
	.byte #%01110000
	.byte #%01101000
	.byte #%00110000
	.byte #%00110100
	.byte #%00110000
	.byte #%00110100
	.byte #%01111000
	.byte #%00110000
	.byte #%01111000
	.byte #%01110000
	.byte #%01111000
	.byte #%01111000
	.byte #%00100000
	.byte #%00100000
	.byte #%11001110     ; FE20 WalkingHeroSprite 3
	.byte #%10011000     ; FE21 WalkingHeroSprite 4
	.byte #%01111100
	.byte #%11111000
	.byte #%00111000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%01111000
	.byte #%01110000
	.byte #%01111000
	.byte #%01111000
	.byte #%00110000
	.byte #%00110000
	.byte #%00000000

Enemy
	.byte #%00001111    ;FE30   Schlauch 1
	.byte #%00001111    ;FE31   Schlauch 2
	.byte #%00000110
	.byte #%00000110
	.byte #%00000110
	.byte #%00000110
	.byte #%00000110
	.byte #%00001100
	.byte #%00000110
	.byte #%00001100
	.byte #%00000110
	.byte #%00011000
	.byte #%00000110
	.byte #%00110000
	.byte #%00000010    
	.byte #%00010000

	.byte #%00001111  ;FE40    Schlauch 3
	.byte #%00001111  ;FE41    Schlauch 4
	.byte #%00000110
	.byte #%01000110
	.byte #%00000110
	.byte #%11100110
	.byte #%00001100
	.byte #%00111110
	.byte #%11111100
	.byte #%00011100
	.byte #%01111000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000

	.byte #%11100111  ;FE50    Schlauch 5
	.byte #%00000000  ;FE51 Ball 1
	.byte #%01100110
	.byte #%00111100
	.byte #%01111110
	.byte #%01111110
	.byte #%00111100
	.byte #%01111110
	.byte #%00000000
	.byte #%01011110
	.byte #%00000000
	.byte #%01001110
	.byte #%00000000
	.byte #%00111100
	.byte #%00000000
	.byte #%00000000

	.byte #%01111000     ; FE60 WaitingHeroSprite 1
	.byte #%01111000     ; FE61 WaitingHeroSprite 2
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%01111000
	.byte #%01111000
	.byte #%01001000
	.byte #%01111000
	.byte #%01111000
	.byte #%01111000
	.byte #%00100000
	.byte #%00100000

	.byte #%00111100    ; FE70 Ball 2
	.byte #%01111110    ; FE71 Ball 3
	.byte #%01111110
	.byte #%01001110
	.byte #%01111110
	.byte #%00111100
	.byte #%01001110
	.byte #%00000000
	.byte #%00111100
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000
	.byte #%00000000

	.byte #%01110000     ; FE80 WaitingHeroSprite 3
	.byte #%01110000     ; FE81 WaitingHeroSprite 4
	.byte #%00111000
	.byte #%00111000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%00110000
	.byte #%01111000
	.byte #%01111000
	.byte #%01001000
	.byte #%01111000
	.byte #%01111000
	.byte #%01111000
	.byte #%00100000
	.byte #%00100000

; Sprites fuer die Darstellung der Lebensanzeige
;
LIFE     .byte #%00111110
         .byte #%01111111
         .byte #%00111110
LOSTLIFE .byte #%00000000
         .byte #%00000000
         .byte #%00000000
;}}}

;{{{ 
; LEVEL5
   IFCONST NTSC
LEVEL5   hex 4930FF4842  ; 5
   ELSE
LEVEL5   hex 49302F6862  ; 5
   ENDIF
         hex AD          ; 1 (5 + 1 + 1 + 18 - 2) + 150
         hex FC          ; 1 (5 + 1 + 1 + 18 + 77) + 150
         hex 22CF212E1FAD14CF11A10D6E0ACF02EF024A ; 18
         hex 00000000000000000FC80000800200000EC00000800200000EC0000000000EC0
	      hex 000080020000F7FF00000000080000000000100400000000080000004010
	      hex 000000000108000000000C40000000000C40 
;}}}

   echo "Free mem before PFDATA [", *, "-", PFDATA, "] =", (PFDATA - *), "bytes" 
         ORG PFDATA

;{{{
; ----- L E V E L S -------------------------------------------------------

;{{{ 
; LEVEL3
   IFCONST NTSC
LEVEL3   hex 4949FFC8C2  ; 5
   ELSE
LEVEL3   hex 49492F5852  ; 5
   ENDIF
         hex 21 ; 1 ( 5 + 1 + 1 + 28 - 2)
         hex 9A            ; 1 (5 + 1 + 1 + 28 + 119) 
         hex 3ADC3AA0343630C427DD27901DD11D4C152415C209A006DB067602E1 ;28
         hex 0000FFFF0000000080023302370200020037000200027FFF0000000080008000
         hex CC00C000C031C000CC00C0000000F100000000000CC80000000300030003
         hex 256B00000000F10000000800000000003100000008FF00000000E000E000
         hex FFFCF700F70080028002F1030003000308FF000231020013085B0002FFFF
;}}}

;{{{ 
; LEVEL6
   IFCONST NTSC
LEVEL6   hex 5930FF6862  ; 5
   ELSE
LEVEL6   hex 59302FA8A2  ; 5
   ENDIF
         hex A4          ; 1 (5 + 1 + 1 + 2 - 2) + 157
         hex BB          ; 1 (5 + 1 + 1 + 2 + 21) + 157
         hex 02E2        ; 2
         hex 0000FFFF20002000E0BF8CEE8002F0FE800280138013FFFF
;}}}

;{{{ 
; LEVEL1
   IFCONST NTSC
LEVEL1   hex 5930FF9422  ; 5
   ELSE
LEVEL1   hex 59302FB442  ; 5
   ENDIF
         hex C9          ; 1 (5 + 1 + 1 + 6 - 2) + 190
         hex EA          ; 1 (5 + 1 + 1 + 6 + 31) + 190
         hex 07DD077201E0;6
         hex 000000000000F00080008CC08011F000800080BFF302800280028CC280028002
	      hex FFFF
;}}}

;{{{
; Die folgende Tabelle enthaelt die Pointer zu den Level-Daten
;
LVPTRS   
         hex BEFF       ; LEVEL1 - braun        1 Gold
         hex 8AFD       ; LEVEL2 - stahlblau    3 Gold
         hex 00FF       ; LEVEL3 - gruenlich    6 Gold
         hex 90FB       ; LEVEL4 - grau         4 Gold
         hex 96FE       ; LEVEL5 - rot          3 Gold
         hex 9DFF       ; LEVEL6 - lila         0 Gold
;}}}

   echo "Free mem [", *, "-", $FFFA, "] =", ($FFFA - *), "bytes" 

;{{{
; INTERRUPTS - Installiert die Interrupt-Vektoren (d.h. wenn eines der
; folgenden drei Ereignisse auftritt springt der Prozessor zum Label
; RESET.
;
         ORG $FFFA
         .word RESET          ;NMI
         .word RESET          ;Reset
         .word RESET          ;IRQ
;}}}

