library(rmarkdown)
render("Pritcel.rmd", output_format = "html_document", output_dir = "out",,output_options=list(self_contained=TRUE))
