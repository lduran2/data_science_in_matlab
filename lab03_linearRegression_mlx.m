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
% housing prices.  This dataset includes the attributes and the price
% of each house.  The attributes are

% clear the workspace of variables
clear;
% load the housing data into table T
T = readtable('housing.csv');
% display the column names
columnNames = T.Properties.VariableNames';
disp(columnNames)

%%
% We will train a linear regression model to predict housing prices and
% compare the predictions to the ground truth.

%% 1.1 Preprocess the raw data
% New data may include categorical features and missing values. 
% Because of this, we need to clean up the data.

% store string constants in variables to force syntax errors
% if misspelled
DOUBLE = "double";
OMITNAN = "omitnan";
CONSTANT = "constant";

% get the table size
[nRows, nColumns] = size(T);

%%
% 0. Convert categorical features.

% check the data type of each table column
% (Note that *tableColumnClasses* is a user-defined function.)
classes = tableColumnClasses(T, nColumns);
% make a table of data types to class
columnNames2Classes = table(columnNames, classes)

%%
% Note that ocean_proximity does not have the class "double", which is
% MATLAB's numerical type.  This means that it is categorical data. 
% Let's filter out the cells that do not have categorical data.

% loop through non-numerical data columns:
% * *classes* is an array (or matrix) of strings
% * MATLAB has first class matrices, which means we can compare each
%   string in *classes* to the string "double", creating a boolean
%   matrix called a logical index
% * we can use the *find* function to find the index of true
%   (or nonzero) values
for iCatCol=find(classes ~= DOUBLE)
    % sort and count the existing categories in the column:
    % * categorical creates a categorical array from an array
    % * if you specify *(valueset, catnames)*, it replaces each member
    %   of *valueset* with the parallel member of *catnames* in the
    %   given input array
    % * categories returns each of the categories in a categorical
    %   array in a cell array of unique elements
    columnCategories = categories(categorical(T.(iCatCol)));
    nColumnCategories = numel(columnCategories);
    % create the category encoding as the category index:
    % * *catnames* must be a string array
    encoding = string(1:nColumnCategories);
    % encode the column
    encodedColumn = categorical(T.(iCatCol), columnCategories, encoding);
    % replace them in the dataset T
    T.(iCatCol) = double(encodedColumn);
end % next iCat

%%
% Let's view the data types again.  They should all be "double".

% check the data type of each table column
classes = tableColumnClasses(T, nColumns);
% make a table of data types to class
columnNames2Classes = table(columnNames, classes)

%%
% 1. Fill in missing values.  We will be using means for simplity.

% convert table to a matrix
Tarr = table2array(T);

% check for any missing values:
% * we do this by first checking for each NaN (not a number)
% * then we sum up each column
% * any nonzero column is missing values
nMissingPerColumn = sum(isnan(Tarr))';
% display as a table
columnNames2nMissing = table(columnNames, nMissingPerColumn)

%%
% We see that the number of bedrooms is missing 207 entries.

% get the means of each column ignoring missing data.
Tmeans = mean(Tarr, OMITNAN);
% fill the missing data with the calculated means
Tarr = fillmissing(Tarr, 'constant', Tmeans);

%%
% There should now be no missing data.

% check for any missing values
nMissingPerColumn = sum(isnan(Tarr))';
% display as a table
columnNames2nMissing = table(columnNames, nMissingPerColumn)

%% Appendix

function classes = tableColumnClasses(T, nColumns)
%% tableColumnClasses
% Returns the classes of the leftmost *nColumns* columns in table *T*.
%
%% Input Arguments
% *T* : table = whose classes to evaluate
%
% *nColumns* : double = the number of leftmost columns to classify
%
%% Output Arguments
% classes : string = the class of each of the leftmost *nColumns*
% columns in table T

    % allocate the string array of types
    classes = strings(nColumns, 1);
    % loop through the columns
    for iCol=1:nColumns
        classes(iCol) = string(class(T.(iCol)));
    end % next iCol
end % tableColumnClasses(T, nColumns)
