# List all datasets
data()

# Summary of the esoph dataset
summary(esoph)
#    agegp          alcgp         tobgp        ncases         ncontrols
# 25-34:15   0-39g/day:23   0-9g/day:24   Min.   : 0.000   Min.   : 0.000
# 35-44:15   40-79    :23   10-19   :24   1st Qu.: 0.000   1st Qu.: 1.000
# 45-54:16   80-119   :21   20-29   :20   Median : 1.000   Median : 4.000
# 55-64:16   120+     :21   30+     :20   Mean   : 2.273   Mean   : 8.807
# 65-74:15                                3rd Qu.: 4.000   3rd Qu.:10.000
# 75+  :11                                Max.   :17.000   Max.   :60.000

# Dimension of the esoph dataset
dim(esoph)
# [1] 88  5

# Structure of the esoph dataset
str(esoph)
# 'data.frame':	88 obs. of  5 variables:
# $ agegp    : Ord.factor w/ 6 levels "25-34"<"35-44"<..: 1 1 1 1 1 1 1 1 1 1 ...
# $ alcgp    : Ord.factor w/ 4 levels "0-39g/day"<"40-79"<..: 1 1 1 1 2 2 2 2 3 3 ...
# $ tobgp    : Ord.factor w/ 4 levels "0-9g/day"<"10-19"<..: 1 2 3 4 1 2 3 4 1 2 ...
# $ ncases   : num  0 0 0 0 0 0 0 0 0 0 ...
# $ ncontrols: num  40 10 6 5 27 7 4 7 2 1 ...

# Average number of cancer cases observed in subjects older that 75 (75+)
mean(subset(esoph$ncases, esoph$agegp == "75+"))
# [1] 1.181818

# Average number of cases by age group
aggregate(esoph$ncases, by=list(AgeGroup=esoph$agegp), FUN=mean)
#  AgeGroup          x
#1    25-34 0.06666667
#2    35-44 0.60000000
#3    45-54 2.87500000
#4    55-64 4.75000000
#5    65-74 3.66666667
#6      75+ 1.18181818


# Total number of cases by age group
aggregate(esoph$ncases, by = list(AgeGroup = esoph$agegp), FUN = sum)
#  AgeGroup  x
#1    25-34  1
#2    35-44  9
#3    45-54 46
#4    55-64 76
#5    65-74 55
#6      75+ 13

# Average number of cases by tobacco group
aggregate(esoph$ncases, by=list(TobaccoGroup=esoph$tobgp), FUN=mean)
#  TobaccoGroup        x
#1     0-9g/day 3.250000
#2        10-19 2.416667
#3        20-29 1.650000
#4          30+ 1.550000

# Total number of cases by tobacco group
aggregate(esoph$ncases, by=list(TobaccoGroup=esoph$tobgp), FUN=sum)
#  TobaccoGroup  x
#1     0-9g/day 78
#2        10-19 58
#3        20-29 33
#4          30+ 31

# Total number of cases by alcohol group
aggregate(esoph$ncases, by=list(AlcoholGroup=esoph$alcgp), FUN=sum)
#  AlcoholGroup  x
#1    0-39g/day 29
#2        40-79 75
#3       80-119 51
#4         120+ 45

# Group data by alcohol group and tobacco group
# and calculate the total number of cases using the "dplyr" package
data_group <- esoph %>%
   group_by(alcgp, tobgp) %>%
   dplyr::summarize(Cases = sum(ncases)) %>%
   as.data.frame()
data_group
#       alcgp    tobgp Cases
# 1  0-39g/day 0-9g/day     9
# 2  0-39g/day    10-19    10
# 3  0-39g/day    20-29     5
# 4  0-39g/day      30+     5
# 5      40-79 0-9g/day    34
# 6      40-79    10-19    17
# 7      40-79    20-29    15
# 8      40-79      30+     9
# 9     80-119 0-9g/day    19
# 10    80-119    10-19    19
# 11    80-119    20-29     6
# 12    80-119      30+     7
# 13      120+ 0-9g/day    16
# 14      120+    10-19    12
# 15      120+    20-29     7
# 16      120+      30+    10