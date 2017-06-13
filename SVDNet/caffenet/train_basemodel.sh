if [ ! -x "linear" ]; then mkdir linear; fi
# please define the path of imagenet pre-trained caffenet from caffe rootpath here
# define your market1501 dataset as well. lmdb is required, or you can change the data format in prototxt files by hand.
BasemodelPath=
Train_Data_Path=~/market1501/caffenet_img_train_lmdb
Val_Data_Path=~/market1501/caffenet_img_test_lmdb
cd models
sed -i '16d' train_caffenet_linear.prototxt
sed -i "16i \    source:\ \"$Train_Data_Path\"" train_caffenet_linear.prototxt
sed -i '35d' train_caffenet_linear.prototxt
sed -i "35i \    source:\ \"$Val_Data_Path\"" train_caffenet_linear.prototxt
cd ../../../
./build/tools/caffe train -solver SVDNet/caffenet/models/solver_linear.prototxt -weights ${BasemodelPath} -gpu 0,1
mv SVDNet/caffenet/linear/linear_iter_15000.caffemodel SVDNet/caffenet/1024d_linear.caffemodel
