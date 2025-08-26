#!/usr/bin/env bash

echo "Robot Teleoperation Start..."

# Declare array variable for storing all terminal pids
declare -a terminal_pids

# Define cleanup function
cleanup() {
    echo "Caught Ctrl+C signal. Stopping all child nodes..."
    
    # Stop all child nodes and wait for them to exit
    for pid in "${terminal_pids[@]}"; do
        if ps -p $pid > /dev/null; then
            kill -s SIGINT $pid
            wait $pid 2>/dev/null
            kill -9 $pid
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

# Launch slave_xjcsensor node
echo "Launch slave_xjcsensor node..."
gnome-terminal --title="SLAVE-XJCSENSOR" -- bash -c "ros2 launch xjcsensor_teleoperation slave_xjcsensor.launch.py; exec bash; read" &
terminal_pids+=($!)
sleep 0.5

# Launch master_hfd node
echo "Launch master_hfd node..."
gnome-terminal --title="MASTER-HFD" -- bash -c "ros2 launch hfd_teleoperation master_hfd.launch.py; exec bash; read" &
terminal_pids+=($!)

# Launch slave_realman node
echo "Launch slave_realman node..."
gnome-terminal --title="SLAVE-REALMAN" -- bash -c "ros2 launch realman_teleoperation slave_realman.launch.py; exec bash; read" &
terminal_pids+=($!)

# Launch slave_ctek node
echo "Launch slave_ctek node..."
gnome-terminal --title="SLAVE-CTEK" -- bash -c "ros2 launch ctek_teleoperation slave_ctek.launch.py; exec bash; read" &
terminal_pids+=($!)

# Launch slave_realsense node
echo "Launch slave_realsense node..."
gnome-terminal --title="SLAVE-REALSENSE" -- bash -c "ros2 launch realsense_teleoperation slave_realsense.launch.py; exec bash; read" &
terminal_pids+=($!)

# Catch Ctrl+C signal
echo "Press Ctrl+C to exit..."
while true; do
    sleep 1
done
