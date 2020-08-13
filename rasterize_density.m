function [ras, cellsize] = rasterize_density(data, remove, dim1, dim2, eps, ras)

cellsize = eps;

if max(size(remove))==0
    remove = ones(size(data,1),1);
end

rdim1 = ceil(dim1/cellsize);
rdim2 = ceil(dim2/cellsize);


if max(size(ras)) == 0
    ras = zeros(rdim1, rdim2);
end

for i = 1:size(remove, 1)
    
    if remove(i) == 1
        gridloc = ceil(data(i,:)/cellsize);
        ras(gridloc(1), gridloc(2)) = ras(gridloc(1), gridloc(2)) + 1;
    end
    
end