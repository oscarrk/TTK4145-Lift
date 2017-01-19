#!/bin/bash
MAIN=$(xdotool getwindowfocus)
while :
do
    clear
    cat<<EOF
==============================================================
  Elevator test suite
--------------------------------------------------------------
  Please enter your choice:

  Spawn 4x simulator and elevator controller pairs         (1)
  Send elevator 1 upward                                   (2)
  Hold HallUp 1st floor for 2 sec in elevator 1            (3)
  Rebuild and restart controllers                          (4)
  Quit                                                     (Q)
--------------------------------------------------------------
Choose and option:
EOF
    read -n1 -s
    case "$REPLY" in
    "1")
        echo "Spawning simulator and controllers"
        ./launch-4xsimulator.sh
        echo "Select simulators"
        SIM1=$(xdotool search --name sim53566)
        SIM2=$(xdotool search --name sim53567)
        SIM3=$(xdotool search --name sim53568)
        SIM4=$(xdotool search --name sim53569)
        CTRL1=$(xdotool search --name controller53566)
        CTRL2=$(xdotool search --name controller53567)
        CTRL3=$(xdotool search --name controller53568)
        CTRL4=$(xdotool search --name controller53569)
        xdotool windowactivate --sync $MAIN
        ;;
    "2")
        echo "Entering UP command to simulator 1"
        xdotool windowactivate --sync $SIM1 key "9"
        # Return to main
        xdotool windowactivate --sync $MAIN
        ;;
    "3")
        echo "Holding Hallup in 1st floor, elevator 1"
        xdotool windowactivate --sync $SIM1 keydown q
        echo "Depressing key"
        sleep 2
        xdotool windowactivate --sync $SIM1 keyup q
        # Return to main
        xdotool windowactivate --sync $MAIN
        ;;
    "4")
        sleep .2
        xdotool windowactivate $CTRL1 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL2 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL3 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL4 key ctrl+c
        sleep .2
        echo "Building..."
        go build .
        echo "Build complete!"
        gnome-terminal -e './ttk4145-elevator -sim 53566 -nick sim53566' --geometry 90x10+680+100 --title="controller53566"
        gnome-terminal -e './ttk4145-elevator -sim 53567 -nick sim53567' --geometry 90x10+680+320 --title="controller53567"
        gnome-terminal -e './ttk4145-elevator -sim 53568 -nick sim53568' --geometry 90x10+680+540 --title="controller53568"
        gnome-terminal -e './ttk4145-elevator -sim 53569 -nick sim53569' --geometry 90x10+680+760 --title="controller53569"
        sleep .2
        CTRL1=$(xdotool search --name controller53566)
        CTRL2=$(xdotool search --name controller53567)
        CTRL3=$(xdotool search --name controller53568)
        CTRL4=$(xdotool search --name controller53569)
        # Return to main
        xdotool windowactivate --sync $MAIN
        ;;
    "Q")
        sleep .2
        xdotool windowactivate $SIM1 key ctrl+c
        sleep .2
        xdotool windowactivate $SIM2 key ctrl+c
        sleep .2
        xdotool windowactivate $SIM3 key ctrl+c
        sleep .2
        xdotool windowactivate $SIM4 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL1 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL2 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL3 key ctrl+c
        sleep .2
        xdotool windowactivate $CTRL4 key ctrl+c
        sleep .2
        exit
        ;;
    "q")
        echo "case sensitive!!"
        ;;
     * )
        echo "invalid option"
        ;;
    esac
    read -p "Press enter to continue"
done