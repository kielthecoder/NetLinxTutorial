PROGRAM_NAME='Main Program'

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvCONSOLE = 0:1:0	// Master Controller

dvCOM1 = 5001:1:0	// RS-232 port 1
dvCOM2 = 5001:2:0	// RS-232 port 2

dvIR1 = 5001:9:0	// IR port 1
dvIR2 = 5001:10:0	// IR port 2

dvRELAY = 5001:8:0	// Relays
dvIO    = 5001:17:0	// GPIO

dvTP1 = 10001:1:0	// NXT-1200

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

DATA_EVENT[dvTP1]
{
    ONLINE:
    {
	SEND_COMMAND dvTP1, 'ADBEEP'
    }
}

BUTTON_EVENT[dvTP1,1] // Touch to Start System
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	SEND_COMMAND dvTP1,'^PPK-Start System'
	SEND_COMMAND dvTP1,'^PPN-Source Selection'
    }
}

BUTTON_EVENT[dvTP1,2] // Power Off
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	SEND_COMMAND dvTP1,'^PPK-Source Selection'
	SEND_COMMAND dvTP1,'^PPN-Start System'
    }
}

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
