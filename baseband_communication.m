clc;
clear;
close all;

N = 1e7; % 10^7 adet sayı üreteceğiz ,10^8 için octave yeterli hafıza yok dedi.
half_N = N / 2; % 0 ve 1 sayılarının yarı yarıya olması için N'in yarısı kadar 0 ve 1 ekleyeceğiz

a1 = 1; % 1 biti için
a2 = -1; % 0 biti için

% dB değerleri
dB_values = 20:-1:0;

% No vektörünü oluşturdum.
No_values = 10 .^ (-dB_values / 10);

disp('Decibel (dB)   No');
disp('-----------------');
disp([dB_values', No_values']);

rand("state", 100); % hep aynı olasılıksal dağılımı üretmesi için bu duruma getirdim.
randn("state", 100);

BER_values = zeros(1, numel(No_values)); % SNR değerleri için BER değerlerini saklamak için bir vektör oluştur
s_vectors = cell(1, numel(No_values)); % Her SNR değeri için oluşturulan s vektörlerini saklamak için bir hücre dizisi oluşturdum
s_t_vectors = cell(1, numel(No_values)); % Her SNR değeri için oluşturulan s_t vektörlerini saklamak için bir hücre dizisi oluşturdum
z_vectors = cell(1, numel(No_values)); % Her SNR değeri için oluşturulan z vektörlerini saklamak için bir hücre dizisi oluşturdum
teorik_ber_values = zeros(1,numel(No_values)); #teorik ber değerleri için vektör oluşturdum


# q fonksiyonu , matlabda var ama octave de yok , bu şekilde tanımlanıyor , octave için.
function q = qfunction(x)
    q = 0.5 * erfc(x / sqrt(2));
end





#burada sırayla no değerleri için noise üretilip  a ile toplanıp z oluşturulacak, noise no a bağlı olduğu için bu şekilde yapıyoruz,
for i = 1:numel(No_values)
    % SNR değerine karşılık gelen No değerini alıyorum.
    No = No_values(i);

    % Her SNR değeri için yeni bir s vektörü oluşturuyorum.
    bits_ones = ones(1, half_N); % 1'ler
    bits_zeros = zeros(1, half_N); % 0'lar
    s = [bits_ones, bits_zeros];
    s = s(randperm(N));

    % Oluşturulan s vektörlerini cell' de saklamak istedim
    s_vectors{i} = s;

    % a vektörünü oluştur oluşturduğumuz N sayıda noktada değeri olan s vektöründe 1 olan yerlere a1 , 0 olan yerlere a2 ataması bu şekilde yapıldı.
    a = zeros(1, N);
    a(s == 1) = a1;
    a(s == 0) = a2;

    % Noise vektörünü oluşturup a vektörü ile topladığımızda z vektörünü elde ediyoruz bu z vektörünü birazdan eşik değerle test edeceğiz.
    noise = sqrt(No) * randn(1, N);
    z = a + noise;
    z_vectors{i} = z;


    % Eşik değeri hesapla (a1 ve a2'nin ortalaması)  # eşit ortalamalı bitlerin gaması bu şekilde bulunuyordu.
    gama = (a1 + a2) / 2;

    % S_t vektörünü hesapla
    s_t = z > gama;  # bu z vektörü gama değerinden büyükse 1 ,küçükse 0 değerini atar o sıradaki elemana gelir .

    % Oluşturulan s_t vektörlerini bu şekilde saklamak istedim.
    s_t_vectors{i} = s_t;

    % s_t ile s arasındaki aynı olmayan bitlerin sayılarının toplamı bit hata oranını bulmak için lazım. ~=  eşit değilse 1 döndürür , vektörler için yapınca birler sum() ile dööndürülen birler toplanıyor.
    % kaç bitte kaç tane hata olduğunu hesapladım bu şekilde.
    error_bits = sum(s_t ~= s);
    BER_values(i) = error_bits / N;
    disp(['SNR değeri ', num2str(i), ' için BER: ', num2str(BER_values(i))]);


    % teorik olarak bit hata oranı formülü Q(1/(sqrt(No))) bulunmuştu analitik çözümde.
    q = qfunction(1/sqrt(No));
    teorik_ber_values(i)=q;
    disp(['SNR değeri ', num2str(i), ' için teorik BER: ', num2str(teorik_ber_values(i))]);

end



SNR_dB = 10 * log10(1 ./ No_values);
figure;
semilogy(SNR_dB, BER_values, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;

% teorik_ber_values'ı 10^-7 ile sınırladım , grafik için(derste böyle söylendi)
BER_limit=10^-7;
teorik_ber_values(teorik_ber_values < BER_limit)=BER_limit ;
semilogy(SNR_dB, teorik_ber_values, 'r-', 'LineWidth', 2, 'MarkerSize', 8);


hold off;

% Eksen ve etiket ayarları
xlabel('SNR (dB)');
ylabel('Bit Hata Oranı (BER)');
title('SNR vs. BER');
legend('Deneysel BER', 'Teorik BER', 'BER Sınırı');
grid on;



% eşit olasılıklı olmayan bitler için




# Her snr değeri için saklamak istediğim ber values,s_vectorler,s_t_vectorleri,z_vectorleri,Teorik_olarak hesaplanan ber değerlerini cell açarak bu şekilde tanımladım.

# BU ŞEKİLDE CELL lerde saklama sebebim , gözümle de kontrol etmek için.

BER_values_esit_olmayan = zeros(1, numel(No_values));
s_vectors_esit_olmayan = cell(1, numel(No_values));
s_t_vectors_esit_olmayan = cell(1, numel(No_values));
z_vectors_esit_olmayan = cell(1, numel(No_values));
teorik_ber_values_esit_olmayan = zeros(1,numel(No_values));




N = 1e7; % 10^7 adet sayı üreteceğiz ,10^8 için octave yeterli hafıza yok dedi.
 % 0 ve 1 sayılarının yarı yarıya olması için N'in yarısı kadar 0 ve 1 ekleyeceğiz

a1 = 1; % 1 biti için
a2 = -1; % 0 biti için

% dB değerleri
dB_values = 0:1:20;

% No vektörünü oluşturdum._ değerleri hesaplayarak.
No_values = 10 .^ (-dB_values / 10);

p_bir=0.5
p_sifir=0.5

rand("state", 100); % hep aynı olasılıksal dağılımı üretmesi için bu duruma getirdim.
randn("state", 100);
function q = qfunction(x)
    q = 0.5 * erfc(x / sqrt(2));
end
#burada sırayla no değerleri için noise üretilip  a ile toplanıp z oluşturulacak, noise no a bağlı olduğu için bu şekilde yapıyoruz,
for i = 1:numel(No_values)
    % SNR değerine karşılık gelen No değerini alıyorum.
    No = No_values(i);
    % Her SNR değeri için yeni bir s vektörü oluşturuyorum.
    bits_ones = ones(1,N*p_bir ); % 1'ler
    bits_zeros = zeros(1,N*p_sifir ); % 0'lar
    s = [bits_ones, bits_zeros];
    s = s(randperm(N));

    % a vektörünü oluştur oluşturduğumuz N sayıda noktada değeri olan s vektöründe 1 olan yerlere a1 , 0 olan yerlere a2 ataması bu şekilde yapıldı.
    a = zeros(1, N);
    a(s == 1) = a1;
    a(s == 0) = a2;
    % Noise vektörünü oluşturup a vektörü ile topladığımızda z vektörünü elde ediyoruz bu z vektörünü birazdan eşik değerle test edeceğiz.
    noise = sqrt(No) * randn(1, N);
    z = a + noise;
    % Eşik değeri hesapla (a1 ve a2'nin ortalaması)  # eşit ortalamalı bitlerin gaması bu şekilde bulunuyordu.
    gama = (a1 + a2) / 2;
    % S_t vektörünü hesapla
    s_t = z > gama;  # bu z vektörü gama değerinden büyükse 1 ,küçükse 0 değerini atar o sıradaki elemana gelir .
    % s_t ile s arasındaki aynı olmayan bitlerin sayılarının toplamı bit hata oranını bulmak için lazım. ~=  eşit değilse 1 döndürür , vektörler için yapınca birler sum() ile dööndürülen birler toplanıyor.
    % kaç bitte kaç tane hata olduğunu hesapladım bu şekilde.
    error_bits = sum(s_t ~= s);
    BER_values(i) = error_bits / N;
    disp(['SNR değeri ', num2str(i-1), ' için BER: ', num2str(BER_values(i))]);
    % teorik olarak bit hata oranı formülü Q(1/(sqrt(No))) bulunmuştu analitik çözümde.
    q = qfunction(1/sqrt(No));
    teorik_ber_values(i)=q;
    disp(['SNR değeri ', num2str(i-1), ' için teorik BER: ', num2str(teorik_ber_values(i))]);

end


SNR_dB = 10 * log10(1 ./ No_values);

figure;
semilogy(SNR_dB, BER_values, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;

% teorik_ber_values'ı sınırla
BER_limit = 10^-7;
teorik_ber_values(teorik_ber_values < BER_limit) = BER_limit;
semilogy(SNR_dB, teorik_ber_values, 'r-', 'LineWidth', 2, 'MarkerSize', 8);

hold off;
xlabel('SNR (dB)');
ylabel('Bit Hata Oranı (BER)');
title('SNR vs. BER');
legend('Deneysel BER', 'Teorik BER', 'BER Sınırı');
grid on;
