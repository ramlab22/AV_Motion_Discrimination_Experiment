function rmmatvar(matfile, varname)
% Load in data as a structure, where every field corresponds to a variable
% Then remove the field corresponding to the variable
tmp = rmfield(load(matfile), varname);
% Resave, '-struct' flag tells MATLAB to store the fields as distinct variables
save(matfile, '-struct', 'tmp');
end