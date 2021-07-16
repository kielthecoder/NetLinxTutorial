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

dvTP1       = 10001:1:0	 // MXP-9000i
dvTP1_SWT   = 10001:2:0	 // Switcher controls
dvTP1_TPORT = 10001:3:0	 // Transport controls

vdvROOM = 33001:1:0
vdvSWT  = 33002:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

TL_LOOP = 1

(***********************************************************)
(*                  INCLUDE FILES GO BELOW                 *)
(***********************************************************)

#INCLUDE 'SNAPI'

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

LONG lLoopTimes[] = { 500, 500, 500, 500, 500, 500, 500, 500 }

INTEGER btnSystemPower[] = { 1, 2 }
INTEGER btnSources[]     = { 1, 2, 3, 4, 5, 6, 7, 8 }

INTEGER btnAppleTV[] = {
	PLAY,
	MENU_FUNC,
	MENU_UP,
	MENU_DN,
	MENU_LT,
	MENU_RT,
	MENU_SELECT
    }

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_MODULE 'Room System' mRoomSystem (vdvROOM,dvTP1)
DEFINE_MODULE 'Simple Switcher' mSwitcher (vdvSWT,dvCOM1)

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

SEND_STRING dvCONSOLE, 'Main Program: Entered DEFINE_START'

TIMELINE_CREATE(TL_LOOP, lLoopTimes, LENGTH_ARRAY(lLoopTimes),
    TIMELINE_RELATIVE, TIMELINE_REPEAT);

SEND_STRING dvCONSOLE, 'Main Program: Leaving DEFINE_START'

(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvTP1]
{
    ONLINE:
    {
	SEND_COMMAND dvTP1,'ADBEEP'
    }
}

BUTTON_EVENT[dvTP1,btnSystemPower]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	[vdvROOM,POWER_ON] = (GET_LAST(btnSystemPower) == 1)
    }
}

BUTTON_EVENT[dvTP1,3]	// Toggle AppleTV popup
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	SEND_COMMAND dvTP1,'PPOG-AppleTV'
    }
}

BUTTON_EVENT[dvTP1_SWT,btnSources]
{
    PUSH:
    {
	SEND_LEVEL vdvSWT,1,GET_LAST(btnSources)
    }
}

BUTTON_EVENT[dvTP1_TPORT,btnAppleTV]
{
    PUSH:
    {
	TO[dvIR1,BUTTON.INPUT.CHANNEL]
    }
}

LEVEL_EVENT[vdvSWT,1]
{
    INTEGER i
    
    FOR (i = 1; i <= 8; i++)
    {
	[dvTP1_SWT,i] = (i == LEVEL.VALUE)
    }
    
    IF (LEVEL.VALUE == 5)
    {
	SEND_COMMAND dvTP1,'^SHO-3,1'
    }
    ELSE
    {
	SEND_COMMAND dvTP1,'^SHO-3,0'
    }
}

CHANNEL_EVENT[vdvROOM,POWER_FB]
{
    OFF:
    {
	SEND_LEVEL vdvSWT,1,0
    }
}

CHANNEL_EVENT[dvIO,1]	// Fire Alarm
{
    OFF:
    {
	OFF[vdvROOM,POWER_ON]
    }
}
