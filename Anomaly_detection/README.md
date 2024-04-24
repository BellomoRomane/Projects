# 1. Explanation

The aim of this project is to enlight what I've leant during Jonathan Sprauel*(Data Scientist at Thales Alenia Space, Toulouse)* classes.
During his classes, I've mainly worked on machine learning and deep learning lessons as well as optimizations subjects.
Here is my work on the anomaly detection project andthe instructions given:

*An aircraft system expert comes to see you (data scientist) with this dataset, and asks you to Build an algorithm to detect windows that are abnormal.*

* 1. With this information and no more, formulate the problem, and tell him what is feasible and what is not.
* 2. Develop an approach to answer his question in the best way possible.
* 3. Present your findings to the expert, in a way he can understand and help you validate your results...


Here are the different libraries used for this project.

## Libraries

* matplotlib.pyplot
* numpy 
* pandas
* sklearn
    * IsolationForest
    * LocalOutlierFactor
    * PCA
    * StandardScaler
* seaborn 

# 2. Architecture of the project

For a deaper explanation, here is how I developed the project.

## Data Analysis

First of all, If I wanted to know my dataset in details in order to better comprehend it and to execute the best anomaly detection possible, I needed to do a data analysis.  
So, I explored my dataset to know its shape, the type of its columns, the *NaN* values and its statistics.

## Anomaly detection

Then, after having done this data analysis, I needed to decide which type of anomaly detection was the best for this project.  
To do so, I used 2 different libraries which worked differently. I have created my machine learning algorithm for each one and compared their results. I also plotted the results in 2D and 3D.  

Then, after everything, I gave my point of view, explained my results and determined the best algorithm to use for this project.
