function varargout = basicISSTrackGui(varargin)
% BASICISSTRACKGUI MATLAB code for basicISSTrackGui.fig
%      BASICISSTRACKGUI, by itself, creates a new BASICISSTRACKGUI or raises the existing
%      singleton*.
%
%      H = BASICISSTRACKGUI returns the handle to a new BASICISSTRACKGUI or the handle to
%      the existing singleton*.
%
%      BASICISSTRACKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASICISSTRACKGUI.M with the given input arguments.
%
%      BASICISSTRACKGUI('Property','Value',...) creates a new BASICISSTRACKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before basicISSTrackGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to basicISSTrackGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help basicISSTrackGui

% Last Modified by GUIDE v2.5 14-Dec-2014 18:45:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @basicISSTrackGui_OpeningFcn, ...
                   'gui_OutputFcn',  @basicISSTrackGui_OutputFcn, ...
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


% --- Executes just before basicISSTrackGui is made visible.
function basicISSTrackGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to basicISSTrackGui (see VARARGIN)

% Choose default command line output for basicISSTrackGui
handles.output = hObject;

global tumin mu radiusearthkm xke j2 j3 j4 j3oj2
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(72);

% setup observer location
handles.observerLoc.lat = 39.985592;
handles.observerLoc.lon = -76.017356;
handles.observerLoc.alt = 0.1518;

[handles.ephermisJson] = updateEphermis();

[handles.satrec] = json2satrec(handles.ephermisJson);

handles.currentTime = datevec(now);

handles.currentJulianTime = jday(handles.currentTime(1),handles.currentTime(2),...
    handles.currentTime(3),handles.currentTime(4),...
    handles.currentTime(5),handles.currentTime(6));

handles.epherimesAge = etime(handles.currentTime,[handles.satrec.epochyear,...
    handles.satrec.epochmon,handles.satrec.epochday,...
    handles.satrec.epochhour,handles.satrec.epochmin,...
    handles.satrec.epochsec])/60;

[handles.satrec, handles.r, handles.v] = sgp4(handles.satrec,handles.epherimesAge);

[ handles.az,handles.el,handles.rg ] = lookangles( ...
    handles.r(1,1),handles.r(1,2),handles.r(1,3),...
    handles.observerLoc.lat,handles.observerLoc.lon,...
    handles.observerLoc.alt,handles.currentJulianTime );

set(handles.azimuthText,'String',num2str(handles.az));
set(handles.elevationText,'String',num2str(handles.el));
set(handles.rangeText,'String',num2str(handles.rg));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes basicISSTrackGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = basicISSTrackGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function azimuthText_Callback(hObject, eventdata, handles)
% hObject    handle to azimuthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of azimuthText as text
%        str2double(get(hObject,'String')) returns contents of azimuthText as a double


% --- Executes during object creation, after setting all properties.
function azimuthText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azimuthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elevationText_Callback(hObject, eventdata, handles)
% hObject    handle to elevationText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elevationText as text
%        str2double(get(hObject,'String')) returns contents of elevationText as a double


% --- Executes during object creation, after setting all properties.
function elevationText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevationText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rangeText_Callback(hObject, eventdata, handles)
% hObject    handle to azimuthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of azimuthText as text
%        str2double(get(hObject,'String')) returns contents of azimuthText as a double


% --- Executes during object creation, after setting all properties.
function rangeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azimuthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in ephermisRefreshButton.
function ephermisRefreshButton_Callback(hObject, eventdata, handles)
% hObject    handle to ephermisRefreshButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Gets surface Z data, adds noise, and writes it back to surface object.



[handles.satrec] = json2satrec(handles.ephermisJson);

handles.currentTime = datevec(now);

handles.currentJulianTime = jday(handles.currentTime(1),handles.currentTime(2),...
    handles.currentTime(3),handles.currentTime(4),...
    handles.currentTime(5),handles.currentTime(6));

handles.epherimesAge = etime(handles.currentTime,[handles.satrec.epochyear,...
    handles.satrec.epochmon,handles.satrec.epochday,...
    handles.satrec.epochhour,handles.satrec.epochmin,...
    handles.satrec.epochsec])/60;

[handles.satrec, handles.r, handles.v] = sgp4(handles.satrec,handles.epherimesAge);

[ handles.az,handles.el,handles.rg ] = lookangles( ...
    handles.r(1,1),handles.r(1,2),handles.r(1,3),...
    handles.observerLoc.lat,handles.observerLoc.lon,...
    handles.observerLoc.alt,handles.currentJulianTime );

set(handles.azimuthText,'String',num2str(handles.az));
set(handles.elevationText,'String',num2str(handles.el));
set(handles.rangeText,'String',num2str(handles.rg));

% Update handles structure
guidata(hObject, handles);





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject,eventdata,hfigure)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% START USER CODE
% Necessary to provide this function to prevent timer callback
% from causing an error after GUI code stops executing.
% Before exiting, if the timer is running, stop it.
if strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
end
% Destroy timer
delete(handles.timer)
% END USER CODE

% Hint: delete(hObject) closes the figure
delete(hObject);




