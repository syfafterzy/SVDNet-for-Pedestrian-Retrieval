if exist('../+caffe', 'dir')
  addpath('..');
else
  error('Please run this demo from caffe/matlab/SVDNet');
end

model_dir = '../../SVDNet/caffenet/';
net_model =[model_dir 'models/deploy_linear.prototxt']
net_weights = [model_dir 'caffenet_linear_tmp.caffemodel']
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please copy the model to caffenet_linear_tmp.caffemodel');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);
