if [ ! -x "linear" ]
then
mkdir linear
fi
# please define the path of imagenet pre-trained caffenet from caffe rootpath here
BasemodelPath=
cd ../../
./build/tools/caffe train -solver solver_linear.prototxt -weights ${BasemodelPath} -gpu 0,1
mv SVDNet/caffenet/linear/linear_iter_15000.caffemodel SVDNet/caffenet/1024d_linear.caffemodel
