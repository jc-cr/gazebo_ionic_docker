# Use Ubuntu 24.04 (Noble) as the base image
FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg \
    curl \
    sudo \
    libgl1 \
    libglu1-mesa \
    libxcb1 \
    libxcb-glx0 \
    libxcb-dri2-0 \
    libxcb-dri3-0 \
    libxcb-present0 \
    libxcb-sync1 \
    libxshmfence1 \
    libxxf86vm1 \
    x11-xserver-utils \
    xauth \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Add Gazebo repository
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-prerelease $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-prerelease.list > /dev/null

# Install Gazebo Ionic
RUN apt-get update && apt-get install -y gz-ionic \
    && rm -rf /var/lib/apt/lists/*

# Set up a non-root user
RUN useradd -m developer && echo "developer:developer" | chpasswd && adduser developer sudo

# Add developer to video group for graphics access
RUN usermod -aG video developer

# Allow developer to run sudo without password
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set up the environment for X11 forwarding
ENV DISPLAY=:0
ENV QT_X11_NO_MITSHM=1

# Switch to the non-root user
USER developer
WORKDIR /home/developer

# Set the entrypoint to bash
CMD ["/bin/bash"]