#!/usr/bin/env bash

echo "Robot Teleoperation Start..."

# Get the config parameters from yaml config file
user_password=$1
haptic_name=$2
haptic_type=$3
haptic_port=$4
haptic_title=$5
robot_name=$6
robot_type=$7
robot_port=$8
robot_title=$9
effector_name=${10}
effector_type=${11}
effector_port=${12}
effector_title=${13}
sensor_name=${14}
sensor_type=${15}
sensor_port=${16}
sensor_title=${17}
camera_name=${18}
camera_type=${19}
camera_port=${20}
camera_title=${21}
shift 21
launch_order=("$@")
device_names=($haptic_name $robot_name $effector_name $sensor_name $camera_name)
device_types=($haptic_type $robot_type $effector_type $sensor_type $camera_type)
device_ports=($haptic_port $robot_port $effector_port $sensor_port $camera_port)
device_titles=($haptic_title $robot_title $effector_title $sensor_title $camera_title)

# Declare array variables for storing all node pids and terminal pids
declare -a node_pids

# Define cleanup function
cleanup() {
    echo "Caught Ctrl+C signal. Stopping all child nodes..."
    
    # Stop all child nodes and wait for them to exit
    for pid in "${node_pids[@]}"; do
        if ps -p $pid > /dev/null 2>&1; then
            pgid=$(ps -o pgid= -p $pid 2>/dev/null | tr -d ' ')
            ppid=$(ps -o ppid= -p $pid 2>/dev/null | awk '{print $1}')
            kill -s SIGINT -$pgid 2>/dev/null
            (   while kill -0 -$pgid 2>/dev/null; do
                    sleep 0.5
                done
                kill -SIGHUP $ppid 2>/dev/null
            ) &
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
for port in "${device_ports[@]}"; do
    if [ -n $port ] && [ $port != "None" ]; then
        echo $user_password | sudo -S chmod 777 $port
    fi
done

# Declare launch_node function
launch_node() {
    # Define the local variables for launching node
    local name=$1
    local type=$2
    local title=$3
    
    # Launch node in sub terminal
    gnome-terminal --tab --maximize --title="$title" -- bash -c "ros2 launch ${name}_teleoperation ${type}_${name}.launch.py; exit"
    local pid=$(pgrep -f "ros2 launch ${name}_teleoperation ${type}_${name}.launch.py")
    node_pids+=($pid)
}

# Launch all child nodes
for index in "${launch_order[@]}"; do
    echo "Launch ${device_types[$index]}_${device_names[$index]} node..."
    launch_node ${device_names[$index]} ${device_types[$index]} ${device_titles[$index]}
done

# Catch Ctrl+C signal
echo "All child nodes started. Press Ctrl+C to exit..."
while true; do
    sleep 0.5
done
