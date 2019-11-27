clear all
close all
clc

c1=1;
c2=1;
iter_n=100;
f =@(x,y)  3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ... 
   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ... 
   - 1/3*exp(-(x+1).^2 - y.^2) ;

[x,y]=meshgrid(-3:0.01:3,-3:0.01:3);
z=f(x,y);


contourf(x,y,z)
hold on

P_n=20;
P=rand(2,P_n)*6-3;
scatter(P(1,:),P(2,:),'r');
pbest=P;
V=zeros(2,P_n);
P_vals=f(P(1,:),P(2,:));

gbest=(P(:,find(P_vals==min(P_vals))))
w=1;
for i=1:iter_n

V=w*V+c1*rand*(pbest-P)+c2*rand*(repmat(gbest,1,P_n)-P);

P=P+V;

ix_ext=sum(abs(P)>3)>0;
n_ext=sum(ix_ext);
P(:,ix_ext)=rand(2,n_ext)*6-3;

clf
contourf(x,y,z)
hold on
scatter(P(1,:),P(2,:),'r');
P_vals=f(P(1,:),P(2,:));
pause(0.2);

pbest_vals=f(pbest(1,:),pbest(2,:));

pbest(:,(P_vals<pbest_vals))=P(:,(P_vals<pbest_vals));

gbest=(pbest(:,find(pbest_vals==min(pbest_vals))))
gbest=gbest(:,1);
g_best_val(i)=f(gbest(1),gbest(2))

w=w-(i/iter_n)*w
end
figure,
plot(1:100,g_best_val);