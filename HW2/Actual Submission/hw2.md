# A2 —  Jason Pekos

---

**BMB: generally better/easier to write in `.Rmd` (RMarkdown) rather than generating `.md` and then sticking it in (unless graphs are very computationally intensive/are rendered in a separate part of the pipeline). Also, using markdown format (where pictures are incorporated via `![alt_text](img_reference)`) is better than HTML format, unless you need fine control; in an Rmarkdown file you can also use `knitr::include_graphic()` or `knitr::include_url()` for finer control**

*Q1*: write a short statement (a few sentences) that explains what question you think the graphic is trying to answer, or what pattern it’s trying to display*

<p align="center">
  <img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW2/you_graph_original.jpg" width="550" title="initial graph from https://www.science.org/news/2017/04/here-s-visual-proof-why-vaccines-do-more-good-harm">

</p>



**A:**  The purpose of the graph is to demonstrate the efficacy of the Measles vaccine by plotting the time series of measles cases each year before and after the introduction of the Measles vaccine. The pattern is a clear decrease in the prevalence of the disease — represented by the area of the blue circles — in the years following the vaccine rollout. 


---

*Q2*: based on these data, create 2 ggplots that display the data in a different way from the original; use the 2 plots to illustrate tradeoffs between different graphical principles. (If you’re feeling truly uncreative, one of your plots can replicate the original graphical design.) You do not need to worry about the dynamic-graphics aspect or the historical events shown in the original display.




## Graph One

For my first graph, I tried simply representing the data as a scatterplot: the Wilke book seems to suggest that this is a pretty good first step with time series data. The main issue is that there is a pretty large amount of noise. This also makes directly connecting all the points pretty unfeasible; the result is really messy, and interferes with interpretation. To compromise, I tried using the built in ggplot LOESS fit to draw a smooth line between the points. 

<p align="center">
  <img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW2/RplotLOESSsimple.png" width="550" title="First Attempt">
</p>

This is pretty bad — I think the way that the points after the vaccine drag down the LOESS fit before the vaccine date is misleading: it makes it look like the vaccine had no impact, and really there is some other trend driving this. 

**BMB: might work better to specify a smaller `span` value (less smoothing than default)**

I'd like to fix this, so I replaced the LOESS fit with a regression discontinuity model centred at 1964. 

<p align="center">
  <img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW2/AsgPlot1.png" width="550" title="Second Attempt at First Attempt">
</p>


I think this is a lot better! I have some pretty major concerns though:

1. I'm not sure if fitting a smoothed curve is a good idea at all — it just seems dishonest if I haven't actually done any statistical analysis here! the fancier (and less standard) I make the smoothing, the more I feel this way. 

**BMB: fair enough. Reducing the `span` should be OK, though, as it brings the smoothed line *closer* to the data ...**

2. The "Vaccine Introduced" annotation is pretty ugly 

**BMB: it's not *too* bad**

3. Axis ticks should probably have commas

**BMB: you could do that pretty easily (https://stackoverflow.com/questions/37713351/formatting-ggplot2-axis-labels-with-commas-and-k-mm-if-i-already-have-a-y-sc), or perhaps better express cases in per-1000 (brings the scale down to a readable 0-800). Note that loess curve CIs drop below zero (see ggplot hacks on main class web site).**

That said, in comparison to the original chart:

1. The actual magnitudes are easier to decipher here; in the original, they are encoded by areas that overlap each other. You can get a general sense of what's going on, but it's hard to compare specific early years. Magnitudes are easier to decode on a common scale than using circular areas.

2. My scale is much easier to read if you want the actual numbers — in the original, you have to estimate by trying to guess how much would fit into the legend circle, which is very difficult. 

**BMB: did you think about colours/themes/etc.? Legend for vacc available/unavailable could be done by direct labeling, or skipped entirely**

## Graph Two

I though a bar plot would work well here: it's equivalent to the area under the curve plots which are suggested later in the Wilke book, but a bit more granular. It's also further from the style of my initial chart. 

I actually couldn't get what I wanted to do here to work — my initial plan was to add an inset into the top right, demonstrating cumulative cases before and after the vaccine, in the style of the original visualization. I got about this far:


<p align="center">
  <img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW2/The_Failed_Bubbleplot_Inlet.png" width="550" title="First Attempt at Second Attempt">
</p>

But I couldn't get the annotations to play nice due to the hacky way I wrote the inset plot. That's why they look very ugly here and don't point to the correct areas. I had other issues coming up with the axis here too, so I had to give up and go a different route.

I ended up switching to a single bar plot inset to represent the same thing, but much uglier. 








<p align="center">
  <img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW2/AsgPlot2.png" width="650" title="Second Attempt at Second Attempt">
</p>

This has some advantages over the original two graphs:

1. I represent the same thing as my first graph without a potentially misleading smooth 

2. You can accurately decode areas here in a way you can't for either of the two initial graphs, both for cumulative and disaggregated cases 

However it also has a disadvantage

1. It looks really bad.

Ultimately, I think the way to go is probably a combination of the two: remove the smooth, go with area under the curve, and add an actually functional cumulative cases inset in the top right. 

**BMB: I agree that this could be nice. The circle/bubble is visually attractive even if it's lower on the Cleveland hierarchy than a stacked bar chart. I might (1) suppress spaces between bars; (2) fill bars with different colours before/after onset of vax (these could match colours in the inset);  maybe change aspect ratio?**

**BMB: mark 2.5/3**
