#!/usr/bin/env bash

echo "Robot Teleoperation Start..."

# Declare array variables for storing all node pids and terminal pids
declare -a node_pids
declare -a terminal_pids

# Define cleanup function
cleanup() {
    echo "Caught Ctrl+C signal. Stopping all child nodes..."
    
    # Stop all child nodes and wait for them to exit
    for pid in "${node_pids[@]}"; do
        if ps -p $pid > /dev/null; then
            kill -s SIGINT $pid
            wait $pid 2>/dev/null
            kill -SIGHUP $(ps -o ppid= -p $pid)
        fi
    done
    
    echo "All child nodes stopped. Exiting..."
    echo "Robot Teleoperation Done..."
    exit 0
}

# Set trap to catch Ctrl+C signal
trap cleanup SIGINT

# Grant permission to all device ports
echo "Grant permission to all device ports..."
sudo chmod 777 /dev/ttyACM0
sudo chmod 777 /dev/ttyACM1
sudo chmod 777 /dev/ttyUSB0

# Declare launch_node function
launch_node() {
    # Define the local variables for launching node
    local title=$1
    local device=$2
    local type=$3
    
    # Launch node in sub terminal
    gnome-terminal --tab --maximize --title="$title" -- bash -c "ros2 launch ${device}_teleoperation ${type}_${device}.launch.py; exec bash" &
    local pid=$(ps -o ppid= -p $(pstree -p | grep -oP "$device\(\K[0-9]+(?=\))"))
    node_pids+=$pid
    terminal_pids+=$(ps -o ppid= -p $pid)
    sleep 0.5
}

# Launch slave_xjcsensor node
echo "Launch slave_xjcsensor node..."
launch_node "SLAVE-XJCSENSOR" "xjcsensor" "slave"

# Launch master_hfd node
echo "Launch master_hfd node..."
launch_node "MASTER-HFD" "hfd" "master"

# Launch slave_realman node
echo "Launch slave_realman node..."
launch_node "SLAVE-REALMAN" "realman" "slave"

# Launch slave_ctek node
echo "Launch slave_ctek node..."
launch_node "SLAVE-CTEK" "ctek" "slave"

# Launch slave_realsense node
echo "Launch slave_realsense node..."
launch_node "SLAVE-REALSENSE" "realsense" "slave"

# Catch Ctrl+C signal
echo "All child nodes started. Press Ctrl+C to exit..."
while true; do
    sleep 1
done
