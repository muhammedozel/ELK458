Vth=Vgs1*sqrt(Id2)-Vgs2*sqrt(Id1)/(sqrt(Id2)-sqrt(Id1));
Uplateau=Vth+sqrt(Id/(Id1/(Vgs1-Vth)^2));
tfu1=(Udd-Rdson*Idon)*Rg*Cgd1/(Udr-Uplateau);
tfu2=(Udd-Rdson*Idon)*Rg*Cgd2/(Udr-Uplateau);
tfu=(tfu1+tfu2)/2;
tfu1=(Udd-Rdson*Idon)*Rg*Cgd1/Uplateau;
tfu2=(Udd-Rdson*Idon)*Rg*Cgd2/Uplateau;
tru=(tru1+tru2)/2;
%Mosfet kayıpları
%iletim kaybı
Piletim(t)=Rdson*Id^2;

%anahtarlama kaybı

Ig=tf/Qgd;
Psw=Vds*Id*fsw*(Qgs*Qgd/Ig);
Pdrr=1/4*Qrr*Vds*fsw;
Pg=Qg*Vgs*fsw
ESR1 = DF/(2*fsw*C*3.14);
        Pcout = Icout ^ 2 * ESR1;