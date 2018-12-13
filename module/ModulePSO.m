classdef ModulePSO < AlgorithmModule
    %ModulePSO PSO module implementation
    %   Implementation of the module for the Particle Swarm Optimization
    %   algorithm
    
    properties
        prefix = 'PSO';
        name = 'Particle Swarm Optimization';
    end
    
    properties (Access = private)
        lblInertiaFactor;
        eInertiaFactor;
        
        lblLocalFactor;
        eLocalFactor;
        
        lblSocialFactor;
        eSocialFactor;
    end
    
    methods
        function [components] = registerComponents(this, tab)
            this.lblInertiaFactor = uilabel(tab, 'Text' , 'Inércia');
            this.lblInertiaFactor.HorizontalAlignment = 'right';
            this.eInertiaFactor = uieditfield(tab, 'numeric');
            this.eInertiaFactor.Position(3) = 50;
            this.eInertiaFactor.Limits = [0 Inf];
            this.eInertiaFactor.Value = 0.6;
            this.eInertiaFactor.ValueDisplayFormat = '%.3f';
            
            this.lblLocalFactor = uilabel(tab, 'Text' ,'Ajuste pessoal');
            this.lblLocalFactor.HorizontalAlignment = 'right';
            this.eLocalFactor = uieditfield(tab, 'numeric');
            this.eLocalFactor.Position(3) = 50;
            this.eLocalFactor.Limits = [0 Inf];
            this.eLocalFactor.Value = 1.49;
            this.eLocalFactor.ValueDisplayFormat = '%.3f';
            
            this.lblSocialFactor = uilabel(tab, 'Text' , 'Ajuste social');
            this.lblSocialFactor.HorizontalAlignment = 'right';
            this.eSocialFactor = uieditfield(tab, 'numeric');
            this.eSocialFactor.Position(3) = 50;
            this.eSocialFactor.Limits = [0 Inf];
            this.eSocialFactor.Value = 1.49;
            this.eSocialFactor.ValueDisplayFormat = '%.3f';
            
            components(1,:) = [this.lblInertiaFactor, this.eInertiaFactor];
            components(2,:) = [this.lblLocalFactor, this.eLocalFactor];
            components(3,:) = [this.lblSocialFactor, this.eSocialFactor];
        end
        
        function [specificArguments, result] = validateArguments(this, generalArguments)
            specificArguments.inertiaFactor = this.eInertiaFactor.Value;
            specificArguments.localFactor = this.eLocalFactor.Value;
            specificArguments.socialFactor = this.eSocialFactor.Value;
            
            result = [];
        end
        
        function [bestX, bestY] = runOptimization(this, optimFunction, generalArguments, specificArguments)
            numVars = generalArguments.numVars;
            numIters = generalArguments.numIters;
            numPop = generalArguments.numPop;
            lowerLimits = generalArguments.lowerLimits;
            upperLimits = generalArguments.upperLimits;
            progressFunction = generalArguments.progressFunction;
            
            inertiaFactor = specificArguments.inertiaFactor;
            localFactor = specificArguments.localFactor;
            socialFactor = specificArguments.socialFactor;
            
            outputFunction = @(optimValues, state) this.runOutputFunction(optimValues, state, progressFunction);
            
            options = optimoptions(@particleswarm);
            options.Display = 'off';
            options.InertiaRange = [inertiaFactor, inertiaFactor];
            options.MaxIterations = numIters;
            options.OutputFcn = outputFunction;
            options.SelfAdjustmentWeight = localFactor;
            options.SocialAdjustmentWeight = socialFactor;
            options.SwarmSize = numPop;
            
            [bestX, bestY] = particleswarm(optimFunction, numVars, lowerLimits, upperLimits, options);
        end
    end
    
    methods (Access = private)
        function [stop] = runOutputFunction(this, optimValues, state, progressFunction)
            stop = false;
            if any(strcmp(state, {'init', 'done'}))
                return;
            end
            
            if progressFunction(optimValues.iteration, optimValues.bestx, optimValues.bestfval)
                stop = true;
            end
        end
    end
end

