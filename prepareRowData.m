function IG=prepareRowData(I,SIG)

% prepareRowData crops part of the initial image (120,120) and filters it.
% Set the corner values of the filtered image the same as the corner
% values of the raw data (low) in order to improve the triangulation
%
%
% SYNOPSIS   IG=prepareRowData(I,SIG)
%
% INPUT      I          :   raw data
%            SIG        :   sigma of the GK
%
% OUTPUT     IG         :   filtered image
%
% REMARKS       Used by fsmPrepMainSecondarySpeckles when the detection algorithm is run
%               independently from the software package
%
% DEPENDENCES   prepareRowData uses { Gauss2d}
%               prepareRowData is used by { fsmPrepMainSecondarySpeckles }
%
% Alexandre Matov, November 7th, 2002

% extracting the Bit Depth information
aux=class(I);
switch aux
case 'uint8'
    BitDepth=8;
    I=double(I); % initial treatment of the raw data
    I=I/(2^BitDepth-1); % convert back the images
case 'uint16'
    BitDepth=16;
    I=double(I);
    I=I/(2^(BitDepth-2)-1);
otherwise
    error('unknown bit depth')
end
 
% I=double(I);
% I=I/(2^14-1);
% % I=I/(2^8-1);

% filter image
IG=Gauss2D(I,1);

% set the corner values of the filtered image the same as the corner values of the raw data (low) in order to improve the triangulation
IG(1,1)=I(1,1);
IG(1,size(IG,2))=I(1,size(I,2));
IG(size(IG,1),1)=I(size(I,1),1);
IG(size(IG,1),size(IG,2))=I(size(I,1),size(I,2));