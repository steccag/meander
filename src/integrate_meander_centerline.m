function [svec, xvec, yvec, zvec, sinuosity] = integrate_meander_centerline(Centerline_Length,nmeanders, imax, baselevel, theta0, c_Fat, c_Skew, valley_slope)
%function integrate_meander_centerline
%projects the meander centerline in a x-y cartesian coordinate system

ds = nmeanders*Centerline_Length/(imax);
xvec=zeros(imax,1);
yvec=zeros(imax,1);
svec=0:ds:nmeanders*Centerline_Length;
svec=svec';
zvec=zeros(imax,1);

for i=1:imax-1
    s1 = svec(i,1);
    [int_costh_ds, int_sinth_ds] = integrate_angle (s1, ds, theta0, Centerline_Length, c_Fat, c_Skew);
    xvec(i+1,1) = xvec(i,1) + int_costh_ds;
 %   svec(i,1)
 %   xvec(i,1)
    yvec(i+1,1) = yvec(i,1) + int_sinth_ds;
    zvec(i+1,1) = zvec(i,1) - int_costh_ds * valley_slope;
%    pause
end

zvec(:,1) = zvec(:,1) + baselevel;

sinuosity = svec(end)/xvec(end)

end

