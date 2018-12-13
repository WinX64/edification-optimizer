function [ bestX, bestY ] = differentialEvolution( costFnc, options )
% Differential Evolution algorithm implementation
% Tries to find the best value for the given function inside the specified
% constrains
%
% costFnc       - The cost function
% options       - Optimization options
%   numVars     - Number of variables of the problem
%   numIters    - Maximum number of iterations to perform
%   numPop      - Number of the initial population
%   lowerLimits - The lower constraints for the variables
%   upperLimits - The upper constraints for the variables
%   outputFcn   - The output function to be invoked after every iteration
%   diffFactor  - The differential factor [0-2]
%   crossChance - The cross-over chance [0-1]
%
% bestX         - The best solution for the given problem
% bestY         - The cost for the best solution

%% Initial declaration of variables %%
numVars = options.numVars;
numIters = options.numIters;
numPop = options.numPop;
lowerLimits = options.lowerLimits;
upperLimits = options.upperLimits;
outputFcn = options.outputFcn;

diffFactor = options.diffFactor;
crossChance = options.crossChance;

%% Validation for the input parameters %%
if size(lowerLimits, 2) ~= numVars || size(upperLimits, 2) ~= numVars
    error('Tamanho das matrizes de intervalo não coincide com o número de variaveis!');
end

if numPop < 4
    error('O número da população deve ser maior ou igual a 4!');
end

%% Population struct %%
point.x = [];
point.y = 0;
bestX = [];
bestY = Inf;

population = repmat(point, 1, numPop); % Population of solutions

%% Random picking of the initial population %%
for n = 1:numPop
    
    %% Random point inside the constraints %%
    x = zeros(1, numVars);  % Solution vector
    for i = 1:numVars
        x(i) = lowerLimits(i) + rand() * (upperLimits(i) - lowerLimits(i));
    end
    
    %% Cost of the solution %%
    y = costFnc(x);
    
    %% Saving the generated point %%
    point.x = x;
    point.y = y;
    
    population(n) = point;
    
    if bestY > point.y
        bestX = point.x;
        bestY = point.y;
    end
end

%% Main iteration %%
for iter = 1:numIters
    
    %% Iteration specific population %%
    iterPopulation = population; % Solutions for the current iteration
    for n = 1:numPop
        availablePoints = population; % Available solutions
        parentPoint = population(n);  % Parent solution
        availablePoints(n) = [];  % Removal of the parent solution
        otherPoints = struct();   % 3 other random solutions
        
        %% Selection of the other 3 solutions %%
        for i = 1:3
            rIndex = randi(size(availablePoints, 2));
            rPoint = availablePoints(rIndex);
            otherPoints(i).x = rPoint.x;
            otherPoints(i).y = rPoint.y;
            availablePoints(rIndex) = [];
        end
        
        %% Mutant solution %%
        mutPoint = struct();
        mutPoint.x = otherPoints(1).x + diffFactor * (otherPoints(2).x - otherPoints(3).x);
        
        %% Validation of the mutant solution %%
        if any(mutPoint.x < lowerLimits) || any(mutPoint.x > upperLimits)
            continue;
        end
        
        %% Child solution %%
        childPoint = struct();
        x = zeros(1, numVars);
        for i = 1:numVars
            if rand() <= crossChance
                x(i) = mutPoint.x(i);
            else
                x(i) = parentPoint.x(i);
            end
        end
        
        %% Cost of the child solution %%
        y = costFnc(x);
        
        %% Saving the child solution %%
        childPoint.x = x;
        childPoint.y = y;
        
        %% Greedy selection %%
        if parentPoint.y > childPoint.y
            iterPopulation(n) = childPoint;
        end
        
        %% Update of the best solution %%
        point = iterPopulation(n);
        if bestY > point.y
            bestX = point.x;
            bestY = point.y;
        end
    end
    population = iterPopulation; % Update of the population
    
    if outputFcn(iter, bestX, bestY)
        break;
    end
end
end