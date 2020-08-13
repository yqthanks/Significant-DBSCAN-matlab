function max_lb = getlb(rdis, eps, minpts, dim1, dim2, eps_div, maxthrd)
%cellsize is a division of eps

%init eps grid, compute count
cellsize = eps*eps_div;
[qgrid, ~] = rasterize_density(rdis, ones(size(rdis,1),1), dim1, dim2, cellsize, []);
neighborhood = 2*floor(1/(eps_div*sqrt(2)))-1;
if neighborhood<3
    disp('invalid eps value!!!!!!!!!!');
    return;
end

max_lb = lbdbscan(qgrid, minpts, neighborhood, maxthrd);