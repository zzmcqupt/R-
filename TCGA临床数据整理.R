rm(list = ls())

library(jsonlite)

#设置工作路径
setwd("E:/")

#读取数据，需修改文件名
json <- jsonlite::fromJSON("metadata.cart.2023-07-25.json")

View(json)#可不需要
entity_submitter_id <- sapply(json$associated_entities,function(x){x[,1]})
case_id <- sapply(json$associated_entities,function(x){x[,3]})
sample_case <- t(rbind(entity_submitter_id,case_id))

clinical <- read.delim('clinical.cart.2023-07-26\\clinical.tsv', header = TRUE)
clinical <- as.data.frame(clinical[duplicated(clinical$case_id),])

clinical_matrix <- merge(sample_case,clinical,by="case_id",all.x=T)
clinical_matrix <- clinical_matrix[,-1]

write.csv(clinical_matrix,'clinical_matrix.csv',row.names = TRUE)
