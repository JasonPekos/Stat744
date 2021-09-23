library(tidyverse)
library(mgcv)
library(ggplot2)
library(ggthemes)
options(scipen=10000)


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
  ggtitle("Measles Cases Before and After Introduction of Vaccine") +
  annotate(x=bp,y=+Inf,label=" < Vaccine Introduced",vjust=3, hjust = -0.11, geom="label") +
  theme_fivethirtyeight() +
  scale_shape_tableau()
  

#Now for Plot Two

#first, make a new dataframe for our inlet

dummyvec = integer(2)
cumsumvec = c(tail(cumsum(df_minimal$cases[01:19]),n = 1),
              tail(cumsum(df_minimal$cases[20:70]),n = 1))

cumsumvec = cumsumvec / (sqrt(sum(cumsumvec^2))) #normalize for bubble scale param
class = c("before", "after")
df_dummy = tibble(dummyvec, cumsumvec,class)


# using help from this answer: 
#https://stackoverflow.com/a/50876626/12369476
# and this answer:
#https://stackoverflow.com/a/52841737/12369476

main = ggplot(data = df_minimal, aes( x = year, y = cases)) +
  geom_bar(stat="identity") +
  ggtitle("Measles Cases Before and After Introduction of Vaccine") +
  annotate(x=bp,y=+Inf,
           label=" < Vaccine Introduced",
           vjust=2,
           hjust = -0.10,
           fill = "lightgrey",
           geom="label") +
  geom_vline(xintercept = bp, linetype = "dashed") +
  theme_fivethirtyeight()

bubblescale = 70 #makes bubble larger while retaining area
rev(df_dummy) #reverse order of columns for opacity reasons

#source for help for making transparent background: 
#https://stackoverflow.com/a/41878833/12369476
areaplot = ggplot(data = df_dummy, aes(x = dummyvec, y = dummyvec, size = cumsumvec, color = class)) +
    geom_point(alpha = 0.7) +
    scale_size(range = c(bubblescale * cumsumvec[1],
                         bubblescale * cumsumvec[2])) +
    theme(legend.position="none") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())+
  theme(panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())


#not using this anymore — bar plot instead of bubble
areaplot2 = ggplot(data = df_dummy, aes(1, y =  cumsumvec, fill = class)) +
  geom_bar(position = "identity", stat = "identity", alpha = 0.8) +
  theme_fivethirtyeight()

#now, add the inlet into the main plot
library(cowplot)
fullplot = ggdraw() + draw_plot(main) +
  draw_plot(areaplot, x = 0.4, y = .23, width = .7, height = .7)

fullplot

# main + annotation_custom(
#   ggplotGrob(main), 
#   xmin = 5, xmax = 7, ymin = 30, ymax = 44
# )



