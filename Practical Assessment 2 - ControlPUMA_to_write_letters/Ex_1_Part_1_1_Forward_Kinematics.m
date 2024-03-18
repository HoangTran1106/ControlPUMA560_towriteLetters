clear 
clc
%%% Data
syms t1 t2 t3 t4 t5 t6 t al d a;
d3 = 0.15; a2 = 0.4318;
a3 = 0.0203; d4 = 0.4318;
T01 = zeros(4); T12 = zeros(4); T23 = zeros(4); T34 = zeros(4); T45 = zeros(4);
T56 = zeros(4);
%%% 
c0 = cos(t); s0 = sin(t);
ca = cos(al); sa = sin(al);
tranform_matrix = [c0   -s0   0   a;
    s0*ca c0*ca -sa -sa*d;
    s0*sa c0*sa ca  ca*d;  
    0     0     0   1];

M =   [0	0	        0    t1;
       0	-90/180*pi	0    t2;
       a2   0           d3   t3;
       a3 	-90/180*pi	d4   t4; 
       0	90/180*pi	0    t5;
       0	-90/180*pi	0    t6;
       0    0           0.1  0];

%%% Unit for angles is radian
T01 = subs(tranform_matrix, [a, al, d,  t], [M(1, 1), M(1, 2), M(1, 3), M(1, 4)]);
T12 = subs(tranform_matrix, [a, al, d,  t], [M(2, 1), M(2, 2), M(2, 3), M(2, 4)]);
T23 = subs(tranform_matrix, [a, al, d,  t], [M(3, 1), M(3, 2), M(3, 3), M(3, 4)]);
T34 = subs(tranform_matrix, [a, al, d,  t], [M(4, 1), M(4, 2), M(4, 3), M(4, 4)]);
T45 = subs(tranform_matrix, [a, al, d,  t], [M(5, 1), M(5, 2), M(5, 3), M(5, 4)]);
T56 = subs(tranform_matrix, [a, al, d,  t], [M(6, 1), M(6, 2), M(6, 3), M(6, 4)]);
T67 = subs(tranform_matrix, [a, al, d,  t], [M(7, 1), M(7, 2), M(7, 3), M(7, 4)]);

T07 = T01*T12*T23*T34*T45*T56*T67;