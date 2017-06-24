FROM armv7/armhf-ubuntu:14.04

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

#Development Tools
RUN apt-get update && \
    apt-get install -y tmux \
                       wget zip unzip curl \
                       bash-completion git \
                       software-properties-common 
# Vim
RUN apt-get install -y  vim-nox && \
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh -o /tmp/install.sh
WORKDIR /tmp
RUN /bin/bash -c "sh ./install.sh" && \
    git clone https://github.com/tomasr/molokai && \
    mkdir -p ~/.vim/colors && \
    cp ./molokai/colors/molokai.vim ~/.vim/colors/
COPY .vimrc /root/.vimrc
# Tmux
WORKDIR /tmp
COPY .tmux.conf /root/.tmux.conf


WORKDIR /root/catkin_ws
CMD ["/bin/bash"]
