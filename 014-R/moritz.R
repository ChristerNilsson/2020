# if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

setwd(file.path("/Lab/2020/014-R"))

# BiocManager::install("infercnv")

library(infercnv)

infercnv_obj = readRDS('run.final.infercnv_obj')
# ?plot_cnv
# apply median filtering adding on to the one before
infercnv_obj_medianfiltered = infercnv::apply_median_filtering(infercnv_obj)

infercnv::plot_cnv(infercnv_obj_medianfiltered,
                   #out_dir= o.dir,
                   output_filename='infercnv.median_filtered',
                   x.range="auto",
                   x.center=1,
                   title = "infercnv",
                   color_safe_pal = FALSE)