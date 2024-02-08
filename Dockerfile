# Use the base image from Docker Hub
FROM piopirahl/docker-desktop:1.0.2

# Expose ports 6901 and 5901
EXPOSE 6901 5901

# Start the container command
CMD ["-d", "-p", "6901:6901", "-p", "5901:5901", "--name", "desktop"]
