##SCRIPT FOR CONVERTING DATA FROM SURVEY CSV TO R DATA STRUCTURES

#' @name Convert from csv to data frame
#' @author Bartol Freškura
#' @description Converts raw csv file from survey to a R data structure in a form of data frame
#' @param path Path to folder where .csv files is locatde
#' @param fileName Name of the .csv file
#' @return Data frame with processed data
#' @example convertToRData("/home/username/Documents/Project/CSVDir/", "sample_survey.csv")
convertToRData <- function(path, fileName){
      
      ##CONSTANTS
      #LOCAL path for csv files
      pathCsv <- path
      
      
      #Types of attributes in columns
      columnTypes <- c("character","character","character","integer","integer","integer","integer",
                       "integer", "character", "character", "character", "character", "character", "character"
                       , "character", "character", "character", "character","character","character")
      
      #Column names
      columnNames <- c("ID.Hash","Sex","Age","Student.Status","Employer.Opinion","National.Identity",
                       "Employee.Satisfaction","Future.Employee","Work.Field","Industry","Creativity","Ecology",
                       "Science","Energetics","Croatia","Association.Career", "E.Mail", "Start.Date","End.Date",
                       "Network.ID")
      
      ##Load data
      rawData <- read.csv(paste(pathCsv,fileName, sep = ''),header = TRUE, na.strings = "",
                          colClasses = columnTypes, comment.char = "")
      #Set column names
      colnames(rawData) <- columnNames
      
      
      ##### QUESTION CONSTANTS ############
      
      ##Koja je vaša dobna skupina?*
      #constants
      to17 <- "do 17"
      from18To20 <- "od 18 do 20"
      from21To23 <- "od 21 do 23"
      from23To26 <- "od 24 do 26"
      from27Above <- "27 ili stariji"
      
      
      #Koje područje poslovanja INA grupacije smatrate osobno najzanimljivijim?*
      #constants
      research <- "Istraživanje i proizvodnja nafte i plina"
      rafinery <- "Rafinerije i marketing"
      finance <- "Financije"
      it_sup <- "IT potpora"
      logistics <- "Logistička potpora"
      
      ##### QUESTION CONSTANTS ############
      
      
      #Create vectors for modified data frame
      id <- character()
      sex <- character()
      age <- character()
      student.status <- integer()
      employer.opinion <- integer()
      national.identity <- integer()
      employee.satisfaction <- integer()
      future.employee <- integer()
      work.field <- character()
      ina.association <- character()
      association.career <- character()
      email <- character()
      start.date <- date()
      end.date <- date()
      network.id <- character()
      
      #Iterate through data frame and do the conversion
      
      for (i in 1:nrow(rawData)) {
            #Handle ID hash
            id <- c(id, rawData[i,]$ID.Hash)
            
            #Handle sex (hueuheuhueuhe69)
            if(rawData[i,2]=="muško"){
                  sex <- c(sex,"M")
            }
            else{
                  sex <- c(sex,"F")
            }
            
            #Handle Age
            if(rawData[i,3]==to17){
                  age <- c(age, "0-17")
            }
            else if(rawData[i,3]==from18To20){
                  age <- c(age, "18-20")
            }
            else if(rawData[i,3]==from21To23){
                  age <- c(age, "21-23")
            }
            else if(rawData[i,3]==from23To26){
                  age <- c(age, "24-26")
            }
            else{
                  age <- c(age, "27-Inf")
            }
            
            #Handle student status
            # 1== STUDENT_TRUE, 0== STUDENT_FALSE
            student.status <- c(student.status, rawData[i,]$Student.Status)
            
            #Handle Employer opinion
            employer.opinion <- c(employer.opinion, rawData[i,]$Employer.Opinion)
            
            #Handle National Identity rating
            national.identity <- c( national.identity , rawData[i,]$National.Identity)
            
            #Handle Employee satifaction
            employee.satisfaction <- c(employee.satisfaction, rawData[i,]$Employee.Satisfaction)
            
            #Handle future employee
            future.employee <- c(future.employee, rawData[i,]$Future.Employee)
            
            #Handle Work field
            if(rawData[i,]$Work.Field==it_sup){
                  work.field <- c(work.field, "IT_Support")
            }
            
            else if(rawData[i,]$Work.Field==research){
                  work.field <- c(work.field, "Research_Production_Oil_Gas")
            }
            
            else if(rawData[i,]$Work.Field==finance){
                  work.field <- c(work.field, "Finances")
            }
            
            else if(rawData[i,]$Work.Field==rafinery){
                  work.field <- c(work.field, "Rafinery_Marketing")
            }
            
            else{
                  work.field <- c(work.field, "Logistics")
            }
            
            
            #Handle INA association
            
            #define temp variables
            ind <- toString(rawData[i,]$Industry)
            cre <- toString(rawData[i,]$Creativity)
            eco <- toString(rawData[i,]$Ecology)
            sci <- toString(rawData[i,]$Science)
            en <- toString(rawData[i,]$Energetics)
            cro <- toString(rawData[i,]$Croatia)
            ##MAGIC :D
            newVec <- paste(ind,cre,eco,sci,en,cro, sep = ";")
            newVec <- gsub(pattern = ";NA", x = newVec, replacement = "")
            newVec <- gsub(pattern = ";;", x = newVec, replacement = "")
            newVec <- gsub(pattern = "NA;", x = newVec, replacement = "")
            ina.association <- c(ina.association, newVec)
            
            
            #Handle Association career
            association.career <- c(association.career, rawData[i,]$Association.Career)
            
            #Handle E-mail
            email <- c(email, rawData[i,]$E.Mail)
            
            #Handle Network ID
            network.id <- c(network.id, rawData[i,]$Network.ID)
            
      }
      
      #Store to new data frame
      dataProc <- data.frame(id,sex,age,student.status,employer.opinion,national.identity,employee.satisfaction,
                             future.employee,work.field,ina.association,association.career,email,network.id)
      
      dataProc
}
