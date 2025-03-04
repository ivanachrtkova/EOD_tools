# EODs
Repository with codes for the analyses of electric organ discharges (EODs) in weakly electric fish, Gnathonemus petersii.

## Folders
### Separation 
Algorithm for separation of EODs from two free-swimming individuals of wekly electric fish, Gnathonemus petersii. The unsupervised algorithm extract the continuous wavelet transform coefficients from each EOD and subsequently applies FFT-accelerated Interpolation-based t-SNE (FIt-SNE) algorithm for dimensionality reduction and hierarchical clustering for classification. FIt-SNE is an open-source software developed by Linderman et al. (2019) and is freely avalaible at https://github.com/KlugerLab/FIt-SNE.

#### Functions
cwt_coef_extraction() - extracts wavelet coefficients from each EOD in signal\
classification() - applies FIt-SNE algorithm and classifies ouput with hierarchical clustering\
separation() - run to separate EODs from two individuals\

### Sonification
Algorithms for sonification of two separated signals.

#### Functions
pulse_wise_sonification() - sonify signals with pulse-wise approach\
fm_sonification() - sonify signals with frequency modulation approach

## Prerequisities
FIt-SNE package installed https://github.com/KlugerLab/FIt-SNE

Linderman, G.C., Rachh, M., Hoskins, J.G. et al. Fast interpolation-based t-SNE for improved visualization of single-cell RNA-seq data. Nat Methods 16, 243–245 (2019). https://doi.org/10.1038/s41592-018-0308-4
