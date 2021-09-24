library(tidyverse)
library(ggplot2)
library(ggthemes)
library(cowplot)
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

#just cumulative deaths for 1:19 and 20:70
cumsumvec = c(tail(cumsum(df_minimal$cases[01:19]),n = 1),
              tail(cumsum(df_minimal$cases[20:70]),n = 1))

cumsumvec_normalized = cumsumvec / (sqrt(sum(cumsumvec^2))) #normalize for bubble scale param

#added a name here to try to get an auto legend thing; I don't think it helps, but I don't want to remove it to break anything
class = c("every case in the ~20 years before the vaccine", "every case in the ~50 years after")
df_dummy = tibble(dummyvec, cumsumvec_normalized,class)
df_dummy_full = tibble(dummyvec, cumsumvec,class)

# using help from this answer: 
#https://stackoverflow.com/a/50876626/12369476
# and this answer:
#https://stackoverflow.com/a/52841737/12369476

#THIS IS THE BAR PLOT, creating it first before messing with any inset stuff.
main = ggplot(data = df_minimal, aes( x = year, y = cases)) +
  geom_bar(stat="identity") +
  ggtitle("Measles Cases Over Time") +
  annotate(x=bp,y=+Inf,
           label=" < Vaccine Introduced",
           vjust=2,
           hjust = -0.10,
           fill = "lightgrey",
           geom="label") +
  geom_vline(xintercept = bp, linetype = "dashed") +
  theme_fivethirtyeight()


##BUBBLE PLOT STUFF STARTS HERE
bubblescale = 70 #makes bubble larger while retaining area
rev(df_dummy) #reverse order of columns for opacity reasons

#source for help for making transparent background: 
#https://stackoverflow.com/a/41878833/12369476

areaplot = ggplot(data = df_dummy, aes(x = dummyvec, y = dummyvec,
                                       size = cumsumvec_normalized,
                                       color = class)) +
    geom_point(alpha = 0.7) +
    
    #this scales the actual size of the bubbles in the chart; it should keep the 
    #values propotional probably
    scale_size(range = c(bubblescale * cumsumvec_normalized[2],
                         bubblescale * cumsumvec_normalized[1])) +
  
    #remove legend for now
    theme(legend.position="none") +
    
    #add manual bubble colors because green + pink doesn't look great
    #credit to http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
    #here
    scale_color_manual(values=c('#999999','#E69F00')) +
  
    #trying to make text smaller, don't think this does much
    theme(text = element_text(size = 1)) +
  
    #add actual annotations. This doesn't work probably because I'm technically still using geom_point
    #which breaks stuff, because all my scales are length 1 dummy variables maybe. 
    annotate(x=0,y=0.0,
             label="total cases in 18\n  years before vaccine:",
             vjust=-1.9,
             hjust = 0.70,
             #fill = "lightgrey",
             size = 3,
             geom="text") +
  
    annotate(x=0,y=0,
             label=" ^ total cases in 52 years\nafter vaccine",
             vjust= 2.9,
             hjust = 0.7,
             #fill = "lightgrey",
             size = 2.5,
             geom="text") +
  
 
    #strip all the formatting because this is a inset. Need to make custom stuff later.
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
#actually I am using this... 
areaplot2 = ggplot(data = df_dummy, aes(1, y =  cumsumvec, fill = class)) +
  #make one-bar bar chart
  geom_bar(position = "identity", stat = "identity", alpha = 0.8) + 
  
  #mess with colors and remove some elements because this is an inset
  theme(panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "lightgrey", color = 'lightgrey'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  
  #remove some elements because this is an inset. 
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  
  #move legend around 
  theme(legend.position = c(-.14,-.25)) +
  
  #fill legend with not-pure-white
  theme(legend.background=element_rect(fill = '#a5a5a5')) +
  
  #labels and title
  labs(y = "cases", fill = "Legend") +
  ggtitle("Cumulative Cases")

#now, add the inlet into the main plot
fullplot = ggdraw() + draw_plot(main) +
  #draw_plot(areaplot, x = 0.4, y = .23, width = .7, height = .7)+ #uncomment for bubble
  draw_plot(areaplot2, x = 0.70, y = .53, width = .2, height = .3) + #comment for bubble
  scale_x_continuous("",breaks=c(.5,2.5),labels=c("Low types","High types") ) 


fullplot
