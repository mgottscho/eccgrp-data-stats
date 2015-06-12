function [memory_trace] = getTraceFromFile(filename)
% getTraceFromFile
%
% Author: Mark Gottscho
% mgottscho@ucla.edu
%
% Reads a memory trace from a text file containing N lines of the following form:
%   CMD,ADDR,SIZE,FLAGS,TICK,HAS_DATA,DATA0,DATA1,DATA2,DATA3,DATA4,DATA5,DATA6,DATA7
%   All fields are positive integers in decimal notation except for
%   DATA0...DATA7, which are in hexadecimal notation.
%
% Returns:
%   memory_trace -- An matrix of dimension Mx14, with M <= N. Only memory
%       transactions with HAS_DATA asserted are maintained in the output
%       matrix.

memory_trace = NaN(1,11);
fid = fopen(filename);
done = 0;
i = 1;
while done == 0
    % Parse a line
    [line,charsRead] = fscanf(fid, '%lu,%lu,%lu,%lu,%lu,%lu,%lx,%lx,%lx,%lx,%lx,%lx,%lx,%lx\n',14);
    if charsRead == 0
        done = 1;
    else   
        cmd = line(1);
        addr = line(2);
        size = line(3);
        flags = line(4);
        tick = line(5);
        has_data = line(6);
        if has_data == 1
            data = line(7:14);
            % Store relevant information into a matrix
            memory_trace(i,1) = cmd;
            memory_trace(i,2) = addr;
            memory_trace(i,3) = size;
            memory_trace(i,4) = flags;
            memory_trace(i,5) = tick;
            memory_trace(i,6) = has_data;
            memory_trace(i,7:14) = data(:)';
            i = i+1;
        end
    end
end
fclose(fid);

end