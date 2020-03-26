FROM debian:buster

LABEL maintainer="pan.luo@ubc.ca"

# libnlopt-dev is required by lmerTest
RUN apt update && \
    apt install -y gnupg2 && \
    apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' && \
    echo "deb http://mirror.its.sfu.ca/mirror/CRAN/bin/linux/debian buster-cran35/" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
      wget \
      r-base \
      r-base-dev \
      libssl-dev \
      libnlopt-dev \
      libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz && \
    R CMD INSTALL Rserve_1.8-6.tar.gz && \
    rm Rserve_1.8-6.tar.gz && \
    Rscript -e 'install.packages(c("leaps", "tree", "glmnet", "lars", "locfit", "nnet", "randomForest", "adabag", "lmerTest", "ggplot2", "visreg", "dplyr", "car", "vegan", "mclust", "tseries", "zoo", "lpSolve"), repo="http://cran.rstudio.com")'

VOLUME /localdata

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 6311

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["R", "-e", "Rserve::run.Rserve(remote=TRUE, auth=FALSE, daemon=FALSE)"]
