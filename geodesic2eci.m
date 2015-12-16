function [ x,y,z ] = geodesic2eci( lat,lon,alt,time )
%geodesic2eci geodesic to eci convertion
%   output - x,y,z in km
%   input  - lat long in degrees
%          - alt in km
%          - time  days since 4713 bc
% Reference:  The 1992 Astronomical Almanac, page K11. 

global radiusearthkm 
   
  deg2rad  =   pi() / 180.0;
  theta = mod(gstime(time) + lon*deg2rad,pi()*2);
  r = (radiusearthkm + alt)*cos(lat*deg2rad);
  x = r*cos(theta);
  y = r*sin(theta);
  z = (radiusearthkm + alt)*sin(lat*deg2rad);


end

