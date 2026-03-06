
suppressMessages(library(vegan))
abund_fp <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/species_profile_norm.csv"
meta_fp  <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/metadata_all.csv"
batch_fp <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/Batch3.csv"

abund <- read.csv(abund_fp, row.names=1, check.names=FALSE, stringsAsFactors=FALSE)
meta  <- read.csv(meta_fp, stringsAsFactors=FALSE)
batch <- read.csv(batch_fp, stringsAsFactors=FALSE)

# Normalize column names
if(!"sample_id" %in% colnames(meta)) {
  candidate <- NULL
  for(cn in colnames(meta)) {
    if(tolower(cn) %in% c("sampleid","sample_id","sample","id")) {
      candidate <- cn; break
    }
  }
  if(!is.null(candidate)) {
    colnames(meta)[colnames(meta) == candidate] <- "sample_id"
  }
}

ids <- as.character(batch$sample_id)
avail <- ids[ids %in% rownames(abund)]
if(length(avail) == 0) stop("No batch samples found in abundance file.")

abund_sub <- abund[avail, , drop=FALSE]
meta_sub  <- meta[meta$sample_id %in% avail, , drop=FALSE]
rownames(meta_sub) <- as.character(meta_sub$sample_id)

if(!"age" %in% colnames(meta_sub)) stop("Column 'age' not found in metadata.")
meta_sub$age <- as.numeric(meta_sub$age)

# ✅ Bray–Curtis PERMANOVA controlling for age
bray <- vegdist(abund_sub, method="bray")
adon_res <- adonis2(bray ~ study_condition + age, data=meta_sub, permutations=999, by="margin")

cat("---- adonis2 results (study_condition + age) ----\n")
print(adon_res)
write.table(capture.output(adon_res), file="/content/drive/MyDrive/Assignments/CoMeG/assignment_2/q2/adonis2_output.txt", row.names=FALSE, col.names=FALSE)
