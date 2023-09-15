
# mycroft

<!-- badges: start -->
<!-- badges: end -->

Mycroft provides data-driven large language model generated explanations of data tables.

## Installation

You can install the development version of mycroft like so:

``` r
devtools::install_github("BDSi-UTwente/mycroft")
```

## Example

Given a summarized/aggregated data table, description of the subject of the data, 
and an audience to write for, mycroft fetches large language model (ChatGPT only, 
for now) generated explanations of the data. 


``` r
library(mycroft)
library(tidyverse)

# if not specified, uses `OPENAI_API_KEY` environment variable
token <- "YOUR OPENAI API TOKEN"

# while we can throw whatever data we want at mycroft, large tables will cause 
# problems with the limits of the underlying API. Not to mention they will be 
# slower, and cause higher API usage - all the data is part of the prompt.
data_summary <- iris %>% 
  group_by(Species) %>%
  summarize(across(everything(), list(mean = mean, sd = sd)))
  
explain_data(
  data = data_summary,
  subject = "Figure 3: Iris properties by species",
  audience = "botanical researchers"),
  token = token)
```

> Figure 3 presents the mean and standard deviation (SD) for four properties of the Iris flower: sepal length, sepal width, petal length, and petal width. These measurements are further categorized by the three species of the Iris flower: setosa, versicolor, and virginica.\n\nFor the sepal length, the virginica species has the greatest mean (6.588) with the highest standard deviation (0.6359), indicating more variability in this species. The setosa species has the smallest mean sepal length (5.006) but also the smallest standard deviation (0.3525), which suggests less variability in sepal length within this species.\n\nFor the sepal width, the setosa species shows the highest mean (3.428) and standard deviation (0.379), while versicolor has the lowest values for both measures.\n\nRegarding petal length, the virginica species demonstrates the highest mean measurement (5.552) and standard deviation (0.5519). Conversely, setosa has the smallest mean petal length (1.462) and the least variability (SD = 0.1737).\n\nLastly, the petal width of the virginica species has the highest mean (2.026) and standard deviation (0.2747) signifying more variability. Setosa has the smallest mean petal width (0.246) and smallest standard deviation (0.1054), pointing to less variability in petal width within this species. \n\nComparative analysis hints that for all four characteristics, the setosa species tend to have the lowest mean and least variability, while the virginica species tends to have the highest mean and more variability.

``` r 
# we can change the language and tone of the description by changing the audience
explain_data(
  data = data_summary,
  subject = "Figure 3: Iris properties by species",
  audience = "a group of toddlers",
  token = token)
```
  
> [1] "Figure 3 shows us different measurements of flowers, specifically for three types of Iris flowers - setosa, versicolor, and virginica. It's like comparing the sizes of three different types of toy flowers. \n\nFor each type of flower (species), we have average (mean) sizes and the amount they vary (standard deviation or sd). Let's start with the length of the sepal (the green leafy part). Setosa flowers have the shortest, versicolor flowers are a bit longer, and virginica flowers have the longest ones.\n\nThe sepal width (how wide the green leafy part is) is almost the same for all three types of flowers, but setosa flowers have slightly wider sepals.\n\nNow, let's look at the petal (the colorful part of the flower). The setosa flowers have much shorter petals than versicolor and virginica flowers. Virginica flowers have the longest petals.\n\nLastly, for the petal width, again setosa flowers have the narrowest petals, while virginica flowers have the widest ones.\n\nRemember, not all flowers of the same type will be exactly the same size. Some may be a bit bigger or a bit smaller, that's what the values in the 'sd' columns tell us."
  
``` r
# the default prompt is just "Describe {subject} for {audience}\n\n{data}", 
# so we can add some more context to the audience if needed:
explain_data(
  data = data_summary,
  subject = "Figure 3: Iris values in Bounty Bay",
  audience = "a gathering of victorian pirates, buccaneers, and privateers. Use pirate language and expressions, such as 'Yarrr!', 'Shiver me timbers', 'Arrrrgh!', and so forth",
  token = token)
```

> [1] "Ahoy, mateys! Now take a gander at this treasure map, Figure 3, here. It shows the lay of the Iris land in old Bounty Bay for all us seafarin' types.\n\nFirst off, we got the Setosa Iris. Yarrr! It's a wee one, with a Sepal Length average of about 5, and not much variation there. 'Tis pretty stout too, with a mean width yonder the 3-mark. But if ye be lookin' at its Petal, avast! It's tiny, with an average length of 1.462 and an even tinier width. Its variation ain't much either.\n\nNext up be the Versicolor Iris. This one's a bit larger! With Sepal Lengths averaging close to 6 and widths about 2.770. Shiver me timbers! Versicolor's Petal Length gets bolder at a mean of 4.260, and its width increases too, with a mean of 1.326.\n\nBut the true Leviathan here be Virginica! Blimey, its average Sepal Length is a whopping 6.588, and it's wider with a mean of nearly 3. But look out for its Petal Length - around 5.552, it is! Also, it's got a mean Petal Width of 2.026. Virginica has the greatest variation among all with widths and lengths of Sepals, Petals, and all.\n\nSo there ye have it, me hearty friends. The bounty that be the Iris land at a glance. Now set yer sails for discovery! Arrrrgh!"
```

``` r 
# if you want the model to pick up on features, explicitly including them in the data is a good bet:
data_summary_relative <- iris %>%
  mutate(
    Species,
    Sepal.Size = Sepal.Length * Sepal.Width,
    Petal.Size = Petal.Length * Petal.Width,
    Relative.Petal.Size = Petal.Size / Sepal.Size
  ) %>%
  group_by(Species) %>%
  summarize(across(everything(), mean))
  
explain_data(
  data = data_summary_relative,
  subject = "Figure 3: absolute and relative size of Iris petals and sepals",
  audience = "botanical researchers"),
  token = token
)
```

> [1] "Figure 3 provides the average measurements of sepal and petal sizes across three species of the Iris: setosa, versicolor, and virginica. It shows both absolute measurements (in centimeters) and relative measurements that consider the proportion of the petal size to the sepal size.\n\nWhen comparing absolute sepal sizes, virginica has the largest sepal whereas setosa has the smallest. For petal size, again, virginica is the largest while setosa is the smallest.\n\nRelative petal size - the proportion of petal to sepal - is also the greatest in virginica and the smallest in setosa. This implies that for virginica, the petal occupies a much larger proportion compared to the sepal as compared to the other species.\n\nNotably, versicolor exhibits a relative petal size that is considerably greater than setosa, despite having an almost similar sepal size, meaning its petal size is much bigger relative to its sepal size. This indicates significant differences in the morphology of these Iris species. \n\nThese data can enhance our understanding of variations in flower structure among Iris species, which could be linked to their ecological and evolutionary adaptations."

    
