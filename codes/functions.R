# functions for codes/2_run.Rmd

# extract the closest tips
f_extract_closest_group <- function(dist_matrix, n_neighbour, taxonomic_rank, df_metadata, keep_ties) {
    # extract top hits and their taxonomic groups
    top_hits <- data.table::data.table(tip=names(dist_matrix), dist=dist_matrix) %>% slice_min(dist, n=n_neighbour)
    top_hits <- merge(top_hits, df_metadata, by.x="tip", by.y="sample", all.x=T)

    # output data.frame
    best_hit <- NULL

    # iterate over rank
    for (level in taxonomic_rank) {
        # extract the majority group for this rank
        major_group <- top_hits %>% count(!!sym(level)) %>% slice_max(n, n=1) %>% pull(!!sym(level))
        n_major_group <- length(major_group)

        # filter out locus if there is >1 majority
        if (length(major_group)>1 && !keep_ties) {
            next
        }

        # iterate over majority groups
        for (group in major_group) {
            # extract the closest tip in this group
            closest_tip <- top_hits %>% filter(!!sym(level)==group) %>% slice_min(dist, n=1)
            n_closest_tip <- nrow(closest_tip)

            # assign weight
            closest_tip <- closest_tip %>% mutate(rank_level=level, weight=1/(n_major_group*n_closest_tip))

            # update output data.frame
            best_hit <- rbind(best_hit, closest_tip)
        }
    }

    return(best_hit)
}