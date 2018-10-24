function [theta] = Kinoshita(s, theta0, Centerline_Length, c_Fat, c_Skew)
%Evaluates Kinoshita's 
%   sine generated curve plus
% fattening and skewing 
wavenumber = 2 * pi / Centerline_Length;
theta = theta0 * ( sin( wavenumber * s ) - c_Fat / 3 * sin( 3 * wavenumber * s ) - c_Skew / 3 * cos( 3 * wavenumber * s ) );
end

