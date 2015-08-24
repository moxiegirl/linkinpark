FROM docs/base:hugo
MAINTAINER Mary Anthony <mary@docker.com> (@moxiegirl)

RUN apt-get install ssed

# To get the git info for this repo
COPY . /src

COPY . /docs/content/linkinpark/

RUN /src/pre-process.sh /docs