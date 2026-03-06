
suppressMessages({"library(vegan)"})

# Install vegan if needed (non-interactive; CRAN mirror set)
if (!requireNamespace("vegan", quietly = TRUE)) {
    install.packages("vegan", repos = "https://cloud.r-project.org")
    library(vegan)
}

abund_fp <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/q1/abundance_for_adonis.csv"
meta_fp  <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/q1/metadata_for_adonis.csv"
batch_fp <- "/content/drive/MyDrive/Assignments/CoMeG/assignment_2/q1/batch3_ids.csv"

# Read CSVs
abund <- read.csv(abund_fp, row.names=1, check.names=FALSE, stringsAsFactors=FALSE)
meta  <- read.csv(meta_fp, stringsAsFactors=FALSE)
batch <- read.csv(batch_fp, stringsAsFactors=FALSE)

# Normalize sample id column name if necessary
if (!"sample_id" %in% colnames(meta)) {
    candidate <- NULL
    for (cn in colnames(meta)) {
        if (tolower(cn) %in% c("sampleid","sample_id","sample","id")) {
            candidate <- cn
            break
        }
    }
    if (!is.null(candidate)) {
        colnames(meta)[colnames(meta) == candidate] <- "sample_id"
    }
}

# Subset samples according to batch file, preserving order
ids <- as.character(batch$sample_id)
avail <- ids[ids %in% rownames(abund)]
if (length(avail) == 0) stop("No batch samples found in abundance file. Check sample IDs.")
abund_sub <- abund[avail, , drop = FALSE]

meta_sub <- meta[meta$sample_id %in% avail, , drop = FALSE]
rownames(meta_sub) <- as.character(meta_sub$sample_id)
# Reorder meta_sub to match abund_sub order
meta_sub <- meta_sub[rownames(abund_sub), , drop = FALSE]

# Ensure study_condition and age_category exist
if (!"study_condition" %in% colnames(meta_sub)) stop("Column 'study_condition' not found in metadata.")
if (!"age_category" %in% colnames(meta_sub)) stop("Column 'age_category' not found in metadata.")

# Make age_category a factor
meta_sub$age_category <- as.factor(meta_sub$age_category)
meta_sub$study_condition <- as.factor(meta_sub$study_condition)

# Compute Bray distance (vegdist expects samples x species)
bray <- vegdist(abund_sub, method = "bray")

# Run adonis2 with study_condition + age_category (by = "margin" gives marginal tests)
adon_res <- adonis2(bray ~ study_condition + age_category, data = meta_sub, permutations = 999, by = "margin")

cat("---- adonis2 results (study_condition + age_category) ----\n")
print(adon_res)
