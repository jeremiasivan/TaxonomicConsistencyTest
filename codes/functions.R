# functions for codes/2_run.Rmd

# extract the closest tips
f_extract_closest_group <- function(dist_matrix, n_neighbour, taxonomic_rank, df_metadata) {
    # extract top hits and their taxonomic groups
    top_hits <- data.table::data.table(tip=names(dist_matrix), dist=dist_matrix) %>% slice_min(dist, n=n_neighbour)
    top_hits <- merge(top_hits, df_metadata, by.x="tip", by.y="sample", all.x=T)

    # output data.frame
    df_temp_out <- data.frame(level=character(), group=character())
    for (level in taxonomic_rank) {
        major_group <- top_hits %>% count(!!sym(level)) %>% slice_max(n, n=1) %>% pull(!!sym(level))
        df_temp_out <- rbind(df_temp_out, data.frame(level=level, group=major_group))
    }

    # keep only hits that match all levels
    matches_all_levels <- rep(TRUE, nrow(top_hits))
    for (i in 1:nrow(df_temp_out)) {
        level <- df_temp_out$level[i]
        group <- df_temp_out$group[i]
        matches_all_levels <- matches_all_levels & (top_hits[[level]] == group)
    }

    # extract the best hit
    best_hit <- top_hits[matches_all_levels, ] %>% slice_min(dist, n=1)

    return(best_hit)
}