FROM 192.168.11.201:55000/docker-registry/armhf-devel-ubuntu14.04:latest

#ROS indigo installation
RUN update-locale LANG=C LANGUAGE=C LC_ALL=C LC_MESSAGES=POSIX && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update && \
    apt-get install -y ros-indigo-desktop
RUN apt-get install -y python-rosdep && \
    rosdep init && rosdep update && \
    apt-get install -y python-rosinstall
RUN mkdir -p $HOME/catkin_ws/src
WORKDIR /root/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/indigo/setup.bash; catkin_init_workspace'
WORKDIR /root/catkin_ws/
RUN /bin/bash -c '. /opt/ros/indigo/setup.bash; catkin_make' && \
    echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc && \
    echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
    echo "unset GTK_IM_MODULE" >> ~/.bashrc

# ROS packages instalation
RUN apt-get update && \
    apt-get install -y ros-indigo-rosbridge-server \
                       ros-indigo-ros-control \
                       ros-indigo-ros-controllers \
                       ros-indigo-joy \
                       spacenavd libmotif4 ros-indigo-spacenav-node \
                       ros-indigo-openni2-camera \
                       ros-indigo-openni2-launch \
                       ros-indigo-usb-cam \
                       ros-indigo-image-view \
                       ros-indigo-rosbridge-server \
                       ros-indigo-tf2-web-republisher

WORKDIR /root/catkin_ws
CMD ["/bin/bash"]
