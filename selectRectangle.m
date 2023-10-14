function [posMin,posMax,sRectangle,c]=selectRectangle

% selects region in an image 

k = waitforbuttonpress; % only if you dont have an open figure

enough = 0;
c = 1; % counter of RsOI
while ~enough
    
    answer = questdlg('Please select region or Exit','','Select','Exit','Select');
    if strcmp (answer,'Select')
        
        
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        posMin(c,:) = min(point1,point2);        % lower left corner
        posMax(c,:) = max(point1,point2);        % upper right corner
        sRectangle  = rectangle('Position',[posMin(c,:),posMax(c,:)-posMin(c,:)],'EdgeColor','r');
        
        c = c + 1;
    else 
        enough = 1;
    end
    
end % ~enough