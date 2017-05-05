# ec503-final-project
This application examines the effect of query strategy on the performance of various classifiers. We examined the change in performance of several classifiers as we gradually increased the number of labeled training samples used for the classifier. We examined several different query strategies as they relate to QDA and SVM classifiers including variants of uncertainty sampling and query by committee.


## Instructions to Create New Data
1. Open main.m
2. Select the dataset by assigning the respective index to the variable 'select_dataset'
3. Select the training size scale increment by assigning the respective index to the variable 'select_scale'
    i. if linear - you can update the starting seed and increment size starting on line 93
4. Select the query stratgies by assigning the respective index to the variable 'select_strat_1' and 'select_strat_2'
5. Select the number of trials to run by updating the variable trials


## Instructions to recreate data
1. Run createTable
i. For the spambase dataset 
cur_dir = dir_spam;
lastp = 2300;

ii. For the ibn_sina dataset
cur_dir = dir_ibn;
lastp = 10361;


## Instructions to replot -- only supports log scale at the moment
1. Run replot
i. For the spambase dataset 
cur_dir = dir_spam;
lastp = 2300;

ii. For the ibn_sina dataset
cur_dir = dir_ibn;
lastp = 10361