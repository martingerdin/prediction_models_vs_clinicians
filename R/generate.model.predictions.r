#' Generate model predictions function
#'
#' This function bins model predictions and converts them from character labels to numeric labels.
#' @param study_data The study data frame. No default
#' @param model_names Character vector of names of models. Defaults to c("RTS","GAP","KTS","gerdin")
#' @param n_cores Number of cores to be used in parallel gridsearch. Passed to bin.models (which, in turn, passes to SupaLarna::gridsearch.breaks). As integer. Defaults to 2 (in gridsearch.breaks)
#' @param return_cps Logical. Function returns model cut_points if TRUE. Passed to bin.models. Defaults to TRUE.
#' @param log Logical. If TRUE progress is logged in logfile. Defaults to FALSE.
#' @param boot Logical. Affects only what is printed to logfile. If TRUE prepped_sample is assumed to be a bootstrap sample. Defaults to FALSE.
#' @param write_to_disk Logical. If TRUE the prediction data is saved as RDS to disk. Defaults to FALSE.
#' @param clean_start Logical. If TRUE the predictions directory and all files in it are removed before saving new stuff there. Defaults to FALSE.
#' @param gridsearch_parallel Logical. Passed to bin.models (which, in turn, passes to SupaLarnas gridsearch.breaks). If TRUE the gridsearch is performed in parallel. Defaults to FALSE.
#' @export
generate.model.predictions <- function(
                                       study_data,
                                       model_names = c("RTS",
                                                       "GAP",
                                                       "KTS",
                                                       "gerdin"),
                                       n_cores,
                                       return_cps = TRUE,
                                       log = FALSE,
                                       boot = FALSE,
                                       write_to_disk = FALSE,
                                       clean_start = FALSE,
                                       gridsearch_parallel = TRUE
                                       )
{
    ## Define dir_name for write_to_disk
    dir_name <- "predictions"
    ## List modelling functions names and the spacing used in grid search
    preds_list <- list(modelling_names = unlist(lapply(model_names,
                                                       function(name) paste0("model.",
                                                                             name))))
    ## Generate predictions with models
    preds <- lapply(setNames(preds_list$modelling_names, nm = model_names),
                    function(func_name)
                    {
                        fun <- get(func_name) # Get function from string
                        fun(study_data)       # Make predictions on study_data
                    }
                    )
    ## Extract outcome from study_data; Then, coerce to numeric
    outcome <- study_data$s30d; levels(outcome) <- c("0","1")
    outcome <- as.numeric(as.character(outcome))
    ## Bin model predictions
    binned_preds <- lapply(setNames(model_names, nm = model_names),
                           function(model_name) bin.models(preds[[model_name]],
                                                           outcomes = outcome,
                                                           n_cores = n_cores,
                                                           return_cps = return_cps,
                                                           gridsearch_parallel = gridsearch_parallel))
    ## Convert to numeric preds
    binned_to_ints <- lapply(binned_preds,
                             function(pred) {
                                 levels(pred) <- c("1","2","3","4")
                                 as.numeric(as.character(pred))
                             }
                             )
    ## Define names of list elements for continous predictions
    names(preds) <- unlist(lapply(model_names,
                                  function(name) paste0(name, "_con")))
    ## Define names list elements of binned_predictions
    names(binned_to_ints) <- unlist(lapply(model_names,
                                           function(name) paste0(name, "_cut")))
    ## Define pred_data
    pred_data <- c(preds,
                   binned_to_ints)
    ## Bind outcome_cut and outcome_con (for plots) as well as tc to pred_data
    pred_data$outcome <- outcome
    pred_data$tc <- as.numeric(study_data$tc)
    ## Define timestamp
    timestamp <- Sys.time()
    file_name <- ""
    ## Write each prediction to disk
    if (write_to_disk) {
        if (!dir.exists(dir_name)) dir.create(dir_name)
        filenum <- as.character(round(as.numeric(timestamp)*1000))
        file_name_ext <- "main"
        if (boot) file_name_ext <- "boot"
        file_name <- paste0(dir_name, "/model_predictions_", file_name_ext, "_", filenum, ".rds")
        saveRDS(pred_data, file_name)
        file_name <- paste0("saved in ", file_name, " ")
    }
    ## Log
    if (log) {
        analysis_name <- "Main"
        if (boot) analysis_name <- "Bootstrap"
        logline <- paste0(analysis_name, " analysis ", file_name, "completed on ", timestamp)
        append <- ifelse(clean_start, FALSE, TRUE)
        write(logline, "logfile", append = append)
    }
    ## Return pred_data and cut_points
    return (pred_data)
}

