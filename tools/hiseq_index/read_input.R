
#' full table
#'
index_full_table <- function() {
  # read all
  idx_list <- read_index()
  
  # truseq
  df1 <- data.frame(
    id = names(idx_list$truseq),
    in_sequence = idx_list$truseq,
    in_primer   = revcomp(idx_list$truseq),
    row.names   = 1:length(idx_list$truseq)
  )
  
  # nextera
  df2 <- data.frame(
    id = names(idx_list$nextera),
    in_sequence = idx_list$nextera,
    in_primer   = revcomp(idx_list$nextera),
    row.names   = 1:length(idx_list$nextera)
  )
  
  # output
  return(list(truseq = df1, nextera = df2))
}


# simplify index name
# keep only index number
index_fix_name <- function(x) {
  xn <- sapply(x, function(i) {
    gsub("truseq_index|next_ad2.", "", i, ignore.case = TRUE)
  })
  return(xn)
}



#' for recommend index - module
#' suggested index
#' 
index_picker <- function(hiseq_type, n_mutation = 3) {
  # read all
  idx_list <- read_index()
  
  # available tables
  idx <- c()
  if("truseq" %in% hiseq_type) {
    idx <- c(idx, idx_list$truseq)
  }
  if("nextera" %in% hiseq_type) {
    idx <- c(idx, idx_list$nextera)
  }
  
  # if no input
  if(length(idx) == 0) {
    df <- data.frame(Index_group      = c("TruSeq", "Nextera"),
                     n_candidates     = c(0, 0),
                     Index_candidates = c("", ""),
                     Index_conflict   = c("", ""))
  } else {
    # exclude index
    dfx <- index_mutation(idx) %>%
      dplyr::filter(! is.na(score)) %>%
      dplyr::filter(score < n_mutation)
    idx_ex         <- unique(c(as.character(dfx$y), 
                               as.character(dfx$x)))
    idx_ex_truseq  <- idx_ex[grepl("TruSeq", idx_ex)]
    idx_ex_nextera <- idx_ex[grepl("Next", idx_ex)]
    
    # include index
    idx_in         <- names(idx)[! names(idx) %in% idx_ex]
    idx_in_truseq  <- idx_in[grepl("TruSeq", idx_in)]
    idx_in_nextera <- idx_in[grepl("Next", idx_in)]
    
    # output
    p <- lapply(list(ex_t = idx_ex_truseq, 
                     ex_n = idx_ex_nextera,
                     in_t = idx_in_truseq,
                     in_n = idx_in_nextera), 
                function(i) {
                  paste(index_fix_name(i), collapse = ", ")
                })
    
    # output
    df <- data.frame(Index_group      = c("TruSeq", "Nextera"),
                     n_candidates     = c(length(idx_in_truseq),
                                          length(idx_in_nextera)),
                     Index_candidates = c(p$in_t, p$in_n),
                     Index_conflict   = c(p$ex_t, p$ex_n))
  }
  
  # output
  return(df)
}


#' index seq
#' read index from text
#'
read_index <- function(path = NULL) {
  # path
  path <- "data"
  
  # truseq
  df1 <- read.csv(file.path(path, "illumina_truseq.txt"), comment.char = "#")
  idx1 <- df1$sequence
  names(idx1) <- df1$id
  
  # nextera
  df2 <- read.csv(file.path(path, "illumina_nextera.txt"), comment.char = "#")
  idx2 <- df2$sequence
  names(idx2) <- df2$id
  
  # save to list
  p <- list(truseq = idx1, nextera = idx2)
  
  # save to RDS
  out <- file.path(path, "illumina_index.rds")
  saveRDS(p, file = out)
  
  return(p)
}




#'
complement <- function(x) {
  # table
  comp <- c("A", "C", "G", "T", "U", "N", "a", "c", "g", "t", "u", "n")
  names(comp) <- c("T", "G", "C", "A", "A", "n", "t", "g", "c", "a", "a", "n")
  
  x_comp <- sapply(x, function(i){
    # split i
    i_char <- stringr::str_split(i, "", simplify = TRUE)
    i_char <- as.vector(i_char)
    
    # complement
    i_comp <- comp[i_char]
    
    # to string
    i_str  <- paste(i_comp, collapse = "")
    return(i_str)
  })
  
  # output
  return(x_comp)
}


reverse <- function(x) {
  x_rev <- sapply(x, function(i){
    i_char <- stringr::str_split(i, "", simplify = TRUE)
    i_char <- as.vector(i_char)
    i_rev  <- paste(rev(i_char), collapse = "")
  })
  return(x_rev)
}


revcomp <- function(x) {
  return(reverse(complement(x)))
}


#' read index for server
#'
#' @param x character illumina truseq, nextera
#' @param y character inputbox
#'
read_input <- function(x, y = NULL) {
  # illumina index
  # saved in :data/illumina_index.rds
  idx_list <- read_index()
  idx      <- c(idx_list$truseq, idx_list$nextera)
  
  idx_illumina <- idx[idx %in% x]
  
  # check inputbox
  if(is.null(y)){
    idx_box <- ""
  } else {
    idx_box <- read_textbox(y)
  }
  
  # prepare input
  idx_input <- c(idx_illumina, idx_box)
  
  # valid
  chk <- sapply(idx_input, valid_index)
  
  # remove others
  return(idx_input[chk])
}



#' read input
#'
#'
#' @param x character
#'
#'
#' @export
#'
read_textbox <- function(x) {
  # split by; non-letters
  m <- stringr::str_split(x, "[^A-Za-z]", simplify = TRUE)
  m <- as.vector(m)
  m <- toupper(m)
  return(m)
}


#' check if the index is valid
#' 2-30 nt
#' ACGTN
#'
#' @param x vector
#'
#'
#' @return
#'
valid_index <- function(x) {
  tmp <- sapply(x, function(i){
    grepl("^[ACGTN]{2,30}$", i)
  })
  
  return(all(tmp))
}


#' get labels
#'
#' @param x vector character
#'
#' @export
#'
get_labels <- function(x, labels = NULL) {
  # could be vector, matrix, data.frame
  pre_labels <- c(LETTERS,
                  paste(rep(LETTERS, each = length(LETTERS)),
                        LETTERS,
                        sep = ""))
  
  # assign, default
  if(is.null(names(x))) {
    names(x) <- pre_labels[1:length(x)]
  }
  
  # check if "blank" names exists
  bn <- sum(names(x) == "")
  names(x)[names(x) == ""] <- pre_labels[1:bn]
  
  # check input
  if(! is.null(labels)) {
    warning("labels short than x")
    pre_labels <- c(labels, pre_labels)
    names(x) <- pre_labels[1:length(x)]
  }
  
  # ouptut
  return(x)
}


#' 
#' pick_n <- function(x, n = 0) {
#'   # input
#'   n_input <- length(x)
#'   
#'   # choose
#'   if(n_input < n) {
#'     warning("not enough items, choose a smaller number")
#'     n = 0
#'   }
#'   
#'   # check n
#'   if(n == 0) {
#'     return(list())
#'   }
#'   
#'   # number of gaps
#'   n_gap <- n_input - n + 1
#'   
#'   # check start, end
#'   x_list <- lapply(seq_len(n_gap), function(i){
#'     x[i:(i + n - 1)]
#'   })
#'   
#'   # output
#'   return(x_list)
#' }
#' 
#' 
#' #' suggest combinations
#' #'
#' #'
#' #'
#' index_combinations <- function(n_truseq = 0, n_nextera = 0, n_mutation = 3) {
#'   # read all
#'   idx_list <- read_index()
#'   
#'   # available tables
#'   # idx <- unlist(idx_list)
#'   if(n_truseq > 0 & n_nextera > 0) {
#'     idx <- c(idx_list$truseq, idx_list$nextera)
#'   } else if(n_truseq > 0) {
#'     idx <- idx_list$truseq
#'   } else if(n_nextera > 0) {
#'     idx <- idx_list$nextera
#'   } else {
#'     idx <- ""
#'   }
#'   
#'   # exclude index
#'   dfx <- index_mutation(idx) %>%
#'     dplyr::filter(! is.na(score)) %>%
#'     dplyr::filter(score < n_mutation)
#'   idx_ex <- unique(c(as.character(dfx$y), as.character(dfx$x)))
#'   
#'   # full list
#'   idx_str <- names(idx)[! names(idx) %in% idx_ex]
#'   
#'   # truseq
#'   idx_truseq <- idx_str[grepl("TruSeq", idx_str)]
#'   
#'   # nextera
#'   idx_nextera <- idx_str[grepl("Next", idx_str)]
#'   
#'   # pick index
#'   list_truseq  <- pick_n(idx_truseq, n_truseq)
#'   list_nextera <- pick_n(idx_nextera, n_nextera)
#'   
#'   # output
#'   return(list(truseq  = list_truseq,
#'               nextera = list_nextera))
#' }
#' 
#' 
#' #' choose specific number of truseq, nextera index
#' #'
#' #' ouput, as string
#' index_auto <- function(n_truseq = 0, n_nextera = 0, n_mutation = 3) {
#'   idx_list <- index_combinations(n_truseq, n_nextera, n_mutation)
#'   
#'   ia <- gsub("truseq_index", "", unique(unlist(idx_list$truseq)),
#'              ignore.case = TRUE)
#'   ib <- gsub("next_ad2.", "", unique(unlist(idx_list$nextera)),
#'              ignore.case = TRUE)
#'   
#'   sa <- paste(ia, collapse = ", ")
#'   sb <- paste(ib, collapse = ", ")
#'   
#'   df <- data.frame(
#'     group = c("TruSeq", "Nextera"),
#'     candidates = c(length(ia), length(ib)),
#'     index = c(sa, sb)
#'   )
#'   
#'   return(df)
#' }
#' 











