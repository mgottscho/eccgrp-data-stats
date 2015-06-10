% Memory Trace Tranmission

% Code parameters:
n = 72;
k = 64;
r = n-k;

% read the file:
done = 0;
i = 1;
fid = fopen('mem_chan_trace.txt');
trace_data = NaN(1,11);
while done == 0
    % Parse a line
    [line,charsRead] = fscanf(fid, '%lu,%lu,%lu,%lu,%lu,%lu,%X,%X,%X,%X,%X,%X,%X,%X\n',14);
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
            trace_data(i,1) = tick;
            trace_data(i,2) = addr;
            trace_data(i,3) = cmd;
            trace_data(i,4:11) = data(:)';
            i = i+1;
        end
    end
end
fclose(fid);

% the data words are in C{7} to C{14}:
ln = length(C{7});
for i=1:ln
   for j=1:8
      messageList(i,j) =  C{6+j}(i);
   end
end

% transmit our messages:
for i=1:ln
    for j=1:8
        mess = dec2bin(messageList(i,j),64);
        mess=mess-'0';
        
        % generate an error:
        err = zeros(1,n);
        err(1) = 1;
        err(2) = 1;
        
        % encode our codeword
        cw = hamEnc(mess);
            
        % receive an word (poss. in error)
        reccw = mod(cw+err,2);
        
        % decode our received codeword
        [decCw, e] = hamDec(reccw);
        
        % check for errors. if e==2, we 
        if e==2
           disp('We are in the 2 error case.');
           
           % let's run the decoder through every codeword that flips a bit
           % from the received word.
           
           idx = 1;
           for k=1:n
               cwmod = reccw;
               cwmod(k) = mod(cwmod(k)+1,2);
               
               [decCwmod, e] = hamDec(cwmod);
               cwList(k,:) = decCwmod;
           end           
        end
    end
    
    cw
    cwList
   
end
