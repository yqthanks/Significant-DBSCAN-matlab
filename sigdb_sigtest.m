function sig_vec = sigdb_sigtest(nc_cluster_vec, eps_cluster, minpts_cluster, n, dim1, dim2, m, siglvl, ras, cellsize, mode, eps_div)
% cluster

%nc_cluster_vec must be sorted!!!!!!!!

% activate_acceleration = 1;

if exist('mode','var')
   mode = round(mode);
   if mode<0 || mode>10
       fprintf('Invalid mode input! %d, using mode = 3\n', mode);
       mode = 3;
   end
   fprintf('current mode is: %d\n', mode);
else
    mode = 3;
end

if ~exist('eps_div','var')
    eps_div = 0.25;
end

vec_len = max(size(nc_cluster_vec));
sig_vec = zeros(vec_len, 1);

current_sig_id = 0;

nc_cluster_vec = sort(nc_cluster_vec, 'desc');
% fprintf('nc_cluster:\n');
% disp(nc_cluster_vec);

sig_fulltest_vec = sigdb_mcs(nc_cluster_vec, eps_cluster, minpts_cluster, n, dim1, dim2, m, siglvl, ras, cellsize, mode);
sig_vec(current_sig_id+1:end,:) = sig_fulltest_vec(:,:);


