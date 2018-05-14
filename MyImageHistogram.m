function [xCen,n] = MyImageHistogram(dataVec,nBins)
% function [xCen,n] = MyHistogram(dataVec,nBins)
% Yoji Watanabe - ES2
% Input  - dataVec is an array of values to fit into bins
%        - nBins is an integer with the number of bins for the histogram
% Output - xCen is an array with the center x value of each bin
%        - n is an array with the number of values fitting into each bin
% Calculates the data for a histogram for given input. Can be used in
% conjunction with the bar function to graph a histogram.
    % Preallocate arrays
    xCen        = zeros(1, nBins);
    n           = zeros(1, nBins);
    
    % Set necessary values
    dataVec     = dataVec(:);
    edges       = 0:1:255;
    xCen        = linspace(0.5, 254.5, 255);
    
    % Loop and calculate values
    for i=1:nBins
        n(i)         = sum(dataVec >= edges(i) & dataVec < edges(i + 1));
    end

    % Check for edge case
    if (dataVec(end) > edges(end - 1)) && (dataVec(end) <= edges(end))
        n(end) = n(end) + 1;
    end
    
    % Handle another edge case where binWidth method cannot account for the
    % small difference and calculates wrong n values
    if sum(abs(diff(dataVec)) <= 1)
        n(i) = sum(dataVec >= edges(i) & dataVec <= edges(i + 1));
    end
    
end
