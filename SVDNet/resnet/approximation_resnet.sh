cp 1024d_linear.caffemodel resnet_linear_tmp.caffemodel

for i in $(seq  1 2 )
do
   echo Starting Iteration $i
   cd ~/caffe/SVDNet/resnet/
   sed -n "${i},1p" base_lr.txt>> tmp.txt
   sed -i '5d' solver_restraint.prototxt
   sed -i '4r tmp.txt' solver_restraint.prototxt
   sed -i '5d' solver_relaxation.prototxt
   sed -i '4r tmp.txt' solver_relaxation.prototxt
   rm tmp.txt

   cd ~/caffe/matlab/SVDNet/
   cat change_resnet_W.m | matlab -nodisplay 2>&1 | tee ../../SVDNet/resnet/log/SVD${i}.log
   cd ~/caffe/
   ./build/tools/caffe train -solver SVDNet/resnet/solver_restraint.prototxt -weights SVDNet/resnet/resnet_force_eigen.caffemodel -gpu 1,2 2>&1 | tee SVDNet/resnet/log/Restraint${i}.log
   mv SVDNet/resnet/Restraint/restraint_iter_8000.caffemodel SVDNet/resnet/Restraint/Restraint${i}.caffemodel
   ./build/tools/caffe train -solver SVDNet/resnet/solver_relaxation.prototxt -weights SVDNet/resnet/Restraint/Restraint${i}.caffemodel -gpu 1,2 2>&1 | tee SVDNet/resnet/log/Relaxation${i}.log
   mv SVDNet/resnet/Relaxation/relaxation_iter_8000.caffemodel SVDNet/resnet/Relaxation/Relaxation${i}.caffemodel
   cp SVDNet/resnet/Relaxation/Relaxation${i}.caffemodel SVDNet/resnet/resnet_linear_tmp.caffemodel
done

