graph_occurence <- function(keyword, data) {
    
    #' Graph the volume of stories per day
    #' for a particular term. 
    
    t <- tidy_df %>%
        filter(word == keyword) %>%
        group_by(date) %>%
        summarise(count = n()) 
    
    if(nrow(t) == 0) {
        print('No Occurences of this word, in this dataset')
    } else {
        ggplot(t, aes(date, count)) +
            geom_smooth() +
            theme_minimal() +
            labs(title = 'Key Word Occurences',
                 subtitle = paste0('Number of Stories Including "',
                                   keyword, '" per day'),
                 x = '', y = 'Count of Stories')
    }
    
}