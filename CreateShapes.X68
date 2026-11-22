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
    move.w  XO(a6),d1       ; parameters
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  d1,SXO(a6)      ; save d1
SqrLoop:
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    addq.w  #1,d1           ; next column
    cmp     d3,d1           ; Width
    blo     SqrLoop
    addq.w  #1,d2           ; next row
    move.w  SXO(a6),d1      ; use saved d1
    cmp     d4,d2           ; Height
    blo     SqrLoop         
    movem.l (a7)+,d0-d6
    unlk    a6
    rts

triangle:
    link    a6,#-2
    movem.l  d0-d7,-(a7)
    move.w  XO(a6),d1       ; parameters
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5
    move.w  typ(a6),d7
    move.w  d1,SXO(a6)      ; save d1
    
    tst.w   d5              ; detect flips
    ble     TriLoop
    tst.w   d7
    ble     TriLoop  
    move.w  d1,d3
   
TriLoop:  
    cmp     d1,d3
    blo     Triend
    
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    addq.w  #1,d1           ; next column
    cmp     d3,d1           ; Width
    blo     TriLoop
    add.w   d5,d3           ; Right Slop
    addq.w  #1,d2           ; next row
    move.w  SXO(a6),d1      ; use saved d1
    sub.w   d7,SXO(a6)      ; Left Slop
    cmp     d4,d2           ; Height
    blo     TriLoop        
TriEnd:
    movem.l (a7)+,d0-d7
    unlk    a6
    rts
    
diamond:
    move.w  XO(a6),d1       ; parameters
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5
    move.w  typ(a6),d7
    move.w  d1,SXO(a6)      ; save d1
    move.w  #1,-(a7)        
    move.w  #1,-(a7)       
    move.w  #100,-(a7)      
    move.w  #100,-(a7)      
    move.w  #150,-(a7)      
    move.w  #110,-(a7)
    jsr     triangle
    addi.w  #12,(a7)       
    rts
    
_MAIN:
    move.l  #$0000FF00,d1
    jsr     _SET_COLOR      ; set color in d1.l
    move.w  #200,-(a7)      ; X coordinate
    move.w  #300,-(a7)      ; Y coordinate
    move.w  #250,-(a7)      ; Width
    move.w  #350,-(a7)      ; Hight
    jsr     square          
    addi    #8,(a7)
        
    move.l  #$00FF0000,d1
    jsr     _SET_COLOR      
    move.w  #300,-(a7)
    move.w  #400,-(a7)
    move.w  #350,-(a7)
    move.w  #450,-(a7)
    jsr     square          
    addi    #8,(a7)
    
    move.l  #$000000FF,d1
    jsr     _SET_COLOR      
    move.w  #100,-(a7)
    move.w  #200,-(a7)
    move.w  #150,-(a7)
    move.w  #250,-(a7)
    jsr     square          
    addi    #8,(a7)
    
    move.l  #$00FF00FF,d1
    jsr     _SET_COLOR      
    move.w  #1,-(a7)       ; left side slope
    move.w  #1,-(a7)       ; right side slope 
    move.w  #100,-(a7)      ; X coordinate
    move.w  #400,-(a7)      ; Y coordinate
    move.w  #200,-(a7)      ; Width
    move.w  #450,-(a7)      ; Hight
    jsr     triangle        
    addi    #12,(a7)
    
    move.l  #$0000FFFF,d1
    jsr     _SET_COLOR      
    move.w  #2,-(a7)        
    move.w  #-4,-(a7)       
    move.w  #100,-(a7)      
    move.w  #300,-(a7)      
    move.w  #150,-(a7)      
    move.w  #350,-(a7)      
    jsr     triangle        
    addi    #12,(a7)
    
    move.l  #$00FFFF00,d1
    jsr     _SET_COLOR      
    move.w  #1,-(a7)        
    move.w  #1,-(a7)       
    move.w  #100,-(a7)      
    move.w  #100,-(a7)      
    move.w  #110,-(a7)      
    move.w  #110,-(a7)      
    jsr     triangle        
    addi    #12,(a7)
    
    move.l  #$00A00C70,d1
    jsr     _SET_COLOR      
    move.w  #1,-(a7)        
    move.w  #1,-(a7)       
    move.w  #100,-(a7)      
    move.w  #100,-(a7)      
    move.w  #150,-(a7)      
    move.w  #110,-(a7)      
    jsr     diamond
    addi    #12,(a7)
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
