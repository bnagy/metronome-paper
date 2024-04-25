library(tidytext)
library(tidyverse)

#################
### FUNCTIONS ###
#################


## helper function to distinguish verse groups in .csv
verse_groups <- function(x,iter=i) {
  if(nchar(x)>0) {
    return(i)
  } else {
    i<<-i+1
    return(NA)
  }
} 

## function to process files
process_re_samples <- function(x) {
  print(x)
  ## read table
  df<-read.table(x,
                 sep = ";",
                 quote = "\"",
                 col.names = c("text","metronome")) %>%
    tibble() %>%
    mutate(file=str_replace(x,".*//(.*?)\\.csv", "\\1"))
  
  ## reset global variable
  i<<-1
  df<-df %>% mutate(text_group=sapply(df$text,verse_groups)) %>% filter(!is.na(text_group))
}

### extract inter-stress intervals for rhythm regularity calculation as in Šeļa & Gronas 2022

extract_intervals <- function(binary_df,
                              no_anacrusis=F,
                              no_clausula=T,
                              binary_string="metronome",
                              document="id") {
  
  
  binary_df <- binary_df %>%
    mutate(intervals = !! sym(binary_string))
  
  # drop preceding unstressed syllables
  if(no_anacrusis) {
    binary_df <- binary_df %>%
      mutate(intervals = str_remove(!! sym(binary_string), "^0*"))
  }
  
  # drop postceding unstressed syllables
  if(no_clausula) {
    binary_df <- binary_df %>%
      mutate(intervals = str_remove(!! sym(binary_string), "w*?(?=\\|)"), intervals = str_remove(intervals, "w*?$"))
  }
  
  
  intervals_unnested <- binary_df %>%
    mutate(no_stress = str_extract_all(intervals, "w{1,15}|(SS)")) %>%
    group_by(!! sym(document)) %>%
    unnest(no_stress)
  
  return(intervals_unnested)
  
}



#########################
### PROCESSSING FILES ###
#########################

## list files
f <- list.files(full.names = T,path="RenaissanceWB/")

## apply process function to each path
ren_df<-lapply(f,process_re_samples)


## transform Mirella's annotation to metronome
ren_meter <- ren_df %>% 
  bind_rows() %>%
  mutate(metronome = str_replace_all(metronome,"._1", "1"), # stressed synalephas
         metronome = str_remove_all(metronome,"_."), # other synalephas
         metronome=str_remove_all(metronome, "\\s"), # spaces
         metronome=str_replace(metronome,"([x,X]*?[w,W]$)|([x,X]$)", "|"), # end of line
         metronome=str_replace_all(metronome,"W", "\\."), # word boundaries
         metronome=str_replace(metronome, "^x", "0"), # initial "x" to "O"
         metronome=str_replace(metronome, "x", ""), # remove other "x"s
         metronome=str_replace_all(metronome, "0", "w"), # 0 to "w"
         metronome=str_replace_all(metronome,"1", "S"), # "1" to "S"
         metronome=str_replace_all(metronome,"\\.{2,5}", "."), # fix word boundaries
         metronome=ifelse(str_detect(metronome,"\\|"), metronome, paste0(metronome, "|"))) # fix end of line

###  sanity check for line-lengths
check_lengths <- ren_meter %>% 
   group_by(file) %>% 
  mutate(count=lengths(str_extract_all(metronome, "(S)|(w)"))) %>% 
  count(as.factor(count))

### one metronome string representation of samples 
ren_meter_all <- ren_meter %>% 
  select(-text) %>% 
  group_by(file) %>% 
  summarize(metronome=paste(metronome, collapse=""))

### regularity calculation
reg<-extract_intervals(ren_meter_all,document="file") %>%
  group_by(file) %>% 
  count(no_stress) %>% 
  mutate(n=n/sum(n)) %>%
  summarize(regularity=sum(log(n)*n))

### join tables
ren_meter_all <- ren_meter_all %>% left_join(reg,by="file") 


## fix labels and save
ren_meter_all %>%
  mutate(file=c("Venetian_AndreaCalmo",
                "Catalan_AusiasMarch",
                "Portugese_Camoes",
                "Napolitan_Cortese",
                "French_DuBellay",
                "Spanish_deLaTorre",
                "Occitan_Gaucelm",
                "ItalianSicily_daLentini",
                "Frisian_Japics",
                "German_Opitz",
                "French_Peletier",
                "Italian_Petrarca",
                "English_Shakespeare",
                "ItalianNapolitan_Tansillo",
                "Napolitan_Velardiniello",
                "Occitan_Ventadorn",
                "Dutch_Vondel")) %>%
  select(label=file,regularity,metronome) %>% 
  write_tsv(file="../renaissance_metronome.tsv")


################ SESSION INFO #################

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
#  [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.0   dplyr_1.1.3     purrr_1.0.2    
#  [6] readr_2.1.4     tidyr_1.3.0     tibble_3.2.1    ggplot2_3.4.4   tidyverse_2.0.0
# [11] tidytext_0.4.1 
# 
# loaded via a namespace (and not attached):
#  [1] tidyselect_1.2.0    fastmap_1.1.1       janeaustenr_1.0.0   promises_1.2.1     
#  [5] digest_0.6.33       timechange_0.2.0    mime_0.12           lifecycle_1.0.3    
#  [9] ellipsis_0.3.2      tokenizers_0.3.0    processx_3.8.2      magrittr_2.0.3     
# [13] compiler_4.3.0      rlang_1.1.1         tools_4.3.0         utf8_1.2.4         
# [17] yaml_2.3.7          data.table_1.14.8   knitr_1.44          prettyunits_1.2.0  
# [21] htmlwidgets_1.6.2   bit_4.0.5           pkgbuild_1.4.2      mclust_6.0.0       
# [25] pkgload_1.3.3       miniUI_0.1.1.1      withr_2.5.1         grid_4.3.0         
# [29] fansi_1.0.5         urlchecker_1.0.1    profvis_0.3.8       xtable_1.8-4       
# [33] colorspace_2.1-0    scales_1.2.1        cli_3.6.1           rmarkdown_2.25     
# [37] crayon_1.5.2        generics_0.1.3      remotes_2.4.2.1     rstudioapi_0.15.0  
# [41] tzdb_0.4.0          sessioninfo_1.2.2   ape_5.7-1           cachem_1.0.8       
# [45] parallel_4.3.0      vctrs_0.6.4         devtools_2.4.5      Matrix_1.5-1       
# [49] callr_3.7.3         hms_1.1.3           bit64_4.0.5         lgr_0.4.4          
# [53] glue_1.6.2          ps_1.7.5            stringi_1.7.12      gtable_0.3.4       
# [57] later_1.3.1         munsell_0.5.0       mlapi_0.1.1         pillar_1.9.0       
# [61] htmltools_0.5.6.1   float_0.3-1         rsparse_0.5.1       R6_2.5.1           
# [65] vroom_1.6.3         evaluate_0.22       shiny_1.7.4         lattice_0.22-5     
# [69] SnowballC_0.7.1     RhpcBLASctl_0.23-42 memoise_2.0.1       httpuv_1.6.12      
# [73] text2vec_0.6.3      Rcpp_1.0.11         nlme_3.1-163        xfun_0.40          
# [77] fs_1.6.3            usethis_2.1.6       pkgconfig_2.0.3   
