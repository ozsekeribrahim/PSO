clear all
close all
clc

c1=1;
c2=1;
P_n=20
P_d=3
lim=5
O_n=200
span = -0:0.005:5;
[p1,p2] = meshgrid(span,span);
x_mesh=[p1(:),p2(:)];
x=[rand(2,O_n)*2 rand(2,O_n)*2+2.1]';
t=[ones(1,O_n) zeros(1,O_n)]';

class1=x(t==1,:);
class2=x(t==0,:);

[O_n,V_n]=size(x);
P=rand(P_d,P_n)*lim*2-lim;

perc=@(data,w) hardlim(data(:,1:2)*w(1:2,:)+repmat(w(3,:),size(data,1),1));
% f=@(p)sum(abs((hardlim(x(:,1:2)*p(1:2,:)+repmat(p(3,:),O_n,1)))-repmat(t,1,size(p,2))));
f=@(vars,target,p) sum(abs((perc(vars,p))-repmat(target,1,size(p,2))));
iter_n=100;

% z=f(P);


% contourf(x,y,z)
% hold on


% P=rand(2,P_n)*6-3;
% scatter(P(1,:),P(2,:),'r');
pbest=P;
V=zeros(P_d,P_n);
P_vals=f(x,t,P);

gbest=(P(:,find(P_vals==min(P_vals))))
gbest=gbest(:,1);
w=1;
for i=1:iter_n

V=w*V+c1*rand*(pbest-P)+c2*rand*(repmat(gbest,1,P_n)-P)

P=P+V;

ix_ext=sum(abs(P)>lim)>0;
n_ext=sum(ix_ext);
P(:,ix_ext)=rand(P_d,n_ext)*lim*2-lim;



P_vals=f(x,t,P);
pause(0.01);

pbest_vals=f(x,t,pbest);

pbest(:,(P_vals<pbest_vals))=P(:,(P_vals<pbest_vals));

gbest=(pbest(:,find(pbest_vals==min(pbest_vals))));
gbest=gbest(:,1);
g_best_val(i)=f(x,t,gbest);

clf

scatter(class1(:,1),class1(:,2),'k','filled'); hold on;
scatter(class2(:,1),class2(:,2),'r+','LineWidth',2); hold on;

aa=perc(x_mesh,gbest);
mesh(p1,p2,reshape(aa,length(span),length(span))-5);
colormap cool
view(2)
hold on
for i=1:P_n
    plotpc(P(1:2,i)',P(3,i));
    hold on;
end
w=w-(i/iter_n)*w;
end
figure,
plot(1:100,g_best_val);