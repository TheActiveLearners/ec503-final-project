function [ output_args ] = linSepFiles( input_args )
%LINSEPFILES Summary of this function goes here
%   Detailed explanation goes here


{'linSep', 'linSep_data.mat','linSep_label.mat'},... % 4
{'nonLinSep','nonLinSep_data.mat','nonLinSep_label.mat'},... % 5
{'nonLinSep2','nonLinSep_data2.mat','nonLinSep_label2.mat'} % 6

fname = fullfile(dir_data,dataset_data);
all_data = load(fname);
if(class(all_data) == 'struct')
    switch select_dataset
        case 5
            all_data = all_data.X_nonLinSep;
        case 4
            all_data = all_data.X_linSep;
        case 6
            all_data = all_data.X_nonLinSep2;
    end
end
[sample_steps,~] = size(all_data);
fname = fullfile(dir_data,dataset_label);
all_labels = load(fname);
if(class(all_labels) == 'struct')
    switch select_dataset
        case 5
            all_labels = all_labels.Y_nonLinSep;
        case 4
            all_labels = all_labels.Y_linSep;
        case 6
            all_labels = all_labels.Y_nonLinSep2;
    end
end

end

