<<<<<<< HEAD
library(dplyr)
library(stringr)
library(nnet)
#The quarterbacks on the individual teams throw deep and short passes, left or 
#right, successful or not?

#pass_result= C (completed), I (Incomplete), IN (Interception)
#depth
#direction
#possession_team (team who threw it)

#create new variables from the description on depth(short|deep) and direction (left|right|middle)
depth=str_extract(supplementary_data$play_description, "\\b(short|deep)\\b")
direction=str_extract(supplementary_data$play_description, "\\b(left|right|middle)\\b")

supplementary_data = supplementary_data %>%
  mutate(
    depth = str_extract(play_description, "\\b(short|deep)\\b"),
    direction = str_extract(play_description, "\\b(left|right|middle)\\b"))

#turn pass_result into categorical
supplementary_data$pass_result= factor(supplementary_data$pass_result)

#actual statistics now, multinominal log regression
multi_model= multinom(pass_result ~ depth + direction + possession_team, data = supplementary_data)
summary(multi_model)

z= summary(multi_model)$coefficients / summary(multi_model)$standard.errors
p= 2 * (1 - pnorm(abs(z)))
p

pred= predict(multi_model, type = "probs")
head(pred)
