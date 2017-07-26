FROM debian:stretch

MAINTAINER Pan Luo pan.luo@ubc.ca

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests wget r-base r-base-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate https://www.rforge.net/Rserve/snapshot/Rserve_1.8-5.tar.gz && \
    R CMD INSTALL Rserve_1.8-5.tar.gz && \
    rm Rserve_1.8-5.tar.gz && \
    Rscript -e 'install.packages(c("leaps", "tree", "glmnet", "lars", "locfit", "nnet", "randomForest", "adabag", "lmerTest", "ggplot2", "visreg", "dplyr", "car", "vegan"), repo="http://cran.rstudio.com")'

EXPOSE 6311

CMD ["R", "-e", "Rserve::run.Rserve(remote=TRUE, auth=FALSE, daemon=FALSE)"]
