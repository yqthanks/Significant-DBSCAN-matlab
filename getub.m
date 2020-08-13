function max_ub = getub(rdis, eps, minpts, dim1, dim2, eps_div, maxthrd)
%cellsize is a division of eps

%init eps grid, compute count
cellsize = eps*eps_div;
[qgrid, ~] = rasterize_density(rdis, ones(size(rdis,1),1), dim1, dim2, cellsize, []);
neighborhood = round(2/eps_div + 1);

max_ub = ubdbscan(qgrid, minpts, neighborhood, maxthrd);