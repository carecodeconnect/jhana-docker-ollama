# Use the Ollama base image
FROM ollama/ollama

# Install Python, Flask, net-tools (for netstat), and iputils-ping (for ping command)
RUN apt-get update && \
    apt-get install -y python3-pip net-tools iputils-ping

# Copy requirements file
COPY requirements.txt /tmp/

# Install Python packages
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Set up the working directory
WORKDIR /app

# Copy the Flask app and the startup script to the container
COPY flask-app.py /app/
COPY start.sh /app/

# Expose the port the Flask app runs on
EXPOSE 5000

# Use the startup script as the entry point
ENTRYPOINT ["./start.sh"]

