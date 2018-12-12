function [ textBlock, remainingText ] = readBlock( text, delimStart, delimEnd, keepDelim )
% Function to read a block of text that is placed between two delimiters
% Everything before the first delimStart is discarded
%
% Input variables:
%  text - The text to be read
%  delimStart - The character that specifies the begining of the block
%  delimEnd - The character that specifies the ending of the block
%  keepDelim - Keep the delimiter in the result text
%
% Output variables:
%  textBlock - The parsed text block
%  remainingText - The remaining of the text, after the last delimEnd

    %% Variable declaration %%
    count = 0; %The delimiter counter, used for nested blocks
    started = 0; %The variable to indicate the first delimiter has been found
    textBlock = ''; %The parsed text block
    remainingText = text; %The remaining text

    %% Main iteration %%
    for currentIndex = 1:size(text, 2)
        char = text(currentIndex);

        %If the char is a delimStart
        if char == delimStart
            %Begin the process
            if started == 0
                started = 1;
            end

            %Increment the counter
            count = count + 1;
        end

        %If the char is a delimEnd
        if char == delimEnd
            %Decrement the counter
            count = count - 1;
        end

        %If the process has start, concat the current char in the textBlock
        if started ~= 0
            textBlock = cat(2, textBlock, char);
        end

        %If a delimEnd is first found, return with an error
        if count < 0
            error('[Bloco] Um caractere de término de bloco foi encontrado no lugar de um de início');
        end

        %If the process has started and the count is 0 again, it means that a
        %delimEnd has been found for the first delimStart, so, the operations
        %is complete
        if started == 1 && count == 0
            %Remove the delimiters if specified
            if keepDelim == 0
                textBlock = textBlock(2:end - 1);
            end

            %Set the new value of the remainingText
            remainingText = text(1, currentIndex + 1:end);
            return;
        end
    end

    %If no final delimEnd has been found, return with an error
    if count > 0
        error('[Bloco] Caractere de término de bloco faltado');
    end
end
