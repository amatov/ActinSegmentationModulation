function getModulation(dirName,fileName,num,border,sigma,flag,posMin,posMax)
%GETMODULATION calculates speckle modulation of selected image regions
%
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
%
%select the images for comparizon and then select the regions of interest
%the function will provide you with the number of speckles in
%the respective regions and the mean modulation, i.e. (peak-bkg)/(peak+bkg)
%
% Alexandre Matov Sept 17, 2003

BATCH=0;
if ~isempty(fileName)
    BATCH=1;
end

if nargin < 3
    num = 5;
    flag = 1;
    %     sigma = 1.3351; % 568
    sigma = 1.1541; % 488
    border = 10;
end
if nargin == 3
    flag = 1;
    %     sigma = 1.3351; % 568
    sigma = 1.1541; % 488
    border = 10;
end
if nargin == 4
    flag = 1;
    %     sigma = 1.3351; % 568
    sigma = 1.1541; % 488
end
if nargin == 5
    flag = 1;
end
if nargin == 7
    error('Missing last argument (square size or maximal position)');
end
if flag~=1 & flag~=2 & flag~=3
    error('Wrong "flag" (enter "1","2" or "3")');
end

% select first image
%if isempty(dirName)
if BATCH==0
    [fileName(1,:),dirName(1,:)] = uigetfile('*.tif','Select image');
end
img=imread([dirName(1,:),filesep,fileName(1,:)]);
img=img(1+border:end-border,1+border:end-border); % cut border pixels from each side
np(1,:)=([dirName(1,:),fileName(1,1:end-4),'np']);
[x,y]=size(img);
I = zeros(x,y,num); % row data
If = zeros(x,y,num); % filtered images
I(:,:,1) = img;
% select 'num'-1 images
for i = 2:num
    
    if BATCH==0
        [fileName(i,:),dirName(i,:)] = uigetfile('*.tif','Select image');
    end
    %end
    auxImg = imread([dirName(i,:),filesep,fileName(i,:)]);
    auxImg=auxImg(1+border:end-border,1+border:end-border); % cut border pixels from each side
    np(i,:)=([dirName(i,:),fileName(i,1:end-4),'np']);
    I(:,:,i)=auxImg;
end

% prepare row data
I=double(I);
I=I/(2^14-1);

candsTot=[];
for i = 1:num  
    If(:,:,i)=Gauss2D(I(:,:,i),sigma);   
%     load(np(i,:));
noiseParam=[1.96/1.12985 0.00028 1e-4 0.00495 1.96];
    [Icands,cands]=fsmPrepMainSecondarySpeckles(If(:,:,i),0,1,noiseParam,[1 0.0/100],0);
    I0(i)=noiseParam(4);
    confSp=find([cands.status]==1); % indx sign spe
    img=I(:,:,i);
    minI(i)=min(img(:));
    maxI(i)=max(img(:));
    meanI(i)=mean(img(:));
    nbLocMax(i)=length(cands);
    nbSp(i)=length(confSp);
    % find outlyers
    [n,h]=hist(img(:));
    mostSpe=find(n>1000);
    indxCut=length(mostSpe);
    cutStretch(i)=h(indxCut);
    % display (hot spots avoided)
    currFig=figure; imshow(I(:,:,i),[minI(i) cutStretch(i)]);
    hold on
    for j=1:length(cands)
        if cands(j).status == 1
            plot(cands(j).Lmax(2),cands(j).Lmax(1),'r.'); 
        end
    end
    lengthCands(i)=length(cands);
    candsTot=cat(2,candsTot,cands);
    % Save image
    hold off
    currDir=cd;
    if exist([dirName(i,:),filesep,'figures'])~=7
        % Subdirectory does not exist - create it
        if ~mkdir(dirName(i,:),'figures');
            error('Could not create directory.');
        end
    end
    cd(dirName(i,:));
    figName = [dirName(i,:),filesep,'figures',filesep,fileName(i,1:end-4),'_ts.fig'];
    saveas(currFig,figName,'fig');
    close(currFig);
end

switch flag
    case 1 % select regions manually
        k = waitforbuttonpress; % only if you dont have an open figure
        enough = 0;
        cR = 1; % counter of RsOI
        while ~enough   
            answer = questdlg('Please select region or Exit','','Select','Exit','Select');
            if strcmp (answer,'Select')
                k = waitforbuttonpress;
                point1 = get(gca,'CurrentPoint');    % button down detected
                finalRect = rbbox;                   % return figure units
                point2 = get(gca,'CurrentPoint');    % button up detected
                point1 = point1(1,1:2);              % extract x and y
                point2 = point2(1,1:2);
                posMin(cR,:) = min(point1,point2);        % lower left corner
                posMax(cR,:) = max(point1,point2);        % upper right corner
                sRectangle  = rectangle('Position',[posMin(cR,:),posMax(cR,:)-posMin(cR,:)],'EdgeColor','g');
                cR = cR + 1;
            else 
                enough = 1;
            end   
        end % ~enough
        
        for a  = 1:num-1
            k = waitforbuttonpress; % click on the other figure
            % draw the same regions on the second figure
            for i = 1:cR-1
                sRectangle  = rectangle('Position',[posMin(i,:),posMax(i,:)-posMin(i,:)],'EdgeColor','g');
            end
        end
    case 2
        posMax=posMin+posMax; % to obtain posMax add to posMin the fifth input argument (square size in this case)
        cR = size(posMin,1) + 1;
    case 3
        cR = size(posMin,1) + 1;
end

aux = 0;
for j = 1:num % number of images
    cands=candsTot(1+aux:lengthCands(j)+aux); % extract the corresponding cands
    H=figure
    imshow(I(:,:,j),[minI(j) cutStretch(j)]);% visual check of results
    hold on
    for i = 1:cR-1 % number of regions
        area = (posMax(i,2)-posMin(i,2))*(posMax(i,1)-posMin(i,1))*(0.064^2);  
        pMax = round(posMax);
        pMin = round(posMin);
        mI = mean(mean(I(pMin(i,2):pMax(i,2),pMin(i,1):pMax(i,1),j)));
        meanInt(i,j)=(mI-I0(j))*(2^14-1); % result
        [roi,spNum] = candsRoi(cands,posMin(i,:),posMax(i,:)); % get the struct for the speckles in the ROI 
        modulation(i,j) = modu([roi.indxList],cands,I0(j)); % result
        if spNum == 0
            specklesPerArea(i,j) = 0;
        else
            specklesPerArea(i,j)=length(roi)/area; % result
        end
        speckles(i,j)=spNum; % result
        indx = [roi.indxList];
        for k = 1:size(indx,2)
            plot(cands(indx(k)).Lmax(2),cands(indx(k)).Lmax(1),'r.'); % visual check of results
        end      
        sRectangle  = rectangle('Position',[posMin(i,:),posMax(i,:)-posMin(i,:)],'EdgeColor','g');
        text(posMax(i,1),posMin(i,2),[' region ',num2str(i)],'Color',[0 1 0]);
        text(posMax(i,1),posMax(i,2),[' speckles ',num2str(spNum)],'Color','r');
    end
    hold off
    currDir=cd;
    cd(dirName(j,:));
    figName = [dirName(j,:),filesep,'figures',filesep,fileName(j,1:end-4),'.fig'];
    saveas(H,figName,'fig');
    close(H);
    cd(currDir);
    aux=aux+lengthCands(j); % update 'aux' to move in the struct of cands
end

% write to file
oldPath=cd;
cd(dirName(1,:));
% Open/create text files
fid=fopen('resultsModulation.txt','a+');
fid2=fopen('resultsModulation_imgStats.txt','a+');
fid3=fopen('resultsModulation_regStats.txt','a+');
fid4=fopen('resultsModulation_rois.txt','a+');

fprintf(fid,'                               Image statistics :\n');
for i = 1:num
    fprintf(fid,'-------------------------------------------------------------------------------------\n');
    fprintf(fid,' Image | min I | max I | mean I | # Speckles | # Significant Sp | mean background I0 \n');
    fprintf(fid,'   %d   %6.0f  %6.0f   %6.0f       %d            %d             %6.0f\n',i,minI(i)*(2^14-1),maxI(i)*(2^14-1),meanI(i)*(2^14-1),nbLocMax(i),nbSp(i),I0(i)*(2^14-1));
    fprintf(fid2,'   %d   %6.0f  %6.0f   %6.0f       %d            %d             %6.0f\n',i,minI(i)*(2^14-1),maxI(i)*(2^14-1),meanI(i)*(2^14-1),nbLocMax(i),nbSp(i),I0(i)*(2^14-1));
end
fprintf(fid,'-------------------------------------------------------------------------------------\n');
for i = 1:num
    for j = 1:cR-1
        fprintf(fid,'------------------------------------------------------------------------------------------------\n');
        fprintf(fid,' Image | Region | Speckle Number | Speckle Density | Speckel Modulation | Mean Region Intensity \n');
        fprintf(fid,'   %d       %d           %d              %6.2f              %6.2f                %6.0f       \n',i,j,speckles(j,i),specklesPerArea(j,i),modulation(j,i),meanInt(j,i));
        fprintf(fid3,'   %d       %d           %d              %6.2f              %6.2f                %6.0f       \n',i,j,speckles(j,i),specklesPerArea(j,i),modulation(j,i),meanInt(j,i));
    end
end
fprintf(fid,'------------------------------------------------------------------------------------------------\n');
for j = 1:cR-1
    fprintf(fid,'-------------------------------------------------------------------------------------------------------------------------\n');
    fprintf(fid,' Region | X upper left corner (min) | Y upper left corner (min) | X lower right corner (max) | Y lower right corner (max)\n');
    fprintf(fid,'   %d              %6.2f                        %6.2f                        %6.2f                       %6.2f\n',j,posMin(j,1),posMin(j,2),posMax(j,1),posMax(j,2));
    fprintf(fid4,'   %d              %6.2f                        %6.2f                        %6.2f                       %6.2f\n',j,posMin(j,1),posMin(j,2),posMax(j,1),posMax(j,2));
end
fprintf(fid,'-------------------------------------------------------------------------------------------------------------------------\n');
% Close files
fclose(fid);
fclose(fid2);
fclose(fid3);
fclose(fid4);

% Change back to original path
cd(oldPath);

% calculate modulation
function m = modu(r,cands,I0)
moduu=zeros(length(r),1);
for i = 1:length(r)
    moduu(i) = (cands(r(i)).ILmax-cands(r(i)).IBkg)/(cands(r(i)).ILmax+cands(r(i)).IBkg-2*I0);
end
if min(moduu)>0
    m = mean(moduu);
else 
    m = 0;
end
