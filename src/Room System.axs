MODULE_NAME='Room System' (DEV vdvROOM, DEV dvTP)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvCONSOLE = 0:1:0	// Master Controller

(***********************************************************)
(*                  INCLUDE FILES GO BELOW                 *)
(***********************************************************)

#INCLUDE 'SNAPI'

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
	SEND_COMMAND dvTP,'@PPX'
	SEND_COMMAND dvTP,'@PPN-Source Selection'
    }
    OFF:
    {
	SEND_COMMAND dvTP,'@PPX'
	SEND_COMMAND dvTP,'@PPN-Start System'
    }
}

