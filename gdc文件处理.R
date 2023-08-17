# 清除工作空间
rm(list = ls())

# 设置工作目录为
setwd("E:/5DATA/gdc_download_20230724_062421.288369 (2)")

# 获取内层文件夹列表
inner_folders <- list.dirs(recursive = FALSE)

# 遍历内层文件夹，并将文件移动到指定文件夹中
for (folder in inner_folders) {
  inner_files <- list.files(path = folder, full.names = TRUE)
  file.copy(from = inner_files, to = ".", overwrite = TRUE)
}

# 删除内层文件夹（可选，根据需求）
for (folder in inner_folders) {
   unlink(folder, recursive = TRUE)
 }
