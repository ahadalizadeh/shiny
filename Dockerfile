FROM rocker/r-ver:3.6.3

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget


# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

RUN apt-get install nano  -y
EXPOSE 3838
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN  mkdir -p  /srv/app1
RUN  mkdir -p  /srv/shiny-server/app1
RUN  mkdir -p  /srv/shiny-server/app2

COPY /srv/apps/app1 /srv/shiny-server/app1
COPY /srv/apps/app2 /srv/shiny-server/app2

CMD ["/usr/bin/shiny-server.sh"]
