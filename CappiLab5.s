@ Filename: LAB5.s
@ Author:   Jacob Cappi
@ Mail:     JC0199@uah.edu
@ Assignment: CS-309-01 2021 
@
@ Purpose: Provide a gasoline pump interface.
@          The program will check the level of gas, and will quit when  
@          out. Each fuel grade starts at 500, and the program will 
@          prevent usage below 10.
@           
@ 
@ History: 
@    Date       Purpose of change
@    ----       ----------------- 
@     4/1       Completion of Lab
@ Use these commands to assemble, link, run and debug this program:
@    as -o SBCappi.o SBCappi.s
@    gcc -o SBCappi SBCappi.o
@    ./student_inputC ;echo $?
@    gdb --args ./student_inputC 
@ ***********************************************************************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ***********************************************************************

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 

main:

   ldr r0, =strPrompt1 
   bl printf
@*******************
prompt:
@*******************

@ Prompting the User with general prompt.
   ldr r0, =strPrompt2     @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 
@ Printing out the current inventory in tenths 
   ldr r0, =strRegular 
   ldr r1, =intRegular
   ldr r1, [r1]
   bl printf

   ldr r0, =strMidGrade     @ Put the address of my string into the first parameter
   ldr r1, =intMidGrade
   ldr r1, [r1]
   bl  printf              @ Call the C printf to display input prompt. 

   ldr r0, =strPremium     @ Put the address of my string into the first parameter
   ldr r1, =intPremium
   ldr r1, [r1]
   bl  printf              @ Call the C printf to display input prompt. 


   ldr r0, =strPrompt3
   bl printf

@ Printing out the currently dispensed 
   ldr r0, =strRegular 
   ldr r1, =intRegularDispensed
   ldr r1, [r1]
   bl printf

   ldr r0, =strMidGrade     @ Put the address of my string into the first parameter
   ldr r1, =intMidGradeDispensed
   ldr r1, [r1]
   bl  printf              @ Call the C printf to display input prompt. 

   ldr r0, =strPremium     @ Put the address of my string into the first parameter
   ldr r1, =intPremiumDispensed
   ldr r1, [r1]
   bl  printf              @ Call the C printf to display input prompt. 

@*******************
get_input:
@*******************
@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. 
@ Getting first selection


@ Error Check 
   
   ldr r1, =intRegular
   ldr r1, [r1]
   mov r4, #10
   cmp r0, r4
   ble errorCheck

@ Error success

@*******************
errorSuccess:
@*******************
   ldr r0, =strPrompt4
   bl printf

   ldr r0, =charInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   ldr r2, =charCheckRegular
   ldr r2, [r2]
   cmp r1, r2               @ Check Prompt if Regular
   beq pickR

   ldr r2, =charCheckMidGrade
   ldr r2, [r2]
   cmp r1, r2               @ Check Prompt if Mid Grade
   beq pickM

   ldr r2, =charCheckPremium
   ldr r2, [r2]
   cmp r1, r2               @ Check Prompt if Premium
   beq pickP

   ldr r2, =charCheckSecretCode @ 'S' for secret
   ldr r2, [r2]
   cmp r1, r2               @ Check Prompt if Premium
   beq prompt

   ldr r0, =strErrorMessage1 @ if none, just error message and repeat
   bl printf
   b get_input


@ Lazy way to do this, but it seemed simple

@ R Branch
@*******************
pickR:
@*******************
   ldr r3, =intRegular
   ldr r3, [r3]
   mov r2, #10
   cmp r3, r2
   ble outError

   ldr r0, =strUserR
   bl printf

@*******************
pickRMon:
@*******************
   ldr r0, =strEnterDollar
   bl printf

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerrorR            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   cmp r1, #50              @ top limit
   bgt ErrorR1          

   cmp r1, #1               @ bottom limit
   blt ErrorR1

   mov r5, #4

   mul r3, r1, r5
   ldr r2, =intRegular
   ldr r2, [r2]

   cmp r3, r2              @ r2: how much regular r1: amount requested
   bgt ErrorR2

   ldr r6, =intRegularDispensed @r1: amount dispereced
   ldr r5, [r6]
   add r7, r1, r5
   str r7, [r6]

   sub r4, r2, r3          @ amount leftover from r3 - r2

   ldr r2, =intRegular
   str r4, [r2]

   mov r1, r3
   ldr r0, =strUserR2
   bl printf

   b get_input


@*******************
ErrorR1:
@*******************
   ldr r0, =strErrorMessage2
   bl printf
   b pickRMon


@*******************
ErrorR2:
@*******************
   ldr r0, =strErrorMessage3
   bl printf
   b pickRMon


@*******************
pickM:
@*******************

   ldr r3, =intMidGrade
   ldr r3, [r3]
   mov r2, #10
   cmp r3, r2
   ble outError

   ldr r0, =strUserM
   bl printf

@*******************
pickMMon:
@*******************
   ldr r0, =strEnterDollar
   bl printf

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerrorM           @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   cmp r1, #50              @ top limit
   bgt ErrorM1          

   cmp r1, #1               @ bottom limit
   blt ErrorM1

   mov r5, #3
   mul r3, r1, r5
   ldr r2, =intMidGrade
   ldr r2, [r2]

   cmp r3, r2              @ r2: how much regular r3: amount requested
   bgt ErrorM2

   ldr r6, =intMidGradeDispensed @r1: amount dispereced
   ldr r5, [r6]
   add r1, r1, r5
   str r1, [r6]

   sub r4, r2, r3          @ amount leftover from r3 - r2

   ldr r2, =intMidGrade
   str r4, [r2]

   mov r1, r3
   ldr r0, =strUserM2
   bl printf

   b get_input


@*******************
ErrorM1:
@*******************
   ldr r0, =strErrorMessage2
   bl printf
   b pickMMon


@*******************
ErrorM2:
@*******************
   ldr r0, =strErrorMessage3
   bl printf
   b pickMMon


@*******************
pickP:
@*******************

   ldr r3, =intPremium
   ldr r3, [r3]
   mov r2, #10
   cmp r3, r2
   ble outError


   ldr r0, =strUserP
   bl printf

@*******************
pickPMon:
@*******************
   ldr r0, =strEnterDollar
   bl printf

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerrorP            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   cmp r1, #50              @ top limit
   bgt ErrorP1          

   cmp r1, #1               @ bottom limit
   blt ErrorP1

   mov r5, #2              @ Premium has 2 gallons per dollar
   mul r3, r1, r5
   ldr r2, =intPremium
   ldr r2, [r2]

   cmp r3, r2              @ r2: how much premium r3: amount requested
   bgt ErrorP2

   ldr r6, =intPremiumDispensed @r1: amount dispereced
   ldr r5, [r6]
   add r1, r1, r5
   str r1, [r6]

   sub r4, r2, r3          @ amount leftover from r3 - r2

   ldr r2, =intPremium
   str r4, [r2]

   mov r1, r3
   ldr r0, =strUserP2
   bl printf

   b get_input


@*******************
ErrorP1:
@*******************
   ldr r0, =strErrorMessage2
   bl printf
   b pickPMon


@*******************
ErrorP2:
@*******************
   ldr r0, =strErrorMessage3
   bl printf
   b pickPMon

@*******************
outError:
@*******************
   ldr r0, =strErrorMessage4  
   bl printf
   b get_input

@*******************
errorCheck:
@*******************
   ldr r1, =intMidGrade
   ldr r1, [r1]
   mov r4, #10
   cmp r1, r4
   ble finalCheck
   b errorSuccess

@*******************
finalCheck:
@*******************
   ldr r1, =intPremium
   ldr r1, [r1]
   mov r4, #10
   cmp r1, r4
   ble fatalError
   b errorSuccess

@*******************
fatalError:
@*******************
   ldr r0, =strErrorMessage5
   bl printf
   b myexit 
   
@**********
endMessage:
@**********
   ldr r0, =strErrorMessage @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 
   b myexit


@***********
readerror:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b myexit 
@***********
readerrorR:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b ErrorR2
@***********
readerrorM:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b ErrorM2
@***********
readerrorP:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b ErrorP2 

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 

.data
@ Declare the strings and data needed

.balign 4
strPrompt1: .asciz "\nWelcome to gasoline pump\n"
.balign 4
strPrompt2: .asciz "\n\nCurrent inventory of gasoline (in tenths of gallons) is \n"
.balign 4
strPrompt3: .asciz "Dollar Amount dispensed by grade: \n"
.balign 4
strPrompt4: .asciz "Select Grade of gas to dispense (R, M, or, P [input uppercase]): \n"

.balign 4
strRegular: .asciz "\tRegular %d\n"
.balign 4
strMidGrade: .asciz "\tMid-Grade %d\n"
.balign 4
strPremium: .asciz "\tPremium %d\n"


.balign 4
intRegular: .word 500
.balign 4
intMidGrade: .word 500
.balign 4
intPremium: .word 500

.balign 4
intRegularDispensed: .word 0
.balign 4
intMidGradeDispensed: .word 0
.balign 4
intPremiumDispensed: .word 0

.balign 4
strUserR: .asciz "You selected Regular\n"
.balign 4
strUserM: .asciz "You selected Mid-Grade\n"
.balign 4
strUserP: .asciz "You selected Premium\n"

.balign 4
strUserR2: .asciz "\n%d tenths of gallons of Regular Dispensed\n"
.balign 4
strUserM2: .asciz "\n%d tenths of gallons of Mid-Grade Dispensed\n"
.balign 4
strUserP2: .asciz "\n%d tenths of gallons of Premium Dispensed\n"

.balign 4
strEnterDollar: .asciz "\nEnter Dollar amount to dispense (Atleast 1 and no more than 50):\n"


.balign 4
charCheckRegular: .word 82
.balign 4
charCheckMidGrade: .word 77 
.balign 4
charCheckPremium: .word 80 
.balign 4
charCheckSecretCode: .word 83

.balign 4
strErrorMessage: .asciz "\n\nError: Scanf Error\n"
.balign 4
strErrorMessage1: .asciz "\n\nError: Invalid Character\n"
.balign 4
strErrorMessage2: .asciz "Error: Dollar not within bounds.\n"
.balign 4
strErrorMessage3: .asciz "\nNot enough gasoline, enter lower dollar amount \n"
.balign 4
strErrorMessage4: .asciz "\nNot enough gasoline of this grade, Pick a different grade \n"
.balign 4
strErrorMessage5: .asciz "\nNot enough gasoline: Shutting down pump\n"

@ Format pattern for scanf call.

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
charInputPattern: .asciz "%s" @char format for read




.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 

@ Let the assembler know these are the C library functions. 

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

.global scanf
@  To use scanf:
@      r0 - Contains the address of the input format string used to read the user
@           input value. In this example it is numInputPattern.  
@      r1 - Must contain the address where the input value is going to be stored.
@           In this example memory location intInput declared in the .data section
@           is being used.  
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.
@ Important Notes about scanf:
@   If the user entered an input that does NOT conform to the input pattern, 
@   then register r0 will contain a 0. If it is a valid format
@   then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@   input so that needs to be cleared out before attempting anything else.
@
@ Additional notes about scanf and the input patterns:
@    1. If the pattern is %s or %c it is not possible for the user input to generate
@       and error code. Anything that can be typed by the user on the keyboard
@       will be accepted by these two input patterns. 
@    2. If the pattern is %d and the user input 12.123 scanf will accept the 12 as
@       valid input and leave the .123 in the input buffer. 
@    3. If the pattern is "%c" any white space characters are left in the input
@       buffer. In most cases user entered carrage return remains in the input buffer
@       and if you do another scanf with "%c" the carrage return will be returned. 
@       To ignore these "white" characters use " $c" as the input pattern. This will
@       ignore any of these non-printing characters the user may have entered.
@

@ End of code and end of file. Leave a blank line after this.
