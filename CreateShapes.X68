*-----------------------------------------------------------
* Title      : Create Shapes
* Written by : Jason Klutse
* Date       : 2026-11-14
* Description: Creating shapes with pixles in the simulator.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    *   1. Set pen color to Red ($00BBGGRR -> $000000FF)
    move.l  #$000000FF,d1   ; Load color value into D1
    move.b  #80,d0          ; Task 80: Set pen color
    trap    #15             ; Execute simulator task
    
    *   2. Draw pixel at X=100, Y=150 
    *   2. convert coordinates
    move.w  #100,d1         ; X Start coordinate
    lsl.w   #8,d1           ; Y Start coordinate
    addi.w  #150,d1
    
    move.w  #150,d3         ; X End coordinate
    lsl.w   #8,d3           ; Y End coordinate
    addi.w  #200,d3    
    *   2. convert back coordinates
    move.b  d3,d4
    andi.w  #$00FF,d3
     
    move.b  d1,d2
    andi.w  #$00FF,d1

loopV:
    addq.w  #1,d1
    addq.w  #1,d3
    move.b  #82,d0          ; Task 82: Draw pixel in pen color
    trap    #15             ; Execute simulator task
    cmp     d3,d1
    blo     loopV


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
