install.packages("rscopus")
install.packages("tidyverse")
library(rscopus)
library(tidyverse)

dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
dir.create("papers/", recursive=TRUE)
dir.create("affils/", recursive=TRUE)
dir.create("authors/", recursive=TRUE)



  search_term<-c('60017252')
  
    
    yr1=2019
    yr2=2025
    
    date_range <- seq(yr1,yr2)
    year <- seq_along(date_range)
    term <- seq_along(search_term)
    
    for (h in term){
      
      for (j in year) {
        
        # a<-paste("(AF-ID('",search_term[h],"') AND (DOCTYPE(ar) OR DOCTYPE(re) OR DOCTYPE(ch) OR DOCTYPE(ed) OR DOCTYPE(le) OR DOCTYPE(dp) OR DOCTYPE(no))",sep="")
        a<-paste("(AF-ID('",search_term[h],"')"," AND (DOCTYPE(ar) OR DOCTYPE(re) OR DOCTYPE(ch) OR DOCTYPE(ed) OR DOCTYPE(le) OR DOCTYPE(dp) OR DOCTYPE(no))",sep="")
        # a<-paste("((AFFIL(",search_term[h],")"," AND AFFILCOUNTRY('united states')) AND (DOCTYPE(ar) OR DOCTYPE(re) OR DOCTYPE(ch) OR DOCTYPE(ed) OR DOCTYPE(le) OR DOCTYPE(dp) OR DOCTYPE(no))",sep="")
        
        # c <- " AND PUBYEAR > 2018"
        # query_string <-paste0(a, c,")",sep = "")
        c <- " AND PUBYEAR = "
        
        query_string <-paste0(a, c, date_range[j],")",sep = "")
      
        
        
        # api1: 38c1ea28aed25f40f11034d20557ccde
        # 8d8d7b628fae6e1a5a04db969b0bca93
        # api2: 8e204bc721cb41c0251c8846351342b0
        # api3: c253aa47dd592442b1d5ad7ded7b0514
        # api4: 8d8d7b628fae6e1a5a04db969b0bca93
        
        # c253aa47dd592442b1d5ad7ded7b0514 throttled 5/16
        scopus_data <- rscopus::scopus_search(query_string,
                                              max_count=8000,
                                              view = "COMPLETE",
                                              api_key = "8d8d7b628fae6e1a5a04db969b0bca93")
        
        
        
        # query_string <- paste0("eid(2-s2.0-0024266051)")
        scopus_data_raw <- gen_entries_to_df(scopus_data$entries)
        # nrow(scopus_data_raw$df)==1 & ncol(scopus_data_raw$df)==3
        if(nrow(scopus_data_raw$df)==1 & ncol(scopus_data_raw$df)==3){
          next
        }else{
        scopus_papers <- scopus_data_raw$df
        
        term_for_file<-paste("scopus_affil_",search_term[h],"_",date_range[j],sep="")
        papers <- paste("./papers/",term_for_file,"_papers", ".csv", sep = "")
        write_csv(scopus_papers, papers)
        
        scopus_affiliations <- scopus_data_raw$affiliation
        affils <- paste("./affils/",term_for_file,"_affils_", ".csv", sep = "")
        write_csv(scopus_affiliations, affils)
        
        scopus_authors <- scopus_data_raw$author
        authors <- paste("./authors/",term_for_file,"_authors", ".csv",sep = "")
        write_csv(scopus_authors, authors)
        }
    }
    }
  
