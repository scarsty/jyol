function WAR_CALLEVENT(num)
	local war={}
	war[999]=true
	
	if num==999 then 
		return 0
	else	
		local eventfilename=string.format("warevent%03d.lua",num);
		--lib.Debug(eventfilename);
		return dofile(CONFIG.ScriptPath.."war\\" .. eventfilename) or 0;
	end
end


------战斗事件中使用的部分函数----全部以WE_开头
function WE_xy(x,y,id)			--获取离目标xy最接近的可行坐标
--输入id时，适用于移动
--不输入时，适用于出现
	if id~=nil then
		War_CalMoveStep(id,128,0)
		--MY_CalMoveStep(x,y,128,0)
	else
		CleanWarMap(3,0)
	end
	if GetWarMap(x,y,3)~=255 and War_CanMoveXY(x,y,0) then
		return x,y
	else
		for s=1,128 do
			for i=1,s do
				local j=s-i
				if x+i<63 and y+j<63 then
					if GetWarMap(x+i,y+j,3)~=255 and War_CanMoveXY(x+i,y+j,0) then
						return x+i,y+j
					end
				end
				if x+j<63 and y-i>0 then
					if GetWarMap(x+j,y-i,3)~=255 and War_CanMoveXY(x+j,y-i,0) then
						return x+j,y-i	
					end
				end
				if x-i>0 and y-j>0 then
					if GetWarMap(x-i,y-j,3)~=255 and War_CanMoveXY(x-i,y-j,0) then
						return x-i,y-j	
					end
				end
				if x-j>0 and y+i<63 then
					if GetWarMap(x-j,y+i,3)~=255 and War_CanMoveXY(x-j,y+i,0) then
						return x-j,y+i
					end
				end
			end
		end		
	end
	
	for s=1,128 do
		for i=1,s do
			local j=s-i
			if x+i<63 and y+j<63 then
				if War_CanMoveXY(x+i,y+j,0) then
					return x+i,y+j
				end
			end
			if x+j<63 and y-i>0 then
				if War_CanMoveXY(x+j,y-i,0) then
					return x+j,y-i	
				end
			end
			if x-i>0 and y-j>0 then
				if War_CanMoveXY(x-i,y-j,0) then
					return x-i,y-j	
				end
			end
			if x-j>0 and y+i<63 then
				if War_CanMoveXY(x-j,y+i,0) then
					return x-j,y+i
				end
			end
		end
	end	
	return x,y
end	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--[[
	
	if GetWarMap(x,y,3)~=255 and War_CanMoveXY(x,y,0) then
		return x,y
	else
		CleanWarMap(4,0)
		local steparray={};     --用数组保存第n步的坐标。
		
			steparray.num=1;
			steparray.x={};
			steparray.y={};
		
		steparray.x[1]=x;
		steparray.y[1]=y;
		SetWarMap(x,y,4,1) 
		x,y=WE_FindNextxy(steparray)
		CleanWarMap(4,0)
		return x,y
	end
end


function WE_FindNextxy(steparray)
	local num=0
	for i=1,steparray.num do
	    local x=steparray.x[i];
	    local y=steparray.y[i];
	--lib.Debug("a"..(x)..','..y..','..GetWarMap(x,y,4))
	    if x+1<CC.WarWidth-1 and GetWarMap(x+1,y,4)==0 then                        --当前步数的相邻格
			if GetWarMap(x+1,y,3)==255 or War_CanMoveXY(x+1,y,0)==false then
                num=num+1;
                steparray.x[num]=x+1;
                steparray.y[num]=y;
				SetWarMap(x+1,y,4,1) 
	--lib.Debug((x)..','..y..','..GetWarMap(x,y,4))
			else return x+1,y
			end
		end
	    if x-1>=0 and GetWarMap(x-1,y,4)==0 then                        --当前步数的相邻格
			if GetWarMap(x-1,y,3)==255 or War_CanMoveXY(x-1,y,0)==false then
                num=num+1;
                steparray.x[num]=x-1;
                steparray.y[num]=y;
				SetWarMap(x-1,y,4,1) 
			else return x-1,y
			end
		end
	    if y+1<CC.WarWidth-1 and GetWarMap(x,y+1,4)==0 then                        --当前步数的相邻格
			if GetWarMap(x,y+1,3)==255 or War_CanMoveXY(x,y+1,0)==false then
                num=num+1;
                steparray.x[num]=x;
                steparray.y[num]=y+1;
				SetWarMap(x,y+1,4,1) 
			else return x,y+1
			end
		end
	    if y-1>=0 and GetWarMap(x,y-1,4)==0 then                        --当前步数的相邻格
			if GetWarMap(x,y-1,3)==255 or War_CanMoveXY(x,y-1,0)==false then
                num=num+1;
                steparray.x[num]=x;
                steparray.y[num]=y-1;
				SetWarMap(x,y-1,4,1) 
			else return x,y-1
			end
		end	
	--lib.Debug("b"..(x)..','..y..','..GetWarMap(x,y,4))
	end
	steparray.num=num
	return WE_FindNextxy(steparray)
	--local nx,ny=WE_FindNextxy(steparray)
	--return nx,ny
end

--]]
function WE_getwarid(pid)
	if WAR.PersonNum==nil then
		return -1;
	end
	for i=0,WAR.PersonNum-1 do
		if WAR.Person[i]["人物编号"]==pid then return i end
	end
	return -1;
end

function WE_move(pid,x,y)
--pid,人物编号
--x,y,目的坐标与坐标的相对值
	local id=WE_getwarid(pid)
	if id==-1 then return end
	WAR.CurID=id
	local cx,cy=WAR.Person[id]["坐标X"],WAR.Person[id]["坐标Y"]
	local nx,ny=WE_xy(cx+x,cy+y,id)
	--lib.Debug(x..','..y..','..nx..','..ny)
	War_MovePerson(nx,ny)
	lib.Delay(100)
end

function WE_moveto(pid,x,y)
--pid,人物编号
--x,y,目的坐标
	local id=WE_getwarid(pid)
	if id==-1 then return end
	WAR.CurID=id
	local nx,ny=WE_xy(x,y,id)
	--lib.Debug(x..','..y..','..nx..','..ny)
	War_MovePerson(nx,ny)
	lib.Delay(100)
end

function WE_follow(pid,eid)
--pid,人物编号
--id,目标人物，移动到离目标人物最近的位置
	local a=WE_getwarid(pid)
	local b=WE_getwarid(eid)
	--lib.Debug(a..','..b)
	if a==-1 or b==-1 then return end
	WAR.CurID=a
	local x,y=WAR.Person[b]["坐标X"],WAR.Person[b]["坐标Y"]
	local nx,ny=WE_xy(x,y,a)
	--lib.Debug(pid..','..eid..','..a..','..b..','..x..','..y..','..nx..','..ny)
	War_MovePerson(nx,ny)
	lib.Delay(100)
end

function WE_addperson(id,x,y,faseto,jq,flag)
--id,战场上新加的人物的人物编号
--x,y,出现位置
--flag,敌我标识
--faceto人物方向：0右上1右下2左上3左下
	faseto=faseto or 0
	if flag==nil then
		flag=true;
	end
	jq=jq or 200;
	local cx,cy=WE_xy(x,y)
	WAR.Person[WAR.PersonNum]["人物编号"]=id;
	WAR.Person[WAR.PersonNum]["我方"]=flag;
	WAR.Person[WAR.PersonNum]["坐标X"]=cx;
	WAR.Person[WAR.PersonNum]["坐标Y"]=cy;
	WAR.Person[WAR.PersonNum]["死亡"]=false;
	WAR.Person[WAR.PersonNum]["人方向"]=faseto;
	WAR.Person[WAR.PersonNum]["AI"]={2,0,0};
	if id==0 then
		WAR.Person[WAR.PersonNum]["AI"]={0,0,0};
	end
	WAR.Person[WAR.PersonNum]["贴图"]=WarCalPersonPic(WAR.PersonNum);
		--WAR.Person[i]["贴图"]=WarCalPersonPic(i);
	--WAR.Person[WAR.PersonNum]["AI"]=2;
	SetWarMap(cx,cy,2,WAR.PersonNum);
	SetWarMap(cx,cy,5,WAR.Person[WAR.PersonNum]["贴图"]);
	lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[id]["战斗动作"]),string.format(CC.FightPicFile[2],JY.Person[id]["战斗动作"]),4+WAR.PersonNum);
	WAR.Person[WAR.PersonNum]["轻功"]=GetSpeed(id);
	WAR.Person[WAR.PersonNum]["Time"]=jq;
	GetJiqi(WAR.PersonNum);
	WAR.PersonNum=WAR.PersonNum+1
	--WAR.CurID=WAR.PersonNum-1
end

function WE_sort()
--集中处理设置新加人物
--如设置贴图，轻功排序等
--未考虑周全	
--现在这个函数基本没用了，暂且保留吧
	WarPersonSort(1)
	for i=0,WAR.PersonNum-1 do
		local pid=WAR.Person[i]["人物编号"]
		lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[pid]["头像代号"]),string.format(CC.FightPicFile[2],JY.Person[pid]["头像代号"]),4+i);
		end
end

function WE_atk(id,cx,cy,kfid,lv,flag)
--播放武功动画
--如果lv为空，则只播放人物攻击动作
	CleanWarMap(4,0)
	local cid=WE_getwarid(id)
	local x0=WAR.Person[cid]["坐标X"];
	local y0=WAR.Person[cid]["坐标Y"];
	WAR.Person[cid]["人方向"]=War_Direct(0,0,cx,cy) or WAR.Person[cid]["人方向"]
	if lv~=nil then
		local kind,len1,len2=fenjie(JY.Wugong[kfid]["范围"..math.modf((lv+2)/3)])
		WarDrawAtt(x0+cx,y0+cy,kind,len1,len2,3,x0,y0)
	end
	local tmp=WAR.CurID
	WAR.CurID=cid
	War_ShowFight(id,kfid,JY.Wugong[kfid]["武功类型"],lv,x0+cx,y0+cy,JY.Wugong[kfid]["武功动画&音效"],0,0,0);
	WAR.CurID=tmp
	CleanWarMap(4,0)
end

function WE_close(id1,id2,len)
--判断两个id之间的距离，如果小于等于len则返回真
--如果len为空则返回两人的距离
	--len=len or 1
	local cid1=WE_getwarid(id1);
	local cid2=WE_getwarid(id2);
	if cid1==-1 or cid2==-1 then
		if len==nil then
			return -1;
		else
			return false;
		end
	end
	local x1,y1=WAR.Person[cid1]["坐标X"],WAR.Person[cid1]["坐标Y"]
	local x2,y2=WAR.Person[cid2]["坐标X"],WAR.Person[cid2]["坐标Y"]
	local s;
	if WAR.Person[cid1]["死亡"] or WAR.Person[cid2]["死亡"] then
		s=math.huge;
	else
		s=math.abs(x1-x2)+math.abs(y1-y2);
	end
	if len==nil then return s
	elseif s<=len then return true
	else return false
	end
end

function WE_chuxian(id,x,y)
	local pid=WE_getwarid(id)
	local cx,cy=WE_xy(x,y)
	SetWarMap(cx,cy,2,pid);
	SetWarMap(cx,cy,5,WAR.Person[pid]["贴图"]);
	WAR.Person[pid]["坐标X"]=cx
	WAR.Person[pid]["坐标Y"]=cy
end

function WE_xiaoshi(id)
	local pid=WE_getwarid(id)
	local cx,cy=WAR.Person[pid]["坐标X"],WAR.Person[pid]["坐标Y"]
	SetWarMap(cx,cy,2,-1);
	SetWarMap(cx,cy,5,-1);
end
