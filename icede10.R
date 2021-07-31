########### Managing ICD10 codes########

# install.packages("devtools")
# devtools::install_github("jackwasey/icd")

library(icd)
library(tidyverse)


######### If you want to convert a code to a description #######
######### For help type '?explain_code' ########################

## Example of a single code ###

#explain_code(as.icd10who("Q24.8"))

### Reading Comorbidity Matrices ################

Covid_Dec=read.csv(file="CoNet_Comorb_CDMX_INC_Decesased.txt", header = FALSE, sep=" ")

Covid_Surv=read.csv(file="CoNet_Comorb_CDMX_INC_Survived.txt", header = FALSE, sep=" ")

#### Spliting into Condition column vectors #########
X=Covid_Dec[,1]
Y=Covid_Dec[,2]

Z=Covid_Surv[,1]
W=Covid_Surv[,2]

length(Z)
length(W)

#### Initializing description vectors #######

comor1 <-character(length = length(X))
comor2 <-character(length = length(Y))

comor3 <-character(length = length(Z))
comor4 <-character(length = length(W))


###### Skipping missing (un-annotated or wrong) ICD-10 codes #######

X[X == "I10.X"] <- "I10"
X[X == "J80.X"] <- "J80"
Y[Y == "I10.X"] <- "I10"
Y[Y == "J80.X"] <- "J80"

Z[Z == "I10.X"] <- "I10"
Z[Z == "J80.X"] <- "J80"
Z[Z == "I10.X"] <- "I10"
W[W == "I10.X"] <- "I10"
W[W == "J80.X"] <- "J80"

Z[Z=="149.8"] <- "I49.8"
W[W=="149.8"] <- "I49.8"

Z[Z=="T82.22"] <- "T82.2"
W[W=="T82.22"] <- "T82.2"

### Querying ICD10 descriptors ######

for (i in 1:length(X)) {
  comor1[i] <- explain_code(as.icd10who(X[i]))
}

for (i in 1:length(Y)) {
  comor2[i] <- explain_code(as.icd10who(Y[i]))
}

for (i in 1:length(Z)) {
  comor3[i] <- explain_code(as.icd10who(Z[i]))
}

for (i in 1:length(W)) {
  comor4[i] <- explain_code(as.icd10who(W[i]))
}


### Condition vectors ########
 ## comor1

## comor2

## comor3

## comor4

### Generating the annotated comorbidity matrix #####

ComoNet=cbind(X,comor1,Y,comor2)

ComoNet2=cbind(Z,comor3,W,comor4)

#### Saving the comorbidity matrix to a file #####

write.csv(ComoNet, file="Comorbidity_Network_Deceased.csv")

write.csv(ComoNet2, file="Comorbidity_Network_Survived.csv")

### Calculation of comorbidity tables #####################
###########################################################
## Input registry table should have at least two columns ##
## visit_name (i.e. Patient ID) and icd_name (i.e. ICD codes)

# visit_name icd_name
# 1          a     I058
# 2          b    I73.9
# 3          c    T82.8
# 4          d    I69.3
# 5          e    I69.3
# 6          e    I21.9
# 7          b    I69.3

Covid_Pts10 <- read.csv(file="CDMX_COMOR_CHARSON.csv", header=TRUE, sep=",")

# Let us call this list "Covid_Pts10"

# The associated comorbidity table ComTab can be generated as

ComTab <- comorbid_charlson(Covid_Pts10)

ComTab

### Calculation of  Charlson Comorbidity Scores #####

### Charlson scores for individual patients are calculated as follows:

Charlson_scores_Covid <- charlson_from_comorbid(ComTab)

Charlson_scores_Covid

write.csv(ComTab, file="Charlson_Comorbidity_Table.csv")

write.csv(Charlson_scores_Covid, file="Charlson_Comorbidity_Scores.csv")

pdf(file="Density_Charlson.pdf")

plot(d, main="Charlson scores for Covid-19 patients", xlab = "Charlson comorbidity scores", ylab="Probability density")
 polygon(d, col="red", border="blue") 
 
dev.off()

####

pdf(file="Frequency_Charlson.pdf")
plot_comorbid_results(ComTab, main="Number of Covid-19 patients with each Charlson comorbidity")
dev.off()

######## Figuras en Español #############

pdf(file="Densidad_Charlson.pdf")

plot(d, main="Puntajes de Charlson para pacientes con Covid-19", xlab = "Puntajes de comorbilidad Charlson", ylab="Densidad de probabilidad")
polygon(d, col="red", border="blue") 

dev.off()

####

pdf(file="Frecuencia_Charlson.pdf")
plot_comorbid_results(ComTab, main="Frecuencia de Comorbilidades de Charlson", ylab="Frecuencia en pacientes con COVID-19")
dev.off()








