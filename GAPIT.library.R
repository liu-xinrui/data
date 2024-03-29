    options(repos='http://cran.rstudio.com/')

if(!require(gplots)) install.packages("gplots")
if(!require(LDheatmap)) install.packages("LDheatmap")
if(!require(genetics)) install.packages("genetics")
if(!require(ape)) install.packages("ape")
if(!require(compiler)) install.packages("compiler")
if(!require(grid)) install.packages("grid")

if(!require(EMMREML)) install.packages("EMMREML")
if(!require(scatterplot3d)) install.packages("scatterplot3d")

if(!'multtest'%in% installed.packages()[,"Package"]|!'snpStats'%in% installed.packages()[,"Package"]){
	if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")

    BiocManager::install("multtest")
    BiocManager::install("snpStats")

    print("If these packages can not be installed.")
    print("Please try this code: ")
    print(" options(BioC_mirror='http://mirrors.ustc.edu.cn/bioc/') ")
}
