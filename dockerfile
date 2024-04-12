# Use the official OSRF ROS Noetic desktop full image
FROM osrf/ros:noetic-desktop-full
RUN mkdir -p /rosstart
COPY start-roscore.sh /rosstart
RUN chmod +x /rosstart/start-roscore.sh

COPY catkin_ws/. catkin_ws/
WORKDIR /catkin_ws
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make'
RUN echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc
# Set a working directory

WORKDIR /ros

# Install some useful tools and dependencies for development
RUN apt-get update && apt-get install -y \
    ros-noetic-velodyne \
    nano \
    wget \
    curl \
    git \
    supervisor \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Setup environment variables needed for ROS
ENV ROS_WS=/catkin_ws

# # Create a catkin workspace
# RUN mkdir -p $ROS_WS/src && \
#     /bin/bash -c "source /opt/ros/noetic/setup.bash; catkin_init_workspace $ROS_WS/src"

# Build the catkin workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash; cd $ROS_WS; catkin_make"

# Automatically source the workspace in each bash session
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source $ROS_WS/devel/setup.bash" >> ~/.bashrc

# Set the default command to execute
# Keeps the container running and provides an interactive shell
CMD ["bash"]