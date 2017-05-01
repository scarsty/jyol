


---本模块存放对JYMain.lua 的修改和扩充。

--尽量把新增加模块放在这里，少修改原始JYMain.Lua文件。
--这里一般包括以下几个部分
--1. SetModify函数。   该函数在游戏开始时调用，可以在此修改原有的数据，以及重定义原有的函数，以实现对原有函数的修改、
--                    这样就可以基本不动原始的函数
--2. 原有函数的重载函数。 SetModify中重载的函数放在此处。尽量不修改JYMain.lua文件，对它的修改采用重定义函数的形式。
--3. 新的物品使用函数。
--4. 新的场景事件函数。





--对jymain的修改，以及增加新的物品函数和场景事件函数。
--注意这里可以定义全程变量。
function SetModify()
	Font_Qiti=".\\方正启体简体.ttf";
	Font_Xihei=".\\华文细黑.ttf";
   --这是一个定义函数的例子。这里重新修改主菜单中的系统菜单，增加在游戏运行中控制音效的功能。
   --原来只能在jyconst.lua中通过参数在运行前控制，不能做到实时控制。
   Menu_System_old=Menu_System;         --备份原始函数，如果新的函数需要，还可以调用原始函数。
   Menu_System=Menu_System_new;

   --在此定义特殊物品。没有定义的均调用缺省物品函数
    JY.ThingUseFunction[182]=Show_Position;     --罗盘函数
	JY.ThingUseFunction[0]=newThing_0;   --改变原来康贝特的功能为醉生梦死酒忘记武功。
	JY.ThingUseFunction[2]=newThing_2;

  --在此可以定义使用新事件函数的场景
    JY.SceneNewEventFunction[1]=newSceneEvent_1;          --新的河洛客栈事件处理函数

end


--新的系统子菜单，增加控制音乐和音效
function Menu_System_new()
	local menu={
	             {"读取进度",Menu_ReadRecord,1},
                 {"保存进度",Menu_SaveRecord,1},
				 {"关闭音乐",Menu_SetMusic,1},
				 {"关闭音效",Menu_SetSound,1},
				 {"全屏切换",Menu_FullScreen,1},
                 {"离开游戏",Menu_Exit,1},   };

    if JY.EnableMusic==0 then
	    menu[3][1]="打开音乐";
	end

	if JY.EnableSound==0 then
	    menu[4][1]="打开音效";
    end


    local r=ShowMenu(menu,6,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r == 0 then
        return 0;
    elseif r<0 then   --要退出全部菜单，
        return 1;
 	end
end

function Menu_FullScreen()
    lib.FullScreen();
	lib.Debug("finish fullscreen");
end

function Menu_SetMusic()
    if JY.EnableMusic==0 then
	    JY.EnableMusic=1;
		PlayMIDI(JY.CurrentMIDI);
	else
	    JY.EnableMusic=0;
		lib.PlayMIDI("");
	end
	return 1;
end

function Menu_SetSound()
    if JY.EnableSound==0 then
	    JY.EnableSound=1;
	else
	    JY.EnableSound=0;
	end
	return 1;
end


----------------------------------------------------------------
---------------------------物品使用函数--------------------------


--罗盘函数，显示主地图主角位置
function Show_Position()
    if JY.Status ~=GAME_MMAP then
        return 0;
    end
    DrawStrBoxWaitKey(string.format("当前位置(%d,%d)",JY.Base["人X"],JY.Base["人Y"]),C_ORANGE,CC.DefaultFont);
	return 1;
end


--醉生梦死酒。喝后可以忘掉一种武功
function newThing_0(id)
    if JY.Status ==GAME_WMAP then
	    return 0;
	end

    Cls();
    if DrawStrBoxYesNo(-1,-1,"喝后会忘记武功，但损害生命，是否继续?",C_WHITE,CC.DefaultFont,1) == false then
        return 0;
    end
    Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("谁要服用%s?",JY.Thing[id]["名称"]),C_WHITE,CC.DefaultFont,1);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r<=0 then
	    return 0;
	end

	local pid=JY.Base["队伍" .. r];

	if JY.Person[pid]["生命最大值"]<=50 then
	    return 0;
	end

	Cls();
    local numwugong=0;
    local menu={};
    for i=1,10 do
        local tmp=JY.Person[pid]["武功" .. i];
        if tmp>0 then
            menu[i]={JY.Wugong[tmp]["名称"],nil,1};
            numwugong=numwugong+1;
        end
    end

    if numwugong==0 then
        return 0;
    end

    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("请选择要忘记的武功"),C_WHITE,CC.DefaultFont,1);

	r=ShowMenu(menu,numwugong,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

    if r<=0 then
	    return 0;
    else
        local s=string.format("%s 忘记武功 %s",JY.Person[pid]["姓名"],JY.Wugong[JY.Person[pid]["武功" .. r]]["名称"]);
		DrawStrBoxWaitKey(s,C_WHITE,24);

		for i=r+1,10 do
		    JY.Person[pid]["武功" .. i-1]=JY.Person[pid]["武功" .. i];
		    JY.Person[pid]["武功等级" .. i-1]=JY.Person[pid]["武功等级" .. i];
		end

		local v,str=AddPersonAttrib(pid,"生命最大值",-50);

	    DrawStrBoxWaitKey(str,C_WHITE,CC.DefaultFont);
        AddPersonAttrib(pid,"生命",0);

        instruct_32(id,-1);
	end
    Cls();
	return 1;
end


--还魂液，战斗时可以使一个死亡的队友复活，各项机能恢复50%
function newThing_2(thingid)
    if JY.Status ~=GAME_WMAP then
	    return 0;
	end

	local menu={};
    local menunum=0;
    for i=0,WAR.PersonNum-1 do
	    menu[i+1]={JY.Person[WAR.Person[i]["人物编号"]]["姓名"],nil,0}
        if WAR.Person[i]["我方"]==true and WAR.Person[i]["死亡"]==true then
            menu[i+1][3]=1;
			menunum=menunum+1;
        end
    end

	if menunum==0 then
	    return 0;
	end

	Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("请选择要复活的队友"),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=ShowMenu(menu,WAR.PersonNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
    Cls();
    if r>0 then
	    r=r-1;           --菜单返回值是从1开始编号的。
		WAR.Person[r]["死亡"]=false;
        local pid=WAR.Person[r]["人物编号"];
        JY.Person[pid]["生命"]=JY.Person[pid]["生命最大值"];
        SetRevivePosition(r);
        instruct_32(thingid,-1);
        WarSetPerson();        --重新设定战斗位置
	    return 1;
	else
	    return 0;
	end
end

--设置复活队友的位置为距离当前使用物品的战斗人物最近的空位
function  SetRevivePosition(id)
	local minDest=math.huge;
	local x,y;
	War_CalMoveStep(WAR.CurID,100,0);   --计算移动步数 假设最大100步
	for i=0,CC.WarWidth-1 do
		for j=0,CC.WarHeight-1 do
			local dest=Byte.get16(WAR.Map3,(j*CC.WarWidth+i)*2);
			if dest>0 and dest <128 then
				if minDest>dest then
					minDest=dest;
					x=i;
					y=j;
				 elseif minDest==dest  then
					 if Rnd(2)==0 then
						x=i;
						y=j;
					end
				end
			end
		end
	end

	if minDest<math.huge then
        WAR.Person[id]["坐标X"]=x;
        WAR.Person[id]["坐标Y"]=y;
	end

end


------------------------------------------------------------------------------------------
-------新的场景事件函数实例

--对每个场景每个D*都对应一个lua文件。在此文件中处理不同的触发方式和事件变化情况
--这样做有一个缺点，如果多个D*需要调用同样的事件怎么办？一个办法是在一个lua文件中继续用dofile调用另一个。
--另一个办法是做一个自定义的场景事件处理函数，在里面判断不同的D调用不同的函数。


-------新的河洛客栈场景事件处理函数
--由于这是在旧的处理函数基础上增加了D*，因此才需要单独定制一个函数。
--如果是全新的处理函数，直接使用newCallEvent即可。
--flag 1 空格触发，2，物品触发，3，路过触发
function newSceneEvent_1(flag)
    if JY.CurrentD<=18 then     --对以前编号的D*，仍然调用旧的处理函数
        oldEventExecute(flag);
    else
        newCallEvent(flag);
	end
end


--新的通用事件处理函数
function newCallEvent(flag)

    JY.CurrentEventType=flag;

	local eventnum;
	if flag==1 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,2);
	elseif flag==2 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,3);
	elseif flag==3 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,4);
	end

    if eventnum>=0 then           --只有大于或等于0时才调用lua文件。
	--按照给定格式生成要调用的D*处理文件名。然后加载运行
		local eventfilename=string.format(CONFIG.NewEventPath .. "scene_%d_event_%d.lua",JY.SubScene,JY.CurrentD);
		dofile(eventfilename);
    end

    JY.CurrentEventType=-1;
end

------------------------------重定义一些做事件用的函数----------------
--[[
这里面是一些已定义过的函数
function GetTeamNum()            --得到队友个数
function WaitKey()       --等待键盘输入
function DrawBox(x1,y1,x2,y2,color)         --绘制一个带背景的白色方框
function DrawBox_1(x1,y1,x2,y2,color)       --绘制四角凹进的方框
function DrawString(x,y,str,color,size)         --显示阴影字符串
function DrawStrBox(x,y,str,color,size)         --显示带框的字符串
function DrawStrBoxYesNo(x,y,str,color,size)        --显示字符串并询问Y/N
function DrawStrBoxWaitKey(s,color,size)          --显示字符串并等待击键
function Rnd(i)           --随机数
function AddPersonAttrib(id,str,value)            --增加人物属性
function PlayMIDI(id)             --播放midi
function PlayWavAtk(id)             --播放音效atk***
function PlayWavE(id)              --播放音效e**
function ShowScreen(flag)              --刷新屏幕显示
function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --通用菜单函数
function ShowMenu2(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --通用菜单函数
function ChangeMMap(x,y,direct)          --改变大地图坐标
function ChangeSMap(sceneid,x,y,direct)       --改变当前场景
function Cls(x1,y1,x2,y2)                    --清除屏幕
function Talk(s,personid)            --最简单版本对话
function TalkEx(s,headid,flag)          --复杂版本对话

lib.GetTime
    返回开机到当前的毫秒数
	
lib.Delay(t)
    延时t毫秒
	
lib.GetS(id,x,y,level)
    读S*数据
    id 场景编号
    x,y 坐标
    level 层数
 
lib.SetS(id,x,y,level,v)
    写场景数据v

lib.GetD(Sceneid,id,i)
   读D*数据
   sceneid 场景编号
   id 该场景D编号
   i 第几个数据
  
lib.SetD(Sceneid,id,i,v)
   写D*数据v
]]--


--以下是对原指令的直接调用，其实就换了个容易记得名字
function GetItem(thingid,num)	--得到物品（物品编号，数量）
	instruct_2(thingid,num)  
end

function AskFight() 			--询问是否战斗
	return instruct_5() 
end

function AskJoin() 				--询问是否加入
	return instruct_9() 
end

function Join(personid)			--加入（人物编号）
	instruct_10(personid)
end

function AskRest() 				--询问是否住宿
	return instruct_11() 
end

function Rest()					--住宿恢复体力
	instruct_12()
end

function LightScence()			--场景变亮
	instruct_13()
end

function DarkScence()			--场景变暗
	instruct_14()
end

function GameOver()				
	instruct_15()
end

function InTeam(personid)		--某人是否在队伍（人物编号）
	return instruct_16(personid)
end

function HaveItem(thingid)		--是否有某物品（物品编号）
	return instruct_18(thingid)
end

function TeamIsFull()			--队伍是否满员
	return instruct_20()
end

function LeaveTeam(personid)	--离队（人物编号）
	instruct_21(personid)
end

function NoNeili()				--全员内力归零
	instruct_22()
end

function ScenceFromTo(x1,y1,x2,y2)		--场景移动，x1，y1可以为0，此时x2，y2为相对值(x2-x1)(y2-y1)
	instruct_25(x1,y1,x2,y2)
end

function PlayAnimation(id,startpic,endpic)	--播放动画
	instruct_27(id,startpic,endpic)
end

function WalkFromTo(x1,y1,x2,y2) 		--人物走动，x1，y1可以为0，此时x2，y2为相对值(x2-x1)(y2-y1)
	instruct_30(x1,y1,x2,y2) 
end

function AddItem(thingid,num)			--增加物品（物品编号，数量），数量为负时即减少物品
	instruct_32(thingid,num)
end

function LearnWugong(personid,wugongid,flag)	--学会武功（人物编号，武功编号，武功经验）
	instruct_33(personid,wugongid,flag) 
end

function SetWugong(personid,id,wugongid,wugonglevel)	--设置人物武功（人物编号，第几个武功，武功编号，武功经验）
	instruct_35(personid,id,wugongid,wugonglevel)
end

function OpenScence(sceneid)			--打开场景（场景编号）
	instruct_39(sceneid) 
end


--以下是我添加的几个函数
function GetBestMember(a,b,c)				--返回队伍中某项属性最高或最低的队友编号，a=1返回最高，a=0返回最低，b=1不包含主角=0包含，c,属性名
	local num=GetTeamNum()
	local d=b+1
	for i=b+2,num do
		if a==1 then 
			if JY.Person[JY.Base["队伍" ..i]][a]>JY.Person[JY.Base["队伍" ..d]][a] then d=i end;
		else
			if JY.Person[JY.Base["队伍" ..i]][a]<JY.Person[JY.Base["队伍" ..d]][a] then d=i end;
		end
	end

end





----------------------------------------------部分函数------------------------------------


function GetAtkKungfu(pid)							--返回人物攻击用的武功ID（在人物武功列表中的序号）
	--暂不完成，纯测试用
	return JY.Person[pid]["类型1"]
end

function KeepSafe(id)								--解决由于R数据不正确，造成的部分跳出
	return
	--[[
	for i=1,8 do
		if JY.Person[id]["类型"..i]>CC.Kungfunum or JY.Person[id]["类型"..i]<1 then JY.Person[id]["类型"..i]=0 end		--只考虑了超出的情况，不过一般而言，够了
	end
	]]--
end

--[[
function War_AutoSelectWugong()           --自动选择合适的武功
	--重载了自动选择武功的函数
	--功能很简陋，基本就是根据武器得出使用的武功，实际也就一种武功而已
	--以后期待根据多种情况选择不用的武器以及不同的武功
	--不过感觉这种选择也没什么意义
	local pid=WAR.Person[WAR.CurID]["人物编号"];
	return GetAtkKungfu(pid)
	
end
]]--



--计算当前位置能攻击到的敌人数目
function GetAtkNum(x,y,fanwei,atk)
	local point={}		--记录可以攻击的点
	local num=0			--记录点的个数
	local len=	0			--攻击距离
	local kind,len1,len2
	kind,len1,len2=fenjie(JY.Wugong[kfnum]["范围"..math.modf((lv+2)/3)])
	
	if kind <8 then len=kind
	elseif kind==8 then len=0
	elseif kind==9 or kind==10 then len=1 end
	
	--范围格式{a,b,c,d,e}
	--a,攻击范围类型 0菱形1十字2方块9四向10八向
	--b,攻击范围的距离
	--c,伤害范围
	--d,e伤害范围的距离参数
	local kind=fanwei[1]
	local len=fanwei[2]
	if kind==9 then 
		kind=1
		len=1
	elseif kind==10 then
		kind=2
		len=1
	end
	
	if kind==0 then
	for i=x-len,x+len do			--定点类的，取攻击范围
		for j=y-len,y+len do
			if math.abs(i-x)+math.abs(j-y)>len and kind~=9 then
				
			else
				num=num+1
				point[num]={i,j}
			end
		end
	end
	elseif kind==1 then
		--四向
		if len<1 then len=1 end
		num=len*4+1
		point[num]={x,y}
		for i=1,len do
			point[i*4-3]={x+i,y}
			point[i*4-2]={x-i,y}
			point[i*4-1]={x,y+i}
			point[i*4]={x,y-i}
		end	
	elseif kind==2 then
		--八向(方块)
		if len<1 then len=1 end
		for i=x-len,x+len do
			for j=y-len,y+len do
				num=num+1
				point[num]={i,j}
			end
		end
		num=num+1
		point[num]={x,y}
	end
	
	--从第一个点开始，分别获取该点攻击敌人的数目，并保存最大点的坐标，攻击数目
	local maxx,maxy,maxnum,atknum=0,0,0,0
	for i=1,num do
		atknum=GetWapMap(x,y,4)				--取第四层数据，若为-1,则调用函数计算
		if atknum==-1 or fanwei[1]~=0 then		--如果不是定点类，则必须重复计算
			atknum=WarDrawAtt(point[i][1],point[i][2],fanwei,2,x,y,atk)
			SetWarMap(x,y,4,atknum)
		end
		if atknum>maxnum then
			maxnum,maxx,maxy=atknum,point[i][1],point[i][2]
		end
	end
	SetWarMap(x,y,4,maxnum);
	return maxnum,maxx,maxy;
	
end


--绘制攻击范围|f返回该点的攻击敌人数目
--flag=1时绘制范围，flag=2时返回敌人数目
--初步考虑攻击范围如下
--采用三位，从高到低来，最高位表示武功攻击距离（），然后是该范围类型的两个参数，这个工作在调用本函数之前做，本函数只接受已处理好了的数据
----类型0：范围0x，点，x不使用
----类型0：范围1x，定点十字，x为十字大小，0依然为点，1为小十字，类推
----类型0：范围2x，定点斜十字，x为十字大小，0依然为点，1为梅花，类推
----类型0：范围3x，菱形，x为菱形大小，0依然为点，1为小十字，2就有菱形的样子了，类推
----类型0：范围4x，方块，x为方块大小，0依然为点，1为小方块，类推
----类型0：其他均为点
----类型1：范围ab，线攻击，同原版，b表示中间攻击长度
----类型1：范围ab，线攻击，b表示中间攻击长度，a表示两侧攻击长度（即该方向上，三条攻击）
----类型1：范围ab，线攻击，特别的，当a为9时，方向三角攻击
----程序中，类型一的攻击距离可用，但不再表示攻击长度，攻击长度用攻击范围表示。攻击距离的作用待定
----类型2：范围ab，八向攻击，a表示斜十字攻击长度，b表示正十字攻击长度
----程序中，类型二的攻击距离将被无视，只考虑攻击范围
----类型3：范围ab，原地
---------更新--------
--[[
采用三位，高位是攻击距离和类型复用
	0即原地攻击
	1-7定点攻击
	8原地八向攻击
	9方向攻击,八个方向
	10方向攻击，四个方向，三角形
	处理上，只需分别对0-7，8，9，10分别处理即可
]]--
function WarDrawAtt(x,y,fanwei,flag,cx,cy,atk)
	local x0,y0
	if cx==nil or cy==nil then
		x0=WAR.Person[WAR.CurID]["坐标X"];
		y0=WAR.Person[WAR.CurID]["坐标Y"];
	else
		x0,y0=cx,cy
	end
	local xy={}
	local num=0
	
	if kind>=0 and kind<8 then				--定点攻击
			if len1==0 or len2==0 then		--单点
				num=1
				xy[1]={x,y}
			elseif len1==1 then					--定点十字
				num=1+len2*4
				xy[1]={x,y}
				for i=1,len2 do
					xy[4*i-2]={x-i,y}
					xy[4*i-1]={x+i,y}
					xy[4*i]={x,y-i}
					xy[4*i+1]={x,y+i}
				end
			elseif len1==2 then					--定点斜十字
				num=1+len2*4
				xy[1]={x,y}
				for i=1,len2 do
					xy[4*i-2]={x-i,y-i}
					xy[4*i-1]={x+i,y+i}
					xy[4*i]={x+i,y-i}
					xy[4*i+1]={x-i,y+i}
				end			
			elseif len1==3 then					--定点菱形
				for tx=x-len2,x+len2 do			--这个方法感觉有点浪费，1/2的点都是不符合要求的
					for ty=y-len2,y+len2 do
						if math.abs(tx-x)+math.abs(ty-y)>len2 then
							
						else
							num=num+1
							xy[num]={tx,ty}
						end
					end
				end			
			elseif len1==4 then					--定点方块
				for tx=x-len2,x+len2 do
					for ty=y-len2,y+len2 do
						num=num+1
						xy[num]={tx,ty}
					end
				end					
			else
				num=1
				xy[1]={x,y}			
			end	
	elseif kind==8 then							--原地八向
			num=1+(len1+len2)*4
			xy[1]={x,y}			
			if len1~=0 then
				for i=1,len1 do
					xy[i*4-2]={x-i,y-i}
					xy[i*4-1]={x+i,y+i}
					xy[i*4]={x-i,y+i}
					xy[i*4+1]={x+i,y-i}
				end
			end
			if len2~=0 then
				for i=1,len2 do
					xy[i*4-2+4*len1]={x-i,y}
					xy[i*4-1+4*len1]={x+i,y}
					xy[i*4+4*len1]={x,y-i}
					xy[i*4+1+4*len1]={x,y+i}
				end			
			end
	elseif kind==9 then							--原地方向
			if x==x0 and y==y0 then return 0 end
			if len1<=0 and len2<=0 then return 0 end
			local fx,fy=x-x0,y-y0
			local linenum=1
				--首先绘制中间一条
			if len2~=0 then 
				for j=1,len2 do
					num=num+1
					xy[num]={x0+j*fx,y0+j*fy}
				end
			end
				--然后是两边
			if len2~=0 then 
				local xl,yl,xr,yr
				xl,yl=x0-fy,y0+fx
				xr,yr=x0+fy,y0-fx
				if fx~=0 and fy~=0 then
					xl,yl=x0,y0-fy
					xr,yr=x0-fx,y0
				end
				for j=1,len1 do
					num=num+1
					xy[num]={xl+j*fx,yl+j*fy}
					num=num+1
					xy[num]={xr+j*fx,yr+j*fy}
				end
			end
	elseif kind==10 then					--原地方向三角
			if len2<=0 then return 0 end
			local fx,fy=x-x0,y-y0
			if fx==0 and fy==0 then return 0 end
			for i=1,len2 do
				num=num+1
				xy[num]={x0+fx*i,y0+fy*i}
				for j=1,i -1 do
					num=num+1
					xy[num]={x0+fx*i+fy*j,y0+fy*i-fx*j}
					num=num+1
					xy[num]={x0+fx*i-fy*j,y0+fy*i+fx*j}
				end
			end
	
	
	else
		return	0
	end
		
		
		
	if flag==1 then									--绘制攻击范围

		local function thexy(nx,ny,x,y)
			local dx,dy=nx-x,ny-y
			return CC.ScreenW/2+CC.XScale*(dx-dy),CC.ScreenH/2+CC.YScale*(dx+dy)			
		end
		
		for i=1,num do
			local tx,ty=thexy(xy[i][1],xy[i][2],x0,y0)
			lib.PicLoadCache(0,0,tx,ty,2,128)		
		end
	elseif flag==2 then													--返回攻击数目
		local diwo=WAR.Person[WAR.CurID]["我方"]
		local atknum=0
		for i=1,num do
			local id=GetWarMap(xy[i][1],xy[i][2],2);
			if id>=0 then 
				if diwo~=WAR.Person[id]["我方"] then 
					if id==WAR.Person[WAR.CurID]["自动选择对手"] then
						atknum=atknum+20
					else
						local hp=JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["生命"]
						if hp<atk/2 then
							atknum=atknum+8
						elseif hp<atk then
							atknum=atknum+5
						else
							atknum=atknum+3
						end					
					end
				end;
			end
		end
		return atknum;
	elseif flag==3 then							--设置武功效果作用层，第四层
		CleanWarMap(4,0)
		for i=1,num do
			SetWarMap(xy[i][1],xy[i][2],4,1);
		end
	
	end
		
		
end


function War_FightSelectType(kind,len1,len2,x,y)		--
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    if x==nil and y==nil then
        x,y=War_SelectMove(kind,len1,len2);              --未指定攻击地点，选择攻击对象
		if x ==nil then
			lib.GetKey();
			Cls();
			return false;
		end
	else																	--自动战斗时，以指定攻击地点，针对斗转的情况对坐标修正
		if kind==0 then
			x,y=x0,y0
		elseif kind==8 then
			x,y=x0,y0
		elseif kind==9 then
		    local dx=math.abs(x-x0);
			local dy=math.abs(y-y0);
			local dxy=math.abs(dx-dy)
			if dx+dy~=1 then 			--坐标正确就不修正了
				if dxy==0 or dxy==1 then						--这里按理来说应该是 ==1，可为啥实际1反而有问题？嗯，其实就是针对斗转罢了，其他的都是正确的坐标,修好了
					if x>x0 then
						dx=1
					else
						dx=-1
					end
					if y>y0 then
						dy=1
					else
						dy=-1
					end			
				--lib.Debug(x0..','..y0..'|'..x..','..y..'|'..dx..','..dy)
				else 			
					if dy>dx then
						if y>y0 then
							dx,dy=0,1;
						else
							dx,dy=0,-1;
						end
					else
						if x>x0 then
							dx,dy=1,0;
						else
							dx,dy=-1,0;
						end
					end
				end
				x,y=x0+dx,y0+dy
			end
		elseif kind==10 then
			local dx=x-x0;
			local dy=y-y0;
			--if math.abs(dx+dy)~=1 then
				if math.abs(dy)>math.abs(dx) then
					if y>y0 then
						dx,dy=0,1;
					else
						dx,dy=0,-1;
					end
				else
					if x>x0 then
						dx,dy=1,0;
					else
						dx,dy=-1,0;
					end
				end
				x,y=x0+dx,y0+dy
			--end
		end
		--WarSetPerson()		
		WarDrawAtt(x,y,kind,len1,len2,1)								--显示攻击范围，斗转时显示不正确，应该是人物没有移动到场景中心-修复了
		ShowScreen();
		lib.Delay(500);
    end

    WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x,y) or WAR.Person[WAR.CurID]["人方向"]

	SetWarMap(x,y,4,1);

    WAR.EffectXY={};
	WarDrawAtt(x,y,kind,len1,len2,3)


end


function War_SelectMove(kind,len1,len2)              ---选择移动位置
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local x=x0;
    local y=y0;
	if kind~=nil then
		if kind<8 then
			War_CalMoveStep(WAR.CurID,kind,1);
		elseif kind==8 then
			War_CalMoveStep(WAR.CurID,0,1);
		elseif kind==9 then
			War_CalMoveStep(WAR.CurID,2,1);
			SetWarMap(x0+2,y0,3,255)
			SetWarMap(x0-2,y0,3,255)
			SetWarMap(x0,y0+2,3,255)
			SetWarMap(x0,y0-2,3,255)
		elseif kind==10 then
			War_CalMoveStep(WAR.CurID,1,1);
		end
	end
    while true do
        local x2=x;
        local y2=y;

        WarDrawMap(1,x,y);
		if kind~=nil then
			WarDrawAtt(x,y,kind,len1,len2,1)
		end
        ShowScreen();
        local key=WaitKey();
        if key==VK_UP then
            y2=y-1;
        elseif key==VK_DOWN then
            y2=y+1;
        elseif key==VK_LEFT then
            x2=x-1;
        elseif key==VK_RIGHT then
            x2=x+1;
        elseif key==VK_SPACE or key==VK_RETURN then
			if kind==nil or kind<9 or x~=x0 or y~=y0 then
				return x,y;
			end
        elseif key==VK_ESCAPE then
            return nil;
        end

		if GetWarMap(x2,y2,3)<128 then
            x=x2;
            y=y2;
        end
    end

end


function War_PersonLostLife()             --计算战斗后每回合由于中毒或受伤而掉血
	--改成处理中毒掉血
	--以及武功特殊效果回复状态
end


function MyDrawString(x1,x2,y,str,color,size) 
	local len=math.modf(string.len(str)*size/4)
	local x=math.modf((x1+x2)/2)-len
    DrawString(x,y,str,color,size);
end

function ShowPersonStatus(teamid)---显示队友状态
	local teamnum=GetTeamNum();

	while true do
	    Cls();
        local id=JY.Base["队伍" .. teamid];
        ShowPersonStatus_sub(id);

        ShowScreen();
	    local keypress=WaitKey();
        lib.Delay(100);
        if keypress==VK_ESCAPE then
            break;
        elseif keypress==VK_UP then
		    teamid=teamid-1;
        elseif keypress==VK_DOWN then
		    teamid=teamid+1;
        elseif keypress==VK_LEFT then
		    teamid=teamid-1;
        elseif keypress==VK_RIGHT then
		    teamid=teamid+1;
		elseif keypress==VK_RETURN then
			SetKungfu(id);	--装备武功界面
        end
		teamid=limitX(teamid,1,teamnum);
	end
end

function ShowPersonStatus_sub(id)    --显示人物状态页面
    local size=CC.DefaultFont;    --字体大小
    local p=JY.Person[id];
    local width=23*size+15;             --18个汉字字符宽
	local h=size+CC.PersonStateRowPixel;
	local height=13*h+10;                --12个汉字字符高
	local dx=(CC.ScreenW-width)/2;
	local dy=(CC.ScreenH-height)/2;

    local x1,y1,x2;

    DrawBox(dx,dy,dx+width,dy+height,C_WHITE);

    x1=dx+5;
	y1=dy+5;
	x2=4*size;
	local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
    local headx=(width/3-headw)/2;
	local heady=(h*5-headh)/2;


    lib.PicLoadCache(1,p["头像代号"]*2,x1+headx-10,y1+heady,1);

	y1=y1+130
    MyDrawString(x1,x1+100,y1,p["姓名"],C_WHITE,size);
    DrawString(x1+8*size/2,y1,string.format("%3d",p["等级"]+7),C_GOLD,size);
    DrawString(x1+11*size/2,y1,"级",C_ORANGE,size);
	
	y1=y1+30
	local hp=math.modf(p["生命"]*160/p["生命最大值"])
	local mp=math.modf(p["内力"]*160/p["内力最大值"])
	local tp=math.modf(p["体力"]*160/100)
	x1=x1+5
	lib.PicLoadCache(1,118*2,x1,y1,1);
	lib.PicLoadCache(1,118*2,x1,y1+30,1);
	lib.PicLoadCache(1,118*2,x1,y1+60,1);
	lib.SetClip(x1,y1,x1+hp,y1+24)
	lib.PicLoadCache(1,115*2,x1,y1,1);
	lib.SetClip(x1,y1+30,x1+mp,y1+54)
	lib.PicLoadCache(1,116*2,x1,y1+30,1);
	lib.SetClip(x1,y1+30,x1+tp,y1+84)
	lib.PicLoadCache(1,117*2,x1,y1+60,1);
	lib.SetClip(0,0,0,0)
	x1=x1-5
	local function DrawAttrib1(str,x,y)    --定义内部函数
		 local bf=math.modf(p[str]*1.60)
         lib.PicLoadCache(1,163*2,x,y,1);
		 lib.SetClip(x,y,x+bf,y+24)
         lib.PicLoadCache(1,164*2,x,y,1);
		 lib.SetClip(0,0,0,0)
		 DrawString(x+5,y+5,str,C_WHITE,18)
    end
	local function DrawAttrib2(str,x,y)    --定义内部函数☆★
		 local bf=math.modf((p[str]-10)/9)
		 local T={"☆","★","★☆","★★","★★☆","★★★","★★★☆","★★★★","★★★★☆","★★★★★"}
		 DrawString(x,y+2,str,C_WHITE,21)
		 local xxstr=""
		 if bf>0 and bf<11 then xxstr=T[bf] end
		 DrawString(x+45,y+2,xxstr,C_GOLD,21)
    end
	local  function DrawAttrib3(kfnum,kflv,x,y)
		local T={"一","二","三","四","五","六","七","八","九","十"}
		DrawString(x,y,JY.Wugong[kfnum]["名称"],C_WHITE,24)
		DrawString(x+136,y,T[kflv].."级",C_WHITE,24)
	end
    DrawString(x1+14,y1+5,"生命",C_WHITE,16);
    DrawString(x1+14,y1+35,"内力",C_WHITE,16);
    DrawString(x1+14,y1+65,"体力",C_WHITE,16);
	y1=y1+90
	x1=x1+7
	local thezb
	thezb=p["武器"] or -1
	DrawString(x1,y1,"武器"..":",C_WHITE,21)
	if thezb~=-1 then
	DrawString(x1+56,y1,JY.Thing[thezb]["名称"],C_ORANGE,21)
	else DrawString(x1+56,y1,"无",C_ORANGE,21)
	end
	y1=y1+28
	thezb=p["防具"] or -1
	DrawString(x1,y1,"防具"..":",C_WHITE,21)
	if thezb~=-1 then
	DrawString(x1+56,y1,JY.Thing[thezb]["名称"],C_ORANGE,21)
	else DrawString(x1+56,y1,"无",C_ORANGE,21)
	end
	y1=y1+28
	thezb=p["修炼物品"] or -1
	DrawString(x1,y1,"修炼物品"..":",C_WHITE,21)
	if thezb~=-1 then
	y1=y1+26
	local skexp=math.modf(p["修炼点数"]*160/TrainNeedExp(id))
	--lib.Debug(skexp..'.'..p["修炼点数"]..','..TrainNeedExp(id))
    lib.PicLoadCache(1,163*2,x1,y1,1);
	lib.SetClip(x1,y1,x1+skexp,y1+21)
    lib.PicLoadCache(1,164*2,x1,y1,1);
	lib.SetClip(0,0,0,0)
	MyDrawString(x1,x1+160,y1,JY.Thing[thezb]["名称"],C_ORANGE,21)
	else DrawString(x1+108,y1,"无",C_ORANGE,21)
	end
	y1=y1+28
--lib.Debug("11")
	--[[
    local color;              --显示生命和最大值，根据受伤和中毒显示不同颜色
    if p["受伤程度"]<33 then
        color =RGB(236,200,40);
    elseif p["受伤程度"]<66 then
        color=RGB(244,128,32);
    else
        color=RGB(232,32,44);
    end
	]]--
	x1=x1+180
	y1=dy+16
	DrawAttrib1("力道",x1,y1)
	DrawAttrib1("机敏",x1,y1+28)
	DrawAttrib1("精纯",x1,y1+56)
	DrawAttrib1("根骨",x1,y1+84)
	y1=y1+108
	x1=x1+3
	DrawAttrib2("拳掌",x1,y1)
	DrawAttrib2("御剑",x1,y1+24)
	DrawAttrib2("耍刀",x1,y1+48)
	DrawAttrib2("使棍",x1,y1+72)
	DrawAttrib2("暗器",x1,y1+96)
	y1=y1+120
	DrawAttrib2("医疗",x1,y1)
	DrawAttrib2("用毒",x1,y1+24)
	DrawAttrib2("解毒",x1,y1+48)
	DrawAttrib2("抗毒",x1,y1+72)
	DrawAttrib2("资质",x1,y1+96)
	
--lib.Debug("12")
	x1=x1+177
	y1=dy+16;
	DrawString(x1,y1,"外功",C_ORANGE,24)
	DrawString(x1,y1+200,"内功",C_ORANGE,24)
	DrawString(x1,y1+250,"轻功",C_ORANGE,24)
	DrawString(x1,y1+300,"特技",C_ORANGE,24)
	y1=y1+25
	local nei,qing,te=p["内功"],p["轻功"],p["特技"]
	for i=1,CC.Kungfunum do
		if p["武功"][i]~=nil then
		local kfnum=p["武功"][i][1]
		local kflv=div100(p["武功"][i][2] or 0)+1
		local kfkind=JY.Wugong[kfnum]["武功类型"]
			if kfkind<6 and kfnum~=0 then
				DrawAttrib3(kfnum,kflv,x1,y1)
				y1=y1+25
			elseif i==nei then
				DrawAttrib3(kfnum,kflv,x1,293)		
			elseif i==qing then
				DrawAttrib3(kfnum,kflv,x1,343)		
			elseif i==te then
				DrawAttrib3(kfnum,kflv,x1,393)		
			end
		end
	end
	
	
end


function WarDrawMap(flag,v1,v2,v3)
    local x=WAR.Person[WAR.CurID]["坐标X"];
    local y=WAR.Person[WAR.CurID]["坐标Y"];
    if flag==0 then
	    lib.DrawWarMap(0,x,y,0,0,-1);
    elseif flag==1 then
		if WAR.Data["地图"]==0 then     --雪地地图用黑色菱形
		    lib.DrawWarMap(1,x,y,v1,v2,-1);		
		else
		    lib.DrawWarMap(2,x,y,v1,v2,-1);			
		end
	elseif flag==2 then
	    lib.DrawWarMap(3,x,y,0,0,-1);
	elseif flag==4 then
		if v3>2972 then
			local function thexy(nx,ny,ox,oy)
				local dx,dy=nx-ox,ny-oy
				return CC.ScreenW/2+CC.XScale*(dx-dy),CC.ScreenH/2+CC.YScale*(dx+dy)	
			end
			lib.DrawWarMap(4,x,y,v1,v2,-1);
			for i=0,63 do
				for j=0,63 do
					if GetWarMap(i,j,4)>0 then
						local xx,xy=thexy(i,j,x,y)
						xy=fyxy(xy,v3)
						lib.PicLoadCache(3,v3,xx,xy,0,0)
					end
				end
			end		
		else
			lib.DrawWarMap(4,x,y,v1,v2,v3);
		end
	end
	if WAR.ShowHead==1 then
        WarShowHead();
	end
end


function fyxy(y,num)
--反回eft里png图片的y偏移，返回值是修改后的
	if num>3218 then return y-75
	elseif num>3192 then return y-45
	elseif num>3166 then return y-45
	elseif num>3158 then return y-45
	elseif num>3130 then return y-45
	elseif num>3068 then return y-60
	elseif num>3042 then return y-70
	elseif num>3030 then return y-35
	elseif num>2972 then return y-45
	end
end

--重写移动函数，主要是加入zoc，即当附近有敌人时，移动力额外减1
function War_CalMoveStep(id,stepmax,flag)
	
  	CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，

    local x=WAR.Person[id]["坐标X"];
    local y=WAR.Person[id]["坐标Y"];

	local steparray={};     --用数组保存第n步的坐标。
	for i=0,stepmax do
	    steparray[i]={};
		steparray[i].bushu={};
        steparray[i].x={};
        steparray[i].y={};
	end

	SetWarMap(x,y,3,0);
    steparray[0].num=1;
	steparray[0].bushu[1]=stepmax;					--还能移动的步数
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	War_FindNextStep(steparray,0,id,flag);

	return steparray;

end

--被上面的函数调用
function War_FindNextStep(steparray,step,id,flag)      --设置下一步可移动的坐标
    local num=0;
	local step1=step+1;
	
	local function fujinnum(tx,ty)
		local tnum=0
		local wofang=WAR.Person[id]["我方"]
		local tv;
		tv=GetWarMap(tx+1,ty,2);
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx-1,ty,2);
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty+1,2);
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty-1,2);
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		return tnum
	end
	
	
	
	for i=1,steparray[step].num do
		if steparray[step].bushu[i]>0 then
		steparray[step].bushu[i]=steparray[step].bushu[i]-1;
	    local x=steparray[step].x[i];
	    local y=steparray[step].y[i];
	    if x+1<CC.WarWidth-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x+1,y,3);
			if v ==255 and War_CanMoveXY(x+1,y,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
				SetWarMap(x+1,y,3,step1);
				steparray[step1].bushu[num]=steparray[step].bushu[i]-fujinnum(x+1,y);
			end
		end

	    if x-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x-1,y,3);
			if v ==255 and War_CanMoveXY(x-1,y,flag)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
				SetWarMap(x-1,y,3,step1);
				steparray[step1].bushu[num]=steparray[step].bushu[i]-fujinnum(x-1,y);
			end
		end

	    if y+1<CC.WarHeight-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x,y+1,3);
			if v ==255 and War_CanMoveXY(x,y+1,flag)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
				SetWarMap(x,y+1,3,step1);
				steparray[step1].bushu[num]=steparray[step].bushu[i]-fujinnum(x,y+1);
			end
		end

	    if y-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x ,y-1,3);
			if v ==255 and War_CanMoveXY(x,y-1,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
				SetWarMap(x ,y-1,3,step1);
				steparray[step1].bushu[num]=steparray[step].bushu[i]-fujinnum(x,y-1);
			end
		end
		end
	end
	if num==0 then return end;
    steparray[step1].num=num;
	--尝试加入一个排序，把步数低的放后面
	--不过如果反过来的话，zoc的效果就很极其明显了...
	for i=1,num-1 do
		for j=i+1,num do
			if steparray[step1].bushu[i]<steparray[step1].bushu[j] then
				steparray[step1].bushu[i],steparray[step1].bushu[j]=steparray[step1].bushu[j],steparray[step1].bushu[i]
				steparray[step1].x[i],steparray[step1].x[j]=steparray[step1].x[j],steparray[step1].x[i]
				steparray[step1].y[i],steparray[step1].y[j]=steparray[step1].y[j],steparray[step1].y[i]
			end
		end
	end
	
	
	War_FindNextStep(steparray,step1,id,flag)

end


--重写AI

--AI中的自动攻击
	--需要人物的移动步数,武功的攻击范围,
	--考虑武功范围的格式 {a,b,c,d,e,...},主要是a,决定是定点(0)还是方向(1,2)
	--考虑仇人,考虑能一次攻击杀死的人
	--一般敌人:1--能杀死的:5--仇人:50

function unnamed(kungfuid,kungfulv)
	local pid=WAR.Person[WAR.CurID]["人物编号"]
	local kungfuatk=GetAtk(pid,kungfuid,kungfulv)										--武功攻击力
	local fanwei=JY.Wugong[kungfuid]["范围"][math.modf(kungfulv/3)+1]		--实际武功范围
	local atkarray={}
	local num=0
	
 	CleanWarMap(4,-1);    --用level 4地图表示该位置可以攻击的数目
									-- -1表示此点还没计算
	local movearray=War_CalMoveStep(pid,WAR.Person[WAR.CurID]["移动步数"],0)		--移动表
	for i=0,WAR.Person[WAR.CurID]["移动步数"] do
		local step_num=movearray[i].num ;
		if step_num==nil or step_num==0 then
			break;
		end
		
		for j=1,step_num do
			local xx=movearray[i].x[j]
			local yy=movearray[i].y[j]
			num=num+1
			atkarray[num]={}
			atkarray[num].x,atkarray[num].y=xx,yy
			atkarray[num].p,atkarray[num].ax,atkarray[num].ay=GetAtkNum(xx,yy,fanwei,kungfuatk)
		end
		
	end
	
	--去掉得点过低的
	for i=1,num-1 do
		for j=i+1,num do
			if atkarray[i].p<atkarray[j].p then
				atkarray[i],atkarray[j]=atkarray[j],atkarray[i]
			end
		end
	end
	for i=1,num do
		if atkarray[i].p<atkarray[1].p/2 then
			num=i-1
			break;
		end
	end
	--接着针对移动目的地，考虑好坏
	--考虑前后左右,如果是我方则-2,如果是死路-2,如果是敌人:
	--进一步考虑,考虑气,如果为1,则-10,如果为2,则-5
	--考虑附近敌人,如果敌人气为1,则+10,若为2,则+5
	local wofang=WAR.Person[WAR.CurID]["我方"]
	local function getqi(nx,ny)
		local qi=4
		local nv
		
		nv=GetWarMap(nx+1,ny,2)
		if nv~=-1 and nv~=WAR.CurID then
			qi=qi-1
		elseif not War_CanMoveXY(nx+1,ny,0) then
			qi=qi-1
		end
		
		nv=GetWarMap(nx-1,ny,2)
		if nv~=-1 and nv~=WAR.CurID then
			qi=qi-1
		elseif not War_CanMoveXY(nx-1,ny,0) then
			qi=qi-1
		end
		
		nv=GetWarMap(nx,ny+1,2)
		if nv~=-1 and nv~=WAR.CurID then
			qi=qi-1
		elseif not War_CanMoveXY(nx,ny+1,0) then
			qi=qi-1
		end
		
		nv=GetWarMap(nx,ny-1,2)
		if nv~=-1 and nv~=WAR.CurID then
			qi=qi-1
		elseif not War_CanMoveXY(nx,ny-1,0) then
			qi=qi-1
		end
		return qi
	end
	for i=1,num do
		local v
		local theqi=getqi(atkarray[i].x,atkarray[i].y)
		if theqi==1 then 
			atkarray[i].p=atkarray[i].p-5
		elseif theqi==2 then
			atkarray[i].p=atkarray[i].p-2
		end
		v=GetWarMap(atkarray[i].x-1,atkarray[i].y,2);
		if v~=-1 and v~=WAR.CurID then
			if WAR.Person[v]["我方"]~=wofang then
				theqi=getqi(atkarray[i].x-1,atkarray[i].y)
				if theqi==1 then 
					atkarray[i].p=atkarray[i].p+10 
				elseif theqi==2 then
					atkarray[i].p=atkarray[i].p+5
				end
			else
				atkarray[i].p=atkarray[i].p-2
			end			
		elseif not War_CanMoveXY(atkarray[i].x-1,atkarray[i].y) then
			atkarray[i].p=atkarray[i].p-2			
		end
		
		v=GetWarMap(atkarray[i].x+1,atkarray[i].y,2);
		if v~=-1 and v~=WAR.CurID then
			if WAR.Person[v]["我方"]~=wofang then
				theqi=getqi(atkarray[i].x+1,atkarray[i].y)
				if theqi==1 then 
					atkarray[i].p=atkarray[i].p+10 
				elseif theqi==2 then
					atkarray[i].p=atkarray[i].p+5
				end
			else
				atkarray[i].p=atkarray[i].p-2
			end			
		elseif not War_CanMoveXY(atkarray[i].x+1,atkarray[i].y) then
			atkarray[i].p=atkarray[i].p-2			
		end
		
		v=GetWarMap(atkarray[i].x,atkarray[i].y-1,2);
		if v~=-1 and v~=WAR.CurID then
			if WAR.Person[v]["我方"]~=wofang then
				theqi=getqi(atkarray[i].x,atkarray[i].y-1)
				if theqi==1 then 
					atkarray[i].p=atkarray[i].p+10 
				elseif theqi==2 then
					atkarray[i].p=atkarray[i].p+5
				end
			else
				atkarray[i].p=atkarray[i].p-2
			end			
		elseif not War_CanMoveXY(atkarray[i].x,atkarray[i].y-1) then
			atkarray[i].p=atkarray[i].p-2			
		end
		
		v=GetWarMap(atkarray[i].x,atkarray[i].y+1,2);
		if v~=-1 and v~=WAR.CurID then
			if WAR.Person[v]["我方"]~=wofang then
				theqi=getqi(atkarray[i].x,atkarray[i].y+1)
				if theqi==1 then 
					atkarray[i].p=atkarray[i].p+10 
				elseif theqi==2 then
					atkarray[i].p=atkarray[i].p+5
				end
			else
				atkarray[i].p=atkarray[i].p-2
			end			
		elseif not War_CanMoveXY(atkarray[i].x,atkarray[i].y+1) then
			atkarray[i].p=atkarray[i].p-2			
		end
		
		if atkarray[i].p<1 then atkarray[i].p=1 end
		
	end

	for i=1,1 do
		for j=i+1,num do
			if atkarray[i].p<atkarray[j].p then
				atkarray[i],atkarray[j]=atkarray[j],atkarray[i]
			end
		end
	end
	
	return 

end


--返回两人之间的实际距离
function War_realjl(ida,idb)
	if ida==nil then
		ida=WAR.CurID
	end
	
  	CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，

    local x=WAR.Person[ida]["坐标X"];
    local y=WAR.Person[ida]["坐标Y"];

	local steparray={};     --用数组保存第n步的坐标。
	--[[for i=0,128 do
	    steparray[i]={};
		steparray[i].bushu={};
        steparray[i].x={};
        steparray[i].y={};
	end--]]
	    steparray[0]={};
		steparray[0].bushu={};
        steparray[0].x={};
        steparray[0].y={};

	SetWarMap(x,y,3,0);
    steparray[0].num=1;
	steparray[0].bushu[1]=0;					--还能移动的步数
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	return War_FindNextStep1(steparray,0,ida,idb);
	--return steparray;

end

--被上面的函数调用
function War_FindNextStep1(steparray,step,id,idb)      --设置下一步可移动的坐标
    local num=0;
	local step1=step+1;
	
	    steparray[step1]={};
		steparray[step1].bushu={};
        steparray[step1].x={};
        steparray[step1].y={};
	
	local function fujinnum(tx,ty)
		local tnum=0
		local wofang=WAR.Person[id]["我方"]
		local tv;
		tv=GetWarMap(tx+1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx-1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty+1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty-1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		return tnum
	end
	
	
	
	for i=1,steparray[step].num do
		--if steparray[step].bushu[i]<128 then
		steparray[step].bushu[i]=steparray[step].bushu[i]+1;
	    local x=steparray[step].x[i];
	    local y=steparray[step].y[i];
	    if x+1<CC.WarWidth-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x+1,y,3);
			if v ==255 and War_CanMoveXY(x+1,y,0)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
				SetWarMap(x+1,y,3,step1);
				local mnum=fujinnum(x+1,y);
				if mnum==-1 then 
					return steparray[step].bushu[i],x+1,y
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if x-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x-1,y,3);
			if v ==255 and War_CanMoveXY(x-1,y,0)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
				SetWarMap(x-1,y,3,step1);
				local mnum=fujinnum(x-1,y);
				if mnum==-1 then 
					return steparray[step].bushu[i],x-1,y
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if y+1<CC.WarHeight-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x,y+1,3);
			if v ==255 and War_CanMoveXY(x,y+1,0)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
				SetWarMap(x,y+1,3,step1);
				local mnum=fujinnum(x,y+1);
				if mnum==-1 then 
					return steparray[step].bushu[i],x,y+1
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if y-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x ,y-1,3);
			if v ==255 and War_CanMoveXY(x,y-1,0)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
				SetWarMap(x ,y-1,3,step1);
				local mnum=fujinnum(x,y-1);
				if mnum==-1 then 
					return steparray[step].bushu[i],x,y-1
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end
		--end
	end
	if num==0 then return -1 end;
    steparray[step1].num=num;
	for i=1,num-1 do
		for j=i+1,num do
			if steparray[step1].bushu[i]>steparray[step1].bushu[j] then
				steparray[step1].bushu[i],steparray[step1].bushu[j]=steparray[step1].bushu[j],steparray[step1].bushu[i]
				steparray[step1].x[i],steparray[step1].x[j]=steparray[step1].x[j],steparray[step1].x[i]
				steparray[step1].y[i],steparray[step1].y[j]=steparray[step1].y[j],steparray[step1].y[i]
			end
		end
	end
	
	
	return War_FindNextStep1(steparray,step1,id,idb)

end



function War_GetCanFightEnemyXY()
	local num,x,y
	num,x,y=War_realjl(WAR.CurID)
	--lib.Debug(num..'|'..x..','..y)
	if num==-1 then 
		return --WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"]
	else
		return x,y
	end
end
