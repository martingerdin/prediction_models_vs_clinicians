#' Model GAP
#'
#' This function makes predictions with the GAP model.
#' @param study_data The study data frame. No default.
#' @export
model.GAP <- function(
                      study_data
                      )
{
    ## Define model variables; bind gcs later
    model_variables <- c("age",
                         "sbp")
    ## Define cut points for binning
    cut_points <- list(age = c(0,60,Inf),
                       sbp = c(0,60,120, Inf))
    ## Bin model variables with bin.model.variables
    binned_variables <- bin.model.variables(study_data,
                                            model_variables,
                                            cut_points)
    ## Sum binned_variables to generate gap score
    gap_predictions <- rowSums(cbind(binned_variables,
                                     study_data$gcs))

    return (gap_predictions)
}
