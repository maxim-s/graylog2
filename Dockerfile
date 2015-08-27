FROM java
RUN apt-get install wget -y 
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen
RUN mkdir -p /conf 
WORKDIR /opt
ENV GRAYLOG_VERSION="1.1.6"

# Get graylog2 web and server and install
ENV GRAYLOG_SERVER="graylog-$GRAYLOG_VERSION" 
ENV GRAYLOG_WEB="graylog-web-interface-$GRAYLOG_VERSION" 
RUN wget "http://packages.graylog2.org/releases/graylog2-server/$GRAYLOG_SERVER.tgz" -q
RUN wget "http://packages.graylog2.org/releases/graylog2-web-interface/$GRAYLOG_WEB.tgz" -q 
RUN tar -xf "$GRAYLOG_SERVER.tgz" && rm "$GRAYLOG_SERVER.tgz" 
RUN tar -xf "$GRAYLOG_WEB.tgz" && rm "$GRAYLOG_WEB.tgz"
RUN mv "$GRAYLOG_SERVER" /opt/graylog2-server 
RUN mv "$GRAYLOG_WEB" /opt/graylog2-web-interface 
RUN useradd -s /bin/false -r -M graylog2 
RUN chown -R graylog2:root /opt 
RUN mkdir -p /var/log/graylog
RUN chown -R graylog2:root /var/log/graylog
# Copy config
COPY ./graylog.conf /etc/graylog/server/server.conf
RUN chown -R graylog2:root /etc/graylog/server
RUN sed -i -e "s/password_secret =.*$/password_secret = $(pwgen -s 96)/" /etc/graylog/server/server.conf
RUN sed -i -e "s/application.secret=.*$/application.secret=$(pwgen -s 96)/" /opt/graylog2-web-interface/conf/graylog-web-interface.conf
RUN sed -i -e "s/graylog2-server.uris=.*$/graylog2-server.uris=\"http:\/\/127.0.0.1:12900\/\"/" /opt/graylog2-web-interface/conf/graylog-web-interface.conf

EXPOSE 9000 12201 12900
VOLUME ["/var/log/graylog"]
VOLUME ["/opt/graylog2-server/log"]
COPY ./run.sh /opt/run.sh
RUN chmod a+x /opt/run.sh
USER graylog2
CMD /opt/run.sh