#! /bin/bash

R_PATH=$(which r)
$R_PATH --save -e 'source("http://bioconductor.org/biocLite.R")'
$R_PATH --save -e 'biocLite("PROcess")'
$R_PATH --save -e 'install.packages("ggplot2", repos="http://cran.us.r-project.org")'
