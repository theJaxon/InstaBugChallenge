FROM node:slim
RUN apt-get update &&  apt-get install -y \
    libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb git && \
    apt-get clean && \
    git clone https://github.com/dobromir-hristov/todo-app && \
    cd todo-app && \
    yarn install --frozen-lockfile

WORKDIR /todo-app/

ENV PORT=4222
ENV CYPRESS_BASE_URL=http://localhost:4222
ENV DEBUG=cypress:*

ENTRYPOINT [ "yarn" ]