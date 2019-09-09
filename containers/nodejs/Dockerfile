FROM jenkins/jnlp-slave:alpine
MAINTAINER Norman Khine <norman.khine@electricjukebox.com>

USER root
RUN apk update && apk upgrade && apk add git jq nodejs yarn

USER jenkins