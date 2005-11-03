function handles = ConvertToImage(handles)

% Help for the Quick Fix Convert Objects To Image module:
% Category: Object Processing
%
% SHORT DESCRIPTION:
% n/a
% *************************************************************************
%
% This module hasn't really been written yet, much less documented.
%
% See also <nothing relevant>

% CellProfiler is distributed under the GNU General Public License.
% See the accompanying file LICENSE for details.
%
% Developed by the Whitehead Institute for Biomedical Research.
% Copyright 2003,2004,2005.
%
% Authors:
%   Anne Carpenter <carpenter@wi.mit.edu>
%   Thouis Jones   <thouis@csail.mit.edu>
%   In Han Kang    <inthek@mit.edu>
%   Ola Friman     <friman@bwh.harvard.edu>
%   Steve Lowe     <stevelowe@alum.mit.edu>
%   Joo Han Chang  <joohan.chang@gmail.com>
%   Colin Clarke   <colinc@mit.edu>
%   Mike Lamprecht <mrl@wi.mit.edu>
%   Susan Ma       <xuefang_ma@wi.mit.edu>
%
% $Revision$

%%%%%%%%%%%%%%%%
%%% VARIABLES %%%
%%%%%%%%%%%%%%%%
drawnow

%%% Reads the current module number, because this is needed to find
%%% the variable values that the user entered.
CurrentModule = handles.Current.CurrentModuleNumber;
CurrentModuleNum = str2double(CurrentModule);
ModuleName = char(handles.Settings.ModuleNames(CurrentModuleNum));

%textVAR01 = What did you call the objects you want to process?
%infotypeVAR01 = objectgroup
%inputtypeVAR01 = popupmenu
ObjectName = char(handles.Settings.VariableValues{CurrentModuleNum,1});

%textVAR02 = What do you want to call the resulting image?
%defaultVAR02 = CellImage
%infotypeVAR02 = imagegroup indep
ImageName = char(handles.Settings.VariableValues{CurrentModuleNum,2});

%textVAR03 = Do you want the image to be?
%choiceVAR03 = Binary
%choiceVAR03 = Grayscale
%choiceVAR03 = Color
%inputtypeVAR03 = popupmenu
ImageMode = char(handles.Settings.VariableValues{CurrentModuleNum,3});

%textVAR04 = For COLOR, what do you want the colormap to be?
%defaultVAR04 = Default
ColorMap = char(handles.Settings.VariableValues{CurrentModuleNum,4});

%%%VariableRevisionNumber = 1

LabelMatrixImage = handles.Pipeline.(['Segmented' ObjectName]);
if strcmp(ImageMode,'Binary')
    Image = logical(LabelMatrixImage ~= 0);
elseif strcmp(ImageMode,'Grayscale')
    Image = double(LabelMatrixImage / max(max(LabelMatrixImage)));
elseif strcmp(ImageMode,'Color')
    if strcmp(ColorMap,'Default')
        Image = CPlabel2rgb(handles,LabelMatrixImage);
    else
        try
            cmap = eval([ColorMap '(max(64,max(LabelMatrixImage(:))))']);
        catch
            error(['The ColorMap, ' ColorMap ', that you entered, is not valid']);
        end
        Image = label2rgb(LabelMatrixImage,cmap,'k');
    end
end

handles.Pipeline.(ImageName) = Image;

%%%%%%%%%%%%%%%%%%%%%%
%%% DISPLAY RESULTS %%%
%%%%%%%%%%%%%%%%%%%%%%
drawnow

fieldname = ['FigureNumberForModule',CurrentModule];
ThisModuleFigureNumber = handles.Current.(fieldname);
if any(findobj == ThisModuleFigureNumber)
    drawnow
    CPfigure(handles,ThisModuleFigureNumber);
    ColoredLabelMatrixImage = CPlabel2rgb(handles,LabelMatrixImage);
    subplot(2,1,1);
    ImageHandle = imagesc(ColoredLabelMatrixImage);
    set(ImageHandle,'ButtonDownFcn','CPImageTool(gco)');
    title('Original Identified Objects','fontsize',8);
    subplot(2,1,2);
    ImageHandle = imagesc(Image);
    set(ImageHandle,'ButtonDownFcn','CPImageTool(gco)');
    title('New Image','fontsize',8);
end