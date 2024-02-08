# Use a base image with Ubuntu
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    firefox \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV DISPLAY=:1 \
    VNC_PORT=5900 \
    NO_VNC_PORT=6080 \
    TZ=UTC

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Download noVNC
RUN mkdir -p /opt/novnc \
    && wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C /opt/novnc \
    && ln -s /opt/novnc/vnc_lite.html /opt/novnc/index.html

# Expose ports for VNC and noVNC
EXPOSE $VNC_PORT $NO_VNC_PORT

# Start Xvfb, Firefox, and noVNC
CMD Xvfb $DISPLAY -screen 0 1024x768x16 & \
    firefox & \
    websockify -D --web=/opt/novnc 6080 localhost:$VNC_PORT && \
    tail -f /dev/null
