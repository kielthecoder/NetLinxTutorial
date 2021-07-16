MODULE_NAME='RoomSystem'

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

SEND_STRING dvCONSOLE, 'RoomSystem: Entered DEFINE_START'

SEND_STRING dvCONSOLE, 'RoomSystem: Leaving DEFINE_START'
