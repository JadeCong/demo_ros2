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

from launch import LaunchDescription
from launch.actions import ExecuteProcess


def generate_launch_description():
    return LaunchDescription([
        # Launch master_hfd node
        ExecuteProcess(
            cmd=[
                'gnome-terminal', '--', 'bash', '-c',
                'ros2 launch hfd_teleoperation master_hfd.launch.py; exec bash'
            ],
            shell=False
        ),
        
        # Launch slave_realman node
        ExecuteProcess(
            cmd=[
                'gnome-terminal', '--', 'bash', '-c',
                'ros2 launch realman_teleoperation slave_realman.launch.py; exec bash'
            ],
            shell=False
        ),
        
        # Launch slave_ctek node
        ExecuteProcess(
            cmd=[
                'gnome-terminal', '--', 'bash', '-c',
                'ros2 launch ctek_teleoperation slave_ctek.launch.py; exec bash'
            ],
            shell=False
        ),
    ])
