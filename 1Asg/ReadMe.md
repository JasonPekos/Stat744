# Asg 1 for data visualization 

These types of countries-scaled-by-metric graphs are awful. They aren’t necessarily misleading, but the presentation is ridiculous, and I don’t think it adds anything aesthetically either. I keep seeing them in sponsored ads / explore feed posts on social media, so I’ve grabbed a few to complain about.

## Graph One:



Going down the Cleveland list of encoding importance for example one:

1. There is nothing on a clear common scale 
2. There is nothing on a misaligned scale either (except maybe geographical location)
	- but this is ruined by the countries not being justified to the centre of their geographic location 		(e.g. Canada is too far west; other countries are much worse; Africa is … really weird and missing 90% of the continent)
	- this is also probably the least important metric, and yet it is the highest on this list
3.  Length is not used
4.  Angle is not used
5. The most important feature — debt to gdp ratio — is encoded by one of the two lowest possible metrics:              area.

6. For some reason, colour indicates another metric — GDP growth rate. This is super confusing, but it is the reason Canada is orange at 86% dept/gdp and Bhutan is green at 101% dept/gdp ratio. 
	 - this is actually in agreement with the Cleveland hierarchy, because we represent the more important feature with area and the less important feature with colour, but I find it very confusing. 

7. This pretty clearly breaks the law of continuity wrt to the metric we care about, preserving it (kind of) only for geographic location.

I find this graph to be borderline unreadable, which is a shame because it looks like it took a lot of work — it isn't even like there is some deception intended here. Just a really bad graph. 


## Graph Two:

This is identical, but now we encode the same metric in two ways: distance out from the centre point and size. We encode continent by colour. The same Cleveland hierarchy issues remain, but now we rank on a common scale — which is _better_, but this is a really weird common scale!

Here we also add the law of continuity for our more important debt metric, instead of wasting it on geography. This is a lot better! I still think this graph is really terrible though. 

## Other Nitpicks:

1. you can't really even compare ratios due to wildly different country shapes (e.g try comparing Chile vs Barbados in Graph Two)

2. you need to work out for yourself if they're using _percentage of original size_ or scaling up from a common baseline.

3. In graph two, angle doesn't really seem to encode anything, but they plot everything on a circle anyways. It's like an even more useless pie chart. 

4. Using country shape as essentially a 'marker' is bizarre; there's no reason to think it correlates with debt at all, and it makes comparing ratios so much harder than e.g. circular markers. for reasons in point (1.)



