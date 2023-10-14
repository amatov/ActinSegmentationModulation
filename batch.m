% example script for running batch jobs using getModulation
%--------------------------------------------------------------------------
try
    fileName='';
    dirName='';
    
    dirName(1,:) ='P:\Mike\contrast\CMV_Vinc\cell02\';
    dirName(2,:)='P:\Mike\contrast\CMV_Vinc\cell02\';
    
    fileName(1,:)='AOTF488_15_c02_dl.tif';
    fileName(2,:)='AOTF488_15_c02_ds.tif';
    
    getModulation(dirName,fileName,2,10,1,2,[200 300; 300 400],50);
    
catch
    disp('In batch job 1 there was the following error:'); % change the number every time
    disp(lasterr);
end
%--------------------------------------------------------------------------
try
    fileName='';
    dirName='';
    
    dirName(1,:) = 'P:\Mike\contrast\CMV_Vinc\cell11\';
    
    fileName(1,:)='AOTF488_32_c11_dl.tif';
    
    getModulation(dirName,fileName,1,10,1,2,[250 250],70);
    
catch
    disp('In batch job 2 there was the following error:'); % change the number every time
    disp(lasterr);
end
%--------------------------------------------------------------------------
%SYNOPSIS getModulation(dirName,fileName,num,border,sigma,flag,posMin,posMax)
%
%INPUT     num : number of images to be processed (default 5)
%        sigma : FWHM of GK filter (0.21*lambda/NA/Pxy)
%         flag : (1) select regions manually (default)
%                (2) regions' upper left (x,y) given as 4th input 
%                    and square/region size as 5th
%                (3) regions' coordinates given as 4th & 5th input
%       posMin : upper left coordinate (X,Y) of each region
%       posMax : lower right coordinate (X,Y) of each region 
%                or square/region size 
%       border : in pixels; cut the image from all sides to avoid 
%                sharp intensity variation at the border
%      dirName : directory of each image to be analysed
%                if empty ([]) selection will be manual
%     fileName : name of each image to be analysed
%                if empty ([]) selection will be manual
%
%      example : posMin=[1 2;3 4;5 6] means there are 3 regions
%                and upper left corner of region 1 has (x,y) (1,2)
% 
%OUTPUT          text file & figures