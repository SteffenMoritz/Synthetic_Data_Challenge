

# TEAM DESTATIS: Repository for work on the UNECE HLG-MOS Synthetic Data Challenge 

This was our (**Team DESTATIS**) repository for work on the United Nations Economic Commission for Europe (UNECE) High-level Group for the Modernisation of Statistical Production and Services (HLG-MOS) **Synthetic Data Challenge 2022**. 

<img src="img/1024px-United_Nations_Economic_and_Social_Commission_for_Europe_Logo.svg.png" align="center" width="150" height="60" alt="UNECE Logo" />



## Background

The HLG-MOS Synthetical Data Challenge was all about exploring different methods, algorithms, metrics and utilities to create synthetic data. Synthetic Data could potentially be an interesting option for national statistical agencies to share data while maintaining public trust. 

In order to be beneficial for certain use cases (e.g. 'release data to the public', 'release to trusted researchers', 'usage in education') the synthetic data needs to conserve certain statistical properties of the data. Thus, the synthetic data needs to be similar to the original data, but at the same time it has to be different to preserve privacy. 

There is a lot of active research done on synthetic data and new methods for generating and evaluating confidentiality of synthetic data are emerging. The HLG-MOS has created a [Synthetic Data Starter Guide](https://statswiki.unece.org/download/attachments/330367757/Synthetic%20Data%20for%20NSOs%20A%20starter%20guide.pdf?api=v2) to give national statistic offices an intro into this topic. 

<img src="img/ex2.png" align="center" width="300" height="200" alt="Output Example" />
*Example output: Correlation Plot showing differences in correlations between a GAN created synthetic dataset and the original data*


# Goal 

Goal of the challenge was to create synthetic versions of provided datasets and afterwards evaluate to what extent we would use this synthetic data for certain use cases. These use-cases were 'Releasing microdata to the public', 'Testing analysis', 'Education', 'Testing technology'.


One objective thereby was to evaluate as many different methods as possibly, while still trying to optimze parameters for the methods as good as possible.

Our team managed to create synthetic data with the following methods:

 - Fully Conditional Specification (FCS)
 - Generative Adversarial Network (GAN)
 - Probabilistic Graphical Models(Minutemen DP-pgm)
 - Information Preserving Statistical Obfuscation(IPSO)
 - Multivariate non-normal distribution (Simulated)


The other objective was to do this evaluation ideally for both of the provided original datasets. One dataset (SATGPA) being more of a toy example and the other (ACS) a more complex real-life dataset.

  - [SATGPA](https://www.openintro.org/data/index.php?data=satgpa): SAT (United States Standardized university Admissions Test) and GPA (university Grade Point Average) data, 6 features, 1.000 observations. 
  
 - [ACS](https://github.com/usnistgov/SDNist/tree/main/sdnist/census_public_data): Demographic survey data (American Community Survey), 33 features, 1.035.201 observations. 

So overall, it was about trying as many methods as possible, while still doing a quality evaluation (in terms of privacy and usability metrics) for each created synthetic dataset.

**Final deliverables were**: 

A short 5 minute summary **video**, synthetic **datasets**, evaluation **reports** and an evaluation of the starter guide.


<img src="img/ex1.png" align="center" width="300" height="200" alt="Output Example" />
*Example output: Histogram showing differences in distributions between a GAN created synthetic dataset and the original data*

# Team
Our team of the Federal Statistical Office of Germany (Statistisches Bundesamt) consited from five members of different groups within Destatis. Participating were:

 - Steffen M.
 - Reinhard T.
 - Felix G.
 - Michel R.
 - Hariolf M.
 
 <img src="img/Statistisches_Bundesamt.svg.png" align="center" width="150" height="60" alt="Destatis Logo" />


## Repository Structure
Since it was a challenge in limited time and we were working in parallel the Github repository might look a little bit untidy. There are plenty of interesting things to find in the repository, here is a quick orientation:

- [All 0_ files: Overview Presentation abour our challenge work](0_Final_Slides_DESTATIS.pdf) 
- [All 1_ files: All our final synthetic datasets and multiple evaluation reports](/1_Final_Reports_and_Results) 
- [All 2_ files: Different folders with .Rmd files to create the evalation reports for the synthetic datasets ](/2_Evaluation_ACS_FCS) 
- [All 3_ files: Mainly intermediate datasets created from using minutemen](/3_minuteman_acs) 
- [All 4_ files: Saved cgan models](/4_models)
- [All 5_ files: Different resulting synthetic datasets](5_results)
- [All 6_ files: .Rmd files used to run python code for GANs](https://github.com/SteffenMoritz/Synthetic_Data_Challenge)
- [All 7_ files: Different .R files for running algorithms to create synthetic data](https://github.com/SteffenMoritz/Synthetic_Data_Challenge)
- [All other files: Mainly different other .R code files, original datasets, samples of original datasets ](https://github.com/SteffenMoritz/Synthetic_Data_Challenge)


Some larger files >100MB of our repo are unfortunately not linked, because of the max. Github file size allowed in the free tier.

## Results

<img src="img/1.jpg" align="center" alt="Output Example" />
