function zbars = forced_bars(bar_ampl, Centerline_Length, width, nvec, svec, imax, jmax, floodplain_mode, n_add)

[j1, jend, jfin] = get_j_limits(jmax, floodplain_mode, n_add);

zbars = zeros(imax, jfin);
wavenumber = 2 * pi / Centerline_Length;
transverse_wavenumber = pi/width;

for i =1:imax
    for j=j1: jend

    zbars(i,j) = bar_ampl * sin( transverse_wavenumber * nvec(1,j) ) * cos ( wavenumber * svec (i,1) );
    end
end



end