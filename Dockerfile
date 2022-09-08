FROM debian:10.12
WORKDIR /root
COPY . . 
RUN apt update -y
RUN apt-get -y install jq curl
ADD GitHubPullReq1.sh /root/GitHubPullReq1.sh
ENTRYPOINT ["/bin/bash", "/root/GitHubPullreq.sh"]