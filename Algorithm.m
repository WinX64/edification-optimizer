classdef (Abstract) Algorithm < matlab.mixin.Heterogeneous & handle
    %ALGORITHM Classe base de algoritmo
    %   Classe base para implementa��o de algoritmo no m�dulo de otimiza��o
    
    properties (Abstract)
        %Prefixo do algorithm. Ex.: GA
        prefix;
        
        %Nome do algoritmo. Ex.: Genetic Algorithm
        name;
    end
    
    methods (Abstract)
        %M�todo para o registro dos componentes na janela do m�dulo de
        %otimiza��o, referente aos par�metros especificos do algoritmo.
        [components] = registerComponents(this, tab);
        
        %M�todo para a valida��o dos par�metros especificos anteriormente a
        %uma simula��o.
        [specificArguments, result] = validateArguments(this, generalArguments);
        
        %M�todo para a realiza��o da simula��o.
        [bestX, bestY] = runOptimization(this, optimFunction, generalArguments, specificArguments);
    end
end