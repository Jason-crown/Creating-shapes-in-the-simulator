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
    link    a6,#-6
    movem.l  d0-d7,-(a7)
    move.w  XO(a6),d1       ; parameters
    move.w  YO(a6),d2
    move.w  XS(a6),d3
    move.w  YS(a6),d4
    move.w  sft(a6),d5      ; right
    move.w  typ(a6),d7      ; left
    move.w  d1,SXO(a6)      ; save d1
    move.w  d1,-4(a6)
    move.w  d3,-6(a6)
    
    move.w  d1,d0           ; midpoint calculation
    add.w   d3,d0
    lsr.w   #1,d0
    addi.w  #-17,d0
    
    move.w  d7,d6
    mulu.w   d3,d6
    
    move.w  d5,d0
    mulu.w   d1,d0
    
    add.w   d0,d6
    
    move.w  d5,d0
    add.w   d7,d0
    
    divu.w  d0,d6
    andi.l  #$0000FFFF,d6
    move.l  d6,d0
    
    
    ;move.w  d3,d6          ;1 calculate width
    ;sub.w   d1,d6
    
    ;mulu.w  d5,d6
    
    ;move.w  d5,d0
    ;add.w   d7,d0
    
    ;divu.w  d0,d6
    ;andi.w  #$00FF,d6
    ;move.l  d6,d0
    
                            ;2 calculate
    ;mulu.w  d5,d6
    ;move.w  d7,d0
    ;add.w   d5,d0
    ;divu.w  d0,d6
    ;andi.w  #$0000FFFF,d6
    ;add.w   d1,d6

    ;move.b  d6,d1          * tests
    ;move.w  #3,d0
    ;trap    #15
    ;jsr     QUIT
                        
    tst.w   d5              ; check right slop
    ble     skp
    move.w  d0,d3           ; set right to middle ;-d7*size/(d7-d5)
skp:    
    tst.w   d7              ; check left slop
    ble     TriLoop    
    move.w  d0,d1           ; set left to middle
    move.w  d0,SXO(a6) 
                                
                                
TriLoop:  
    cmp     d2,d4           ; Keep in hight bounds
    blo     Triend
    cmp     d1,d3           ; Keep in width bounds
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
    
    move.w  -4(a6),d6
    cmp.w   SXO(a6),d6      
    bgt     TriEnd
    move.w  -6(a6),d6
    cmp.w   d3,d6      
    ble     TriEnd
    
    cmp     d4,d2           ; Height
    blo     TriLoop        
TriEnd:
    movem.l (a7)+,d0-d7
    unlk    a6
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
    
    move.l  #$00110011,d1
    jsr     _SET_COLOR       
    move.w  #100,-(a7)      ; X coordinate
    move.w  #400,-(a7)      ; Y coordinate
    move.w  #200,-(a7)      ; Width
    move.w  #450,-(a7)      ; Hight
    jsr     square        
    addi    #8,(a7)    

    move.l  #$00FFFFFF,d1
    jsr     _SET_COLOR      
    move.w  #-1,-(a7)       ; left side slope
    move.w  #-1,-(a7)       ; right side slope 
    move.w  #100,-(a7)      ; X coordinate
    move.w  #400,-(a7)      ; Y coordinate
    move.w  #200,-(a7)      ; Width
    move.w  #450,-(a7)      ; Hight
    jsr     triangle        
    addi    #12,(a7)
    
    move.l  #$00FF00FF,d1
    jsr     _SET_COLOR      
    move.w  #1,-(a7)        ; left side slope
    move.w  #1,-(a7)        ; right side slope 
    move.w  #100,-(a7)      ; X coordinate
    move.w  #400,-(a7)      ; Y coordinate
    move.w  #200,-(a7)      ; Width
    move.w  #450,-(a7)      ; Hight
    jsr     triangle        
    addi    #12,(a7)
        
QUIT:
    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
