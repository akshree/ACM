function F = sq(p)
 Vph=265.6;
 ws=188.496;
 s=0.021;
 Tst = 49.6264;
 Tmax =149.1091;
 Tn= 3.9997;
 Pf=0.9991;
 
 R1=p(1);
 X2=p(2);
 Xm=p(3);
 R2=p(4);
 R2n=R2/s;
  Vth = Xm* Vph /(X2 + Xm);
  k = 3*(Vth^2)/ws;
  Rth = Xm*R1/(Xm+X2);
  Xth = Xm*X2/(Xm+X2);
  X = Xth + X2;
  
  Tncal= k*(R2n)/((X^2)*((Rth + R2n)^2));
  Tstcal= k*(R2)/((X^2)*((Rth + R2)^2)); 
  Tmaxcal= k*(0.5)/(Rth + (Rth^2 + X^2)^0.5 ); 
  Pfcal=cos(atan((Xth+X2)/(Rth+R2n)));
  
  f= [1 4];
  f(1)= (Tn - Tncal)/ Tn ;
  f(2)= (Tst - Tstcal)/ Tst ;
  f(3)= (Tmax - Tmaxcal)/ Tmax ;
  f(4)= (Pf - Pfcal)/ Pf ;
  F = sum(f.^2);
end