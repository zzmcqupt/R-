rm(list = ls())
setwd("E:/")

data1 <- read.table('GOBP_NEGATIVE_REGULATION_OF_DEFENSE_RESPONSE_TO_VIRUS.v2023.1.Hs.tsv',
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    sep = '\t')
data2 <- read.table('GOBP_NEGATIVE_REGULATION_OF_IMMUNE_EFFECTOR_PROCESS.v2023.1.Hs.tsv',
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    sep = '\t')
data3 <- read.table('GOBP_REGULATION_OF_HUMORAL_IMMUNE_RESPONSE.v2023.1.Hs.tsv',
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    sep = '\t')
data4 <- read.table('GOBP_HUMORAL_IMMUNE_RESPONSE.v2023.1.Hs.tsv',
                    header = FALSE,
                    stringsAsFactors = FALSE,
                    sep = '\t')
# Find the row indices for GENE_SYMBOLS in each data frame
gene_symbols_row_1 <- which(data1$V1 == "GENE_SYMBOLS")
gene_symbols_row_2 <- which(data2$V1 == "GENE_SYMBOLS")
gene_symbols_row_3 <- which(data3$V1 == "GENE_SYMBOLS")
gene_symbols_row_4 <- which(data4$V1 == "GENE_SYMBOLS")

# Extract the gene symbols from each GENE_SYMBOLS row and split them by comma
gene_symbols_1 <- strsplit(data1[gene_symbols_row_1, "V2"], ",")[[1]]
gene_symbols_2 <- strsplit(data2[gene_symbols_row_2, "V2"], ",")[[1]]
gene_symbols_3 <- strsplit(data3[gene_symbols_row_3, "V2"], ",")[[1]]
gene_symbols_4 <- strsplit(data4[gene_symbols_row_4, "V2"], ",")[[1]]

# Combine all the gene symbols into a single vector
all_gene_symbols <- c(gene_symbols_1, gene_symbols_2, gene_symbols_3, gene_symbols_4)

# Create a new data frame with a single column for the merged gene symbols
merged_data <- data.frame(GENE_SYMBOLS = all_gene_symbols)

# Write the merged data to a new CSV file
write.csv(merged_data, file = "Merged_GENE_SYMBOLS.csv", row.names = FALSE)
