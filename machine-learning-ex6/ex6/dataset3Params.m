function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%
min = 9999999999999999;
min2 =0;
i =1;
j = 1;
for C1= [0.01 0.03 0.1 0.3 1 3 10 30]
  for sigma1 =[0.01 0.03 0.1 0.3 1 3 10 30]
    
      model = svmTrain(X, y, C1, @(x1, x2) gaussianKernel(x1, x2, sigma1));
     predictions = svmPredict(model, Xval);
     min2 = mean(double(predictions~=yval));
     if min2<min
       min = min2;
       disp(min)
       sigma = sigma1;
       C = C1;
       
     endif
     j=j+1;
  endfor
  j=1;
  i=i+1;
endfor

disp(sigma)
disp(C)
disp(min)





% =========================================================================

end
