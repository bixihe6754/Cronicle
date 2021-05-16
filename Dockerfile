FROM node:16.0-alpine

WORKDIR /opt/cronicle

COPY bootstrap.sh bootstrap.sh

RUN apk update && apk add bash && apk add curl && apk add gzip && apk add jq

RUN chmod +x bootstrap.sh

CMD [ "/bin/bash", "bootstrap.sh" ]

EXPOSE 3012:3012
