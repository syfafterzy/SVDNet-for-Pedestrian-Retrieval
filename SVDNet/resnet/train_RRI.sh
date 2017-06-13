#please define your caffe root and your training data for market-1501 here
#lmdb is required, or you can set the format in prototxt by hand.
CAFFEPATH=~/caffe
Train_Data_PATH=~/market1501/orig_train_lmdb
Val_Data_PATH=~/market1501/orig_test_lmdb

cd models
sed -i '17d' restraint_resnet.prototxt relaxation_resnet_partial.prototxt
sed -i "17i \    source:\ \"$Train_Data_PATH\"" restraint_resnet.prototxt relaxation_resnet_partial.prototxt
sed -i '35d' restraint_resnet.prototxt relaxation_resnet_partial.prototxt
sed -i "35i \    source:\ \"$Val_Data_PATH\"" restraint_resnet.prototxt relaxation_resnet_partial.prototxt
#==============make dir for intermediate models================================#
cd ..
if [ ! -x "Restraint" ]; then mkdir Restraint; fi
if [ ! -x "Relaxation" ]; then mkdir Relaxation; fi
if [ ! -x "log" ]; then mkdir log; fi
#=======================dir made================================================#

cp 1024d_linear.caffemodel resnet_linear_tmp.caffemodel

#=================start RRI=====================================================#
for i in $(seq  1 7 )
do
   echo Starting Iteration $i
   cd ${CAFFEPATH}/SVDNet/resnet/
   sed -n "${i},1p" base_lr.txt>> tmp.txt
   sed -i '5d' models/solver_restraint.prototxt
   sed -i '4r tmp.txt' models/solver_restraint.prototxt
   sed -i '5d' models/solver_relaxation.prototxt
   sed -i '4r tmp.txt' models/solver_relaxation.prototxt
   rm tmp.txt

   cd ${CAFFEPATH}/matlab/SVDNet/
   cat change_resnet_W.m | matlab -nodisplay 2>&1 | tee ../../SVDNet/resnet/log/SVD${i}.log
   cd ${CAFFEPATH}
   ./build/tools/caffe train -solver SVDNet/resnet/models/solver_restraint.prototxt -weights SVDNet/resnet/resnet_force_eigen.caffemodel -gpu 1,2 2>&1 | tee SVDNet/resnet/log/Restraint${i}.log
   mv SVDNet/resnet/Restraint/restraint_iter_8000.caffemodel SVDNet/resnet/Restraint/Restraint${i}.caffemodel
   ./build/tools/caffe train -solver SVDNet/resnet/models/solver_relaxation.prototxt -weights SVDNet/resnet/Restraint/Restraint${i}.caffemodel -gpu 1,2 2>&1 | tee SVDNet/resnet/log/Relaxation${i}.log
   mv SVDNet/resnet/Relaxation/relaxation_iter_8000.caffemodel SVDNet/resnet/Relaxation/Relaxation${i}.caffemodel
   cp SVDNet/resnet/Relaxation/Relaxation${i}.caffemodel SVDNet/resnet/resnet_linear_tmp.caffemodel
done
#=======================Finish RRI================================================#
