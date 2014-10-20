#!/bin/bash

CD_CMD="cd "\\\"$(pwd)\\\"" && clear"
VERSION=$(sw_vers -productVersion)

if (( $(expr $VERSION '<' 10.7) )); then
	RUNNING=$(osascript<<END
	tell application "System Events"
	    count(processes whose name is "iTerm")
	end tell
END
)
else
	RUNNING=1
fi

if (( $RUNNING )); then
	osascript<<END
	tell application "iTerm"
		make new terminal
		set c to (current terminal)
		try
			get c
		on error
			set c to (make new terminal)
		end try
		
		tell c
			activate current session
			
			set l to (launch session "Default Session")
			tell l
				write text "$CD_CMD"
			end tell
		end tell
	end tell
END
else
	osascript<<END
	tell application "iTerm"
		activate
		set sess to the first session of the first terminal
		tell sess
			write text "$CD_CMD"
		end tell
	end tell
END
fi