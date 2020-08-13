function rdis = ran2d(dim1, dim2, n)

rdis = zeros(n,2);

for i = 1:n
    rx = rand * dim1;
    ry = rand * dim2;
    rdis(i,1) = rx;
    rdis(i,2) = ry;
end