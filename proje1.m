% Giriş değerleri
Po = 250;
Vinmin = 3;
Vinmax = 60;
Vomin = 12;
Vomax = 24;
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

% İndüktör değerleri matrisi (Çekirdek numarası, Çekirdek Tipi, B, Kc, Geçirgenlik, Al, Wa, Ac, Lc, Vc)
inductor = {
            '00K2510E090', 'Kool Mu', 0.1, 16.9, 90, 100, 77.8, 38.5, 48.5, 1870;
            '00K1808E090', 'Kool Mu', 0.1, 16.9, 90, 69, 51.5, 22.80, 40.1, 914;
            '00K3007E090', 'Kool Mu', 0.1, 16.9, 90, 92, 121, 60.1, 65.6, 3940;
            '00K4317E090', 'Kool Mu', 0.1, 16.9, 90, 234, 164, 152, 77.5, 11800;
            '00X3515E060', 'X Flux', 0.1, 16.9, 60, 102, 151, 84, 69.4, 5830;
            '00X4317E060', 'X Flux', 0.1, 16.9, 60, 163, 164, 152, 77.5, 11800;
            '00X4020E060', 'X Flux', 0.1, 16.9, 60, 150, 276, 183, 98.4, 18000;
            '00X1808E060', 'X Flux', 0.1, 16.9, 60, 48, 51.5, 22.8, 40.1, 914
            };

% İndüktör seçim fonksiyonu
function result = inductor_selection(inductor, A, B, C)
    % İndüktör değerlerini al
    core_number = inductor{1};
    core_type = inductor{2};
    B = inductor{3};
    Kc = inductor{4};
    permability = inductor{5};
    Al = inductor{6};
    Wa = inductor{7};
    Ac = inductor{8};
    Lc = inductor{9};
    Vc = inductor{10};

    % Diode forward voltage (Vf) ve on-state resistance (Rdson) değerlerini tanımla
    Vf = 0.45;
    Rdson = 0.003;

    % İdeal diyot ve anahtar gerilim düşüşü değerlerini hesapla
    Vd = Vf;
    Vsw = Vin * Rdson;

    % Çıkış gücü kayıplarını hesapla
    Pout = Po * (1 - n);

    % Buck ve boost modları için diyot ve anahtar kayıplarını hesapla
    Pd_boost = Vin * Io * Dboost * Vd;
    Psw_boost = Vin * Io * (1 - Dboost) * Vsw;
    Pd_buck = Vo * Io * (1 - Dbuck) * Vd;
    Psw_buck = Vin * Io * Dbuck * Vsw;

    % Toplam kayıpları hesapla
    if Vin > Vo
        Ploss = Pd_buck + Psw_buck;
    else
        Ploss = Pd_boost + Psw_boost;
    end

    % İç verimliliği hesapla
    eta = Pout / (Pout + Ploss);

    % Çıkış gerilimini ve akımını yazdır
    fprintf('Giriş Gerilimi (Vin): %.2f V\n', Vin);
    fprintf('Çıkış Gerilimi (Vo): %.2f V\n', Vo);
    fprintf('Çıkış Akımı (Io): %.2f A\n', Io);

    % Endüktans ve kapasitans değerlerini yazdır
    fprintf('Endüktans (L): %.2e H\n', L);
    fprintf('Kapasitans (C): %.2e F\n', C);

    % Zirve akım ve kayıpları yazdır
    fprintf('Zirve Akım (Ipeak): %.2f A\n', Ipeak);
    fprintf('Toplam Kayıp (Ploss): %.2f W\n', Ploss);

    % İç verimliliği yazdır
    fprintf('İç Verimlilik (eta): %.2f%%\n', eta * 100);
