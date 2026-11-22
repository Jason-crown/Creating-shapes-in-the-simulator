*-----------------------------------------------------------
* Title      : Create Shapes
* Written by : Jason Klutse
* Date       : 2026-11-14
* Description: Creating shapes with pixles in the simulator.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
XO      equ     14
YO      equ     12
XS      equ     10
YS      equ     8
SXO     equ     -2
* Put program code here
    ; set defaults
    move.l  #$00FF00FF,d1   ; default purple
    jsr     _MAIN
    
_SET_COLOR:                 ; $00BBGGRR
    move.b  #80,d0          ; Task 80: Set pen color
    trap    #15             ; Execute simulator task
    rts

_SHAPE:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    move.w  XO(a6),d1
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  d1,SXO(a6)
loop2:    
loop1:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d3,d1          ; Width
    blo     loop1
    addq.w  #1,d2
    
    move.w  SXO(a6),d1

   
    cmp     d4,d2          ; Height
    blo     loop2    
    movem.l (a7)+,d0-d6
    unlk    a6
    rts
    
line:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    move.w  XS(a6),d1
    move.w  YS(a6),d2
    move.w  d1,SXO(a6)   
loop:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d2,d1          ; Width
    blo     loop1
    movem.l (a7)+,d0-d6
    unlk    a6
    rts    
_MAIN:
    move.l  #$0000FF00,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #200,-(a7)
    move.w  #300,-(a7)
    move.w  #250,-(a7)
    move.w  #350,-(a7)
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height

    move.l  #$00FF0000,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #300,-(a7)
    move.w  #400,-(a7)
    move.w  #350,-(a7)
    move.w  #450,-(a7)
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    
    move.l  #$000000FF,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #100,-(a7)
    move.w  #200,-(a7)
    move.w  #150,-(a7)
    move.w  #250,-(a7)
    jsr     _SHAPE          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
