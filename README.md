## Skeleton-based gait recognition via robust frame-level matching (RFM)
#### This paper is accepted to IEEE Transactions on Information Forensics and Security [TIFS 2019]
#### Impact factor: 5.824
---

### Abstract

Gait is a useful biometric feature for human identification in video surveillance applications since it can be obtained without subject cooperation. In recent years, model-based gait recognition using a 3D skeleton has been widely studied through view-invariant modeling and kinematic gait analysis. However, existing methods integrate all frame-level feature vectors using the same criterion, even though skeleton information is highly sensitive to changes in covariate conditions such as clothing, carrying, and occlusion. The scheme inevitably reduces the frame-level discriminative power and eventually degrades performance. Instead, we propose a robust frame-level matching method for gait recognition that minimizes the influence of noisy patterns as well as secures the frame-level discriminative power. To this end, we measure the skeleton quality in terms of body symmetry for each frame. Based on the quality, we construct a quality-adjusted cost matrix between input frames and registered frames to prevent matching with noisy patterns. Our two-stage linear matching is then applied to the cost matrix to compute a frame-level discriminative score including similarity and margin. In the end, the identity of a probe is determined by a weighted majority voting scheme via frame-level scores. It enhances the robustness against inaccurate skeleton estimation results by assigning different weights for each frame based on the score. Our approach outperforms the state-of-the-art methods on three public datasets (UPCVgait, UPCVgaitK2, and SDUgait) and a new gait dataset which we create with consideration of unpredictable behaviors while walking. In addition, we demonstrate that our method is robust to skeleton estimation error, partial occlusion, and data loss. The CILgait dataset and MATLAB code are available at https://sites.google.com/site/seokeonchoi/gait-recognition.

---

### 


