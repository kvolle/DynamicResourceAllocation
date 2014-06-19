% This is an example of simulated annealing for Dynamic Allocation
% This is the object oriented version
clear all
clc

% Define the workspace
width = 100;
height = 100;

% Define the number of targets and agents
targets = 90;
robots = 450;

% Define the sizes of the targets
target_sizeT = [2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7,2,5,7,4,7];
target_size = [target_sizeT,target_sizeT,target_sizeT];
%target_pk = [0.8685,0.99374,0.999177,0.98273,0.999177,0.8685,0.99374,0.999177,0.98273,0.999177,0.8685,0.99374,0.999177,0.98273,0.999177,...
%    0.8685,0.99374,0.999177,0.98273,0.999177,0.8685,0.99374,0.999177,0.98273,0.999177,0.8685,0.99374,0.999177,0.98273,0.999177];
for z=1:length(target_size);
    target_pk(z) = 1-0.3625^target_size(z);
end
%Instantiate targets spaced randomly
target_loc = zeros(2,targets);
for i = 1:targets
    target_loc(:,i)=[ceil(rand()*50);ceil(rand()*50)+100];
end

% Declare the world object
world = environment(target_pk,target_loc);

% The negative one is for debugging since it should never exist after this
% This will be replaced with communication eventually
targeted = -1*ones(1,robots);


% Instantiate robots spaced randomly
% Select the nearest target
for r = 1:robots
    robot_array(r) = agent(r);
    robot_array(r).distance_ordering(target_loc);
    robot_array(r).target = robot_array(r).target_order(1);
    robot_array(r).adjust_velocity(target_loc);
    % Fill the ground truth array of who everyone is targeting
    targeted(r) = robot_array(r).target;
end

% Plot the scene
%figure(1)
%draw_step(target_loc,robot_loc,targeted);



% Set the threshold for switching based on initial allocation
threshold = set_threshold(target_pk,targeted);

error_exists = true;
i = 0;
tic

figure(1)

while (error_exists && i<1500)
     i=i+1;
     
     %{
    clf
    axis ([0 50 0 150])
    hold on
    for dr =1:robots
        plot(robot_array(dr).location(1),robot_array(dr).location(2),'rh');
    end
    for dt = 1:targets
        plot(target_loc(1,dt),target_loc(2,dt),'bh');
    end
    %pause(0.01)
     %}
    %{
 //////////////////////////////////////////////////////////////////////////
    drawnow;
      frame = getframe(1);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,256);
      if i == 1;
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append');
      end
%}
    %robot_loc = relocate(target_loc,robot_loc,targeted);
    %pause(0.15)
    %draw_step(target_loc,robot_loc,targeted);
    for r=1:robots
        % threshold times sigmoid function based on distance
        if (rand()<threshold(targeted(r))/(1+exp(-.2*(robot_array(r).distance(targeted(r))-15))))
            robot_array(r).get_model(targeted,targets);
            robot_array(r).retarget(target_loc,target_pk);
            robot_array(r).adjust_velocity(target_loc);
            targeted(r) = robot_array(r).target;
            robot_array(r).distance_ordering(target_loc);
        end
    end
    threshold = set_threshold(target_pk,targeted);
    su = zeros(1,targets);

    for t = 1:length(target_pk)
        for r = 1:length(targeted)
            if targeted(r) == t
                su(t) = su(t)+1;
            end
        end
    end
    Pk = ones(1,length(target_pk))-0.3625.^su;
    error(i,:) =abs((Pk-target_pk))/30;
    error_cnt(i,:) = abs(su-target_size);
    tot_err(i,1) = sum(error(i,:));
    tot_err_cnt(i,1) = sum(error_cnt(i,:));

    if tot_err(i,1)==0
        error_exists = false;
    end
    for r=1:robots
         robot_array(r).location = robot_array(r).location+robot_array(r).velocity;
     end
end
toc

%movie(M); 
%movie2avi(M, 'armanimation.avi'); 

figure(2)
plot(tot_err);
title('Error using Pk For Threshold');
xlabel('Iterations')
ylabel('Average Difference from Desired Pk')
figure(3)
plot(tot_err_cnt);

%plot(error(:,1),'r');
%hold on
%plot(error(:,2),'b');
%plot(error(:,3),'g');
%plot(error(:,4),'k');
%plot(error(:,5),'c');
%}