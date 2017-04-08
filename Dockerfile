FROM debian:jessie
ENV Selenium_version=3.3.1

RUN apt-get update

RUN apt-get install wget openjdk-7-jre xvfb unzip -y 
  # Add Google public key to apt
RUN  wget -q -O - "https://dl-ssl.google.com/linux/linux_signing_key.pub" | apt-key add -

  # Add Google to the apt-get source list
RUN  echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list

  # Update app-get
RUN  apt-get update

  # Install Java, Chrome, Xvfb, and unzip
RUN  apt-get install google-chrome-stable -y

  # Download and copy the ChromeDriver to /usr/local/bin
 RUN cd /tmp \
  && wget -q "https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip" \
  && wget -q "http://selenium-release.storage.googleapis.com/3.3/selenium-server-standalone-${Selenium_version}.jar" \
  && unzip chromedriver_linux64.zip \
  && mv chromedriver /usr/local/bin \
  && mv selenium-server-standalone-${Selenium_version}.jar /usr/local/bin/selenium-server.jar

#to start selenium and chrome, start by :
# - export DISPLAY=:10
# - Xvfb :10 -screen 0 1366x768x24 -ac &
# - google-chrome --remote-debugging-port=9222 &
# - nohup java -jar /usr/local/bin/selenium-server.jar &