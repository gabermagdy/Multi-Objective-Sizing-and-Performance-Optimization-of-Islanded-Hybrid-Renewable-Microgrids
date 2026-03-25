function [Eb,Edump,Edch,time1,t] = dicharge(Pw,Pp,Eb,uinv,Pl,t,Ebmin,Edump,Edch,time1)
 %^^^^^^^^^^^^^^DISCHARGE^^^^^^^^^^^^^^^^^^^
    Pdch(t)=(Pl(t)/uinv)-(Pw(t)+Pp(t));
    Edch(t)=Pdch(t)*1;%one hour iteration time
    
    if(Eb(t-1)-Ebmin)>=(Edch(t))
        Eb(t)=Eb(t-1)-Edch(t);
        time1(t)=2;
         return
    else
     Eb(t)=Ebmin;   
        %run load with diesel generator and renewable sources
        %^^^^^^^^^^^^^^^RUN DIESEL GENERATOR ^^^^^^^^^^^^^^
       %[Eb,Edump,diesel,t] = RunDieselGenerator(Pw,Pp,Eb,Ebmax,uinv,Pl,t,Pg,Edump,Edch,Ech,diesel,Ebmin);
       
       
    end
            
end

