# PRIDE Cluster clusters all MS/MS spectra submitted to PRIDE Archive repository release: 2015-04
# http://www.ebi.ac.uk/pride/cluster/

# Description:The present script provides a reliable QC (Quality control) report about MGF files generated. 

# This script must be in the folder /nfs/nobackup/pride/cluster-prod/archive_spectra 

###############################################
# 
# Upload packages
packages <- c( "ggplot2", "scales", "knitr", "markdown", "tidyr", "rmarkdown","gridExtra")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(packages, rownames(installed.packages())))  }

library("ggplot2"); library("scales"); library("knitr"); library("markdown"); 
library("tidyr"); library("rmarkdown"); library("gridExtra")


#Count files how many files are in the folder. 
file_all <- list.files(file.path(getwd(), "testall"), pattern = "\\.mgf$") 
file_iden <- list.files(file.path(getwd(), "testide"), pattern = "\\.mgf$") 
file_unide <- list.files(file.path(getwd(), "testun"), pattern = "\\.mgf$")


#Create a data frame with the data obtained: 
df.test <- data.frame(Types = c("Total", "Identify", "Unidentify"), Spectra= c(length(file_all), length(file_iden),length(file_unide)) )

table(df.test)


df.id_and_uni <- data.frame(Types = c("Identify", "Unidentify"), Spectra= c(length(file_iden),length(file_unide)) )

#Create the pie chart

ggplot(transform(transform(df.id_and_uni, Spectra=Spectra/sum(Spectra)), labPos=cumsum(Spectra)-Spectra/2), 
       aes(x="", y = Spectra, fill = Types)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(y=labPos, label=scales::percent(Spectra)), size=7)

#How many files without data
#Removing empty files, the porcentage is: 


# create a list of files in the current working directory. CHANGE PATH
setwd("~/Dropbox/Script_R_Cambridge/Script2/testall")
list_of_all <- file.info(dir())
setwd("~/Dropbox/Script_R_Cambridge/Script2/testide")
list_of_iden <- file.info(dir())
setwd("~/Dropbox/Script_R_Cambridge/Script2/testun")
list_of_unid <- file.info(dir())


# get the size for each file
setwd("~/Dropbox/Script_R_Cambridge/Script2/testall")
size_all <- file.info(dir(path = "~/Dropbox/Script_R_Cambridge/Script2/testall"))$size
setwd("~/Dropbox/Script_R_Cambridge/Script2/testide")
size_iden <- file.info(dir(path = "~/Dropbox/Script_R_Cambridge/Script2/testide"))$size
setwd("~/Dropbox/Script_R_Cambridge/Script2/testun")
size_uniden <- file.info(dir(path = "~/Dropbox/Script_R_Cambridge/Script2/testall"))$size


# subset the files that have non-zero size
all_with_data <-  rownames(list_of_all)[which(size_all != 0)]
iden_with_data <-  rownames(list_of_iden)[which(size_iden != 0)]
unid_with_data <-  rownames(list_of_unid)[which(size_uniden != 0)]


# get the empty files
all_without_data <-  rownames(list_of_all)[which(size_all == 0)]
iden_without_data <-  rownames(list_of_iden)[which(size_iden == 0)]
unid_without_data <-  rownames(list_of_unid)[which(size_uniden == 0)]

#plot with data. 


df_with_data_all <- data.frame(Types = c("Total", "Identify", "Unidentify"), Spectra= c(length(all_with_data),length(iden_with_data),length(unid_with_data)) )
grid.table(df_with_data_all)

df_with_data <- data.frame(Types = c("Identify", "Unidentify"), Spectra= c(length(iden_with_data),length(unid_with_data)) )

ggplot(transform(transform(df_with_data , Spectra=Spectra/sum(Spectra)), labPos=cumsum(Spectra)-Spectra/2), 
       aes(x="", y = Spectra, fill = Types)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(y=labPos, label=scales::percent(Spectra)), size=7)

#without data. 
df_without_data_all <- data.frame(Types = c("Total", "Identify", "Unidentify"), Spectra= c(length(all_without_data),length(iden_without_data),length(unid_without_data)) )
grid.table(df_without_data_all)
df_without_data <- data.frame(Types = c("Identify", "Unidentify"), Spectra= c(length(iden_without_data),length(unid_without_data)) )

ggplot(transform(transform(df_without_data , Spectra=Spectra/sum(Spectra)), labPos=cumsum(Spectra)-Spectra/2), 
       aes(x="", y = Spectra, fill = Types)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar(theta = "y") +
    geom_text(aes(y=labPos, label=scales::percent(Spectra)), size=7)

