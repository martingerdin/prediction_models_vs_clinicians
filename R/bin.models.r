#' Bin models function
#'
#' This function bins model predictions using SupaLarnas gridsearch.breaks function.
#' @param predictions A numeric vector of predicted probabilites. No default.
#' @param outomes A numeric vector of 0 and 1. No default.
#' @param grid All values to be combnd in gridsearch.breaks, i.e. used to find optimal cutpoints. No default.
#' @param n_cores Number of cores to be used in parallel gridsearch. Passed to SupaLarna::gridsearch.breaks. As integer. Defaults to 2 (in gridsearch.breaks)
#' @param return_cps Logical. Function returns model cut_points if TRUE. Defaults to TRUE.
#' @param gridsearch_parallel Logical. If TRUE the gridsearch is performed in parallel. Defaults to FALSE.
#' @param is_sample Logical. If TRUE, only a tenth of possible cut points is searched. Defaults to TRUE.
#' @param maximise Logical. If TRUE, grid search maximizes performance metric. Passed to SupaLarna::gridsearch.breaks. Defaults to TRUE.
#' @export
bin.models <- function(
                       predictions,
                       outcomes,
                       n_cores,
                       grid,
                       return_cps = TRUE,
                       gridsearch_parallel = FALSE,
                       is_sample = TRUE,
                       maximise = FALSE
                       )
{
    ## Grid search cutpoints for model predictions.
    ## Use max and min of predictions in as starting and
    ## end point in grid search.
    cut_points <- SupaLarna::gridsearch.breaks(
                                 predictions,
                                 grid = grid,
                                 outcomes = outcomes,
                                 parallel = gridsearch_parallel,
                                 n_cores = n_cores,
                                 sample = is_sample,
                                 maximise = maximise)
    if (return_cps) results$cut_points_lst[[paste0(max(predictions), "_cut_points")]] <<- cut_points
    ## Define labels for binning
    labels <- c("Green",
                "Yellow",
                "Orange",
                "Red")
    ## Use cut_points to bin predictions
    binned_predictions <- cut(predictions,
                              breaks = c(0,cut_points, Inf),
                              labels = labels,
                              include.lowest = TRUE)

    return (binned_predictions)
}
