PROGRAM_NAME='Main Program'

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvCONSOLE = 0:1:0	// Master Controller

dvIO = 5001:17:0	// GPIO

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

TL_LOOP = 1

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG lLoopTimes[] = { 500, 500, 500, 500, 500, 500, 500, 500 }

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

TIMELINE_CREATE(TL_LOOP, lLoopTimes, LENGTH_ARRAY(lLoopTimes),
    TIMELINE_RELATIVE, TIMELINE_REPEAT);

(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[TL_LOOP]
{
    [dvIO,1] = (TIMELINE.SEQUENCE == 1)
    [dvIO,2] = (TIMELINE.SEQUENCE == 2)
    [dvIO,3] = (TIMELINE.SEQUENCE == 3)
    [dvIO,4] = (TIMELINE.SEQUENCE == 4)
    [dvIO,5] = (TIMELINE.SEQUENCE == 5)
    [dvIO,6] = (TIMELINE.SEQUENCE == 6)
    [dvIO,7] = (TIMELINE.SEQUENCE == 7)
    [dvIO,8] = (TIMELINE.SEQUENCE == 8)
    
    IF (TIMELINE.SEQUENCE == 8)
    {
	SEND_STRING dvCONSOLE, 'One more time!'
    }
}
