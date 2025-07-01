clear all; close all; clc;

% Parámetros de navegación
x0 = -0.36; y0 = -0.36;
theta_init = deg2rad([30, 45, 60]); % 0, 30, 45 y 60 grados
colores = {'-b','-r','-g','-k'}; % para ver cada trayectoria

x_goal = 0.36;
y_goal = 0.36;
position_accuracy = 0.01;

zeta = 50;
eta = 0.01;
dstar = 0.3;
Qstar = 0.22;

% Obstáculos (centros y radios)
CC = [0.12   -0.28;
      -0.2   -0.2;
       0      0;
     -0.32    0.24;
      0.04    0.24;
      0.28    0.16];
RC = [0.04, 0.06, 0.1, 0.04, 0.048, 0.08];

% Parámetros del robot
error_theta_max = deg2rad(45);
v_max = 0.1;
Kp_omega = 1.5;
omega_max = 0.5*pi;

% Simulación
dT = 0.12;
t_max = 2000;

figure(1); clf; hold on; box on;
daspect([1 1 1]); xlim([-0.5, 0.5]); ylim([-0.5, 0.5]);
title('Trayectorias con diferentes orientaciones iniciales');
xlabel('X'); ylabel('Y');

% Obstáculos
theta_c = linspace(0, 2*pi, 80);
for k = 1:length(RC)
    fill(CC(k,1) + RC(k)*cos(theta_c), ...
         CC(k,2) + RC(k)*sin(theta_c), ...
         'r', 'EdgeColor','k','FaceAlpha',0.8)
end

plot(x_goal, y_goal, 'mo', 'MarkerSize', 10, 'LineWidth', 2);

% Analizar para cada orientación inicial
for idx = 1:length(theta_init)
    x = x0; y = y0; theta = theta_init(idx);
    X = zeros(1, t_max); Y = zeros(1, t_max);
    X(1) = x; Y(1) = y; t = 1;

    while norm([x_goal y_goal] - [x y]) > position_accuracy && t < t_max
        % Gradiente Potencial Atractivo
        delta_goal = [x y] - [x_goal y_goal];
        d_goal = norm(delta_goal);
        if d_goal <= dstar
            nablaU_att =  zeta * delta_goal;
        else
            nablaU_att = dstar / d_goal * zeta * delta_goal;
        end

        % Gradiente Potencial Repulsivo
        nablaU_rep = [0 0];
        for k = 1:length(RC)
            obs_center = CC(k,:);
            obs_radius = RC(k);
            diff = [x y] - obs_center;
            d_obs = norm(diff);
            rho = d_obs - obs_radius;
            if rho <= Qstar && rho > 0
                grad = diff / d_obs;
                nablaU_rep = nablaU_rep + eta*(1/Qstar - 1/rho)*(1/rho^2)*grad;
            end
        end

        nablaU = nablaU_att + nablaU_rep;
        theta_ref = atan2(-nablaU(2), -nablaU(1));
        error_theta = theta_ref - theta;
        error_theta = atan2(sin(error_theta), cos(error_theta));

        if abs(error_theta) <= error_theta_max
            alpha = (error_theta_max - abs(error_theta)) / error_theta_max;
            v_ref = min(alpha * norm(-nablaU), v_max);
        else
            v_ref = 0;
        end
        omega_ref = Kp_omega * error_theta;
        omega_ref = min( max(omega_ref, -omega_max), omega_max);

        % Actualizar estado del robot
        theta = theta + omega_ref * dT;
        x = x + v_ref * cos(theta) * dT;
        y = y + v_ref * sin(theta) * dT;
        t = t + 1;
        X(t) = x; Y(t) = y;
    end
    

   h(idx) = plot(X(1:t), Y(1:t), colores{idx}, 'LineWidth', 2, 'DisplayName', ...
        ['\theta_0 = ' num2str(round(rad2deg(theta_init(idx))) ) '^\circ']);
    plot(X(1), Y(1), 'ko','MarkerFaceColor','k','MarkerSize',6); % punto de inicio
end

legend([h(1) h(2) h(3)]);

