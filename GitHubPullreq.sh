#!/bin/bash
set -e
FILE=`cat URL.txt`
touch log.txt
LOGFILE=log.txt
lastweek=`date --date="-7 days" +'%Y-%m-%d'T''%H:%M:%S'Z'`


# #### This script 2 user inputs 1) Github owner name and 2) GitHub repo name
# #### Calling GitHub API to get all close pull request for last 1 week 
# #### and sending error to log file "log.txt"

or_exit() {
    local exit_status=$?
    local message=$*

    if [ "$exit_status" -gt 0 ]
    then
        echo "$(date '+%F %T') [$(basename "$0" .sh)] [ERROR] $message" >&2
        exit "$exit_status"
    fi
}
send_mail () {
    curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from 'noreply@mail.in'  --mail-rcpt 'ritesh692@gmail.com' --upload-file mail.txt --user 'noreply@mail.in:MyComplexP@SSw0rd' --insecure
}
count_close() {
        while read  URL
          do
            curl $URL?state=close > closerequest.json
            or_exit "Error while fetching data from URL"
            CLOSE_NUM=`jq -r '.[] | select (.state=="closed" and .closed_at > "'"$lastweek"'")' < closerequest.json | grep "state"  | wc -l`
            printf "Total Close pull of last week is $CLOSE_NUM \n" > mail.txt
            done < URL.txt
     }
#### Calling GitHub API to get all open pull request for last 1 week
#### using last updated date and sending error to log file "log.txt"
count_open() {
        while read  URL
          do
            curl $URL?state=open > openrequest.json
            or_exit "Error while fetching data from URL"
            OPEN_NUM=`jq -r '.[] | select (.state=="open" and .updated_at > "'"$lastweek"'")' < openrequest.json | grep "state"  | wc -l`
            printf "Total Open pull of last week is $OPEN_NUM \n" >> mail.txt
            done < URL.txt
      }


# mail -s "Repo Pull Details" user@mail.com < mail.txt
count_close
count_open
send_mail



