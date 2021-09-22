# Asg 1 for data visualization 

I don't like these types of countries-scaled-by-metric graphs. They aren’t necessarily misleading, but the presentation is ridiculous, and I don’t think it adds anything aesthetically either. I keep seeing them in sponsored ads / explore feed posts on social media, so I’ve grabbed a few to go over in this assignment.

## Graph One:


<img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW1/Asg1Graph1.jpg" width="400" height="350" />

Going down the Cleveland list of encoding importance for example one:

1. There is nothing on a clear common scale 
2. There is nothing on a misaligned scale either (except maybe geographical location)
	- but this is ruined by the the weird scaling and missing countries  		(e.g. Africa & a surprising amount of Europe are missing, Cape Verde is closer to Jamaica than Mexico is to America, Ireland is further north than Iceland, India borders Lebanon, Austria borders Greece)
	- Location is probably the least important metric, and yet it is the highest on the encoding hierarchy. 
3.  Length is not used
4.  Angle is not used
5. The most important feature — debt to gdp ratio — is encoded by one of the two lowest possible metrics on the hierarchy:              area.

6. For some reason, colour indicates another metric — GDP growth rate. This is super confusing, but it is the reason Canada is orange at 86% dept/gdp and Bhutan is green at 101% dept/gdp ratio. 
	 - this is actually in agreement with the Cleveland hierarchy, because we represent the more important feature with area and the less important feature with colour, but I find it very confusing. 

7. This pretty clearly breaks the law of continuity wrt to the metric we care about, preserving it (kind of) only for geographic location.

I find this graph to be borderline unreadable, which is a shame because it looks like it took a lot of work — it isn't even like there is some deception intended here. Just a really bad graph. 


## Graph Two:

<img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW1/Asg1Graph2.jpg" width="400" height="400" />


This is identical, but now we encode the metric we care about (changed to unemployment)  in two ways: distance out from the centre point and size. We encode continent by colour. The same Cleveland hierarchy issues remain, but now we rank on a common scale — which is _better_, but this is a really weird common scale!

Here we also add the law of continuity for our more important unemployment metric, instead of wasting it on geography. This is a lot better! I still think this graph is still really bad though, for a couple of reasons:

## Other Nitpicks:

1. You can't really even compare ratios due to wildly different country shapes (e.g try comparing Chile vs Barbados in Graph Two)

2. You need to work out for yourself if they're using _percentage of original size_ or scaling up from a common baseline.

3. In graph two, angle doesn't really seem to encode anything, but they plot everything on a circle anyways. It's like an even more useless pie chart. 

4. It is difficult to find any specific country because there is no clear order to skim the labels in
	- e.g try finding fiji or malta
	
5. Oceana and Europe are essentially the same shade of teal (look at fiji again)

6. Inconsistent text size, colour,  and boldness is a bit of an eyesore. 

## JD

Nicely put together and nice explanations. Grade: 2.2/3
		





