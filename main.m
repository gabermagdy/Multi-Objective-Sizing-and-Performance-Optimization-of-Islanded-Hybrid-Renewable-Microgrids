close all;
clearvars;
% clc;
% format long g
% Initial parameters of the MODA algorithm
%-------------------------- System parameters -----------------------------------------
%-------------------------- Optimization parameters -----------------------------------------
max_iter=10;
NTRIALS=1;                     %NUMBER OF TRIALS
N=30;
ArchiveMaxSize=N;
fobj=@obj_function5;%Obj_function;
lb=[15 1 0 1];%[0.125 0.1  0.1 0.125];
ub=[45 5 10 4];%[5.0 10.0 10.0 5.0];
obj_no=3;
dim=length(lb);%4;
%-------------------------- Optimization Methods -----------------------------------------
addpath('MO_Methods');
addpath('MO_Methods/NSGA-III');
addpath('MO_Methods/MODE');
addpath('MO_Methods/MODA');
% MethodNames{1}='hybrid';
MethodNames{1}='NSGA-III';
MethodNames{2}='MODA';
MethodNames{3}='MODE';
nMethods=length(MethodNames);

%-------------------------- MOMVO -----------------------------------------
for j=1:nMethods
    for M=1:NTRIALS % Numbver of independent runs
        switch MethodNames{j}
            case 'hybrid'
                [Archive_F,Archive_X]=hybrid(N,max_iter,lb,ub,dim,fobj,obj_no);
            case 'MODE'
                [Archive_F,Archive_X]=MODE(N,max_iter,lb,ub,dim,fobj,obj_no);
            case 'MODA'
                [Archive_F,Archive_X]=MODA(N,max_iter,lb,ub,dim,fobj,obj_no,ArchiveMaxSize);
            case 'NSGA-III'
                [Archive_F,Archive_X]=nsga3(N,max_iter,lb,ub,dim,fobj,obj_no);
        end
        format short
        PV=Archive_X(:,1);
        AD=Archive_X(:,2);
        WT=ceil(Archive_X(:,3));
        Diesel=round(Archive_X(:,4));
        COE=Archive_F(:,2);
        LPSP=Archive_F(:,1);
        RF=1-Archive_F(:,3);
%         RESULTS_MODE=table(PV,AD,WT,Diesel,COE,LPSP,RF)
        
    end

%% plot the last trail    
switch MethodNames{j}
    case 'hybrid'
        figure(1),plot3(Archive_F(:,1),Archive_F(:,2),Archive_F(:,3),'s','MarkerSize',6,'markerfacecolor','k'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'m*','MarkerSize',8,'markerfacecolor','k');
             RESULTS_hybrid=table(PV,AD,WT,Diesel,COE,LPSP,RF)
    case 'MODE'
        figure(1),plot3(Archive_F(:,1),Archive_F(:,2),Archive_F(:,3),'o','MarkerSize',6,'markerfacecolor','r'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'b*','MarkerSize',8);hold on
            RESULTS_MODE=table(PV,AD,WT,Diesel,COE,LPSP,RF)
     
    case 'MODA'
        figure(1),plot3(Archive_F(:,1),Archive_F(:,2),Archive_F(:,3),'h','MarkerSize',6,'markerfacecolor','b'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'r*','MarkerSize',8,'markerfacecolor','b');
               RESULTS_MODA=table(PV,AD,WT,Diesel,COE,LPSP,RF)
 
    case 'NSGA-III'
        figure(1),plot3(Archive_F(:,1),Archive_F(:,2),Archive_F(:,3),'s','MarkerSize',6,'markerfacecolor','k'); hold on
%         figure(1),plot3(FMIN(:,1),FMIN(:,2),FMIN(:,3),'m*','MarkerSize',8,'markerfacecolor','k');
             RESULTS_NSGA_III=table(PV,AD,WT,Diesel,COE,LPSP,RF)
    
end
end
legend(MethodNames,'Location','northeast')
xlabel('LPSP');
ylabel('COE($/KWH)');
zlabel('RF');
grid on

% houses=15;   % number of houses
% % PV system
% gref=1 ;%1000kW/m^2
% tref=25;%temperature of the PV cell at reference condition (STC)
% kt=-3.7e-3;% temperature coefficient of the maximum power(1/c0)
% upv=0.986;%efficiency of pv with tilted angle>>98.6%
% s_dc=4;  %kwh/m^3
% uinv=0.92; %inverter efficincy
% ub=0.85;   % battery efficiency
% dod=0.8;   %depth of discharge 0.5 0.7 in the article 80%
% h2=6;  %hub hight
% h0=10; %reference hight 
% alfa=0.25;
% rw=4;%blades diameter(m)
% aw=pi*(rw)^2;%Swept Area>>pi x Radius? = Area Swept by the Blades
% uw=0.95;%efficiency
% vco=40;%cut out speed
% vci=2.5;%cut in
% vr=8;%%rated speed(m/s)
% pr=2;%rated power(kW)
% pmax=2.5;%maximum output power(kW)
% pfurl=2.5;%output power at cut-out speed9kW)
% Bg=0.08145;%1/kW
% Ag=0.246;%1/kW
% Pg=4;%nominal power kW
% SOCb=0.2;%state of charge of the battery>>20%
% % initial cost
% WT_C=2000;
% PV_C=3400;
% BAT_C=280;
% DSL_C=1000;
% INV_C=2500;
% PV_reg=1500;
% Wind_reg=1000;
% %economic index
% REAL_INTREST=12;
% %life time
% WT_LF=24;
% PV_LF=24;
% BAT_LF=12;
% DSL_LF=24000;
% INV_LF=24;
% PRJ_LF=24;
% %Opeartion & mainentance (O&M) of pv and wind
% OM_pv=1;
% OM_wind=3;
% OM_battery=1;
% %running cost of diesel 
% OM=20;
% %rated power
% WT_P=2;
% %PV_P=7.3;
% PV_P=p_npv;%for sensivity analysis for pv
% BAT_P=cwh;%for sensivity analysis for autonomy days
% DSL_P=4;
% 
% Sys_Parameters=[];
%   
