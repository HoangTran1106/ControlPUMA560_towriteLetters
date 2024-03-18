Ex_1_Part_1_1_Forward_Kinematics;
run("Ex_1_Part_1_1_Forward_Kinematics.m");

%%% initate Jacobian function 
syms J [6 6]
%%% Jacobian including linear kinematics 
J(1:3,1) = diff(T07(1:3,4), t1);
J(1:3,2) = diff(T07(1:3,4), t2);
J(1:3,3) = diff(T07(1:3,4), t3);
J(1:3,4) = diff(T07(1:3,4), t4);
J(1:3,5) = diff(T07(1:3,4), t5);
J(1:3,6) = diff(T07(1:3,4), t6);

%%% Jacobian including for angular kinematics
% All joints are revolute => epsilon bar always = 1 
% => Only angles are considered in the partial derivative. 

T02 = T01 * T12;
T03 = T02 * T23;
T04 = T03 * T34;
T05 = T04 * T45;
T06 = T05 * T56;

J(4:6,1) = T01(1:3, 3);
J(4:6,2) = T02(1:3, 3);
J(4:6,3) = T03(1:3, 3);
J(4:6,4) = T04(1:3, 3);
J(4:6,5) = T05(1:3, 3);
J(4:6,6) = T06(1:3, 3);
disp(J)