function [price_electricity] = economic_fast(Pl,cwh,p_npv,nwt)
% initial cost
WT_C=2000;
PV_C=3400;
BAT_C=280;
DSL_C=1000;
INV_C=2500;
PV_reg=1500;
Wind_reg=1000;
%ROD
%ROD_C=532; %$/m^3
%VT_C=255.4; %$/M^3
%C_MNT=0.2;% $/M3
%C_MR=0.06;%$/M3
%N=2;
%C_CH=0.06;%$/M3
%economic index
REAL_INTREST=12;
%life time
WT_LF=24;
PV_LF=24;
BAT_LF=12;
DSL_LF=24000;
INV_LF=24;
PRJ_LF=24;
%Opeartion & mainentance (O&M)
OM_PV=0.01;
OM_WT=0.03;
OM_BAT=0.01;
%rated power
WT_P=2;
%PV_P=7.3;
PV_P=p_npv;%for sensivity analysis for pv
BAT_P=cwh;%for sensivity analysis for autonomy days
%ROD_capacity=10; %m^3
%VT_capacity=2*ROD_capacity;
%DSL_P=4;
%% economic analysis
%diesel*************************A*************************************8
%[i,j,k]=find(diesel);
% k=sum(k/4);%4 is because i set diesel on 4 when it will be turn on
% fuel_consumption=Fg*k;%feul consuption in one year for diesel
% k=DSL_LF/k;%year life time
% if k<PRJ_LF
%     n=floor(PRJ_LF/k);%n is number of repalcement for diesel in project life time
%     price_d=DSL_C*DSL_P*n; 
%else
%    k_d=PRJ_LF;
%    price_d=DSL_C*DSL_P;
% end
 
 %battery************A**************A*********************A************************
k=floor(PRJ_LF/BAT_LF);
price_b=BAT_C*BAT_P*k;
% economic analysis
% initial cost
initial_cost=WT_C*WT_P*nwt+PV_C*PV_P+price_b+INV_C+PV_reg+Wind_reg;
% O&M cost;
sum1=0;
for kk=0:23
  sum1=sum1+(1/(1+(REAL_INTREST/100))^kk);  
end
OM_PV=(WT_C*WT_P*nwt)*OM_PV;
OM_WT=(PV_C*PV_P)*OM_WT;
OM_BAT=price_b*OM_BAT;
%%ROD 
%OM_ROD=ROD_capacity*C_MNT*sum1;
%TC_MR=N*ROD_capacity*C_MR*sum1;
%TC_CH=ROD_capacity*C_CH*sum1;
%OM_ROD=OM_ROD+TC_MR+TC_CH;
OM=OM_PV+OM_WT+OM_BAT;
initial_cost=initial_cost+OM;%addind operation and maintanence cost
i=REAL_INTREST/100;%real interest rate=monetary interest rate-rate of inflation
Anual_cost=initial_cost*((i*(1+i)^PRJ_LF)/(((1+i)^PRJ_LF)-1));
%i=REAL_INTREST/100;%feul real interest rate=monetary interest rate-rate of inflation
%Anual_cost_fuel=fuel_consumption*PRJ_LF*((i*(1+i)^PRJ_LF)/(((1+i)^PRJ_LF)-1))*0.13;
%Anual_cost=Anual_cost%+Anual_cost_fuel;
Anual_load=sum(Pl);
price_electricity=Anual_cost/Anual_load;
end