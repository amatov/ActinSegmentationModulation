function [roi,count] = candsRoi(cands,posMin,posMax)
%assigns 'cands' to the respective Regions Of Interest

indxList=[];
le=length(cands);
roi = struct('posMin',[posMin(1) posMin(2)],'posMax',[posMax(1) posMax(2)],'indxList',[indxList]);
count=0;
for i = 1:le
    % change to INSIDE
    if cands(i).Lmax(1) >= posMin(2) & cands(i).Lmax(1) <= posMax(2) & cands(i).Lmax(2) >= posMin(1) & cands(i).Lmax(2) <= posMax(1) & cands(i).status == 1
        count=count+1;
        roi(count).indxList = i; 
    end     
end


