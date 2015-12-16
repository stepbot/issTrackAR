global tumin mu radiusearthkm xke j2 j3 j4 j3oj2
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(72);

lato = 39.985592;
lono = -76.017356;
alto = 0.1518;

url    = 'https://www.space-track.org/ajaxauth/login';
params = {'identity' 'stephanbotes@gmail.com' 'password' 'whatisthissupersecurepassword4!Spacetrack' 'query' 'https://www.space-track.org/basicspacedata/query/class/tle/format/json/NORAD_CAT_ID/25544/orderby/EPOCH%20desc/limit/1'};
[paramString,header] = http_paramsToString(params,1);
[output,extras] = urlread2(url,'POST',paramString,header);
data=loadjson(output);
[satrec] = json2satrec(data{1,1});
currentTime = datevec(now);
currentJulianTime = jday(currentTime(1),currentTime(2),currentTime(3),...
    currentTime(4),currentTime(5),currentTime(6));
epherimesAge = etime(currentTime,[satrec.epochyear,satrec.epochmon,... 
satrec.epochday,satrec.epochhour,satrec.epochmin,satrec.epochsec])/60;
[satrec, r, v] = sgp4(satrec,epherimesAge);

[ az,el,rg ] = lookangles( r(1,1),r(1,2),r(1,3),lato,lono,alto,currentJulianTime )
