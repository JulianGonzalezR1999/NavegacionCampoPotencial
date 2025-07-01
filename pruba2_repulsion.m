clc; clear; close all; 
%% Mapa original
clf
figure(1); hold on
radio = 0.7;% m
k = 10 * radio;% factor de escala
plot(k*[-1 1 1 -1 -1], k*[-1 -1 1 1 -1], 'r')% bordes de mapa

CC = k * 0.1 * [3 -7; -5 -5; 0 0; -8 6; 1 6; 7 4];% centros de obstáculos
RC = k * 0.1 * [1 1.5 2.5 1 1.2 2];% radios de obstáculos
t = 0:pi/8:2*pi;
for i = 1:length(RC)
    patch(CC(i,1) + RC(i)*sin(t), CC(i,2) + RC(i)*cos(t), 'r')
end
plot(k*[-.9,.9], k*[-.9,.9], '+')
text(-k*.85, -k*.9, 'Inicio')
text(k*.95, k*.9, 'Meta')
axis(k*[-1.2 1.2 -1.2 1.2])
axis equal
grid on

%% campotencial
res = 100;% resolución de malla
x_vals = linspace(-k, k, res);
y_vals = linspace(-k, k, res);
[XX, YY] = meshgrid(x_vals, y_vals);
U_rep = zeros(size(XX));

d0 = 0.8;% distancia donde la repulsión se vuelve relevante [m]
lambda = 8;% factor de repulsion   

for i = 1:size(CC,1)
    dx = XX - CC(i,1);
    dy = YY - CC(i,2);
    dist = sqrt(dx.^2 + dy.^2) - RC(i);% distancia desde el borde del obstáculo
    U_rep = U_rep + 1 ./ (1 + exp(lambda*(dist - d0)));
end

margen = 0.1;     
lambda_borde = 15;
map_size = k;

dist_izq  = abs(XX + map_size);  
dist_der  = abs(XX - map_size);  
dist_abaj = abs(YY + map_size);  
dist_arr  = abs(YY - map_size);  

U_rep = U_rep + ...
    1 ./ (1 + exp(lambda_borde * (dist_izq - margen))) + ...
    1 ./ (1 + exp(lambda_borde * (dist_der - margen))) + ...
    1 ./ (1 + exp(lambda_borde * (dist_abaj - margen))) + ...
    1 ./ (1 + exp(lambda_borde * (dist_arr - margen)));

%% Campotencial completo
figure(2); clf
contourf(XX, YY, U_rep, 20)
hold on
inicio = [-0.9*k, -0.9*k];
meta   = [ 0.9*k,  0.9*k];
plot(inicio(1), inicio(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g')
plot(meta(1), meta(2), 'm*', 'MarkerSize', 12)
text(inicio(1)+1, inicio(2), 'Inicio', 'Color', 'g', 'FontWeight', 'bold')
text(meta(1)-2, meta(2), 'Meta', 'Color', 'm', 'FontWeight', 'bold')
title('Campo Potencial')
xlabel('X [m]')
ylabel('Y [m]')
axis equal
grid on

%% Campo atractivo 
alpha = 0.08; % Intensidad del campo atractivo
[Xg, Yg] = deal(meta(1), meta(2)); % Coordenadas de la meta

% Campo potencial atractivo
U_att = 0.5 * alpha * ((XX - Xg).^2 + (YY - Yg).^2);

U_total = U_rep + U_att; % Combinacion de campos

figure(3); clf
contourf(XX, YY, U_total, 30)
hold on
plot(inicio(1), inicio(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g')
plot(meta(1), meta(2), 'm*', 'MarkerSize', 12)
text(inicio(1)+1, inicio(2), 'Inicio', 'Color', 'g', 'FontWeight', 'bold')
text(meta(1)-2, meta(2), 'Meta', 'Color', 'm', 'FontWeight', 'bold')
title('Campo de Potencial Total')
xlabel('X [m]')
ylabel('Y [m]')
axis equal
grid on


%% Combinacion d e campos y simulacion
[Fx_total, Fy_total] = gradient(-U_total, mean(diff(x_vals)), mean(diff(y_vals)));

R = 0.041;% radio de rueda [m]
L = 0.053;% trocha [m]
dt = 0.1; % paso de integración [s]
K_angular = 3;% ganancia de orientación
theta = deg2rad(60);% angulo inicial [rad]
x = inicio(1); % posición inicial en X
y = inicio(2); % posición inicial en Y

dist_threshold = 0.05; % distancia mínima a la meta [m]
trayectoria = [];
max_steps = 1000; % por si se queda girando

for i = 1:max_steps
    x = max(min(x, max(x_vals)), min(x_vals));
    y = max(min(y, max(y_vals)), min(y_vals));
    % Calcular fuerza atractiva total
    fx = interp2(x_vals, y_vals, Fx_total, x, y, 'linear', 0);
    fy = interp2(x_vals, y_vals, Fy_total, x, y, 'linear', 0);

    theta_d = atan2(fy, fx);
    error_theta = atan2(sin(theta_d - theta), cos(theta_d - theta));

    % Velocidades
    v = 1.0;%vel robot
    w = K_angular * error_theta;

    omegaR = (2*v + w*L) / (2*R);
    omegaL = (2*v - w*L) / (2*R);

    v_real = R/2 * (omegaR + omegaL);
    w_real = R/L * (omegaR - omegaL);

    x = x + v_real * cos(theta) * dt;
    y = y + v_real * sin(theta) * dt;
    theta = theta + w_real * dt;

    trayectoria(end+1,:) = [x, y];

    % Verificar si llegó
    if norm([x - meta(1), y - meta(2)]) < dist_threshold
        disp("El robot llegó a la meta.");
        break
    end
end

% Visualización final de la trayectoria
figure(4); clf
contourf(XX, YY, U_total, 30); hold on
plot(trayectoria(:,1), trayectoria(:,2), 'c', 'LineWidth', 2)

plot(inicio(1), inicio(2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g')
plot(meta(1), meta(2), 'm*', 'MarkerSize', 12)
text(inicio(1)+1, inicio(2), 'Inicio', 'Color', 'g', 'FontWeight', 'bold')
text(meta(1)-2, meta(2), 'Meta', 'Color', 'm', 'FontWeight', 'bold')
title('Trayectoria del e-puck sobre Campo Potencial')
xlabel('X [m]')
ylabel('Y [m]')
axis equal
grid on
