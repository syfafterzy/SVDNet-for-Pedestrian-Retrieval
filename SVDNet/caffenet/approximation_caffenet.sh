cp 1024d_linear.caffemodel caffenet_linear_tmp.caffemodel
CAFFEPATH=~/caffe
if [ ! -x "Restraint" ]
then
mkdir Restraint
fi
if [ ! -x "Relaxation" ]
then
mkdir Relaxation
fi
if [ ! -x "log" ]
then
mkdir log
fi

if []

for i in $(seq  1 25 )
do
   echo Starting Iteration $i
   cd ${CAFFEPATH}/matlab/SVDNet/
   if [ $i -lt "7" ]
   then
   cat change_caffenet_W_pos_fixed.m | matlab -nodisplay 2>&1 | tee ../../SVDNet/caffenet/log/SVD${i}.log
   else
   cat change_caffenet_W.m | matlab -nodisplay 2>&1 | tee ../../SVDNet/caffenet/log/SVD${i}.log
   fi

   cd ${CAFFEPATH}/
   ./build/tools/caffe train -solver SVDNet/caffenet/solver_restraint.prototxt -weights SVDNet/caffenet/caffenet_force_eigen.caffemodel -gpu 1,2 2>&1 | tee SVDNet/caffenet/log/Restraint${i}.log
   mv SVDNet/caffenet/Restraint/restraint_iter_2000.caffemodel SVDNet/caffenet/Restraint/Restraint${i}.caffemodel
   ./build/tools/caffe train -solver SVDNet/caffenet/solver_relaxation.prototxt -weights SVDNet/caffenet/Restraint/Restraint${i}.caffemodel -gpu 1,2 2>&1 | tee SVDNet/caffenet/log/Relaxation${i}.log
   mv SVDNet/caffenet/Relaxation/relaxation_iter_2000.caffemodel SVDNet/caffenet/Relaxation/Relaxation${i}.caffemodel
   cp SVDNet/caffenet/Relaxation/Relaxation${i}.caffemodel SVDNet/caffenet/caffenet_linear_tmp.caffemodel
done
  ./build/tools/caffe train -solver SVDNet/caffenet/solver_restraint_final.prototxt -weights SVDNet/caffenet/Restraint/Restraint25.caffemodel
  mv SVDNet/caffenet/Restraint/restraint_final_iter_6000.caffemodel SVDNet/caffenet/Restraint/Restraint_final.caffemodel
