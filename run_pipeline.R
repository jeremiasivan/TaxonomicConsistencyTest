#!/usr/bin/env Rscript

# ============================================================
#  Taxonomic Consistency Test
#
#  Usage: Rscript run_pipeline.R --config config.yaml
#         Rscript run_pipeline.R --config config.yaml --redo
# ============================================================

# --- Load libraries and function ----------------------------
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(yaml))

# create a function to retrieve parameter value with default
f_get_param <- function(value, default) {
  if (is.null(value) || identical(value, "")) {
    default
  } else {
    value
  }
}

# --- Argument parsing ----------------------------------------
option_list <- list(
  make_option(c("-c", "--config"), type="character", default=NULL,
              help="Path to YAML config file [required]", metavar="FILE"),
  make_option(c("-r", "--redo"), action="store_true", default=FALSE,
              help="Re-run all analyses and override previous results")
)

# parse the arguments
opt <- parse_args(OptionParser(option_list=option_list))

# stop the code if config file is invalid
if (is.null(opt$config)) {
  stop("-c/--config is required.\n
        Usage: Rscript run_pipeline.R --config config.yaml")
}

if (!file.exists(opt$config)) {
  stop(paste("Config file not found:", opt$config))
}

# --- Load and validate config --------------------------------
cfg <- yaml::read_yaml(opt$config)

# set required parameters
required_fields <- c("codedir", "outdir", "dir_gene_tree", "file_taxonomy_metadata", "taxonomic_rank")
missing <- setdiff(required_fields, names(cfg))
if (length(missing) > 0) {
  stop(paste("Missing required config fields:", paste(missing, collapse=", ")))
}

# check if input files are invalid
if (is.null(cfg$dir_gene_tree) || cfg$dir_gene_tree == "") {
  stop("dir_gene_tree must be set in the config file.")
}

if (!dir.exists(path.expand(cfg$dir_gene_tree))) {
  stop(paste("dir_gene_tree not found:", cfg$dir_gene_tree))
}

if (!file.exists(path.expand(cfg$file_taxonomy_metadata))) {
  stop(paste("file_taxonomy_metadata file not found:", cfg$file_taxonomy_metadata))
}

if (length(unlist(cfg$taxonomic_rank))==0) {
  stop(paste("Invalid taxonomic ranks to test:", cfg$taxonomic_rank))
}

# check if prefix is set
if (is.null(cfg$prefix) || cfg$prefix == "") {
  cfg$prefix <- "TCT_output"
}

# --- Apply CLI overrides -------------------------------------
if (opt$redo) {
  message("Note: --redo flag set via CLI, overriding config.")
  cfg$redo <- TRUE
}

# --- Map config to rmarkdown params --------------------------
render_params <- list(
  codedir              = cfg$codedir,
  prefix               = cfg$prefix,
  outdir               = cfg$outdir,
  thread               = as.integer(f_get_param(cfg$thread, 1)),
  redo                 = as.logical(f_get_param(cfg$redo, FALSE)),

  dir_gene_tree           = cfg$dir_gene_tree,
  file_taxonomy_metadata  = cfg$file_taxonomy_metadata,

  file_list_tips       = f_get_param(cfg$file_list_tips, ""),

  n_neighbour          = unlist(f_get_param(cfg$n_neighbour, list(1,5))),
  taxonomic_rank       = cfg$taxonomic_rank
)

# --- Run Taxonomic Consistency Test --------------------------
rmd_path <- file.path(path.expand(render_params$codedir), "codes", "1_main.Rmd")
if (!file.exists(rmd_path)) {
  stop(paste("1_main.Rmd not found:", rmd_path))
}

message("Starting Taxonomic Consistency Test...")
message("  Config:          ", opt$config)
message("  Prefix:          ", render_params$prefix)
message("  Output:          ", render_params$outdir)
message("  Gene trees:      ", render_params$dir_gene_tree)
message("  Metadata file:   ", render_params$file_taxonomy_metadata)
message("  Threads:         ", render_params$thread)

# render the Rmarkdown file
rmarkdown::render(
  input       = rmd_path,
  params      = render_params,
  output_file = paste0(render_params$prefix, "_report.html"),
  output_dir  = file.path(path.expand(render_params$outdir), render_params$prefix),
  quiet       = FALSE
)

message("Done. Report: ",
        file.path(path.expand(render_params$outdir), render_params$prefix, paste0(render_params$prefix, "_report.html")))
