function [int_costh_ds, int_sinth_ds] = integrate_angle(s1, ds, theta0, Centerline_Length, c_Fat, c_Skew)

% integrate_angle
% computes the integral of cos(theta), sin(theta) ds
% where theta is externally defined by Kinoshita's curve
% using a three point Gauss Legendre quadrature

int_costh_ds = 0.;
int_sinth_ds = 0.;
abscissae = [0.5-0.5*sqrt(3./5.);  0.5; 0.5+0.5*sqrt(3./5.)];
weights = [5./18; 4./9; 5./18];

for k=1:3
    s = s1 + ds * abscissae(k,1);
    theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);
    int_costh_ds = int_costh_ds + weights(k,1) * cos(theta) * ds;
    int_sinth_ds = int_sinth_ds + weights(k,1) * sin(theta) * ds;
end

% backup mode: midpoint rule (equal to a 1-point Gauss-Legendre quadrature)
  %  s = s1 + ds / 2;
  %  theta = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew);
  %  int_costh_ds = cos(theta)*ds;
  %   int_sinth_ds = sin(theta) * ds;
end

