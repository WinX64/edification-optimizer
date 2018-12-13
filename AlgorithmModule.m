classdef (Abstract) AlgorithmModule < matlab.mixin.Heterogeneous & handle
    %ALGORITHMMODULE Base algorithm class
    %   Base class for algorithm implementations to be used on the
    %   optimization application
    
    properties (Abstract)
        %Prefix of the algorithm. Eg.: GA
        prefix;
        
        %Name of the algorithm. Eg.: Genetic Algorithm
        name;
    end
    
    methods (Abstract)
        %Register the components for the algorithm's specific parameters on
        %the algorithm's tab
        [components] = registerComponents(this, tab);
        
        %Validates the specific arguments before the optimization starts
        [specificArguments, result] = validateArguments(this, generalArguments);
        
        %Performs the optimization with the specified parameters
        [bestX, bestY] = runOptimization(this, optimFunction, generalArguments, specificArguments);
    end
end
