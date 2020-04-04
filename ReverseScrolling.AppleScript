try
	tell application "System Preferences"
		activate
		set current pane to pane "com.apple.preference.trackpad"
		delay (0.4)
	end tell
	
	tell application "System Events"
		tell process "System Preferences"
			click radio button "Scroll & Zoom" of tab group 1 of window "Trackpad"
			delay (0.2)
			click checkbox 1 of tab group 1 of window "Trackpad"
			delay (0.7)
		end tell
	end tell
	
	tell application "System Preferences" to quit
	
end try
