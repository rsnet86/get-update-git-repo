# This script uses github pull api and print total Closed and Open pull request for last 1 week.

DockerFile is created to run this script 
```
--user 'noreply@mail.in:MyComplexP@SSw0rd'
```
We do not have any seceret manager implemented we have put smtp credentiaal in the script just change the above enrty with the proper credentiaal to send mail sucessfullly in send_mail function in this script.
To run this script you need to give 2 user input 1. Github User name and 2. Repository Name

```
e.g: sh GitHubPullReq.sh raspberrypi linux
```
