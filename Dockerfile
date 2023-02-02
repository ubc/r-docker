FROM debian:bullseye

LABEL maintainer="pan.luo@ubc.ca"

# libnlopt-dev is required by lmerTest
RUN apt-get update && \
    apt-get install -y gnupg2 && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      wget \
      r-base \
      r-base-dev \
      libssl-dev \
      libnlopt-dev \
      libcurl4-openssl-dev \
      # these r packages failed to install from the cran repo as they require R
      # >= 4.1.0, so installing them from debian repo instead
      r-cran-locfit \
      r-cran-randomforest \
      r-cran-car \
      && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz && \
    R CMD INSTALL Rserve_1.8-6.tar.gz && \
    rm Rserve_1.8-6.tar.gz
# preferring cran repo for R packages as they're more up-to-date, e.g. debian
# repo version of tseries failed to connect to yahoo for data which was fixed
# in a more recent release of tseries
RUN Rscript -e 'install.packages(c("leaps", "tree", "glmnet", "lars", "nnet", "adabag", "lmerTest", "ggplot2", "visreg", "dplyr", "vegan", "mclust", "tseries", "zoo", "lpSolve"), repo="http://cran.rstudio.com")'

VOLUME /localdata

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 6311

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["R", "-e", "Rserve::run.Rserve(remote=TRUE, auth=FALSE, daemon=FALSE)"]
