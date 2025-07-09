#!/usr/bin/env bash

echo "Robot Teleoperation Start..."

# Launch master_hfd node
echo "Launch master_hfd node..."
gnome-terminal -- bash -c "ros2 launch hfd_teleoperation master_hfd.launch.py; exec bash" &
PID1=$!

# Launch slave_realman node
echo "Launch slave_realman node..."
gnome-terminal -- bash -c "ros2 launch realman_teleoperation slave_realman.launch.py; exec bash" &
PID2=$!

# Launch slave_ctek node
echo "Launch slave_ctek node..."
gnome-terminal -- bash -c "ros2 launch ctek_teleoperation slave_ctek.launch.py; exec bash" &
PID3=$!

# Launch slave_xjcsensor node
# echo "Launch slave_xjcsensor node..."
# gnome-terminal -- bash -c "ros2 launch xjcsensor_teleoperation slave_xjcsensor.launch.py; exec bash" &
# PID4=$!

# Launch slave_realsense node
# echo "Launch slave_realsense node..."
# gnome-terminal -- bash -c "ros2 launch realsense_teleoperation slave_realsense.launch.py; exec bash" &
# PID5=$!

# Catch Ctrl+C signal
trap "echo 'Caught Ctrl+C signal, killing all child processes...'; kill $PID1 $PID2 $PID3; exit 0" SIGINT

# Wait for all child processes to finish
wait

echo "Robot Teleoperation Done..."
