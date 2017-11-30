; -----------------------------------------------------------------------------
; Star Castle Arcade Music Data - Atari 2600
; Copyright (C) 2012 Chris Walton (cd-w) <cwalton@gmail.com>
; Copyright (C) 2013 Thomas Jentzsch <tjentzsch@yahoo.de>
; -----------------------------------------------------------------------------

; Zombified Zombie Bones
; By Kulor (C) 2008

  DEFINE_FPS_DIV TEMPO_DELAY, 5
HATSTART    equ 0
HATVOLUME   equ 7
HATPITCH    equ 0
HATSOUND    equ 8

; 000=square  001=bass  010=pitfall  011=noise
; 100=buzz    101=lead  110=saw      111=lowbass
; Using default sound table

  MAC SOUNDARRAYS
soundTurnArray
  byte  8, 0, 5, 9
  byte  0, 6, 4, 0
EsoundTurnArray
  if (>soundTurnArray != >EsoundTurnArray)
    echo "WARNING: soundTurnArray crosses a page boundary!"
  endif

soundTypeArray
  byte  4,6,7,8
  byte  15,12,1,14
EsoundTypeArray
  if (>soundTypeArray != >EsoundTypeArray)
    echo "WARNING: soundTypeArray crosses a page boundary!"
  endif

hatPattern
  byte  %00001010
  byte  %00001010
  byte  %00001010
  byte  %00001010
  byte  %11101010
  byte  %00001010
  byte  %00001010
  byte  %10101010
EhatPattern
  if (>hatPattern != >EhatPattern)
    echo "WARNING: soundTypeArray crosses a page boundary!"
  endif
  ENDM

  MAC SONGDATA
song1
  ; Part 1
  byte 1,1
  byte 1,4
  byte 7,9
  byte 1,8
  ; Part 2
  byte 11,12
  byte 11,13
  byte 11,12
  byte 11,13
  byte 14, 255
  ; End of song marker
  byte 255
Esong1
  if (>song1 != >Esong1)
    echo "WARNING: song1 crosses a page boundary!"
  endif

song2
  ; Part 1
  byte 2,3
  byte 2,5
  byte 6,2
  byte 2,10
  ; Part 2
  byte 128,129
  byte 128,130
  byte 128, 129
  byte 128, 131
  byte 15, 255
  ; End of song marker
  byte 255
Esong2
  if (>song2 != >Esong2)
    echo "WARNING: song2 crosses a page boundary!"
  endif
  ENDM

  ; Higher volume patterns
  MAC PATTERNH
patternArrayH             ; starts at 0
  ; Muted Pattern
  word mute,mute,mute,mute                    ;0
  ; Part 1
  word Bass1a, Bass1a, Bass1a, Bass1b         ;1
  word Bass2a, Bass2b, Bass2a, Bass2b         ;2
  word Arp1a, Bass2b, Bass2a, Bass2b          ;3
  word Bass3a, Bass3b, Bass4a, Bass4b         ;4
  word Bass5a, Bass5b, Bass6a, Bass6b         ;5
  word Melody1a, Melody2a, Melody3a, Bass2b   ;6
  word Bass1c, Bass1d, Bass1c, Bass1b         ;7
  word Bass3c, Bass3b, Bass4a, Bass4b         ;8
  word Bass1a, Fill1, Bass1a, Bass1b          ;9
  word Bass5a, Bass5b, Bass6a, Bass6c         ;10
  ; Part 2
  word Bass7a, Bass7a, Bass7a, Bass7a         ;11
  word Bass8a, Bass8a, Bass8a, Bass8b         ;12
  word Bass9a, Bass9a, Bass8a, Bass8c         ;13
  word Trans1, Trans1, Trans1, Trans1         ;14
  word Trans2, Trans3, Trans4, Trans5         ;15
EpatternArrayH
  if (>patternArrayH != >EpatternArrayH)
    echo "WARNING: patternArrayH crosses a page boundary!"
  endif
  ENDM

  ; Lower volume patterns
  MAC PATTERNL
patternArrayL             ; start at 128
  word Melody4a, Melody4b, Melody5a, Melody6a  ;128
  word Melody4c, Fill2, Fill3, Fill4    ;129
  word Melody7a, Fill3, Melody8a, Fill3    ;130
  word Melody9a, Melody9a, Melody9b, Melody9c  ;131
EpatternArrayL
  if (>patternArrayL != >EpatternArrayL)
    echo "WARNING: patternArrayL crosses a page boundary!"
  endif
  ENDM

  ; Pattern Data
  MAC PATTERNDATA

Sample    ; do not erase
  byte %00111101, %00111101
  byte %00111101, %00111101
  byte %00101110, %00101110
  byte %00101110, %00101110

  byte %10001000

Bass1a    ; Bass for eigth note
  byte %00111101, %00111101
  byte %00111101, %00111101
  byte 255,255,255,255
  byte %11110000


Bass1b    ; Bass 1-5 interval
  byte %00111101, %00111101
  byte %00111101, %00111101
  byte %00101001, %00101001
  byte %00101001, %00101001

  byte %11111111

Bass1c    ; Bass for eigth note, kick on down
  byte %10011111, %00111101
  byte %00111101, %00111101
  byte 255,255,255,255

  byte %11110000

Bass1d    ; Bass for eigth note, heavy snare on down
  byte %10000110, %10000111
  byte %00111101, %00111101
  byte 255,255,255,255

  byte %10110000

Bass2a    ; LtBass for eigth note, kick on down
  byte %10011111, %11011110
  byte %11011110, %11011110
  byte 255,255,255,255

  byte %11110000

Bass2b    ; LtBass for eigth note, heavy snare on down
  byte %10000110, %10000111
  byte %11011110, %11011110
  byte 255,255,255,255

  byte %10110000

Bass3a    ; Bass on 4th for eigth note, effect on 2nd eigth
  byte %00110101, %00110101
  byte %00110101, %00110101
  byte %01000100, %01000011
  byte %01000010, %01000001

  byte %11110000

Bass3b    ; Bass on 4th for eigth note
  byte %00110101, %00110101
  byte %00110101, %00110101
  byte 255,255,255,255

  byte %11110000

Bass3c    ; Bass on 4th for eigth note, effect on 2nd eigth
  byte %00110101, %00110101
  byte %00110101, %00110101
  byte %11100100, %11100101
  byte %11100110, %11100111

  byte %11110000

Bass4a    ; Bass on #5th for eigth note
  byte %00110010, %00110010
  byte %00110010, %00110010
  byte 255,255,255,255

  byte %11110000

Bass4b    ; Bass on #5th for eigth note, 5th 2nd eigth
  byte %00110010, %00110010
  byte %00110010, %00110010
  byte %00101001, %00101001
  byte %00101001, %00101001

  byte %11111111

Bass5a    ; LtBass on 4th for eigth note, kick on down
  byte %10011111, %11010110
  byte %11010110, %11010110
  byte 255,255,255,255

  byte %11110000

Bass5b    ; LtBass on 4th for eigth note, heavy snare on down
  byte %10000110, %10000111
  byte %11010110, %11010110
  byte 255,255,255,255

  byte %10110000

Bass6a    ; LtBass on #5th for eigth note, kick on down
  byte %10011111, %11010011
  byte %11010011, %11010011
  byte 255,255,255,255

  byte %11110000

Bass6b    ; LtBass on #5th for eigth note, heavy snare on down
  byte %10000110, %10000111
  byte %11010011, %11010011
  byte 255,255,255,255

  byte %10110000

Bass6c    ; LtBass on #5th for eigth note, heavy snare on down, 8th; kick on 16th, 16th+8th
  byte %10000110, %10000111
  byte %10011111, %11010011
  byte %10000110, %10000111
  byte %10011111, 255


  byte %10111010

Bass7a    ; Bass on F#, kick on down, snare on 8th
  byte %10011111, %00110101
  byte %11010110, %11010110
  byte %01100111, %00110101
  byte %11010110, %11010110

  byte %11001000

Bass8a    ; Bass on D, kick on down, snare on 8th
  byte %10011111, %00111011
  byte %11011100, %11011100
  byte %01100111, %00111011
  byte %11011100, %11011100

  byte %11001000

Bass8b    ; Bass on D, kick on down and 16th, snare on 8th
  byte %10011111, %00111011
  byte %10011111, %11011100
  byte %01100111, %00111011
  byte %11011100, %11011100

  byte %11101000

Bass8c    ; Bass on D, kick on down, 16th and 8th+16th, snare on 8th
  byte %10011111, %00111011
  byte %10011111, %11011100
  byte %01100111, %00111011
  byte %10011111, %11011100

  byte %11101000

Bass9a    ; Bass on E, kick on down, snare on 8th
  byte %10011111, %00111000
  byte %11011001, %11011001
  byte %01100111, %00111000
  byte %11011001, %11011001

  byte %11001000

Arp1a    ; C# G# E D#; kick on down
  byte %10011111, %00001101
  byte %00010010, %00010010
  byte %00010111, %00010111
  byte %00011001, %00011001

  byte %10101010

Melody1a  ; C#, D#
  byte %00011011, %00011011
  byte %00011011, %00011011
  byte %00011000, %00011000
  byte %00011000, %00011000

  byte %11001100

Melody2a  ; E, F#
  byte %00010111, %00010111
  byte %00010111, %00010111
  byte %00010100, %00010100
  byte %00010100, %00010100

  byte %11001100

Melody3a  ; G
  byte %11000100, %00010010
  byte %11000100, %00010010
  byte %11000100, %00010010
  byte %11000100, %00010010

  byte %01010000

Fill1    ; Noise
  byte %01111111, %01111101
  byte %01111011, %01110111
  byte %01110111, %01101111
  byte %01100111, %01100011

  byte %00000000

Fill2    ; Noise Up Twice
  byte %11100100, %11100011
  byte %11100010, %11100001
  byte %11100100, %11100011
  byte %11100010, %11100001

  byte %11111111

Fill3    ; Engine Down
  byte %11100011, %11100001
  byte %11101111, %11100111
  byte %11111011, %11110111
  byte %11111110, %11111101

  byte %11111111

Fill4    ; Saw Down
  byte %01000011, %01000001
  byte %01001111, %01000111
  byte %01011011, %01010111
  byte %01011110, %01011101

  byte %00000000

Melody4a  ; Arp A-C#
  byte %10101011,  %10110010
  byte %10101011,  %10110010
  byte %10101011,  %10110010
  byte %10101011,  %10110010

  byte %11111111

Melody4b  ; Arp A-C# trans
  byte %10101011,  %10110010
  byte %10101011,  %10110010
  byte %10101100,  %10110010
  byte %10101100,  %10110010

  byte %11111111

Melody4c  ; Arp A-C
  byte %10101011,  %10110011
  byte %10101011,  %10110011
  byte %10101011,  %10110011
  byte %10101011,  %10110011

  byte %11111111

Melody5a  ; Arp F#-C#
  byte %10101111,  %10110010
  byte %10101111,  %10110010
  byte %10101111,  %10110010
  byte %10101111,  %10110010

  byte %11111111

Melody6a  ; Arp G#-C#
  byte %10101100,  %10110010
  byte %10101100,  %10110010
  byte %10101100,  %10110010
  byte %10101100,  %10110010

  byte %11111111

Melody7a  ; Arp C-G#
  byte %10101001, %10101100
  byte %10101001, %10101100
  byte %10101001, %10101100
  byte %10101001, %10101100

  byte %11111111

Melody8a  ; Arp D-G#
  byte %10101000, %10101101
  byte %10101000, %10101101
  byte %10101000, %10101101
  byte %10101000, %10101101

  byte %11111111

Melody9a  ; Arp D-D
  byte %10101000, %10110001
  byte %10101000, %10110001
  byte %10101000, %10110001
  byte %10101000, %10110001

  byte %11111111

Melody9b  ; D fall
  byte %10101000, %10101000
  byte %10101000, %10101000
  byte %10101100, %10101111
  byte %10110100, %10111000

  byte %11111111

Melody9c  ; D fall
  byte %10101000, %10101000
  byte %10101000, %10101000
  byte %10101100, %10101111
  byte %10110100, %10111000

  byte %00000000

Trans1    ; Drone bass D
  byte %00111011, %00111011
  byte %00111011, %00111011
  byte %00111011, %00111011
  byte %00111011, %00111011

  byte %11111111

Trans2    ; Drone ltbass D
  byte %11011100, %11011100
  byte %11011100, %11011100
  byte %11011100, %11011100
  byte %11011100, %11011100

  byte %11111111

Trans3    ; Noise down 1
  byte %01100000, %01100000
  byte %01100001, %01100001
  byte %01100010, %01100010
  byte %01100100, %01100100

  byte %11111111

Trans4    ; Noise down 2
  byte %01101000, %01101000
  byte %01110000, %01110000
  byte %01111000, %01111000
  byte %01111100, %01111100

  byte %11111111

Trans5    ; Engine Rumble
  byte %11111110, %11111110
  byte %11111110, %11111110
  byte %11111110, %11111110
  byte %11111110, %11111110

  byte %11110000

mute
  byte 255,255,255,255
  byte 255,255,255,255

  byte 255

  ENDM

