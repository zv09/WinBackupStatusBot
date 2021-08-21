# Description and Documentation
[![docs](https://img.shields.io/badge/Docs:-HTML-blue?style=plastic&logo=CSS3)](https://zv09.github.io/WinBackupStatusBot/#Documentation)  [![docs](https://img.shields.io/badge/Docs:-Markdown%20Index.md-yellow?style=plastic&logo=Mardown)](docs/index.md)

*  [**Powershell WinBackupStatusBot** description](#description)
*  [Undestanding workflow](#workflow)
*  [Installation](#installation)
*  [How-to-use](#how-to-use)


[## **Powershell WinBackupStatusBot** description]{#description} 

**Powershell WinBackupStatusBot** is a Windows scheduled task to run a Powershell script whenever a necessary event appears in the windows event log system.

This Powershell script will parse the event log further to find the event that triggered the task configured and report when backup operation start, is finished, cancelled or interrupted with the error code. 

You will get an instant message in Telegram messenger whenever successfully or unsuccessfully Backup operations try to do their job on your Windows Server or standard Windows 7+ installation. 

That allows you to monitor backup operations on the go and is informed when the unsuccessful result will appear to become aware of something goes wrong in the system. You should check up your Backup logs to manually maintain malfunctions on your Windows machine in this case.

[workflow]## Workflow undestanding

Briefly, look at the script's workflow is shown in the figure below for a clearer understanding of how it works on your Windows server.

![WinBackupStatusBotWorkFlow](https://zv09.github.io/WinBackupStatusBot/WinBackupStatusBotWorkFlow.png)

1. Windows Events engine continuously collect all the events rotating in the Windows machine with unique IDs and statuses
2. Task Scheduler has a task with XML filter that is triggered when backup service doing its job
3. Task Scheduler run **Powershell WinBackupStatusBot** script when a task is filtered with EventID related to Backup operations service
4. **Powershell WinBackupStatusBot** script makes another series of requests to Windows Event Log system to filter this triggered task again to parse additional data like operation result, error codes, etc
5. **Powershell WinBackupStatusBot** script pack that data, preparing the message  and makes a webhook to send it to the Telegram server
6. You getting notification based on message format in the **Powershell WinBackupStatusBot** script
7. Story continuing until Task Scheduler has its active task for filtering. 

[installation]## Installation

### Get files from GitHub

Clone **Powershell WinBackupStatusBot** repository 

1. Open Terminal.
2. Change the current working directory to the location where you want the cloned directory.
3. Type `git clone` and then paste the URL you copied earlier or paste it: https://github.com/zv09/WinBackupStatusBot.git

	```shell
	$ git clone https://github.com/zv09/WinBackupStatusBot.git 
	```
	
More detail how to clone repository from GitHub you can find in the GitHub's docs section:  [Cloning a repository](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository-from-github/cloning-a-repository)

### Enable Powershell Scripts

1. Open PowerShell console as an Administrator role
2. Type there: `set-executionpolicy remotesigned`

	```shell
	Set-ExecutionPolicy RemoteSigned
	```

3. Then type Y (or A) and press Enter

![WinBackupStatusBotPSPolicy](https://zv09.github.io/WinBackupStatusBot/PoweshellExecPolicy.png)

This will allow you to run Powershell scripts in your Windows system

### Script configuration 

Generally, there are 3 files you need from repository for making things happen
- WinBackupStatusBotTracking.xml
- WinBackupStatusBot.ps1
- TelegramBotSettings-Example.ps1

#### Configure Task Scheduler 

1. Open Windows Task Scheduler
2. In the Task Scheduler tree right click to create a new folder, name it as "Tracking"
3. In this "Tracking" folder Select "Import Task"
4. Import the `WinBackupStatusBotTracking.xml` file
5. On the "General" tab, click on "Change User or Group" and select a local administrative user.
6. On the "Actions" tab, ensure the parameter of the Powershell action points to the actual location of the WinBackupStatusBot.ps1 file
7. Click OK and type the correct password for choosen user.

#### Configuring Telegram messaging 

1. Install Telegram on your device or use it already 
2. Find @botfather and start chat 
3. Type `/newbot`
4. Give your bot a wishful name... like MyBackupBot, etc...
5. Give your bot a username... e.g. mybackupbot
6. You will get a message from @BotFather contains creation status, bot URL and providing token to access the HTTP API:  via string with letters and digits
`YYYYYYYYYY:WWWWWWWWWWWWWWWWWWWWWWWWWWWWW-ZZZZZ`
7. Keep your token secure and store it safely
8. Start a chat with your bot and type `/start`
9. Type a  message for the bot like "Hi"
10. Exit bot chat and create a Telegram Group conversation. Call it something with the name "Dev-Test" or any other
11. Invite your bot to the group.
12. Access the following page `https://api.telegram.org/bot<TOKEN>/getUpdates` with insertion your bot's TOKEN between < >  and remove < > characters
13. Look for the IDs in the page you got. Normally the Group ID will be a numbers preceded by a minus sign. User ID is a positive. 
14. Open `TelegramBotSettings-Example.ps1` and edit it pasting Group or User ID on your choose. Copy and paste your token ID there. 
15. Save `TelegramBotSettings-Example.ps1` as a `TelegramBotSettings.ps1` file. This is neccesary for working the **Powershell WinBackupStatusBot** script corectly, couse it merge this data on its runtime. 

- That's all 

[how-to-use]## How-to-use

The script is useful when you have many Windows Servers in different organizations (installation sites) which are not part of the one Domain infrastructure. And on everyday use you need to be sure that's everything goes well. 

Based on how the time for starting the Backup process is configured in your system, you will get statuses in the Telegram messenger.
If in your Task Scheduler the Backup operation is configured to launch once a day, during the launch you will receive a message about the start and a message upon completion of the process with the execution status.

[contribution]# Contribution 

The script is gradually developing. I will add new features and functionality based on issues need to know about Backup operations.

Whether reporting bugs, discussing improvements and new ideas or writing extensions: Contributions to **Powershell WinBackupStatusBot** are welcome! 

Here's how to get started:

Check for issues or open a issue or open a feature requests.
Fork the repository on Github
Create a new branch off the master branch.
Write a test which shows that the bug was fixed or that the feature works as expected.
Send a pull request to me and wait till it get merged.

Based on communication further I will add you to the Contributors list additionally if you wish.

#### Jekyll Themes

Pages site will use the layout and styles from the GitHub's Jekyll theme.

