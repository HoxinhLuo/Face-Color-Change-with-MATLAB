clear, close all;

% imgpath = '11.jpg';
filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
[f, p] = uigetfile(filterspec);
if (ischar(p))
    imgpath = [p f];
    img = imread(imgpath);

    [R, G, B] = getRGB(img);
    out = faceDetection(imgpath);

    aveR = getColorEverage(R, out);
    aveG = getColorEverage(G, out);
    aveB = getColorEverage(B, out);
end