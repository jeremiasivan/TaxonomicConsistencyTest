# TaxonomicConsistencyTest

**Taxonomic Consistency Test** is an R pipeline to measure the variation of per-tip taxonomic placements across gene trees. It requires a set of gene trees as input, as well as the taxonomic groups for every sample on the trees. It is mainly developed and tested using Linux, so there might be incompatibilities using MacOS and Windows.

## Table of Content
- <a href="#prereqs">Prerequisites</a>
- <a href="#inout">Input and Output Files</a>
- <a href="#genpipe">General Pipeline</a>
- <a href="#refs">References</a>

## <a id="prereqs">Prerequisites</a>
Taxonomic Consistency Test requires several R packages to run. We recommend you to use environment management system (e.g. `conda`) to install the prerequisites, but you can also use `install.packages()` built-in function in R or RStudio.

### R packages
|    Name    |                               CRAN                               |                                   Anaconda                               |
| ---------- |:----------------------------------------------------------------:|:------------------------------------------------------------------------:|
| ape        | <a href="https://cran.r-project.org/package=ape">Link</a>        | <a href="https://anaconda.org/conda-forge/r-ape">Link</a>                |
| data.table | <a href="https://cran.r-project.org/package=data.table">Link</a> | <a href="https://anaconda.org/conda-forge/r-data.table">Link</a>         |
| doSNOW     | <a href="https://cran.r-project.org/package=doSNOW">Link</a>     | <a href="https://anaconda.org/conda-forge/r-dosnow">Link</a>             |
| kableExtra | <a href="https://cran.r-project.org/package=kableExtra">Link</a> | <a href="https://anaconda.org/conda-forge/r-kableextra">Link</a> |
| log4r      | <a href="https://cran.r-project.org/package=log4r">Link</a>      | <a href="https://anaconda.org/conda-forge/r-log4r">Link</a>              |
| optparse   | <a href="https://cran.r-project.org/package=optparse">Link</a>   | <a href="https://anaconda.org/conda-forge/r-optparse">Link</a>           |
| rmarkdown  | <a href="https://cran.r-project.org/package=rmarkdown">Link</a>  | <a href="https://anaconda.org/conda-forge/r-rmarkdown">Link</a>          |
| tidyverse  | <a href="https://cran.r-project.org/package=tidyverse">Link</a>  | <a href="https://anaconda.org/conda-forge/r-tidyverse">Link</a>          |
| yaml       | <a href="https://cran.r-project.org/package=yaml">Link</a>       | <a href="https://anaconda.org/conda-forge/r-yaml">Link</a>               |

## <a id="inout">Input and Output Files</a>

### Input Files
To run Taxonomic Consistency Test, users are required to provide a directory of gene trees and metadata file for all tips on the trees (see <a href="./config.yaml">`config.yaml`</a>). The metadata file should have a `sample` column, as well as separate columns for individual taxonomic ranks to be tested (e.g., genus, species). For example:

- `dir_gene_tree`
    ```
    gene_tree_directory/
    ├── gene01.treefile
    ├── gene02.treefile
    ├── gene03.treefile
    ...
    ```

- `file_taxonomy_metadata`
    | sample                | genus         | species    |
    | --------------------- | ------------- | ---------- |
    | SpeciesA_Sample01     | GenusX        | SpeciesA   |
    | SpeciesA_Sample02     | GenusX        | SpeciesA   |
    | SpeciesB_Sample01     | GenusX        | SpeciesB   |
    | SpeciesC_Sample01     | GenusY        | SpeciesC   |
    | ...                   | ...           | ...        |

### Output Files
Running Taxonomic Consistency Test will create an output folder that consists of:
- `allhits/` : all hits (i.e., closest taxa) for individual tips across all gene trees
- `prop_rank_Xneighbours.tsv`  : proportion of taxonomic `rank` assignment by considering `X` nearest neighbours
- `besthits_Xneighbours.tsv`   : best taxonomic assignment across ranks by considering `X` nearest neighbours
- `eff_Xneighbours.tsv`        : effective number of categories across taxonomic ranks by considering `X` nearest neighbours
- `prefix.log`             : Taxonomic Consistency Test log file
- `prefix_report.html`     : Taxonomic Consistency Test HTML report

## <a id="genpipe">General Pipeline</a>
1. **Clone the Git repository** <br>
    ```
    git clone git@github.com:jeremiasivan/TaxonomicConsistencyTest.git
    ```

2. **Install the prerequisites** <br>
    - Create a new conda environment
        ```
        conda create -n taxontest
        conda activate taxontest
        ```
    - Installing prerequisites
        ```
        conda install -c conda-forge r-ape r-data.table r-doSNOW r-kableExtra r-log4r r-optparse r-rmarkdown r-tidyverse r-yaml
        ```

3. **Update the parameters in `config.yaml`** <br>

4. **Run Taxonomic Consistency Test** <br>
    ```
    Rscript run_pipeline.R --config config.yaml
    Rscript run_pipeline.R --config config.yaml --redo
    ```

    In UNIX-based operating systems (e.g., Linux and MacOS), it is advisable to use `nohup` or `tmux` to run the whole pipeline. For Windows, you can use `psmux`. 

---
## <a id="refs">References</a>
1. Paradis, E., et al. (<a href="https://doi.org/10.1093/bioinformatics/btg412">2004</a>). **APE: Analyses of Phylogenetics and Evolution in R language**. *Bioinformatics*, *20*(2), 289-290.

2. Barrett, T., et al. (<a href="https://doi.org/10.32614/CRAN.package.data.table">2026</a>). **data.table: Extension of 'data.frame'**. *R package*.

3. Daniel, F. (<a href="https://cran.r-project.org/package=doSNOW">2022</a>). **doSNOW: Foreach Parallel Adaptor for the 'snow' Package**. *R package*.

4. Zhu, H., et al. (<a href="https://cran.r-project.org/package=kableExtra">2024</a>). **kableExtra: Construct Complex Table with 'kable' and Pipe Syntax**. *R package*.

5. White, J.M. & Jacobs, A. (<a href="https://doi.org/10.32614/CRAN.package.log4r">2024</a>). **log4r: A Fast and Lightweight Logging System for R, Based on 'log4j'**. *R package*.

6. Davis, T.L. (<a href="https://doi.org/10.32614/CRAN.package.optparse">2026</a>). **optparse: Command Line Option Parser**. *R package*.

7. Allaire, J.J., et al. (<a href="https://doi.org/10.32614/CRAN.package.rmarkdown">2026</a>). **rmarkdown: Dynamic Documents for R**. *R package*.

8. Wickham, H., et al. (<a href="https://doi.org/10.21105/joss.01686">2019</a>). **Welcome to the tidyverse**. *Journal of Open Source Software*, *4*(43), 1686.

9. Stephens, J., et al. (<a href="https://doi.org/10.32614/CRAN.package.yaml">2025</a>). **yaml: Methods to Convert R Data to YAML and Back**. *R package*.

10. Anthropic. (<a href="https://claude.ai/">2026</a>). Claude 4.6 Sonnet was used to generate `config.yaml` and `run_pipeline.R`. 

---
*Last update: 28 July 2026 by Jeremias Ivan*