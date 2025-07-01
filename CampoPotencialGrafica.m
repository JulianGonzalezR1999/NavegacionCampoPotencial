% --- Parámetros de los obstáculos ---
CC = [0.12    -0.28;      % Centro obstáculo 1
      -0.2    -0.2;
      0    0;
      -0.32 0.24;
      0.04 0.24;
      0.28 0.16];   % Centro obstáculo 2
RC = [0.04, 0.06, 0.1,0.04,0.048 0.08]; % Radios
rho0 = 0.25;
eta = 0.02;

% --- Malla (debe coincidir con la del campo atractivo) ---
[X,Y] =  meshgrid(linspace(-0.5,0.5,120), linspace(-0.5,0.5,120));

% --- Potencial atractivo ---
zeta = 1;
q_goal = [0.36; 0.36];
U_att = 0.5 * zeta * ((X - q_goal(1)).^2 + (Y - q_goal(2)).^2);

% --- Potencial repulsivo total ---
U_rep = zeros(size(X));
for i = 1:length(RC)
    obs_center = CC(i,:);
    obs_radius = RC(i);
    dist = sqrt((X - obs_center(1)).^2 + (Y - obs_center(2)).^2);
    rho = dist - obs_radius;
    mask = (rho > 0) & (rho <= rho0);
    U_rep(mask) = U_rep(mask) + 0.5 * eta * (1 ./ rho(mask) - 1/rho0).^2;
end

% --- Campo total ---
U_total = U_att + U_rep;

% --- Graficar ---
figure; hold on
contourf(X, Y, log10(1 + U_total), 20, 'LineColor', 'none')
colorbar
title('Campo total')
xlabel('X'); ylabel('Y');

% Inicio y meta
plot(-0.36, -0.36, 'ro', 'MarkerSize', 10, 'LineWidth', 2)
plot( 0.36,  0.36, 'mo', 'MarkerSize', 10, 'LineWidth', 2)

% Obstáculos
theta = linspace(0, 2*pi, 50);
for i = 1:length(RC)
    fill(CC(i,1) + RC(i)*cos(theta), ...
         CC(i,2) + RC(i)*sin(theta), ...
         'r', 'EdgeColor', 'k', 'FaceAlpha', 0.9)
end

axis equal
hold off
