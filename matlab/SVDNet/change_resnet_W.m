deploy_resnet;
tmp=net.layers('fc').params(1).get_data();
co=abs(tmp'*tmp);dco=diag(co);ccc=sum(dco)/sum(sum(co));
fprintf(['auto/co=',num2str(ccc)]);%S(W)
Dim=size(tmp,2);
[U,S,V]=svd(tmp);W=U(:,1:Dim)*S(1:Dim,:);

% replacing tmp=USV with W
% Note that the sequeence of  column vectors can be changed discretionarily, with no influence on the discriminant ability.  
% The principle of the following part is to replace each weight vector with the "closest" eigen vector.
for i=1:Dim
	index=i;
%	co=tmp(:,index)'*W;%the matching algorithm is to be optimized.
	co=tmp(:,index)'*W./sqrt(tmp(:,index)'*tmp(:,index))./sqrt(sum(W.^2,1));% co value determined by the intersection angle.
    absco=abs(co);%SVD result is ambiguous about the sign of the singular value, so each colomn vector of W may be reversed geometrically.
	maxco_index=find(absco==max(absco));%This is to match the ith weight vector with the closest eigen vector. Due to the ambiguity of SVD result, the largest absolute value of co indicates the smallest in    tersection angle, i.e., the "closest" eigen vector to the ith weight vector.
	NW(:,index)=W(:,maxco_index)*absco(maxco_index)/co(maxco_index);%This is to set the ith column vector of NW to be the matched column vector in W. Please note that the direction could have been reversed after this step, to eliminate the ambiguity of sign of SVD result.
	W(:,maxco_index)=[];
end

net.layers('fc').params(1).set_data(NW);net.save('../../SVDNet/resnet/resnet_force_eigen.caffemodel')
