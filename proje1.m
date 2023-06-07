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

% Buck ve boost modları için en yüksek anahtar akımının hesaplanması
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
deltaIlbuck = ((Vinmin - Vo)*Dbuck)/ (fsw * Lbuckmin);
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


% Eklenen CAPACITOR değerleri
capacitors = {
    'EEU-FS1J181',        0.045, 0.09, 1256.637061, 2530;
    'EEUFR1J181B',        0.035, 0.09, 1570.79633,  2325;
    'EEU-FC1J181SB',      0.150, 0.08, 1840.77695,  2880;
    '860080775017',       0.095, 0.08, 1570.79633,  1865;
    'EEU-FC1J181S',       0.150, 0.08, 1840.77695,  3625;
    'EEU-FS1J181L',       0.050, 0.09, 1005.30965,  2110;
    'EEU-FR1J181',        0.035, 0.09, 1570.79633,  3070;
    '63ZLH180MEFC10X16',  0.110, 0.09, 1256.63706,  1365;
    'EKZN800ELL181MK16S', 0.090, 0.09, 1963.49541,  2180;
    'UPW1J181MPD',        0.147, 0.09, 1570.79633,  2840;
    'UHE1J181MPD1TD',     0.210, 0.09, 1570.79633,  1960;
    'EKZE630ELL181MK16S', 0.072, 0.09, 1963.49541,  2370;
    'EKZN800ELL181MK16S', 0.090, 0.09, 1963.49541,  2180;
    '187AVG063MGBJ',      0.028, 0.12, 942.47780,   2900;
    'UCZ1J181MNS1MS',     0.020, 0.12, 1656.69925,  3925;
    'UHW1J181MPD1TD',     0.115, 0.09, 1256.63706,  2005;
    '63ZLJ180M10X16',     0.076, 0.09, 1256.63706,  1785;
    '860040775009',       0.100, 0.09, 1570.79633,  2225 
};

% Eklenen MOSFET değerleri
mosfets = {
    'IPD036N04L G',     20.00,	0.0036,	90.00,	1.60,	54.00,	3.00,	2.00,	6.00,	5.40,	14.00,	6.10,	38.00,	0.84208;
    'IRF40R207',        20.00,	0.0051,	89.00,	2.00,	220.00,	5.30,	2.50,	19.00,	35.00,	12.00,	15.00,	68.00,	0.41983;
    'BSZ031NE2LS5',     20.00,	0.0031,	80.00,	1.20,	38.00,	2.50,	2.00,	2.00,	3.00,	2.30,	1.40,	18.30,	0.60008;
    'BSZ0503NSI',	    20.00,	0.0034,	82.00,	1.40,	36.00,	2.60,	3.20,	2.00,	3.00,	2.50,	1.80,	9.50,	0.65252;
    'IPD036N04L G',	    20.00,	0.0039,	90.00,	1.60,	54.00,	3.00,	3.50,	6.00,	5.40,	14.00,	6.10,	38.00,	0.66481;
    'BSZ0902NS',	    20.00,	0.0035,	106.00,	1.80,	88.00,	2.60,	2.00,	3.60,	5.20,	5.90,	5.20,	35.00,	0.50211;
    'BSC050N03LS G',	20.00,	0.0030,	80.00,	1.40,	41.00,	3.10,	2.20,	3.60,	4.00,	8.40,	4.80,	35.00,	0.42586;
    'IPP023N04N G',	    20.00,	0.0023,	90.00,	1.90,	77.00,	4.80,	4.00,	7.80,	6.60,	35.00,	11.00,	120.00,	1.25743;
    'BSC054N04NS G',	20.00,	0.0054,	80.00,	1.50,	22.00,	5.30,	4.00,	3.60,	2.60,	11.00,	3.40,	34.00,	0.45202;
};

% Eklenen INDUCTOR değerleri
% inductor ismi{1}, BT({2), Kc{3}, Geçirgenlik{4}, Al (nH/T^2){5}, Hata Payı{6}, Wa (mm^'2){7}, Ac (mm^2){8}, Lc (mm){9}, Vc (mm3){10},
inductors = {
    '00K2510E090'		0.1,	16.9,	90,     100,    8,	77.8,	38.5,	48.5,	1870;
    '00K1808E090'		0.1,	16.9,	90,     69,     8,	51.5,	22.80,	40.1,	914;
    '00K3007E090'		0.1,	16.9,	90,     92,     8,	121,	60.1,	65.6,	3940;
    '00K4317E090'		0.1,	16.9,	90,     234,    8,	164,	152,	77.5,	11800;
    '00X3515E060'		0.1,	16.9,	60,     102,    8,	151,	84,	    69.4,	5830;
    '00X4317E060'		0.1,	16.9,	60,     163,    8,	164,	152,	77.5,	11800;
    '00X4020E060'		0.1,	16.9,	60,     150,	8,	276,	183,	98.4,	18000;
    '00X1808E060'		0.1,	16.9,	60,     48, 	8,	51.5,	22.8,	40.1,	914
};


% En etkili CAPACITOR'i seç
loss_weight   = 0.55;
cost_weight   = 0.30;
volume_weight = 0.15;
[best_capacitor, best_score, best_Pcout] = select_best_capacitor(capacitors, loss_weight, cost_weight, volume_weight, Icout, fsw, C);

% En etkili CAPACITOR'i yazdır
fprintf('En Etkili CAPACITOR: %s\n', best_capacitor{1});
fprintf('Kapasite (F): %.2f F\n', "180");
fprintf('Pcout : %.2f\n', best_Pcout);
fprintf('Hacim: %.2f\n', best_capacitor{4});
fprintf('Maliyet: %.2f\n', best_capacitor{5});
% En etkili CAPACITOR seçim algoritması
Pcapacite=(best_Pcout);
total = (best_Pcout + Pt);
function [best_capacitor, best_score, best_Pcout] = select_best_capacitor(capacitors, loss_weight, cost_weight, volume_weight, Icout, fsw, C)
    best_capacitor = capacitors(1, :);
    best_score = Inf;
    best_Pcout = 0;  % En iyi Pcout değeri için değişken tanımlama

    for i = 1:size(capacitors, 1)
        capacitor = capacitors(i, :);
        esr = capacitor{2};
        DF = capacitor{3};
        volume = capacitor{4};
        cost = capacitor{5};
        
        ESR1 = DF/(2*fsw*C*3.14);
        Pcout = Icout ^ 2 * ESR1;

        score = loss_weight * Pcout + cost_weight * cost + volume_weight * volume;

        if score < best_score
            best_capacitor = capacitor;
            best_score = score;
            best_Pcout = Pcout;  % En iyi kapasitörün Pcout değerini saklama
        end
    end
end


