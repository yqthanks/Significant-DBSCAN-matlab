function [ras, cellsize] = rasterize(data, remove, dim1, dim2, eps, ras)

%note that this must be equal, otherwise will change later cellsizes used
%in generating the random datasets; if needed revise later
cellsize = eps;

rdim1 = ceil(dim1/cellsize);
rdim2 = ceil(dim2/cellsize);


if max(size(ras)) == 0
    ras = zeros(rdim1, rdim2);
end

for i = 1:size(remove, 1)
    
    if remove(i) == 1
        gridloc = ceil(data(i,:)/cellsize);
        gridloc = max(gridloc, 1);
        ras(gridloc(1), gridloc(2)) = 1;
    end
    
end