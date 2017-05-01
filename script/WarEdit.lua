--By:JY027
function WarEdit()
	lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_BLACK);
	WAR.Data={};
	local warnum=filelength(CC.WarFile)/CC.WarDataSize;
	local menu=	{
					{"新增战斗",nil,1},
					{"编辑战斗",nil,1},
				};
	while true do
		local select=ShowMenu(menu,2,2,4,4,0,0,1,1,CC.Fontbig,C_ORANGE,C_WHITE);
		if select==1 then
			if WarEdit_sub(warnum)==1 then
				warnum=warnum+1;
			end
		elseif select==2 then
			local wid=SelectWar(warnum);
			if wid>=0 then
				if WarEdit_sub(wid)==1 then
					warnum=warnum+1;
				end
			end
		else
			break;
		end
	end
	return -1;
end

function SelectWar(num)
	local warname={};
	for i=0,num-1 do
		local data=Byte.create(CC.WarDataSize);      --读取战斗数据
		Byte.loadfile(data,CC.WarFile,i*CC.WarDataSize,CC.WarDataSize);
		LoadData(WAR.Data,CC.WarData_S,data);
		warname[i]=string.format("%03d:%s",i,WAR.Data["名称"]);
	end
	local fontsize=CC.FontSMALL;
	local wan=fontsize*8;
	local select=0;
	local page=0;
	local num_x=math.modf(CC.ScreenW/wan);
	local num_y=math.modf(CC.ScreenH/fontsize);
	local function ShowWarName()
		lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_BLACK);
		local start=num_x*num_y*page;
		for i=start,num_x*num_y*(page+1) do
			if warname[i]==nil then
				break;
			else
				local color=C_ORANGE;
				if i==select then
					color=C_WHITE;
				end
				local y=math.modf((i-start)/num_x);
				local x=i-start-num_x*y;
				DrawString(x*wan,y*fontsize,warname[i],color,fontsize);
			end
		end
		ShowScreen();
	end
	while true do
		ShowWarName();
		local eventtype,key,x,y=WaitKey(1);
		if eventtype==1 then
			if key==VK_UP then
				if select>=num_x then
					select=select-num_x;
				end
			elseif key==VK_DOWN then
				if warname[select+num_x]~=nil then
					select=select+num_x;
				end
			elseif key==VK_LEFT then
				if select>0 then
					select=select-1;
				end
			elseif key==VK_RIGHT then
				if warname[select+1]~=nil then
					select=select+1;
				end
			elseif key==VK_SPACE or key==VK_RETURN then
				break;
			elseif key==VK_ESCAPE then
				select=-1;
				break;
			end
		elseif eventtype==2 then
			select=math.modf(x/wan)+num_x*math.modf(y/fontsize);
		elseif eventtype==3 then
			select=math.modf(x/wan)+num_x*math.modf(y/fontsize);
			break;			
		end
		page=math.modf(select/num_x/num_y);
	end
	return select;
end

function WarEdit_sub(wid)
	lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_BLACK);
	local menu=	{
					{"设置战斗名称",WarEdit_SetName,1},
					{"设置音乐",WarEdit_SetMusic,1},
					{"设置经验",WarEdit_SetExp,1},
					{"设置战场地图",WarEdit_SetMap,1},
					{"配置敌方位置",WarEdit_SetEnemy,1},
					{"配置我方位置",WarEdit_SetTeam,1},
					{"保存退出",WarEdit_Save,1},
				};
	ShowMenu(menu,7,7,4,4,0,0,1,1,CC.Fontbig,C_ORANGE,C_WHITE);
end

function WarEdit_SetName()
	local s=Shurufa();
	if s~='' then
		WAR.Data["名称"]=s;
	end
end

function WarEdit_SetMusic()
	local musicid=GetNumStr();
	if type(musicid)=='number' then
		WAR.Data["音乐"]=musicid;
	end
end
function WarEdit_SetExp()
	local warexp=GetNumStr();
	if type(warexp)=='number' then
		WAR.Data["经验"]=warexp;
	end
end
function WarEdit_SetMap()
	local mapid=GetNumStr();
	if type(mapid)=='number' then
		WAR.Data["地图"]=mapid;
	end
end
function WarEdit_SetEnemy()
	WarEdit_SetSub();
end
function WarEdit_SetTeam()
	WarEdit_SetSub();
end
function WarEdit_SetSub()
end
function WarEdit_Save()
end