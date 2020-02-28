 close all % closes all the open figure windows
 clear all % removes all variables in the workspace
 clc       % clears the command window
 
 x = 0:0.1:100;
 
 %Take a set of inputs from the user.
 caUserInput = inputdlg({'x1','x2','x3','x4','x5','x6','x7','Input'},...
              'Inputs', [1 10; 1 10; 1 10; 1 10; 1 10; 1 10; 1 10; 1 10;]); 
          
 %Convert the Inputs to Double.
usersValue1 = str2double(caUserInput{1});
usersValue2 = str2double(caUserInput{2});
usersValue3 = str2double(caUserInput{3});
usersValue4 = str2double(caUserInput{4});
usersValue5 = str2double(caUserInput{5});
usersValue6 = str2double(caUserInput{6});
usersValue7 = str2double(caUserInput{7});
inputValue = str2double(caUserInput{8});

%Handling error or x3 < x2
if usersValue3 < usersValue2
    error("Can't enter x3 less than x2")
    return; 
end

%Preparing to plot according to the assignment.
a = trapmf(x,[0 0 usersValue1 usersValue3]);
b = trapmf(x,[usersValue2 usersValue4 usersValue5 usersValue6]);
c = trimf(x, [usersValue5 usersValue6 usersValue7]);
d = trapmf(x,[usersValue6 usersValue7 100 100]);
hold on;
%Plot the Fuzzy Sets.
plot(x,a)
plot(x,b)
plot(x,c, 'r')
plot(x,d)
xlabel('X')
ylabel('Membership Value')
ylim([-0.05 1.05])

% Handling all cases for the read value from the USER.
if (inputValue<usersValue2)
u1=evalmf(inputValue, [0 0 usersValue1 usersValue3], 'trapmf');
fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set A\n ',inputValue, u1)

elseif (inputValue>=usersValue2) && (inputValue <= usersValue3)
    u1=evalmf(inputValue, [0 0 usersValue1 usersValue3], 'trapmf');
    u2=evalmf(inputValue, [usersValue2 usersValue4 usersValue5 usersValue6], 'trapmf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set A\n',inputValue, u1)
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set B\n',inputValue, u2)
    
elseif (inputValue>usersValue3) && (inputValue < usersValue5)
    u1=evalmf(inputValue, [usersValue2 usersValue4 usersValue5 usersValue6], 'trapmf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set B\n',inputValue, u1)
    
elseif (inputValue>=usersValue5) && (inputValue <= usersValue6)
    u1=evalmf(inputValue, [usersValue2 usersValue4 usersValue5 usersValue6], 'trapmf');
    u2=evalmf(inputValue, [usersValue5 usersValue6 usersValue7], 'trimf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set B\n',inputValue, u1)
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set C\n',inputValue, u2)
    
elseif inputValue == usersValue6
    u1=evalmf(inputValue, [usersValue2 usersValue4 usersValue5 usersValue6], 'trapmf');
    u2=evalmf(inputValue, [usersValue5 usersValue6 usersValue7], 'trimf');
    u3=evalmf(inputValue, [usersValue6 usersValue7 100 100], 'trimf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set B\n',inputValue, u1)
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set C\n',inputValue, u2)
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set D\n',inputValue, u3)
    
elseif (inputValue>usersValue6) && (inputValue <= usersValue7)
    u1=evalmf(inputValue, [usersValue5 usersValue6 usersValue7], 'trimf');
    u2= evalmf(inputValue, [usersValue6 usersValue7 100 100], 'trapmf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set C\n',inputValue, u1)
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set D\n',inputValue, u2)
    
elseif inputValue >usersValue7
    u1=evalmf(inputValue, [usersValue6 usersValue7 100 100], 'trapmf');
    fprintf('The Membership value for %1.2f is %1.2f in Fuzzy set D\n',inputValue, u1)
    
end