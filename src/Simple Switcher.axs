MODULE_NAME='Simple Switcher' (DEV vdv, DEV dv)

DEFINE_VARIABLE

INTEGER nOutputs[] = { 1 }

NON_VOLATILE INTEGER nSelectedInput[] = { 0 }

DEFINE_EVENT

DATA_EVENT[dv]
{
    ONLINE:
    {
	SEND_COMMAND dv, 'SET BAUD 9600,N,8,1'
	SEND_COMMAND dv, 'HSOFF'
    }
}

DATA_EVENT[vdv]
{
    ONLINE:
    {
	LOCAL_VAR INTEGER i;
	
	FOR (i = 1; i <= LENGTH_ARRAY(nSelectedInput); i++)
	{
	    SEND_LEVEL vdv,i,nSelectedInput[i]
	}
    }
    COMMAND:
    {
	LOCAL_VAR INTEGER in;
	LOCAL_VAR INTEGER out;
	
	// CI<input>O<output>
	// Switch input to output, All levels
	IF (LEFT_STRING(DATA.TEXT, 2) == 'CI')
	{
	    REMOVE_STRING(DATA.TEXT, 'I', 1)
	    in = ATOI(DATA.TEXT)
	    REMOVE_STRING(DATA.TEXT, 'O', 1)
	    out = ATOI(DATA.TEXT)
	    
	    nSelectedInput[out] = in
	    SEND_STRING dv, "ITOA(in),'*',ITOA(out),'!'"
	}
    }
}

LEVEL_EVENT[vdv,nOutputs]
{
    SEND_COMMAND vdv,"'CI',ITOA(LEVEL.VALUE),'O',ITOA(LEVEL.INPUT.LEVEL)"
}

