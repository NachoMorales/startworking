# startworking
Batch command to automate workflow.


# Setup
  - Download the file and move it to "C:\Windows\System32"
  - Change :projectsFolder "MAINFOLDER" variable to your projects directory


# What it does
  - Start project's selected apps
  - Open VSCode if selected
  - Open Discord
  - Open Postman
  - Open Git Bash
  - Git Pull if selected


# Usage
startworking [ project ] [ first-app ] [ second-app ]

  - project: </br>
           - name of the project folder. </br>
           - Required.
  
  - first-app: </br>
              - name of the first app folder. Ex: adm/api/app </br>
              - Not required. </br>
              - Default: all apps. </br>
              - "n": none.
  - second-app: </br>
              - name of the second app folder. Ex: adm/api/app </br>
              - Not required </br>
              - Default: none

# Notes
  - VSCode will open in apps selected. If there is no app selected, it will ask for a folder in your project. </br>
              - ".": open vscode in project's root folder </br>
              - "n": don't open vscode </br>
              - "a": open vscode in all folders

  - Default commands: </br>
              - app: ionic s </br>
              - adm: ng serve </br>
              - api: npm start

  - If you select an app that is not one of these: adm, api or app. You'll be asked for a command to run your app.
