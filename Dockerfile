# Set up a docker machine that has all the tools to build teh senml spec

FROM ubuntu
MAINTAINER Cullen Jennings <fluffy@iii.ca>

RUN apt-get -y update

RUN apt-get -y install tcsh

RUN apt-get install -y build-essential python-pip python-dev rubygems

RUN pip install --upgrade pip

RUN pip install xml2rfc

RUN gem install kramdown-rfc2629

VOLUME /senml

WORKDIR /senml

CMD [ "/usr/bin/make", "all" ]

