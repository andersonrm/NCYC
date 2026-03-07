setwd("C:/Users/riley/Dropbox/rileyanderson123/NCYC")


dat <- read.csv("be_opt_output.csv")

library(tidyverse)



dat1 <- dat %>% 
  pivot_longer(cols = c(current : opt4),
               names_to = "options") %>% 
  mutate(across(c(item : options), factor),
         value = case_when(
           item == "Misc." | item == "Lights" | item == "Stove_Fridge" ~
             round(value * (7/12),3),
           TRUE ~ value
         ),
         kWh = round(value * 293, 4),
         MWh = round(kWh / 1000, 2))


dat1 %>%
  filter(item != "Cooling Fan/Pump",
         item != "Heating") %>% 
  ggplot(aes(x = options, y = MWh, fill = item)) +
  geom_col() +
  geom_label(aes(x = options, y = ,
                 label = MWh),
             position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("turquoise",
                               "yellow3",
                               "wheat2",
                               "tan2")) +
  theme_minimal() +
  scale_x_discrete(labels = c("Current",
                              "R15 walls &\nnew windows",
                              "+ South awning",
                              "+ R60 attic &\nceiling drywall",
                              "+ 100% LED\nlights")) +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust = 0.8)) +
  labs(x = NULL, fill = NULL)



dat1 %>% 
  group_by(options) %>% 
  summarise(total = sum(MWh)) %>% 
  left_join(., dat1, by = "options") %>% 
  filter(item == "Cooling") %>% 
  mutate(prop_mwh = MWh / total) %>% 
  filter(options != "opt4")
