classdef foo
    properties
        changeMe = 0;
    end

    methods
        function self = go(self)
          self.changeMe = 1;
        end
    end
end