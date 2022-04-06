#!/bin/env Rscript
###
# Author:      Evgenii Semenov
# Description: Test proxy settings
#
#
###
tested_url <- "http://cran.r-project.org/Rlogo.jpg"
tested_package <- "Rcpp"
tested_github <- "RcppCore/Rcpp"

repos_url <- "https://cran.rstudio.com/"

dir <- tempfile()
dir.create(dir)
.libPaths(c(dir, .libPaths()))


saved_params <- c()
print(paste0("temp folder=", dir))
options_list <- c("download.file.method", "download.file.extra", "internet.info")
saved_params <- lapply(options_list, function(x) {
  print(paste0(x, "=", options(x)))
  options(x)
})

# httr R-package depends on curl R-package
library(httr)
curl::ie_get_proxy_for_url(tested_url)
httr::GET(tested_url, verbose(info=TRUE))

# curl R-package depends on libcurl.so
library(curl)
tmp <- tempfile()
curl_download(tested_url, tmp, handle=new_handle(verbose=1))

# current download.file.method
install.packages(tested_package, repos=repos_url)
devtools::install_github(tested_github)

if (options("download.file.method") != "libcurl") {
    options(download.file.method="libcurl")
    install.packages(tested_package, repos=repos_url)
    devtools::install_github(tested_github)
}

if (options("download.file.method") != "curl") {
    options(download.file.method="curl")
    options(download.file.extra=c("-q", "-vvv"))
    install.packages(tested_package, repos=repos_url)
    devtools::install_github(tested_github)
}

if (askYesNo(paste0("Remove temp dir ", dir, " ?")) {
    unlink(dir, recursive = TRUE, force = TRUE)
}

#
## Check output
