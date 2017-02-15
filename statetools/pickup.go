package statetools

import (
	"strconv"

	"bitbucket.org/halvor_haukvik/ttk4145-elevator/globalstate"
)

// ShouldStopAndPickup asd
func ShouldStopAndPickup(s globalstate.State, currentFloor int, currentDir string) bool {
	// Extract applicable buttons
	var buttons map[string]globalstate.Status
	if currentDir == "up" {
		buttons = s.HallUpButtons
	} else if currentDir == "down" {
		buttons = s.HallDownButtons
	} else {
		return false
	}

	// Get status for the current floor
	status, ok := buttons[strconv.Itoa(currentFloor)]
	if !ok {
		return false
	}

	if status.LastStatus != "done" {
		return true
	}
	return false

}
