function varargout = on_the_image(varargin)
% ON_THE_IMAGE MATLAB code for on_the_image.fig
%      ON_THE_IMAGE, by itself, creates a new ON_THE_IMAGE or raises the existing
%      singleton*.
%
%      H = ON_THE_IMAGE returns the handle to a new ON_THE_IMAGE or the handle to
%      the existing singleton*.
%
%      ON_THE_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ON_THE_IMAGE.M with the given input arguments.
%
%      ON_THE_IMAGE('Property','Value',...) creates a new ON_THE_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before on_the_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to on_the_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help on_the_image

% Last Modified by GUIDE v2.5 10-May-2018 15:32:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @on_the_image_OpeningFcn, ...
                   'gui_OutputFcn',  @on_the_image_OutputFcn, ...
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


% --- Executes just before on_the_image is made visible.
function on_the_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to on_the_image (see VARARGIN)
    % Set up output file
    fid = fopen(sprintf('%s_out.txt', varargin{2}), 'w');
    fprintf(fid, sprintf('Output of DeepDreamGUI, creating ''%s'' from ''%s''\n', ...
            varargin{2}, varargin{1}));
    
    % Choose default command line output for on_the_image
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % Set up necessary data
    initial     = imread(varargin{1});
    generated   = imread(varargin{2});
    scale       = size(initial, 1) / size(generated, 1);
    resized     = imresize(generated, scale);

    % Set up GUI
    setUpImages(initial, generated, handles);
    setUpEuclidean(initial, resized, handles, fid);
    setUpDescStats(initial, resized, handles, fid);
    setUpGraphs(initial, generated, handles)
    
    % Close output file
    fclose(fid);

function setUpImages(initial, generated, handles)
% function setUpImages(initial, generated, handles)
% Function to set up the initial and generated pictures in the GUI
% images.
% Input - initial: Matrix of the initial image
%         generated: Matrix of the generated image
%         handles: Structure with handles and user data
% No output
    % Show initial photo
    axes(handles.initial_image)
    image(initial)
    axis off
    axis image

    % Show generated photo
    axes(handles.generated_image)
    image(generated)
    axis off
    axis image
    
function setUpGraphs(initial, generated, handles)
% function setUpGraphs(initial, generated, handles, fid)
% Function to set up the histograms comparing the initial and generated
% images.
% Input - initial: Matrix of the initial image
%         generated: Matrix of the generated image
%         handles: Structure with handles and user data
%         fid: File to write output to
% No output
    % Set up necessary data
    numBins = 255;

    % Set up B&W histogram
    axes(handles.bw_graph), hold on;
    initBwInfo        = rgb2gray(initial);
    initBwInfo        = initBwInfo(:);
    geneBwInfo        = rgb2gray(generated);
    geneBwInfo        = geneBwInfo(:);

    scale              = size(initial, 1) / size(generated, 1);
    resized            = imresize(geneBwInfo, scale);
    [       ~, tempN1] = MyImageHistogram(resized, numBins);    % Generated image histogram data
    [tempXcen, tempN2] = MyImageHistogram(initBwInfo, numBins); % Initial histogram data
    bar(tempXcen, [tempN1(:), tempN2(:)], 'grouped');
    xlabel('Level, x/255');
    ylabel('Count');

    % Set up red histogram
    axes(handles.red_graph), hold on;
    redInitInfo       = generated(:,:,1);
    redInitInfo       = redInitInfo(:);
    redInfo           = generated(:,:,1);
    redInfo           = redInfo(:);

    scale             = size(initial, 1) / size(generated, 1);
    resized           = imresize(redInfo, scale);
    [       ~, tempN1] = MyImageHistogram(resized, numBins);    % Generated image histogram data
    [tempXcen, tempN2] = MyImageHistogram(redInitInfo, numBins); % Initial histogram data
    bar(tempXcen, [tempN1(:), tempN2(:)], 'grouped');
    xlabel('Level, x/255');
    ylabel('Count');

    % Set up green histogram
    axes(handles.green_graph), hold on;
    greenInitInfo     = generated(:,:,1);
    greenInitInfo     = greenInitInfo(:);
    greenInfo         = generated(:,:,2);
    greenInfo         = greenInfo(:);

    scale  = size(initial, 1) / size(generated, 1);
    resized = imresize(greenInfo, scale);
    [       ~, tempN1] = MyImageHistogram(resized, numBins);    % Generated image histogram data
    [tempXcen, tempN2] = MyImageHistogram(greenInitInfo, numBins); % Initial histogram data
    bar(tempXcen, [tempN1(:), tempN2(:)], 'grouped');

    xlabel('Level, x/255');
    ylabel('Count');

    % Set up blue histogram
    axes(handles.blue_graph), hold on;
    blueInitInfo        = generated(:,:,1);
    blueInitInfo        = blueInitInfo(:);
    blueInfo            = generated(:,:,3);
    blueInfo            = blueInfo(:);

    scale               = size(initial, 1) / size(generated, 1);
    resized             = imresize(blueInfo, scale);
    [       ~, tempN1] = MyImageHistogram(resized, numBins);    % Generated image histogram data
    [tempXcen, tempN2] = MyImageHistogram(blueInitInfo, numBins); % Initial histogram data
    bar(tempXcen, [tempN1(:), tempN2(:)], 'grouped');
    xlabel('Level, x/255');
    ylabel('Count');

% --- Outputs from this function are returned to the command line.
function varargout = on_the_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function dist = getDistance(initMatrix, geneMatrix)
% function dist = getDistance(initMatrix, geneMatrix)
% Function to find the euclidean distance between two 2D matrices.
% Input  - initMatrix: initial image array
%          geneMatrix: generated deep dream image
% Output - dist: Euclidean distance of the given matrices
    matrixDiff  = initMatrix - geneMatrix;
    dist        = sqrt(sum(sum((matrixDiff).^2)));

function setUpEuclidean(initial, generated, handles, fid)
% function setUpEuclidean(initial, generated, handles, fid)
% Function to set up the descriptive stats panel.
% Input - initial: initial image array
%         generated: generated deep dream image
%         handles: structure with handles and user data (see GUIDATA)
%         fid: file to write output to
% No output    
    bwInitMatrix    = rgb2gray(initial);
    bwGeneMatrix    = rgb2gray(generated);
    bwDist          = getDistance(bwInitMatrix, bwGeneMatrix);
    
    redInitMatrix   = initial(:,:,1);
    redGeneMatrix   = generated(:,:,1);
    redDist         = getDistance(redInitMatrix, redGeneMatrix);
    
    greenInitMatrix = initial(:,:,2);
    greenGeneMatrix = generated(:,:,2);
    greenDist       = getDistance(greenInitMatrix, greenGeneMatrix);
    
    blueInitMatrix  = initial(:,:,3);
    blueGeneMatrix  = generated(:,:,3);
    blueDist        = getDistance(blueInitMatrix, blueGeneMatrix);

    set(handles.bw_dist,    'String', bwDist);
    set(handles.red_dist,   'String', redDist);
    set(handles.green_dist, 'String', greenDist);
    set(handles.blue_dist,  'String', blueDist);
    
    fprintf(fid, 'B&W Euclidean distance: %s\n', bwDist);
    fprintf(fid, 'Red Euclidean distance: %s\n', redDist);
    fprintf(fid, 'Green Euclidean distance: %s\n', greenDist);
    fprintf(fid, 'Blue Euclidean distance: %s\n', blueDist);


function mean = getMean(imData)
% function mean = getMean(imData)
% Finds mean of the given data
% Input  - imData: array with data to find median for
% Output - mean: median of given data
    imData = imData(:);
    dataSum = sum(imData);
    mean    = dataSum / length(imData);

function median = getMedian(imData)
% function median = getMedian(imData)
% Finds median of the given data
% Input  - imData: array with data to find median for
% Output - median: median of given data
    imData = imData(:);
    midIdx = length(imData) / 2;
    imData = sort(imData);
        
    if mod(length(imData), 2) == 0
        median = (imData(midIdx) + imData(midIdx + 1)) / 2;
        return
    end
    
    median = imData (midIdx);
    

function stddev = getStdDev(data, mean)
% function stddev = getStdDev(imData, mean)
% Find the standard deviation for the given data
% Input  - data: data to find the std dev
%          mean: mean of the given data
% Output - stddev: calculated standard deviation
    data      = data(:);
    sumData     = sum(abs(data - mean) .^ 2);
    variance    = sumData / (length(data) - 1);
    stddev      = variance ^ 2;

    
function setUpDescStats(initial, generated, handles, fid)
% function setupDescStats(initial, generated, handles)
% Function to set up the descriptive stats panel.
% Input - initial: initial image array
%         generated: generated deep dream image
%         handles: structure with handles and user data (see GUIDATA)
%         fid: file to write output to
% No output
    initMean = getMean(initial);
    geneMean = getMean(generated);
    set(handles.mean_text, 'String', geneMean);
    set(handles.mean_before, 'String', initMean);
    
    initMedian = getMedian(initial);
    geneMedian = getMedian(generated);
    set(handles.median_text, 'String', geneMedian);
    set(handles.median_before, 'String', initMedian);

    initStdDev = getStdDev(initial, initMean);
    geneStdDev = getStdDev(generated, geneMean);
    set(handles.stddev_text, 'String', geneStdDev);
    set(handles.stddev_before, 'String', initStdDev);
    
    fprintf(fid, 'Initial:output mean: %s:%s\n',  ...
            initMean, geneMean);
    fprintf(fid, 'Initial:output median: %d:%d\n',  ...
            initMedian, geneMedian);
    fprintf(fid, 'Initial:output standard deviation: %s:%s\n', ...
            initStdDev, geneStdDev);    
