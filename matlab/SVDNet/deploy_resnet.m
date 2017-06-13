if exist('../+caffe', 'dir')
  addpath('..');
else
  error('Please run this demo from caffe/matlab/SVDNet');
end

model_dir = '../../SVDNet/resnet/';
net_model = [model_dir 'models/deploy_resnet_linear.prototxt'];
net_weights = [model_dir,'resnet_linear_tmp.caffemodel']
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please copy the model to resnet_linear_tmp.caffemodel');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);
