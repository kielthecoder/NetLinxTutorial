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

dvTP1     = 10001:1:0	// MXP-9000i
dvTP1_SWT = 10001:2:0	//   Switcher controls

vdvROOM = 33001:1:0

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

INTEGER btnSystemPower[] = { 1, 2 }
INTEGER btnSources[] = { 1, 2, 3, 4, 5, 6, 7, 8 }

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

BUTTON_EVENT[dvTP1,btnSystemPower]
{
    PUSH:
    {
	TO[BUTTON.INPUT]
	
	[vdvROOM,255] = (GET_LAST(btnSystemPower) == 1)
    }
}

BUTTON_EVENT[dvTP1_SWT,btnSources]
{
    PUSH:
    {
	INTEGER i, n
	
	n = GET_LAST(btnSources)
	
	FOR (i = 1; i <= 8; i++)
	{
	    [dvTP1_SWT,i] = (i == n)
	}
	
	IF (n == 5) // AppleTV input
	{
	    SEND_COMMAND dvTP1,'^SHO-3,1'
	}
	ELSE
	{
	    SEND_COMMAND dvTP1,'^SHO-3,0'
	}
    }
}

CHANNEL_EVENT[vdvROOM,255]
{
    ON:
    {
	SEND_COMMAND dvTP1,'@PPK-Start System'
	SEND_COMMAND dvTP1,'@PPN-Source Selection'
    }
    OFF:
    {
	SEND_COMMAND dvTP1,'@PPK-Source Selection'
	SEND_COMMAND dvTP1,'@PPN-Start System'
    }
}

CHANNEL_EVENT[dvIO,1]	// Fire Alarm
{
    OFF:
    {
	OFF[vdvROOM,255]
    }
}
