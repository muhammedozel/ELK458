Po = 250;
Vinmin = 2.5;
Vinmax = 60;
Vomin = 12;
Vomax = 24;
n = 0.95;
fsw = 500000;

% Rastgele giriş ve çıkış gerilimlerini hesapla
Vin = round(Vinmin + (Vinmax - Vinmin) * rand(1, 1));
Vo = round(Vomin + (Vomax - Vomin) * rand(1, 1));

% Çıkış akımı (Io), direnç (R) ve anahtarlama periyodu (T) hesaplamaları
Io = Po / Vo;
R = Po / Io;
T = 1 / fsw;

% Giriş ve çıkış gerilimlerine göre buck ve boost görev döngülerini belirle
Dbuck = Vo / (Vinmax * n);
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
Lbuck = Vo * (Vinmax - Vo) / (Kind * fsw * Vinmax * Io);
Lboost = Vinmin ^ 2 * (Vo - Vinmin) / (fsw * Kind * Io * Vo ^ 2);

% Buck ve boost modları için akım çırpıntısı hesaplamaları
dImaxbuck = (Vinmin - Vo) * Dbuck / (fsw * Lbuck);
Iswmaxbuck = dImaxbuck / 2 + Io;
dImaxboost = Vinmin * Dboost / (fsw * Lboost);
Iswmaxboost = dImaxboost / 2 + Io / (1 - Dboost);

% Çıkış gerilimi çırpıntısı
Voutripple = Vo * 0.005;

% Buck ve boost modları için kapasitans değerlerini hesapla (Cbuck, Cboost)
Cbuck = Kind * Io / (8 * fsw * Voutripple);
Cboost = Io * Dboost / (fsw * Voutripple);

% Buck ve boost modlarından daha büyük endüktans (L) ve kapasitans (C) değerlerini seç
if Lbuck >= Lboost
    L = Lbuck;
else
    L = Lboost;
end

if Cbuck >= Cboost
    C = Cbuck;
else
    C = Cboost;
end

% Buck ve boost modları için minimum endüktans değerlerini hesapla
Lboostmin = Vinmin ^ 2 * (Vomin - Vinmin) / (fsw * Kind * Io * Vo ^ 2);
deltaIlboost = Vinmin * Dboost / (fsw * Lboostmin);
Ilmaxboost = deltaIlboost / 2 + Io / (1 - Dboost);
Ilminboost = -deltaIlboost / 2 + Io / (1 - Dboost);
Lbuckmin = Vomin * (Vinmax - Vomin) / (Kind * fsw * Vinmax * Io);
deltaIlbuck = (Vinmin - Vo) / (fsw * Lbuckmin);
Ilmaxbuck = deltaIlbuck / 2 + Io;
Ilminbuck = -deltaIlbuck / 2 + Io;

% Zirve akım değerini hesapla
Ipeak = Io + deltaIlbuck / 2;

% Maksimum manyetik akı yoğunluğunu hesapla
Bmax = 0.25;

% Diğer sabitler
ku = 0.8;
Ki = 1;
Kt = 48.2 * 10 ^ 3;
dT = 15;
gamma = 0;
Vc = 11.8 * 10 ^ -6;
L1 = 5.12 * 10 ^ -6;
lc = 6.9 * 10 ^ -2;
Wa = 1.51 * 10 ^ -4;
row = 1.72 * 10 ^ -8;
MLT = 3.3 * 10 ^ -2;
mu0 = 4 * pi * 10 ^ -7;
Al = 56 * 10 ^ -9;
alfa = 1.25;
beta = 2.35;
Kc = 16.9;

% Manyetik bileşenler için hesaplamalar
dIL = (Vinmax - Vomin) * Dbuck * T / L1;
L1 = Vomin * (Vinmax - Vomin) / (Kind * fsw * Vinmax * (Po / Vomin));
I = Po / Vomin + dIL / 2;
LI2 = L1 * I ^ 2;
Ap = ((sqrt(1 + gamma) * Ki * LI2) / (Bmax * Kt * sqrt(ku * dT))) ^ (8/7) * 10 ^ 8;
Ac = 84 * 10 ^ -6;
Rteta = 0.06 / sqrt(Vc);
Pd = dT / Rteta;
muopt = (Bmax * lc * Ki) / (mu0 * sqrt((Pd * ku * Wa) / (row * MLT)));
mumax = lc / muopt;
N = sqrt(L1 / Al);
dB = ((Vinmax - Vomin) * Dbuck * T) / (N * Ac);
Pfe = Vc * Kc * fsw ^ alfa * (dB / 2) ^ beta;

% Manyetik bileşenler için boyut ve tel özelliklerini hesapla
gmax = (lc / muopt) * 10 ^ 3;
Ap2 = 2.49;
Jo = Kt * (sqrt(dT)) / (sqrt(ku * (1 + gamma)) * (Ap2 * 10 ^ -8) ^ (1/8)) * 10 ^ -4;
Iomax = Po / Vomin;
Aw = Iomax / Jo;
N1 = 9;
Rdcwire = 10.75 * 10 ^ -6;
alpha20 = 0.00393;
Tmax = 85;

% Tel direnci ve bakır kayıplarını hesapla
Rdc = N1 * MLT * 10 ^ 2 * Rdcwire * (1 + alpha20 * (Tmax - 20)) * 10 ^ 3;
Pcu = Rdc * 10 ^ -3 * Iomax ^ 2;
Pt = Pcu + Pfe;

Icout = Iomax * sqrt((Vomax / Vinmin) - 1);
ESR = 0.025;
Pcout = Icout ^ 2 * ESR;

% Eklenen INDUCTANCE değerleri
inductances = {
           'EEU-FS1J181',       180, 0.045, 1256.637061, 2530,000;
           'EEUFR1J181B',       180, 0.035, 1570.79633,  2325;
           'EEU-FC1J181SB',     180, 0.150, 1840.77695,  2880;
           '860080775017',      180, 0.095, 1570.79633,  1865;
           'EEU-FC1J181S',      180, 0.150, 1840.77695,  3625;
           'EEU-FS1J181L',      180, 0.050, 1005.30965,  2110;
           'EEU-FR1J181',       180, 0.035, 1570.79633,  3070;
           '63ZLH180MEFC10X16', 180, 0.110, 1256.63706,  1365;
           'EKZN800ELL181MK16S',180, 0.090, 1963.49541,  2180,00;
           'UPW1J181MPD',       180, 0.147, 1570.79633,  2840;
           'UHE1J181MPD1TD',    180, 0.210, 1570.79633,  1960;
           'EKZE630ELL181MK16S',180, 0.072, 1963.49541,  2370;
           'EKZN800ELL181MK16S',180, 0.090, 1963.49541,  2180;
           '187AVG063MGBJ',     180, 0.028, 942.47780,   2900;
           'UCZ1J181MNS1MS',    180, 0.020, 1656.69925,  3925;
           'UHW1J181MPD1TD',    180, 0.115, 1256.63706,  2005;
           '63ZLJ180M10X16',    180, 0.076, 1256.63706,  1785;
           '860040775009',      180, 0.100, 1570.79633,  2225;                           
                      
           };

% En etkili INDUCTANCE'i seç
loss_weight = 0.7;
cost_weight = 0.3;
[best_inductance, best_score] = select_best_inductance(inductances, loss_weight, cost_weight);

% En etkili INDUCTANCE'i yazdır
fprintf('En Etkili INDUCTANCE: %s\n', best_inductance{1});
fprintf('Gerilim (V): %.2f V\n', best_inductance{2});
fprintf('ESR: %.2f\n', best_inductance{3});
fprintf('Maliyet: %.2f\n', best_inductance{4});

% En etkili INDUCTANCE seçim algoritması
function [best_inductance, best_score] = select_best_inductance(inductances, loss_weight, cost_weight, volume_weight)
    best_inductance = inductances(1, :);
    best_score = Inf;

    for i = 1:size(inductances, 1)
        inductance = inductances(i, :);
        esr = inductance{3};
        volume = inductance{4};
        cost = inductance{5};
        score = loss_weight * esr + cost_weight * cost volume_weight * volume; 

        if score < best_score
            best_inductance = inductance;
            best_score = score;
        end
    end
end

% En etkili INDUCTANCE'i seç
loss_weight = 0.6;
cost_weight = 0.3;
volume_weight = 0.1;
[best_inductance, best_score] = select_best_inductance(inductances, loss_weight, cost_weight, volume_weight);

% En etkili INDUCTANCE'i yazdır
fprintf('En Etkili INDUCTANCE: %s\n', best_inductance{1});
fprintf('Gerilim (V): %.2f V\n', best_inductance{2});
fprintf('ESR: %.2f\n', best_inductance{3});
fprintf('Maliyet: %.2f\n', best_inductance{4});
fprintf('Hacim: %.2f\n', best_inductance{5});
