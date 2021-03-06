#' ---
#' title: "Regression and Other Stories: KidIQ cross-validation"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' Linear regression and leave-one-out cross-validation.
#' 
#' -------------
#' 

#' **Load packages**
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library("rprojroot")
root<-has_dirname("RAOS-Examples")$make_fix_file()
library("rstanarm")
options(mc.cores = parallel::detectCores())
library("loo")
library("foreign")

#' **Load children's test scores data**
kidiq <- read.dta(file=root("KidIQ/data","kidiq.dta"))

#' **Linear regression**
#+ results='hide'
fit_3 <- stan_glm(kid_score ~ mom_hs + mom_iq, data=kidiq, seed=1507)
#+
print(fit_3)

#' **Estimate the predictive performance of a model using
#' within-sample plug-in (ie with mean parameters) log-score**
pluginlogscore_3 <- sum(dnorm(kidiq$kid_score, fitted(fit_3), sigma(fit_3), log = TRUE))
round(pluginlogscore_3, 1)

#' **Estimate the predictive performance of a model using
#' within-sample posterior predictive (ie integrating over parameters) log-score**
sigmas <- as.matrix(fit_3)[,'sigma']
preds <- posterior_linpred(fit_3)
nsims <- nrow(preds)
logscore_3 <- sum(log(rowMeans(sapply(1:nsims, FUN = function(i) dnorm(kidiq$kid_score, preds[i,], sigmas[i], log=FALSE)))))
round(logscore_3, 1)

#' **Add five pure noise predictors to the data
set.seed(1507)
n <- nrow(kidiq)
kidiqr <- kidiq
kidiqr$noise <- array(rnorm(5*n), c(n,5))

#' **Linear regression with additional noise predictors**
#+ results='hide'
fit_3n <- stan_glm(kid_score ~ mom_hs + mom_iq + noise, data=kidiqr, seed=1507)
#+
print(fit_3n)

#' **Estimate the predictive performance of a model using
#' within-sample plug-in (ie with mean parameters) log-score**
pluginlogscore_3n <- sum(dnorm(kidiq$kid_score, fitted(fit_3n), sigma(fit_3n), log = TRUE))
round(pluginlogscore_3n, 1)

#' **Estimate the predictive performance of a model using
#' within-sample posterior predictive (ie integrating over parameters) log-score**
sigmas <- as.matrix(fit_3n)[,'sigma']
preds <- posterior_linpred(fit_3n)
logscore_3n <- sum(log(rowMeans(sapply(1:nsims, FUN = function(i) dnorm(kidiq$kid_score, preds[i,], sigmas[i], log=FALSE)))))
round(logscore_3n, 1)

#' **Compare models with within-sample plug-in log scores**
round(pluginlogscore_3n - pluginlogscore_3, 1)

#' **Compare models with within-sample posterior predictive log scores**
round(logscore_3n - logscore_3, 1)

#' ### Compare models with LOO-CV
#' 

#' ### Estimate the predictive performance of models using LOO-CV
loo_3 <- loo(fit_3)
print(loo_3)
loo_3n <- loo(fit_3n)
print(loo_3n)
compare_models(loo_3, loo_3n)

#' **Linear regression with different predictors**
#+ results='hide'
fit_1 <- stan_glm(kid_score ~ mom_hs, data=kidiq)
#+
loo_1 <- loo(fit_1)
print(loo_1)
compare_models(loo_3, loo_1)

#' **Linear regression with interaction**
#+ results='hide'
fit_4 <- stan_glm(kid_score ~ mom_hs + mom_iq + mom_iq:mom_hs,
                  data=kidiq, seed=1507)
#+
print(fit_4)
loo_4 <- loo(fit_4)
print(loo_4)
compare_models(loo_3, loo_4)

#' **Linear regression with log-transformation and interaction**
#+ results='hide'
fit_5 <- stan_glm(kid_score ~ mom_hs + log(mom_iq) + log(mom_iq):mom_hs,
                  data=kidiq, seed=1507)
#+
print(fit_5)
loo_5 <- loo(fit_5)
print(loo_5)
compare_models(loo_3, loo_5)
