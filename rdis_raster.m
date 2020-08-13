function rdata = rdis_raster(dim1, dim2, n, ras, cellsize)

[crow, ccol] = find(ras==0);%valid locs
num = max(size(crow));

rdata = zeros(n, 2);

for i = 1:n
    
    %within the range of "1" region

    id = ceil(rand*num);
    row = crow(id);
    col = ccol(id);
    rx = (row-1)*cellsize + rand*cellsize;
    ry = (col-1)*cellsize + rand*cellsize;
    rx = min(dim1, rx);
    ry = min(dim2, ry);
    
    rdata(i,:) = [rx ry];
    
end