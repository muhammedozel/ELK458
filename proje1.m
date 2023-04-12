Po=250;
Vinmin=3;
Vinmax=60;
Vomin=12;
Vomax=24;
n=0.95;
fsw=300000;

Vin=round(Vinmin+(Vinmax-Vinmin)*rand(1,1));
Vo=round(Vomin+(Vomax-Vomin)*rand(1,1));
Io=Po/Vo;
R=Po/Io;
T=1/fsw;
Dbuck=Vomax/(Vinmax*n);
Dboost=1-(Vinmin*n)/Vomax;
if Vin>Vo
    D1=Dbuck*99.99;
    D2=(1-Dbuck)*99.99;
    D3=1*99.99;
    D4=0.00000001;
    D2_d=T*Dbuck;
    D3_d=0.00000001;
else 
    D1=1*99.99;
    D2=0.00000001;
    D3=(1-Dboost)*99.99;
    D4=Dboost*99.99;
    D2_d=0.00000001;
    D3_d=T*Dboost;
end

Kind=0.3;
Lbuck=Vo*(Vinmax-Vo)/(Kind*fsw*Vinmax*Io); 
Lboost=Vinmin^2*(Vo-Vinmin)/(fsw*Kind*Io*Vo^2); 
dImaxbuck=(Vinmin-Vo)*Dbuck/(fsw*Lbuck);
Iswmaxbuck=dImaxbuck/2+Io;
dImaxboost=Vinmin*Dboost/(fsw*Lboost);
Iswmaxboost=dImaxboost/2+Io/(1-Dboost);
Voutripple=Vo*0.005;
Cbuck=Kind*Io/(8*fsw*Voutripple);
Cboost=Io*Dboost/(fsw*Voutripple);

if Lbuck>=Lboost
    L=Lbuck;
else
    L=Lboost;
end

if Cbuck>=Cboost
    C=Cbuck;
else 
    C=Cboost;
end


Lboostmin=Vinmin^2*(Vomin-Vinmin)/(fsw*Kind*Io*Vo^2);
deltaIlboost=Vinmin*Dboost/(fsw*Lboostmin);
Ilmaxboost=deltaIlboost/2+Io/(1-Dboost);
Ilminboost=-deltaIlboost/2+Io/(1-Dboost);
Lbuckmin=Vomin*(Vinmax-Vomin)/(Kind*fsw*Vinmax*Io);
deltaIlbuck=(Vinmin-Vo)/(fsw*Lbuckmin);
Ilmaxbuck=deltaIlbuck/2+Io;
Ilminbuck=-deltaIlbuck/2+Io;

Ipeak=Io+deltaIlbuck/2;
Bmax=0.25;
ku=0.8;
Ki=1;
Kt=48.2*10^3;
dT=15;
gamma=0;
Vc=11.8*10^-6;
L1=5.12*10^-6;
lc=6.9*10^-2;
Wa=1.51*10^-4;
row=1.72*10^-8;
MLT=3.3*10^-2;
mu0=4*pi*10^-7;
Al=56*10^-9;
alfa=1.25;
beta=2.35;
Kc=16.9;

dIL=(Vinmax-Vomin)*Dbuck*T/L1;
L1=Vomin*(Vinmax-Vomin)/(Kind*fsw*Vinmax*(Po/Vomin));
I=Po/Vomin+dIL/2;
LI2=L1*I^2;
Ap=((sqrt(1+gamma)*Ki*LI2)/(Bmax*Kt*sqrt(ku*dT)))^(8/7)*10^8;
Ac=84*10^-6;
Rteta=0.06/sqrt(Vc);
Pd=dT/Rteta;
muopt=(Bmax*lc*Ki)/(mu0*sqrt((Pd*ku*Wa)/(row*MLT)));
mumax=lc/muopt;
N=sqrt(L1/Al);
dB=((Vinmax-Vomin)*Dbuck*T)/(N*Ac);
Pfe=Vc*Kc*fsw^alfa*(dB/2)^beta;

gmax=(lc/muopt)*10^3;
Ap2=2.49;
Jo=Kt*(sqrt(dT))/(sqrt(ku*(1+gamma))*(Ap2*10^-8)^(1/8))*10^-4;
Iomax=Po/Vomin;
Aw=Iomax/Jo;
N1=9;
Rdcwire=10.75*10^-6;
alpha20=0.00393;
Tmax=85;
Rdc=N1*MLT*10^2*Rdcwire*(1+alpha20*(Tmax-20))*10^3;
Pcu=Rdc*10^-3*Iomax^2;