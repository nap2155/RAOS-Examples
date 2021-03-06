#' ---
#' title: "Regression and Other Stories: Interactions"
#' author: "Andrew Gelman, Jennifer Hill, Aki Vehtari"
#' date: "`r format(Sys.Date())`"
#' ---

#' Plot interaction example figure
#' 
#' -------------
#' 

#+ include=FALSE
# switch this to TRUE to save figures in separate files
savefigs <- FALSE

#' **Load packages**
#+ setup, message=FALSE, error=FALSE, warning=FALSE
library("rprojroot")
root<-has_dirname("RAOS-Examples")$make_fix_file()

#' **Plot interaction example figure**
#+ eval=FALSE, include=FALSE
if (savefigs) pdf(root("Interactions/figs","interactions_male.pdf"), height=4, width=6)
#+
par(mar=c(3,3,2,1), mgp=c(1.7,.5,0), tck=-.01)
plot(c(0,12.5),c(0,.25), type="n", xaxs="i", yaxs="i",
  xlab="Home radon exposure (pCi/L)", ylab="Probability of lung cancer", bty="l", main="Example of an interaction") 
lines(c(0,20),.07409+c(0,20)*.0134)
lines(c(0,20),.00579+c(0,20)*.0026)
text(10, .07409+10*.0134 - .02, "Smokers")
text(10, .00579+10*.0026 + .01, "Nonsmokers")
#+ eval=FALSE, include=FALSE
if (savefigs) dev.off()
