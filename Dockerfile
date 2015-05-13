#
# DesertBit Bulldozer Dockerfile
#

FROM golang

MAINTAINER Roland Singer, roland.singer@desertbit.com

ENV BULLDOZER_DATA_DIR "/data/files"
ENV BULLDOZER_DB_ADDR "ENV:DB_PORT_28015_TCP_ADDR"
ENV BULLDOZER_DB_PORT "28015"

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive; \
	apt-get update && \
	apt-get install -y rubygems && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	gem install sass

# Add the bulldozer user, prepare the data directory and fix permission.
ADD run.sh /run.sh
RUN useradd --no-create-home bud
RUN mkdir -p /data/files && \
	touch /data/settings.toml
RUN chown -R bud:bud /data /go  && \
	chmod -R 770 /go /data && \
	chmod +x /run.sh

# Fix permission on build.
ONBUILD RUN chown -R bud:bud /go && \
	chmod -R 770 /go

EXPOSE 9000

VOLUME [ "/data" ]

CMD [ "/run.sh", "go-wrapper", "run", "-settings", "/data/settings.toml" ]