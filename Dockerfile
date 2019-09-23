FROM debian:stretch

LABEL maintainer="pan.luo@ubc.ca"

# libnlopt-dev is required by lmerTest
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      wget \
      r-base \
      r-base-dev \
      libssl-dev \
      libnlopt-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz && \
    R CMD INSTALL Rserve_1.8-6.tar.gz && \
    rm Rserve_1.8-6.tar.gz && \
    Rscript -e 'install.packages(c("leaps", "tree", "glmnet", "lars", "locfit", "nnet", "randomForest", "adabag", "lmerTest", "ggplot2", "visreg", "dplyr", "car", "vegan", "ElemStatLearn", "mclust"), repo="http://cran.rstudio.com")'

VOLUME /localdata

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 6311

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["R", "-e", "Rserve::run.Rserve(remote=TRUE, auth=FALSE, daemon=FALSE)"]
