#!/bin/bash

# Log file for the entire script
script_log="script.log"

# Function to check internet connectivity
check_internet_access() {
    echo "Checking internet connectivity..." | tee -a $script_log
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "Internet connectivity check passed." | tee -a $script_log
    else
        echo "Internet connectivity check failed. Please ensure the container has internet access." | tee -a $script_log
        exit 1
    fi
}

# Call the internet connectivity check function
check_internet_access

# Start the main Ollama server in the background
echo "Starting the main Ollama server..." | tee -a $script_log
/bin/ollama serve &> ollama_main_server.log &
# Record the PID
main_server_pid=$!

# Wait a bit for the main Ollama server to initialize
sleep 10

# Check if the main Ollama server is running
if ! ps -p $main_server_pid > /dev/null; then
    echo "Failed to start the main Ollama server. Check ollama_main_server.log for details." | tee -a $script_log
    cat ollama_main_server.log >> $script_log
    exit 1
else
    echo "Main Ollama server started successfully." | tee -a $script_log
fi

# Now, start the specific Llama2 model
echo "Starting Ollama Llama2 model..." | tee -a $script_log
/bin/ollama run llama2 &> ollama_llama2.log &
# Record the PID
llama2_pid=$!

# Wait a bit for the Llama2 model to initialize
sleep 10

# Check if the Llama2 model is running
if ! ps -p $llama2_pid > /dev/null; then
    echo "Failed to start Ollama Llama2 model. Check ollama_llama2.log for details." | tee -a $script_log
    cat ollama_llama2.log >> $script_log
    exit 1
else
    echo "Ollama Llama2 model started successfully." | tee -a $script_log
fi

# Ensure net-tools is installed for netstat
if ! command -v netstat &> /dev/null; then
    echo "net-tools not found, installing..." | tee -a $script_log
    apt-get update && apt-get install -y net-tools
fi

echo "Checking listening ports..." | tee -a $script_log
netstat -tuln | tee -a $script_log

# Before starting the Flask application, check if the port is available
if netstat -tuln | grep -q ':5000'; then
    echo "Port 5000 is already in use. Exiting." | tee -a $script_log
    exit 1
fi

# Now start the Flask application
echo "Starting Flask application..." | tee -a $script_log
exec python3 flask-app.py 2>&1 | tee -a $script_log


