clear all
close all
clc
houses=15;   % number of houses
p_npv=45;%x(1); % pv output kw
ad=5;%x(2);    % dayes of autonomy
nwt=10;%x(3);   % number of wind trbine
%nPng=x(4);%ceil(x(4));  % number of deisel generator
%% 1)load inputs   (meteorological data)
wind_speed=load('berenicewindspeed.txt'); %hourly wind speed (m/s)
solar_radiation=load('berenicesolarradation.txt'); %hourly solar radiation(w)
tamb=load('berenicetemprture.txt'); %hourly temprture
%% solar power
tamb2=tamb;%temperature of nahavand on each hour;
%p_npv=7.3;%kW >>0.130w each pv,14 pv in string;%rated power at reference condition
g=solar_radiation./1000;%hourly_solar_radiation_nahavand';%kW
gref=1 ;%1000kW/m^2
tref=25;%temperature at reference condition
kt=-3.7e-3;% temperature coefficient of the maximum power(1/c0)
tc=tamb2+(0.0256).*g;
upv=0.986;%efficiency of pv with tilted angle>>98.6%
p_pvout_hourly=upv*(p_npv.*(g/gref)).*(1+kt.*(tc-tref));%output power(kw)_hourly
clear tc
clear tamb2
clear g
%% ROD
s_dc=4;  %kwh/m^3
H_wds=[0.1 0.1 0.1 0.1 0.1 0.1 0.7 0.7 0.7 0.4 0.4 0.5 0.7 0.7 0.7 0.4 0.4 0.4 0.7 0.7 0.7 0.4 0.1 0.1 ];
H_wdw=[0.1 0.1 0.1 0.1 0.1 0.1 0.2 0.68 0.68 0.68 0.4 0.4 0.4 0.68 0.68 0.68 0.4 0.4 0.4 0.68 0.68 0.68 0.4 0.14 ];

p_dem=H_wdw*s_dc; % hourly energy demand kw
%% battery
%#######inputs##############inputs####################inputs##
load1=[1.5 1 0.5 0.5 1 2 2 2.5 2.5 3 3 5 4.4 4 3.43 3 1.91 2.48 3 3 3.42 3.44 2.51 2];
load1=load1/5; load1=load1*2;% maximum would be 2kW mean is 1kW
%the load curve of a typical complete day's consumption, palestin case study
%load1=[1 1 1 1 1.5 2 2.5 2.5 1.5 1.5 1.5 2 2 2.5 2.5 3 3.5 4 4 3.5 2.5 1.5 1 1];
%houses=1;%number of houses in a village
load2=houses.*load1;%total load in a day for the whole village
%hourly load data for one year
a1=0;
for i=1:1:360
     a1=[a1,load2];   
end
a1(1)=[];
a2=0;
for i=1:1:360
     a2=[a2,p_dem];   
end
a2(1)=[];
a=a1+a2;
Pl1=a;
uinv=0.92; %inverter efficincy
ub=0.85;   % battery efficiency
dod=0.8;   %depth of discharge 0.5 0.7 in the article 80%
el=mean(load2);%2.5775; %mean(load2);(mean dialy load)kw
cwh=(el*ad)/(uinv*ub*dod);%storage capacity for battery,bmax,kW
%% wind turbine
%% inputs
h2=6;  %hub hight
h0=10; %reference hight 
alfa=0.25;
rw=4;%blades diameter(m)
aw=pi*(rw)^2;%Swept Area>>pi x Radius? = Area Swept by the Blades
uw=0.95;%efficiency
vco=40;%cut out speed
vci=2.5;%cut in
vr=8;%%rated speed(m/s)
pr=2;%rated power(kW)
pmax=2.5;%maximum output power(kW)
pfurl=2.5;%output power at cut-out speed9kW)
v1=wind_speed;
v2=((h2/h0)^(alfa))*v1;
%% diesel generator
%Png=4;Png=nPng*Png;%kW output power of diesel generator
%Bg=0.08145;%1/kW
%Ag=0.246;%1/kW
%Pg=4;Pg=nPng*Pg;%nominal power kW
%%fuel consumption of the diesel generator
%Fg=Bg*Pg+Ag*Png;
%% MAIN PROGRAM
contribution=zeros(5,8640);%pv,wind, battery, diesel contribution in each hour
Ebmax=cwh;%40kWh%battery capacity 40 kWh
Ebmin=cwh*(1-dod);%40kWh
SOCb=0.2;%state of charge of the battery>>20%
Eb=zeros(1,8640);
time1=zeros(1,8640);
diesel=zeros(1,8640);
Edump=zeros(1,8640);
Edch=zeros(1,8640);
Ech=zeros(1,8640);
Eb(1,1)=SOCb*Ebmax;%state of charge for starting time
%^^^^^^^^^^^^^^START^^^^^^^^^^^^^^^^^^^^^^^^
Pl=Pl1;
clear Pl1;
%^^^^^^^^^^Out put power calculation^^^^^^^^
%solar power calculation
Pp=p_pvout_hourly;%output power(kw)_hourly
for i=1:1:8640
    if Pp(i)>p_npv
        Pp(i)=p_npv;%if the power output of pv  exceed the maximum
    end
end
% wind power calculation
for t=1:1:8640
    %pr *((v2(t)-vci)/(vr-vci))^3pr+(((pfurl-pr)/(vco-vr))*(v2(t)-vr));
if v2(t)<vci %v2>>hourly_wind_speed;
        pwtg(t)=0;
    elseif vci<=v2(t)&& v2(t)<=vr
        pwtg(t)=(pr/(vr^3-vci^3))*(v2(t))^3-(vci^3/(vr^3-vci^3))*(pr);
    elseif vr<=v2(t) &&v2(t)<=vco
        pwtg(t)=pr;
    else 
        pwtg(t)=0;
end
Pw(t)=pwtg(t)*uw*nwt;%electric power from wind turbine
end
 
for t=2:1:8640
%^^^^^^^^^^^^^^READ INPUTS^^^^^^^^^^^^^^^^^^

%^^^^^^^^^^^^^^COMPARISON^^^^^^^^^^^^^^^^^^^
if Pw(t)+Pp(t)>=(Pl(t)/uinv)
    %^^^^^^RUN LOAD WITH WIND TURBINE AND PV^^^^^^
     
    if Pw(t)+Pp(t)>Pl(t)
        %^^^^^^^^^^^^^^CHARGE^^^^^^^^^^^^^^^^^^^^^^^^^^
        
       [Edump,Eb,Ech] = charge(Pw,Pp,Eb,Ebmax,uinv,Pl,t,Edump,Ech); 
       time1(t)=1;
      contribution(1,t)=Pp(t);contribution(2,t)=Pw(t);contribution(3,t)=Edch(t);%contribution(4,t)=diesel(t);contribution(5,t)=Edump(t);
    else
        Eb(t)=Eb(t-1);
        return
    end
    
else
   %^^^^^^^^^^^^^^DISCHARGE^^^^^^^^^^^^^^^^^^^
   [Eb,Edump,Edch,time1,t] = dicharge(Pw,Pp,Eb,uinv,Pl,t,Ebmin,Edump,Edch,time1);
   contribution(1,t)=Pp(t);contribution(2,t)=Pw(t);contribution(3,t)=Edch(t);%contribution(4,t)=diesel(t);contribution(5,t)=Pl(t);

end



end
%% plotting

figure(1)
a=contribution';
b=sum(a);
%g=1-b(4)/(b(1)+b(2));%renewable_factor(>=0.01)
 h=pie(b);
 colormap jet;
 legend('PV','WIND','BATTERY');

%reliability
%lose of load probability=sum(load-pv-wind+battery)/sum(load)
total_loss=0;
for t=2:1:8640
%     aa(t)=Pl(t)-Pp(t)-Pw(t)+Eb(t);
    if Pl(t)>((Pp(t)+Pw(t)+(Eb(t-1)-Ebmin)))
       total_loss=total_loss+(Pl(t)-((Pp(t)+Pw(t)+(Eb(t-1)-Ebmin))));
    end
    
end
LPSP=total_loss/(sum(Pl))
% reliability=sum(aa)/sum(Pl);
% [price_electricity] = economic(diesel,Pl,Fg,cwh);
COE=economic_fast(Pl,cwh,p_npv,nwt)
  %ali=[Pp(1:168),Pw(1:168)',Eb(1:168)',diesel(1:168)',Pl(1:168)',Edump(1:168)'];
 %Edump=sum(Edump);
%o(3)=b(4)/(b(1)+b(2));
 % Penalty constant
%lam=10^15;
% if g>=0.01,
%     H=0;
% else
%     H=1;
% end
% z=lam*g^2*H;
% o=o+z;
figure(2)
subplot(2,2,1),plot(Pp(1:720)),xlabel('hour'),ylabel('pv_output (kw)')
subplot(2,2,2),plot(Pw(1:720)),xlabel('hour'),ylabel('wind_output (kw)')
subplot(2,2,3),plot(Eb(1:720)),xlabel('hour'),ylabel('battery (kw)')
subplot(2,2,4),plot(a2(1:720)),xlabel('hour'),ylabel('Desalination power (kw)')
