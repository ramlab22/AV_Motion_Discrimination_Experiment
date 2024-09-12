%assumes you have made CAM signals

FS_old = 44100; %old FS
FS_new = 24414*2; %sampling rate of RZ processor

[p, q] = rat(FS_new/FS_old); 

arr1 = resample(CAM(:,1), p, q); 
arr2 = resample(CAM(:,2), p, q); 

filename = 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_1.f32'; 
filename2 = 'C:\Jackson\Adriana Stuff\Auditory_Experiment_Jack_060722\Auditory Stimulus\CAM_2.f32'; 

fid = fopen(filename, 'wb'); 
fid2 = fopen(filename2, 'wb');
y = fwrite(fid, arr1, 'float32'); 
y2 = fwrite(fid2, arr2, 'float32'); 
fclose(fid); 
fclose(fid2); 

%%
seconds = 10; 
xx = linspace(0,seconds*FS_new,length(arr1)); 

fid = fopen(filename, 'r'); 
yy = fread(fid, inf, '*float32'); 
fclose(fid); 
figure; plot(xx, yy);

fid = fopen(filename2, 'r'); 
yy2 = fread(fid, inf, '*float32'); 
fclose(fid); 
figure(2); plot(xx, yy2); 

