MODULE_NAME='Room System' (DEV vdvROOM, DEV dvTP)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvCONSOLE = 0:1:0	// Master Controller

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

TL_STARTUP  = 1
TL_SHUTDOWN = 2

(***********************************************************)
(*                  INCLUDE FILES GO BELOW                 *)
(***********************************************************)

#INCLUDE 'SNAPI'

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG lWaitTimes[] = { 200, 200, 200, 200, 200,
                      200, 200, 200, 200, 200 }

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

SEND_STRING dvCONSOLE, 'Room System: Entered DEFINE_START'

SEND_STRING dvCONSOLE, 'Room System: Leaving DEFINE_START'

(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvTP]
{
    ONLINE:
    {
	IF ([vdvROOM,POWER_FB])
	{
	    SEND_COMMAND dvTP,'@PPX'
	    SEND_COMMAND dvTP,'@PPN-Source Selection'
	}
	ELSE
	{
	    SEND_COMMAND dvTP,'@PPX'
	    SEND_COMMAND dvTP,'@PPN-Start System'
	}
    }
}

CHANNEL_EVENT[vdvROOM,POWER_FB]
{
    ON:
    {
	SEND_COMMAND dvTP,'PAGE-Wait'
	SEND_COMMAND dvTP,'^ANI-2,1,12,10'
	SEND_COMMAND dvTP,'^TXT-1,0,System is starting up...'
	SEND_LEVEL dvTP,2,0
	
	TIMELINE_CREATE(TL_STARTUP, lWaitTimes, LENGTH_ARRAY(lWaitTimes),
	    TIMELINE_RELATIVE, TIMELINE_ONCE)
    }
    OFF:
    {
	SEND_COMMAND dvTP,'PAGE-Wait'
	SEND_COMMAND dvTP,'^ANI-2,1,12,10'
	SEND_COMMAND dvTP,'^TXT-1,0,System is shutting down...'
	SEND_LEVEL dvTP,2,0
	
	TIMELINE_CREATE(TL_SHUTDOWN, lWaitTimes, LENGTH_ARRAY(lWaitTimes),
	    TIMELINE_RELATIVE, TIMELINE_ONCE)
    }
}

TIMELINE_EVENT[TL_STARTUP]
{
    SEND_LEVEL dvTP,2,TIMELINE.SEQUENCE
    
    SWITCH (TIMELINE.SEQUENCE)
    {
	CASE 5:
	{
	    SEND_COMMAND dvTP,'^ANI-2,1,12,10'
	}
	CASE 10:
	{
	    SEND_COMMAND dvTP,'PAGE-Main'
	    SEND_COMMAND dvTP,'@PPX'
	    SEND_COMMAND dvTP,'@PPN-Source Selection'
	}
    }
}

TIMELINE_EVENT[TL_SHUTDOWN]
{
    SEND_LEVEL dvTP,2,TIMELINE.SEQUENCE
    
    SWITCH (TIMELINE.SEQUENCE)
    {
	CASE 5:
	{
	    SEND_COMMAND dvTP,'^ANI-2,1,12,10'
	}
	CASE 10:
	{
	    SEND_COMMAND dvTP,'PAGE-Main'
	    SEND_COMMAND dvTP,'@PPX'
	    SEND_COMMAND dvTP,'@PPN-Start System'
	}
    }
}

