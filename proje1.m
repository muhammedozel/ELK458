% 1. Çıkış gücü (Po), giriş gerilimi aralığı (Vinmin ve Vinmax), çıkış gerilimi aralığı (Vomin ve Vomax), verim (n) ve anahtarlama frekansı (fsw) değerleri verilmiştir.
% 2. Çıkış akımı (Io) ve yük direnci (R) hesaplanır.
% 3. Rastgele bir giriş gerilimi (Vin) ve çıkış gerilimi (Vo) değeri seçilir.
% 4. Anahtarlama periyodu (T) hesaplanır.
% 5. Buck ve Boost dönüşüm oranları (Dbuck ve Dboost) hesaplanır.
% 6. Gerilim düşüş oranları (D1, D2, D3 ve D4) ve süreleri (D2_d ve D3_d) hesaplanır.
% 7. Endüktans değerleri (Lbuck ve Lboost) ve akım dalgalanması (dImaxbuck ve dImaxboost) hesaplanır.
% 8. Anahtar akımının maksimum değeri (Iswmaxbuck ve Iswmaxboost) hesaplanır.
% 9. Çıkış gerilimi dalgalanması (Voutripple) ve kapasitans değerleri (Cbuck ve Cboost) hesaplanır.
% 10. Son olarak, en uygun endüktans (L) ve kapasitans (C) değerleri seçilir.
Po = 250;
Vinmin = 2.5;
Vinmax = 60;
Vomin = 20;
Vomax = 24;
n = 0.95;
fsw = 300000;
Io = Po / Vo;
R = Po / Io;
Vin = round(Vinmin + (Vinmax - Vinmin) * rand(1, 1));
Vo = round(Vomin + (Vomax - Vomin) * rand(1, 1));
T = 1 / fsw;
Dbuck = Vomax / (Vinmax * n);
Dboost = 1 - (Vinmin * n) / Vomax;

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

Kind = 0.3;
Lbuck = Vo * (Vinmax - Vo) / (Kind * fsw * Vinmax * Io);
Lboost = Vinmin ^ 2 * (Vo - Vinmin) / (fsw * Kind * Io * Vo ^ 2);
dImaxbuck = (Vinmin - Vo) * Dbuck / (fsw * Lbuck);
Iswmaxbuck = dImaxbuck / 2 + Io;
dImaxboost = Vinmin * Dboost / (fsw * Lboost);
Iswmaxboost = dImaxboost / 2 + Io / (1 - Dboost);
Voutripple = Vo * 0.005;
Cbuck = Kind * Io / (8 * fsw * Voutripple);
Cboost = Io * Dboost / (fsw * Voutripple);

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
