      ******************************************************************
      *Author: David Nguyen
      *Due Date: February 23, 2022
      *Purpose: Project 3
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. NGUYEN-P03-PAY-SCREEN.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CALCULATE.
           03 WS-HOURS PIC 9(2)V9(2).
           03 WS-RATE PIC 9(2)V9(2).
           03 WS-REGULAR-HOURS PIC 9(2)V9(2).
           03 WS-REGULAR-RATE PIC 9(2)V9(2).
           03 WS-REGULAR-EARNINGS PIC 9(4)V9(2).
           03 WS-OVERTIME-HOURS PIC 9(2)V9(2).
           03 WS-OVERTIME-RATE PIC 9(2)V9(2).
           03 WS-OVERTIME-EARNINGS PIC 9(4)V9(2).
           03 WS-TOTAL-HOURS PIC 9(2)V9(2).
           03 WS-TOTAL-EARNINGS PIC 9(4)V9(2).
       01  WS-SYS-DATE.
           03 WS-SYS-DATE-YEAR.
               05 WS-SYS-DATE-YR-CENTURY PIC 99.
               05 WS-SYS-DATE-YR-DECADE PIC 99.
           03 WS-SYS-DATE-MONTH PIC 99.
           03 WS-SYS-DATE-DAY PIC 99.
           03 WS-SYS-DATE-HOUR PIC 99.
           03 WS-SYS-DATE-MINUTE PIC 99.
       01  WS-HEADER-DATE.
           03 WS-HEADER-MONTH PIC XX.
           03 FILLER PIC X VALUE '/'.
           03 WS-HEADER-DAY PIC XX.
           03 FILLER PIC X VALUE '/'.
           03 WS-HEADER-YEAR PIC XXXX.
       01  WS-MISC.
           03 WS-EXIT PIC X VALUE SPACES.
       SCREEN SECTION.
       01  SCREEN-HEADER.
           03 BLANK SCREEN.
           03 LINE 01 COL 01 VALUE 'DAVID NGUYEN'.
           03         COL 30 VALUE 'PAYROLL CALCULATION'.
           03         COL 70 PIC X(10) FROM WS-HEADER-DATE.
       01  SCREEN-INPUT-FIELDS.
           03 SCREEN-HOURS.
               05 LINE 7 COL 27 VALUE 'HOURS WORKED'.
               05        COL 47 PIC Z9.99 TO WS-HOURS.
           03 SCREEN-RATE.
               05 LINE 8 COL 27 VALUE 'PAY RATE'.
               05        COL 47 PIC Z9.99 TO WS-RATE.
       01  SCREEN-RESULT.
           03 SCREEN-HEADER-RESULT.
               05 LINE 7 COL 32 VALUE 'HOURS'.
               05        COL 43 VALUE 'RATE'.
               05        COL 52 VALUE 'EARNINGS'.
           03 SCREEN-REGULAR.
               05 LINE 8 COL 19 VALUE 'REGULAR'.
               05        COL 32 PIC Z9.99 FROM WS-REGULAR-HOURS.
               05        COL 42 PIC Z9.99 FROM WS-REGULAR-RATE.
               05        COL 52 PIC Z,ZZ9.99 FROM WS-REGULAR-EARNINGS.
           03 SCREEN-OVERTIME.
               05 LINE 9 COL 19 VALUE 'OVERTIME'.
               05        COL 32 PIC Z9.99 FROM WS-OVERTIME-HOURS.
               05        COL 42 PIC Z9.99 FROM WS-OVERTIME-RATE.
               05        COL 52 PIC Z,ZZ9.99 FROM WS-OVERTIME-EARNINGS.
           03 SCREEN-TOTAL.
               05 LINE 11 COL 19 VALUE 'TOTAL'.
               05         COL 32 PIC Z9.99 FROM WS-TOTAL-HOURS.
               05         COL 52 PIC Z,ZZ9.99 FROM WS-TOTAL-EARNINGS.
       01  SCREEN-EXIT.
           03 LINE 17 COL 25 PIC X TO WS-EXIT AUTO.
           03         COL 16 VALUE 'PRESS ENTER TO CONTINUE (X=EXIT)'.
       01  SCREEN-RESET.
           03 LINE 10 COL 1 ERASE EOS.
       01  SCREEN-END.
           03 BLANK SCREEN.
           03 LINE 25 COL 1 VALUE SPACES.
       01  SCREEN-CLEAR.
           03 BLANK SCREEN.
       PROCEDURE DIVISION.
       100-MAIN.
           PERFORM 200-GET-SCREEN-HDR-DATE.
           PERFORM UNTIL WS-EXIT EQUALS 'X'
               DISPLAY SCREEN-HEADER
               DISPLAY SCREEN-INPUT-FIELDS
               ACCEPT SCREEN-HOURS
               ACCEPT SCREEN-RATE
               PERFORM 300-CALCULATE-REGULAR-OVERTIME
               PERFORM 400-CALCULATE-TOTAL
               DISPLAY SCREEN-CLEAR
               DISPLAY SCREEN-HEADER
               DISPLAY SCREEN-RESULT
               PERFORM 500-RESET-VALUES
               DISPLAY SCREEN-EXIT
               ACCEPT SCREEN-EXIT
               DISPLAY SCREEN-RESET
           END-PERFORM.
           DISPLAY SCREEN-END.
       STOP RUN.
       200-GET-SCREEN-HDR-DATE.
           MOVE FUNCTION CURRENT-DATE TO WS-SYS-DATE.
           MOVE WS-SYS-DATE-MONTH TO WS-HEADER-MONTH.
           MOVE WS-SYS-DATE-DAY TO WS-HEADER-DAY.
           MOVE WS-SYS-DATE-YEAR TO WS-HEADER-YEAR.
       300-CALCULATE-REGULAR-OVERTIME.
           IF WS-HOURS <= 40
               MOVE WS-HOURS TO WS-REGULAR-HOURS
               MOVE WS-RATE TO WS-REGULAR-RATE
               COMPUTE WS-REGULAR-EARNINGS ROUNDED = 
                       WS-REGULAR-HOURS * WS-REGULAR-RATE
           ELSE
               MOVE 40 TO WS-REGULAR-HOURS
               MOVE WS-RATE TO WS-REGULAR-RATE
               COMPUTE WS-REGULAR-EARNINGS = 
                       WS-REGULAR-HOURS * WS-REGULAR-RATE
               COMPUTE WS-OVERTIME-HOURS = WS-HOURS - 40
               COMPUTE WS-OVERTIME-RATE ROUNDED = WS-RATE * 1.5
               COMPUTE WS-OVERTIME-EARNINGS ROUNDED = 
                       WS-OVERTIME-HOURS * WS-OVERTIME-RATE
           END-IF.
       400-CALCULATE-TOTAL.
           COMPUTE WS-TOTAL-HOURS = 
                   WS-REGULAR-HOURS + WS-OVERTIME-HOURS.
           COMPUTE WS-TOTAL-EARNINGS = 
                   WS-REGULAR-EARNINGS + WS-OVERTIME-EARNINGS.
       500-RESET-VALUES.
           MOVE 0.00 TO WS-HOURS.
           MOVE 0.00 TO WS-RATE.
           MOVE 0.00 TO WS-REGULAR-HOURS.
           MOVE 0.00 TO WS-REGULAR-RATE.
           MOVE 0.00 TO WS-REGULAR-EARNINGS.
           MOVE 0.00 TO WS-OVERTIME-HOURS.
           MOVE 0.00 TO WS-OVERTIME-RATE.
           MOVE 0.00 TO WS-OVERTIME-EARNINGS.
           MOVE 0.00 TO WS-TOTAL-HOURS.
           MOVE 0.00 TO WS-TOTAL-EARNINGS.
       END PROGRAM NGUYEN-P03-PAY-SCREEN.
