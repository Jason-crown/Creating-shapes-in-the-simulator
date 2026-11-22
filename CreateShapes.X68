*-----------------------------------------------------------
* Title      : Create Shapes
* Written by : Jason Klutse
* Date       : 2026-11-14
* Description: Creating shapes with pixles in the simulator.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

typ     equ     18
sft     equ     16
XO      equ     14
YO      equ     12
XS      equ     10
YS      equ     8
SXO     equ     -2

* Put program code here
    jsr     _MAIN
    
_SET_COLOR:                 ; $00BBGGRR
    move.b  #80,d0          ; Task 80: Set pen color
    trap    #15             ; Execute simulator task
    rts

square:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    move.w  XO(a6),d1
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  d1,SXO(a6)
SqrLoop:
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d3,d1           ; Width
    blo     SqrLoop
    addq.w  #1,d2
    move.w  SXO(a6),d1
    cmp     d4,d2           ; Height
    blo     SqrLoop
    movem.l (a7)+,d0-d6
    unlk    a6
    rts

triangle:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    
    move.w  XO(a6),d1
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5
    move.w  typ(a6),d7
    
    move.w  d1,SXO(a6)    
TriLoop:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d3,d1           ; Width
    blo     TriLoop
    sub.w   d5,d3           ;control factor
    addq.w  #1,d2
    move.w  SXO(a6),d1
    add.w   d7,SXO(a6)
    cmp     d4,d2           ; Height
    blo     TriLoop    
    movem.l (a7)+,d0-d6
    unlk    a6
    rts
      
circle:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    
    move.w  XO(a6),d1
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5
    move.w  typ(a6),d7
    
    move.w  d1,SXO(a6)    
CirLoop:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task

    movem.l (a7)+,d0-d6
    unlk    a6
    rts
    
polygone:
    link    a6,#-2
    movem.l  d0-d6,-(a7)
    
    move.w  XO(a6),d1
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5
    move.w  typ(a6),d7
    
    move.w  d1,SXO(a6)    
polLoop:  
    addq.w  #1,d1
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task

    movem.l (a7)+,d0-d6
    unlk    a6
    rts
    
_MAIN:
    move.l  #$0000FF00,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #200,-(a7) ;x start
    move.w  #300,-(a7) ;y start
    move.w  #250,-(a7) ;x size
    move.w  #350,-(a7) ;y size
    jsr     square          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    addi    #8,(a7)
        
    move.l  #$00FF0000,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #300,-(a7)
    move.w  #400,-(a7)
    move.w  #350,-(a7)
    move.w  #450,-(a7)
    jsr     square          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    addi    #8,(a7)
    
    move.l  #$000000FF,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #100,-(a7)
    move.w  #200,-(a7)
    move.w  #150,-(a7)
    move.w  #250,-(a7)
    jsr     square          ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    addi    #8,(a7)
    
    move.l  #$00FF00FF,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #-1,-(a7)       ; make both type offsets negative for isosceles, and make sure the size (xo-xs or yo-yx == 0)
    move.w  #-1,-(a7)
    move.w  #100,-(a7)
    move.w  #400,-(a7)
    move.w  #100,-(a7)
    move.w  #450,-(a7)
    jsr     triangle        ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height
    addi    #12,(a7)
    
    move.l  #$0000FFFF,d1
    jsr     _SET_COLOR      ; set color in d1.l 
    move.w  #2,-(a7)       ; make both negative for isosceles
    move.w  #2,-(a7)
    move.w  #50,-(a7)
    move.w  #200,-(a7)
    move.w  #50,-(a7)
    move.w  #250,-(a7)
    jsr     circle        ; d1.w = x offset d2.w = y offset, d3.w = Width, d4.w = Height       
        
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
