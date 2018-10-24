function [delta_sinuosity] = delta_sinuosity_function(Centerline_Length, nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope, sinuosity_obj)
%sinuosity
%Wrapper for integrate_meander_centerline
%that outputs sinuosity

[svec, xvec, yvec, zvec] = integrate_meander_centerline(Centerline_Length,nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope);

sinuosity = svec(end)/xvec(end);
delta_sinuosity = sinuosity - sinuosity_obj;
end

