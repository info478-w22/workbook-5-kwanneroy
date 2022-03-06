# Workbook 6: analyze NHANES data

# Set up
library(survey)
library(Hmisc)

demo <- sasxport.get('DEMO_I.XPT')
alco <- sasxport.get('ALQ_I.XPT')

nhanes <- merge(x = demo, y = alco, by = 'seqn', all = TRUE)

wt_sum <- sum(nhanes$wtint2yr, na.rm = TRUE)
# This number represents the total US population at the time

## Analysis
# Cleaning Data - Converting Answers to 0, 1's, and NA's
nhanes$alq151[nhanes$alq151 == 2] <- 0
nhanes$alq151[nhanes$alq151 == 7] <- NA
nhanes$alq151[nhanes$alq151 == 9] <- NA

# Create a Survey Design
nhanes_survey <- svydesign(
  id = ~sdmvpsu,
  nest = TRUE,
  strata = ~sdmvstra,
  weights = ~wtint2yr,
  data = nhanes
)

nhanes_mean <- svymean(~alq151, nhanes_survey, na.rm = TRUE)
mean_by_gender <- svyby(~alq151, ~riagendr, nhanes_survey, svymean, na.rm = TRUE)
   