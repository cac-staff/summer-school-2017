MODULE BASIC_DATA_MDL
    IMPLICIT NONE
    REAL*16, PARAMETER :: RADIUS  = 1.0Q0
    REAL*16, PARAMETER :: RADIUS_SQUIRED = RADIUS ** 2
    REAL*16, PARAMETER :: REQUIRED_ACCURACY  = 1.0Q-212
END MODULE BASIC_DATA_MDL




MODULE INTERFACE_MDL
INTERFACE
REAL*16 FUNCTION NEXT_CHORD(CHORD_TRIED)
    REAL*16 :: CHORD_TRIED
END FUNCTION NEXT_CHORD
END INTERFACE
END MODULE INTERFACE_MDL




REAL*16 FUNCTION NEXT_CHORD(CHORD_TRIED)
    USE BASIC_DATA_MDL
    IMPLICIT NONE
    REAL*16 :: CHORD_TRIED, HALF, HALF_SQUIRED, VT1, VT2
    HALF = CHORD_TRIED/2
    HALF_SQUIRED = HALF * HALF
    VT1 = SQRT(RADIUS_SQUIRED - HALF_SQUIRED)
    VT2 = RADIUS - VT1
    NEXT_CHORD = SQRT(HALF_SQUIRED + VT2*VT2)
    RETURN
END FUNCTION NEXT_CHORD




MODULE WORKING_MDL
    USE BASIC_DATA_MDL
    IMPLICIT NONE
    INTEGER, PARAMETER     :: OUTPUT_FILE_UNIT = 12
    CHARACTER(*), PARAMETER:: OUTPUT_FILE = 'pi_calculated.dat'
    INTEGER                :: EFFORT
    REAL*16                :: CHORD
    REAL*16                :: NUMBER_OF_CHORDS
    REAL*16                :: PREVIOUS_PI
    REAL*16                :: CURRENT_PI
    REAL*16                :: RELATIVE_ERROR


    CONTAINS


    SUBROUTINE INITIALIZATION()
    IMPLICIT NONE
    OPEN(OUTPUT_FILE_UNIT, FILE = OUTPUT_FILE)
    EFFORT = 1
    CHORD = SQRT(RADIUS_SQUIRED + RADIUS_SQUIRED)
    NUMBER_OF_CHORDS = 2.0Q0
    PREVIOUS_PI = 8.0Q10
    CURRENT_PI = CHORD * NUMBER_OF_CHORDS / RADIUS
    RELATIVE_ERROR = ABS(CURRENT_PI - PREVIOUS_PI) / CURRENT_PI
    CALL STEP_OUTPUT('Initialized for PI computing: ')
    RETURN
    END SUBROUTINE INITIALIZATION


    SUBROUTINE STEP_OUTPUT(A_STRING)
    IMPLICIT NONE
    CHARACTER (LEN=*) :: A_STRING
    WRITE(OUTPUT_FILE_UNIT, *) A_STRING
    WRITE(OUTPUT_FILE_UNIT, *) EFFORT, CHORD, CURRENT_PI
    WRITE(*, *)                EFFORT, CHORD, CURRENT_PI
    RETURN
    END SUBROUTINE STEP_OUTPUT


    SUBROUTINE FINALIZATION()
    IMPLICIT NONE
    CALL STEP_OUTPUT("This is my result of PI: ")
    WRITE(OUTPUT_FILE_UNIT, *) "with previous PI     : ", PREVIOUS_PI
    WRITE(OUTPUT_FILE_UNIT, *) "relative error       : ", RELATIVE_ERROR
    WRITE(OUTPUT_FILE_UNIT, *) "and required accuracy: ", REQUIRED_ACCURACY
    CLOSE(OUTPUT_FILE_UNIT)
    RETURN
    END SUBROUTINE FINALIZATION


END MODULE WORKING_MDL




SUBROUTINE CALCULATE_PI()
    USE INTERFACE_MDL
    USE WORKING_MDL
    IMPLICIT NONE
    WORKING_HARD: DO
        EFFORT = EFFORT + 1
        CHORD = NEXT_CHORD(CHORD)
        NUMBER_OF_CHORDS = 2.0Q0 * NUMBER_OF_CHORDS
        PREVIOUS_PI = CURRENT_PI
        CURRENT_PI = CHORD * NUMBER_OF_CHORDS / RADIUS
        RELATIVE_ERROR = ABS(CURRENT_PI - PREVIOUS_PI) / CURRENT_PI
        CALL STEP_OUTPUT(' ')
        IF(RELATIVE_ERROR < REQUIRED_ACCURACY) EXIT WORKING_HARD
    END DO WORKING_HARD
    RETURN
END SUBROUTINE CALCULATE_PI




PROGRAM PI_CALCULATION
    USE WORKING_MDL
    IMPLICIT NONE
    CALL INITIALIZATION()
    CALL CALCULATE_PI()
    CALL FINALIZATION()
    STOP
END PROGRAM PI_CALCULATION



