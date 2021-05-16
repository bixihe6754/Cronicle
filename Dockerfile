FROM node:16.0-alpine

WORKDIR /opt/cronicle

COPY bootstrap.sh bootstrap.sh

RUN chmod +x bootstrap.sh

CMD [ "/bin/bash", "bootstrap.sh" ]