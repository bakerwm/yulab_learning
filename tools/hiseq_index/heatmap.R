
## create heatplot for sequences
## edits distance between sequences
library(ggplot2)
library(dplyr)


#' calculate the mutations between index
#'
#' @param x vector index sequences
#'
#' @export
index_mutation <- function(x, labels = NULL) {
  # chr
  if(!inherits(x, "character")) {
    stop("Expect character")
  }

  # get labels
  x <- get_labels(x, labels)

  # make sure the same length
  min_len <- min(nchar(x))
  x <- sapply(x, function(i){stringr::str_sub(i, 1, min_len)}) # uniform length

  # distance
  ma <- adist(x, partial = FALSE, ignore.case = TRUE)

  # save half matrix
  # ma[upper.tri(ma, diag = TRUE)] <- NA
  ma[lower.tri(ma, diag = TRUE)] <- NA

  # create matrix/data.frame
  df <- ma %>%
    as.data.frame() %>%
    tibble::rownames_to_column("y") %>%
    tidyr::gather(key = "x", value = "score", -1) %>%
    # dplyr::mutate(score = factor(score)) %>%
    dplyr::mutate(x = factor(x, levels = rownames(ma)),
                  y = factor(y, levels = rev(colnames(ma))))

  # output
  return(df)
}



#' create heatmap plot
#'
#'
#' @param x vector index sequenes
#'
#' @export
#'
mut_heatmap <- function(df) {
  # convert to level
  df <- df %>%
    dplyr::mutate(score = factor(score))

  # chosen colors
  # pre-defined colors:
  # 0:red, 1:brown1, 2:darkorange, 3-:cyan
  mut_colors <- c("red2", "brown1", "darkorange",
                  rep("seagreen3", 98))
  names(mut_colors) <- 0:100
  mut_colors <- mut_colors[levels(df$score)]

  # number of samples
  nsamples <- length(levels(df$x))
  ptitle   <- paste0("Number of index sequences: [ ", nsamples, " ]")

  # create heatmap
  p <- df %>%
    ggplot(aes(x, y, fill = score)) +
    # geom_raster() +
    geom_tile(color = "white") +
    xlab(NULL) + ylab(NULL) +
    # ggtitle("Mutations between sequences") +
    ggtitle(ptitle) +
    geom_text(aes(label = score), color = "grey30", size = 4) +
    scale_fill_manual(values = mut_colors, na.value = "white", guide = FALSE) +
    scale_x_discrete(position = "top") +
    theme_minimal() +
    theme(
      axis.text.x.top = element_text(angle = 90, vjust = 0.5, size = 11),
      axis.ticks.x = element_blank(),
      axis.text.y.left = element_text(size = 11)
    )

  # output
  return(p)
}



#' index_checker
#'
#' @param x vector of index sequences,
#' @param labels vector, get from x names, the same length of x
#' @param ignore.case bool,
#'
#' @export
#'
index_mut_heatmap <- function(x, labels = NULL) {
  # calculate mutations
  if(! valid_index(x)) {
    stop("input error, [ACGTN] allowed only")
  }

  # calculate
  ma <- index_mutation(x, labels)

  # heatmap
  p <- mut_heatmap(ma)

  # output
  return(p)
}




#'
#' #' get labels
#' #'
#' #'
#' #' @export
#' #'
#' get_labels <- function(x, labels = NULL) {
#'   # could be vector, matrix, data.frame
#'   pre_labels <- c(LETTERS,
#'                   paste(rep(LETTERS, each = length(LETTERS)),
#'                         LETTERS,
#'                         sep = ""))
#'
#'   if(inherits(x, "matrix") | inherits(x, "data.frame")) {
#'     if(is.null(colnames(x))) {
#'       colnames(x) <- pre_labels[1:ncol(x)]
#'     }
#'
#'     if(is.null(rownames(x))) {
#'       rownames(x) <- pre_labels[1:nrow(x)]
#'     }
#'   } else {
#'     if(is.null(names(x))) {
#'       names(x) <- pre_labels[1:length(x)]
#'     }
#'
#'     if(! is.null(labels)) {
#'       warning("labels short than x")
#'       pre_labels <- c(labels, pre_labels)
#'       names(x) <- pre_labels[1:length(x)]
#'     }
#'   }
#'
#'   # ouptut
#'   return(x)
#' }

