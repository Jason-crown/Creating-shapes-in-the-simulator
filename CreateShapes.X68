*-----------------------------------------------------------
* Title      : Create Shapes
* Written by : Jason Klutse
* Date       : 2026-11-14
* Description: Creating shapes with pixles in the simulator.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    ; set defaults
    move.l  #$00FF00FF,d1   ; default purple
    jsr     _MAIN
    
_SET_COLOR:                 ; $00BBGGRR
    move.b  #80,d0          ; Task 80: Set pen color
    trap    #15             ; Execute simulator task
    rts

_SHAPE:
    move.w  #-1,d6
    move.w  d1,d5
loop2:    
loop1:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d3,d1          ; Width
    blo     loop1
    addq.w  #1,d2
    
    move.w  d5,d1

   
    cmp     d4,d2          ; Height
    blo     loop2    
    rts

_MAIN:
    move.l  #$0000FF00,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #200,d1
    move.w  #300,d2
    move.w  #250,d3
    move.w  #350,d4
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height

    move.l  #$00FF0000,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #300,d1
    move.w  #400,d2
    move.w  #350,d3
    move.w  #450,d4
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    
    move.l  #$000000FF,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #100,d1
    move.w  #200,d2
    move.w  #150,d3
    move.w  #250,d4
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
