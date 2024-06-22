# import cv2 library 
import cv2
import os

path = 'C:\\Users\\Jacob\Documents\\matlab\\lab_1\\lab_1\\images\\'
testName = "nonlin_feedback_normal"
type = 1;
testComp = ["realDer", "numDer"]

img1 = cv2.imread(path + "keep\\elliptical_r.png")
img2 = cv2.imread(path + "keep\\elliptical_w.png")

cv2.imshow(img1)

im_h = cv2.hconcat([img1, img2])

#cv2.imshow(im_h)

cv2.imwrite(path + "images\\keep\\elliptical_showcase.png", im_h) 


if type == 1:

    # read the images 
    img1 = cv2.imread(path + testName + "_timeplot.png") 
    img2 = cv2.imread(path + testName + "_phaseplot.png")

    im_v = cv2.vconcat([img1, img2]) 

    cv2.imwrite(path + testName + "_timeAndPhase.png", im_v) 

    img3 = cv2.imread(path + testName + "_fourier.png")
    img4 = cv2.imread(path + testName + "_radhist.png")

    im_v2 = cv2.vconcat([img3, img4]) 

    cv2.imwrite(path + testName + "_fourierAndCyclic.png", im_v2)
elif type == 2:
    img1 = cv2.imread(path + testComp[0] + "_phaseplot.png") 
    img2 = cv2.imread(path + testComp[1] + "_phaseplot.png")

    im_h = cv2.hconcat([img1, img2]) 

    cv2.imwrite(path + testComp[0] + "_" + testComp[1] + "_phaseComp.png", im_h)

elif type == 3:
    img1 = cv2.imread(path + "vanDer_a.png") 
    img2 = cv2.imread(path + "vanDer_u.png")

    im_h = cv2.hconcat([img1, img2]) 

    cv2.imwrite(path + testComp[0] + "_" + testComp[1] + "_phaseComp.png", im_h)
