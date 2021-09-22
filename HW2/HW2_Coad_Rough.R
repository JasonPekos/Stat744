library(tidyverse)
library(mgcv)

#read in data
df = readr::read_csv("https://mac-theobio.github.io/DataViz/data/vaccine_data_online.csv")

#get rid of the non-measles data, and useless columns which are only used for other data (all FALSE here)
df_minimal = filter(df, disease == "Measles")[1:5]

#make first plot, just smoothed time series plot
ggplot(data = df_minimal, aes(x = year, y = cases)) +
  geom_smooth() + 
  geom_point(shape = 4) +
  geom_vline(xintercept = filter(df_minimal,
                                 vaccine != FALSE)$year,
             linetype = "dashed")+
  labs(y = "cases", x = "year")

# The issue is that the later points drag down the loess fit 
# and make it look like the trend was decereasing before the vaccine
# which sends .. probably a bad (&wrong) message. I plotted the actual points
# which helps a little, but I still think this is bad, so I'm decreasing the loess span

ggplot(data = df_minimal, aes(x = year, y = cases)) +
  geom_smooth(span = 0.09) + #method = mgcv::gam()
  geom_point(shape = 4) +
  geom_vline(xintercept = filter(df_minimal,
                                 vaccine != FALSE)$year,
             linetype = "dashed")+
  labs(y = "cases", x = "year")

#Much better! But I think it would look good fitting a seperate smooth to either 
#side of the breakpoint

##Discontinuity Attempt starts here
#first, specify the breakpoint year because I was running into issue with nested verbs
#just sets bp = 1964(?)

bp = filter(df_minimal,vaccine != FALSE)$year

#credit to here: https://rstudio-pubs-static.s3.amazonaws.com/116317_e6922e81e72e4e3f83995485ce686c14.html#/5
#for mutate + iflelse troubleshooting help
#nvm in the end it was a bracket issue :-/
#credit to https://stackoverflow.com/a/61702104/12369476
#for vline label help also 

#make before /  after vaccine categories 
df_minimal %>% mutate(post_date = ifelse(year > bp,"yes","no")) -> df_minimal

ggplot(data = df_minimal, aes(x = year, y = cases, color = post_date)) +
  geom_smooth(span = 0.5) + 
  geom_point(shape = 4)   +
  geom_vline(xintercept = bp,
             linetype = "dashed") +
  labs(y = "cases", x = "year", color = "Vaccine \nAvailable?") +
  ggtitle("Recorded Measles Cases Before and After Introduction of Vaccine") +
  annotate(x=bp,y=+Inf,label=" < Vaccine Introduced",vjust=3, hjust = -0.11, geom="label") 






