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
create_floodplain_topography=data(17,1)
floodplain_imax = data(18,1)
floodplain_jmax = data(19,1)

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
scatter3(xmatr_vec, ymatr_vec, zmatr_vec, 7*ones(size(zbars_vec)), zbars_vec)
grid on
view(-10,45)

if create_floodplain_topography==1 
% 4 - Create full DEM (plus floodplain)

    floodplain_left_margin = max(max(ymatr_vec));
    floodplain_right_margin = min(min(ymatr_vec));
    fp_upstr_bound = min(min(xmatr_vec));
    fp_downstr_bound = max(max(xmatr_vec));

    [xvec_fp, yvec_fp, zvec_fp] = create_floodplain(floodplain_left_margin, floodplain_right_margin, fp_upstr_bound, fp_downstr_bound, floodplain_imax, floodplain_jmax, valley_slope, baselevel);
    [x_fp, y_fp, z_fp] = create_floodplain2(xvec_fp, yvec_fp, zvec_fp, xmatr, ymatr);
    %	[x_fp_riv, y_fp_riv, z_fp_riv] = create_floodplain_river(xmatr, ymatr, xmatr_vec, ymatr_vec, zmatr_vec, xvec_fp, yvec_fp, zvec_fp);
    
    figure(9)
    scatter3(x_fp, y_fp, z_fp, 25*ones(size(z_fp)), z_fp)
    grid on
    hold on 
    
    plot3(xmatr, ymatr, -ones(size(zmatr)), '-k')
    view(0,90)

   xmatr_vec = [xmatr_vec' x_fp']';
   ymatr_vec = [ymatr_vec' y_fp']';
   zmatr_vec = [zmatr_vec' z_fp']';
   zbars_vec = [zbars_vec' zeros(size(z_fp'))]';
    
   figure(10)
   scatter3(xmatr_vec, ymatr_vec, zmatr_vec, 7*ones(size(zbars_vec)), zbars_vec)
   grid on
    view(-10,45)
    
end

%addpath C:\Users\steccag\Documents\OpenEarth\matlab\
%oetsettings 
%OK = WLGRID('write','FileName1',MeanderGrid,'PropName2',PropVal2, ...)
%OK = WLGRID('write','FileName1',MeanderGrid,'PropName2',PropVal2, ...)
    

%OK = WLGRID('write','PropName1',PropVal1,'PropName2',PropVal2, ...)
%   writes a grid file. The following property names are accepted when
%   following the write command
%     'FileName'        : Name of file to write
%     'X'               : X-coordinates (can be a 1D vector 'stick' of an
%                         orthogonal grid)
%     'Y'               : Y-coordinates (can be a 1D vector 'stick' of an
%                         orthogonal grid)
%     'Enclosure'       : Enclosure array
%     'AutoEnclosure'   : Use this keyword to automatically generate an
%                         enclosure from the fields 'X and 'Y' if you don't
%                         specify one.
%     'CoordinateSystem': Coordinate system 'Cartesian' (default) or
%                         'Spherical'
%     'Format'          : 'NewRGF'   - keyword based, double precision file
%                                      (default)
%                         'OldRGF'   - single precision file
%                         'SWANgrid' - SWAN formatted single precision file
%     'MissingValue'    : Missing value MV to be used for NaN coordinates.
%                         Any (X,Y) pair that matches (MV,MV) will be
%                         shifted slightly to avoid clipping, hence don't
%                         use MV to already mark clipped points in the X,Y
%                         datasets provided.
%
%   Accepted without property name: x-coordinates, y-coordinates and
%   enclosure array (in this order), file name, file format, coordinate
%   system strings 'Cartesian' and 'Spherical' (non-abbreviated).
%



