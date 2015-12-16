function [ephermisJson] = updateEphermis()
%updateEphermis() retrieves latest ephermis data and returns a JSON encoded
%object containing tle data

url    = 'https://www.space-track.org/ajaxauth/login';
params = {'identity' 'stephanbotes@gmail.com' 'password' 'whatisthissupersecurepassword4!Spacetrack' 'query' 'https://www.space-track.org/basicspacedata/query/class/tle/format/json/NORAD_CAT_ID/25544/orderby/EPOCH%20desc/limit/1'};
[paramString,header] = http_paramsToString(params,1);
[output,~] = urlread2(url,'POST',paramString,header);
data=loadjson(output);
ephermisJson = data{1,1};

end

