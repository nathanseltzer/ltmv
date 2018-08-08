## 00 ltmv runfile
## "less trust, moore verification"
## Nathan Seltzer

## clean out any previous work
paths <- c("clean data", "graphics", "output")

for(path in paths){
  unlink(path, recursive = TRUE)    # delete folder and contents
  dir.create(path)                  # create empty folder
}

## run scripts
source("01_import_ltmv.R")
source("02_prep_ltmv.R")
source("03_plot_ltmv.R")
rmarkdown::render("04_report_ltmv.Rmd", output_dir = "output")
