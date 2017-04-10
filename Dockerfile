FROM ubuntu:xenial
ENV Selenium_version=3.3.1
ENV DEBIAN_FRONTEND=noninteractive

# install Google chrome
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates socat wget software-properties-common unzip \
    && apt-get install -y --no-install-recommends xvfb x11vnc fluxbox xterm \
    && apt-get install -y --no-install-recommends sudo \
    && apt-get install -y --no-install-recommends supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:openjdk-r/ppa

  # Update app-get
RUN  apt-get update

  # Install Java
RUN  apt-get install openjdk-8-jre -y --force-yes

  # Download and copy the ChromeDriver to /usr/local/bin
 RUN cd /tmp \
  && wget -q "https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip" \
  && wget -q "http://selenium-release.storage.googleapis.com/3.3/selenium-server-standalone-${Selenium_version}.jar" \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin \
  && mv selenium-server-standalone-${Selenium_version}.jar /usr/local/bin/selenium-server.jar

# add nodejs
RUN wget https://deb.nodesource.com/setup_7.x -v -O install.sh && chmod +x install.sh && ./install.sh \
  && apt-get install -y build-essential nodejs \
  && npm install -g grunt

#========================================
# Add normal user with passwordless sudo
#========================================
RUN set -xe \
    && useradd -u 1000 -g 100 -G sudo --shell /bin/bash --no-create-home --home-dir /tmp user \
    && echo 'ALL ALL = (ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN wget -q -O /entry.sh https://raw.githubusercontent.com/thib3113/selenium-chrome-headless/master/entry.sh && chmod +x /entry.sh
RUN wget -q -O /etc/supervisord.conf https://raw.githubusercontent.com/thib3113/selenium-chrome-headless/master/supervisord.conf && chmod +x /entry.sh

RUN mkdir /tmp/chrome-data

ENTRYPOINT /entry.sh && bash
CMD ["/bin/bash"]

#to start selenium and chrome, start by :
# - export DISPLAY=:10
# - Xvfb :10 -screen 0 1366x768x24 -ac &
# - google-chrome --remote-debugging-port=9222 &
# - nohup java -jar /usr/local/bin/selenium-server.jar &
