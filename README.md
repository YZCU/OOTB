### 📖[**OOTB**](https://www.sciencedirect.com/science/article/pii/S0924271624000856)

Benchmark for "**Satellite Video Single Object Tracking: A Systematic Review and An Oriented Object Tracking Benchmark**", ISPRS Journal of Photogrammetry and Remote Sensing (ISPRS), 2024.

--------------------------------------------------------------------------------------

:running:Keep updating:running:: We have released the [**LMOD**](https://github.com/RS-Devotee/LMOD): A Large-scale and Multiclass Moving Object Detection Dataset for Satellite Videos.

--------------------------------------------------------------------------------------
- Authors: 
[Yuzeng Chen](https://yzcu.github.io/), 
[Yuqi Tang*](https://faculty.csu.edu.cn/yqtang/zh_CN/zdylm/66781/list/index.htm),
[Yi Xiao](https://github.com/XY-boy), 
[Qiangqiang Yuan](http://qqyuan.users.sgg.whu.edu.cn/),
Yuwei Zhang,
Fengqing Liu,
[Jiang He](https://jianghe96.github.io/),
[Liangpei Zhang](http://www.lmars.whu.edu.cn/prof_web/zhangliangpei/rs/index.html)
- Wuhan University and Central South University
- Download the OOTB dataset on [Baidu Cloud Disk (code: OOTB)](https://pan.baidu.com/s/11hsA4pOliwA1FpOqNol93w ) to your disk, the organized directory looks like:
    ```
    --OOTB/
    	|--car_1/
                |--img/
                    |--0001.jpg
                    |--...
                    |--0268.jpg
                |--groundtruth.txt
    	|...
    	|--train_10/
                |--img/
                    |--0001.jpg
                    |--...
                    |--0120.jpg
                |--groundtruth.txt
    	|--anno/
		    	|--car_1.txt
		    	|...
		    	|--train_10.txt
      	|--OOTB.json
    ```
	
- Download the benchmark [Toolkit](https://github.com/YZCU/OOTB).
- Download the [vlfeat](http://www.vlfeat.org/index.html).

- ### Installation
  Environments
  ```
  Matlab 2018a
  ```
- ### Visual samples
  Train_1
 ![image](/fig/Train_1.gif)
  Plane_21
 ![image](/fig/Plane_21.gif)

## Abstract
> Single object tracking (SOT) in satellite video (SV) enables the continuous acquisition of position and range information of an arbitrary object, showing promising value in remote sensing applications. However, existing trackers and datasets rarely focus on the SOT of oriented objects in SV. To bridge this gap, this article presents a comprehensive review of various tracking paradigms and frameworks covering both the general video and satellite video domains and subsequently proposes the oriented object tracking benchmark (OOTB) to advance the field of visual tracking. OOTB contains 29,890 frames from 110 video sequences, covering common satellite video object categories including car, ship, plane, and train. All frames are manually annotated with oriented bounding boxes, and each sequence is labeled with 12 fine-grained attributes. Additionally, a high-precision evaluation protocol is proposed for comprehensive and fair comparisons of trackers. To validate the existing trackers and explore frameworks suitable for SV tracking, we benchmark 33 state-of-the-art trackers totaling 58 models with different features, backbones, and tracker tags. Finally, extensive experiments and insightful thoughts are also provided to help understand their performance and offer baseline results for future research. The proposed OOTB will be available at https://github.com/YZCU/OOTB.

## Visualization of the scenery diversity
 ![image](/fig/dataset.jpg)
## Overview
 ![image](/fig/overview.png)
## The aspect ratios of the OOTB dataset
 ![image](/fig/aspectratios.jpg)
## Attribute distribution for each type of object
 ![image](/fig/attribute.jpg)
## Evaluations
- Experimental results for 33 SOTAs with a total of 58 models. 
 ![image](/fig/overallresults.jpg)
- Overall results for the top 30 trackers on OOTB.
 ![image](/fig/overallfigs.jpg)
- The precision plot (column 1), normalized precision plot (column 2), and success plot (column 3) for top 30 trackers. Rows 1 to 5 show the results for car, ship, plane, and train, respectively.
 ![image](/fig/fig15.jpg)
- The success plot of each attribute for the top 30 trackers.
 ![image](/fig/fig16.jpg)
- Qualitative results for nine SOTAs. The current frame is shown in the upper left corner.
 ![image](/fig/fig18.jpg)

## Contact
If you have any questions or suggestions, feel free to contact me.  
Email: yuzeng_chen@whu.edu.cn, rs_devotee@163.com

## Acknowledgement

:heart::heart::heart: We really appreciate excellent works, as follows:

- [OTB](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html) 
- [TrackingNet](https://github.com/SilvioGiancola/TrackingNet-devkit)
- [VOT](https://github.com/votchallenge/toolkit-legacy)
