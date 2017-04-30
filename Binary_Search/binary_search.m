% Goals:
% Make array of 0-1 data along a known distribution. Start with bi-modal
% Model uncertainty sampling as the most uncertain point being closest
% to the decision line. Compare with random sampling.

% It looks like I'm having a trouble getting a B for the thresholding in
% uncertainty sampling

%% Data generation phase
% Idea: Add quasi-random noise to linearly increasing data
bot = -100;
top = 99;
linData = bot:top;
noisyData = zeros(size(linData));
midPoint = floor(length(linData)/2);
for i = 0:length(linData)-1
    noisyData(i+1) = linData(i+1) + 500*randi([-midPoint+i,0+i]); 
end

% Now we'll shift the data down to get an even(ish) amount of positive and
% negative values
myData = noisyData - mean(noisyData);
myData(myData==0) = 1; %Get rid of 0's so the sign function works as intended
scatter([1:length(myData)],myData)

% Generating our label values
labels = sign(myData);

% Visualizing our binary, 1-dim data
labelColor = zeros(size(labels),3);
labelColor(labels==1,:) = [0 0 1];
labelColor(labels==-1,:) = [1 0 0];
figure
scatter([1:length(myData)],zeros(1,length(myData)),labelColor)
ylim([-1.5,1.5])



%% Making a classifier
% So we know that, since the data was centered, a threshold at the mean is
% the best classfier. That is y = 1 if x >0; y = -1 otherwise. 

% Since I can't figure out how to pick the decision rule in the next
% step, I'm gonna use an SVM here.
svmBest = fitcsvm([bot:top]', labels');
yPredSvm = predict(svmBest,[bot:top]');

yPredBest = zeros(size(myData));
BestThreshold = floor((bot+top)/2); % this is the midpoint
count = 1;
for i = bot:top
    %Remember our feature is the position in the array, not the array's
    %value
    yPredBest(count) = hThresh(i,BestThreshold);
    count = count +1;
end

% Looking at 0-1 loss as an error function
ccrSVM = sum(labels==yPredSvm')/length(labels);
mystr = sprintf('SVM CCR is: %0.3f', ccrSVM);
disp(mystr)

ccrBest = sum(labels==yPredBest)/length(labels);
mystr = sprintf('Heuristic CCR is: %0.3f', ccrBest);
disp(mystr)

% we should see from the above ccr's that the two methods are comparable

%% Seeding
seedSize = 2;

% Randomly generating our seed
seed = zeros(seedSize,1);
% Initializing our vector of chosen points
idxVec = zeros(size(linData));
for i = 1:seedSize
   seed(i) = randi([bot,top]);
   idxVec(linData==seed(i)) = 1;
end
% Storing the data that we've used for the seed for later
seedIdx = idxVec;


%% Now for the active learning. Starting with random sampling
% This loop keeps running until we use all of the points in the data
count = 1; % Count for error checking

% Sampling 1 at a time
sampSize = 1;

% Making a vector to store the CCRs
ccrRand = zeros(1,ceil(length(linData)/sampSize));

% Starting with our seed
mySample = linData(seedIdx==1);
sampleLabels = labels(seedIdx==1);

while sum(idxVec) ~= length(linData)
    possibleIdx = (idxVec == 0);
    % Training the svm for random sampling
    svmRand = fitcsvm(mySample',sampleLabels');
    % Making prediction for the entire training set (including sampled
    % data
    yRand = predict(svmRand,linData'); 
    ccrRand(count) = sum(labels==yRand')/length(labels);
    
    [newSample] = datasample(linData(possibleIdx), sampSize);
    % Switching on the appropriate indices
    for i = 1:length(newSample)
        idxVec(linData == newSample(i)) = 1;
    end
    % Pulling the points in our new sample set
    mySample = linData(idxVec==1);
    sampleLabels = labels(idxVec==1);
    
    if count >= length(linData)/sampSize
        disp("Error in random sampling >:[") 
        break
    end
    count = count + 1;
end
%Plotting
figure()
plot(1:length(ccrRand),ccrRand)

%% Now for uncertainty sampling
% Resetting our idxVec with the seed so the while loop runs properly
idxVec = seedIdx;

% This loop keeps running until we use all of the points in the data
count = 1; % Count for error checking

% Sampling 1
sampSize = 2;

% Making a vector to store the CCRs
ccrUnc = zeros(1,ceil(length(linData)/sampSize));

% Starting with our seed
mySample = linData(seedIdx==1);
sampleLabels = labels(seedIdx==1);

while sum(idxVec) ~= length(linData)
    % Training the svm for random sampling
    svmUnc = fitcsvm(mySample',sampleLabels');
    % Making prediction for the entire training set (including sampled
    % data)
    yUnc = predict(svmUnc,linData'); 
    ccrUnc(count) = sum(labels==yUnc')/length(labels);
    
    % This is where we implement uncertainty sampling
    possibleIdx = (idxVec == 0);
    
    % Since the data is 1-dim, b corresponds with the decision line 
    b = svmUnc.Beta;
    % Most uncertain are the closest to the decision line
    [~, sortIdx] = sort(abs(linData(possibleIdx==1) - b));
    % Switchign on the indices of our most uncertain points
    newIdx = sortIdx(1:sampSize);
    idxVec(newIdx) = 1;
    
    % Pulling the points in our new sample set
    mySample = linData(idxVec==1);
    sampleLabels = labels(idxVec==1);
    
    if count >= length(linData)/sampSize
        disp("Error in unc sampling >:[") 
        break
    end
    count = count + 1;
end
%Plotting
figure()
plot(1:length(ccrUnc),ccrUnc)



%% Data Generation Phase
% 
% % We'll generate a positively skewed distribution
% distro = umgrn([1000, 0],[25,81],30,'with_plot',1);
% % Shifting the data down so half is below and half is above 0
% distro = distro - mean(distro);
% % Taking the sign of this distribution generates biased 1-dim data, where
% % the higher the x-value (position in the array) the higher chance of being
% % +1. The lower in the array, the higher chance for being -1.
% distro(distro==0) = 1; %Eliminating pesky 0s
% class = sign(distro);
% % Visualizing our binary, 1-dim data
% figure
% scatter(1:length(distro),class)
% ylim([-1.5,1.5])
% 
% %% Making a classifier
% % The best decision rule 


%% Data Generation Phase
% 
% % We'll generate a positively skewed distribution
% distro = umgrn([1000, 0],[25,81],30,'with_plot',1);
% % Shifting the data down so half is below and half is above 0
% distro = distro - mean(distro);
% % Taking the sign of this distribution generates biased 1-dim data, where
% % the higher the x-value (position in the array) the higher chance of being
% % +1. The lower in the array, the higher chance for being -1.
% distro(distro==0) = 1; %Eliminating pesky 0s
% class = sign(distro);
% % Visualizing our binary, 1-dim data
% figure
% scatter(1:length(distro),class)
% ylim([-1.5,1.5])
% 
% %% Making a classifier
% % The best decision rule 