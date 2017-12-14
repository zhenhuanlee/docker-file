FROM ruby:2.2.7 
ENV APP_DIR /app/acx

RUN git clone --depth=1 https://github.com/foalford/maklib maklib \
 && cd maklib \ 
 && make install \ 
 && make deps

RUN mkdir -p $APP_DIR

WORKDIR $APP_DIR
ADD . .

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 4.4.7

RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && nvm use default \
 && npm install -g gulp bower \
 && npm install \
 && apt-get -y update \
 && curl -sL https://deb.nodesource.com/setup | bash - \
 && apt-get -y install imagemagick gsfonts \
 && bundle install \
 &&  make clean build -e project=acx

CMD ["rails", "s", "-b", "0.0.0.0"]
