# Discord Token Grabber
The Discord Token grabber is a simple Ruby script that searches for tokens in various locations commonly used by Discord, Google Chrome, Opera, Brave, and Yandex browsers on Windows. It extracts tokens from log and ldb files in the Local Storage directory and sends them via a webhook to a specified URL.

# Installation
- Install Ruby on your system if it's not already installed.
- Clone the repository or download the script file.

# Usage
- Replace the webhook_url variable with the actual webhook URL you want to send the tokens to.
- Set the ping_me variable to true if you want to mention everyone in the Discord server, or false otherwise.
- Run the script by executing ruby token_extractor.rb in the project directory.

# Dependencies
The script requires the following gems to be installed:
- net/http: To send HTTP requests
- json: To encode payload data in JSON format

# Disclaimer
This script is intended for educational purposes and should be used responsibly and legally. The use of this script for malicious purposes or without proper authorization is strictly prohibited. The author/s are not responsible for any misuse or damage caused by this script. Use it at your own risk.

# License
This script is released under the MIT License. Feel free to use, modify, and distribute it as per the terms of the license.
