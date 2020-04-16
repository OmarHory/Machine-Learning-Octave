%OMAR ALHORY
%Assume a wireless sensor network (WSN) of N stationary sensor nodes that 
%are deployed randomly in a sensing area of W x L m2. 
%Assume the sensing range of the node Rs. After random deployment, 
%the N nodes will cover partial of the area. Assume you are given additional M sensor nodes. 
%Write a MATLAB code that uses Genetic Algorithm in order to find the
%best locations of the M sensor nodes such that the covered area will be maximized.

close all
clear all
clc

global Nodes;
global M;
global N;
global W;
global L;
global rs;
global cFitness;
global pairs;
global Pc;
global Pm;
global maximum;
global FinalCord;
global bits;


 x=inputdlg({'N','W','L','Rs','M'},...
 'Inputs' ,[1 40; 1 40;1 40; 1 40; 1 40; ] , {'5', '50', '100', '10', '5'});
 
 N = str2double(x{1});
 W = str2double(x{2});
 L = str2double(x{3});
 rs = str2double(x{4});
 M = str2double(x{4});
 cFitness = zeros(16,2);
 pairs=[];
 Pm = 0.001;
 Pc = 0.7;
 maximum = 0;
 Nodes = [];
 randlocx = [];
 randlocx = (L).*rand(N,1);
 randlocx(:,2) = (W).*rand(N,1);
 Nodes = randlocx;
 th = 0:pi/50:2*pi;

 bits = size(round(de2bi(max(W,L))),2); %Required Bits
 population = zeros(16,bits*M*2); %Initialize Population

%Initialize the whole population of 16 chromosomes for the first
%Generation. (You can do 18, maybe it would improve performance and maybe
%not)
temp1 = zeros(M,2);
for i =1:16
temp1 = round(L.*rand(M,1));
temp1(:,2) = round(W.*rand(M,1));
temp = de2bi(temp1,bits,'left-msb');
population(i,:) = reshape(temp.',1,[]); %Flatten the input into a single row
end

Area = areaCovered(N,randlocx);
Area = Area/(W*L)*100;
fprintf('The percentage of the area covered by N sensor nodes is: %1.2f Percent. \n', Area);
if Area == 100
    fprintf("You do not need to optimize anything, the area is already 100, just distribute them anywhere or change your paramenters!\n");
    return;
end

gen=0;

fprintf("Please wait, going through 400 generations...\n");
while gen < 400 %Of Generations (Iterations)
evaluateFitness(population);

if(gen==1)

Area1 = areaCovered(N+M,Nodes);
Area1 = Area1/(W*L)*100;
fprintf('The percentage of the area covered by N+M (Not Optimized) sensor nodes is: %1.2f Percent. \n', Area1);
hold on;
figure(1),plot(randlocx(:,1),randlocx(:,2),'ko','MarkerSize',5,'MarkerFaceColor','k');
plot(Nodes(N+1:end,1),Nodes(N+1:end,2),'ko','MarkerSize',7,'MarkerFaceColor','r');
for i=1:N+M

    xRS = rs * cos(th) + Nodes(i,1);
    yRS = rs * sin(th) + Nodes(i,2);
    plot(xRS, yRS, 'b');
end
grid on
xlim([0 L]);
ylim([0 W]);
end

pairs = selection();
postCross = crossover(population);
population = postCross;
postMutate = mutation(population);
population = postMutate;
evaluateFitness(population);
gen=gen+1;
end

optimizedNodes = [Nodes(1:N,:); FinalCord];
Area2 = areaCovered(N+M,optimizedNodes);
Area2 = Area2/(W*L)*100;
fprintf('The percentage of the area covered by N+M (Optimized) sensor nodes is: %1.2f Percent. \n', Area2);
hold off;


figure(2), 
hold on;
plot(optimizedNodes(N+1:end,1),optimizedNodes(N+1:end,2),'ko','MarkerSize',7,'MarkerFaceColor','r');
plot(randlocx(:,1),randlocx(:,2),'ko','MarkerSize',5,'MarkerFaceColor','k');


for i=1:N+M

    xRS = rs * cos(th) + optimizedNodes(i,1);
    yRS = rs * sin(th) + optimizedNodes(i,2);
    plot(xRS, yRS, 'b');

    
end

xlim([0 L]);
ylim([0 W]);
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function evaluateFitness(cromo)
global Nodes;
global bits;
global M;
global N;
global cFitness;

for i=1:16
    c = 0;
    c1 = 1;
    
    for j=1:M
    x = bi2de(cromo(i,bits*c+1:bits*c1), 'left-msb');
    c= c+1;
    c1 = c1+1;
    y = bi2de(cromo(i,bits*c+1:bits*c1), 'left-msb');
    c= c+1;
    c1 = c1+1;
    Nodes(N+j,1) = x;
    Nodes(N+j,2) = y;
    end
    
    cFitness(i,1) = areaCovered(N+M,Nodes);
    bestCor(Nodes, cFitness);
end
    
    for i = 1:16
        cFitness(i,2) = (cFitness(i,1)./sum(cFitness(:,1)))*100;
    end
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function s = selection()

global pairs;
global cFitness;

for i=1:8
    index = fortune_wheel(cFitness(:,2)');
    index1 = fortune_wheel(cFitness(:,2)');
    if(index == index1)
    index = fortune_wheel(cFitness(:,2)');
    index1 = fortune_wheel(cFitness(:,2)');
    end
    
    pairs(i,1) = index;
    pairs(i,2) = index1;
end
s = pairs;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function postCross = crossover(cromo)
global Pc;
global pairs;
global bits;
global M;

   for i=1:8
    toss = rand(1,1);
    if toss < Pc
        tossCross = round(bits*M*2*rand(1,1)); %Handle if zero
        if tossCross == 0
            tossCross = tossCross +1;
        end
        chunk = cromo(pairs(i,1),tossCross:end);
        chunk1 = cromo(pairs(i,2),tossCross:end);
        cromo(pairs(i,1), tossCross:end) = chunk1;
        cromo(pairs(i,2), tossCross:end) = chunk;
    end 
   end
    postCross = cromo;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function postMutate = mutation(cromo)
global Pm;
global pairs;
global bits;
global M;

   for i=1:8
    toss = rand(1,1);
    if toss < Pm
        tossCross = round(bits*M*2*rand(1,1)); %Handle if zero
        if tossCross == 0
            tossCross = tossCross +1;
        end
        cromo(pairs(i,1), tossCross) =not(cromo(pairs(i,1), tossCross));
        cromo(pairs(i,2), tossCross) = not(cromo(pairs(i,1), tossCross));
    end   
   end
    postMutate = cromo;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bestCor(Ms, percentage)
global maximum;
global FinalCord;
global N;

if max(percentage(:,1)) > maximum
  maximum = percentage;
  FinalCord = Ms(N+1:end,:);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function areaCov = areaCovered(Ns,center)
global W;
global L;
global rs;
 delta = 1; %You can tune this.
 count = 0;
 
 for i=1:L/delta
     for j =1:W/delta
         xDelta = (i-1)*delta + delta/2;
         yDelta = (j-1)*delta + delta/2;
            for k=1:Ns
                if (sqrt( (xDelta - center(k,1))^2 + (yDelta - center(k,2))^2)) <=rs
                count = count+1;
                break;
                end 
            end     
     end
 end
 areaCov = count * (delta)^2;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function choice = fortune_wheel(weights)
  accumulation = cumsum(weights);
  p = rand() * accumulation(end);
  choice = find(accumulation>p,1);
end