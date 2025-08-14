#!/usr/bin/env bash

echo "Robot Teleoperation Start..."

# Define cleanup function
cleanup() {
    echo "Caught Ctrl+C signal. Stopping all child nodes..."
    
    # Close all terminal windows
    for pid in $(pgrep -f 'ros2 launch'); do
        echo "Sending SIGINT to process $pid"
        kill -SIGINT "$pid"
    done
    
    # Wait for all to exit gracefully
    sleep 2
    
    # Ensure all remaining terminal windows are killed
    pkill -f 'master_hfd.launch.py'
    pkill -f 'slave_realman.launch.py'
    pkill -f 'slave_ctek.launch.py'
    pkill -f 'slave_xjcsensor.launch.py'
    pkill -f 'slave_realsense.launch.py'
    
    echo "All child nodes stopped. Exiting..."
    echo "Robot Teleoperation Done..."
    exit 0
}

# Set trap to catch Ctrl+C signal
trap cleanup SIGINT

# Grant permission to all device ports
echo "Grant permission to all device ports..."
echo 156958 | sudo -S chmod 777 /dev/ttyACM0
sudo chmod 777 /dev/ttyACM1
sudo chmod 777 /dev/ttyUSB0

# Launch slave_xjcsensor node
echo "Launch slave_xjcsensor node..."
gnome-terminal --title="SLAVE-XJCSENSOR" -- bash -c "ros2 launch xjcsensor_teleoperation slave_xjcsensor.launch.py; exec bash"

# Launch master_hfd node
echo "Launch master_hfd node..."
gnome-terminal --title="MASTER-HFD" -- bash -c "ros2 launch hfd_teleoperation master_hfd.launch.py; exec bash"

# Launch slave_realman node
echo "Launch slave_realman node..."
gnome-terminal --title="SLAVE-REALMAN" -- bash -c "ros2 launch realman_teleoperation slave_realman.launch.py; exec bash"

# Launch slave_ctek node
echo "Launch slave_ctek node..."
gnome-terminal --title="SLAVE-CTEK" -- bash -c "ros2 launch ctek_teleoperation slave_ctek.launch.py; exec bash"

# Launch slave_realsense node
echo "Launch slave_realsense node..."
gnome-terminal --title="SLAVE-REALSENSE" -- bash -c "ros2 launch realsense_teleoperation slave_realsense.launch.py; exec bash"

# Catch Ctrl+C signal
echo "Press Ctrl+C to exit..."
while true; do
    sleep 1
done
