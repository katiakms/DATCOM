clear all; clc; close all;

%%
%%%%%%%%%% PROGRAMA PARA DETERMINAÇÃO DOS PONTOS QUE DESCREVEM O PERFIL AERODINÂMICO PARA QUALQUER INTERVALO DO EIXO X %%%%%%%%%%

warning('O arquivo .dat deve estar na mesma pasta que o programa');
warning('O .dat deve conter apenas os numeros! É necessário excluir a primeira linha do arquivo que contém letras!');
a1 = input('Digite o perfil que você deseja abrir (EX: mh80.dat): ', 's');
[x, y] = textread(a1);

n = length(y); %Número de pontos
j = 1;

for i=1:n
   if y(i) < 0        
        k(j) = i; %Vetor com os índices dos valores que são negativos
        j = j+1;
   end
end

p = k(1); %Índice do primeiro valor negativo
q = 0;
r = 0;

%Loop de 1 até o primeiro valor negativo, preenchendo x e y extradorso

for m = 1:(p-1)    
   X_extradorso(1+r) = x(m);
   Y_extradorso(1+r) = y(m);
   r = r + 1;
end


%Loop do primeiro valor negativo até o último, preenchendo x e y intradorso

for m = p:n 
   X_intradorso(1+q) = x(m);
   Y_intradorso(1+q) = y(m);
   q = q + 1;
end

%Transpor para vetor coluna
X_extradorso = X_extradorso';
Y_extradorso = Y_extradorso';
X_intradorso = X_intradorso';
Y_intradorso = Y_intradorso';

X_passo1 = input('Digite o passo do bordo de ataque (eixo X): ');
X_passo2 = input('Digite o passo da parte central (eixo X): ');
X_passo3 = input('Digite o passo do bordo de fuga (eixo X): ');

X_intervalo1 = 0:X_passo1:0.3;
X_intervalo2 = 0.3:X_passo2:0.7;
X_intervalo3 = 0.7:X_passo3:1;

Coef_extradorso = polyfit(X_extradorso, Y_extradorso, 12); %Equação do perfil para o extradorso
Y_extradorso_21 = polyval(Coef_extradorso, X_intervalo1)';
Y_extradorso_22 = polyval(Coef_extradorso, X_intervalo2)';
Y_extradorso_23 = polyval(Coef_extradorso, X_intervalo3)';

Y_extradorso_2 = [Y_extradorso_21; Y_extradorso_22;  Y_extradorso_23];

Coef_intradorso = polyfit(X_intradorso, Y_intradorso, 12); %Equação do perfil para o intradorso
Y_intradorso_21 = polyval(Coef_intradorso, X_intervalo1)';
Y_intradorso_22 = polyval(Coef_intradorso, X_intervalo2)';
Y_intradorso_23 = polyval(Coef_intradorso, X_intervalo3)';

Y_intradorso_2 = [Y_intradorso_21; Y_intradorso_22; Y_intradorso_23];

X_intervalo1 = X_intervalo1';
X_intervalo2 = X_intervalo2';
X_intervalo3 = X_intervalo3';
X_intervalo = [X_intervalo1; X_intervalo2; X_intervalo3];

var = table(X_intervalo, Y_extradorso_2, Y_intradorso_2);
open var

extra = [X_intervalo Y_extradorso_2];
intra = [X_intervalo Y_intradorso_2];


%Gráficos
plot(extra(:,1), extra(:,2), 'b')
hold on
plot(x,y, 'm')
hold on
scatter(extra(:,1), extra(:,2),'k');
hold on
scatter(intra(:,1), intra(:,2),'k');
hold on
plot(intra(:,1), intra(:,2), 'b');
grid minor
ylim([-0.22 0.22])
legend('Calculado','Real','Pontos escolhidos')
title('Perfil')
