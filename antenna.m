%
% File: Antenna.m
%
%Author: Ekin Aky?rek
%In order to use in simulation of control sytems in ELEC304 classes at Koc University
classdef Antenna < handle
  %A class plots antenna and has ability to rotate it and prints the instantenous angle.
  
  %For the antenna, there are 3 graphical object:
    %Half paraboloid
    %Half paraboloid
    %Cyclinder
 % Antenna is in the form of paraboloid. It is plotted with two half paraboloid with different colors.
 %Thus, we can feel its rotation.
 
 %One text object which puts the current angle
 
 %One text is static label for the ELEC304 class name
 
 %Transform object is responsible for rotation.
 
 %Angle stores the angle of anttenan in radians.
 
  properties (SetAccess=private)
    my_graphics    = gobjects(1,3);
    my_text  = gobjects(1,2);
    h_axes = hgtransform();
    angle = 0;
  end
  %
  % Public methods
  methods
      %Init
    function obj = Antenna()
      obj.create_antenna();
    end
    %Rotate to given angle
    function setAngle(obj, theta)
    % Call this to change the angles.
      obj.angle = theta;
      obj.transform();
    end
    %Check whether the figure which contaions the objects is alive. 
    function r = isAlive(obj)
      r = isvalid(obj) && ...
          isvalid(obj.my_graphics(1)) && isvalid(obj.my_graphics(2)) &&  isvalid(obj.my_graphics(3)) &&...
          isvalid(obj.my_text(1)) && isvalid(obj.my_text(2));
    end
  end
  
  %
  % Private methods
  methods (Access=private)

    function transform(obj)
    % Rotate in z axis with ang angle
    Rz = makehgtform('zrotate',obj.angle);
    % Set the transform Matrix property to rotate all connected objects.
    set(obj.h_axes,'Matrix',Rz)
    %Print the angle of antenna
    obj.my_text(2).String =[' Angle: ', num2str((obj.angle/pi)*180)];
    %Refresh the frame
    drawnow
    end
    
    function create_antenna(obj)
        close all;
        %Set the axis limits and titles
        ax = axes('XLim',[-2 2],'YLim',[-2 2],'ZLim',[-1 1.5]);
        %Set view
        view(3)
        % Create a transform object from axises
        obj.h_axes = hgtransform('Parent',ax);
        hold on;
        %Half paraboloid
        [X1,Y1] = meshgrid(-1.5:0.01:1.5, 0:0.01:1.5);
        Z1 = sqrt((1/7 + X1.^2/1+Y1.^2/1));
        %Connect to paraboloid to h object
        surf1 = surf(X1,  Y1,  Z1,'Parent',  obj.h_axes);
        %Save the surface to my_graphics array
        obj.my_graphics(1) = surf1;
        hold on;
        %Second half paraboloid
        [X2,Y2] = meshgrid(-1.5:0.01:1.5, -1.5:0.01:0);
        Z2 = sqrt((1/7 + X2.^2/1+Y2.^2/1));
        %Connect to second paraboloid to h object too
        surf2 = mesh(X2,  Y2 , Z2,'Parent', obj.h_axes , 'FaceColor','interp','FaceLighting','gouraud');
        %Save surface to my_graphics array.
        obj.my_graphics(2) = surf2;
        hold on;
        
        %Create the rotation disk of antenna
        [X3,Y3,Z3] = cylinder(0.4);
        Z3 = Z3 *0.5;
        disk1 = mesh(X3,  Y3 , Z3,'Parent', obj.h_axes, 'FaceColor', [1,1,0]);
        %Save surface to my_graphics array
        obj.my_graphics(3) = disk1;
        % Print initial texts.
        obj.my_text(1) = text(0.5,0.5, -1.5,'Elec 304 Antenna Simulation','HorizontalAlignment','center','FontSize',15);
        obj.my_text(2) = text(0.4, 0.5, - 0.5 , [' Angle: ', num2str((obj.angle/pi)*180)],'HorizontalAlignment','center','FontSize',12);
        
    end
  end
end