function [ az,el,rg ] = lookangles( xs,ys,zs,lato,lono,alto,time )
%lookangles Summary of this function goes here
%   Detailed explanation goes here
% based on http://celestrak.com/columns/v02n02/
deg2rad  =   pi() / 180.0;
latoRad = lato*deg2rad;
lonoRad = lono*deg2rad;

  [ xo,yo,zo ] = geodesic2eci( lato,lono,alto,time );
  theta = mod(gstime(time) + lonoRad,pi*2);
  rx = xs - xo;
  ry = ys - yo;
  rz = zs - zo;
  top_s = sin(latoRad)* cos(theta)*rx...
         + sin(latoRad)* sin(theta)*ry...
         - cos(latoRad)*rz;
  top_e = - sin(theta)*rx...
         + cos(theta)*ry;
  top_z = cos(latoRad)* cos(theta)*rx...
         + cos(latoRad)* sin(theta)*ry...
         + sin(latoRad)*rz;
  az = atan(-top_e/top_s);
  if top_s > 0
    az = az + pi();
  end
  if az < 0 
    az = az + 2*pi();
  end
  rg = sqrt(rx*rx + ry*ry + rz*rz);
  el = asin(top_z/rg);
  

end

