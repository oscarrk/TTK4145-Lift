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

  Spawn 4x simulators                                      (0)
  Spawn 4x simulator and elevator controller pairs         (1)
  Send elevator 1 upward                                   (2)
  Hold HallUp 1st floor for 2 sec in elevator 1            (3)
  Rebuild and restart controllers                          (4)
  Emulate packet loss on network adapter                   (5)
  Remove emulated packet loss                              (6)
  Spawn 4x terminals for the simulators                    (7)
  Quit                                                     (Q)
--------------------------------------------------------------
Choose an option:
EOF
    read -n1 -s
    case "$REPLY" in
    "0")
        echo "Launching 4 simulators"
        cd driver/simulators
        gnome-terminal -e "rdmd sim_server.d ./config-53566.con" --geometry 65x10+80+100 --title="sim53566"
        gnome-terminal -e "rdmd sim_server.d ./config-53567.con" --geometry 65x10+80+320 --title="sim53567"
        gnome-terminal -e "rdmd sim_server.d ./config-53568.con" --geometry 65x10+80+540 --title="sim53568"
        gnome-terminal -e "rdmd sim_server.d ./config-53569.con" --geometry 65x10+80+760 --title="sim53569"
        cd ../..
        ;;
    "1")
        echo "Launching 4 simulators"
        cd driver/simulators
        gnome-terminal -e "rdmd sim_server.d ./config-53566.con" --geometry 65x10+80+100 --title="sim53566"
        gnome-terminal -e "rdmd sim_server.d ./config-53567.con" --geometry 65x10+80+320 --title="sim53567"
        gnome-terminal -e "rdmd sim_server.d ./config-53568.con" --geometry 65x10+80+540 --title="sim53568"
        gnome-terminal -e "rdmd sim_server.d ./config-53569.con" --geometry 65x10+80+760 --title="sim53569"
        cd ../..

        read -p "Press any key to continue when simulators are ready... " -n1 -s

        gnome-terminal -e './TTK4145-Lift -sim 53566 -nick sim53566 -raft 8000' --geometry 90x10+680+100 --title="controller53566"
        sleep 5
        gnome-terminal -e './TTK4145-Lift -sim 53567 -nick sim53567 -raft 8002' --geometry 90x10+680+320 --title="controller53567"
        sleep 5
        gnome-terminal -e './TTK4145-Lift -sim 53568 -nick sim53568 -raft 8004' --geometry 90x10+680+540 --title="controller53568"
        sleep 5
        gnome-terminal -e './TTK4145-Lift -sim 53569 -nick sim53569 -raft 8006' --geometry 90x10+680+760 --title="controller53569"

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
        gnome-terminal -e './TTK4145-Lift -sim 53566 -nick sim53566' --geometry 90x10+680+100 --title="controller53566"
        gnome-terminal -e './TTK4145-Lift -sim 53567 -nick sim53567' --geometry 90x10+680+320 --title="controller53567"
        gnome-terminal -e './TTK4145-Lift -sim 53568 -nick sim53568' --geometry 90x10+680+540 --title="controller53568"
        gnome-terminal -e './TTK4145-Lift -sim 53569 -nick sim53569' --geometry 90x10+680+760 --title="controller53569"
        sleep .2
        CTRL1=$(xdotool search --name controller53566)
        CTRL2=$(xdotool search --name controller53567)
        CTRL3=$(xdotool search --name controller53568)
        CTRL4=$(xdotool search --name controller53569)
        # Return to main
        xdotool windowactivate --sync $MAIN
        ;;
    "5")
        echo "Enter name of network adapter: "
        read adapter
        echo "Select percentage of packets to drop: "
        read percentage
        sudo tc qdisc add dev $adapter root netem loss $percentage% && echo "Packet loss set to $percentage %"
        ;;
    "6")
        sudo tc qdisc del dev $adapter root netem loss $percentage%
        echo "Emulated packet loss reset"
        ;;
    "7")
        echo "Launching 4 simulators"
        gnome-terminal --geometry 135x10+680+100
        gnome-terminal --geometry 135x10+680+320
        gnome-terminal --geometry 135x10+680+540
        gnome-terminal --geometry 135x10+680+760
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
