function varargout = Sarcoidosis_Project(varargin)
% SARCOIDOSIS_PROJECT MATLAB code for Sarcoidosis_Project.fig
%      SARCOIDOSIS_PROJECT, by itself, creates a new SARCOIDOSIS_PROJECT or raises the existing
%      singleton*.
%
%      H = SARCOIDOSIS_PROJECT returns the handle to a new SARCOIDOSIS_PROJECT or the handle to
%      the existing singleton*.
%
%      SARCOIDOSIS_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SARCOIDOSIS_PROJECT.M with the given input arguments.
%
%      SARCOIDOSIS_PROJECT('Property','Value',...) creates a new SARCOIDOSIS_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sarcoidosis_Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sarcoidosis_Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sarcoidosis_Project

% Last Modified by GUIDE v2.5 08-May-2022 17:00:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sarcoidosis_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Sarcoidosis_Project_OutputFcn, ...
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


% --- Executes just before Sarcoidosis_Project is made visible.
function Sarcoidosis_Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sarcoidosis_Project (see VARARGIN)

% Choose default command line output for Sarcoidosis_Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes1);
% imshow('vidyanikethan.png');
[img,cmap] = imread('vidyanikethan.png');
cla(handles.axes1, 'reset');
colormap(handles.axes1, cmap);
axes(handles.axes1);
imshow(img, []);
% UIWAIT makes Sarcoidosis_Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sarcoidosis_Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=imread('sarcoidosis.bmp');
axes(handles.axes2);
imshow(i);
title('Original Image', 'FontSize', 10);
M=[];

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=imread('sarcoidosis.bmp');
x=im2bw(a, graythresh(a)); 
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(x), hy, 'replicate'); 
Ix = imfilter(double(x), hx, 'replicate'); 
gradmag = sqrt(Ix.^2 + Iy.^2); 
axes(handles.axes3);
% imshow(a);
imshow(gradmag)
title('ORIGINAL IMAGE SEGMENTATION', 'FontSize', 8);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=imread('sarcoidosis.bmp');
%figure, imshow(I,'DisplayRange',[]);
I7=imread('sarcoidosis.bmp');
I=im2bw(I, graythresh(I));
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate'); 
gradmag = sqrt(Ix.^2 + Iy.^2);
%figure, imshow(gradmag,[]), title('GRADIENT OF IMAGE')
L = watershed(gradmag);
se = strel('disk',4); 
Io = imopen(I, se);
%figure, imshow(Io), title('IMAGE OPEN') ;
Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);
%figure, imshow(Iobr), title('IMAGE RECONSTRUCT')
Ioc = imclose(Io, se);
%figure, imshow(Ioc), title('Ioc') ;
Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr)); 
Iobrcbr = imcomplement(Iobrcbr);
%figure, imshow(Iobrcbr), title('IMAGE COMPLEMENT') 
fgm = imregionalmax(Iobrcbr);
%figure;
% imshow(fgm);
% title('FORE GROUND IMAGE')
I2 = I; I2(fgm) = 0;
%figure, imshow(I2), title('FOREGROUND SUPERIMPOSED')
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 255);
I3 = I;
I3(fgm4) = 255;
D = bwdist(I3);
DL = watershed(D);
bgm = DL ==0;
%figure, imshow(bgm), title('BACK GROUND IMAGE')
gradmag2 = imimposemin(gradmag, fgm4 | bgm);
L = watershed(gradmag2); I4 = I;
I4(imdilate(L == 100, ones(3, 3)) | fgm4 | bgm) = 255;
%figure, imshow(I4), title('MARKERS AND BOUNDARIES SUPERIMPOSED ON ORIGINAL IMAGE') ;
Lrgb =label2rgb(bgm, 'jet', 'w', 'shuffle');
%figure, imshow(Lrgb)
% title('Lrgb')
% figure, imshow(I);
% hold on
% himage = imshow(bgm);
% set(himage, 'AlphaData', 0.3);
% title('Lrgb superimposed transparently on original image') ;
H = fspecial('sobel');
J = roifilt2(H,I,bgm);
maskImage = imfill(bgm, 'holes'); % Fill holes.
maskImage = cast(maskImage, class(I7)); % Match integer types
%I7=im2bw(I7);
%I8= im2bw(I7).* maskImage;
I8(:,:,1) = I7(:,:,1).* maskImage;
I8(:,:,2) = I7(:,:,2).* maskImage;
I8(:,:,3) = I7(:,:,3).* maskImage;% Do the masking.
%figure, imshow(I8,'DisplayRange',[]);
%title(' region of interest - extracted lung area'); 
[cA1,cH1,cV1,cD1] = dwt2(I8,'bior3.7');
sx = size(I8);
A1 = idwt2(cA1,[],[],[],'bior3.7',sx);
H1 = idwt2([],cH1,[],[],'bior3.7',sx);
V1 = idwt2([],[],cV1,[],'bior3.7',sx);
D1 = idwt2([],[],[],cD1,'bior3.7',sx);
%figure, imshow(A1,'DisplayRange',[]); 
Y1=wcodemat(A1,192);
% Y1=double(Y1);
% subplot(2,2,1);
% image(uint8(Y1));
% title('Approximation A1')
% subplot(2,2,2)
Y2=wcodemat(H1,192);
%title('Horizontal Detail H1')
Y3=wcodemat(V1,192);
% Y3=wcodemat(V1,192);
% Y3=double(Y3);
% subplot(2,2,3)
% title('Vertical Detail V1');
% image(uint8(Y3));
Y4=wcodemat(D1,192);
%subplot(2,2,4, image(uint8(Y4));
pasa0=double(I);
edgepasa=logical(bgm);
LungMap=imfill(edgepasa,'holes'); 
LungMap=imdilate(LungMap,ones(3)); 
tmp=LungMap.*pasa0; 
LungMap=imfill(tmp,'holes').*(tmp<10);
%Empirical threshold
LungMap=imdilate(LungMap,ones(2)); 
LungMap=logical(LungMap); 
LungMap=imfill(LungMap,'holes');
theResult=LungMap.*pasa0;
%figure, imshow(theResult,'DisplayRange',[]); 
axes(handles.axes4)
imshow(theResult) 
title('ORIGINAL ROI', 'FontSize', 10);
% disp('Original o/p');
% disp(1);
pause(5);
bw = bwareaopen(theResult,100);
axes(handles.axes5)
imshow(bw)
title('Possible Abnormalities');

% fill a gap in the pen's cap
se = strel('disk',2);
bw = imclose(bw,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw = imfill(bw,'holes');
%figure,imshow(bw)
[B,L] = bwboundaries(bw,'noholes');
axes(handles.axes6)
% Display the label matrix and draw each boundary
%imshow(label2rgb(L, @jet, [.5 .5 .5]))

imshow(bw)
hold on
% for k = 1:length(B)
%   boundary = B{k};
%   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
%   end
stats = regionprops(L,'Area','Centroid');
threshold = 150;

% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;

  % display the results
  metric_string = sprintf('%2.2f',area);

  % mark objects above the threshold with a black circle
  if area > threshold
    centroid = stats(k).Centroid;
    plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 2)
    %plot(centroid(1),centroid(2),'ko');
    text(boundary(1,2)+20,boundary(1,1)-13,metric_string,'Color','r',...
     'FontSize',10,'FontWeight','bold');
  end
     title('Annotated Abnormalities');  
end
