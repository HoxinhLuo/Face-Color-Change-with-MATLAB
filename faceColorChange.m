function varargout = faceColorChange(varargin)
% FACECOLORCHANGE MATLAB code for faceColorChange.fig
%      FACECOLORCHANGE, by itself, creates a new FACECOLORCHANGE or raises the existing
%      singleton*.
%
%      H = FACECOLORCHANGE returns the handle to a new FACECOLORCHANGE or the handle to
%      the existing singleton*.
%
%      FACECOLORCHANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACECOLORCHANGE.M with the given input arguments.
%
%      FACECOLORCHANGE('Property','Value',...) creates a new FACECOLORCHANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before faceColorChange_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to faceColorChange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help faceColorChange

% Last Modified by GUIDE v2.5 18-Jul-2018 09:44:30

% Begin initialization code - DO NOT EDIT
clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @faceColorChange_OpeningFcn, ...
    'gui_OutputFcn',  @faceColorChange_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before faceColorChange is made visible.
function faceColorChange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to faceColorChange (see VARARGIN)

% Choose default command line output for faceColorChange
clc;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes faceColorChange wait for user response (see UIRESUME)
% uiwait(handles.figure1);
I = imread('face.png');
javaImage = im2java2d(I);
newIcon = javax.swing.ImageIcon(javaImage);
figFrame = get(handles.figure1, 'JavaFrame'); %get Figure's JavaFrame¡£
figFrame.setFigureIcon(newIcon);        %change icon
guidata(hObject, handles);
% if ~isdeployed  
%     newIcon=javax.swing.ImageIcon('face.png');    
% else    
%     newIcon=javax.swing.ImageIcon('face.png');    
% end
% % jFrame = get(handle(hObject),'javaframe');
% jFrame = get(handle(handles.figure1), 'javaframe');
% jFrame.setFigureIcon(newIcon);


% --- Outputs from this function are returned to the command line.
function varargout = faceColorChange_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function showAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate showAxes
set(hObject, 'xTick', []);
set(hObject, 'yTick', []);
set(hObject, 'box', 'on');


% --- Executes on button press in selectBTN.
function selectBTN_Callback(hObject, eventdata, handles)
% hObject    handle to selectBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global path;
global fileName;
global out;
global aveR;
global aveG;
global aveB;
global CImg;
global R G B;

axes(handles.showAxes);
[fileName, pathName] = uigetfile(...
    {'*.jpg;*.tif;*.png;*.gif;*.jpeg', 'Images';...
    '*.*','All Files' }, 'Select Image', 'MultiSelect', 'on');
path = strcat(pathName, fileName);

if ~strcmp(path, '')
    set(handles.pathListbox, 'String', path);
    img = imread(path);
    imshow(img);
    out = faceDetection(path);
end
CImg = img;
[R, G, B] = getRGB(CImg);

aveR = getColorEverage(R, out);
aveG = getColorEverage(G, out);
aveB = getColorEverage(B, out);

aveR = round(aveR);
aveG = round(aveG);
aveB = round(aveB);
set(handles.RSlider, 'value', aveR);
set(handles.GSlider, 'value', aveG);
set(handles.BSlider, 'value', aveB);
set(handles.REdit, 'String', num2str(aveR));
set(handles.GEdit, 'String', num2str(aveG));
set(handles.BEdit, 'String', num2str(aveB));


% --- Executes on button press in saveImgBTN.
function saveImgBTN_Callback(hObject, eventdata, handles)
% hObject    handle to saveImgBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileName;
global CImg;
filepath = uigetdir('*.*', 'SELECT SAVE FOLDER');
filepath = strcat(filepath, '\COLORCHANGE', fileName);

if ~isempty(CImg)
    imwrite(CImg, filepath);
end


% --- Executes on button press in exitBTN.
function exitBTN_Callback(hObject, eventdata, handles)
% hObject    handle to exitBTN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
delete(hObject);


% --- Executes on slider movement.
function RSlider_Callback(hObject, eventdata, handles)
% hObject    handle to RSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global aveR;
global R;
global CImg;
global out;
axes(handles.showAxes);
Rnum = get(handles.RSlider, 'value');
Rnum = round(Rnum);
dif = Rnum - aveR;
aveR = Rnum;
set(handles.REdit, 'String', num2str(aveR));
[w, h] = size(R);
for row = 1 : w
    for col = 1 : h
        if out(row, col) == 255
            R(row, col) = R(row, col) + dif;
        end
    end
end
CImg(:, :, 1) = R;
imshow(CImg);


% --- Executes during object creation, after setting all properties.
function RSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function REdit_Callback(hObject, eventdata, handles)
% hObject    handle to REdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of REdit as text
%        str2double(get(hObject,'String')) returns contents of REdit as a double


% --- Executes during object creation, after setting all properties.
function REdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to REdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function GSlider_Callback(hObject, eventdata, handles)
% hObject    handle to GSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global aveG;
global G;
global CImg;
global out;
axes(handles.showAxes);
Gnum = get(handles.GSlider, 'value');
Gnum = round(Gnum);
dif = Gnum - aveG;
aveG = Gnum;
set(handles.GEdit, 'String', num2str(aveG));
[w, h] = size(G);
for row = 1 : w
    for col = 1 : h
        if out(row, col) == 255
            G(row, col) = G(row, col) + dif;
        end
    end
end
CImg(:, :, 2) = G;
imshow(CImg);


% --- Executes during object creation, after setting all properties.
function GSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function GEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GEdit as text
%        str2double(get(hObject,'String')) returns contents of GEdit as a double


% --- Executes during object creation, after setting all properties.
function GEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function BSlider_Callback(hObject, eventdata, handles)
% hObject    handle to BSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global aveB;
global B;
global CImg;
global out;
axes(handles.showAxes);
Bnum = get(handles.BSlider, 'value');
Bnum = round(Bnum);
dif = Bnum - aveB;
aveB = Bnum;
set(handles.BEdit, 'String', num2str(aveB));
[w, h] = size(B);
for row = 1 : w
    for col = 1 : h
        if out(row, col) == 255
            B(row, col) = B(row, col) + dif;
        end
    end
end
CImg(:, :, 3) = B;
imshow(CImg);



% --- Executes during object creation, after setting all properties.
function BSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function BEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BEdit as text
%        str2double(get(hObject,'String')) returns contents of BEdit as a double


% --- Executes during object creation, after setting all properties.
function BEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in pathListbox.
function pathListbox_Callback(hObject, eventdata, handles)
% hObject    handle to pathListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pathListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pathListbox


% --- Executes during object creation, after setting all properties.
function pathListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
