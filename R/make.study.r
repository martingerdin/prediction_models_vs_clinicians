#' Make study function
#'
#' See title. 
#' @param data_path String. The path to the data file. Defaults to "./extdata/test_sample.csv".
#' @param bootstrap_samples Integer. The number of bootstrap samples to be generated. Defaults to 3.
#' @param test Logical. If True, the analysis is conducted on a test sample. Defaults to TRUE.
#' @export 

make.study <- function(data_path = "./extdata/test_sample.csv",
                       bootstrap_samples = 3, test = TRUE){
    ## Error handling
    if (!(is.character(data_path) && length(data_path) == 1)) stop("The data_path has to be a string.")
    if (!(bootstrap_samples%%1 == 0) | !is.numeric(bootstrap_samples)) stop("Number of bootstrap samples must be integer.")
#    if (!(is.logical(test))) stop("Variable test has to be of type logical.")
#    files <- list.files("./R", pattern = ".r$", full.names = TRUE) # List files
#    files <- files[! files %in% "make.study.r"] # Remove make.study function from files vector
#    for (f in files) source(f)
#    study_data <- read.csv(data_path, stringsAsFactors = FALSE)
#    ## Get data dictionary
#    data_dictionary <- SupaLarna::get.data.dictionary()
#    if (!test) data_dictionary$seqn <- NULL
#    ## Keep relevant variables
#    study_data <- SupaLarna::keep.relevant.variables(study_data,
#                                                     data_dictionary = data_dictionary)
#    ## Define 999 as missing
#    study_data[study_data == 999] <- NA
#    ## Prepare study_data using the data dictionary, i.e
#    ## transform variables to factors
#    study_data <- SupaLarna::prepare.study.data(study_data,
#                                                data_dictionary)
#    ## Coerce avpu, mgcs, egcs and vgcs to numeric
#    study_data <- coerce.factor.to.numeric(study_data)
#    ## Merge gcs components to single gcs
#    study_data$gcs <- with(study_data, egcs + mgcs + vgcs)
#    ## ## Set patients to dead if dead at discharge or at 24 hours
#    ## and alive if coded alive and admitted to other hospital
#    study_data <- SupaLarna::set.to.outcome(study_data)
#    ## Collapse mechanism of injury
#    study_data <- SupaLarna::collapse.moi(study_data)
#    ## Set study_data, i.e. remove patients arriving prior to one month
#    ## before the dataset were created, remove patients before 2016-07-28
#    ## when hospital collected tc. Also, complete dataset for analysis and
#    ## "all" tbl for tbl one. Then split dataset for analysis into training and test set.
#    cc_and_all <- set.data(study_data)
#    all <- cc_and_all$all # Extract data for table
#    prepped_sample <- cc_and_all$cc_dfs # Extract data for analysis
#    str(results)
#    ## Define flowchart main node text
#    node_text <- c("patients were enrolled for this study",
#                   "patients did inform consent",
#                   "patients had complete data",
#                   "patients total were included when study size criteria had been met")
#    ## Define flowchart exclusion node text
#    exclusion_text <- c("patients did not inform consent",
#                        "patients had missing information",
#                        "patients were excluded when study size criteria had been met")
#    ## Generate flow vec
#    flow_vec <- generate.flowchart.vec(
#        results = results$n_s,
#        node_text = node_text,
#        exclusion_text = exclusion_text,
#        results_lst = results)
#    ## Generate table of sample characteristics and save to disk
#    tables <- generate.tbl.one(all, data_dictionary)
#    ## Append tables to results
#    results$tables <- tables
#    ## Extract descriptive characteristics from raw table using the prepped sample
#    ## append to results
#    extract.additional.characteristics(study_data = prepped_sample$train,
#                                       raw_table = tables$raw,
#                                       strata_labels = c("Survivors", "Non-Survivors"),
#                                       results_list = results)
#    ## Generate sample characterstics table (to be inserted)
#    ## Define model_names
#    model_names <- c("RTS",
#                     "GAP",
#                     "KTS",
#                     "gerdin")
#    ## Define pretty model names
#    pretty_model_names <- c("RTS",
#                            "GAP",
#                            "KTS",
#                            "Gerdin et al.")
#    ## Generate table1, i.e. table reporting variables included in the models.
#    generate.variables.table(col_names = pretty_model_names)
#    ## Define suffixes to be added to model names
#    suffixes <- c("_CUT", "_CON")
#    ## Define clinicians labels for regular and pretty names
#    clinicians_names <- c("tc", "Clinicians")
#    ## Create names lst
#    lst_w_names <- setNames(list(model_names, pretty_model_names),
#                            nm = c("names", "pretty_names"))
#    ## Paste suffixes to names, and bind triage category
#    names_lst <- lapply(setNames(seq_along(lst_w_names), nm = names(lst_w_names)),
#                        function (model_lst, names, i){
#                            ## Paste suffixes to both pretty and non-pretty model
#                            ## names
#                            lst <- lapply(suffixes, function(suffix){
#                                paste0(model_lst[[i]], suffix)
#                            })
#                            ## Unlist to vector and bind tc to models
#                            new_names <- c(unlist(lst), clinicians_names[i])
#                            return (new_names)
#                        }, model_lst = lst_w_names, names = names(lst_w_names))
#    ## Initialize cut_points_lst
#    results$cut_points_lst <- list()
#    ## Generate model predictions
#    predictions <- generate.model.predictions(prepped_sample,
#                                              n_cores = 4,
#                                              write_to_disk = TRUE,
#                                              gridsearch_parallel = TRUE,
#                                              clean_start = TRUE,
#                                              return_cps = TRUE)
#    ## Rename cut_points according to model_names
#    names(results$cut_points_lst) <- pretty_model_names
#    ## Generate cut_points table and save to disk
#    cut_points_table <- generate.cut.points.table(cut_points = results$cut_points_lst)
#    ## Generate boostrap samples
#    samples <- SupaLarna::generate.bootstrap.samples(study_data,
#                                                     boostrap_samples = 3)
#    ## Prepare each sample for analysis
#    samples <- lapply(samples, set.data, return_all = FALSE)
#    ## Prepare each sample
#    ## Generate predictions on bootstrap samples
#    bootstrap_predictions <- SupaLarna::generate.predictions.bssamples(
#                                            samples,
#                                            prediction_func = "generate.model.predictions",
#                                            parallel = TRUE,
#                                            n_cores = 4,
#                                            log = TRUE,
#                                            boot = TRUE,
#                                            write_to_disk = TRUE)
#    ## List for ci for each model
#    AUC_ci <- list(models = names_lst$names,
#                   ci_type = "ci",
#                   analysis_type = "AUC",
#                   un_list = TRUE)
#    ## List for model clinician comparison
#    AUC_diff <- list(models = setNames(lapply(names_lst$names, function(model_name) c(model_name, "tc")),
#                                       nm = names_lst$names),
#                     ci_type = "diff",
#                     analysis_type = "AUC",
#                     un_list = FALSE)
#    ## List for cat con model comparison
#    model_model_pairs <- lapply(model_names, function(model_name){
#        pair <- grep(model_name,
#                     names_lst$names,
#                     value = TRUE)
#        return (pair)
#    })
#    model_model_pairs <- setNames(c(model_model_pairs,
#                                    lapply(model_model_pairs, rev),
#                                    list(rep("tc", 2))),
#                                  nm = names_lst$names)
#    ## Listify
#    AUC_diff_cat_con <- list(models = model_model_pairs,
#                             ci_type = "diff",
#                             analysis_type = "AUC",
#                             un_list = FALSE)
#    ## List together
#    AUC_together <- setNames(list(AUC_ci, AUC_diff, AUC_diff_cat_con),
#                             nm = c("AUROCC and corresponding CI (95 \\%)",
#                                    "Model-clincian AUROCC difference (95\\% CI)",
#                                    "Model-model AUROCC difference (95\\% CI)"))
#    ## Intialize analysis list
#    analysis_lst <- list()
#    ## Generate confidence intervals for diff types
#    analysis_lst$AUROCC <- lapply(AUC_together, function (AUC_lst){
#        cis <- lapply(AUC_lst$models, function (model_or_pair,
#                                                models_to_invert) {
#            SupaLarna::generate.confidence.intervals.v2(
#                           predictions,
#                           model_names = model_or_pair,
#                           the_func = SupaLarna::model.review.with.rocr,
#                           samples = bootstrap_predictions,
#                           diffci_or_ci = AUC_lst$ci_type,
#                           outcome_name = "s30d",
#                           digits = 3,
#                           measure = "auc",
#                           models_to_invert = models_to_invert)
#        }, models_to_invert = names_lst$names[!grepl("gerdin|tc", names_lst$names)])
#        ## To prevent list of lists
#        if (AUC_lst$un_list == TRUE) cis <- unlist(cis, recursive = FALSE)
#        return (cis)
#    })
#    ## Generate confidence intervals for reclassification estimates
#    analysis_lst$reclassification <- SupaLarna::generate.confidence.intervals.v2(
#                                                    predictions,
#                                                    model_names = grep("_CUT",
#                                                                       names_lst$names,
#                                                                       value = TRUE),
#                                                    the_func = SupaLarna::model.review.reclassification,
#                                                    samples = bootstrap_predictions,
#                                                    diffci_or_ci = "ci",
#                                                    outcome_name = "s30d",
#                                                    digits = 3,
#                                                    models_to_invert = names_lst$names[!grepl("gerdin|tc|_CON", names_lst$names)])
#    ## Append analysis list to results
#    results$Analysis <- analysis_lst
#    ## Initialize lists for table data
#    auc_table <- list(table_data = t(do.call(rbind,
#                                             lapply(analysis_lst$AUROCC,
#                                                    generate.estimate.table,
#                                                    pretty_names = names_lst$pretty_names))),
#                      label = "auc",
#                      caption = "AUROCC estimates, as well as model-model and model-clinician AUROCC difference, with corresponding CI (95 \\%).",
#                      file_name = "auc_estimates_table.tex",
#                      san_col = function (word) {word},
#                      san_row = function (word) {word},
#                      table_notes = "The model-model comparison reffered is the AUROCC difference of, for example, RTS\\textsubscript{cut} and RTS\\textsubscript{CON}",
#                      star_caption = "Model-model")
#    reclassification_table <- list(table_data = generate.estimate.table(
#                                       lapply(setNames(nm = names(analysis_lst$reclassification)),
#                                              function(model_nm){
#                                        # Extract the model reclass estimates
#                                                  model_tbl <- analysis_lst$reclassification[[model_nm]]
#                                        # Keep only NRI+ and NRI-
#                                                  model_tbl <- model_tbl[c("NRI+",
#                                                                           "NRI-"), ]
#                                                  return (model_tbl)}
#                                              ),
#                                       pretty_names = names_lst$pretty_names[grep("_CUT", names_lst$pretty_names)],
#                                       man_estimate_labels = c("NRI+",
#                                                               "NRI-")),
#                                   label = "reclassification",
#                                   caption = "NRI+ and NRI- estimates with corresponding CI (95 \\%)",
#                                   file_name = "reclassification_estimates_table.tex",
#                                   san_col = function (word) {word},
#                                   san_row = NULL,
#                                   table_notes = "Positive values indicate the model categorisation to be superior to that of clinicians, and negative values vice versa.",
#                                   star_caption = "NRI")
#    ## Add tables
#    table_lst <- list(auc_table = auc_table,
#                      reclassification_table = reclassification_table)
#    ## Save results tables
#    for (lst in table_lst){
#        with(lst, make.and.save.xtable(table_data = table_data,
#                                       caption = caption,
#                                       label = label,
#                                       file_name = file_name,
#                                       san_col = san_col,
#                                       san_row = san_row,
#                                       table_notes = table_notes,
#                                       star_caption = star_caption))
#    }
#    ## Save estimate tables to results
#    results$estimate_tables <- table_lst
#    ## Save results to disk
#    saveRDS(results, file = "results.rds")
#    ## Save plots to disk
#    ## ROC-curves
#    SupaLarna::create.ROCR.plots.v2(
#                   study_sample = predictions,
#                   outcome_name = "s30d",
#                   split_var = "CON",
#                   train_test = FALSE,
#                   ROC_or_precrec = "ROC",
#                   device = "pdf",
#                   models = names_lst$names,
#                   pretty_names = names_lst$pretty_names,
#                   subscript = TRUE,
#                   models_to_invert = names_lst$names[!grepl("gerdin|tc", names_lst$names)])
}
