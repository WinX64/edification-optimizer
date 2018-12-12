function [ parts ] = readProperty( text, delimiter, expectedSize, expectedKey )
% Function to split a property, a text string separated by a delimiter
% Example: 
%  Property 'Some property = 3 = (1,2,3)(4,5,6)(7,8,9)'
%  results in: ['Some property', '3', '(1,2,3)(4,5,6)(7,8,9)']
%
% Input variables:
%  text - The text to be read
%  delimiter - The character that splits the arguments of the property
%  expectedSize - The size of the parts
%  expectedKey - The expected name of the first part
%
% Output variables:
%  parts - The parts of the property  

    %% Variable declaration %%
    parts = strtrim(split(text, delimiter));
    
    %% Main logic %%
    %If the size of the parts isn't the same as the specified
    if size(parts, 1) ~= expectedSize
        error('prog:input', '[Propriedade] Tamanho esperado: %d, encontrado: %d', expectedSize, size(parts, 1));
    end
    
    if size(parts, 1) > 0 && isempty(expectedKey) == 0 && strcmp(char(parts(1)), expectedKey) ~= 1
        error('prog:input', '[Propriedade] Chave esperada: "%s", encontrada: "%s"', expectedKey, char(parts(1)));
    end
end
