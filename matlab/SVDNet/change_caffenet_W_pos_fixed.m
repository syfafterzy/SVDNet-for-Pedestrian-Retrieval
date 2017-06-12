deploy_caffenet;
tmp=net.layers('ft_fc7').params(1).get_data();tmp=tmp*1;cond(tmp)
co=tmp'*tmp;co=abs(co);
dco=diag(co);
ccc=sum(dco)/sum(sum(co));
fprintf(['auto/co=',num2str(ccc)])  %overall correlation of Weight Matrix
co=tmp'*tmp;E=eig(co);
dco=diag(co);CCC=min(E)/min(dco);
fprintf(['correlation_diagnose=',num2str(CCC)]);  %correlation diagnosing by focusing on the most severe pair 

dim=size(tmp,2)
[U,S,V]=svd(tmp);W=U(:,1:dim)*S(1:dim,:);
net.layers('ft_fc7').params(1).set_data(W);net.save('../../SVDNet/caffenet/caffenet_force_eigen.caffemodel')
