 clear, format long g; 
%Run App to get Paramters for test
app = GUI_Test; 
while isvalid(app); pause(0.1); end

%Turn the .txt file into vector for input into PsychToolbox fucntion 
% The 3rd value is the dots position on the screen (1-9)
fid = fopen('data_file.txt');
C = textscan(fid,'%f ');
x = C{1,1};

t_angle = x(1,1); 
w_angle = x(2,1); 
position = x(3,1); 

t_size = angle2pixels(t_angle); 

%Run the Visual Stimulus at position and target size given, Commmands so far are 1 = Dot On , 2 = Dot Off , 3 = Quit Stimulus 
fixation_1_dot(position,t_size)


