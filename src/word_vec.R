search_synonyms <- function(word_vectors, selected_vector) {
    
    similarities <- word_vectors %*% 
        selected_vector %>%
        tidy() %>%
        as_tibble() %>%
        rename(token = .rownames,
               similarity = unrowname.x.)
    
    similarities %>%
        arrange(-similarity) %>%
        top_n(10)
}


get_uni_p <- function(data) {
    
    data %>%
        unnest_tokens(word, headline_text) %>%
        count(word, sort = TRUE) %>%
        mutate(p = n / sum(n))
    
}

get_skipgram_p <- function(data, skipgram = 6) {
    
    data %>%
        unnest_tokens(ngram, headline_text, 
                      token = "ngrams", n = 6) %>%
        mutate(ngramID = row_number()) %>% 
        unite(skipgramID, publish_date, ngramID) %>%
        unnest_tokens(word, ngram)
    
}


get_word_vec <- function(data) {
    
    # The dataset is going to be huge
    # lets cast to a matrix and reduce dimensionality 
    # to make it more efficient to use
    pmi_matrix <- data %>%
        mutate(pmi = log10(p_together)) %>%
        cast_sparse(word1, word2, pmi)
    
    # pmi_svd <- irlba(pmi_matrix, 256, maxit = 1e3)
    word_vectors <- irlba(pmi_matrix, 3)$u
    rownames(word_vectors) <- rownames(pmi_matrix)
    
    word_vectors
    
}
