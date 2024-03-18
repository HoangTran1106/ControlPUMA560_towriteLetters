clear 
clc

%%% DATA
load Letter_HH_trajectory.mat;

% load robot model
puma560=loadrobot("puma560", DataFormat = "row");

% display to robot
puma560.show;

% display the robot in detail
puma560.showdetails

% Set the joint value
joints = [0 0 -pi 0 0 0];

% get the transform of the last link to the base link
T2 =puma560.getTransform(joints,"link7");

% display the robot with joints_1 config
puma560.show(joints);

%%% 
Link7_pos = [-1  0  0 0.35
             0  1  0 0.25    
             0  0  -1 0
             0  0  0 1];
puma_IK = analyticalInverseKinematics(puma560);
generateIKFunction(puma_IK,'willowRobotIK');
ikConfig = willowRobotIK(Link7_pos,false); % Reject joint limit 
% to verify whether the robot can reach the location or not
showdetails(puma_IK)


%
Link7_pos = [-1  0  0 0.4
             0  1  0 0.4    
             0  0  -1 0
             0  0  0 1];

offset_x = 0.25; offset_y = 0.25;
hold on 
traj(:,1) = traj(:,1) + offset_x;
traj(:,2) = traj(:,2) + offset_y;
p = plot3(traj(:,1), traj(:,2), traj(:,3), "-");
p.LineWidth = 2;
% puma560.show([1.0598   -1.5705   -0.3150    0.0000   -1.2561    1.0598])
for i = 1:1:length(traj)
    Link7_pos(1:3,4) = traj(i,1:3)';
    ikConfig = willowRobotIK(Link7_pos,false);
    % if this line of code does not produce any error, the trajectory is 
    % within the robot's workspace. 
end

