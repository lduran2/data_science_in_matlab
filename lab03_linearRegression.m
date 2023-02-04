%% Lab 3: Linear Regression
%
% This example shows how to use linear regression to predict house
% prices.  More specifically, it teaches how to preprocess data, then
% split the dataset into the training set and testing set.  Afterwards,
% is teaches how to use the training set to train a model and evaluate
% that model based on the testing set.
%
% After studying the prediction of housing prices, practing using
% linear regression to predict medical cost from the data in
% "./insurance.csv".

%% 1. Example: Linear Regression for House Price Prediction
% We will use the house price dataset "./housing.csv" to predict
% housing prices.  This dataset includes the attributes

% clear the workspace of variables
clear;
% load the housing data
T = readtable('housing.csv');
% display the column names
disp(T.Properties.VariableNames')

%% 1.1 Preprocess the raw data
