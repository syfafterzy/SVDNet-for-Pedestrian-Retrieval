#SVDNet for Pedestrian Retrieval#
<font face="Times New Roman" size=4>
In this package, we provide our training code written in shell and matlab script for the paper [SVDNet for Pedestrain Retrieval](https://arxiv.org/pdf/1703.05693.pdf). No installation is needed as long as you have caffe and its matlab bindings installed.

**This code is ONLY** released for academic use.</font>

##Setting up and training SVDNet##
<font face="Times New Roman" size=4>
**Step 0: Compile master branch of caffe**  
Checkout the master branch of Caffe and compile it on your machine. Do remember to install the matlab bindings as well, simply by command "make matcaffe" after buiding caffe.

**Step 1: Clone this repo and copy files to the required dictionary.**  
```
	git clone https://github.com/syfafterzy/SVDNet-for-Pedestrian-Retrieval.git   
```
Assume that your caffe rootpath is CAFFE_PATH\.  
```	cp -r SVDNet-for-Pedestrian-Retrieval/SVDNet CAFFE_PATH ```
```	cp -r SVDNet-for-Pedestrian-Retrieval/matlab/SVDNet CAFFE_PATH/matlab/ ```
**Step 2: Train a model with a linear fully-connected layer based on caffenet or resnet.**  
```cd CAFFE\_PATH/SVDNet/caffenet(resnet)/```  
Define your path of caffenet(resnet) basemodel and market1501 dataset in *train\_basemodel.sh*, then: 
```sh train_basemodel.sh```

Please **NOTE** that all the prototxt files require **lmdb** as input data. You may change the data format in the prototxt by hand as well. In this case, you should comment out the shell commands for setting the input data path in the **.sh** files.   
We have also provided caffenet-based and resnet-based models containing a 1024d-linear FC layer in [BAIDUYun](https://pan.baidu.com/s/1slyMCuL). You can download and copy them to ```CAFFE_PATH/SVDNet/caffenet(resnet)/1024d_linear.caffemodel```

**Step 3: Start Restraint and Relaxation Iteration to train SVDNet.**  
Define your caffe rootpath and path of market1501 dataset in *train_RRI.sh*, then start the RRI training simply by:  
```sh train\_RRI.sh```
</font>

##Testing##
<font face="times new roman" size=4>
After 25(7) RRIs for caffenet(resnet) architecutre, the training of SVDNet converges. You may extract the FC6 (or FC of resnet) feature of test dataset and then run evaluation code (evaluation code goes along with the dataset in following links). For caffenet(resnet) backboned SVDNet(with Eigenlayer output 1024d), the Rank-1 accuracy on [Market-1501 Dataset](http://www.liangzheng.org/Project/project_reid.html) is about 80%(82%), and the mAP is about 55%(62%). On [DukeMTMC-reID Dataset](https://github.com/layumi/DukeMTMC-reID_evaluation), the Rank-1 accuracy is about 76%, and the mAP is about 56%. Other dimension settings of Eigenlayer achive slightly different performance.
</font>

##Citiaion##
<font face="times new roman" size=4>
Please cite this paper in your publications if it helps your research:
```
@article{DBLP:journals/corr/SunZDW17,
  author    = {Yifan Sun and
               Liang Zheng and
               Weijian Deng and
               Shengjin Wang},
  title     = {SVDNet for Pedestrian Retrieval},
  journal   = {arXiv preprint arXiv:1703.05693},
  year      = {2017},
}
```
</font>