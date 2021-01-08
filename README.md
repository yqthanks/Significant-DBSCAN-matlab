# Significant DBSCAN
**Code for paper** ([Best Paper Award](http://sstd2019.org/program.html) @ SSTD 2019):

*Xie, Y. and Shekhar, S., 2019, August. Significant DBSCAN towards Statistically Robust Clustering. In Proceedings of the 16th International Symposium on Spatial and Temporal Databases (pp. 31-40).* [ACM link](https://dl.acm.org/doi/abs/10.1145/3340964.3340968)

```
@inproceedings{xie2019significant,
  title={Significant DBSCAN towards Statistically Robust Clustering},
  author={Xie, Yiqun and Shekhar, Shashi},
  booktitle={Proceedings of the 16th International Symposium on Spatial and Temporal Databases},
  pages={31--40},
  year={2019}
}
```

More versions/data will be added soon. We appreciate citing of this paper if the code/data is used for result comparison, etc.


**Sharing code to support reproducible research.**

## Description
This work aims to address a major limitation of traditional density-based clustering approach -- the lack of statistical rigor. This makes approaches such as DBSCAN tend to return many spurious clusters. For example, according to the [HDBSCAN](https://link.springer.com/chapter/10.1007/978-3-642-37456-2_14) paper: 
>"small clusters of objects that may be highly similar to each other just by chance, that is, as a consequence of the natural randomness associated with the use of a finite data sample"

The code implements significant DBSCAN to automatically remove spurious clusters through point-process based statistical tests.

Significant DBSCAN works particularly well when data has high volume of noise.

At the moment, this MATLAB demo code (Python or Java version will come later) is primarily for 2D spatial data but can be easily edited to work for arbitrary dimensions (e.g., removing the grid index). It also works for data with clusters of different densities.

*Please note that we just quickly edited and shared the code here due to requests, and will need to do a bit more testing soon when I get time in about a week or two (late August). Feel free to try for now if interested.*

## Example
The following figure shows an example of results comparing DBSCAN and significant DBSCAN.

![Example](https://github.com/yqthanks/significantDBSCAN/blob/master/example_results.png)

## Usage
**Main function:** significantDBSCAN()
```
[cluster_idx] = sigDBSCAN(data, dim1, dim2, m, siglvl, mode, eps_div)
```

**Inputs:** (as mentioned before, this demo code currently is primarily for 2D spatial data, but can be easily edited to work for arbitrary dimensions if needed; contact xiexx347 at umn dot edu if you have any questions)

```data```: N by 2 array (e.g., spatial coordinates of events)

```dim1, dim2```: scalars describing the size of the study area (data need to be pre-processed to set min to 0 for both dimensions)

```m```: number of Monte Carlo simulation trials to use for estimating test statistic distribution

```siglvl```: significance level (e.g., 0.01)

```mode```: Optional. Defines algorithm to use (e.g., with acceleration or not). Default is 3 (dual-convergence algorithm).

```eps_div```: Optional. Controls cell size to use for discrete scan (an acceleration method). Default is 0.25 (1/4 of current eps).

**Output:**

```cluster_idx```: N by 3 array with data points and corresponding cluster IDs (0 for noise). The order of points is likely different from original data input.

**Result visualization:**

2D visualization code is in [visualization](https://github.com/yqthanks/significantDBSCAN/tree/master/visualization) folder.

## Synthetic Data

Synthetic data generator and base image files are in [synthetic_data](https://github.com/yqthanks/significantDBSCAN/tree/master/synthetic_data) folder.

Example **synthetic data with clusters (24 sets)** and **synthetic data with no cluster (4 sets)** have been added to [synthetic_data](https://github.com/yqthanks/significantDBSCAN/tree/master/synthetic_data). Visualizations of data and Significant DBSCAN results will be added soon.

**Synthetic data with clusters (24 sets)**

Data have four clusters with background noises. The spatial dimensions are 100 x 100. Datasets come with different number of points and effect sizes (exact definition see [paper](https://dl.acm.org/doi/abs/10.1145/3340964.3340968)). The naming format is:

ShapeName_EffectSize1_EffectSize2_#Points

```ShapeName```: "shape" or "test". Determines the shape of clusters (figures included in [synthetic_data](https://github.com/yqthanks/significantDBSCAN/tree/master/synthetic_data) folder)

```EffectSize1``` and ```EffectSize2```: Determines how many times inside probability density is as high as outside (e.g., an effect size of two means the probability density of getting a point at each location inside the corresponding cluster is twice that of the outside non-clustered region). ```EffectSize1``` is used for two clusters and
 ```EffectSize2``` for the rest. When effect size is one, that means the inside probability density is the same as outside. As a result, that means the inside region is not a true cluster (no underlying process to generate high density of points; if high density is observed, that is due to natural randomness).
 
```#Points```: Number of points in a dataset (e.g., 2,000, 10,000).

**Synthetic data with no cluster (4 sets)**

The datasets are generated by homogeneous point processes (effect size = 1 across the study area), and there is no true cluster in the data. Any clusters detected from this type of data are spurious detections. Robust clustering algorithms should tell there is no cluster in the data.

**Running Significant DBSCAN on synthetic data**

Same set of default parameters (```m```=100, ```siglvl```=0.01, default optional parameters) can be used across all example datasets with different number of clusters, number of points and effect sizes.

<!--*We will share some examples of generated synthetic data soon.*-->


## Example comparison with other clustering techniques

In the following, the first figure shows results on complete random data where there is no true cluster, and any cluster detected is spurious (happen only due to natural randomness). In contrast, the second figure shows detections on truly clustered data (governed by clustered point process; please see [paper](https://dl.acm.org/doi/abs/10.1145/3340964.3340968) for more details).

**Complete random data (no true cluster exists)**

![randomdata](https://github.com/yqthanks/significantDBSCAN/blob/master/example_data_and_results/comparison1_random_data.png)


**Clustered data with noise in background (four shapes are true clusters; background are noises generated with homogeneous probability density)**

![clustereddata](https://github.com/yqthanks/significantDBSCAN/blob/master/example_data_and_results/comparison2_clustered_data.png)

## License

The MIT License: AS IS (please see license file)
