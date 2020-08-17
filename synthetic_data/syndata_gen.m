function [data, gt] = syndata_gen(n, dim1, dim2, img, es_vec, labelimg)
%function used to generate synthetic shape and test data using the pictures

%labelimg contains unique pixel labels for each cluster
%will be generated automatically if not given as input

if ~exist('labelimg','var')
    imgcomponents = bwconncomp(img);
    labelimg = labelmatrix(imgcomponents);
end

%es_vec is vector containing effect size for each cluster
%effect size means how many times inside probability density is as high as
%outside (please see paper for more details)
%for simplicity, assume es_vec_len is 2, hard coded this
%thus, two clusters have effect size of es_vec(1) and other two have
%es_vec(2)


%fix image dimension to 100 by 100
step1 = dim1/100;
step2 = dim2/100;

data = zeros(n,2);
gt = zeros(n,1);

%foreground
[crow, ccol] = find(img==1);%cluster locs
[crow2, ccol2] = find(img==2);%cluster locs
%background
[nrow, ncol] = find(img==0);%non-cluster locs

num1 = max(size(crow));
num2 = max(size(crow2));
num0 = max(size(nrow));

p1 = (es_vec(1)*num1)/(es_vec(1)*num1 + es_vec(2)*num2 + 1*num0);
p2 = (es_vec(2)*num2)/(es_vec(1)*num1 + es_vec(2)*num2 + 1*num0);

for i = 1:n
    
    rx = [];
    ry = [];
    
    ptest = rand;
    if ptest<=p1
        %within the range of "1" region
        
        id = ceil(rand*num1);
        row = crow(id);
        col = ccol(id);
        rx = (row-1)*step1 + rand*step1;
        ry = (col-1)*step2 + rand*step2;
        
        gt(i) = labelimg(row,col);
        
    else
        
        if ptest<=p1+p2
            %within the range of "2" region
            
            id = ceil(rand*num2);
            row = crow2(id);
            col = ccol2(id);
            rx = (row-1)*step1 + rand*step1;
            ry = (col-1)*step2 + rand*step2;
            
            gt(i) = labelimg(row,col);
            
        else
            
            id = ceil(rand*num0);
            row = nrow(id);
            col = ncol(id);
            rx = (row-1)*step1 + rand*step1;
            ry = (col-1)*step2 + rand*step2;
            
            gt(i) = labelimg(row,col);
            
        end
        
    end
    
    data(i,:) = [ry,dim1-rx];
    
end

gt = [data, gt];