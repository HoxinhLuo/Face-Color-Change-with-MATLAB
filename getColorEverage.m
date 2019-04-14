function aveColor = getColorEverage(img, condit)

temp = img(condit == 255);
aveColor = sum(temp) / length(temp);