function [satrec] = json2satrec(jsonObject)

global tumin 

deg2rad  =   pi / 180.0;         %  0.01745329251994330;  % [deg/rad]
xpdotp   =  1440.0 / (2.0*pi);   % 229.1831180523293;  % [rev/day]/[rad/min] 
    
satrec.epochyear = str2double(jsonObject.EPOCH(1:4));
satrec.epochmon = str2double(jsonObject.EPOCH(6:7));
satrec.epochday = str2double(jsonObject.EPOCH(9:10));
satrec.epochhour = str2double(jsonObject.EPOCH(12:13));
satrec.epochmin = str2double(jsonObject.EPOCH(15:16));
satrec.epochsec = str2double(jsonObject.EPOCH(18:19));

satrec.satnum = str2double(jsonObject.NORAD_CAT_ID);
satrec.epochyr = str2double(jsonObject.EPOCH(1:4));
satrec.jdsatepoch = jday( satrec.epochyear,satrec.epochmon,satrec.epochday,satrec.epochhour,satrec.epochmin,satrec.epochsec );
satrec.ndot = str2double(jsonObject.MEAN_MOTION_DOT);
satrec.nddot = str2double(jsonObject.MEAN_MOTION_DDOT);
satrec.bstar = str2double(jsonObject.BSTAR);
satrec.inclo = str2double(jsonObject.INCLINATION);
satrec.nodeo = str2double(jsonObject.RA_OF_ASC_NODE);
satrec.ecco = str2double(jsonObject.ECCENTRICITY);
satrec.argpo = str2double(jsonObject.ARG_OF_PERICENTER);
satrec.mo = str2double(jsonObject.MEAN_ANOMALY);
satrec.no = str2double(jsonObject.MEAN_MOTION);

%     // ---- find no ----
    satrec.no   = satrec.no / xpdotp; %//* rad/min
    

%     // ---- convert to sgp4 units ----
    satrec.a    = (satrec.no*tumin)^(-2/3);                % [er]
    satrec.ndot = satrec.ndot  / (xpdotp*1440.0);          % [rad/min^2]
    satrec.nddot= satrec.nddot / (xpdotp*1440.0*1440);     % [rad/min^3]

%     // ---- find standard orbital elements ----
    satrec.inclo = satrec.inclo  * deg2rad;
    satrec.nodeo = satrec.nodeo * deg2rad;
    satrec.argpo = satrec.argpo  * deg2rad;
    satrec.mo    = satrec.mo     * deg2rad;

    satrec.alta = satrec.a*(1.0 + satrec.ecco) - 1.0;
    satrec.altp = satrec.a*(1.0 - satrec.ecco) - 1.0;
    
     
     sgp4epoch = satrec.jdsatepoch - 2433281.5;
     [satrec] = sgp4init(72, satrec, satrec.bstar, satrec.ecco, sgp4epoch, ...
         satrec.argpo, satrec.inclo, satrec.mo, satrec.no, satrec.nodeo);
     
 