cd '/Volumes/Ramlab/Jackson/Adriana Stuff/AV_Behavioral_Data';
baron_totalfiles = dir('*Baron*.mat');
alv_totalfiles = dir('*Alvarez*.mat');
alv_aud_filenames=strings;
alv_vis_filenames=strings;
alv_aud_counter=0;
alv_vis_counter=0;

ba_counter=0;
for i_alvfile = 1:length(alv_totalfiles)
    file_name = string(alv_totalfiles(i_alvfile).name);
    load(file_name)
    if exist('audInfo','var') 
        alv_aud_counter=alv_aud_counter+1;
        alv_aud_filenames(alv_aud_counter,:)=file_name;
    end
    if exist('dotInfo','var')
        alv_vis_counter=alv_vis_counter+1;
        alv_vis_filenames(alv_vis_counter,:)=file_name;
    end
end
for i_bafile = 1:length(ba_totalfiles)
end
aud_figfiles = dir('*AUD*.png');
cd '/Volumes/Ramlab/Jackson/Adriana Stuff/AV_Figures';
aud_figfiles = dir('*AUD*.png');
n_aud_figfiles=length(aud_figfiles);
%[fit_mean_midpoint,fit_standarddeviation_slope,curve_xvals,curve_yvals] = get_LRfunction_threshold(dataout,audInfo,ExpInfo,save_name);
alv_fignames=strings;
ba_fignames=strings;

for i_audfile = 1:length(aud_figfiles)
    audfile_name = aud_figfiles(i_audfile).name;
    if contains(audfile_name,'Psyc_Func_LR')
        if contains(audfile_name,'Baron') 
            ba_counter=ba_counter+1;
            ba_fignames(ba_counter,:)=string(audfile_name(1,1:14));
        end % if Ba
        if contains(audfile_name,'Alvarez')
            alv_counter=alv_counter+1;
            alv_fignames(alv_counter,:)=audfile_name(1,1:16);

        end % if Alv
    end %if LR psych func fig
    
end %for all aud fig files