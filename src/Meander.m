clear all
close all
clc

%1 -read input
filename = '../data/data.ini'
fileID = fopen(filename);
data_cell = textscan(fileID, '%f %*s', 'delimiter', ';');
data = cell2mat(data_cell);

Centerline_Length = data(1,1) % Meander wavelength
c_Fat = data(2,1)
c_Skew = data(3,1)
Radius0 = data(4,1)
sinuosity_obj= data(5,1)
valley_slope = data(6,1)
nmeanders = data(7,1)
imax = data(8,1)
jmax = data(9,1)
width = data(10,1)
baselevel = data(11,1)
mode = data(12,1)
bankfull_depth = data(13,1)
floodplain_mode = data(14,1)
bank_width= data(15,1)
bank_height= data(16,1)

fclose(fileID);

theta0 = Centerline_Length/(Radius0*2*pi);


%2 - integrate meander centerline and project it along the three cartesian
%directions (x - along the plain, downwards; y - in the transverse
%direction, towards the left if looking along x; z - upwards)
if mode ==1
    %call integration of center line line
    [svec, xvec, yvec, zvec] = integrate_meander_centerline(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope);
    sinuosity = svec(end)/xvec(end)
elseif mode==2
%delta_sinuosity = sinuosity_function(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope, sinuosity_obj);

    theta0_ini = 1.E-5;
    fun = @(theta0)delta_sinuosity_function(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope, sinuosity_obj);
    theta0 = fsolve(fun,theta0_ini);
    Radius0 = Centerline_Length/(theta0*2*pi);
    
    [svec, xvec, yvec, zvec] = integrate_meander_centerline(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope);
    sinuosity = svec(end)/xvec(end);
    Radius0
    theta0
end

figure(1)
plot(xvec, yvec)
grid on
axis equal

figure(2)
plot3(xvec, yvec, zvec)
grid on
view(-10,45)
%axis equal%




% 3 - Create a 3d object
[nvec, xmatr, ymatr, zmatr] = threeD_structure(svec, xvec, yvec, zvec, width, imax, jmax, theta0, Centerline_Length, c_Fat, c_Skew, valley_slope, bank_height, floodplain_mode, bank_width);


figure(3)
plot(xmatr, ymatr)
grid on
axis equal

figure(4)
plot3(xmatr, ymatr, zmatr)
grid on
view(-10,45)



% 4 - Create a bar structure
Theta = 0.225;
f_ds = 10;
bar_ampl = 0.5*bankfull_depth * width / Radius0 * sqrt(Theta)*f_ds;
zbars = forced_bars(bar_ampl, Centerline_Length, width, nvec, svec, imax, jmax, floodplain_mode);

% convert to vectors for scatter plots
[xmatr_vec, ymatr_vec, zmatr_vec, zbars_vec] = convert_to_vec(xmatr, ymatr, zmatr, zbars);


%now add the bar structure to the 3D structure
zmatr = zmatr + zbars;
zmatr_vec = zmatr_vec + zbars_vec;

figure(6)
scatter3(xmatr_vec, ymatr_vec, zbars_vec, 10*ones(size(zbars_vec)), zbars_vec)
grid on
view(-10,45)

figure(7)
scatter3(xmatr_vec, ymatr_vec, zeros(size(zbars_vec)), 10*ones(size(zbars_vec)), zbars_vec)
grid on
axis equal
view(0,90)

figure(8)
scatter3(xmatr_vec, ymatr_vec, zmatr_vec, 10*ones(size(zbars_vec)), zbars_vec)
grid on
view(-10,45)

% 4 - Create full DEM (plus floodplain)