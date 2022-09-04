#!/bin/bash
set -e
touch log.txt
LOGFILE=log.txt
repouser=$1
reponame=$2
lastweek=`date --date="-7 days" +'%Y-%m-%d'T''%H:%M:%S'Z'`

if [ $# -lt 2 ]
  then
     printf "This script needs 2 argument a) RepositoryOwner  b) Repo Name \n"
fi

#### This script 2 user inputs 1) Github owner name and 2) GitHub repo name
#### Calling GitHub API to get all close pull request for last 1 week 
#### and sending error to log file "log.txt"

curl https://api.github.com/repos/$repouser/$reponame/pulls?state=close > closerequest.json 2>> $LOGFILE
CLOSE_NUM=`jq -r '.[] | select (.state=="closed" and .closed_at > "'"$lastweek"'")' < allissues.json | grep "state"  | wc -l` 2>> $LOGFILE


#### Calling GitHub API to get all open pull request for last 1 week
#### using last updated date and sending error to log file "log.txt"
curl https://api.github.com/repos/$repouser/$reponame/pulls?state=open > openrequest.json 2>> $LOGFILE
OPEN_NUM=`jq -r '.[] | select (.state=="open" and .updated_at > "'"$lastweek"'")' < openrequest.json | grep "state"  | wc -l` 2>> $LOGFILE


printf "Total Close pull of last week is $CLOSE_NUM \n" > mail.txt
printf "Total Open pull of last week is $OPEN_NUM \n" >> mail.txt

## Sending mail to user/group from output file
mail -s "Repo Pull Details" user@mail.com < mail.txt