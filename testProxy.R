#!/bin/env Rsciprt
###
# Author:      Evgenii Semenov
# Description: Test proxy settings
#
#
###
dir <- tempfile()
dir.create(dir)
.libPaths(c(dir, .libPaths()))

url <- "http://cran.r-project.org/Rlogo.jpg"

print(options("download.file.method"))
print(options("download.file.extra"))
print(options("internet.info"))

saved_method <- options("download.file.method")
saved_extra <- options("download.file.extra")
saved_info <- options("internet.info")

options(internet.info=0)
# httr R-package depends on curl R-package
library(httr)
curl::ie_get_proxy_for_url(url)
httr::GET(url, verbose(info=TRUE))

# curl R-package depends on libcurl.so
library(curl)
tmp <- tempfile()
curl_download(url, tmp, handle=new_handle(verbose=1))

# current download.file.method
install.packages("Rcpp", repos="https://cran.rstudio.com")
devtools::install_github("RcppCore/Rcpp")

if (options("download.file.method") != "libcurl") {
  options(download.file.method="libcurl")
  install.packages("Rcpp", repos="https://cran.rstudio.com")
  devtools::install_github("RcppCore/Rcpp")
}

if (options("download.file.method") != "curl") {
  options(download.file.method="curl")
  options(download.file.extra=c("-q", "-vvv"))
  install.packages("Rcpp", repos="https://cran.rstudio.com")
  devtools::install_github("RcppCore/Rcpp")
}

## Check output
