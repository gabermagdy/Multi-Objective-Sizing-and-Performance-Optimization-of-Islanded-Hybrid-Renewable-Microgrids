function [Edump,Eb,Ech] = charge(Pw,Pp,Eb,Ebmax,uinv,Pl,t,Edump,Ech)
 %^^^^^^^^^^^^^^CHARGE^^^^^^^^^^^^^^^^^^^^^^^^^^
        Pch(t)=(Pw(t)+Pp(t))-(Pl(t)/uinv);
        Ech(t)=Pch(t);%*1;%one hour iteration time
        if Ech(t)<=Ebmax-Eb(t-1)
            Eb(t)=Eb(t-1)+Ech(t);
            
            if Eb(t)>Ebmax%khodam
                    Eb(t)=Ebmax;
                    Edump(t)=Ech(t)-(Ebmax-Eb(t-1));
                    
            else
                    Edump(t)=0;
            end%khodam
            return
        else
            Eb(t)=Ebmax;
            Edump(t)=Ech(t)-(Ebmax-Eb(t-1));
            return
        
        end
end