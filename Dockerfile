FROM drush/drush:8

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

# Install rvm, ruby & docman.
RUN apt-get update \
  && apt-get -y install wget curl libfontconfig1 procps \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && curl -L https://get.rvm.io | bash -s stable \
  && /bin/bash -l -c "rvm install 2.3.0" \
  && /bin/bash -l -c "rvm --default use 2.3.0" \
  && /bin/bash -l -c "gem install -v 0.0.90 docman" \
  && rm -rf /var/lib/apt/lists/*

# Install nodejs & grunt.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y nodejs yarn \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g gulp-cli grunt-cli \
  && grunt --version \
  && gulp --version \
  && yarn versions

# Install compass.
RUN /bin/bash -l -c "gem install compass"
