from PIL import Image, ImageDraw, ImageFont
from math import sqrt, pi, cos, sin
from canny import canny_edge_detector
from collections import defaultdict

# Load image:
input_image = Image.open("1.jpg")

# Output image:
output_image = Image.new("RGB", input_image.size)
output_image.paste(input_image)
draw_result = ImageDraw.Draw(output_image)

# Find circles
rmin = 10 # 18
rmax = 30 # 20
steps = 50
threshold = 0.4

points = []
for r in range(rmin, rmax + 1):
    for t in range(steps):
        points.append((r, int(r * cos(2 * pi * t / steps)), int(r * sin(2 * pi * t / steps))))
print('points',len(points))

acc = defaultdict(int)
lst = canny_edge_detector(input_image)
print('lst',len(lst))
for x, y in lst :
    for r, dx, dy in points:
        a = x - dx
        b = y - dy
        acc[(a, b, r)] += 1

print('f',len(acc))
circles = []
for k, v in sorted(acc.items(), key=lambda i: -i[1]):
    x, y, r = k
    if v / steps >= threshold and all((x - xc) ** 2 + (y - yc) ** 2 > rc ** 2 for xc, yc, rc in circles):
        print(v / steps, x, y, r)
        circles.append((x, y, r))

print('g')
i = 0
fnt = ImageFont.truetype("FreeMono.ttf", 40)
for x, y, r in circles:
    draw_result.ellipse((x-r, y-r, x+r, y+r), outline=(255,0,0,0))
    draw_result.text((x,y), str(i), font=fnt, fill=(255, 255, 0, 128))
    i+=1

print('h')
# Save output image
output_image.save("1.png")
