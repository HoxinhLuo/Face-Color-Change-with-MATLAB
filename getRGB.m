function [R, G, B] = getRGB(img)

R = img(:, :, 1);
G = img(:, :, 2);
B = img(:, :, 3);
