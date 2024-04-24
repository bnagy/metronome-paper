##################
### INITIALIZE ###
##################

library(tidyverse)
library(reticulate)


# !! IMPORTANT !! 
# Some parts of this depends on using metronome from R with Reticulate. You'll need a working environment with Metronome installed. 

### assuming you have your conda env setup somewhere / or use your favorite environment 
use_condaenv("bin/bin/")
### Metronome's package
conda_install(pip = T,packages = "git+https://github.com/bnagy/metronome@main",envname = "bin/bin")
## shorthand for running Metronome with Python
source_python("do_metr.py") 


# Sys.which("python")


# syllable lengths
n_syl <- c(1,2,3,4)
# probabilities to draw a word of length n
p <- c(0.2, 0.6, 0.2,0.05)


#################
### FUNCTIONS ###
#################

## function for inserting character at specific positions in a string
inject <- function(string, index, replacement){
  stringi::stri_sub_replace_all(string, 
                                from = index,
                                to = index-1,
                                replacement = replacement,)
}

## simulate word boundary distributions in line
sim_line <- function(n,p,ll) {
  ## to record the current length of a line
  current_line <- 0
  ## vector that holds sampled word lengths
  wbs <- c()
  
  ## sample word length as long as total line length is smaller than chosen 
  while(current_line < ll) {
    ## sample word once according to word lengths probabilities
    w <- sample(n,size = 1,prob = p)
    
    ## if the current word pushes total length longer than the choice
    if(sum(c(wbs,w)) > ll) {
      ## force the word to be the length just to match the max length of a line
      w <- ll - sum(wbs)
    }
    
    # record word lengths
    wbs <- c(wbs,w)
    # total line length
    current_line <- sum(wbs)
  }
  return(wbs)
}


## make an alexandrine line

m1 <- "wSwSwS"

## to simulate alexandrine line, we simulate to hemi-stichs (both 6 syllables) and combine them together. We use cumulative sum of sampled word lengths to determine the positions of word boundaries that are inserted into a string of "rhythm" (wSwS pattern). As a result, only the word boundary between hemistichs has a truly fixed position.
make_alex_line <- function(i,m1="wSwSwS",
                           m2="wSwSwS") {
  
  
  paste0(
    ## first hemi-stich, take a pattern and determine the word boundary distribution
    inject(m1, 
           index=cumsum(sim_line(n_syl,p,ll=6))+1,
           replacement = "."),
    
    ## second hemi-stich
    inject(m2, index=cumsum(sim_line(n_syl,p,ll=6))+1,
           replacement = ".")
    ) %>% 
    str_replace(".$", "|") ## last word boundary is line break
}


make_alex_line3 <- function(i,m1="wSwSwS",m2="wSwSwS",m3="wSwSwS") {
  
  ## 'broken' Romantic alexandrine consists of three xxxS parts
  
  ## I
  paste0(inject(m1, 
                index=cumsum(sim_line(n_syl,p,ll=4))+1,
                replacement = "."),
  ## II 
  
         inject(m2,
                index=cumsum(sim_line(n_syl,p,ll=4))+1,
                replacement = "."),
  ## III 
         inject(m3,
                index=cumsum(sim_line(n_syl,p,ll=4))+1,
                replacement = ".")) %>%
    
    str_replace(".$", "|")
}

## if the verse is not alexandrine, we don't expect constant caesura and just simulate word boundaries for a full 12-syllable line.
make_line <- function(i,m1) {
  
  inject(m1, 
         index=cumsum(sim_line(n_syl,p,ll=12))+1,
         replacement = ".") %>%
    
    str_replace(".$", "|")
}



########################
### CLUSTERING / ARI ###
########################

iters = 100
res <- vector(length=iters)

for(r in 1:iters) {


### NOT ALEXANDRINE, NOT IAMBIC ###

l <- vector(length=20)

for(i in 1:20) {
  
  ## draw poem length in lines
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 # for each line:
                
                 function(x) {
                  ## 1. sample the metrical pattern
                   m1 <- sample(c("w","S"),
                                size=12,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "")
                   
                   ## 2. inject word boundaries
                   
                   make_line(m1=m1)}) %>%
    
    ## make one string from all lines
    
    paste(collapse="")
}

## save pomes in a tibble

df3 <- tibble(df=paste0("12syl-",rep(1:20)),metronome=l)



###  ALEXANDRINE, NOT IAMBIC ###

l <- vector(mode="character",length=20)

for(i in 1:20) {
  
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 
                 function(x) {
                   
                   m1 <- sample(c("w","S"),
                                size=6,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     stringi::stri_sub_replace(from=6,replacement = "S")
                   
                   m2 <- sample(c("w","S"),
                                size=6,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     ## always strong in the end
                     stringi::stri_sub_replace(from=6,replacement = "S")
                   
                   make_alex_line(m1=m1,m2=m2)
  }) %>%
    paste(collapse="")
}
## save pomes in a tibble
df4 <- tibble(df=paste0("alexFrench-",rep(1:20)),metronome=l)


### BROKEN ALEXANDRINE ### 

l <- vector(mode="character",length=20)

for(i in 1:20) {
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 function(x) {
                   m1 <- sample(c("w","S"),
                                size=4,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     stringi::stri_sub_replace(from=4,replacement = "S")
                   
                   m2 <- sample(c("w","S"),
                                size=4,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     ## always strong in the end
                     stringi::stri_sub_replace(from=4,replacement = "S")
      
      m3 <- sample(c("w","S"),
                   size=4,
                   prob = c(0.6,0.5),
                   replace = T) %>%
        paste(collapse = "") %>%
        ## always strong in the end
        stringi::stri_sub_replace(from=4,replacement = "S")

    make_alex_line3(m1=m1, m2=m2, m3=m3)
  }) %>%
    paste(collapse="")
}

df5 <- tibble(df=paste0("alexBroken-",rep(1:20)),metronome=l)


## combine DFs
sim_df = bind_rows(df3,df4,df5)

## alignment -> distance matrix
dm<-do_metronome(sim_df)  %>% as.matrix()
colnames(dm) <- sim_df$df
rownames(dm) <- sim_df$df

## clustering & cutting tree
cl <- hclust(dm %>% as.dist(),
             method = "ward.D2") %>%
  cutree(k=3)

## calculate ARI and write down
res[r] <- mclust::adjustedRandIndex(cl,str_extract(names(cl), "^.*?-"))
}

## ARI
summary(res)


###########################
### JOINT DATA FOR PLOT ###
###########################


l <- vector(mode="character",length=20)
m1s="wSwSwS"

set.seed(1989)

### ALEXANDRINE, IAMBIC ####

for(i in 1:20) {
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 make_alex_line,
                 m1=m1s) %>%
    paste(collapse="")
}

df <- tibble(df=paste0("alex-",rep(1:20)),metronome=l)


l <- vector(mode="character",length=20)
m1="wSwSwS"

set.seed(1977)

### NOT ALEXANDRINE, IAMBIC ###

for(i in 1:20) {
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 make_line,
                 m1=paste0(m1,m1)) %>%
    paste(collapse="")
}

df2 <- tibble(df=paste0("iamb6-",rep(1:20)),metronome=l)


### NOT ALEXANDRINE, NOT IAMBIC ####

l <- vector(mode="character",length=20)

set.seed(1888)

for(i in 1:20) {
  
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 function(x) {
                   
                   m1 <- sample(c("w","S"),
                                size=12,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "")
    make_line(m1=m1)}) %>%
    paste(collapse="")
}

df3 <- tibble(df=paste0("12syl-",rep(1:20)),metronome=l)



### NOT ALEXANDRINE, NOT IAMBIC ####

l <- vector(mode="character",length=20)

set.seed(1861)

for(i in 1:20) {
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 function(x) {
                   
                   m1 <- sample(c("w","S"),
                                size=6,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
      stringi::stri_sub_replace(from=6,
                                replacement = "S")
                   
                   m2 <- sample(c("w","S"),
                                size=6,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     stringi::stri_sub_replace(from=6,replacement = "S")
                   
                   make_alex_line(m1=m1,m2=m2)
  }) %>%
    paste(collapse="")
}

df4 <- tibble(df=paste0("alexFrench-",rep(1:20)),metronome=l)



###  BROKEN ALEXANDRINE ### 

l <- vector(mode="character",length=20)

set.seed(1991)

for(i in 1:20) {
  l[i] <- sapply(1:rpois(1,lambda = 14),
                 function(x) {
                   
                   m1 <- sample(c("w","S"),
                                size=4,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     ## always strong in the end
                     stringi::stri_sub_replace(from=4,replacement = "S")
                   
                   m2 <- sample(c("w","S"),
                                size=4,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     paste(collapse = "") %>%
                     stringi::stri_sub_replace(from=4,replacement = "S")
                   
                   m3 <- sample(c("w","S"),
                                size=4,
                                prob = c(0.6,0.5),
                                replace = T) %>%
                     
                     paste(collapse = "") %>%
                     stringi::stri_sub_replace(from=4,replacement = "S")
    
    make_alex_line3(m1=m1, m2=m2, m3=m3)
  }) %>%
    paste(collapse="")
}

df5 <- tibble(df=paste0("alexRomantic-",rep(1:20)),metronome=l)

## bind all

sim_df <- df %>% 
  bind_rows(df2,df3,df4,df5)

sim_df %>%
  write_tsv("../sim_alexandrines_metronome.tsv")


############ SESSION INFO ##############
 

# R version 4.3.0 (2023-04-21)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Linux Mint 20.1
# 
# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
# LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0
# 
# locale:
#  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
#  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=pl_PL.UTF-8    LC_MESSAGES=en_US.UTF-8   
#  [7] LC_PAPER=pl_PL.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
# [10] LC_TELEPHONE=C             LC_MEASUREMENT=pl_PL.UTF-8 LC_IDENTIFICATION=C       
# 
# time zone: Europe/Warsaw
# tzcode source: system (glibc)
# 
# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#  [1] reticulate_1.34.0 lubridate_1.9.3   forcats_1.0.0     stringr_1.5.0     dplyr_1.1.3      
#  [6] purrr_1.0.2       readr_2.1.4       tidyr_1.3.0       tibble_3.2.1      ggplot2_3.4.4    
# [11] tidyverse_2.0.0   tidytext_0.4.1   
# 
# loaded via a namespace (and not attached):
#  [1] tidyselect_1.2.0    fastmap_1.1.1       janeaustenr_1.0.0   promises_1.2.1     
#  [5] digest_0.6.33       timechange_0.2.0    mime_0.12           lifecycle_1.0.3    
#  [9] ellipsis_0.3.2      tokenizers_0.3.0    processx_3.8.2      magrittr_2.0.3     
# [13] compiler_4.3.0      rlang_1.1.1         tools_4.3.0         utf8_1.2.4         
# [17] yaml_2.3.7          data.table_1.14.8   knitr_1.44          prettyunits_1.2.0  
# [21] htmlwidgets_1.6.2   bit_4.0.5           pkgbuild_1.4.2      mclust_6.0.0       
# [25] here_1.0.1          pkgload_1.3.3       miniUI_0.1.1.1      withr_2.5.1        
# [29] grid_4.3.0          fansi_1.0.5         urlchecker_1.0.1    profvis_0.3.8      
# [33] xtable_1.8-4        colorspace_2.1-0    scales_1.2.1        cli_3.6.1          
# [37] rmarkdown_2.25      crayon_1.5.2        generics_0.1.3      remotes_2.4.2.1    
# [41] rstudioapi_0.15.0   tzdb_0.4.0          sessioninfo_1.2.2   ape_5.7-1          
# [45] cachem_1.0.8        parallel_4.3.0      vctrs_0.6.4         devtools_2.4.5     
# [49] Matrix_1.5-1        jsonlite_1.8.7      callr_3.7.3         hms_1.1.3          
# [53] bit64_4.0.5         lgr_0.4.4           glue_1.6.2          ps_1.7.5           
# [57] stringi_1.7.12      gtable_0.3.4        later_1.3.1         munsell_0.5.0      
# [61] mlapi_0.1.1         pillar_1.9.0        rappdirs_0.3.3      htmltools_0.5.6.1  
# [65] float_0.3-1         rsparse_0.5.1       R6_2.5.1            rprojroot_2.0.3    
# [69] vroom_1.6.3         evaluate_0.22       shiny_1.7.4         lattice_0.22-5     
# [73] png_0.1-8           SnowballC_0.7.1     RhpcBLASctl_0.23-42 memoise_2.0.1      
# [77] httpuv_1.6.12       text2vec_0.6.3      Rcpp_1.0.11         nlme_3.1-163       
# [81] xfun_0.40           fs_1.6.3            usethis_2.1.6       pkgconfig_2.0.3
