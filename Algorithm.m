classdef (Abstract) Algorithm < matlab.mixin.Heterogeneous & handle
    %ALGORITHM Classe base de algoritmo
    %   Classe base para implementação de algoritmo no módulo de otimização
    
    properties (Abstract)
        %Prefixo do algorithm. Ex.: GA
        prefix;
        
        %Nome do algoritmo. Ex.: Genetic Algorithm
        name;
    end
    
    methods (Abstract)
        %Método para o registro dos componentes na janela do módulo de
        %otimização, referente aos parâmetros especificos do algoritmo.
        [components] = registerComponents(this, tab);
        
        %Método para a validação dos parâmetros especificos anteriormente a
        %uma simulação.
        [specificArguments, result] = validateArguments(this, generalArguments);
        
        %Método para a realização da simulação.
        [bestX, bestY] = runOptimization(this, optimFunction, generalArguments, specificArguments);
    end
end