/*
	Author: Karel Moricky

	Description:
	Export GUI macros and base classes

	Parameter(s):
		0: STRING - mode, can be:
			"Default" - classic base classes like RscText or RscPicture
			"3DEN" - Eden Editor base classes like ctrlStatic or ctrlStaticPicture
			"" - all GUI base classes, including more exotic ones

	Returns:
	STRING	Content of *.hpp file to be included in description.ext
		The result is also copied to clipboard
*/


_method = param [0,"",[""]];

_export = format ["// Generated by: ""%1"" call %2;

",_method,_fnc_scriptName];

_export = _export + "// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_HITZONES         17
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_ITEMSLOT         103
#define CT_CHECKBOX         77

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0
#define ST_UPPERCASE      0xC0
#define ST_LOWERCASE      0xD0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// Default grid
#define GUI_GRID_WAbs			((safezoneW / safezoneH) min 1.2)
#define GUI_GRID_HAbs			(GUI_GRID_WAbs / 1.2)
#define GUI_GRID_W			(GUI_GRID_WAbs / 40)
#define GUI_GRID_H			(GUI_GRID_HAbs / 25)
#define GUI_GRID_X			(safezoneX)
#define GUI_GRID_Y			(safezoneY + safezoneH - GUI_GRID_HAbs)

// Default text sizes
#define GUI_TEXT_SIZE_SMALL		(GUI_GRID_H * 0.8)
#define GUI_TEXT_SIZE_MEDIUM		(GUI_GRID_H * 1)
#define GUI_TEXT_SIZE_LARGE		(GUI_GRID_H * 1.2)

// Pixel grid
#define pixelScale	0.50
#define GRID_W (pixelW * pixelGrid * pixelScale)
#define GRID_H (pixelH * pixelGrid * pixelScale)
";

_grids = [
	["GUI_TEXT_SIZE_SMALL",	"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)"],
	["GUI_TEXT_SIZE_MEDIUM","(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)"],
	["GUI_TEXT_SIZE_LARGE",	"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)"],
	["GUI_GRID_Y",		"(safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))"],
	["GUI_GRID_H",		"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"],
	["GUI_GRID_W",		"(((safezoneW / safezoneH) min 1.2) / 40)"],
	["GUI_GRID_X",		"(safezoneX)"],
	["GUI_GRID_HAbs",	"(((safezoneW / safezoneH) min 1.2) / 1.2)"],
	["GUI_GRID_WAbs",	"((safezoneW / safezoneH) min 1.2)"],
	["GRID_W",		"(pixelW * pixelGrid * 0.50)"],
	["GRID_H",		"(pixelH * pixelGrid * 0.50)"]
];
{_x pushback count (_x select 1);} foreach _grids;
_types = [
	"CT_STATIC",           0,
	"CT_BUTTON",           1,
	"CT_EDIT",             2,
	"CT_SLIDER",           3,
	"CT_COMBO",            4,
	"CT_LISTBOX",          5,
	"CT_TOOLBOX",          6,
	"CT_CHECKBOXES",       7,
	"CT_PROGRESS",         8,
	"CT_HTML",             9,
	"CT_STATIC_SKEW",      10,
	"CT_ACTIVETEXT",       11,
	"CT_TREE",             12,
	"CT_STRUCTURED_TEXT",  13,
	"CT_CONTEXT_MENU",     14,
	"CT_CONTROLS_GROUP",   15,
	"CT_SHORTCUTBUTTON",   16,
	"CT_HITZONES",         17,
	"CT_XKEYDESC",         40,
	"CT_XBUTTON",          41,
	"CT_XLISTBOX",         42,
	"CT_XSLIDER",          43,
	"CT_XCOMBO",           44,
	"CT_ANIMATED_TEXTURE", 45,
	"CT_CHECKBOX",         77,
	"CT_OBJECT",           80,
	"CT_OBJECT_ZOOM",      81,
	"CT_OBJECT_CONTAINER", 82,
	"CT_OBJECT_CONT_ANIM", 83,
	"CT_LINEBREAK",        98,
	"CT_USER",             99,
	"CT_MAP",              100,
	"CT_MAP_MAIN",         101,
	"CT_LISTNBOX",         102,
	"CT_ITEMSLOT",         103
];
_stylesDefault = [
	"ST_POS",            	0x0F,
	"ST_HPOS",           	0x03,
	"ST_VPOS",           	0x0C,
	"ST_LEFT",           	0x00,
	"ST_RIGHT",          	0x01,
	"ST_CENTER",         	0x02,
	"ST_DOWN",           	0x04,
	"ST_UP",             	0x08,
	"ST_VCENTER",        	0x0C,
	"ST_TYPE",           	0xF0,
	"ST_SINGLE",         	0x00,
	"ST_MULTI",          	0x10,
	"ST_TITLE_BAR",      	0x20,
	"ST_PICTURE",        	0x30,
	"ST_FRAME",          	0x40,
	"ST_BACKGROUND",     	0x50,
	"ST_GROUP_BOX",      	0x60,
	"ST_GROUP_BOX2",     	0x70,
	"ST_HUD_BACKGROUND", 	0x80,
	"ST_TILE_PICTURE",   	0x90,
	"ST_WITH_RECT",      	0xA0,
	"ST_LINE",           	0xB0,
	"ST_UPPERCASE",      	0xC0,
	"ST_LOWERCASE",      	0xD0,
	"ST_SHADOW",         	0x100,
	"ST_NO_RECT",        	0x200,
	"ST_KEEP_ASPECT_RATIO",	0x800
];

_stylesSlider = [
	"SL_VERT",           0,
	"SL_HORZ",           0x400,
	"SL_TEXTURES",       0x10
];
_stylesprogress = [
	"ST_VERTICAL",       0x01,
	"ST_HORIZONTAL",     0
];
_stylesListbox = [
	"LB_TEXTURES",       0x10,
	"LB_MULTI",          0x20
];
_stylesTree = [
	"TR_SHOWROOT",       1,
	"TR_AUTOCOLLAPSE",   2
];

_tab = "";
_br = tostring [13,10];
_fnc_addLine = {
	_export = _export + _tab + _this + _br;
};
_tabN = 0;
_fnc_setTab = {
	_tabN = _tabN + _this;
	_tab = "";
	for "_i" from 1 to _tabN do {_tab = _tab + "	";};
};
_fnc_export = {
	{
		_xName = configname _x;
		switch true do {
			case (_xName == "type"): {
				_value = getnumber _x;
				_xID = _types find _value;
				if (_xID >= 0) then {_value = _types select (_xID - 1);};
				(format ["%1 = %2;",_xName,_value]) call _fnc_addLine;
			};
			case (_xName == "style"): {
				_type = getnumber (_this >> "type");
				_styles = _stylesDefault;
				switch _type do {
					case 3;
					case 43: {_styles = _stylesSlider + _styles;};
					case 8: {_styles = _stylesprogress + _styles;};
					case 5;
					case 42: {_styles = _stylesListbox + _stylesSlider + _styles;};
					case 12: {_styles = _stylesTree + _styles;};
				};
				_flags = (getnumber _x) call bis_fnc_bitflagstoarray;
				if (count _flags == 0) then {_flags = [0];};
				_value = "";
				{
					_xID = _styles find _x;
					if (_foreachindex > 0) then {_value = _value + " + ";};
					if (_xID >= 0) then {_value = _value + (_styles select (_xID - 1));};
				} foreach _flags;
				(format ["%1 = %2;",_xName,_value]) call _fnc_addLine;
			};
			case (isnumber _x): {
				_number = getnumber _x;
				(format ["%1 = %2;",_xName,_number]) call _fnc_addLine;
			};
			case (istext _x): {
				_text = gettext _x;
				_textArray = _text splitstring "	";
				_text = _textArray joinstring "";
				_isMacro = false;
				{
					_gridID = _text find (_x select 1);
					if (_gridID >= 0) then {
						_text = (_text select [0,_gridID]) + (_x select 0) + (_text select [_gridID + (_x select 2)]);
						_isMacro = true;
					};
				} foreach _grids;
				if (_isMacro) then {
					(format ["%1 = %2;",_xName,_text]) call _fnc_addLine;
				} else {
					(format ["%1 = ""%2"";",_xName,_text]) call _fnc_addLine;
				};
			};
			case (isarray _x): {
				_array = getarray _x;
				_indexLast = count _array - 1;
				if ({_x isequaltype ""} count _array > 0) then {
                        
					//--- Multi line array
					(format ["%1[] =",configname _x]) call _fnc_addLine;
					"{" call _fnc_addLine;
					+1 call _fnc_setTab;
					{
						(format [if (_foreachindex == _indexLast) then {"%1"} else {"%1,"},str _x]) call _fnc_addLine;
					} foreach _array;
					-1 call _fnc_setTab;
					"};" call _fnc_addLine;
				} else {
                        
					//--- Single line array
					_arrayText = "";
					{
						_arrayText = _arrayText + format [if (_foreachindex == _indexLast) then {"%1"} else {"%1,"},str _x];
					} foreach _array;
					(format ["%1[] = {%2};",_xName,_arrayText]) call _fnc_addLine;
				};
			};
			case (isclass _x): {
				_x call _fnc_addClass;
			};
		};
	} foreach configproperties [_this,"true",false];
};
_fnc_addClass = {
	_parent = inheritsfrom _x;
	if (isclass _parent) then {
		(format ["class %1: %2",configname _x,configname _parent]) call _fnc_addLine;
	} else {
		(format ["class %1",configname _x]) call _fnc_addLine;
	};
	"{" call _fnc_addLine;
	+1 call _fnc_setTab;
	_x call _fnc_export;
	-1 call _fnc_setTab;
	"};" call _fnc_addLine;
};

"" call _fnc_addLine;
"" call _fnc_addLine;

switch _method do {

	//--- Export only classic GUI base classes
	case "Default": {
		_listClassic = [
			"Scrollbar",
			"RscObject",
			"RscText",
			"RscFrame",
			"RscLine",
			"RscProgress",
			"RscPicture",
			"RscPictureKeepAspect",
			"RscVideo",
			"RscHTML",
			"RscButton",
			"RscShortcutButton",
			"RscEdit",
			"RscCombo",
			"RscListBox",
			"RscListNBox",
			"RscXListBox",
			"RscTree",
			"RscSlider",
			"RscXSliderH",
			"RscActiveText",
			"RscActivePicture",
			"RscActivePictureKeepAspect",
			"RscStructuredText",
			"RscToolbox",
			"RscControlsGroup",
			"RscControlsGroupNoScrollbars",
			"RscControlsGroupNoHScrollbars",
			"RscControlsGroupNoVScrollbars",
			"RscButtonTextOnly",
			"RscButtonMenu",
			"RscButtonMenuOK",
			"RscButtonMenuCancel",
			"RscButtonMenuSteam",
			"RscMapControl",
			"RscMapControlEmpty",
			"RscCheckbox"
		];
		{
			_x = configfile >> _x;
			_x call _fnc_addClass;
		} foreach _listClassic;
	};

	//--- Export 3DEN base classes
	case "3DEN": {
		{
			//--- Identify classes with idc (GUI) and no Controls (only the basic ones)
			if (isnumber (_x >> "deletable") && count (_x >> "Controls") == 0) then {
				_x call _fnc_addClass;
			};
		} foreach configproperties [configfile,"isclass _x && {((configname _x) select [0,4]) == 'ctrl'}"];
	};

	//--- Export all classes
	default {
		{
			_x = configfile >> _x;
			_x call _fnc_addClass;
		} foreach [
			"Scrollbar",
			"RscObject"
		];

		{
			//--- Identify classes with idc (GUI) and no Controls (only the basic ones)
			if (isnumber (_x >> "deletable") && count (_x >> "Controls") == 0) then {
				_x call _fnc_addClass;
			};
		} foreach configproperties [configfile,"isclass _x"];
	};
};

copytoclipboard _export;
_export