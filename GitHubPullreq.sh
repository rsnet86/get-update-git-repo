#!/bin/bash

repouser=$1
reponame=$2
lastweek=`date --date="-7 days" +'%Y-%m-%d'T''%H:%M:%S'Z'`

curl https://api.github.com/repos/$repouser/$reponame/pulls?state=close > closerequest.json
CLOSE_NUM=`jq -r '.[] | select (.state=="closed" and .closed_at > "'"$lastweek"'")' < allissues.json | grep "state"  | wc -l`


curl https://api.github.com/repos/$repouser/$reponame/pulls?state=open > openrequest.json
OPEN_NUM=`jq -r '.[] | select (.state=="open" and .updated_at > "'"$lastweek"'")' < openrequest.json | grep "state"  | wc -l`

printf "Total Close pull of last week is $CLOSE_NUM \n" > mail.txt
printf "Total Open pull of last week is $OPEN_NUM \n" >> mail.txt

mail -s "Repo Pull Details" user@mail.com < mail.txt
