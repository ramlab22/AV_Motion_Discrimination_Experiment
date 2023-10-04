function [totalfiles,totalfiles_names] = get_datafile_info(Path)
searchPath = [Path ,'/*.mat']; % Search in folder and subfolders for  *.mat
totalfiles = dir(searchPath); % Find all .mat files
totalfiles_names={totalfiles(:).name};