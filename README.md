# EOD Analyses
This repository is dedicated to analyses of electric organ discharges (EODs) of Gnathonemus petersii.\
G. petersii is a pulse-type weakly electric fish that generates EODs used for electrolocation and electrocommunication. To study electrocommunication effectively, it is crucial to accurately separate the EOD signals emitted by two fish recorded simultaneously. Here, we introduce an unsupervised approach for EOD separation and two EOD sonification techniques for the initial exploration of the relationship between electric signaling and behavior. More information can be found in our preprint (Chrtkova et al., 2025). 


## Folders
### Separation 
Contains the unsupervised approach for EOD separation from two free-swimming individuals of Gnathonemus petersii. It is based on the extraction of the continuous wavelet transform coefficients from each EOD and subsequent application of the FFT-accelerated Interpolation-based t-SNE (FIt-SNE) algorithm for dimensionality reduction and hierarchical clustering for classification. FIt-SNE is an open-source software developed by Linderman et al. (2019) and is freely available at https://github.com/KlugerLab/FIt-SNE.

#### Functions
cwt_coef_extraction() - extracts wavelet coefficients from each EOD in signal\
classification() - applies the FIt-SNE algorithm and classifies output with hierarchical clustering\
separation() - run to separate EODs from two individuals

### Sonification
Contains two EOD sonification techniques, which can be applied to separated signals.

#### Functions
pulse_wise_sonification() - sonify signals with a pulse-wise approach\
fm_sonification() - sonify signals with a frequency modulation approach

## Prerequisities
FIt-SNE package installed https://github.com/KlugerLab/FIt-SNE

## Acknowledgements
Chrtkova, I., Koudelka, V., Langova, V., et al. Unsupervised Approach for Electric Signal Separation in Gnathonemus petersii: Linking Behavior and Electrocommunication. 2025.03.04.641376 Preprint at https://doi.org/10.1101/2025.03.04.641376 (2025).

Linderman, G.C., Rachh, M., Hoskins, J.G. et al. Fast interpolation-based t-SNE for improved visualization of single-cell RNA-seq data. Nat Methods 16, 243–245 (2019). https://doi.org/10.1038/s41592-018-0308-4
