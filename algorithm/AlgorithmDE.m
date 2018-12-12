classdef AlgorithmDE < Algorithm

    properties
        prefix = 'DE';
        name = 'Differential Evolution';
    end
    
    properties (Access = private)
        lblDiffFactor;
        eDiffFactor;
        
        lblCrossChance;
        eCrossChance;
    end
    
    methods
        function [components] = registerComponents(this, tab)
            this.lblDiffFactor = uilabel(tab, 'Text', 'Fator diferencial');
            this.lblDiffFactor.HorizontalAlignment = 'right';
            this.eDiffFactor = uieditfield(tab, 'numeric');
            this.eDiffFactor.Position(3) = 50;
            this.eDiffFactor.Limits = [0 2];
            this.eDiffFactor.Value = 1.0;
            this.eDiffFactor.ValueDisplayFormat = '%.3f';
            
            this.lblCrossChance = uilabel(tab, 'Text' , 'Combinação (%)');
            this.lblCrossChance.HorizontalAlignment = 'right';
            this.eCrossChance = uieditfield(tab, 'numeric');
            this.eCrossChance.Position(3) = 50;
            this.eCrossChance.Limits = [0 1];
            this.eCrossChance.Value = 0.5;
            this.eCrossChance.ValueDisplayFormat = '%.3f';
            
            components(1,:) = [this.lblDiffFactor, this.eDiffFactor];
            components(2,:) = [this.lblCrossChance, this.eCrossChance];
        end
        
        function [specificArguments, result] = validateArguments(this, generalArguments)
            specificArguments.diffFactor = this.eDiffFactor.Value;
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
            
            diffFactor = specificArguments.diffFactor;
            crossChance = specificArguments.crossChance;
            
            outputFunction = @(iteration, bestX, bestY) this.runOutputFunction(iteration, bestX, bestY, progressFunction);
            
            options.numVars = numVars;
            options.numIters = numIters;
            options.numPop = numPop;
            options.lowerLimits = lowerLimits;
            options.upperLimits = upperLimits;
            options.diffFactor = diffFactor;
            options.crossChance = crossChance;
            options.outputFcn = outputFunction;
            
            [bestX, bestY] = differentialEvolution(optimFunction, options);
        end
    end
    
    methods (Access = private)
        function [stop] = runOutputFunction(this, iteration, bestX, bestY, progressFunction)
            stop = progressFunction(iteration, bestX, bestY);
        end
    end
end

