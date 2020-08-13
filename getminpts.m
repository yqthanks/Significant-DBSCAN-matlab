function minpts_mat = getminpts(density_vec, eps_vec)

n_density = max(size(density_vec));
n_eps = max(size(eps_vec));

minpts_mat = zeros(n_density, n_eps);

for i = 1:n_density
    for j = 1:n_eps
        
        minpts = density_vec(i)*pi*eps_vec(j)^2;
        minpts_mat(i,j) = ceil(minpts);
        
    end
end