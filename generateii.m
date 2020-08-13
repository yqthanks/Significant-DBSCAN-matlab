function img = generateii(img)

[dim1, dim2] = size(img);

for i = 1:dim1
    for j = 2:dim2
        img(i,j) = img(i,j-1) + img(i,j);
    end
end
for j = 1:dim2
    for i = 2:dim1
        img(i,j) = img(i-1,j) + img(i,j);
    end
end