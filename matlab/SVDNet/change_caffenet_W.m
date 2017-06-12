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
% replacing tmp=USV with W
% Note that the sequeence of  column vectors can be changed discretionarily, with no influence on the discriminant ability.
% The principle of the following part is to replace each weight vector with the "closest" eigen vector.
for i=1:dim
	co=tmp(:,i)'*W./sqrt(tmp(:,i)'*tmp(:,i))./sqrt(sum(W.^2,1));% co value determined by the intersection angle.
	absco=abs(co);%SVD result is ambiguous about the sign of the singular value, so each colomn vector of W may be reversed geometrically.
	maxco_index=find(absco==max(absco));%This is to match the ith weight vector with the closest eigen vector. Due to the ambiguity of SVD result, the largest absolute value of co indicates the smallest intersection angle, i.e., the "closest" eigen vector to the ith weight vector.
	NW(:,i)=W(:,maxco_index)*absco(maxco_index)/co(maxco_index);%This is to set the ith column vector of NW to be the matched column vector in W. Please note that the direction could have been reversed after this step, to eliminate the ambiguity of sign of SVD result.
	W(:,maxco_index)=[];
end

net.layers('ft_fc7').params(1).set_data(NW);net.save('../../SVDNet/caffenet/caffenet_force_eigen.caffemodel')
