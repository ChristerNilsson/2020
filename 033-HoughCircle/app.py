# https://www.youtube.com/watch?v=dp1r9oT_h9k&t=414s&ab_channel=ProgrammingKnowledge
# https://pypi.org/project/opencv-python/

import numpy as np
import cv2 as cv

NAME = 'images/lingon2.jpg'

input = cv.imread(NAME)
#input = cv.cvtColor(input,cv.COLOR_BGR2GRAY)
input = cv.medianBlur(input,5)
output = input.copy()
#input = cv.Canny(input,100,200) # 625
#input = cv.Canny(input,100,300) # 471
#input = cv.Canny(input,150,200) # 441
#input = cv.Canny(input,50,100) # 3=1476 5=1162 7=898
#input = cv.Canny(input,30,150) # 7=418
input = cv.Canny(input,40,120) # 7=418

# circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,100,param1=10,param2=20,minRadius=50,maxRadius=100) # lingon perfekt!

circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,100,param1=1,param2=15,minRadius=30,maxRadius=100) # lingon2

#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=9,minRadius=0,maxRadius=5) # 61
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=8,minRadius=0,maxRadius=5) # 105
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=7,minRadius=0,maxRadius=5) # 202
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=6,minRadius=0,maxRadius=5) # 426
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=10,minRadius=0,maxRadius=10) # 286
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=10,minRadius=5,maxRadius=10) # 228
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=10,minRadius=10,maxRadius=15) # 358
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=10,minRadius=5,maxRadius=15) # 825
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=10,param2=10,minRadius=2,maxRadius=2) # 27
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=9,param2=9,minRadius=3,maxRadius=3) # 40
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=9,param2=9,minRadius=4,maxRadius=4) # 37
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=12,param2=12,minRadius=5,maxRadius=5) # 13
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=12,param2=12,minRadius=6,maxRadius=6) # 17
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=15,param2=15,minRadius=10,maxRadius=10) # 10
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=15,param2=15,minRadius=15,maxRadius=15) # 8
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=20,param2=20,minRadius=20,maxRadius=20) # 2
#circles = cv.HoughCircles(input, cv.HOUGH_GRADIENT,1,1,param1=30,param2=30,minRadius=0,maxRadius=100)

circles = np.uint16(np.around(circles))
circles = circles[0]
circles = [circle for circle in circles if circle[1] < 2720]

with open(NAME + '.csv','w') as f:
	for x, y, r in circles:
		s = f"{x} {y} {r}"
		f.write(s+'\n')
		print(s)
print(len(circles))

#i=0
font = cv.FONT_HERSHEY_SIMPLEX
for x,y,r in circles:
	cv.circle(output,(x,y),r,(255,255,255,128),1)
	cv.circle(output,(x,y),2,(0,255,255,128),1)
	#if i>60: cv.putText(output, str(i), (x,y), font, 1, (255,255,255), 2)
	#i+=1

cv.imwrite(NAME+'.png',output)
cv.imshow('output',output)
cv.waitKey(0)
cv.destroyAllWindows()
