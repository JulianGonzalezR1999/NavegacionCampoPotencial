k = 10 * 0.04;
CC = k * 0.1 * [3 -7;-5 -5;0 0;-8 6;1 6; 7 4];   % Centros
RC = k * 0.1 * [1 1.5 2.5 1 1.2 2];              % Radios

[X, Y] = meshgrid(-0.4:0.01:0.4, -0.4:0.01:0.4); % Grilla del mapa
Fx = zeros(size(X));  Fy = zeros(size(Y));

k_rep = 1;        % Ganancia de repulsión
alpha = 20;       % Pendiente de la sigmoide

for i = 1:length(RC)
    dx = X - CC(i,1);
    dy = Y - CC(i,2);
    R  = sqrt(dx.^2 + dy.^2);
    mask = R > 1e-3;          % evitar división por cero

    % -------------------------------
    % Módulo con función sigmoide:
    % f(R) = -k_rep * sig( α (R - RC(i)) ) / R
    % -------------------------------
    sig = 1 ./ (1 + exp(-alpha*(R(mask) - RC(i))));   % sigmoide logística
    mag = -k_rep * sig ./ R(mask);

    Fx(mask) = Fx(mask) + mag .* dx(mask);
    Fy(mask) = Fy(mask) + mag .* dy(mask);
end

quiver(X, Y, Fx, Fy)
title('Campo de repulsión con función sigmoide')
axis equal
grid on
hold on
