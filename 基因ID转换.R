rm(list = ls())
setwd("F:/")
library(dplyr)
library(rtracklayer)
library(limma)

#读取注释文件并转换为dataframe
gtf_v22 <- read.table("gencode.v22.annotation.gene.probeMap",sep = "\t" , header = T) %>% as.data.frame()

# 读取RNA表达矩阵信息
data.exp.raw <- read.csv('TCGA-LIHC_FPKM_368.csv',
                         header = TRUE,
                         check.names = FALSE, sep = ',')
dim(data.exp.raw)

#根据注释文件，转换gene_ID
TCGA_gset <- data.exp.raw %>%
  inner_join(gtf_v22, by = c("Ensembl_ID" = "id")) %>%
  select(gene, starts_with("TCGA") )
TCGA_gset[1:4,1:4]

#利用limma包取平均值去重
exprSet = as.data.frame(avereps(TCGA_gset[,-1],ID = TCGA_gset$gene) )
dim(exprSet)
write.table(exprSet,"M_TCGA-LIHC_FPKM_368.csv",
            quote = F,sep = ",",row.names = T )
