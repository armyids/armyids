# System Performance Monitoring

This repository contains a python script that allows you to monitor your system performance in real-time and get alerts via Telegram when any of the specified thresholds are exceeded.

## Script

The following script is included in this repository:

- <b>system_monitor.py</b>: This script uses the psutil library to monitor CPU usage, load average, disk usage, and RAM usage. If any of the performance metrics exceed a specified threshold, the script sends an alert via Telegram.

## Prerequisites

To run this script, you will need to have the following python libraries installed:

- `psutil`: A cross-platform library for retrieving information on system utilization (CPU, memory, disks, network, sensors) and on system uptime.
- `telegram`: A python wrapper around the Telegram Bot API, which allows you to send messages, photos and files through the Telegram Bot API.
- `socket`: A python library that provides low-level core networking services.
- `time`: A python library that provides various time-related functions.

To install the prerequisites libraries, you can use pip package manager.

```
pip install psutil telegram
```

## Usage
To use this script, simply navigate to the directory where the script is located, and run the following command:

```
python system_monitor.py
```

It is essential to replace the placeholders in the script for the Telegram TOKEN and CHAT_ID with your own values.

You can set your own threshold values for each metric, these values are just examples and can be adjusted as needed.

The script runs continuously, to ensure real-time monitoring.

## Contributing

If you would like to contribute to this repository, please submit a pull request with your changes. We review all pull requests and appreciate any contributions.

## Support

If you have any issues or questions, please feel free to open an issue in this repository or contact us directly.

## Note

It is important to note that you need to have python installed on your system to be able to run this script, and you may need to replace the command pip with pip3 if you have multiple version of python installed on your system.
