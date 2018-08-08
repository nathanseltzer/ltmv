## 03 ltmv plot
## "less trust, moore verification"
## Nathan Seltzer


## Packages -------------------------------------------------------------------
library(ggplot2)
library(ggthemes)

## PLOT -----------------------------------------------------------------------

plot <- ggplot(comb, aes(x=district, y=county_name)) + 
          geom_tile(aes(fill=`Any Respondents?`),linewidth=2, 
                    width=.9, height=.9) +
          geom_point(data = select(actual_df, -sample), 
                     aes(size=`Actual Match`), 
                     shape = 4, solid = T, color = "#d68179", stroke = 1.1) +
          scale_y_discrete(name="County of Residence", limits = rev(levels(comb$county_name))) +
          facet_grid(. ~ sample) +
          scale_fill_manual(values=c("gray85", "#3f516e")) +
          theme_tufte(base_family="Helvetica") +
          theme(panel.spacing = unit(1, "lines"),
                strip.text.x = element_text(size = 12)) +
          xlab("U.S. Congressional District") 


plot

ggsave("graphics/IVR vs WEB.png", plot, dpi = 1200, width = 6.3, height =  9 )
