reorder_chr <- function(df, column_name) {
# Reorder the chr column in a data frame
# @arg1 The name of the data frame
# @arg2 The name of the CHR column
    if(!column_name %in% colnames(df)) {
        stop("column name not found in dataframe!")
    }
    if(!length(df[column_name])) {
        stop("empty column name for chromosome column!")
    }
    df[column_name] <- factor(df[, column_name],
                              levels = c("1", "2", "3", "4", "5", "6",
                                         "7", "8", "9", "10", "11", "12",
                                         "13", "14", "15", "16", "17", "18",
                                         "19", "20", "21", "22", "X", "Y", "MT"))
    df
}


