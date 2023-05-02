% JLK
% Coordinate_Transform_Simple
%
% A function used for warping an image

%% Initial Inputs
Cylinder_Diameter = 680;% Diameter for ease of measurement (mm)
Viewing_Angle = 30; % degrees
%Image_Height_Proj = 200; % 2D representation on the cylinder, y (mm)
%Image_Width_Proj = 200; % 2D representation, x (mm)
Projection_Height = 700; % Apparant top of image relative to ground (mm)

Image = imread("Rainbow.png"); % Imports the Image from the Working Directory
%Image = Image(250:650,400:800,:);
Image_Gray = rgb2gray(Image);   % Converts the image to grayscale

Image_Red = Image;
Image_Red(:,:,[2 3]) = 0; % Preserves Dimensions
Red = Image(:,:,1);
Red_Gray = rgb2gray(Image_Red);
figure(55)
montage({Red,Red_Gray})
Image_Green = Image;
Image_Green(:,:,[1 3]) = 0;
Green = Image(:,:,2);
Green_Gray = rgb2gray(Image_Green);

Blue = Image(:,:,3);

% Displays Grayscale Image
figure(4)
imshow(Image_Gray)

% Finds the pixel lengths
[Ypix, Xpix] = size(Image_Gray);

%
% Place here for some logic to place image onto cylinder
%

Image_Width_Proj = 600; % This is the width of the projected image (mm)
Image_Height_Proj = Image_Width_Proj*(Ypix/Xpix); % Same for height

%% Calculate
Outer_Edge = Projection_Height*tand(Viewing_Angle); % Calculates Physical Distance of Outer Radius
Inner_Edge = (Projection_Height-Image_Height_Proj)*tand(Viewing_Angle); % Shows the same Viewing Angle, just basic from infinity.

% This is the radius relative to the center of the sphere
Outer_Radius = Outer_Edge + (Cylinder_Diameter/2); 
Inner_Radius = Inner_Edge + (Cylinder_Diameter/2); 

Cylinder_Image2Diameter = Image_Width_Proj/Cylinder_Diameter; %Ratio of width to diameter
AngleRange = pi*Cylinder_Image2Diameter/2; % Finds Angle range over which to place the image

% 
% Wondering ratio of square im to 180 deg fan
%
%% Map
% Creates Polar Map
Theta = linspace(pi/2-AngleRange,pi/2+AngleRange,Xpix);
Radius = linspace(Inner_Radius,Outer_Radius,Ypix);

[ThTh, RR] = meshgrid(Theta,Radius); % Generates coordinate mesh

[x,y,z] = pol2cart(ThTh,RR,Image_Gray); % Convert polar to cartesian for mapping

%% Display
figure(1)
surf(x,y,Image_Gray,EdgeColor="none");
title("Polar Image plotted in Cartesion")
xlabel("Radians")
I = [x,y,z];
%% Plots the anamorphic Art

% Red Processing
figure(18)
Anamorphic_Art = pcolor(x,y,Red./255); % Creates the actual map
set(Anamorphic_Art,"EdgeColor","none") 
axis off
daspect([1,1,1]) % Equalizes Scaling on axis
f = gca;
exportgraphics(f,'Red.png','Resolution',300)
Image_Red = imread('Red.png');
Red_Comp = rgb2gray(Image_Red);
[Ynew,Xnew] = size(Red_Comp);

% Green Processing
figure(7)
Anamorphic_Art = pcolor(x,y,Green./255); % Creates the actual map %normalizes? :(
set(Anamorphic_Art,"EdgeColor","none") 
axis off
colormap(gray)
daspect([1,1,1]) % Equalizes Scaling on axis
f = gca;
exportgraphics(f,'Green.png','Resolution',300)
Image_Green = imread('Green.png');
Green_Comp = rgb2gray(Image_Green);

% Blue Processing
figure(2)
Anamorphic_Art = pcolor(x,y,Blue./255); % Creates the actual map
set(Anamorphic_Art,"EdgeColor","none") 
axis off
colormap(gray)
daspect([1,1,1]) % Equalizes Scaling on axis
f = gca;
exportgraphics(f,'Blue.png','Resolution',300)
Image_Blue = imread('Blue.png');
Blue_Comp = rgb2gray(Image_Blue);

Color = zeros(Ynew,Xnew,3);
Color(:,:,1) = Red_Comp;
Color(:,:,2) = Green_Comp;
Color(:,:,3) = Blue_Comp;
figure(77)
imshow(Color);
figure(78)
montage({Image,Color})

% Print as pdf after
