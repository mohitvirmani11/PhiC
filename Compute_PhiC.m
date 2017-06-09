%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% This program shows the step-by-step computation of \Phi^C (using ETC)
% for an example network with 3 nodes.
% The network that we are considering is OR-AND-XOR
% with current state ON-OFF-OFF
%
% Nithin Nagaraj, Mohit Virmani
% National Institute of Advanced Studies, Bengaluru, INDIA
% April 2017
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


clear all; close all; % clear workspace
home;
LEN = 200;  % Length of all time series

NUM_NETWORKS = 1; % Only 1 network - OR-AND-XOR
NUM_STATES = 1; % Only 1 state - (1,0,0)

fprintf(1, '\n Computation of PhiC_ETC for the OR-AND-XOR network in the state (1,0,0). \n (This is Fig. 3 of the manuscript) \n');
fprintf(1,'\n >>>>>>>>>>>>>>>>>>>');
ETC_network = zeros(NUM_NETWORKS, NUM_STATES);
for i = 1:NUM_NETWORKS
    for j = 1:NUM_STATES
        dummy=[];
        iCCRD=[];% individual CCRD values
        
        dCCRD=[]; % differential CCRD values
        
        aCCRD = [];
        
        for q=1:2 %This loop is run twice - firstly to calculate MEP complexity and secondly to calculate ZEP complexity.
            if q==1
                fprintf(1,'\n Maximum entropy perturbation... \n');
                % Let us create the string for filename
                FILENAME = sprintf('MEP_TimeSeries.txt',q);
            else
                fprintf(1,'\n Zero entropy perturbation... \n')
                FILENAME = sprintf('ZEP_TimeSeries.txt',q);
            end
            
            
            % Load the file
            load(FILENAME);
            fid = fopen(FILENAME,'rt');
            C = textscan(fid, '%d');
            fclose(fid);
            ARRAY = C{1};
            
            counter = 1;
            for k=1:LEN*3:9*LEN; % running through all perturbations
                A = ARRAY(k:k+LEN-1);
                B = ARRAY(k+(LEN):k+(2*LEN-1));
                C = ARRAY(k+(2*LEN):k+(3*LEN-1));
                
                A = double(A(:));
                B = double(B(:));
                C = double(C(:));
                
                % determine ETC values of A, B and C here.
                
                if counter==1 % When A is perturbed
                    [ETC_B_val, EntLen_array] = ETC(B+1,0);
                    iCCRD = [iCCRD ETC_B_val/(LEN-1)];
                    %disp(['ETC_B_val=',num2str(iCCRD)]);
                    
                    [ETC_C_val, EntLen_array] = ETC(C+1,0);
                    iCCRD = [iCCRD ETC_C_val/(LEN-1)];
                    % disp(['ETC_C_val=',num2str(iCCRD)]);
                    
                elseif counter==2 % When B is perturbed
                    [ETC_A_val, EntLen_array] = ETC(A+1,0);
                    iCCRD= [iCCRD ETC_A_val/(LEN-1)];
                    %disp(['ETC_A_val=',num2str(iCCRD)]);
                    
                    [ETC_C_val, EntLen_array] = ETC(C+1,0);
                    iCCRD= [iCCRD ETC_C_val/(LEN-1)];
                    %disp(['ETC_C_val=',num2str(iCCRD)]);
                    
                else % When C is perturbed
                    [ETC_A_val, EntLen_array] = ETC(A+1,0);
                    iCCRD= [iCCRD ETC_A_val/(LEN-1)];
                    %disp(['ETC_A_val=',num2str(iCCRD)]);
                    
                    [ETC_B_val, EntLen_array] = ETC(B+1,0);
                    iCCRD= [iCCRD ETC_B_val/(LEN-1)];
                    %disp(['ETC_B_val=',num2str(iCCRD)]);
                    
                end
                
                counter = counter+1;
                %                clear A B C ETC_A_val ETC_B_val ETC_C_val
                
                
            end %k loop
        end % q loop
        
        
        for a=1:6 % calculating difference between MEP complexity and ZEP complexity values for the output time series from non-perturbed nodes.
            dCCRD(a)=[iCCRD(a)-iCCRD(a+6)]; %iCCRD(1,2,3,4,5,6) contains MEP complexity values; iCCRD(7,8,9,10,11,12) contains ZEP complexity values
        end
        
        fprintf(1,'\n Differential Compression-Complexity Response Distribution: \n')
        fprintf(1,'{%1.4f, %1.4f}, {%1.4f, %1.4f}, {%1.4f, %1.4f} \n',dCCRD(1), dCCRD(2), dCCRD(3), dCCRD(4), dCCRD(5), dCCRD(6) );
        %disp(dCCRD);
        
        
        % Aggregate dCCRD
        c=1;
        for b=1:3
            aCCRD(b)=[dCCRD(c)+dCCRD(c+1)];
            c=c+2;
        end
        
        fprintf(1,'\n Aggregate Differential Compression-Complexity Measure: \n')
        fprintf(1,'{%1.4f}, {%1.4f}, {%1.4f} \n',aCCRD(1), aCCRD(2), aCCRD(3) );
        %disp(['{' aCCRD(1), '}', ]);
        
        
        
        N = max(aCCRD);
        ETC_network(i,j)=N;
        fprintf(1,'\n Maximal Aggregate Differential Compression-Complexity or PhiC_ETC : \n')
        disp([' PhiC = ',num2str(ETC_network)]);
        
        
        clear dummy %dCCRD aCCRD
        clear ARRAY C counter fid FILENAME
        
    end % j loop
end % i loop
fprintf(1,'>>>>>>>>>>>>>>>>>>> \n');


