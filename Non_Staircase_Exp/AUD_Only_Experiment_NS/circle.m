function[xp, yp] = circle(r)
%assumes circle at 0,0 , if yoou want to change shif the output values to
%get new center 

%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);

end