clear 
clc

P = [0.1  0.2;
     0.3  0.4;
     0.5  0.3;
     0.9  0.5];
d3 = 0.1;
d2 = zeros(4, 1);
seg_t = [5 3 8];
theta = zeros(4, 1);
for i = 1:length(d2)
    d2(i, 1) = sqrt(P(i,2)^2 + P(i,1)^2) - d3;
end
for i = 1:length(theta)
    theta(i, 1) = atan(P(i,2)/P(i,1));
end

u = 50/180*pi; % rad/s^2
%%% With theta 
% Segment 1
u1 = theta(1, 1); u2 = theta(2, 1); td12 = seg_t(1, 1);

dd_u1 = sign(u2 - u1)*abs(u);
t1 = td12 - sqrt(td12^2 - 2*(u2 - u1)/dd_u1);
d_u12 = (u2 - u1)/(td12 -1/2*t1);

% Segment 2
u3 = theta(3, 1); u2 = theta(2, 1); td23 = seg_t(1, 2);

d_u23 = (u3 - u2)/td23;
dd_u2 = sign(d_u23 - d_u12)*abs(u);
t2 = (d_u23 - d_u12)/dd_u2;
t12 = td12 - t1 - 1/2*t2;

% Segment 3
u3 = theta(3,1); u4 = theta(4,1); td34 = seg_t(1, 3);

dd_u4 = sign(u3 - u4)*u;
t4 = td34 - sqrt(td34^2 + 2*(u4 - u3)/dd_u4);
d_u34 = (u4 - u3)/(td34 - 1/2*t4);

dd_u3 = sign(d_u34 - d_u23)*u;
t3 = (d_u34 - d_u23)/dd_u3;
t23 = td23 -1/2*t2 -1/2*t3; 
t34 = td34 -1/2*t3 - t4; 

dt = 0.00001;
t_span = [t1, t12, t2, t23, t3, t34, t4];
velo_acce = [dd_u1, d_u12, dd_u2, d_u23, dd_u3, d_u34, dd_u4];
% Prepare data for plot
current_th = []; start = u1; temp = start;
current_t = 0; period = [];
for i = 1:length(t_span)
    temp_period = linspace(current_t,t_span(i), floor(t_span(i)/dt))';
    temp_th = zeros(length(temp_period), 1);
    for j = 1:length(temp_period)
        if mod(i, 2) == 1
            if i == 1
                temp = start + 1/2*velo_acce(i)*temp_period(j)^2;
            else
                temp = start + 1/2*velo_acce(i)*temp_period(j)^2 + velo_acce(i-1)*temp_period(j);
            end
        else
            temp = temp_period(j)*velo_acce(i) + start;
        end 
        temp_th(j) = temp;
    end
    start = temp;
    if ~isempty(period)
        period = [period; temp_period + period(end)];
    else
        period = [period; temp_period];
    end
    current_th = [current_th; temp_th];
end 
plot(period, current_th)

u = 5; %m/s^2
%%% With d2 
% Segment 1
u1 = d2(1, 1); u2 = d2(2, 1); td12 = seg_t(1, 1);

dd_u1 = sign(u2 - u1)*abs(u);
t1 = td12 - sqrt(td12^2 - 2*(u2 - u1)/dd_u1);
d_u12 = (u2 - u1)/(td12 -1/2*t1);

% Segment 2
u3 = d2(3, 1); u2 = d2(2, 1); td23 = seg_t(1, 2);

d_u23 = (u3 - u2)/td23;
dd_u2 = sign(d_u23 - d_u12)*abs(u);
t2 = (d_u23 - d_u12)/dd_u2;
t12 = td12 - t1 - 1/2*t2;

% Segment 3
u3 = d2(3,1); u4 = d2(4,1); td34 = seg_t(1, 3);

dd_u4 = sign(u3 - u4)*u;
t4 = td34 - sqrt(td34^2 + 2*(u4 - u3)/dd_u4);
d_u34 = (u4 - u3)/(td34 - 1/2*t4);

dd_u3 = sign(d_u34 - d_u23)*u;
t3 = (d_u34 - d_u23)/dd_u3;
t23 = td23 -1/2*t2 -1/2*t3; 
t34 = td34 -1/2*t3 - t4; 

dt = 0.00001;
t_span = [t1, t12, t2, t23, t3, t34, t4];
velo_acce = [dd_u1, d_u12, dd_u2, d_u23, dd_u3, d_u34, dd_u4];
% Prepare data for plot
current_d2 = []; start = u1; temp = start;
current_t = 0; period = [];
for i = 1:length(t_span)
    temp_period = linspace(current_t,t_span(i), floor(t_span(i)/dt))';
    temp_d2 = zeros(length(temp_period), 1);
    for j = 1:length(temp_period)
        if mod(i, 2) == 1
            if i == 1
                temp = start + 1/2*velo_acce(i)*temp_period(j)^2;
            else
                temp = start + 1/2*velo_acce(i)*temp_period(j)^2 + velo_acce(i-1)*temp_period(j);
            end
        else
            temp = temp_period(j)*velo_acce(i) + start;
        end 
        temp_d2(j) = temp;
    end
    start = temp;
    if ~isempty(period)
        period = [period; temp_period + period(end)];
    else
        period = [period; temp_period];
    end
    current_d2 = [current_d2; temp_d2];
end 
figure(2)
plot(period, current_d2)

x = zeros(length(period),1);
y = zeros(length(period),1);
for i = 1:length(x)
    x(i) = (current_d2(i) + d3)*cos(current_th(i));
    y(i) = (current_d2(i) + d3)*sin(current_th(i));
end
figure(3)
plot(x, y)
current_d2 = [current_d2; current_d2(end-1:end,:)];
save theta.mat current_th 
save d2.mat current_d2
save time.mat period