close all
clear all
clc


x=inputdlg({'N','M','L','XBs','YBs','Rs','Rc', 'Given Node'},...
'Inputs' ,[1 40; 1 40; 1 40; 1 40; 1 40; 1 40; 1 40; 1 40;] );

N = str2double(x{1});
M = str2double(x{2});
L = str2double(x{3});
xbs = str2double(x{4});
ybs = str2double(x{5});
rs = str2double(x{6});
rc = str2double(x{7});
givenNode= str2double(x{8});


randlocx = (M).*rand(N,1);
randlocx = (L).*rand(N,2);
hold on;


figure(1),plot(randlocx(:,1),randlocx(:,2),'ko','MarkerSize',5,'MarkerFaceColor','k');
plot(randlocx(givenNode,1),randlocx(givenNode,2),'ko','MarkerSize',8,'MarkerFaceColor','r');
labels = cellstr( num2str([1:N]'));
text(randlocx(:,1),randlocx(:,2),labels,'VerticalAlignment','bottom','HorizontalAlignment','right')

plot(xbs,ybs,'h','MarkerSize',20);
title('Base Wireless Sensor Network');
xlabel('x');
ylabel('y');
xlim([0 M]);
ylim([0 L]);
th = 0:pi/50:2*pi;
%line(randlocx(:,1), randlocx(:,2), 'Color','red');


for i=1:N
    xRC = rc * cos(th) + randlocx(i,1);
    yRC = rc * sin(th) + randlocx(i,2);
    plot(xRC, yRC,'g');
   
    xRS = rs * cos(th) + randlocx(i,1);
    yRS = rs * sin(th) + randlocx(i,2);
    plot(xRS, yRS, 'b');

    
end
 legend('Nodes', 'Given Node', 'Base Station', 'Com. Range', 'Sensing Range', 'Location', 'southoutside');


Isoverlap = checkOverlap(randlocx, rc, givenNode);

if ~isempty(Isoverlap)
fprintf('The neighbors of the given node %d is/are: \n', givenNode);
disp(Isoverlap)
else
    fprintf('There are no neighbors. \n');
end

fprintf('The location of given node %d is: (%1.2f, %1.2f) \n',givenNode, randlocx(givenNode,1), randlocx(givenNode,2))

fprintf('The percentage of the area covered by the sensor nodes is: %1.2f. \n', (areaCovered(N,randlocx, rs,M,L)/(M*L)));

fprintf('Displaying the location and sensing range of a given node %d: \n',givenNode);

hold off;
    
    givenRCx = rc * cos(th) + randlocx(givenNode,1);
    givenRCy = rc * sin(th) + randlocx(givenNode,2);   
    givenRSx = rs * cos(th) + randlocx(givenNode,1);
    givenRSy = rs * sin(th) + randlocx(givenNode,2);

    figure(2), plot(randlocx(givenNode,1),randlocx(givenNode,2),'ko','MarkerSize',8,'MarkerFaceColor','r');
    hold on;
    plot(givenRCx,givenRCy,'MarkerSize',20);
    plot(givenRSx,givenRSy,'MarkerSize',20);
    title('Given Node');
    xlabel('x');
    ylabel('y');
 legend('Given Node', 'Com. Range', 'Sensing Range', 'Location', 'southoutside');
       
function overlapped = checkOverlap(center, rc, node)
overlapped = zeros(0,1);
for i=1 :length(center)
    
    if i == node
        continue
    end
    dist = sqrt( (center(node,1) - center(i,1))^2 + (center(node,2) - center(i,2))^2);
    if dist <= rc
        overlapped = [overlapped ;i];
    end
clear dist;

end

end


function areaCov = areaCovered(Ns,center, srange, M, L)
 delta = 0.01;
 count = 0;
 for i=1:L/delta
     for j =1:M/delta
         xDelta = (i-1)*delta + delta/2;
         yDelta = (j-1)*delta + delta/2;
            for k=1:Ns
                if (sqrt( (xDelta - center(k,1))^2 + (yDelta - center(k,2))^2)) <=srange
                count = count+1;
                break;
                end 
            end     
     end
 end
 
 
 areaCov = count * (delta)^2;

end