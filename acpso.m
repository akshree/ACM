clc;
clear;
close all;

CF = @(p) sq(p); %costfunc
nVar = 4; %Rs Xs=X2' Xm R2' 
Varsize = [1 nVar];
LB=[0 0 0 0];
UB=[5 5 50 5];

Itermax = 100;
Swarmsize = 100;
w =0.8;
dampc=0.9999;
c1=1.5;
c2=0.2;

Initial.position =[];
Initial.velocity =[];
Initial.cost =[];
Initial.best.position =[];
Initial.best.cost=[];

globalbest.cost = inf;
particle = repmat(Initial, Swarmsize, 1);

for i  = 1:Swarmsize
    for j=1:nVar
       x(j)=LB(j) + rand()*(UB(j)-LB(j));
    end
    particle(i).position = x; %generate random values
    particle(i).velocity = 0.1.*particle(i).position;      %initialise 0 for velocity
    particle(i).cost = CF(particle(i).position);           %Calculate cost
    particle(i).best.position = particle(i).position;
    particle(i).best.cost = particle(i).cost;
    
    if particle(i).best.cost < globalbest.cost
        globalbest = particle(i).best;
    end       
end
bestcosts = zeros(Itermax, 1);
R1s = zeros(Itermax, 1);
R2s = zeros(Itermax, 1);
X2s = zeros(Itermax, 1);
Xms = zeros(Itermax, 1);
for j = 1:Itermax
    for i = 1:Swarmsize
%         if particle(i).best.position - particle(i).position < 0
%             cu1 = (-1)*c1 ;
%         else
%             cu1 = c1;
%         end
%         if globalbest.position - particle(i).position < 0
%             cu2 = (-1)*c2 ;
%         else
%             cu2 = c2;
%         end
        particle(i).velocity = w * particle(i).velocity + rand(Varsize)*c1.*(particle(i).best.position - particle(i).position)+ rand(Varsize)*c2.*(globalbest.position - particle(i).position);
        particle(i).position = particle(i).position + particle(i).velocity;
        particle(i).cost = CF(particle(i).position);
        if particle(i).cost < particle(i).best.cost
            particle(i).best.position = particle(i).position;
            particle(i).best.cost = particle(i).cost;
                if particle(i).best.cost < globalbest.cost
                   globalbest = particle(i).best;
                end 
        end       
    end
   bestcosts(j) = globalbest.cost;
 R1s(j)=globalbest.position(1)-1.115;
 X2s(j)=globalbest.position(2)-1.126;
 Xms(j)=globalbest.position(3)-38.4;
 R2s(j)=globalbest.position(4)-1.083;
 
 R1(j)=globalbest.position(1);
 X2(j)=globalbest.position(2);
 Xm(j)=globalbest.position(3);
 R2(j)=globalbest.position(4);
 Vph=265.6;
 ws=2*3.1416*2*60/4;
 s=0.021;
 R2n(j)=R2(j)/s;
  Vth(j) = Xm(j) * Vph /(X2(j) + Xm(j));
  k(j) = 3*(Vth(j)^2)/ws;
  Rth(j) = Xm(j)*R1(j)/(Xm(j)+X2(j));
  Xth(j) = Xm(j)*X2(j)/(Xm(j)+X2(j));
  X(j) = Xth(j) + X2(j);
  
  Tflcal(j)= k(j)*(R2n(j))/((X(j)^2)*((Rth(j) + R2n(j))^2));
  Tstcal(j)= k(j)*(R2(j))/((X(j)^2)*((Rth(j) + R2(j))^2)); 
  Tmaxcal(j)= k(j)*(0.5)/(Rth(j) + (Rth(j)^2 + X(j)^2)^0.5 ); 
  Pfcal(j)=cos(atan((Xth(j)+X2(j))/(Rth(j)+R2n(j))));
   w = w*dampc;
end

figure
 plot(Pfcal','linewidth', 2);
 title('Convergence curve of P.F');
 xlabel('Iterations');
 ylabel('P.F');
 
figure
 plot(Tmaxcal','linewidth', 2);
 title('Convergence curve of Maximum Torque');
 xlabel('Iterations');
 ylabel('Maximum Torque');
 
figure
 plot(Tstcal','linewidth', 2);
 title('Convergence curve of Starting Torque');
 xlabel('Iterations');
 ylabel('Starting Torque');
 
figure
 plot(Tflcal','linewidth', 2);
 title('Convergence curve of Full load Torque');
 xlabel('Iterations');
 ylabel('Full load Torque');

figure
 plot(R1s,'linewidth', 2);
 title('Convergence curve of error in R1');
 xlabel('Iterations');
 ylabel('R1');

figure
 plot(R2s,'linewidth', 2);
 title('Convergence curve of R2');
 xlabel('Iterations');
 ylabel('error in R2'); 

figure
 plot(X2s,'linewidth', 2);
 title('Convergence curve of error in X2');
 xlabel('Iterations');
 ylabel('Error in X2');
 
figure
 plot(Xms,'linewidth', 2);
 title('Convergence curve of error in Xm');
 xlabel('Iterations');
 ylabel('Error in Xm');
 
figure
 plot(bestcosts,'linewidth', 2);
 title('Convergence curve');
 xlabel('Iterations');
 ylabel('Costs');
 
 aR1=globalbest.position(1);
 aX2=globalbest.position(2);
 aXm=globalbest.position(3);
 aR2=globalbest.position(4);
 