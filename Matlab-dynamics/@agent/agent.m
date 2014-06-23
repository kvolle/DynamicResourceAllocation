% Point mass dynamics
classdef agent
    methods
        function obj = agent(State, Mass)
            obj.State = State;
            obj.Mass = Mass;
            obj.Force = [0;0;0];
        end
        function dstate = stateDiff(obj, y);
            dstate(1:3) = y(4:6);
            dstate(4:6) = (1/obj.Mass)*obj.Force;
        end
        function newState = RK4(obj)
            dt = 0.01;
            k1 = obj.stateDiff(obj.State);
            k2 = obj.stateDiff(obj.State+(dt/2)*k1);
            k3 = obj.stateDiff(obj.State+(dt/2)*k2);
            k4 = obj.stateDiff(obj.State+dt*k3);
            newState = obj.State + (dt/6)*(k1+2*k2+2*k3+k4);
        end
    end
    properties
        State
        Mass
        Force
    end
end
            