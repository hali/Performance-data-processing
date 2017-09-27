library(rmarkdown)
filename <-"~/Downloads/ihdeportal.org-09-20-2017.har"
render("HARHotspots.Rmd", output_format = "html_document", output_dir = "out",,output_options=list(self_contained=TRUE))
