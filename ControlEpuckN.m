vrep = remApi('remoteApi');
vrep.simxFinish(-1);

clientId = vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);
if clientId > -1
    disp('✅ Conectado a CoppeliaSim');

    % Obtener handles
    [~, leftMotor]  = vrep.simxGetObjectHandle(clientId, 'ePuck_leftJoint', vrep.simx_opmode_blocking);
    [~, rightMotor] = vrep.simxGetObjectHandle(clientId, 'ePuck_rightJoint', vrep.simx_opmode_blocking);
    [~, robot]      = vrep.simxGetObjectHandle(clientId, 'epuck', vrep.simx_opmode_blocking);

    % Iniciar streaming
    vrep.simxGetObjectPosition(clientId, robot, -1, vrep.simx_opmode_streaming);
    vrep.simxGetObjectOrientation(clientId, robot, -1, vrep.simx_opmode_streaming);
    pause(0.2);

    % Parámetros del robot
    R = 0.0205;  % radio de la rueda [m]
    L = 0.053;       % distancia entre ruedas [m]
    v_max = 0.5;
    epsilon = 0.05;

    % Lista de puntos objetivo (trayectoria)
    trajectory = trayectoria;
    % [ -0.113, -0.3569;
    %                -0.03233, -0.284709;
    %                 0.024622, -0.1677;
    %                0.1458, -0.1233 ];

    for i = 1:183
        goal = trajectory(i, :)';

        while true
            [~, pos] = vrep.simxGetObjectPosition(clientId, robot, -1, vrep.simx_opmode_buffer);
            [~, orient] = vrep.simxGetObjectOrientation(clientId, robot, -1, vrep.simx_opmode_buffer);

            x = pos(1);
            y = pos(2);
            theta = orient(3);  % ángulo en Z
            %Rotacion en Y
            Ry = [cos(-pi/2), 0, sin(-pi/2);
                 0,           1, 0;
                -sin(-pi/2), 0, cos(-pi/2)];
            %Rotacion en Z
            Rz = [cos(-pi/2), -sin(-pi/2), 0;
                 sin(-pi/2),  cos(-pi/2), 0;
                  0, 0, 1];

            m_movil = [cos(theta); sin(theta); 0]
            m_fijo = Rz * Ry * m_movil;
            theta = atan2(dir_global(2), dir_global(1));
            current = [x; y];
            error = goal - current;
            dist = norm(error);

            if dist < epsilon
                % Detener el robot antes de avanzar al siguiente objetivo
                vrep.simxSetJointTargetVelocity(clientId, leftMotor, 0.0, vrep.simx_opmode_streaming);
                vrep.simxSetJointTargetVelocity(clientId, rightMotor, 0.0, vrep.simx_opmode_streaming);
                fprintf("✅ Punto %d alcanzado: [%.2f, %.2f]\n", i, goal(1), goal(2));
                % pause(0.5);
                break;
            end

            % Control de orientación
            angle = atan2(error(2), error(1));
            e_theta = wrapToPi(angle - theta);

            % Control proporcional
            k_w = 0.5;
            w = k_w * e_theta;

            % Control lineal suave
            v = v_max * cos(e_theta);
            if abs(e_theta) > pi/6
                v = 0;  % no avanzar si está muy desalineado
            end
            v = max(0, v);

            % Cinemática diferencial
            vL = (2*v - w*L) / (2*R);
            vR = (2*v + w*L) / (2*R);

            % Limitar velocidades
            vL = max(min(vL, 0.5), -0.5);
            vR = max(min(vR, 0.5), -0.5);

            % Enviar a motores
            vrep.simxSetJointTargetVelocity(clientId, leftMotor, vL, vrep.simx_opmode_streaming);
            vrep.simxSetJointTargetVelocity(clientId, rightMotor, vR, vrep.simx_opmode_streaming);
            fprintf("Punto %d | Dist: %.2f, e_theta: %.2f rad, vL: %.2f, vR: %.2f\n", ...
                i, dist, e_theta, vL, vR);
            pause(0.1);
        end
    end

    % Detener el robot al final de la trayectoria
    vrep.simxSetJointTargetVelocity(clientId, leftMotor, 0.0, vrep.simx_opmode_streaming);
    vrep.simxSetJointTargetVelocity(clientId, rightMotor, 0.0, vrep.simx_opmode_streaming);
    disp("🎯 Trayectoria completada");

    pause(1);
    vrep.simxFinish(clientId);
else
    disp('❌ No se pudo conectar');
end

vrep.delete();