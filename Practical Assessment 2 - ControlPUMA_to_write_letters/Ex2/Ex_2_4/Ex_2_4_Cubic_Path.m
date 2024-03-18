clear
clc
syms a0 a1 a2 a3 b0 b1 b2 b3 t
%%% Requirement
P = [0.1 0.2;
     0.3 0.4;
     0.5 0.3;
     0.9 0.5];
seg_t = [5 3 8];
set_omega = [0 0.1 0.1 0];
set_velo = [0 0.2 0.2 0];

steps = 500;
%%% 
for i = 2:length(P)
    atan(P(i-1,2)/P(i-1,1))
    theta = a3*t^3 + a2*t^2 + a1*t + a0;
    c1 = subs(theta, t, 0) == atan(P(i-1,2)/P(i-1,1));
    c2 = subs(diff(theta, t), t, 0) == set_omega(1, i-1); 
    c3 = subs(theta, t, seg_t(1, i-1)) == atan(P(i,2)/P(i,1));
    c4 = subs(diff(theta, t), t, seg_t(1, i-1)) == set_omega(1, i); % Selected velocity
    [A, B] = equationsToMatrix([c1 c2 c3 c4], [a3 a2 a1 a0]);
    result = linsolve(A, B);
    period = linspace(0,seg_t(1, i - 1), steps);
    theta_path = theta_path_create(theta, period, result, steps);

    d3 = 0.1;
    d2 = b3*t^3 + b2*t^2 + b1*t + b0;
    c1 = subs(d2, t, 0) == sqrt(P(i-1,2)^2 + P(i-1,1)^2) - d3;
    c2 = subs(diff(d2, t), t, 0) == set_velo(1, i-1); % initial velocity = 0
    c3 = subs(d2, t, seg_t(1, i-1)) == sqrt(P(i,2)^2 + P(i,1)^2) - d3;
    c4 = subs(diff(d2, t), t, seg_t(1, i-1)) == set_velo(1, i); % Selected velocity
    [A, B] = equationsToMatrix([c1 c2 c3 c4], [b3 b2 b1 b0]);
    result = linsolve(A, B);
    period = linspace(0,seg_t(1, i - 1), steps);
    d2_path = d2_path_create(d2, period, result, steps);

    x = zeros(1, steps);
    y = zeros(1, steps);
    d2_path = double(d2_path);
    theta_path = double(theta_path);
    for j = 1:length(theta_path)
        x(1, j) = (d2_path(1, j) + d3)*cos(theta_path(1, j));
        y(1, j) = (d2_path(1, j) + d3)*sin(theta_path(1, j));
    end
    plot(x ,y)
    hold on
end

function out = theta_path_create(theta, period, result, steps)
    syms a0 a1 a2 a3 b0 b1 b2 b3 t
    out_ = zeros(1, steps);
    equa = subs(theta, [a3 a2 a1 a0], result');
    for i = 1:length(out_)
        out_(1, i) = double(subs(equa, t, period(i)));
    end
    out = out_;
end

function out = d2_path_create(theta, period, result, steps)
    syms a0 a1 a2 a3 b0 b1 b2 b3 t
    out_ = zeros(1, steps);
    equa = subs(theta, [b3 b2 b1 b0], result');
    for i = 1:length(out_)
        out_(1, i) = double(subs(equa, t, period(i)));
    end
    out = out_;
end
