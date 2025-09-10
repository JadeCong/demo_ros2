#!/usr/bin/env python3
# Copyright 2023 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os, yaml
import launch
from launch import LaunchDescription
from launch.actions import ExecuteProcess
from ament_index_python.packages import get_package_share_directory


def generate_launch_description():
    """
    Generate launch description for robot_teleoperation node.
    """
    
    script_file = os.path.join(get_package_share_directory('robot_teleoperation'), 'scripts', 'robot_teleoperation.sh')
    config_file = os.path.join(get_package_share_directory('robot_teleoperation'), 'config', 'robot_teleoperation.yaml')
    
    with open(config_file, 'r') as f:
        params = yaml.safe_load(f)
    
    robot_teleoperation_params = params['robot_teleoperation']['ros__parameters']
    node_name = robot_teleoperation_params.get('node_name', '')
    user_password = robot_teleoperation_params.get('user_password', '')
    hardware_device = robot_teleoperation_params.get('hardware_device', {})
    
    haptic_params = hardware_device.get('haptic', {})
    haptic_name = haptic_params.get('name', '')
    haptic_type = haptic_params.get('type', '')
    haptic_port = haptic_params.get('port', '')
    haptic_title = haptic_params.get('title', '')
    
    robot_params = hardware_device.get('robot', {})
    robot_name = robot_params.get('name', '')
    robot_type = robot_params.get('type', '')
    robot_port = robot_params.get('port', '')
    robot_title = robot_params.get('title', '')
    
    effector_params = hardware_device.get('effector', {})
    effector_name = effector_params.get('name', '')
    effector_type = effector_params.get('type', '')
    effector_port = effector_params.get('port', '')
    effector_title = effector_params.get('title', '')
    
    sensor_params = hardware_device.get('sensor', {})
    sensor_name = sensor_params.get('name', '')
    sensor_type = sensor_params.get('type', '')
    sensor_port = sensor_params.get('port', '')
    sensor_title = sensor_params.get('title', '')
    
    camera_params = hardware_device.get('camera', {})
    camera_name = camera_params.get('name', '')
    camera_type = camera_params.get('type', '')
    camera_port = camera_params.get('port', '')
    camera_title = camera_params.get('title', '')
    
    return LaunchDescription([
        ExecuteProcess(
            cmd=[script_file,
                user_password,
                haptic_name, haptic_type, haptic_port, haptic_title,
                robot_name, robot_type, robot_port, robot_title,
                effector_name, effector_type, effector_port, effector_title,
                sensor_name, sensor_type, sensor_port, sensor_title,
                camera_name, camera_type, camera_port, camera_title
            ],
            shell=True,
            output='screen',
        ),
    ])
