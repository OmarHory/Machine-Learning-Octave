close all
clear all
clc
format longG

prompt = 'Enter the learning Rate ALPHA: ';
alpha = input(prompt);
a=-2.4/2;
b=2.4/2;
W11=(b-a).*rand(1,2) + a;
W12=(b-a).*rand(1,2) + a;
W21=(b-a).*rand(1,1) + a;
W22 = (b-a).*rand(1,1) + a;
t1 = (b-a).*rand(1,1) + a;
t2 = (b-a).*rand(1,1) + a;
t3 = (b-a).*rand(1,1) + a;
X=[1 1;0 1; 1 0; 0 0];
Yd=[0; 1; 1; 0];
E = [1; 1; 1; 1];
epoch=1;
SSE =size(4,1);
SSE(1,1) = nan;
SSE(2,1) = nan;
SSE(3,1) = nan;
SSE(4,1) = nan;
%Create a file in the local directory.
fileID = fopen('data.txt','w');
fprintf(fileID,"\nX \tYd  Ya      Error   SSE\n");
fprintf("\nTraining..\n");
while sum(E.^2)>0.001
%Start of forward propagation
a11 = sigmoid(X*W11' - t1);
a12 = sigmoid(X*W12' - t2);
Ya = sigmoid(((a11*W21)+(a12*W22)) - t3);
%Start of Back Propagation
 E = Yd - Ya;
 dz2 = Ya .*(1-Ya) .* E;
 dw21 = alpha.*dz2'*a11;
 dw22 = alpha.*dz2'*a12;
 dtheta3 = alpha.*dz2'*[-1;-1;-1;-1];
 dz11 = (a11 .*(1-a11)) .* (dz2*W21);
 dz12 = (a12 .*(1-a12)) .* (dz2*W22);
 dw11 = alpha.*dz11'*X;
 dw12 = alpha.*dz12'*X;
 dtheta2 = alpha.*dz12'*[-1;-1;-1;-1];
 dtheta1 = alpha.*dz11'*[-1;-1;-1;-1];
 %Updating the Weights and Biases
 W21= W21 + dw21;
 W22 = W22 + dw22;
 W11 = W11 + dw11;
 W12 = W12 + dw12;
 t3 = t3 + dtheta3;
 t2 = t2 + dtheta2;
 t1 = t1 + dtheta1;
 SSE(1,1) = sum(E.^2);
 fprintf(fileID,'%d%d  \t%d  %1.4f  %1.4f  %1.4f\n', [X(:,1),X(:,2),Yd(:,1)...
    ,Ya(:,1), E(:,1), SSE]');
 fprintf(fileID, "\n---------------------------------\n");
 epoch=epoch+1;
end
fclose(fileID);
fprintf("\nTraining has been completed in %d Epochs\n",epoch);

function g = sigmoid(z)
g = 1.0 ./ (1.0 + exp(-z));
end