function varargout = DeepDreamGUI(varargin)
% DEEPDREAMGUI MATLAB code for DeepDreamGUI.fig
%      DEEPDREAMGUI, by itself, creates a new DEEPDREAMGUI or raises the existing
%      singleton*.
%
%      H = DEEPDREAMGUI returns the handle to a new DEEPDREAMGUI or the handle to
%      the existing singleton*.
%
%      DEEPDREAMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEEPDREAMGUI.M with the given input arguments.
%
%      DEEPDREAMGUI('Property','Value',...) creates a new DEEPDREAMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeepDreamGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeepDreamGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeepDreamGUI

% Last Modified by GUIDE v2.5 10-May-2018 18:26:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DeepDreamGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DeepDreamGUI_OutputFcn, ...
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

% --- Executes just before DeepDreamGUI is made visible.
function DeepDreamGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeepDreamGUI (see VARARGIN)

% Choose default command line output for DeepDreamGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set up initial image
axes(handles.initial_image)
matlabImage = imread('sample_pictures/flower.jpg');
image(matlabImage)
axis off
axis image

if size(varargin) ~= [0, 0]
    connectedLayer  = 23;
    iterations      = 25;
    pyr_scale       = 3;
    init_image      = varargin{1};
    output_name     = varargin{2};
    active_ch       = varargin{3};
    
    initImage = imread(init_image);

    I = deepDreamImage(alexnet,connectedLayer, active_ch, 'InitialImage', initImage,...
        'NumIterations', iterations, 'PyramidScale', pyr_scale);

    imwrite(I, output_name);
end


% UIWAIT makes DeepDreamGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DeepDreamGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function iteration_slider_Callback(hObject, eventdata, handles)
% hObject    handle to iteration_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    sliderValue = get(handles.iteration_slider,'Value');
    set(handles.iteration_ctr,'String',num2str(round(sliderValue)));


% --- Executes during object creation, after setting all properties.
function iteration_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iteration_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min', 1);
set(hObject,'Max', 100);
set(hObject,'Value', 10);
set(hObject,'SliderStep', [1/99 1/99]);


% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
result = uigetfile;
set(handles.load_text, 'String', result);

% Update initial image on axes
axes(handles.initial_image)
matlabImage = imread(result);
image(matlabImage)
axis off
axis image

% --- Executes on selection change in channel_listbox.
function channel_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to channel_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel_listbox


% --- Executes during object creation, after setting all properties.
function channel_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load('ChannelNames.mat', 'names');
set(hObject,'String', names)

function output_edit_Callback(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_edit as text
%        str2double(get(hObject,'String')) returns contents of output_edit as a double


% --- Executes during object creation, after setting all properties.
function output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Set up necessary data
connectedLayer  = 23;
iterations      = str2num(get(handles.iteration_ctr, 'String'));
pyr_scale       = str2num(get(handles.pyramid_ctr, 'String'));
active_ch       = get(handles.active_listbox, 'String');
init_image      = get(handles.load_text, 'String');
output_name     = get(handles.output_edit, 'String');

% Get correct animal indices to activate correct layers for deep dreaming
connected_channels = zeros(size(active_ch));
load('ChannelNames.mat', 'names');
for i=1:size(active_ch,1)
    temp = active_ch(i);
    connected_channels(i) = find(ismember(names, temp));
end

initImage = imread(init_image);

% Give user prompt that image is being generated
set(handles.creating_image_text,'Visible','On')

I = deepDreamImage(alexnet,connectedLayer, connected_channels, 'InitialImage', initImage,...
    'NumIterations', iterations, 'PyramidScale', pyr_scale);

% Give user prompt that image has been created
set(handles.image_created_text,'Visible','On')

imwrite(I, output_name);
on_the_image(init_image, output_image);


% --- Executes on button press in remove_pushbutton.
function remove_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to remove_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
textbox     = handles.active_listbox;
current     = get(textbox, 'String');

if size(current, 2) < 1 % Check for edge case
    return
end

% Remove the current value from the listbox
to_remove   = get(textbox, 'Value');
current(to_remove) = [];
set(textbox, 'String', current);


% --- Executes on slider movement.
function pyramid_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pyramid_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderValue = get(handles.pyramid_slider,'Value');
% Makes slider move in hundredth increments
set(handles.pyramid_ctr,'String',num2str(round(sliderValue, 2)));


% --- Executes during object creation, after setting all properties.
function pyramid_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pyramid_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min', 1);
set(hObject,'Max', 10);
set(hObject,'Value', 1.4);

% --- Executes on button press in add_pushbutton.
function add_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to add_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
textbox     = handles.active_listbox;
prev_data   = get(textbox, 'String');
to_add      = get(handles.channel_listbox, 'Value');

load('ChannelNames.mat', 'names');
if any(strcmp(prev_data, names(to_add))) % Ensure no duplicates
    return
end

set(textbox, 'String', [prev_data; names(to_add)]);


% --- Executes during object creation, after setting all properties.
function active_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to active_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handlers not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Start with random value
load('ChannelNames.mat', 'names');
random_channel = names{randi([1 size(names, 1)])};
set(hObject,'String', cellstr(random_channel))
