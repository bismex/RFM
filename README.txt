---------------------------------------------------------------------------

This is the official code for the paper "Skeleton-based Gait Recognition via Robust Frame-level Matching,"
Seokeon Choi, Jonghee Kim, Wonjun Kim, and Changick Kim.
We submitted the paper to the IEEE TIFS journal and currently(2019.02.04) in revision.

---------------------------- Code description -----------------------------

1. Download the dataset, and modify each format and path. (function : NodeComposition)
(Datasets for gait recognition are not provided directly in the code by privacy)
- UPCV1 & UPCV2 : http://www.upcv.upatras.gr/personal/kastaniotis/datasets.html
- SDUgait : https://sites.google.com/site/sdugait/
- CILgait : https://sites.google.com/site/seokeonchoi/gait-recognition

For example:UPCV1)
-> Download "UPCV_gait_r1.zip"
-> Move "UPCVgait.mat" file (in the /UPCV_gait_r1/upcvgaitV1/MatlabFormat/) to "/PATHTO/DB/UPCV1/"
-> Change the file name "UPCVgait.mat" to "data.mat"

2. Run main.m

3. Set parameters (function : SetParametersManual)
- If you want to do various experiments as in the manuscript, carefully confirm the below functions. 
(SetFlagGen, SetParameters, SetSituations, SetMethods, SetNames)
- But these functions are very complicated... (so many experiments)
- We recommend that you manually change the parameters and check for changes in performance.

If you have any questions, please contact us through email (seokeon@kaist.ac.kr). 

--------------------------------  Version  --------------------------------

- Ver.1 is released (2018.11.29) : First edition (in Major revision)
- Ver.2 is released (2019.02.04) : Various methods and experiments in the manuscript are included. (in Minor revision)

----------------------------- Acknowledgments -----------------------------

We are so grateful to these authors.

<Dataset> 
1) UPCV1 
- D. Kastaniotis, I. Theodorakopoulos, C. Theoharatos, G. Economou, and S. Fotopoulos, 
"A framework for gait-based recognition using kinect,"
Pattern Recognit. Lett., vol. 68, pp. 327?335, 2015.
- D. Kastaniotis, I. Theodorakopoulos, G. Economou, and S. Fotopoulos,
"Gait-based gender recognition using pose information for real time applications,"
in Proc. IEEE Int. Conf. Digit. Signal Process., 2013, pp. 1?6.

2) UPCV2 
- D. Kastaniotis, I. Theodorakopoulos, G. Economou, and S. Fotopoulos,
"Gait based recognition via fusing information from euclidean and riemannian manifolds," 
Pattern Recognit. Lett., vol. 84, pp. 245?251, 2016.

3) SDUgait 
- Y. Wang, J. Sun, J. Li, and D. Zhao, 
"Gait recognition based on 3d skeleton joints captured by kinect,"
in Proc. IEEE Int. Conf. Image Process., 2016, pp. 3151?3155.
- J. Sun, Y.Wang, J. Li,W.Wan, D. Cheng, and H. Zhang, 
"View-invariant gait recognition based on kinect skeleton feature," 
Multimed. Tools Appl., pp. 1?27, 2018.

<Comparison target>
1) D. Kastaniotis, I. Theodorakopoulos, C. Theoharatos, G. Economou, and S. Fotopoulos, 
"A framework for gait-based recognition using kinect,"
Pattern Recognit. Lett., vol. 68, pp. 327?335, 2015.

2) F. Ahmed, P. P. Paul, and M. L. Gavrilova, 
"Dtw-based kernel and rank-level fusion for 3d gait recognition using kinect,"
Vis. Comput., vol. 31, no. 6-8, pp. 915?924, 2015.

3) J. Preis, M. Kessel, M. Werner, and C. Linnhoff-Popien, 
"Gait recognition with kinect," 
in Proc. Int. Workshop Kinect Pervasive Comput., 2012, pp. P1?P4.

4) D. Kastaniotis, I. Theodorakopoulos, G. Economou, and S. Fotopoulos,
"Gait-based gender recognition using pose information for real time applications,"
in Proc. IEEE Int. Conf. Digit. Signal Process., 2013, pp. 1?6.

5) A. Ball, D. Rye, F. Ramos, and M. Velonaki, 
"Unsupervised clustering of people from 'skeleton' data," 
in Proc. ACM/IEEE Int. Conf. Human-Robot Interact., 2012, pp. 225?226.

-------------------------------- Signature --------------------------------

Seokeon Choi
School of Electrical Engineering
Korea Advanced Institute of Science and Technology (KAIST)
291 Daehak-ro, Yuseong-gu, Daejeon 305-701, Korea
Office: Room 419, Kim Beang-ho Kim Sam-Youl ITC Building(N1)
Tel: +8242.350.7521 H.P:+8210.9912.1583
E-mail: seokeon@kaist.ac.kr
Homepage : https://sites.google.com/site/seokeonchoi

---------------------------------------------------------------------------