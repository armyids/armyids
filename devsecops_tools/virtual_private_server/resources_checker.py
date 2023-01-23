import os
import psutil
import socket
import telegram
import time

def get_cpu_usage():
    """Returns the current CPU usage as a percentage."""
    return psutil.cpu_percent()

def get_load_average():
    """Returns the current load average."""
    return os.getloadavg()

def get_disk_usage():
    """Returns the current disk usage statistics."""
    return psutil.disk_usage('/')

def get_ram_usage():
    """Returns the current RAM usage statistics."""
    return psutil.virtual_memory()

def send_telegram_message(message):
    """Sends a message to the configured Telegram bot."""
    # Replace TOKEN and CHAT_ID with your own values.
    bot = telegram.Bot(token='TOKEN')
    bot.send_message(chat_id='CHAT_ID', text=message)

def check_thresholds(cpu_threshold, load_average_threshold, disk_usage_threshold, ram_usage_threshold):
    """Checks if any of the specified thresholds have been exceeded and sends a notification if necessary."""
    hostname = socket.gethostname()

    cpu_usage = get_cpu_usage()
    if cpu_usage > cpu_threshold:
        send_telegram_message(f'{hostname} | CPU usage is currently at {cpu_usage}%, which is above the specified threshold of {cpu_threshold}%.')

    load_average = get_load_average()
    if load_average[0] > load_average_threshold:
        send_telegram_message(f'{hostname} | Load average is currently at {load_average[0]}, which is above the specified threshold of {load_average_threshold}.')

    disk_usage = get_disk_usage()
    if disk_usage.percent > disk_usage_threshold:
        send_telegram_message(f'{hostname} | Disk usage is currently at {disk_usage.percent}%, which is above the specified threshold of {disk_usage_threshold}%.')

    ram_usage = get_ram_usage()
    if ram_usage.percent > ram_usage_threshold:
        send_telegram_message(f'{hostname} | RAM usage is currently at {ram_usage.percent}%, which is above the specified threshold of {ram_usage_threshold}%.')

def main():
    # Set the thresholds for each metric. These values are just examples and can be adjusted as needed.
    cpu_threshold = 90
    load_average_threshold = 6
    disk_usage_threshold = 90
    ram_usage_threshold = 90

    while True:
        check_thresholds(cpu_threshold, load_average_threshold, disk_usage_threshold, ram_usage_threshold)
        time.sleep(86400)  # Check the thresholds everyday.

if __name__ == '__main__':
    main()
