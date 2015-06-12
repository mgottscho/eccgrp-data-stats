function [deltaHammingWeights] = computeAccessLocality(memory_trace)

% TODO: autocorrelation? Apparently this function is only part of some paid
% MATLAB toolboxes..

deltaHammingWeights = NaN(8,8,size(memory_trace,1));
for transaction=1:size(memory_trace,1)
    for firstword=1:8
        for secondword=1:firstword
            deltaHammingWeights(firstword,secondword,transaction) = length(find(bitget(bitxor(memory_trace(transaction,6+firstword),memory_trace(transaction,6+secondword)), 1:64,'uint64')));
        end
    end
end

meanDeltaHammingWeights = mean(deltaHammingWeights,3);
surf(meanDeltaHammingWeights);

end

