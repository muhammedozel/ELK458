Po = 250;
Vinmin = 5;
Vinmax = 20;
Vomin = 11;
Vomax = 13;
n = 0.95;
fsw = 300000;

% Rastgele giriş ve çıkış gerilimlerini hesapla
Vin = round(Vinmin + (Vinmax - Vinmin) * rand(1, 1));
Vo = round(Vomin + (Vomax - Vomin) * rand(1, 1));

% Çıkış akımı (Io), direnç (R) ve anahtarlama periyodu (T) hesaplamaları
Io = Po / Vomax;
R = Po / Io;
T = 1 / fsw;

% Giriş ve çıkış gerilimlerine göre buck ve boost görev döngülerini belirle
Dbuck = Vomax / (Vinmax * n);
Dboost = 1 - (Vinmin * n) / Vomax;

% Giriş ve çıkış gerilimlerine göre D1, D2, D3 ve D4 hesaplamaları
if Vin > Vo
    D1 = Dbuck * 99.99;
    D2 = (1 - Dbuck) * 99.99;
    D3 = 1 * 99.99;
    D4 = 0.00000001;
    D2_d = T * Dbuck;
    D3_d = 0.00000001;
else
    D1 = 1 * 99.99;
    D2 = 0.00000001;
    D3 = (1 - Dboost) * 99.99;
    D4 = Dboost * 99.99;
    D2_d = 0.00000001;
    D3_d = T * Dboost;
end

% Endüktans ve kapasitans hesaplamaları için sabit
Kind = 0.3;

% Buck ve boost modları için endüktans değerlerini hesapla (Lbuck, Lboost)
Lbuck = Vomax * (Vinmax - Vomax) / (Kind * fsw * Vinmax * Io);
Lboost = Vinmin ^ 2 * (Vomax - Vinmin) / (fsw * Kind * Io * Vomax ^ 2);

% Buck ve boost modları için en yüksek anahtar akımının hesaplanması
dImaxbuck = (5 - 13) * Dbuck / (fsw * Lbuck);
Iswmaxbuck = dImaxbuck / 2 + Io;
dImaxboost = 5 * Dboost / (fsw * Lboost);
Iswmaxboost = dImaxboost / 2 + Io / (1 - Dboost);





