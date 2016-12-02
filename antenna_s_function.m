%
% File: antenna_s_function.m
%
%Author: Ekin Aky?rek
%In order to use in simulation of control sytems in ELEC304 classes at Koc University
%Edited from level-2 S function template of MATLAB
function antenna_s_function(block)
% Level-2 MATLAB file S-Function for antenna simulation
  setup(block);
%endfunction
end

function setup(block)
%% Register number of input and output ports
%We have just one input to represent the angle of antenna
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 0;

%% Setup functional port properties to dynamically
%% inherited.
  block.SetPreCompInpPortInfoToDynamic;
%% Set block sample time to variable sample time
  block.NumDialogPrms     = 0;

% Register sample times
%Inherited sample time [-1 0];
  block.SampleTimes = [-1 0];
  block.SetSimViewingDevice(true)
%% Set the block simStateCompliance to default (i.e., same as a built-in block)
block.SimStateCompliance = 'DefaultSimState';
 %% Register methods
block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Update', @Update);
%endfunction
end

%%
%% PostPropagationSetup:
%%   Functionality    : Setup work areas and state variables. Can
%%                      also register run-time methods here
%%   Required         : No
%%   C-Mex counterpart: mdlSetWorkWidths
%%
function DoPostPropSetup(block)
%Initialize the Dworks for internal data. Not necessary for out antenna simulation. 
%We can directly feed input to the rotation of 3D Object. 
%We don't have to store internal variable for angle. 
%However, I keep it for the sake of development on the project.
  block.NumDworks = 1;
  block.Dwork(1).Name            = 'x1';
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;      % double
  block.Dwork(1).Complexity      = 'Real'; % real
  block.Dwork(1).UsedAsDiscState = true;
end

%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C-MEX counterpart: mdlInitializeConditions
%%
function InitializeConditions(block)
%create a new antenna object. 
%Creation of object calls to initializer function in the Antenna class
    my_antenna = Antenna();
% Save it to UserData in order to reach in the other methods of block
    set_param(block.BlockHandle,'UserData', my_antenna);
%end InitializeConditions
end

%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C-MEX counterpart: mdlStart
%%
function Start(block)
block.Dwork(1).Data = 0;
%end Start
end

%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C-MEX counterpart: mdlUpdate
%%
function Update(block)
%Save angle to internal variable.
block.Dwork(1).Data = block.InputPort(1).Data;
%Get our antenna object from UserData
antenna = get_param(block.BlockHandle, 'UserData');
%Check whether the user closed the figure 
if(~isempty(antenna) && antenna.isAlive())
%Then set its angle to input angle
antenna.setAngle(block.Dwork(1).Data)
end
%end Update
end
%%
function Terminate(block)
%%Do something at the end
%end Terminate
end

