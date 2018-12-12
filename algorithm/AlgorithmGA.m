classdef AlgorithmGA < Algorithm
    
    properties
        prefix = 'GA';
        name = 'Generic Algorithm';
    end
        
    properties (Access = private)
        lblNumGenes;
        eNumGenes;
        
        lblCrossChance;
        eCrossChance;
        
        lblMutChance;
        eMutChance;
    end
    
    methods
        function [components] = registerComponents(this, tab)            
            this.lblCrossChance = uilabel(tab, 'Text' , 'Combinação (%)');
            this.lblCrossChance.HorizontalAlignment = 'right';
            this.eCrossChance = uieditfield(tab, 'numeric');
            this.eCrossChance.Position(3) = 50;
            this.eCrossChance.Limits = [0 1];
            this.eCrossChance.Value = 0.8;
            this.eCrossChance.ValueDisplayFormat = '%.3f';
            
            components(1,:) = [this.lblCrossChance, this.eCrossChance];
        end
        
        function [specificArguments, result] = validateArguments(this, generalArguments)
            specificArguments.crossChance = this.eCrossChance.Value;
            result = [];
        end
        
        function [bestX, bestY] = runOptimization(this, optimFunction, generalArguments, specificArguments)
            numVars = generalArguments.numVars;
            numIters = generalArguments.numIters;
            numPop = generalArguments.numPop;
            lowerLimits = generalArguments.lowerLimits;
            upperLimits = generalArguments.upperLimits;
            progressFunction = generalArguments.progressFunction;
            
            crossChance = specificArguments.crossChance;

            outputFunction = @(options, state, flag) this.runOutputFunction(options, state, flag, progressFunction);
            
            options = optimoptions(@ga);
            options.CrossoverFraction = crossChance;
            options.Display = 'off';
            options.MaxGenerations = numIters;
            options.OutputFcn = outputFunction;
            options.PopulationSize = numPop;
            
            [bestX, bestY] = ga(optimFunction, numVars, [], [], [], [], lowerLimits, upperLimits, [], options);
        end
    end
    
    methods (Access = private)
        function [state, options, optchanged] = runOutputFunction(this, options, state, flag, progressFunction)
            optchanged = false;
            if any(strcmp(flag, {'init', 'done'}))
                return;
            end
            
            [~, bestIndex] = min(state.Score);
            bestX = state.Population(bestIndex,:);
            bestY = state.Best(state.Generation);
            
            if progressFunction(state.Generation, bestX, bestY)
                state.StopFlag = 'Stopped by user';
            end
        end
    end
end