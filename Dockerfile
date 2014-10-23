FROM dockerfile/ubuntu
# Install Redis.
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  cd && \
  wget http://download.go.cd/gocd-deb/go-agent-14.2.0-377.deb && \
  apt-get update && \
  apt-get install openjdk-6-jdk && \
  export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-amd64 &&＼
  dpkg -i go-agent-14.2.0-377.deb && \
  sed -i 's/127.0.0.1/192.168.1.216/g' /etc/default/go-agent && \
  /etc/init.d/go-agent start
# Define mountable directories.
VOLUME ["/data"]
# Define working directory.
WORKDIR /data
# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

EXPOSE 6379
