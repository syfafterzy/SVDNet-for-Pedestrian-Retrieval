if [ ! -x "linear" ]; then mkdir linear; fi
# please define the path of imagenet pre-trained caffenet from caffe rootpath here
# define path of market-1501 dataset as well; lmdb is required, or you can change the data format in prototxt files by hand

BasemodelPath=
Train_Data_Path=~/market1501/orig_train_lmdb
Val_Data_Path=~/market1501/orig_test_lmdb

sed -i '17d' train_resnet_linear.prototxt
sed -i "17i \    source:\ \"$Train_Data_Path\"" train_resnet_linear.prototxt
sed -i '35d' train_resnet_linear.prototxt
sed -i "35i \    source:\ \"$Val_Data_Path\"" train_resnet_linear.prototxt
cd ../../
./build/tools/caffe train -solver solver_linear.prototxt -weights ${BasemodelPath} -gpu 0,1
mv SVDNet/resnet/linear/linear_iter_25000.caffemodel SVDNet/resnet/1024d_linear.caffemodel
