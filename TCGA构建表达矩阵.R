rm(list = ls())
library(stringr)
library(jsonlite)
library(progress)

cancer_type <- "TCGA-LIHC"  # 设置肿瘤类型（需修改）
setwd("E:/") # 设置工作目录（需修改）
options(stringsAsFactors = F)

## 获取每个样品id和相应tsv文件名的对应关系：
json <- jsonlite::fromJSON("metadata.cart.2023-07-25.json")
# 读取Metadata文件中每个样品的信息（需修改matadata文件的名称）
View(json)

#取出json中associated_entities列中的第一个元素
sample_id <- sapply(json$associated_entities,function(x){x[,1]}) 

#sample_id为10个样本名
file_sample <- data.frame(sample_id,file_name=json$file_name)  
#得到file_name和sample_id的对应矩阵，然后将sample_id添加到对应文件名的TSV文件中，作为unstranded列的列名。

count_file <- list.files('gdc_download_20230724_062421.288369',pattern = '*gene_counts.tsv',recursive = TRUE)
#在count_file中分割出文件名
count_file_name <- strsplit(count_file,split='/')  

## 新建空白矩阵，行数与tsv文件中基因名行数形同（需查看并修改）
matrix = data.frame(matrix(nrow = 60660, ncol = 0))
## 取每个文件中的一列数据（count或tpm或fpkm），然后合并
pb <- progress_bar$new(format = "(:spin) [:bar] :percent 已用时::elapsedfull 预计剩余时间::eta",
                       total = length(count_file), clear = FALSE, width = 80) # 设置进度条
for (i in 1:length(count_file)){
  data<- paste0("gdc_download_20230724_062421.288369/", count_file[i]) %>%
    read.delim(fill = TRUE, header = FALSE, row.names = 1)
  data <- data[-c(1:6),]
  data <- data[7] # [3]是count，[6]是tpm，[7]是fpkm。一般用tpm，但差异分析R包需要用count。生存分析用tpm或fpkm。
  colnames(data) <- file_sample$sample_id[which(file_sample$file_name == count_file_name[i])]
  matrix <- cbind(matrix, data)
  pb$tick() # 显示进度条
  Sys.sleep(1 / 100) # 用于计算时间
} # 得到了表达矩阵 matrix ：行名为样品id，列名为Ensembl ID，值为自己修改的结果
write.csv(matrix, 'fpkm_matrix.csv', row.names = TRUE)
