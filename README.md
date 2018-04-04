# Applied-machine-learning-for-financial-modeling

Duplication Files for Applied Machine Learning for Financial Modeling
ASSINGMENT #1 Machine Learning & Inflation Forecasting
Assignment2-3: Credit Default Forecasting Model
code prepared by Jiaxi Wu (jiaxi.wu@columbia.edu)

For inflation forecasting model:

0: Clean BLS data and prepare it for prediction exercise
1: Load prediction tools (simplified version of an R package for easier local replication)
2: Tune prediction algorithms (with sample code for local and distributed/parallel tuning)
3: Fit the tuned models with tuning parameters determined in 2
4: Combine results from 3 and produce Table 1

0 and 1 have to be run before 2 or 3.
3 can be run without 2, using the tuning parameters we found through running 2.
4 uses results from 3.
Based on code by David Welgus and Valerie MichelmanJann Spiess, March/April 2017 jspiess@fas.harvard.edu


For credit default model:

1. Treat single to multiple defaults as “default” (Excel Column CR)

2. For missing values, assign average of previous-available and next-available. If entire data class is missing, assign dummy variable.

3. Randomly divide data into 1 training sample (T) and 1 hold-out sample (H). Disregard the discussion in class of doing 4 samples of equal size and go with this simpler approach.

4. Method 1: OLS
Used library algorithms to run OLS on T to generate and store the regression function.
Test regression function on H and generate MSE and R2.

5. Method 2: Regression Tree
Use library algorithms and set tuning parameters to tree depth 8, minimum units in each non-terminal node 20, and R2 minimal improvement per split 1%.
Run algorithm on T to generate and store prediction algorithm.
Run prediction algorithm on H(rt) to generated MSE and R2.

6. Assess methods 1 and 2 based on MSE and R2 and calculate value-add of best method.

For any questions and suggestions please email Jiaxi Wu at jiaxi.wu@columbia.edu
