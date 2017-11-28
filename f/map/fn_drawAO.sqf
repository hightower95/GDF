//Function by TinfoilHate unless otherwise noted
//[markerName,specLogic,hatchAreaFactor,aoProtection,desertMapColors] call tin_aomSetup;
//Example: ["AO_Map_Marker",100,true] call f_fnc_missionao;

if (!hasInterface || !("AO_Map_Marker" in allMapMarkers)) exitWith {};

_baseMarker = "AO_Map_Marker";
_coverSize = 100;
_desertMap = true;
_markerType = getMarkerType _baseMarker;
if (_markerType == "") exitWith {
	player sideChat "No AO Map marker";
};

_baseMarkerDir = markerDir _baseMarker;
if (_baseMarkerDir > 360) then {_baseMarkerDir = (_baseMarkerDir mod 360)};
if (_baseMarkerDir < 0) then {_baseMarkerDir = (_baseMarkerDir mod 360) + 360};

_baseMarkerPos = getMarkerPos _baseMarker;
_baseMarkerPos = [(round ((_baseMarkerPos select 0) / 100)) * 100,(round ((_baseMarkerPos select 1) / 100)) * 100,0];
_baseMarker setMarkerPos _baseMarkerPos;

_baseMarkerSize = getMarkerSize _baseMarker;
_baseMarkerColor = getMarkerColor _baseMarker;

_baseLogic = "Land_Research_house_V1_F" createVehicleLocal _baseMarkerPos;
_baseLogic hideObject true;
_baseLogic setPosATL _baseMarkerPos;
_baseLogic setDir _baseMarkerDir;

_baseSizeX = _baseMarkerSize select 0;
_baseSizeY = _baseMarkerSize select 1;
_basePosX = 0;
_basePosY = 0;
_baseMulti = 2;

_screenSizeX = 0;
_screenSizeY = 0;

_coverHatch = "FDiagonal";

_coverUX = _basePosX;
_coverUY = _basePosY + (_baseSizeY + _coverSize);

_coverDX = _basePosX;
_coverDY = _basePosY - (_baseSizeY + _coverSize);

_coverLX = _basePosX - (_baseSizeX + _coverSize);
_coverLY = _basePosY;

_coverRX = _basePosX + (_baseSizeX + _coverSize);
_coverRY = _basePosY;

_coverTopX  = (_coverSize * 2) + _baseSizeX;
_coverTopY  = _coverSize;

_coverSideX = _coverSize;
_coverSideY = _baseSizeY;

if ((_baseMarkerDir >= 45 && _baseMarkerDir <= 135) || (_baseMarkerDir >= 225 && _baseMarkerDir <= 315)) then {_screenSizeX = _coverUY; _screenSizeY = _coverRX;} else {_screenSizeX = _coverRX; _screenSizeY = _coverUY;};
if ((_baseMarkerDir >= 45 && _baseMarkerDir <= 90) || (_baseMarkerDir >= 225 && _baseMarkerDir <= 270)) then {_coverHatch = "BDiagonal"};

#define CREATE(NAME,SIZEX,SIZEY) \
_temp = createMarkerLocal [NAME,[_tempPos select 0,_tempPos select 1]]; \
NAME setMarkerShapeLocal "RECTANGLE"; \
NAME setMarkerSizeLocal [SIZEX,SIZEY]; \
NAME setMarkerDirLocal _baseMarkerDir; \
NAME setMarkerBrushLocal _coverHatch; \
NAME setMarkerAlphaLocal 0.5; \
NAME setMarkerColorLocal _baseMarkerColor;

_tempPos = _baseLogic modelToWorld [_coverUX, _coverUY, 0];
CREATE("prx_coverUp",_coverTopX,_coverTopY);

_tempPos = _baseLogic modelToWorld [_coverDX, _coverDY, 0];
CREATE("prx_coverDn",_coverTopX,_coverTopY);

_tempPos = _baseLogic modelToWorld [_coverLX, _coverLY, 0];
CREATE("prx_coverLt",_coverSideX,_coverSideY);

_tempPos = _baseLogic modelToWorld [_coverRX, _coverRY, 0];
CREATE("prx_coverRt",_coverSideX,_coverSideY);

deleteVehicle _baseLogic;

///// Mostly BIS Stuff Within /////
_posX = _baseMarkerPos select 0;
_posY = _baseMarkerPos select 1;
_dir = 0;
_sizeOut = 100000;
_sizeBorder = (_screenSizeX max _screenSizeY) / 50;

_colorForest = "colorKhaki";
_colorDesert = "colorBlack";
_colors = if (_desertMap) then {
	["colorBlack","colorBlack","colorBlack","colorWhite",_colorDesert,/**/"colorBlack"/**/,_colorDesert,_colorDesert];
} else {
	["colorBlack","colorBlack",_colorForest,"colorGreen",_colorForest,/**/"colorBlack"/**/,_colorForest,_colorForest];
};

for "_i" from 0 to 270 step 90 do {
	_sizeMarker = [_screenSizeX,_sizeOut] select ((_i / 90) % 2);
	_dirTemp = _dir + _i;
	_markerPos = [
		_posX + (sin _dirTemp * (_screenSizeX + _sizeOut)),
		_posY + (cos _dirTemp * (_screenSizeY + _sizeOut))
	];
	for "_m" from 0 to (count _colors - 1) do {
		_marker = createMarkerLocal [format ["zone_%1_%2",_i,_m],_markerPos];
		_marker setMarkerSizeLocal [_sizeMarker,_sizeOut];
		_marker setMarkerDirLocal _dirTemp;
		_marker setMarkerShapeLocal "rectangle";
		_marker setMarkerBrushLocal "solid";
		_marker setMarkerColorLocal (_colors select _m);
		if (_m == 5) then {
			_marker setMarkerBrushLocal "grid";
			_marker setMarkerSizeLocal [_sizeMarker,_sizeOut];
		};
	};

	//--- White borders
	_sizeMarker = [_screenSizeX,_screenSizeY + _sizeBorder * 2] select ((_i / 90) % 2);
	_sizeBorderTemp = _sizeBorder;
	_markerPos = [
		_posX + (sin _dirTemp * (_screenSizeX + _sizeBorderTemp)),
		_posY + (cos _dirTemp * (_screenSizeY + _sizeBorderTemp))
	];
	for "_m" from 0 to 7 do {
		_marker = createMarkerLocal [format ["zoneBorder_%1_%2",_i,_m],_markerPos];
		_marker setMarkerSizeLocal [_sizeMarker,_sizeBorderTemp];
		_marker setMarkerDirLocal _dirTemp;
		_marker setMarkerShapeLocal "rectangle";
		_marker setMarkerBrushLocal "solid";
		_marker setMarkerColorLocal "colorwhite";
	};
};

//--- Black frame Inner
_marker = createMarkerLocal ["zoneBorderInner",_baseMarkerPos];
_marker setMarkerSizeLocal [_screenSizeX,_screenSizeY];
_marker setMarkerDirLocal 0;
_marker setMarkerShapeLocal "rectangle";
_marker setMarkerBrushLocal "border";
_marker setMarkerColorLocal "colorBlack";

//--- Black frame Outer
_marker = createMarkerLocal ["zoneBorderOuter",_baseMarkerPos];
_marker setMarkerSizeLocal [_screenSizeX + _sizeBorder * 2,_screenSizeY + _sizeBorder * 2];
_marker setMarkerDirLocal 0;
_marker setMarkerShapeLocal "rectangle";
_marker setMarkerBrushLocal "border";
_marker setMarkerColorLocal "colorBlack";