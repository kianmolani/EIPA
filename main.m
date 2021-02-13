clc
clear
close all

nx = 50;
ny = 50;
V = zeros(nx,ny);
G = sparse(nx*ny,nx*ny);

%% plot G matrix

for i=1:nx
    
    for j=1:ny
        
        n = j + ( i - 1 ) * ny; % mapping equation 
        
        if i == 1 || j == 1 || i == nx || j == ny % for boundary conditions
            
            G(n,:) = 0; % set all other entries to zero
            G(n,n) = 1; % set diagonals to one
            
        else % for bulk nodes (derived from FD equation)
            
            G(n,n) = -4;
            G(n,n+1) = 1; G(n,n-1) = 1; G(n,n+ny) = 1; G(n,n-ny) = 1;
            
        end
    end
end

figure;
spy(G)

%% plot eigenvalues

nmodes = 9;
[E,D] = eigs(G,nmodes,'SM');
figure;
plot(diag(D),'.','MarkerSize',20);

%% plot eigenvectors

figure;
np = ceil(sqrt(nmodes));
for k=1:nmodes
    M = E(:,k);
    for i=1:nx
        for j=1:ny
            n = j + ( i - 1 ) * ny;
            V(i,j) = M(n);
        end
        subplot(np,np,k), surf(V,'linestyle','none');
        title(['EV = ' num2str(D(k,k))])
    end
end
