function [subj_num,min_index] = measurement_matchtest()
load anthro.mat
lengths =[];
prompt = {'d1, cavum concha height', 'd2, cymba concha height', 'd3, cavum concha width',...
    'd4, fossa height', 'd5, pinna height', 'd6, pinna width', 'd7, intertragal incisure width',...
    'd8, cavum concha depth'};
dlgtitle = 'Ear measurements';
definput={'1.8586', '0.6892', '1.5484', '1.5011', '6.3946', '2.8862', '0.5513', '0.9525'}; %based on avgs
dims = [1 35];
left_input=inputdlg(prompt,dlgtitle,dims,definput);
%change input to numeric vector


%assess length of inputs
for j=1:8
    query_answer = left_input(j);
    TF = contains(query_answer,".");
     if TF == 0
        L = strlength(query_answer);
        lengths = [lengths; L]; 
     else
       L = strlength(query_answer)-1;
       lengths = [lengths; L]; 
     end
end


%if not the same precision, go to least precise
if min(lengths) ~= max(lengths)
    cut_off = min(lengths);
    for k=1:8
       query_answer = left_input(k);
        TF = contains(query_answer,".");
       if TF == 1
           left_input(k) = extractBetween(left_input(k),1,min(lengths+1));
       end
    end
end
       
           

left_input=cell2mat(left_input);
left_input=str2num(left_input);
left_input=transpose(left_input);
dists=zeros(1, 45); %vector to hold distances
for i=1:45
    dists(i)=norm(left_input-D(i, 1:8)); %Euclidian distance
end
[min_dist, min_index]=min(dists); %retrieve minimum distance and its index
sprintf('Your closest match is subject %d, the Euclidian distance is %f', id(min_index), min_dist)
subj_num=id(min_index);
end