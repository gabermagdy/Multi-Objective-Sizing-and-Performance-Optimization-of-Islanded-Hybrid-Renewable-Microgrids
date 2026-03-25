%______________________________________________________________________________________
%  Multi-Objective Multi-Verse Optimization (MOMVO) algorithm source codes version 1.0
%
%  Developed in MATLAB R2016a
%
%  Author and programmer: Seyedali Mirjalili
%
%         e-Mail: ali.mirjalili@gmail.com
%                 seyedali.mirjalili@griffithuni.edu.au
%
%       Homepage: http://www.alimirjalili.com
%
%   Main paper:
%   S. Mirjalili, P. Jangir, S. Z. Mirjalili, S. Saremi, and I. N. Trivedi
%   Optimization of problems with multiple objectives using the multi-verse optimization algorithm, 
%   Knowledge-based Systems, 2017, DOI: http://dx.doi.org/10.1016/j.knosys.2017.07.018
%______________________________________________________________________________________

clear all;
close all;
clc;
% format long g
% Initial parameters of the MODA algorithm
max_iter=10;
N=20;
ArchiveMaxSize=100;
fobj=@obj_function5;%Obj_function;
lb=[15 1 0 ];%[0.125 0.1  0.1 0.125];
ub=[45 5 10  ];%[5.0 10.0 10.0 5.0];
obj_no=2;
dim=length(lb);%4;
addpath('MO_Methods');
addpath('MO_Methods/NSGA-III');
addpath('MO_Methods/MODE');
addpath('MO_Methods/MODA');
MethodNames{1}='NSGA-III';
MethodNames{2}='MODA';
MethodNames{3}='MODE';
nMethods=length(MethodNames);
NTRIALS=1;                     %NUMBER OF TRIALS
%-------------------------- MOMVO -----------------------------------------
for j=1:nMethods
    for M=1:NTRIALS % Numbver of independent runs
        switch MethodNames{j}
            case 'MODE'
                [Archive_F,Archive_X]=MODE(N,max_iter,lb,ub,dim,fobj,obj_no);
            case 'MODA'
                [Archive_F,Archive_X]=MODA(N,max_iter,lb,ub,dim,fobj,obj_no,ArchiveMaxSize);
            case 'NSGA-III'
                [Archive_F,Archive_X]=nsga3(N,max_iter,lb,ub,dim,fobj,obj_no);
        end
    end

%% plot the last trail    
switch MethodNames{j}
    case 'MODE'
        figure(1),plot(Archive_F(:,1),Archive_F(:,2),'o','MarkerSize',6,'markerfacecolor','r'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'b*','MarkerSize',8);hold on
         
    case 'MODA'
        figure(1),plot(Archive_F(:,1),Archive_F(:,2),'h','MarkerSize',6,'markerfacecolor','b'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'r*','MarkerSize',8,'markerfacecolor','b');
        
    case 'NSGA-III'
        figure(1),plot(Archive_F(:,1),Archive_F(:,2),'s','MarkerSize',6,'markerfacecolor','k'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'m*','MarkerSize',8,'markerfacecolor','k');
         
end
end
legend(MethodNames,'Location','northeast')
xlabel('LPSP');
ylabel('COE($/KWH)');
%zlabel('RF');
grid on

  format short
  PV=Archive_X(:,1);
  AD=Archive_X(:,2);
  WT=ceil(Archive_X(:,3));
  NR0=ceil(Archive_X(:,4));
  %Diesel=Archive_X(:,4);
  COE=Archive_F(:,2);
  LPSP=Archive_F(:,1);
  %RF=1-Archive_F(:,3);
  RESULTS=table(PV,AD,WT,NR0,COE,LPSP)
