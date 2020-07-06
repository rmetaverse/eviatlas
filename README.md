# eviatlas

eviatlas is an R package for visualising the datasets produced by systematic maps. It is the package version of the EviAtlas app, which you can access at <a href="https://estech.shinyapps.io/eviatlas/">https://estech.shinyapps.io/eviatlas/</a>.

eviatlas was produced as part of the  <a href="https://www.eshackathon.org">Evidence Synthesis Hackathon</a> series. It was created by and for the open-source research community. Pull requests and suggestions for future improvements are welcome.

You can download it using the following code:
``` r
# install.packages("remotes")
remotes::install_github("rmetaverse/eviatlas")
```

## Usage
This package has only one function, called <code>eviatlas</code>, which creates an app in the working directory:
``` r
library(eviatlas)
eviatlas()
```

If you want to run this app, you can do so using <code>shiny::runApp</code>; but note that neither <code>Shiny</code> nor any of the other dependencies of the app are installed by default with <code>eviatlas</code>.

We intend that later versions of <code>eviatlas</code> will allow you to:
- specify your own dataset from the command line
- choose which data tabs you want to display
- change the style of the dashboard
- provide your own user-defined cover pages


## Citation
If you use eviatlas in your work, please cite it as follows:

Haddaway NR, Feierman A, Grainger M, Gray C, Tanriver-Ayder E, Dhaubanjar S, Westgate M. <i>eviatlas: a tool for visualising evidence synthesis databases</i>. Environmental Evidence. 2019; 8:22. <a href="https://doi.org/10.1186/s13750-019-0167-1">https://doi.org/10.1186/s13750-019-0167-1</a>