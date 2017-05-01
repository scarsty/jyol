--------------------------------------------------------------------------------
--------------------------------------事件调用-----------------------------------

--事件调用主入口
--id，d*中的编号
--flag 1 空格触发，2，物品触发，3，路过触发
function EventExecute(id,flag)               --事件调用主入口
    JY.CurrentD=id;
    if JY.SceneNewEventFunction[JY.SubScene]==nil then         --没有定义新的事件处理函数，调用旧的
        oldEventExecute(flag)
	else
        JY.SceneNewEventFunction[JY.SubScene](flag)         --调用新的事件处理函数
    end
    JY.CurrentD=-1;
	JY.Darkness=0;
end

--调用原有的指定位置的函数
--旧的函数名字格式为  oldevent_xxx();  xxx为事件编号
function oldEventExecute(flag)            --调用原有的指定位置的函数

	local eventnum;
	if flag==1 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,2);
	elseif flag==2 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,3);
	elseif flag==3 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,4);
	end

	if eventnum>0 then
	    oldCallEvent(eventnum);
	end

end

function oldCallEvent(eventnum)     --执行旧的事件函数
	local eventfilename=string.format("oldevent_%d.lua",eventnum);
	lib.Debug(eventfilename);
	dofile(CONFIG.OldEventPath .. eventfilename);
end


--改变大地图坐标，从场景出去后移动到相应坐标
function ChangeMMap(x,y,direct)          --改变大地图坐标
	JY.Base["人X"]=x;
	JY.Base["人Y"]=y;
	JY.Base["人方向"]=direct;
end

--改变当前场景
function ChangeSMap(sceneid,x,y,direct)       --改变当前场景
    JY.SubScene=sceneid;
	JY.Base["人X1"]=x;
	JY.Base["人Y1"]=y;
	JY.Base["人方向"]=direct;
end




--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n)              --产生对话显示需要的字符串
    local tmpstr="";
	local num=0;
    for s in string.gmatch(str .. "*","(.-)%*") do           --去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while #tmpstr>0 do
		num=num+1;
		local w=0;
		while w<#tmpstr do
		    local v=string.byte(tmpstr,w+1);          --当前字符的值
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then     --为了避免跨段中文字符
			    break;
			end
		end

        if w<#tmpstr then
		    if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
				newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
				tmpstr=string.sub(tmpstr,w+2,-1);
			else
				newstr=newstr .. string.sub(tmpstr,1,w)  .. "*";
				tmpstr=string.sub(tmpstr,w+1,-1);
			end
		else
		    newstr=newstr .. tmpstr;
			break;
		end
	end
    return newstr,num;
end

--最简单版本对话
function Talk(s,personid)            --最简单版本对话
    local flag;
    if personid==0 then
        flag=1;
	else
	    flag=0;
	end
	TalkEx(s,JY.Person[personid]["头像代号"],flag);
end


--复杂版本对话
--s 字符串，必须加上*作为分行，如果里面没有*,则会自动加上
function TalkEx(s,headid,flag)          --复杂版本对话
    local picw=100;       --最大头像图片宽高
	local pich=100;
	local talkxnum=12;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2;
	local dy=2;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=12*CC.Fontbig+10;
	local boxtalkh=boxpich;

    local talkBorder=(pich-talkynum*CC.Fontbig)/(talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw+2,talky=dy,
				   showhead=0},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy,showhead=1},
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich,showhead=1}, }

    if flag<0 or flag>5 then
        flag=0;
    end

    if xy[flag].showhead==0 then
        headid=-1;
    end

	if string.find(s,"*") ==nil then
	    s=GenTalkString(s,12);
	end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();

    local startp=1
    local endp;
    local dy=0;
    while true do
        if dy==0 then
		    Cls();
            if headid>=0 then
                DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich,C_WHITE);
				local w,h=lib.PicGetXY(1,headid*2);
                local x=(picw-w)/2;
				local y=(pich-h)/2;
				lib.PicLoadCache(1,headid*2,xy[flag].headx+5+x,xy[flag].heady+5+y,1);
            end
            DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx +boxtalkw, xy[flag].talky + boxtalkh,C_WHITE);
        end
        endp=string.find(s,"*",startp);
        if endp==nil then
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.Fontbig+talkBorder),string.sub(s,startp),C_WHITE,CC.Fontbig);
            ShowScreen();
            WaitKey();
            break;
        else
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.Fontbig+talkBorder),string.sub(s,startp,endp-1),C_WHITE,CC.Fontbig);
        end
        dy=dy+1;
        startp=endp+1;
        if dy>=talkynum then
            ShowScreen();
            WaitKey();
            dy=0;
        end
    end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

	Cls();
end

--测试指令，占位置用
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--清屏
function instruct_0()         --清屏
    Cls();
end

--对话
--talkid: 为数字，则为对话编号；为字符串，则为对话本身。
--headid: 头像id
--flag :对话框位置：0 屏幕上方显示, 左边头像，右边对话
--            1 屏幕下方显示, 左边对话，右边头像
--            2 屏幕上方显示, 左边空，右边对话
--            3 屏幕下方显示, 左边对话，右边空
--            4 屏幕上方显示, 左边对话，右边头像
--            5 屏幕下方显示, 左边头像，右边对话

function instruct_1(talkid,headid,flag)        --对话
    local s=ReadTalk(talkid);
	if s==nil then        --对话id不存在
	    return ;
	end
    TalkEx(s,headid,flag);
end

function GetItem(tid,num)
	instruct_2(tid,num);
end
--得到物品
function instruct_2(thingid,num)            --得到物品
    if JY.Thing[thingid]==nil then   --无此物品id
        return ;
	end

    instruct_32(thingid,num);    --增加物品
    DrawStrBoxWaitKey(string.format("得到物品:%s %d",JY.Thing[thingid]["名称"],num),C_ORANGE,CC.Fontbig);
    --instruct_2_sub();         --是否可得武林帖
end

--声望>200以及14天书后得到武林帖
function instruct_2_sub()               --声望>200以及14天书后得到武林帖

    if JY.Person[0]["声望"] < 200 then
        return ;
    end

    if instruct_18(189) ==true then            --有武林帖， 189 武林帖id
        return;
    end

    local booknum=0;
    for i=1,CC.BookNum do
        if instruct_18(CC.BookStart+i-1)==true then
            booknum=booknum+1;
        end
    end

    if booknum==CC.BookNum then        --设置主角居桌子上的武林帖事件
        instruct_3(70,11,-1,1,932,-1,-1,7968,7968,7968,-2,-2,-2);
    end
end

--修改D*
-- sceneid 场景id, -2表示当前场景
-- id  D*的id， -2表示当前id
-- v0 - v10 D*参数， -2表示此参数不变
function ModifyD(sceneid,id,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)
	instruct_3(sceneid,id,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)
end
function instruct_3(sceneid,id,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)     --修改D*
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    if id==-2 then
        id=JY.CurrentD;
    end

    if v0~=-2 then
        SetD(sceneid,id,0,v0)
    end
    if v1~=-2 then
        SetD(sceneid,id,1,v1)
    end
    if v2~=-2 then
        SetD(sceneid,id,2,v2)
    end
    if v3~=-2 then
        SetD(sceneid,id,3,v3)
    end
    if v4~=-2 then
        SetD(sceneid,id,4,v4)
    end
    if v5~=-2 then
        SetD(sceneid,id,5,v5)
    end
    if v6~=-2 then
        SetD(sceneid,id,6,v6)
    end
    if v7~=-2 then
        SetD(sceneid,id,7,v7)
    end
    if v8~=-2 then
        SetD(sceneid,id,8,v8)
    end

    if v9~=-2 and v10 ~=-2 then
	    if v9>=0 and v10 >=0 then   --为了和苍龙兼容，修改的坐标不能为0
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,-1);   --如果xy坐标移动了，那么S中相应数据要修改。
            SetD(sceneid,id,9,v9)
            SetD(sceneid,id,10,v10)
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,id);
		end
	end
end

--是否使用物品触发
function instruct_4(thingid)         --是否使用物品触发
    if JY.CurrentThing==thingid then
        return true;
    else
        return false;
    end
end


function instruct_5()         --选择战斗
    return DrawStrBoxYesNo(-1,-1,"是否与之过招(Y/N)?",C_ORANGE,CC.Fontbig);
end


function instruct_6(warid,tmp,tmp,flag)      --战斗
    return WarMain(warid,flag);
end


function instruct_7()                 --已经翻译为return了
    instruct_test("指令7测试")
end


function instruct_8(musicid)            --改变主地图音乐
    JY.MmapMusic=musicid;
end


function instruct_9()                --是否要求加入队伍
    Cls();
    return DrawStrBoxYesNo(-1,-1,"是否要求加入(Y/N)?",C_ORANGE,CC.Fontbig);
end

function addteam(pid)
    if JY.Person[pid]==nil then
        lib.Debug("instruct_10 error: person id not exist");
		return ;
    end
    local add=0;
    for i =2, CC.TeamNum do             --第一个位置是主角，从第二个开始
        if JY.Base["队伍"..i]<0 then
            JY.Base["队伍"..i]=pid;
            add=1;
			JY.Person[pid]["所在"]=0;
            break;
        end
    end
    if add==0 then
        say("你的队伍已满，我无法加入。",JY.Da);
        return ;
    end
end
function instruct_10(personid)            --加入队员
    if JY.Person[personid]==nil then
        lib.Debug("instruct_10 error: person id not exist");
		return ;
    end
    local add=0;
    for i =2, CC.TeamNum do             --第一个位置是主角，从第二个开始
        if JY.Base["队伍"..i]<0 then
            JY.Base["队伍"..i]=personid;
            add=1;
            break;
        end
    end
    if add==0 then
        lib.Debug("instruct_10 error: 加入队伍已满");
        return ;
    end

    for i =1,4 do                --个人物品归公
        local id =JY.Person[personid]["携带物品" .. i];
        local n=JY.Person[personid]["携带物品数量" .. i];
        if id>=0 and n>0 then
            instruct_2(id,n);
            JY.Person[personid]["携带物品" .. i]=-1;
            JY.Person[personid]["携带物品数量" .. i]=0;
        end
    end
end


function instruct_11()              --是否住宿
    Cls();
    return DrawStrBoxYesNo(-1,-1,"是否住宿(Y/N)?",C_ORANGE,CC.Fontbig);
end


function instruct_12()             --住宿，回复体力
    for i=1,CC.TeamNum do
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            if JY.Person[id]["受伤程度"]<33 and JY.Person[id]["中毒程度"]<=0 then
                JY.Person[id]["受伤程度"]=0;
                AddPersonAttrib(id,"体力",math.huge);     --给一个很大的值，自动限制为最大值
                AddPersonAttrib(id,"生命",math.huge);
                AddPersonAttrib(id,"内力",math.huge);
            end
        end
    end
end

function rest_old()             --住宿，回复体力
	Dark();
    for i=1,CC.TeamNum do
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            if JY.Person[id]["内伤"]<=0 and JY.Person[id]["中毒"]<=0 and JY.Person[id]["流血"]<=0 then
                AddPersonAttrib(id,"体力",math.huge);     --给一个很大的值，自动限制为最大值
                AddPersonAttrib(id,"生命",math.huge);
                AddPersonAttrib(id,"内力",math.huge);
            end
        end
    end
	lib.Delay(1000);
	WaitKey();
	Light();
end

function rest()
	lib.GetKey();
	local size=CC.Fontbig;
	local color=C_WHITE;
    local ll=12;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
    local x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
    local y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;

    DrawStrBox(x,y,"是否要休息？",color,size);
    local menu=	{
							{"休息一天",nil,1},
							{"休息三天",nil,1},
							{"恢复体力",nil,0},
							{"恢复全部",nil,0},
							{"不要休息",nil,2},
						};
	if JY.Person[0]["内伤"]<=0 and JY.Person[0]["中毒"]<=0 and JY.Person[0]["流血"]<=0 then
		menu[3][3]=1;
		menu[4][3]=1;
	end
	local r=ShowMenu(menu,5,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,CC.Fontbig,C_ORANGE, C_WHITE)
	Cls();
    if r==1 then
		Dark();
		lib.Delay(500);
		--WaitKey();
	    if DayPass(1,8) then
			for i=1,CC.TeamNum do
				local id=JY.Base["队伍" .. i];
				if id>=0 then
					if JY.Person[id]["内伤"]<=0 and JY.Person[id]["中毒"]<=0 and JY.Person[id]["流血"]<=0 then
						AddPersonAttrib(id,"生命",180+Rnd(20));
						AddPersonAttrib(id,"内力",160+Rnd(40));
						if id>0 then
							AddPersonAttrib(id,"体力",8);
						end
					end
				end
			end
			Light();
		end
	elseif r==2 then
		Dark();
		lib.Delay(500);
		--WaitKey();
	    if DayPass(3,8) then
			for i=1,CC.TeamNum do
				local id=JY.Base["队伍" .. i];
				if id>=0 then
					if JY.Person[id]["内伤"]<=0 and JY.Person[id]["中毒"]<=0 and JY.Person[id]["流血"]<=0 then
						AddPersonAttrib(id,"生命",3*180+Rnd(20));
						AddPersonAttrib(id,"内力",3*160+Rnd(40));
						if id>0 then
							AddPersonAttrib(id,"体力",3*8);
						end
					end
				end
			end
			Light();
		end
	elseif r==3 then
		local n=math.modf((107-JY.Person[0]["体力"])/8);
		if n<1 then
			return false;
		end
		Dark();
		lib.Delay(500);
		--WaitKey();
		if DayPass(n,8) then
			for i=1,CC.TeamNum do
				local id=JY.Base["队伍" .. i];
				if id>=0 then
					if JY.Person[id]["内伤"]<=0 and JY.Person[id]["中毒"]<=0 and JY.Person[id]["流血"]<=0 then
						AddPersonAttrib(id,"生命",n*180+Rnd(20));
						AddPersonAttrib(id,"内力",n*160+Rnd(40));
						if id>0 then
							AddPersonAttrib(id,"体力",n*8);
						end
					end
				end
			end
			Light();
		end
	elseif r==4 then
		Dark();
		lib.Delay(500);
		while JY.Person[0]["体力"]<100 or JY.Person[0]["生命"]<JY.Person[0]["生命最大值"] or JY.Person[0]["内力"]<JY.Person[0]["内力最大值"] do
			if DayPass(1,8) then
				for i=1,CC.TeamNum do
					local id=JY.Base["队伍" .. i];
					if id>=0 then
						if JY.Person[id]["内伤"]<=0 and JY.Person[id]["中毒"]<=0 and JY.Person[id]["流血"]<=0 then
							AddPersonAttrib(id,"生命",180+Rnd(5));
							AddPersonAttrib(id,"内力",160+Rnd(10));
							if id>0 then
								AddPersonAttrib(id,"体力",8);
							end
						end
					end
				end
			end
		end
		Light();
	elseif r==5 then
	    return false;
	end
	return true;
end

function Light()            --场景变亮
    Cls();
	if JY.Darkness==1 then
		lib.ShowSlow(50,0);
		JY.Darkness=0;
		lib.GetKey();
	end
end


function Dark()             --场景变黑
	if JY.Darkness==0 then
		lib.ShowSlow(50,1);
		JY.Darkness=1;
		lib.GetKey();
	end
end


function instruct_15()          --game over
    JY.Status=GAME_DEAD;
    Cls();
    DrawString(CC.GameOverX,CC.GameOverY,JY.Person[0]["姓名"],RGB(0,0,0),CC.Fontbig);

	local x=CC.ScreenW-9*CC.Fontbig;
    DrawString(x,10,os.date("%Y-%m-%d %H:%M"),RGB(216, 20, 24) ,CC.Fontbig);
    DrawString(x,10+CC.Fontbig+CC.RowPixel,"在地球的某处",RGB(216, 20, 24) ,CC.Fontbig);
    DrawString(x,10+(CC.Fontbig+CC.RowPixel)*2,"当地人口的失踪数",RGB(216, 20, 24) ,CC.Fontbig);
    DrawString(x,10+(CC.Fontbig+CC.RowPixel)*3,"又多了一笔。。。",RGB(216, 20, 24) ,CC.Fontbig);

    local loadMenu={ {"载入进度一",nil,1},
                     {"载入进度二",nil,1},
                     {"载入进度三",nil,1},
                     {"回家睡觉去",nil,1} };
    local y=CC.ScreenH-4*(CC.Fontbig+CC.RowPixel)-10;
    local r=ShowMenu(loadMenu,4,0,x,y,0,0,0,0,CC.Fontbig,C_ORANGE, C_WHITE)

    if r<4 then
        LoadRecord(r);
        JY.Status=GAME_FIRSTMMAP;
    else
        JY.Status=GAME_END;
    end

end


function instruct_16(personid)      --队伍中是否有某人
    local r=false;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["队伍" .. i] then
            r=true;
            break;
        end
    end;
    return r;
end


function instruct_17(sceneid,level,x,y,v)     --修改场景图形
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    SetS(sceneid,x,y,level,v);
end


function instruct_18(thingid)           --是否有某种物品
    for i = 1,CC.MyThingNum do
        if JY.Base["物品" .. i]==thingid then
            return true;
        end
    end
    return false;
end


function instruct_19(x,y)             --改变主角位置
    JY.Base["人X1"]=x;
    JY.Base["人Y1"]=y;
	JY.SubSceneX=0;
	JY.SubSceneY=0;
end


function instruct_20()                 --判断队伍是否满
    if JY.Base["队伍" .. CC.TeamNum ] >=0 then
        return true;
    end
    return false;
end

function decteam(pid)
    if JY.Person[pid]==nil then
        lib.Debug("instruct_21 error: personid not exist");
        return ;
    end
    local j=0;
    for i = 1, CC.TeamNum do
        if pid==JY.Base["队伍" .. i] then
            j=i;
            break;
        end
    end;
    if j==0 then
       return;
    end
    for  i=j+1,CC.TeamNum do
        JY.Base["队伍" .. i-1]=JY.Base["队伍" .. i];
		JY.Person[pid]["所在"]=JY.Shop[JY.Person[pid]["门派"]]["据点"];
    end
    JY.Base["队伍" .. CC.TeamNum]=-1;
end
function instruct_21(personid)               --离队
    if JY.Person[personid]==nil then
        lib.Debug("instruct_21 error: personid not exist");
        return ;
    end
    local j=0;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["队伍" .. i] then
            j=i;
            break;
        end
    end;
    if j==0 then
       return;
    end

    for  i=j+1,CC.TeamNum do
        JY.Base["队伍" .. i-1]=JY.Base["队伍" .. i];
    end
    JY.Base["队伍" .. CC.TeamNum]=-1;

    if JY.Person[personid]["武器"]>=0 then
        JY.Thing[JY.Person[personid]["武器"]]["使用人"]=-1;
        JY.Person[personid]["武器"]=-1
    end
    if JY.Person[personid]["防具"]>=0 then
        JY.Thing[JY.Person[personid]["防具"]]["使用人"]=-1;
        JY.Person[personid]["防具"]=-1;
    end

    if JY.Person[personid]["修炼物品"]>=0 then
        JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"]=-1;
        JY.Person[personid]["修炼物品"]=-1;
    end

    JY.Person[personid]["修炼点数"]=0;
    JY.Person[personid]["物品修炼点数"]=0;
end


function instruct_22()            --内力降为0
    for i = 1, CC.TeamNum do
        if JY.Base["队伍" .. i] >=0 then
            JY.Person[JY.Base["队伍" .. i]]["内力"]=0;
        end
    end
end


function instruct_23(personid,value)           --设置用毒
    JY.Person[personid]["用毒能力"]=value;
    AddPersonAttrib(personid,"用毒能力",0)
end

--空指令
function instruct_24()
    instruct_test("指令24测试")
end

--场景移动
function MoveScene(x,y)
	instruct_25(JY.SubSceneX,JY.SubSceneY,x,y)
end
--为简化，实际上是场景移动(x2-x1)，(y2-y1)。先y后x。因此，x1,y1可设为0
function instruct_25(x1,y1,x2,y2)             --场景移动
    local sign;
    if y1 ~= y2 then
        if y2<y1 then
            sign=-1;
        else
            sign=1;
        end
        for i=y1+sign,y2,sign do
            local t1=lib.GetTime();
            JY.SubSceneY=JY.SubSceneY+sign;
	        --JY.oldSMapX=-1;
		    --JY.oldSMapY=-1;
            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end

    if x1 ~= x2 then
        if x2<x1 then
            sign=-1;
        else
            sign=1;
        end
        for i=x1+sign,x2,sign do
            local t1=lib.GetTime();
            JY.SubSceneX=JY.SubSceneX+sign;
			--JY.oldSMapX=-1;
			--JY.oldSMapY=-1;

            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end
end


function instruct_26(sceneid,id,v1,v2,v3)           --增加D*编号
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    local v=GetD(sceneid,id,2);
    SetD(sceneid,id,2,v+v1);
    v=GetD(sceneid,id,3);
    SetD(sceneid,id,3,v+v2);
    v=GetD(sceneid,id,4);
    SetD(sceneid,id,4,v+v3);
end

function PlayMovie(id,startpic,endpic)
	instruct_27(id,startpic,endpic)
end
--显示动画 id=-1 主角位置动画
function instruct_27(id,startpic,endpic)           --显示动画
    local old1,old2,old3;
	if id ~=-1 then
        old1=GetD(JY.SubScene,id,5);
        old2=GetD(JY.SubScene,id,6);
        old3=GetD(JY.SubScene,id,7);
    end

    --Cls();
	--ShowScreen();
    for i =startpic,endpic,2 do
        local t1=lib.GetTime();
        if id==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id,5,i);
            SetD(JY.SubScene,id,6,i);
            SetD(JY.SubScene,id,7,i);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
	if id ~=-1 then
        SetD(JY.SubScene,id,5,old1);
        SetD(JY.SubScene,id,6,old2);
        SetD(JY.SubScene,id,7,old3);
    end
end

--判断品德
function instruct_28(personid,vmin,vmax)          --判断品德
    local v=JY.Person[personid]["品德"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false;
    end
end

--判断攻击力
function instruct_29(personid,vmin,vmax)           --判断攻击力
    local v=JY.Person[personid]["攻击力"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false
    end
end

--主角走动
--为简化，走动使用相对值(x2-x1)(y2-y1),因此x1,y1可以为0，不必一定要为当前坐标。
function instruct_30(x1,y1,x2,y2)                --主角走动
    --Cls();
    --ShowScreen();

    if x1<x2 then
        for i=x1+1,x2 do
            local t1=lib.GetTime();
            instruct_30_sub(1);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif x1>x2 then
        for i=x2+1,x1 do
            local t1=lib.GetTime();
            instruct_30_sub(2);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end

    if y1<y2 then
        for i=y1+1,y2 do
            local t1=lib.GetTime();
            instruct_30_sub(3);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif y1>y2 then
        for i=y2+1,y1 do
            local t1=lib.GetTime();
            instruct_30_sub(0);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end
end

function walkto_old(x,y)
	instruct_30(0,0,x,y)
end

function walk(direct)
	while AutoMoveTab[0]>0 do
		local t1=lib.GetTime();
		if JY.Status==GAME_SMAP then
			instruct_30_sub(AutoMoveTab[AutoMoveTab[0]]);
		elseif JY.Status==GAME_MMAP then
			instruct_30_sub2(AutoMoveTab[AutoMoveTab[0]]);
		end
		AutoMoveTab[AutoMoveTab[0]]=nil;
		AutoMoveTab[0]=AutoMoveTab[0]-1;
		local t2=lib.GetTime();
		if (t2-t1)<CC.PersonMoveFrame then
			lib.Delay(CC.PersonMoveFrame-(t2-t1));
		end
	end
	JY.Base["人方向"]=direct;
	JY.MyPic=GetMyPic();
    --DrawSMap();
	Cls();
    ShowScreen();
end
--主角走动sub
function instruct_30_sub(direct)            --主角走动sub
    local x,y;
    AddMyCurrentPic();
    x=JY.Base["人X1"]+CC.DirectX[direct+1];
    y=JY.Base["人Y1"]+CC.DirectY[direct+1];
    JY.Base["人方向"]=direct;
    JY.MyPic=GetMyPic();
    DtoSMap();

    if  SceneCanPass(x,y)==true then
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
		if JY.SubSceneX~=0 or JY.SubSceneY~=0 then
			JY.SubSceneX=JY.SubSceneX-CC.DirectX[direct+1]
			JY.SubSceneY=JY.SubSceneY-CC.DirectY[direct+1]
		end
    end
    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);
	getkey();
    --DrawSMap();
    Cls();
    ShowScreen();
end
function instruct_30_sub2(direct)            --主角走动sub
    local x,y;
    AddMyCurrentPic();
    x=JY.Base["人X"]+CC.DirectX[direct+1];
    y=JY.Base["人Y"]+CC.DirectY[direct+1];
    JY.Base["人方向"]=direct;
    JY.MyPic=GetMyPic();
    JY.Base["人X"]=limitX(x,1,CC.MWidth-2);
    JY.Base["人Y"]=limitX(y,1,CC.MHeight-2);
	getkey();
    --DrawSMap();
    Cls();
    ShowScreen();
end
--判断是否够钱
function instruct_31(num)             --判断是否够钱
    local r=false;
    for i =1,CC.MyThingNum do
        if JY.Base["物品" .. i]==CC.MoneyID then
            if JY.Base["物品数量" .. i]>=num then
                r=true;
            end
            break;
        end
    end
    return r;
end

--增加物品
--num 物品数量，负数则为减少物品
function instruct_32(thingid,num)           --增加物品
    local p=1;
    for i=1,CC.MyThingNum do
        if JY.Base["物品" .. i]==thingid then
            JY.Base["物品数量" .. i]=JY.Base["物品数量" .. i]+num
            p=i;
            break;
        elseif JY.Base["物品" .. i]==-1 then
            JY.Base["物品" .. i]=thingid;
            JY.Base["物品数量" .. i]=num;
            p=1;
            break;
        end
    end

    if JY.Base["物品数量" .. p] <=0 then
        for i=p+1,CC.MyThingNum do
            JY.Base["物品" .. i-1]=JY.Base["物品" .. i];
            JY.Base["物品数量" .. i-1]=JY.Base["物品数量" .. i];
        end
        JY.Base["物品" .. CC.MyThingNum]=-1;
        JY.Base["物品数量" .. CC.MyThingNum]=0;
    end
end

--学会武功
function instruct_33(personid,wugongid,flag)           --学会武功
    local add=0;
    for i=1,10 do
        if JY.Person[personid]["武功" .. i]==0 then
            JY.Person[personid]["武功" .. i]=wugongid;
            JY.Person[personid]["武功等级" .. i]=0;
            add=1
            break;
        end
    end

    if add==0 then      --，武功已满，覆盖最后一个武功
        JY.Person[personid]["武功10" ]=wugongid;
        JY.Person[personid]["武功等级10"]=0;
    end

    if flag==0 then
        DrawStrBoxWaitKey(string.format("%s 学会武功 %s",JY.Person[personid]["姓名"],JY.Wugong[wugongid]["名称"]),C_ORANGE,CC.Fontbig);
    end
end

--资质增加
function instruct_34(id,value)              --资质增加
    local add,str=AddPersonAttrib(id,"资质",value);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.Fontbig);
end

--设置武功
function instruct_35(personid,id,wugongid,wugonglevel)         --设置武功
    if id>=0 then
        JY.Person[personid]["武功" .. id+1]=wugongid;
        JY.Person[personid]["武功等级" .. id+1]=wugonglevel;
    else
        local flag=0;
        for i =1,10 do
            if JY.Person[personid]["武功" .. i]==0 then
                flag=1;
                JY.Person[personid]["武功" .. i]=wugongid;
                JY.Person[personid]["武功等级" .. i]=wugonglevel;
                return;
            end
        end
        if flag==0 then
            JY.Person[personid]["武功" .. 1]=wugongid;
            JY.Person[personid]["武功等级" .. 1]=wugonglevel;
        end
    end
end
function SetKF(pid,kfid,kflv)
	if kfid<=0 then
		return;
	end
	for i =1,80 do
		if JY.Person[pid]["所会武功" .. i]<=0 then
			JY.Person[pid]["所会武功" .. i]=kfid;
			JY.Person[pid]["所会武功经验" .. i]=kflv;
			return;
		elseif JY.Person[pid]["所会武功" .. i]==kfid then
			JY.Person[pid]["所会武功经验" .. i]=kflv;
			return;
		end
	end
end
--判断主角性别
function instruct_36(sex)               --判断主角性别
    if JY.Person[0]["性别"]==sex then
        return true;
    else
        return false;
    end
end


function instruct_37(v)              --增加品德
    AddPersonAttrib(0,"品德",v);
end

--修改场景某层贴图
function instruct_38(sceneid,level,oldpic,newpic)         --修改场景某层贴图
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    for i=0,CC.SWidth-1 do
        for j=1, CC.SHeight-1 do
            if GetS(sceneid,i,j,level)==oldpic then
                SetS(sceneid,i,j,level,newpic)
            end
        end
    end
end


function instruct_39(sceneid)             --打开场景
    JY.Scene[sceneid]["进入条件"]=0;
end


function instruct_40(v)                --改变主角方向
    JY.Base["人方向"]=v;
    JY.MyPic=GetMyPic();
end


function instruct_41(personid,thingid,num)        --其他人员增加物品
    local k=0;
    for i =1, 4 do        --已有物品
        if JY.Person[personid]["携带物品" .. i]==thingid then
            JY.Person[personid]["携带物品数量" .. i]=JY.Person[personid]["携带物品数量" .. i]+num;
            k=i;
            break
        end
    end

    --物品减少到0，则后面物品往前移动
    if k>0 and JY.Person[personid]["携带物品数量" .. k] <=0 then
        for i=k+1,4 do
            JY.Person[personid]["携带物品" .. i-1]=JY.Person[personid]["携带物品" .. i];
            JY.Person[personid]["携带物品数量" .. i-1]=JY.Person[personid]["携带物品数量" .. i];
        end
        JY.Person[personid]["携带物品" .. 4]=-1;
        JY.Person[personid]["携带物品数量" .. 4]=0;
    end


    if k==0 then    --没有物品，注意此处不考虑超过4个物品的情况，如果超过，则无法加入。
        for i =1, 4 do        --已有物品
            if JY.Person[personid]["携带物品" .. i]==-1 then
                JY.Person[personid]["携带物品" .. i]=thingid;
                JY.Person[personid]["携带物品数量" .. i]=num;
                break
            end
        end
    end
end


function instruct_42()          --队伍中是否有女性
    local r=false;
    for i =1,CC.TeamNum do
        if JY.Base["队伍" .. i] >=0 then
            if JY.Person[JY.Base["队伍" .. i]]["性别"]==1 then
                r=true;
            end
        end
    end
    return r;
end


function instruct_43(thingid)        --是否有某种物品
    return instruct_18(thingid);
end


function instruct_44(id1,startpic1,endpic1,id2,startpic2,endpic2)     --同时显示两个动画
    local old1=GetD(JY.SubScene,id1,5);
    local old2=GetD(JY.SubScene,id1,6);
    local old3=GetD(JY.SubScene,id1,7);
    local old4=GetD(JY.SubScene,id2,5);
    local old5=GetD(JY.SubScene,id2,6);
    local old6=GetD(JY.SubScene,id2,7);

    --Cls();
    --ShowScreen();
    for i =startpic1,endpic1,2 do
        local t1=lib.GetTime();
        if id1==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id1,5,i);
            SetD(JY.SubScene,id1,6,i);
            SetD(JY.SubScene,id1,7,i);
        end
        if id2==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id2,5,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,6,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,7,i-startpic1+startpic2);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
    SetD(JY.SubScene,id1,5,old1);
    SetD(JY.SubScene,id1,6,old2);
    SetD(JY.SubScene,id1,7,old3);
    SetD(JY.SubScene,id2,5,old4);
    SetD(JY.SubScene,id2,6,old5);
    SetD(JY.SubScene,id2,7,old6);

end


function instruct_45(id,value)        --增加轻功
    local add,str=AddPersonAttrib(id,"轻功",value);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.Fontbig);
end


function instruct_46(id,value)            --增加内力
    local add,str=AddPersonAttrib(id,"内力最大值",value);
    AddPersonAttrib(id,"内力",0);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.Fontbig);
end


function instruct_47(id,value)
    local add,str=AddPersonAttrib(id,"攻击力",value);           --增加攻击力
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.Fontbig);
end


function instruct_48(id,value)         --增加生命
    local add,str=AddPersonAttrib(id,"生命最大值",value);
    AddPersonAttrib(id,"生命",0);
    if instruct_16(id)==true then             --我方队员，显示增加
        DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.Fontbig);
    end
end


function instruct_49(personid,value)       --设置内力属性
    JY.Person[personid]["内力性质"]=value;
end

--判断是否有5种物品
function instruct_50(id1,id2,id3,id4,id5)       --判断是否有5种物品
    local num=0;
    if instruct_18(id1)==true then
        num=num+1;
    end
    if instruct_18(id2)==true then
        num=num+1;
    end
    if instruct_18(id3)==true then
        num=num+1;
    end
    if instruct_18(id4)==true then
        num=num+1;
    end
    if instruct_18(id5)==true then
        num=num+1;
    end
    if num==5 then
        return true;
    else
        return false;
    end
end


function instruct_51()     --问软体娃娃
    instruct_1(2547+Rnd(18),114,0);
end


function instruct_52()       --看品德
    DrawStrBoxWaitKey(string.format("你现在的品德指数为: %d",JY.Person[0]["品德"]),C_ORANGE,CC.Fontbig);
end


function instruct_53()        --看声望
    DrawStrBoxWaitKey(string.format("你现在的声望指数为: %d",JY.Person[0]["声望"]),C_ORANGE,CC.Fontbig);
end


function instruct_54()        --开放其他场景
    for i = 0, JY.SceneNum-1 do
        JY.Scene[i]["进入条件"]=0;
    end
    JY.Scene[2]["进入条件"]=2;    --云鹤崖
    JY.Scene[38]["进入条件"]=2;   --摩天崖
    JY.Scene[75]["进入条件"]=1;   --桃花岛
    JY.Scene[80]["进入条件"]=1;   --绝情谷底
end


function instruct_55(id,num)      --判断D*编号的触发事件
    if GetD(JY.SubScene,id,2)==num then
        return true;
    else
        return false;
    end
end


function instruct_56(v)             --增加声望
    JY.Person[0]["声望"]=JY.Person[0]["声望"]+v;
    instruct_2_sub();     --是否可以增加武林帖
end

--高昌迷宫劈门
function instruct_57()       --高昌迷宫劈门
    instruct_27(-1,7664,7674);
    --Cls();
	--ShowScreen();
    for i=0,56,2 do
	    local t1=lib.GetTime();
        if JY.MyPic< 7688/2 then
            JY.MyPic=(7676+i)/2;
        end
        SetD(JY.SubScene,2,5,i+7690);
        SetD(JY.SubScene,2,6,i+7690);
        SetD(JY.SubScene,2,7,i+7690);
        SetD(JY.SubScene,3,5,i+7748);
        SetD(JY.SubScene,3,6,i+7748);
        SetD(JY.SubScene,3,7,i+7748);
        SetD(JY.SubScene,4,5,i+7806);
        SetD(JY.SubScene,4,6,i+7806);
        SetD(JY.SubScene,4,7,i+7806);

        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
    	if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
	    end
    end
end

--武道大会比武
function instruct_58()           --武道大会比武
    local group=5           --比武的组数
    local num1 = 6          --每组有几个战斗
    local num2 = 3          --选择的战斗数
    local startwar=102      --起始战斗编号
    local flag={};

    for i = 0,group-1 do
        for j=0,num1-1 do
            flag[j]=0;
        end

        for j = 1,num2 do
            local r;
            while true do          --选择一场战斗
                r=Rnd(num1);
                if flag[r]==0 then
                    flag[r]=1;
                    break;
                end
            end
            local warnum =r+i*num1;      --武道大会战斗编号
            WarLoad(warnum + startwar);
            instruct_1(2854+warnum, JY.Person[WAR.Data["敌人1"]]["头像代号"], 0);
            instruct_0();
            if WarMain(warnum + startwar, 0) ==true  then     --赢
                instruct_0();
                instruct_13();
                TalkEx("还有那位前辈肯赐教？", 0, 1)
                instruct_0();
            else
                instruct_15();
                return;
            end
        end

        if i < group - 1 then
            TalkEx("少侠已连战三场，*可先休息再战．", 70, 0);
            instruct_0();
            instruct_14();
            lib.Delay(300);
            if JY.Person[0]["受伤程度"] < 50 and JY.Person[0]["中毒程度"] <= 0 then
               JY.Person[0]["受伤程度"] = 0
               AddPersonAttrib(0,"体力",math.huge);
               AddPersonAttrib(0,"内力",math.huge);
               AddPersonAttrib(0,"生命",math.huge);
            end
            instruct_13();
            TalkEx("我已经休息够了，*有谁要再上？",0,1);
            instruct_0();
        end
    end

    TalkEx("接下来换谁？**．．．．*．．．．***没有人了吗？",0,1);
    instruct_0();
    TalkEx("如果还没有人要出来向这位*少侠挑战，那麽这武功天下*第一之名，武林盟主之位，*就由这位少侠夺得．***．．．．．．*．．．．．．*．．．．．．*好，恭喜少侠，这武林盟主*之位就由少侠获得，而这把*”武林神杖”也由你保管．",70,0);
    instruct_0();
    TalkEx("恭喜少侠！",12,0);
    instruct_0();
    TalkEx("小兄弟，恭喜你！",64,4);
    instruct_0();
    TalkEx("好，今年的武林大会到此已*圆满结束，希望明年各位武*林同道能再到我华山一游．",19,0);
    instruct_0();
    instruct_14();
    for i = 24,72 do
        instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
    end
    instruct_0();
    instruct_13();
    TalkEx("历经千辛万苦，我终於打败*群雄，得到这武林盟主之位*及神杖．*但是”圣堂”在那呢？*为什麽没人告诉我，难道大*家都不知道．*这会儿又有的找了．", 0, 1)
    instruct_0();
    instruct_2(143, 1)           --得到神杖

end

--全体队员离队
function instruct_59()           --全体队员离队
    for i=CC.TeamNum,2,-1 do
	    if JY.Base["队伍" .. i]>=0 then
            instruct_21(JY.Base["队伍" .. i]);
	    end
    end

    for i,v in ipairs(CC.AllPersonExit) do
        instruct_3(v[1],v[2],0,0,-1,-1,-1,-1,-1,-1,0,-2,-2);
    end
end

--判断D*图片
function instruct_60(sceneid,id,num)          --判断D*图片
    if sceneid==-2 then
         sceneid=JY.SubScene;
    end

    if id==-2 then
         id=JY.CurrentD;
    end

    if GetD(sceneid,id,5)==num then
        return true;
    else
        return false;
    end
end

--判断是否放完14天书
function instruct_61()               --判断是否放完14天书
    for i=11,24 do
        if GetD(JY.SubScene,i,5) ~= 4664 then
            return false;
        end
    end
    return true;
end

--播放时空机动画，结束
function instruct_62(id1,startnum1,endnum1,id2,startnum2,endnum2)      --播放时空机动画，结束
      JY.MyPic=-1;
      instruct_44(id1,startnum1,endnum1,id2,startnum2,endnum2);

      --此处应该插入正规的片尾动画。这里暂时用图片代替

	  lib.LoadPicture(CONFIG.PicturePath .."end.png",-1,-1);
	  ShowScreen();
	  PlayMIDI(24);
	  lib.Delay(5000);
	  lib.GetKey();
	  WaitKey();
	  JY.Status=GAME_END;
end

--设置性别
function instruct_63(personid,sex)          --设置性别
    JY.Person[personid]["性别"]=sex
end

--小宝卖东西
function instruct_64()                 --小宝卖东西
    local headid=111;           --小宝头像


    local id=-1;
    for i=0,JY.ShopNum-1 do                --找到当前商店id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    TalkEx("这位小哥，看看有什麽需要*的，小宝我卖的东西价钱绝*对公道．",headid,0);

    local menu={};
    for i=1,5 do
        menu[i]={};
        local thingid=JY.Shop[id]["物品" ..i];
        menu[i][1]=string.format("%-12s %5d",JY.Thing[thingid]["名称"],JY.Shop[id]["物品价格" ..i]);
        menu[i][2]=nil;
        if JY.Shop[id]["物品数量" ..i] >0 then
            menu[i][3]=1;
        else
            menu[i][3]=0;
        end
    end

    local x1=(CC.ScreenW-9*CC.Fontbig-2*CC.MenuBorderPixel)/2;
    local y1=(CC.ScreenH-5*CC.Fontbig-4*CC.RowPixel-2*CC.MenuBorderPixel)/2;



    local r=ShowMenu(menu,5,0,x1,y1,0,0,1,1,CC.Fontbig,C_ORANGE, C_WHITE);

    if r>0 then
        if instruct_31(JY.Shop[id]["物品价格" ..r])==false then
            TalkEx("非常抱歉，*你身上的钱似乎不够．",headid,0);
        else
            JY.Shop[id]["物品数量" ..r]=JY.Shop[id]["物品数量" ..r]-1;
            instruct_32(CC.MoneyID,-JY.Shop[id]["物品价格" ..r]);
            instruct_32(JY.Shop[id]["物品" ..r],1);
            TalkEx("大爷买了我小宝的东西，*保证绝不後悔．",headid,0);
        end
    end

    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,939,-1,-1,-1,-2,-2,-2);      --设置离开场景时触发小宝离开事件，
    end
end

--小宝去其他客栈
function instruct_65()           --小宝去其他客栈
    local id=-1;
    for i=0,JY.ShopNum-1 do                --找到当前商店id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    ---清除当前商店所有小宝D×
    instruct_3(-2,CC.ShopScene[id].d_shop,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    end

    local newid=id+1;              --暂时用顺序取代随机，
    if newid>=5 then
        newid=0;
    end

    --设置新的小宝商店位置
    instruct_3(CC.ShopScene[newid].sceneid,CC.ShopScene[newid].d_shop,1,-2,938,-1,-1,8256,8256,8256,-2,-2,-2);
end

--播放音乐
function instruct_66(id)       --播放音乐
    PlayMIDI(id);
end

--播放音效
function instruct_67(id)      --播放音效
     PlayWavAtk(id);
end


function SmartWalk(x,y,d)
								JY.EnableKeyboard=false;
								JY.EnableMouse=false;
								walkto(x,y);
								walk(d);
								JY.EnableKeyboard=true;
								JY.EnableMouse=true;
end
--say,say_1,say_sub

function script_say(s)
	local num=string.find(s,"：");
	local name=string.sub(s,1,num-1);
	local str=string.sub(s,num+2,-1);
	say(str,JY.Name[name]);
end
--新对话方式
--加入控制字符
--暂停，任意键后继续，ｐ
--控制颜色 Ｒ=redＧ=goldＢ=blackＷ=whiteＯ=orange
--控制字符显示速度０－９
--控制字体ＡＳＤＦ
--控制换行Ｈ分页Ｐ
--Ｎ代表自己ｎ代表主角
function say(s,pid,flag,name)          --个人新对话
	pid=pid or 0;
	if type(pid)=="string" then
		pid=JY.Name[pid];
	end
	if flag==nil then
		if pid==0 then
			flag=1;
		elseif pid==JY.LastSayPid then
			flag=JY.LastSayPosition;
		else
			if inteam(pid) then
				flag=5;	--LD
			else
				if JY.LastSayPosition==0 then
					flag=4;
					JY.LastSayPosition=flag;
				else
					flag=0;
					JY.LastSayPosition=flag;
				end
				JY.LastSayPid=pid;
			end
		end
	end
	name=name or JY.Person[pid]['姓名'];
	local headid=JY.Person[pid]['头像代号'];
	Cls();
	say_sub(s,headid,name,flag);
	--Cls();
end
function say_2(s,pid,flag,name)          --个人新对话
	pid=pid or 0;
	if type(pid)=="string" then
		pid=JY.Name[pid];
	end
	if flag==nil then
		if pid==0 then
			flag=1;
		elseif pid==JY.LastSayPid then
			flag=JY.LastSayPosition;
		else
			if inteam(pid) then
				flag=5;	--LD
			else
				if JY.LastSayPosition==0 then
					flag=4;
					JY.LastSayPosition=flag;
				else
					flag=0;
					JY.LastSayPosition=flag;
				end
				JY.LastSayPid=pid;
			end
		end
	end
	name=name or JY.Person[pid]['姓名'];
	local headid=JY.Person[pid]['头像代号'];
	say_sub(s,headid,name,flag);
	--Cls();
end
function say_1(s,headid,name,flag)
	name=name or '';
	flag=flag or 0;
	say_sub(s,headid,name,flag);
	Cls();
end
function say_sub(s,headid,name,flag)          --个人新对话
    local picw=150;       --最大头像图片宽高
	local pich=150;
	local talkxnum=18;         --对话一行字数
	local talkynum=3;          --对话行数
	local boxw=picw+talkxnum*24+20;
	local boxh=96;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=talkxnum*24+10;
	local boxtalkh=96;
	local dx=(CC.ScreenW-boxtalkw-boxpicw)/2;
	local dy=10;
    local talkBorder=24/4--(pich-talkynum*24)/(talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx+5,heady=dy-2,
	                talkx=dx+boxpicw,talky=dy+54,
					bx1=dx,by1=dy+54,bx2=dx+boxw,by2=dy+54+boxh,
					showhead=1},--左上
                   {headx=CC.ScreenW-dx-boxpicw+5,heady=CC.ScreenH-dy-boxpich+8,
					talkx=CC.ScreenW-dx-boxw,talky=CC.ScreenH-dy-boxh,
					bx1=CC.ScreenW-dx-boxw,by1=CC.ScreenH-dy-boxh,bx2=CC.ScreenW-dx,by2=CC.ScreenH-dy,
				    --talkx=CC.ScreenW-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					showhead=1},--右下
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43,talky=dy+27,
				   showhead=0},--上中
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					showhead=1},
                   {headx=CC.ScreenW-dx-boxpicw+5,heady=dy-2,
	                talkx=CC.ScreenW-dx-boxw,talky=dy+54,
					bx1=CC.ScreenW-dx-boxw,by1=dy+54,bx2=CC.ScreenW-dx,by2=dy+54+boxh,
					showhead=1},--右上
                   {headx=dx+5,heady=CC.ScreenH-dy-boxpich+8,
				   talkx=dx+boxpicw,talky=CC.ScreenH-dy-boxh,
				   bx1=dx,by1=CC.ScreenH-dy-boxh,bx2=dx+boxw,by2=CC.ScreenH-dy,
				   showhead=1}, --左下
			}

    if flag<0 or flag>5 then
        flag=0;
    end
    if xy[flag].showhead==0 then
        --headid=-1;
    end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();
	--s=string.sub(s,2,-1);
	
	local function readstr(str)
		local T1={"０","１","２","３","４","５","６","７","８","９"}
		local T2={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE}}
		local T3={{"ｓ",CC.FontNameSong},{"ｈ",CC.FontNameHei},{"ｆ",CC.FontName}}
		--美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
		--以默认的字体为标准，启体需下移，细黑需上移
		for i=0,9 do
			if T1[i+1]==str then return 1,i*20 end
		end
		for i=1,5 do
			if T2[i][1]==str then return 2,T2[i][2] end
		end
		for i=1,3 do
			if T3[i][1]==str then return 3,T3[i][2] end
		end
		return 0
	end
	
	local function mydelay(t)
		lib.GetKey()
		if t<=0 then return end
		lib.ShowSurface(0)
		lib.Delay(t)
	end
	
	local page,cy,cx=0,0,0
	local color,t,font=C_WHITE,0,CC.FontName
	local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
	while string.len(s)>=1 do
		if page==0 then				--新的一页，清屏，显示头像
			--Cls()
			lib.LoadSur(sid,0,0);
			DrawNewBox(xy[flag].bx1,xy[flag].by1,xy[flag].bx2,xy[flag].by2,C_WHITE);
			if headid>=0 then
				local w,h=lib.PicGetXY(1,headid*2);
				local x=(picw-w)/2;
				local y=(pich-h)/2;
				if flag==1 or flag==4 then
					lib.PicLoadCache(1,headid*2,xy[flag].headx+x,xy[flag].heady+y,17);
				else
					lib.PicLoadCache(1,headid*2,xy[flag].headx+x,xy[flag].heady+y,1);
				end
				for i=xy[flag].headx,xy[flag].headx+150 do
					lib.Background(i,xy[flag].heady+129,i+1,xy[flag].heady+129+21,64+128*math.abs(xy[flag].headx+75-i)/75)
				end
				MyDrawString(xy[flag].headx,xy[flag].headx+150,xy[flag].heady+129,name,C_ORANGE,21);
			end
			page=1
		end
		local str;
		str=string.sub(s,1,1);
		if string.byte(str)>127 then
			str=string.sub(s,1,2);
			s=string.sub(s,3,-1);
			--开始控制逻辑
			if str=="Ｈ" then
				if cx~=0 then
					cx=0
					cy=cy+1
					if cy==3 then
						cy=0
						page=0
					end
				end
			elseif str=="Ｐ" then
				cx=0
				cy=0
				page=0
			elseif str=="ｐ" then
				ShowScreen();
				WaitKey();	
				lib.Delay(100)	
			elseif str=="Ｎ" then
				s=name..s
			elseif str=="ｎ" then
				s=JY.Person[0]["姓名"]..s
			else 
				local kz1,kz2=readstr(str)
				if kz1==1 then
					t=kz2
				elseif kz1==2 then
					color=kz2
				elseif kz1==3 then
					font=kz2
				else
					getkey();
					lib.DrawStr(xy[flag].talkx+24*cx+5,
								xy[flag].talky+(24+talkBorder)*cy+talkBorder,
								str,color,24,font,0,0)
					mydelay(t)
					cx=cx+1
					--[[
					if cx==talkxnum then
						cx=0
						cy=cy+1
						if cy==talkynum then
							cy=0
							page=0
						end
					end]]--
				end
			end
		else
			str=string.sub(s,1,1);
			s=string.sub(s,2,-1);
			getkey();
			lib.DrawStr(xy[flag].talkx+24*cx+5,
						xy[flag].talky+(24+talkBorder)*cy+talkBorder,
						str,color,24,font,0,0)
			mydelay(t)
			cx=cx+0.5
		end
			if cx>talkxnum-1 then
				cx=0
				cy=cy+1
				if cy==talkynum then
					cy=0
					page=0
				end
			end
		--如果换页，则显示，等待按键
		if page==0 or string.len(s)<1 then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		end
	end
	--lib.LoadSur(sid,0,0);
	lib.FreeSur(sid);

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

end

function say_sub1(s,headid,name,flag)          --个人新对话
    local picw=150;       --最大头像图片宽高
	local pich=150;
	local talkxnum=18;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2;
	local dy=2;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=talkxnum*CC.Fontbig+10;
	local boxtalkh=boxpich-27;
    local talkBorder=(pich-talkynum*CC.Fontbig)/(talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+27,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--左上
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					namex=CC.ScreenW-1-dx-boxpicw-96,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--右下
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43,talky=dy+27,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--上中
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+27,
					namex=CC.ScreenW-1-dx-boxpicw-96,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+27,
					namex=CC.ScreenW-1-dx-boxpicw-96,namey=dy,
					showhead=1},--右上
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+27,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --左下
			}

    if flag<0 or flag>5 then
        flag=0;
    end
    if xy[flag].showhead==0 then
        headid=-1;
    end
	s=string.sub(s,2,-1);

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();
	
	local function readstr(str)
		local T1={"０","１","２","３","４","５","６","７","８","９"}
		local T2={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE}}
		local T3={{"Ｈ",CC.FontNameSong},{"Ｓ",CC.FontNameHei},{"Ｆ",CC.FontName}}
		--美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
		--以默认的字体为标准，启体需下移，细黑需上移
		for i=0,9 do
			if T1[i+1]==str then return 1,i*20 end
		end
		for i=1,5 do
			if T2[i][1]==str then return 2,T2[i][2] end
		end
		for i=1,3 do
			if T3[i][1]==str then return 3,T3[i][2] end
		end
		return 0
	end
	
	local function mydelay(t)
		lib.GetKey()
		if t<=0 then return end
		lib.ShowSurface(0)
		lib.Delay(t)
	end
	
	local page,cy,cx=0,0,0
	local color,t,font=C_WHITE,0,CC.FontName
	while string.len(s)>1 do
		if page==0 then				--新的一页，清屏，显示头像
			Cls()
            if headid>=0 then
                DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich,C_WHITE);
				DrawBox(xy[flag].namex,xy[flag].namey,xy[flag].namex+96,xy[flag].namey+24,C_WHITE)
				MyDrawString(xy[flag].namex,xy[flag].namex+96,xy[flag].namey+1,name,C_ORANGE,21)
				local w,h=lib.PicGetXY(1,headid*2);
                local x=(picw-w)/2;
				local y=(pich-h)/2;
				lib.PicLoadCache(1,headid*2,xy[flag].headx+5+x,xy[flag].heady+5+y,1);
            end
            DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx +boxtalkw, xy[flag].talky + boxtalkh,C_WHITE);			
			page=1
		end
		local str=string.sub(s,1,2)
		s=string.sub(s,3,-1)
		--开始控制逻辑
		if str=="Ｈ" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="Ｐ" then
			cx=0
			cy=0
			page=0
		elseif str=="ｐ" then
			ShowScreen();
			WaitKey();	
			lib.Delay(100)	
		elseif str=="Ｎ" then
			s=JY.Person[pid]["姓名"]..s
		elseif str=="ｎ" then
			s=JY.Person[0]["姓名"]..s
		else 
			local kz1,kz2=readstr(str)
			if kz1==1 then
				t=kz2
			elseif kz1==2 then
				color=kz2
			elseif kz1==3 then
				font=kz2
			else
				lib.DrawStr(xy[flag].talkx+CC.Fontbig*cx+5,
							xy[flag].talky+(CC.Fontbig+talkBorder)*cy+talkBorder-8,
							str,color,CC.Fontbig,font,0,0)
				mydelay(t)
				cx=cx+1
				if cx==talkxnum then
					cx=0
					cy=cy+1
					if cy==talkynum then
						cy=0
						page=0
					end
				end
			end
		end
		--如果换页，则显示，等待按键
		if page==0 or string.len(s)<2 then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		end
	end


    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

end

function inteam(pid)
	return instruct_16(pid)
end

--人物内场景坐标是否在范围内
function inrect(v1,v2,v3,v4)
	if v3==nil then
		if JY.Base["人X1"]==v1 and JY.Base["人Y1"]==v2 then
			return true
		end
	else
		if JY.Base["人X1"]>=v1 and JY.Base["人Y1"]>=v2 and JY.Base["人X1"]<=v3 and JY.Base["人Y1"]<=v4 then
			return true
		end
	end
	return false
end

function MoveSceneTo(x,y)
	if y~=nil then
		instruct_25(0,0,x-JY.Base["人X1"]-JY.SubSceneX,y-JY.Base["人Y1"]-JY.SubSceneY)
	else
		instruct_25(0,0,-JY.SubSceneX,-JY.SubSceneY)
	end
end

function walkto11(x,y)
	instruct_30(JY.Base["人X1"],JY.Base["人Y1"],x,y)
end

function fenjie(a,b)
	local aa,bb
	aa=math.modf(a/b)
	bb=math.fmod(a,b)
	return aa,bb
end

function ScreenFlash(color,flag)
	Cls();
	lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,color,128);
	ShowScreen();
	lib.Delay(80);
	lib.ShowSlow(50,1);
	if flag~=nil then
		Light();
	end
end
--设置标记
function SetFlag(id,value)
	if between(id,0,49151) then
		local n,x,y,level
		id,n=fenjie(id,2)
		id,y=fenjie(id,64)
		id,level=fenjie(id,6)
		x=math.fmod(id,64)
		--print(string.format('%d,%d,%d,%d',b,x,y,level))
		return SetS(90+n,x,y,level,value)
	end
	return false
end

function GetFlag(id)
	if between(id,0,49151) then
		local n,x,y,level
		id,n=fenjie(id,2)
		id,y=fenjie(id,64)
		id,level=fenjie(id,6)
		x=math.fmod(id,64)
		return GetS(90+n,x,y,level)
	end
	return 0
end

--养成期间时间流逝,用于时间触发的事件
function NextDay(n)
	n=n or 1;
	local day=GetFlag(1);
	for i=1,n do
		day=day+1;
		if TimeEvent[day]~=nil then
			TimeEvent[day]();
		end
	end
	SetFlag(1,day);
end

function vs(id1,x1,y1,id2,x2,y2,EXP,isexp)
	--local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
	isexp=isexp or 0;
	WAR={};
	WAR.Data={};
	WAR.Data["代号"]=0;
	WAR.Data["名称"]="切磋";
	WAR.Data["地图"]=JY.SubScene;
	if JY.Person[id2]["等级"]<16 then
		WAR.Data["音乐"]=307;
	elseif JY.Person[id2]["等级"]<31 then
		WAR.Data["音乐"]=305;
	elseif JY.Person[id2]["等级"]<46 then
		WAR.Data["音乐"]=304;
	elseif JY.Person[id2]["等级"]<51 then
		WAR.Data["音乐"]=303;
	end
	WAR.Data["经验"]=50--EXP;
	
	WAR.Data["自动选择参战人"  .. 1]=id1;
	WAR.Data["我方X"  .. 1]=x1;
	WAR.Data["我方Y"  .. 1]=y1;
	WAR.Data["敌人"  .. 1]=id2;
	WAR.Data["敌方X"  .. 1]=x2;
	WAR.Data["敌方Y"  .. 1]=y2;
	local result;
	if x1<0 then
		WAR.Data["我方X"  .. 1]=JY.Base["人X1"];
		WAR.Data["我方Y"  .. 1]=JY.Base["人Y1"];
		result=WarMain(998,isexp);
	else
		result=WarMain(999,isexp);
	end
	local add;
	--lib.LoadSur(sid,0,0);
	--ShowScreen();
	--WaitKey()
	if result then
		add=(JY.Person[id2]["等级"]^2)/3+JY.Person[id2]["等级"]*5;
		local lvdiff=JY.Person[id2]["等级"]-JY.Person[id1]["等级"]
			lvdiff=limitX(lvdiff,-12,6);
			if lvdiff>0 then
				add=add*(7-lvdiff)/7;
			else
				add=add*(12-lvdiff)/12;
			end
		add=math.modf(add+JY.Person[id2]["等级"]+50);
		add=AddPersonAttrib(id2,"经验",math.modf(add*(100+smagic(id2,58,1))/100))+Rnd(10);
		DrawStrBoxWaitKey(string.format("%s获得*经验点数 %d",JY.Person[id2]["姓名"],add),C_WHITE,CC.Fontbig,1);
		--lib.LoadSur(sid,0,0);
		if War_AddPersonLevel(id2) then
			JY.Person[id2]["友好"]=JY.Person[id2]["友好"]+1+Rnd(3);
		elseif JY.Person[id2]["友好"]<80 and math.random(100)<50 then
			JY.Person[id2]["友好"]=JY.Person[id2]["友好"]+1+Rnd(2);
		end
	else
		--add=AddPersonAttrib(id2,"经验",math.modf((EXP+JY.Person[0]["等级"])*(100+smagic(id2,58,1))/100));
	end
	--lib.FreeSur(sid);
	return result;
end

function FIGHT(meNUM,enemyNUM,p,q,EXP,isexp,wid,quick)
	wid=wid or 999;
	WAR={};
	WAR.Data={};
	WAR.Data["代号"]=0;
	WAR.Data["名称"]="多人战斗";
	WAR.Data["地图"]=JY.SubScene;
	WAR.Data["经验"]=EXP;
	WAR.Data["音乐"]=302;
	
	local force=q;
	local fnum=enemyNUM;
	for i=1,meNUM do
		if p[3*i-2]==0 then
			force=p;
			fnum=meNUM;
			break;
		end
	end
	local pp={};
	local ni=0;
	for i=1,fnum do
		if force[3*i-2]>=0 then
			ni=ni+1;
			pp[ni]={force[3*i-2],2};
		end
	end
	if ni<fnum then
		for i,v in pairs(JY.Person) do
			if inteam(i) then
				local alreadyin=false;
				for ii,vv in pairs(pp) do
					if i==vv[1] then
						alreadyin=true;
						break;
					end
				end
				if not alreadyin then
					ni=ni+1;
					pp[ni]={i,0};
				end
			end
		end
		ShowAllPerson(pp,fnum);
		local ni=0;
		for i=1,fnum do
			if type(pp[i])=="table" and pp[i][2]>0 then
				ni=ni+1;
				force[3*ni-2]=pp[i][1];
			end
		end
	end
	
	
	for i=1,meNUM do
		if p[3*i-2]>=0 then
			WAR.Data["自动选择参战人"  .. i]=p[3*i-2];
			WAR.Data["我方X"  .. i]=p[3*i-1];
			WAR.Data["我方Y"  .. i]=p[3*i];
		else
			meNUM=i-1;
			break;
		end
	end
	for i=1,enemyNUM do
		if q[3*i-2]>=0 then
			WAR.Data["敌人"  .. i]=q[3*i-2];
			WAR.Data["敌方X"  .. i]=q[3*i-1];
			WAR.Data["敌方Y"  .. i]=q[3*i];
		else
			meNUM=i-1;
			break;
		end
	end
	if quick then
		return QuickWar(wid)
	else
		return WarMain(wid,isexp);
	end
end

function Getkflv(pid,kfid)
	if kfid<=0 then
		return 0;
	end
	for i=1,CC.MaxKungfuNum do
		if JY.Person[pid]["所会武功"..i]==kfid then
			return 1+math.modf(JY.Person[pid]["所会武功经验"..i]/100)
		end
	end
	return 0;
end

--事件相关函数
function E_kungfugame(fid,pid)
	--选择出战的人物
	local id={0,};
	local id1={};
	local id2={};
	local id3={};
	local id4={};
	local num=1;
	for i=1,CC.ToalPersonNum do
		if fid==-99 or (fid>=0 and JY.Person[i]["门派"]==fid and JY.Person[0]["身份"]>=JY.Person[i]["身份"]) or (fid<0 and JY.Person[i]["门派"]~=-fid) then
				num=num+1;
				id[num]=i;
		end
	end
	--排序
	for i=2,num-1 do
		for j=i+1,num do
			if JY.Person[id[i]]["身份"]<JY.Person[id[j]]["身份"] then
				id[i],id[j]=id[j],id[i];
			else
			if JY.Person[id[i]]["身份"]==JY.Person[id[j]]["身份"] and math.random(100)<20 then
				id[i],id[j]=id[j],id[i];
			end
			end
		end
	end
	--打乱
	id=TableRandom(id);
	--[[
	for i=2,math.min(16,num)-1 do
		for j=2,math.min(16,num) do
			if i~=j then
				if math.random(100)>50 then
					id[i],id[j]=id[j],id[i];
				end
			end
		end
	end]]--
	--local n=math.random(math.min(16,num));
	--id[1],id[n]=id[n],id[1];
	
	local size=math.modf(CC.ScreenW/28);
	local x=(CC.ScreenW-size*23.5-4)/2;
	local linelength=math.modf((CC.ScreenH-size*8)/6);
	local y=CC.ScreenH-(CC.ScreenH-linelength*5-size*5)/2-size*4;
	local function redrow()
		DrawBoxTitle(size*25,linelength*5+size*8,"门派比武",C_GOLD);
		local color;
		for i=1,16 do
			if id[i]~=nil then
				local s=GenTalkString(JY.Person[id[i]]["姓名"],1);
				DrawStrBox(x+(i-1)*size*1.5,y,s,C_WHITE,size);
				local win=id1[math.modf((i+1)/2)];
				if win~=nil and win==id[i] then
					color=C_RED;
				else
					color=C_WHITE;
				end
				DrawLine(	x+size/2+2+(i-1)*size*1.5,y-linelength,
									x+size/2+2+(i-1)*size*1.5,y,color);
				DrawLine(	x+size/2+2+(i-1)*size*1.5,y-linelength,
									x+size/2+2+(i-1)*size*1.5+size*0.75*(-1)^(1+i%2),y-linelength,color);
			else
				break;
			end
		end
		for i=1,8 do
			local win=id2[math.modf((i+1)/2)];
			if win~=nil and win==id1[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*5/4+2+(i-1)*size*3,y-linelength*2,
								x+size*5/4+2+(i-1)*size*3,y-linelength*1,color);
			DrawLine(	x+size*5/4+2+(i-1)*size*3,y-linelength*2,
								x+size*5/4+2+(i-1)*size*3+size*1.5*(-1)^(1+i%2),y-linelength*2,color);
		end
		for i=1,4 do
			local win=id3[math.modf((i+1)/2)];
			if win~=nil and win==id2[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*11/4+2+(i-1)*size*6,y-linelength*3,
								x+size*11/4+2+(i-1)*size*6,y-linelength*2,color);
			DrawLine(	x+size*11/4+2+(i-1)*size*6,y-linelength*3,
								x+size*11/4+2+(i-1)*size*6+size*3*(-1)^(1+i%2),y-linelength*3,color);
		end
		for i=1,2 do
			local win=id4[math.modf((i+1)/2)];
			if win~=nil and win==id3[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*23/4+2+(i-1)*size*12,y-linelength*4,
								x+size*23/4+2+(i-1)*size*12,y-linelength*3,color);
			DrawLine(	x+size*23/4+2+(i-1)*size*12,y-linelength*4,
								x+size*23/4+2+(i-1)*size*12+size*6*(-1)^(1+i%2),y-linelength*4,color);
		end
		if id4[1]~=nil then
			color=C_RED;
		else
			color=C_WHITE;
		end
		DrawLine(	CC.ScreenW/2,y-linelength*5,
							CC.ScreenW/2,y-linelength*4,color);
		DrawStrBox(CC.ScreenW/2-size-4,y-linelength*5-size-7,"优胜",color,size);
		
	end
	
	local function vvss(iid1,iid2)
		if iid1~=0 and iid2~=0 then
			redrow();
			if not DrawStrBoxYesNo(-1,-1,string.format("Ｙ%sＷVsＹ%sＷ，是否观战？",JY.Person[iid1]["姓名"],JY.Person[iid2]["姓名"]),C_WHITE,CC.Fontbig) then
				return FIGHT(1,1,{iid1,21,27},{iid2,13,26},100,-1,999,true);
			end
		end
		return VVS(iid1,iid2);
	end
	redrow();
	ShowScreen();
	WaitKey();
	Cls();
	for i=1,8 do
		local ida,idb=id[i*2-1],id[i*2];
		if ida==nil then
			id1[i]=nil;
			break;
		end
		if idb==nil then
			id1[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id1[i]=ida;
		else
			id1[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id1[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,4 do
		local ida,idb=id1[i*2-1],id1[i*2];
		if ida==nil then
			id2[i]=nil;
			break;
		end
		if idb==nil then
			id2[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id2[i]=ida;
		else
			id2[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id2[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,2 do
		local ida,idb=id2[i*2-1],id2[i*2];
		if ida==nil then
			id3[i]=nil;
			break;
		end
		if idb==nil then
			id3[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id3[i]=ida;
		else
			id3[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id3[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,1 do
		local ida,idb=id3[i*2-1],id3[i*2];
		if ida==nil then
			id4[i]=nil;
			break;
		end
		if idb==nil then
			id4[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id4[i]=ida;
		else
			id4[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id4[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	if id4[1]==0 then
		say("哈哈，我是第一呢！");
		if JY.Person[0]["身份"]==1 then
			JY.Person[0]["身份"]=2;
			JY.Person[0]["外号"]=string.sub(JY.Person[0]["外号"],1,4).."好手";
			say("你实在是"..JY.Person[0]["外号"].."啊，看来你可以学习更进一步的武功了。",pid);
		elseif JY.Person[0]["身份"]==2 then
			JY.Person[0]["身份"]=3;
			JY.Person[0]["外号"]=string.sub(JY.Person[0]["外号"],1,4).."高手";
			say("你实在是"..JY.Person[0]["外号"].."啊，看来你可以学习本门的高深武功了。",pid);
		end
	else
		say("没能取胜实在是很遗憾，下次一定要取得第一。");
	end
end

function VVS(iid1,iid2)

		if JY.SubScene==27 then
			ModifyWarMap=function()
								SetWarMap(25,26,1,851*2);
								SetWarMap(25,27,1,851*2);
								SetWarMap(25,28,1,851*2);
								SetWarMap(25,29,1,851*2);
			end
								local r=FIGHT(1,1,{iid1,21,27},{iid2,13,26},100,-1);
			--[[
								SetS(JY.SubScene,25,26,1,921*2);
								SetS(JY.SubScene,25,27,1,0);
								SetS(JY.SubScene,25,28,1,0);
								SetS(JY.SubScene,25,29,1,919*2);
			]]--
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==29 then
			ModifyWarMap=function()
								SetWarMap(26,27,1,1137*2);
								SetWarMap(26,28,1,1137*2);
								SetWarMap(26,29,1,1137*2);
								SetWarMap(23,24,1,854*2);
								SetWarMap(23,33,1,854*2);
			end
								local r=FIGHT(1,1,{iid1,23,28},{iid2,18,27},100,-1);
			--[[
								SetS(JY.SubScene,26,27,1,1138*2);
								SetS(JY.SubScene,26,28,1,0);
								SetS(JY.SubScene,26,29,1,1136*2);
								SetS(JY.SubScene,23,24,1,0);
								SetS(JY.SubScene,23,33,1,0);
			]]--
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==36 then
			ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(23,18,1,903*2);
								SetWarMap(34,18,1,903*2);
			end
								local r=FIGHT(1,1,{iid1,29,21},{iid2,28,14},100,-1);
			--[[
								SetS(JY.SubScene,29,24,1,0);
								SetS(JY.SubScene,23,18,1,0);
								SetS(JY.SubScene,34,18,1,0);
			]]--
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==57 then
			ModifyWarMap=function()
								SetWarMap(21,24,1,2268);
								SetWarMap(22,24,1,2268);
								SetWarMap(23,24,1,2268);
			end
								local r=FIGHT(1,1,{iid1,21,22},{iid2,21,13},100,-1);
			--[[
								SetS(JY.SubScene,21,24,1,2266);
								SetS(JY.SubScene,22,24,1,0);
								SetS(JY.SubScene,23,24,1,2270);
			]]--
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==58 then
			ModifyWarMap=function()
								SetWarMap(28,28,1,1429*2);
								SetWarMap(29,28,1,1429*2);
								SetWarMap(30,28,1,1429*2);
								SetWarMap(23,23,1,903*2);
								SetWarMap(35,25,1,903*2);
			end
								local r=FIGHT(1,1,{iid1,17,22},{iid2,16,13},100,-1);
			--[[
								SetS(JY.SubScene,28,28,1,0);
								SetS(JY.SubScene,29,28,1,0);
								SetS(JY.SubScene,30,28,1,0);
								SetS(JY.SubScene,23,23,1,0);
								SetS(JY.SubScene,35,25,1,0);
			]]--
								Cls();
								--ShowScreen();
								return r;
		else
		
		end
end
function VVVS()
	local iid1=0;
	local iid2=161;
		if JY.SubScene==27 then
			ModifyWarMap=function()
								SetWarMap(48,29,1,1492*2);
								SetWarMap(57,42,1,1492*2);
								SetWarMap(57,43,1,1492*2);
			end
								local r=FIGHT(1,1,{iid1,50,29},{iid2,54,30},100,-1);
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==29 then
			ModifyWarMap=function()
								SetWarMap(26,27,1,1137*2);
								SetWarMap(26,28,1,1137*2);
								SetWarMap(26,29,1,1137*2);
									SetWarMap(43,26,1,2243*2);
									SetWarMap(43,27,1,2242*2);
									SetWarMap(43,28,1,2242*2);
									SetWarMap(43,29,1,2241*2);
			end
								local r=FIGHT(1,1,{iid1,27,28},{iid2,31,27},100,-1);
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==36 then
			ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(28,44,1,1021*2);
								SetWarMap(29,44,1,1022*2);
								SetWarMap(30,44,1,1023*2);
								SetWarMap(28,43,1,0);
								SetWarMap(30,43,1,0);
			end
								local r=FIGHT(1,1,{iid1,29,25},{iid2,28,32},100,-1);
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==57 then
			ModifyWarMap=function()
									SetWarMap(47,28,1,1840);
									SetWarMap(47,29,1,1840);
									SetWarMap(47,30,1,1840);
									SetWarMap(47,31,1,1840);
									
									SetWarMap(50,27,1,1491*2);
									SetWarMap(51,27,1,1491*2);
									SetWarMap(50,32,1,1491*2);
									SetWarMap(51,32,1,1491*2);
									SetWarMap(57,29,1,1491*2);
									SetWarMap(57,30,1,1491*2);
			end
								local r=FIGHT(1,1,{iid1,47,30},{iid2,54,29},100,-1);
								Cls();
								--ShowScreen();
								return r;
		elseif JY.SubScene==58 then
			ModifyWarMap=function()
									SetWarMap(27,47,1,1021*2);
									SetWarMap(28,47,1,1022*2);
									SetWarMap(29,47,1,1022*2);
									SetWarMap(30,47,1,1023*2);
									SetWarMap(27,46,1,0);
									SetWarMap(30,46,1,0);
									SetWarMap(48,55,1,1144*2);
									SetWarMap(49,55,1,1144*2);
									SetWarMap(25,53,1,1144*2);
			end
								local r=FIGHT(1,1,{iid1,28,48},{iid2,36,53},100,-1);
			--[[
								SetS(JY.SubScene,28,28,1,0);
								SetS(JY.SubScene,29,28,1,0);
								SetS(JY.SubScene,30,28,1,0);
								SetS(JY.SubScene,23,23,1,0);
								SetS(JY.SubScene,35,25,1,0);
			]]--
								Cls();
								--ShowScreen();
								return r;
		else
		
		end
end
--门派守卫
function E_guarding(id)
	say("好啊，我正好有事要出去几天。你帮我顶七天吧",id);
	if DrawStrBoxYesNo(-1,-1,"是否要站岗七天？",C_WHITE,CC.Fontbig) then
		if JY.Person[0]["体力"]<50 then
			say("我看你气色不太好，还是先好好休息吧。",id);
			return;
		end
		Dark();
		lib.Delay(1200);
		if DayPass(7,-3) then
			Light();
			if Rnd(10)<-6 then
				say("哪来的，别在这里乱晃。");
				say("本大爷我想去哪就去哪！",161);
				if VVVS() then
					--say("赶紧滚吧。");
					say("嗯，刚刚怎么有打斗的声音，有什么事吗？",id);
					say("没事，来了个小贼，已经打发掉了。");
					AddPerformance(10);
				else
					say("哼，还敢拦着本大爷吗",161);
					Dark();
					say("哪来的贼子，赶在这里捣乱！",id);
					Light();
					say("切，撤！",161);
					say("幸好你即时赶回来了。");
				end
			else
				say("我回来了，你去休息吧。",id);
				AddPerformance(5);
			end
		else
			--say("不行了，谁来顶我几天？",id);
			script_say("华山弟子：你怎么能这样擅离职守呢！");
			AddPerformance(-5);
		end
	else
		say("本来还想出去玩玩呢。",id);
	end
end
--书架读书
function E_readbook()
						if DrawStrBoxYesNo(-1,-1,"是否花三天时间来参阅武学心得？",C_WHITE,CC.Fontbig) then
								if JY.Person[0]["体力"]<30 then
									say("不行，实在太累了。还是先休息好了再来研究吧。");
									return;
								end
							say("时机难得，好好看看吧。");
							Dark();
							lib.Delay(1500);
							if DayPass(3,-3) then
								Light();
								local add,str;
								if myRnd100()/100-JY.Person[0]["福缘"]/200<(JY.Person[0]["等级"]+5)/(JY.Person[0]["等级"]/2+GetFlag(1000)/3) then
									say("原来如此，前辈的心得果然使人茅塞顿开。");
									add,str=AddPersonAttrib(0,"修炼点数",math.modf(80-Rnd(40)+(4+JY.Person[0]["等级"])*800/(140-JY.Person[0]["资质"])*(100+smagic(0,58,1))/100));
									SetFlag(1000,GetFlag(1000)+1);
								else
									say("什么前辈的心得，一点有价值的东西都没有！");
									add,str=AddPersonAttrib(0,"修炼点数",math.random(10)+10);
									SetFlag(1000,GetFlag(1000)-2);
								end
								DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
							end
						else
							say("下次再来吧。");
						end
end
--闭关练功
function E_training(id)

						if DrawStrBoxYesNo(-1,-1,"是否要练武五天？",C_WHITE,CC.Fontbig) then
							say("好。");
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",id);
									return;
								end
							Dark();
							lib.Delay(1000);
							--SetFlag(1,GetFlag(1)+3);
							if DayPass(5,-3) then
								Light();
								if myRnd100()/4<GetFlag(1)-GetFlag(1001)+JY.Person[0]["福缘"]/4+JY.Person[0]["体力"]/4-5 then
									say("累死我也！不过又学到了不少东西，还是挺值得的。");
									local add,str=AddPersonAttrib(0,"经验",math.modf(100-Rnd(50)+(4+JY.Person[0]["等级"])*2000/(200-JY.Person[0]["资质"])*(100+smagic(0,58,1))/100));
									DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
									War_AddPersonLevel(0);
								else
									say("哎呀！腰扭了！");
									say("你没事吧，",JY.Da);
									say("应该没什么大碍吧，休息几天就好了");
									JY.Person[0]["体力"]=10;
									DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. "练功时，不小心受伤了",C_ORANGE,CC.Fontbig);
								end
								SetFlag(1001,GetFlag(1));
							end
						else
							say("啊？我还有事，下次吧");
						end
end
--锻炼兵器
function E_learning(id)
	local p1=JY.Person[0];
	local p2=JY.Person[id];
	if p2["友好"]<10 then
		say("我和你又不是很熟，为什么要教你。",id);
		return;
	elseif p2["友好"]<=20 then
		if Rnd(p2["友好"])<=10 then
			say("今天有点事，改天吧。",id);
			return;
		end
	end
	local menu=	{
							{"拳掌",nil,0},
							{"御剑",nil,0},
							{"耍刀",nil,0},
							{"枪棍",nil,0},
							--{"",nil,1},
						};
	local flag=false;
	for i,v in pairs(menu) do
		if math.modf(p2[v[1]]/10)>math.modf(p1[v[1]]/10) then
			v[3]=1;
			flag=true;
		end
	end
	menu[5]={"取消",nil,2};
	if flag then
		say("想锻炼什么呢？",id);
		local i=EasyMenu(menu);
		if i==5 then
			say("那今天就算了吧。",id);
		else
			local str=menu[i][1];
			local lv=math.modf(p1[str]/10);
			if p1["体力"]<20+lv*5 then
				say("锻炼"..str.."是很辛苦的事，你还是先休息好再来吧。",id);
			else
				say(string.format("锻炼%s需要花掉%d天时间，你要继续吗？",str,10+lv*5),id);
				if DrawStrBoxYesNo(-1,-1,"是否继续？",C_WHITE,CC.Fontbig) then
					Dark();
					lib.Delay(700);
					if DayPass(10+lv*5,-1) then
						Light();
						local e=math.modf(40/(lv+4))+Rnd(3);
						AddPersonAttrib(0,str,e);
						if p1[str]>(lv+1)*10 then
							p1[str]=(lv+1)*10;
							DrawStrBoxWaitKey( str.."上升！",C_ORANGE,CC.Fontbig);
						else
							DrawStrBoxWaitKey(str.."熟练上升！",C_ORANGE,CC.Fontbig);
						end
						say("谢谢你的指导。");
					end
				else
					say("那今天就算了吧。",id);
				end
			end
		end
	else
		say("似乎我没什么可以教你的阿。",id);
	end
end
--门派贡献
function AddPerformance(n)
	local v=GetFlag(1002);
	local function glv(vv)
		if vv>=1500 then
			return 3;
		elseif vv>=300 then
			return 2;
		elseif vv>=50 then
			return 1;
		else
			return 0;
		end
	end
	local lv=JY.Person[0]["身份"];
	v=v+n;
	if v<0 then
		v=0;
	end
	SetFlag(1002,v);
	if n>0 then
		DrawStrBoxWaitKey(JY.Person[0]["姓名"].."门派贡献上升",C_WHITE,CC.Fontbig);
	else
		DrawStrBoxWaitKey(JY.Person[0]["姓名"].."门派贡献降低",C_RED,CC.Fontbig);
	end
	if glv(v)>lv then
		DrawStrBoxWaitKey(JY.Person[0]["姓名"].."门派地位上升",C_GOLD,CC.Fontbig);
		JY.Person[0]["身份"]=lv+1;
	elseif false and glv(v)<lv then
		DrawStrBoxWaitKey(JY.Person[0]["姓名"].."门派地位降低",C_WHITE,CC.Fontbig);
		JY.Person[0]["身份"]=lv-1;
	end
end
--考察武功
function KaochaKungfu(pid)
	say("今天想考察一下你的武功。",pid);
	if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
		say("是！");
		local eid={};
		local num=0;
		for i=1,CC.ToalPersonNum do
			local p=JY.Person[i];
			if p["门派"]==JY.Person[0]["门派"] then
				if p["身份"]<=JY.Person[0]["身份"] then
					num=num+1;
					eid[num]=i;
				end
			end
		end
		for i=1,num-1 do
			for j=i+1,num do
				if JY.Person[eid[i]]["等级"]>JY.Person[eid[j]]["等级"] then
					eid[i],eid[j]=eid[j],eid[i];
				end
			end
		end
		for i=1,num do
			if JY.Person[eid[i]]["等级"]>JY.Person[0]["等级"] then
				num=i;
				break;
			end
		end
		say(string.format("%s和你武功差不多，你们比试一下吧。",JY.Person[eid[num]]["姓名"]),pid);
		if VVS(0,eid[num]) then
			say("不错，看起来你很努力啊。",pid);
			say("指点一下你的武功吧.",pid);
			local add,str=AddPersonAttrib(0,"经验",(4+JY.Person[0]["等级"])*15+500+math.random(50));
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
			War_AddPersonLevel(0);
			AddPersonAttrib(pid,"友好",2);
		else
			say("不要灰心，好好努力吧。",pid);
			say("稍微指点一下你的武功吧.",pid);
			local add,str=AddPersonAttrib(0,"经验",(4+JY.Person[0]["等级"])*5+200+math.random(50));
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
			War_AddPersonLevel(0);
		end
	else
		say("阿，那个，今天有点不舒服。");
		say("没用的家伙，退下吧。",pid);
		AddPersonAttrib(pid,"友好",-5);
	end
end
--NPC提出切磋
function NPCQiecuo(pid)
	say("今天有空吗，能不能陪我练练功？",pid);
	if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
		say("好啊，咱们点到即止！");
		if VVS(0,pid) then
			say("果然厉害，谢谢你的指点。",pid);
			AddPersonAttrib(pid,"友好",2);
		else
			say("不要灰心，好好努力吧。",pid);
		end
	else
		say("阿，那个，今天有点不舒服。");
		say("那就算了吧。",pid);
		AddPersonAttrib(pid,"友好",-2);
	end
end
--读书+资质
function AddZIZHI(pid)
	if DrawStrBoxYesNo(-1,-1,"是否要读书七天？",C_WHITE,CC.Fontbig) then
		if JY.Person[0]["体力"]<50 then
			say("不行，实在太累了。还是先休息好了再来学习吧。");
			return;
		end
		say("时机难得，好好看看吧。");
		Dark();
		local p1,p2,p3,p4,p5=dofile(".\\script\\qs.lua");
		--总正确数，连续对，连续错，总时间，最快连续对
		local ZZexp=GetFlag(803);
		local lv=math.modf(ZZexp/100);
		ZZexp=ZZexp-lv*100;
		if lv<5 then
			ZZexp=ZZexp+p1*limitX(100-p4/40,1,100)/50;
		else
			ZZexp=ZZexp+p2*limitX(100-p4/20,1,100)/70;
		end
		if DayPass(7,-2) then
			say("每天的积累，终究会有回报的。");
			if ZZexp>100 then
				if lv<10 then
					SetFlag(803,lv*100+ZZexp);
					AddPersonAttrib(0,"资质",1);
					DrawStrBoxWaitKey(JY.Person[0]["资质"].."提升！",C_WHITE,CC.Fontbig,1);
				end
			end
		end
	else
		say("改天吧。");
	end
end

function visit(fid)	--门派拜访
	DrawStrBoxWaitKey("此功能改进中，暂时屏蔽");
	if true then
		return;
	end
	local pp={};
	local ni=0;
	for i,v in pairs(JY.Person) do
		if v["门派"]==fid and v["所在"]==JY.Shop[fid]["据点"] and (not inteam(i)) then
			ni=ni+1;
			pp[ni]={i,0};
		end
	end
	if ni==0 then
		say("没有可拜访的人啊。");
		return;
	end
	local pid=ShowAllPerson(pp);
	if pid<0 then
		say("今天就算了吧。");
		return;
	end
	Dark();
	Light();
	--友好低的,随机不在家
	if JY.Person[pid]["友好"]<40 then
		local r=Rnd(JY.Person[pid]["友好"]+60);
		if r<13 then
			say("没人啊，"..JY.Person[pid]["姓名"].."似乎不在家，下次再来吧。");
			DayPass(1);
			Dark();
			Light();
			return;
		elseif r<20 then
			say("哎呀，欢迎光临，只是我正好有事要出去。今天就算了吧，改天我再登门拜访。",pid);
			say("那真是太遗憾了，你先去忙吧。");
			DayPass(1);
			Dark();
			Light();
			return;
		end
	end
	say("光临寒舍，有什么事吗？",pid);
	JY.Da=pid;
	local menu={
							{"聊天",nil,1},
							{"切磋",nil,1},
							{"锻炼",nil,1},
							{"邀请",nil,0},
							{"状态",nil,1},
							{"离开",nil,1},
						};
	if JY.Person[pid]["身份"]>0 then
		if JY.Person[0]["门派"]>=0 and JY.Person[0]["门派"]==JY.Person[pid]["门派"] then
			menu[4][3]=1;
		end
	end
	while true do
		local r=ShowMenu(menu,6,0,0,0,0,0,1,0);
		if r==1 then
			RandomEvent(JY.Da);
			menu[1][3]=0;
		elseif r==2 then
			if JY.Person[0]["体力"]<30 then
				say("我看你气色不太好，还是先好好休息吧。",JY.Da);
				return;
			end
			say("好啊，咱俩来玩玩。",JY.Da);
			local result=VVS(0,pid)
			Cls();
			ShowScreen();
			if result then
				say("果然厉害！",JY.Da);
			else
				say("你还得多练哪，咱们下次再切磋吧。",JY.Da);
			end
			DayPass(1);
			menu[2][3]=0;
		elseif r==3 then
			E_learning(JY.Da);
			menu[3][3]=0;
		elseif r==4 then
			local yh=JY.Person[pid]["友好"];
			local yy=Rnd(10+yh);
			if Rnd(100)<JY.Person[0]["福缘"] then
				local hh=Rnd(10+yh);
				if hh<yy then
					yy=hh;
				end
			end
			yh=yh*1.5+yy+Rnd(300);
			if yh>150 then
				say("好啊，就陪你走一趟吧。",JY.Da);
				addteam(pid);
			elseif yh>80 then
				say("嗯，也好。不过我想先试试你的武功。",JY.Da);
				local result=VVS(0,pid)
				Cls();
				ShowScreen();
				if result then
					say("果然厉害！那咱们这就出发吧。",JY.Da);
					addteam(pid);
				else
					say("你还得多练哪。",JY.Da);
				end
			else
				say("近来门中多事，恐怕无暇陪你外出了。",JY.Da);
			end
			DayPass(1);
			break;
		elseif r==5 then
			PersonStatus(JY.Da);
		elseif r==6 then
			say("那么，下次再见。",JY.Da);
			DayPass(1);
			break;
		end
	end
	Dark();
	Light();
end
function PersonSelection(pp,fnum)
	
	ShowAllPerson(pp,fnum);
		
end
function E_kungfugamefree()
	--选择出战的人物
	local pp={};
	local id={};
	local id1={};
	local id2={};
	local id3={};
	local id4={};
	local num=0;
	local menu=	{
					{"十级以上",nil,1},
					{"二十级以上",nil,1},
					{"三十级以上",nil,1},
					{"无限制",nil,1},
				}
	local sel=GenSelection(menu);
	if sel==4 then
		sel=0;
	end
	for i=1,CC.ToalPersonNum do
		if JY.Person[i]["身份"]>0 and JY.Person[i]["外功1"]>0 then
			if JY.Person[i]["等级"]>sel*10-4 then
				table.insert(pp,{i,0});
				num=num+1;
			end
		end
	end
	PersonSelection(pp,16);
	for i,v in pairs(pp) do
		if v[2]==1 then
			table.insert(id,v[1]);
		end
	end
	for i=table.maxn(id)+1,16 do
		local n;
		while true do
			n=math.random(num);
			if pp[n][2]==0 then
				pp[n][2]=1;
				table.insert(id,pp[n][1]);
				break;
			end
		end
	end
	--打乱
	id=TableRandom(id,16)
	--[[
	for i=1,math.min(16,num)-1 do
		for j=i+1,math.min(16,num) do
			if math.random(100)>50 then
				id[i],id[j]=id[j],id[i];
			end
		end
	end]]--
	
	local size=math.modf(CC.ScreenW/28);
	local x=(CC.ScreenW-size*23.5-4)/2;
	local linelength=math.modf((CC.ScreenH-size*8)/6);
	local y=CC.ScreenH-(CC.ScreenH-linelength*5-size*5)/2-size*4;
	local function redrow()
		DrawBoxTitle(size*25,linelength*5+size*8,"模拟比武",C_GOLD);
		local color;
		for i=1,16 do
			if id[i]~=nil then
				local s=GenTalkString(JY.Person[id[i]]["姓名"],1);
				DrawStrBox(x+(i-1)*size*1.5,y,s,C_WHITE,size);
				local win=id1[math.modf((i+1)/2)];
				if win~=nil and win==id[i] then
					color=C_RED;
				else
					color=C_WHITE;
				end
				DrawLine(	x+size/2+2+(i-1)*size*1.5,y-linelength,
									x+size/2+2+(i-1)*size*1.5,y,color);
				DrawLine(	x+size/2+2+(i-1)*size*1.5,y-linelength,
									x+size/2+2+(i-1)*size*1.5+size*0.75*(-1)^(1+i%2),y-linelength,color);
			else
				break;
			end
		end
		for i=1,8 do
			local win=id2[math.modf((i+1)/2)];
			if win~=nil and win==id1[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*5/4+2+(i-1)*size*3,y-linelength*2,
								x+size*5/4+2+(i-1)*size*3,y-linelength*1,color);
			DrawLine(	x+size*5/4+2+(i-1)*size*3,y-linelength*2,
								x+size*5/4+2+(i-1)*size*3+size*1.5*(-1)^(1+i%2),y-linelength*2,color);
		end
		for i=1,4 do
			local win=id3[math.modf((i+1)/2)];
			if win~=nil and win==id2[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*11/4+2+(i-1)*size*6,y-linelength*3,
								x+size*11/4+2+(i-1)*size*6,y-linelength*2,color);
			DrawLine(	x+size*11/4+2+(i-1)*size*6,y-linelength*3,
								x+size*11/4+2+(i-1)*size*6+size*3*(-1)^(1+i%2),y-linelength*3,color);
		end
		for i=1,2 do
			local win=id4[math.modf((i+1)/2)];
			if win~=nil and win==id3[i] then
				color=C_RED;
			else
				color=C_WHITE;
			end
			DrawLine(	x+size*23/4+2+(i-1)*size*12,y-linelength*4,
								x+size*23/4+2+(i-1)*size*12,y-linelength*3,color);
			DrawLine(	x+size*23/4+2+(i-1)*size*12,y-linelength*4,
								x+size*23/4+2+(i-1)*size*12+size*6*(-1)^(1+i%2),y-linelength*4,color);
		end
		if id4[1]~=nil then
			color=C_RED;
		else
			color=C_WHITE;
		end
		DrawLine(	CC.ScreenW/2,y-linelength*5,
							CC.ScreenW/2,y-linelength*4,color);
		DrawStrBox(CC.ScreenW/2-size-4,y-linelength*5-size-7,"优胜",color,size);
		
	end
	
	local function vvss(iid1,iid2)
		if iid1~=0 and iid2~=0 then
			redrow();
			if not DrawStrBoxYesNo(-1,-1,string.format("Ｙ%sＷVsＹ%sＷ，是否观战？",JY.Person[iid1]["姓名"],JY.Person[iid2]["姓名"]),C_WHITE,CC.Fontbig) then
				return FIGHT(1,1,{iid1,21,27},{iid2,13,26},100,-1,999,true);
			end
		end
		return VVS(iid1,iid2);
	end
	redrow();
	ShowScreen();
	WaitKey();
	Cls();
	for i=1,8 do
		local ida,idb=id[i*2-1],id[i*2];
		if ida==nil then
			id1[i]=nil;
			break;
		end
		if idb==nil then
			id1[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id1[i]=ida;
		else
			id1[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id1[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,4 do
		local ida,idb=id1[i*2-1],id1[i*2];
		if ida==nil then
			id2[i]=nil;
			break;
		end
		if idb==nil then
			id2[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id2[i]=ida;
		else
			id2[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id2[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,2 do
		local ida,idb=id2[i*2-1],id2[i*2];
		if ida==nil then
			id3[i]=nil;
			break;
		end
		if idb==nil then
			id3[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id3[i]=ida;
		else
			id3[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id3[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	for i=1,1 do
		local ida,idb=id3[i*2-1],id3[i*2];
		if ida==nil then
			id4[i]=nil;
			break;
		end
		if idb==nil then
			id4[i]=ida;
			break
		end
		if idb==0 then
			ida,idb=idb,ida;
		end
		if vvss(ida,idb) then
			id4[i]=ida;
		else
			id4[i]=idb;
		end
		redrow();
		--ShowScreen();
		DrawStrBoxWaitKey(string.format("%s获胜！",JY.Person[id4[i]]["姓名"]),C_WHITE,CC.Fontbig,1);
		--WaitKey();
	end
	say("还有没有更厉害的？哈哈！",id4[1]);
end

function FirstTalk(pid)
	local xg=0;
	local mp=0;
	local mp1=JY.Person[0]["门派"];
	local mp2=JY.Person[pid]["门派"];
	local name1=JY.Person[0]["姓名"];
	local name2=JY.Person[pid]["姓名"];
	local name3="";
	local name4="";
	if mp1>=0 then
		name3=JY.Shop[mp1]["名称"];
	end
	if mp2>=0 then
		name4=JY.Shop[mp2]["名称"];
	end
	local msg=	{
					[0]=	{
								[0]=function()
									say("这位兄台莫非便是"..name4.."的"..name2.."？");
									say("正是在下，不知阁下是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，幸会幸会。",pid);
								end,
								[1]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("正是在下，不知阁下是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，幸会幸会。",pid);
								end,
								[2]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("正是在下，不知阁下是……",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，幸会幸会。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("咦？你是……",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("呵呵，师弟不必如此多礼。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("咦？你是……",pid);
									say("在下乃是"..name3.."新入门的弟子，见到师兄在此，不敢视如不见。");
									say("呵呵，你我两派素来交好，大家虽非同门却有手足之情，师弟不必如此多礼。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("咦？你是……",pid);
									say("在下乃是"..name3.."新入门的弟子。");
									say("你我两派素来不合，所谓道不同不相为谋，以后见到也无需做此亲近摸样，凭添不快而已。",pid);
								end,
							},
					[1]=	{
								[0]=function()
									say("这位兄台莫非便是"..name4.."的"..name2.."？");
									say("哦？此处也有人知我?",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，我游走于江湖，倒是不曾得知何时出了一位如此有礼的青年才俊。",pid);
								end,
								[1]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？此处也有人知我?",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，我游走于江湖，倒是不曾得知何时出了一位如此有礼的青年才俊。",pid);
								end,
								[2]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？此处也有人知我?",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，我游走于江湖，倒是不曾得知何时出了一位如此有礼的青年才俊。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("咦？你如何知我？",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("呵呵，我常年游走于江湖，难得回门派一次，倒是不知门内又得了一位如此有礼的师弟。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("咦？你如何知我？",pid);
									say("在下乃是"..name3.."派新入门的弟子，见到师兄在此，不敢视如不见。");
									say("呵呵，我常年游走于江湖，倒是不知X派又得了一位如此有礼的师弟。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("咦？你如何知我？",pid);
									say("在下乃是"..name3.."派新入门的弟子。");
									say("我常年游走于江湖，倒是不知X派又多了一名弟子。你我两派素来不合，日后相逢，大可不必如此。",pid);
								end,
							},
					[2]=	{
								[0]=function()
									say("这位兄台莫非便是"..name4.."的"..name2.."？");
									say("你是什么人？",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("什么幸不幸的，爷爷我最讨厌文人那一套了，今日就算是拜过山头了。",pid);
								end,
								[1]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("你是什么人？",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("什么幸不幸的，爷爷我最讨厌文人那一套了，今日就算是拜过山头了。",pid);
								end,
								[2]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("你是什么人？",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("什么幸不幸的，爷爷我最讨厌文人那一套了，今日就算是拜过山头了。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("你是什么人？",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("别来文人那一套，爷爷我就是一俗人。今日算是拜过山头了，以后有人欺负你，尽管报爷爷我的名号就是。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("你是什么人？",pid);
									say("在下乃是"..name3.."新入门的弟子，见到师兄在此，不敢视如不见。");
									say("别来文人那一套，爷爷我就是一俗人。我们两派之间有些交情。今日算是拜过山头了，以后有人欺负你，尽管报爷爷我的名号就是。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("你是什么人？",pid);
									say("在下乃是"..name3.."新入门的弟子。");
									say("别来文人那一套，爷爷我就是一俗人。我们两派之间有些不对付。今日便算了，日后见到少不得要教训教训你。",pid);
								end,
							},
					[3]=	{
								[0]=function()
									say("这位兄台莫非便是"..name4.."的"..name2.."？");
									say("……何人？",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("……有礼。",pid);
								end,
								[1]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("……何人？",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("……有礼。",pid);
								end,
								[2]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("……何人？",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("……有礼。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("……何人？",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("……不必多礼。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("……何人？",pid);
									say("在下乃是"..name3.."新入门的弟子，见到师兄在此，不敢视如不见。");
									say("……不必多礼。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("……何人？",pid);
									say("在下乃是"..name3.."新入门的弟子。");
									say("……哼！",pid);
								end,
							},
					[4]=	{
								[0]=function()
									say("这位兄台莫非便是"..name4.."的"..name2.."？");
									say("哦？不知兄台这是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，某如何能当兄台如此？与其口称幸会，不若共饮一碗。",pid);
								end,
								[1]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？不知兄台这是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，某如何能当兄台如此？与其口称幸会，不若共饮一碗。",pid);
								end,
								[2]=function()
									say("这位兄台莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？不知兄台这是……",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("呵呵，某如何能当兄台如此？与其口称幸会，不若共饮一碗。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("哦？不知兄台这是……",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("原来如此。师弟不必多礼，你我既属同门，日后有机会当共饮一碗。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("哦？不知兄台这是……",pid);
									say("在下乃是"..name2.."新入门的弟子，见到师兄在此，不敢视如不见。");
									say("原来如此。师弟不必多礼，你我两派素来交好，日后有机会当共饮一碗。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("哦？不知兄台这是……",pid);
									say("在下乃是"..name2.."新入门的弟子。");
									say("……你我两派不合，某就不请你喝酒了。请吧。",pid);
								end,
							},
					[5]=	{
								[0]=function()
									say("这位公子莫非便是"..name4.."的"..name2.."？");
									say("哦？不知足下这是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("惭愧惭愧。小生有礼了。",pid);
								end,
								[1]=function()
									say("这位公子莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？不知足下这是……",pid);
									say("在下无门无派一江湖小卒，久闻兄台大名，今得一见，实乃大幸。");
									say("惭愧惭愧。小生有礼了。",pid);
								end,
								[2]=function()
									say("这位公子莫非便是江湖上顶顶有名的"..name2.."？");
									say("哦？不知足下这是……",pid);
									say("在下乃是"..name3.."派弟子，久闻兄台大名，今得一见，实乃大幸。");
									say("惭愧惭愧。小生有礼了。",pid);
								end,
								[3]=function()
									say("见过师兄。");
									say("哦？不知足下这是……",pid);
									say("弟子乃是最近新入门的弟子，见到师兄在此，不敢视如不见。");
									say("原来如此。你我分属同门，师弟不必如此多礼。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师兄。");
									say("哦？不知足下这是……",pid);
									say("在下乃是"..name3.."新入门的弟子，见到师兄在此，不敢视如不见。");
									say("原来如此。你我两派素来交好，师弟不必如此多礼。",pid);
								end,
								[5]=function()
									say("敢问阁下可是"..name4.."门下？");
									say("哦？不知足下这是……",pid);
									say("在下乃是"..name3.."新入门的弟子。");
									say("……你我两派素来不合，还望足下自持身份。",pid);
								end,
							},
					[6]=	{
								[0]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
								[1]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
								[2]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
								[3]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
								[4]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
								[5]=function()
									say("见过这位大师……");
									say("阿弥陀佛。",pid);
								end,
							},
					[7]=	{
								[0]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
								[1]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
								[2]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
								[3]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
								[4]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
								[5]=function()
									say("见过道长。");
									say("不必多礼。",pid);
								end,
							},
					[8]=	{
								[0]=function()
									say("见过这位"..name4.."的姐姐。");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("小子乃是无门无派一江湖小子，仰慕姐姐风姿，冒昧打扰，还望姐姐不要怪我。");
									say("呵呵，如此能说会道，姐姐又如何舍得怪你呢。",pid);
								end,
								[1]=function()
									say("见过这位姐姐。");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("小子乃是无门无派一江湖小子，仰慕姐姐风姿，冒昧打扰，还望姐姐不要怪我。");
									say("呵呵，如此能说会道，姐姐又如何舍得怪你呢。",pid);
								end,
								[2]=function()
									say("见过这位姐姐。");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("小子乃是"..name3.."弟子，仰慕姐姐风姿，冒昧打扰，还望姐姐不要怪我。");
									say("呵呵，如此能说会道，姐姐又如何舍得怪你呢。",pid);
								end,
								[3]=function()
									say("见过师姐。");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("弟子乃是最近新入门的弟子，因见师姐风姿，冒昧打扰，还望师姐勿怪。");
									say("呵呵，如此能说会道，姐姐又如何舍得怪你呢。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师姐。");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("小子乃是"..name3.."弟子，仰慕姐姐风姿，冒昧打扰，还望姐姐不要怪我。");
									say("呵呵，如此能说会道，姐姐又如何舍得怪你呢。",pid);
								end,
								[5]=function()
									say("这位姐姐可是"..name4.."门下？");
									say("呵呵，这是谁家的小哥，真会讨人喜欢。",pid);
									say("小子乃是"..name3.."弟子。");
									say("呵呵，如此能说会道，姐姐倒是不知道"..name3.."派也会出你如此人物~下次有机会定会好好与你玩玩~",pid);
								end,
							},
					[9]=	{
								[0]=function()
									say("见过这位"..name4.."的姑娘。");
									say("公子这是……",pid);
									say("在下乃是无门无派一江湖小子，因见姑娘丽质，唐突冒昧，还望恕罪。");
									say("岂敢岂敢。公子有礼了。",pid);
								end,
								[1]=function()
									say("见过这位姑娘。");
									say("公子这是……",pid);
									say("在下乃是无门无派一江湖小子，因见姑娘丽质，唐突冒昧，还望恕罪。");
									say("岂敢岂敢。公子有礼了。",pid);
								end,
								[2]=function()
									say("见过这位姑娘。");
									say("公子这是……",pid);
									say("在下乃是"..name3.."弟子，因见姑娘丽质，唐突冒昧，还望恕罪。");
									say("岂敢岂敢。公子有礼了。",pid);
								end,
								[3]=function()
									say("见过师姐。");
									say("公子这是……",pid);
									say("弟子乃是最近新入门的弟子，因见师姐丽质，唐突冒昧，还望恕罪。");
									say("师弟不必如此多礼。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师姐。");
									say("公子这是……",pid);
									say("在下乃是"..name3.."弟子，因见师姐丽质，唐突冒昧，还望恕罪。");
									say("师弟不必如此多礼。",pid);
								end,
								[5]=function()
									say("这位姐姐可是"..name4.."门下？");
									say("公子这是……",pid);
									say("在下乃是"..name3.."弟子。");
									say("公子不必如此。你我两派素来不合，还望公子勿使小女子难做。",pid);
								end,
							},
					[10]=	{
								[0]=function()
									say("见过这位"..name4.."的女侠。");
									say("哦？阁下这是……",pid);
									say("在下乃是无门无派一江湖小子，素来艳羡女侠英姿，因此冒味，多有得罪，还请见谅。");
									say("江湖谬赞，岂可当真。",pid);
								end,
								[1]=function()
									say("见过这位女侠。");
									say("哦？阁下这是……",pid);
									say("在下乃是无门无派一江湖小子，素来艳羡女侠英姿，因此冒味，多有得罪，还请见谅。");
									say("江湖谬赞，岂可当真。",pid);
								end,
								[2]=function()
									say("见过这位女侠。");
									say("哦？阁下这是……",pid);
									say("在下乃是"..name3.."弟子，素来艳羡女侠英姿，因此冒味，多有得罪，还请见谅。");
									say("江湖谬赞，岂可当真。",pid);
								end,
								[3]=function()
									say("见过师姐。");
									say("哦？阁下这是……",pid);
									say("弟子乃是最近新入门的弟子，素来艳羡女侠英姿，因此冒味，多有得罪，还请见谅。");
									say("江湖谬赞，岂可当真。你既入门，若勤加苦练，日后江湖自有你名。",pid);
								end,
								[4]=function()
									say("见过这位"..name4.."的师姐。");
									say("哦？阁下这是……",pid);
									say("在下乃是"..name3.."弟子，素来艳羡女侠英姿，因此冒味，多有得罪，还请见谅。");
									say("江湖谬赞，岂可当真。",pid);
								end,
								[5]=function()
									say("这位姐姐可是"..name4.."门下？");
									say("哦？阁下这是……",pid);
									say("在下乃是"..name3.."弟子。");
									say("你我之间并无交往，自也不必见礼。",pid);
								end,
							},
				};
	xg=JY.Person[pid]["闲聊"];
	if mp1<0 then
		if mp2<0 then
			mp=1;
			AddPersonAttrib(pid,"友好",5);
		else
			mp=0;
			AddPersonAttrib(pid,"友好",10);
		end
	else
		if mp2<0 then
			mp=2;
			AddPersonAttrib(pid,"友好",5);
		else
			if mp1==mp2 then
				mp=3;
				AddPersonAttrib(pid,"友好",20);
			elseif true then
				mp=4;
				AddPersonAttrib(pid,"友好",10);
			elseif true then
				mp=5;
				AddPersonAttrib(pid,"友好",1);
			end
		end
	end
	msg[xg][mp]();
end
function CommonDrink(pid)
	local xg=0;
	local mp=0;
	local mp1=JY.Person[0]["门派"];
	local mp2=JY.Person[pid]["门派"];
	local name1=JY.Person[0]["姓名"];
	local name2=JY.Person[pid]["姓名"];
	local name3="";
	local name4="";
	if mp1>=0 then
		name3=JY.Shop[mp1]["名称"];
	end
	if mp2>=0 then
		name4=JY.Shop[mp2]["名称"];
	end
	local msg=	{
					[0]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("见过"..name1.."兄。说来不怕"..name1.."兄笑话，今日出门匆忙，忘带盘缠，这酒水茶钱，此时正不知该如何是好啊。对了，"..name1.."兄，不知可否……",pid);
									local money=JY.Person[0]["等级"]+JY.Person[pid]["等级"]*2+20+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("多谢"..name1.."兄仗义相助。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("不敢不敢……唉……我该如何是好……",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("这……还请见谅，在下今日有要事在身，不便饮酒。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("这有酒不可无肴，小二，快上几个拿手好菜，我今天要跟"..name1.."兄喝个痛快！",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("是当浮得一大白啊……在我收拾你之后！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("呵呵，"..name1.."兄高义，在下佩服。来，敬你一杯。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("哼！"..name1.."兄，你可是好人，别跟在下这种不三不四的人混在一起，免得污了你的名声。",pid);
										end
									elseif r==2 then
										if true then
											say(name1.."兄，他也不过是喝多了而已，何至于如此呢？",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("就当是这样！来来来，"..name1.."兄，接着喝酒，别被那等下人扫了兴致。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二！小二！拿酒来！",eid);
									say("这位爷，小店家底不足，已经没酒了。",164);
									say("你这小二，可是怕我没钱？快拿酒来！不然，我拆了你这破店！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("你是谁？送酒来的么？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[1]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("见过"..name1.."兄。说来不怕"..name1.."兄笑话，某终日游走，竟不查盘缠用尽，这酒水茶钱，此时正不知该如何是好啊。对了，"..name1.."兄，不知可否……",pid);
									local money=JY.Person[0]["等级"]*2+JY.Person[pid]["等级"]*2+20+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("多谢"..name1.."兄。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("既是如此，某再另想他法。",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("抱歉，在下还要赶路。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("哦？不知此间有何美酒？快让某尝上一尝。",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("与你同桌，某食之无味。这杯酒，还是等到你死了之后，某再喝吧！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("某游遍天下，少见"..name1.."兄此等高义之人，来，某敬你一杯。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("哼！"..name1.."兄乃大善之人，某可不敢高攀啊。",pid);
										end
									elseif r==2 then
										if true then
											say(name1.."兄，如此作为，有些过了吧？",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("好！某游遍天下，最看不惯那些假仁假义的家伙了，"..name1.."兄，咱们接着喝酒。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二！小二！拿酒来！",eid);
									say("这位爷，小店家底不足，已经没酒了。",164);
									say("你可是觉着某没钱付账？某告诉你，快拿酒来！不然，当心某拆了你这破店！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("你是谁？给某送酒来的么？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[2]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("唉，说出来不怕你笑话，爷爷今天忘记带银子，这酒钱是没办法给了，现在正伤脑筋呢。对了，不知你是不是……",pid);
									local money=JY.Person[0]["等级"]+JY.Person[pid]["等级"]*2+100+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("好！你小子够仗义！",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("奶奶的，没钱还来招惹爷爷做啥？",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("突那小子,你请爷爷喝酒，爷爷为啥要答应你？",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("只喝一坛？那怎么够呢！小二，把你们这所有的酒都给爷爷搬上来！",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("呸！就凭你也配跟爷爷喝酒！？",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("他奶奶的，你小子是个好人，爷爷敬你。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("他奶奶的，爷爷可看不惯你小子这副面孔。",pid);
										end
									elseif r==2 then
										if true then
											say("他奶奶的，欺负些小老百姓，算什么英雄？",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("他奶奶的，小子做事真对爷爷胃口，来，喝酒！",pid);
										end
									end
								end,
								[5]=function(eid)
									say("他奶奶的！小二！小二！快给爷爷拿酒来！",eid);
									say("这位爷，小店家底不足，已经没酒了。",164);
									say("你这小二，爷爷告诉你，爷爷有的是钱！快拿酒来！不然，爷爷我拆了你这破店！他奶奶的！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("他奶奶的！你是什么东西？给爷爷送酒来的么？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[3]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("……一时不查，无钱付账。",pid);
									local money=JY.Person[0]["等级"]*2+JY.Person[pid]["等级"]+50+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("……承情。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("……嗯。",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("……不必。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("……不醉不归。",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("……哼！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("……敬你。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("……",pid);
										end
									elseif r==2 then
										if true then
											say("……",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("……喝酒。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("……酒！",eid);
									say("这位爷，小店家底不足，已经没酒了。",164);
									say("……酒来！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("……酒来了？",eid);
										say("醒酒来了！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[4]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("见过"..name1.."兄。说来不怕"..name1.."兄笑话，在下今日酒虫作怪，没想到所带银两却不足付这酒水茶钱，此时正不知该如何是好啊。对了，"..name1.."兄，不知可否……",pid);
									local money=JY.Person[0]["等级"]*3+JY.Person[pid]["等级"]*3+20+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("好！来日定当请回"..name1.."兄！",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("有心了。在下另想他法便是。",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("兄台好意，在下心领了。若有机会，下次定当共饮。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("好！与友同醉，快哉！快哉！",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("不必了，咱们手下见真章吧！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say(name1.."兄高义，在下敬你一杯，先干为敬。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say(name1.."兄，大丈夫当快意恩仇，这等废人，何需如此以礼相待？",pid);
										end
									elseif r==2 then
										if true then
											say(name1.."兄，不必如此吧。",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("快意恩仇，当是我辈中人所为，哈哈哈，来，喝酒！",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二！小二！快拿酒来！",eid);
									say("这位爷，小店家底不足，已经没酒了。",164);
									say("你这小二，可是怕我没钱？别担心，不会少你酒钱的。快去拿酒来！不然，别怪我不客气！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("你是谁？可是送酒来的？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[5]=	{
								[0]=function()
									say("咦？"..name2.."兄？为何在此自斟自饮，暗自神伤？");
									say("见过"..name1.."兄。说来惭愧，在下今日一时兴起，却不曾料到银两不足，这酒水茶钱，此时正不知该如何是好啊。",pid);
									local money=JY.Person[0]["等级"]+JY.Person[pid]["等级"]+40+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."兄勿急，这酒当在下请"..name2.."兄便是。");
										say("多谢"..name1.."兄，日后必当重酬。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say("实在抱歉，今日在下亦是囊中羞涩，无力相助，还望恕罪。");
										say("无妨。唉……当真一文钱难倒英雄汉啊……",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("多谢阁下厚爱。只是正所谓无功不受禄，这杯酒，在下就不喝了。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say(""..name1.."兄有命，在下岂敢不从？自当舍命陪君子尔。",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("天下之大，却是有几人之酒，在下不屑饮之！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("曾以为如此义举，只在书中一记，不想今日得见"..name1.."兄高义，在下佩服。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say(name1.."兄如此高义，在下定叫人写文著书，令天下人传颂。",pid);
										end
									elseif r==2 then
										if true then
											say(name1.."兄，圣人曾云及人老幼，此举，不太妥当吧。",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("好！"..name1.."兄快意恩仇，有侠客风范，在下敬你一杯。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二！小二！上酒！",eid);
									say("这位公子，小店家底不足，已经没酒了。",164);
									say("你这小二，本公子看着像没钱之人么？你的那套说辞就省了吧，快去拿酒来，不然，小心本公子砸了你的店！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("你是谁？给本公子送酒来的么？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[6]=	{
								[0]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[4]=function()
								end,
								[5]=function(eid)
								end,
							},
					[7]=	{
								[0]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."兄，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("出家人不可饮酒。",pid);
								end,
								[4]=function()
								end,
								[5]=function(eid)
								end,
							},
					[8]=	{
								[0]=function()
									say("咦？"..name2.."姐姐？为何在此自斟自饮，暗自神伤？");
									say("好弟弟，姐姐今日想小酌两杯，不曾料想往日均有旁人代付，今日这酒水茶钱，却不知该如何是好啊。对了，好弟弟，要不……",pid);
									local money=JY.Person[0]["等级"]*4+JY.Person[pid]["等级"]+200+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，"..name2.."姐姐，这酒自当是由小弟来请。");
										say("嘻嘻~还是弟弟知道疼姐姐~",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say(name2.."姐姐，实在抱歉，今日小弟亦是囊中羞涩，无力相助，还望恕罪。");
										say("唉……这天下竟无一人惜花啊……",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."姐姐，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("弟弟真会说话~只是姐姐今天有事，下次再陪你玩啊~",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."姐姐，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("弟弟真讨人喜欢~姐姐的酒量，可不是一般人能比的哦~",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."姐姐，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("弟弟真会说话~只是姐姐不胜酒力，不如我们玩点别的吧~",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("好弟弟~你这善心可不小啊~嘻嘻~",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("好弟弟~你这善心可不小啊~何时可以施舍一点给姐姐呢~",pid);
										end
									elseif r==2 then
										if true then
											say("好弟弟~何必如此动怒呢~来，陪姐姐喝酒~",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("好弟弟~你真对姐姐胃口~",pid);
										end
									end
								end,
								[5]=function(eid)
									say("嘻嘻~小二哥~再上酒啊~",eid);
									say("这位姐姐，小店家底不足，已经没酒了。",164);
									say("嘻嘻~别跟姐姐开玩笑了~姐姐没有酒喝，可是会发脾气的哦~",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("嘻嘻~是来陪姐姐喝酒的么~",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[9]=	{
								[0]=function()
									say("咦？"..name2.."姑娘？为何在此自斟自饮，暗自神伤？");
									say("见过"..name1.."公子。对了，公子，小女子鲁莽，望公子能暂借小女子几钱碎银，代付酒钱，日后必加倍奉还。",pid);
									local money=JY.Person[pid]["等级"]+50+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，相见便是有缘，天下求为姑娘付账之人何其多，在下有幸得此良机，姑娘切莫再提还钱之事。");
										say("公子说笑了，多谢公子仗义。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say(name2.."姑娘，实在抱歉，今日在下亦是囊中羞涩，心有余而力不足，还望恕罪。");
										say("公子有心了。唉……",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."姑娘，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("公子相邀，小女子本不该不从。只是小女子现有急事，还望公子见谅。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."姑娘，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("公子相邀，小女子不敢不从。",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."姑娘，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("公子当自持身份！此登徒子行径实在欺人太甚！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("公子高义，小女子深感佩服。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say("公子大善之光，令小女子自惭形秽。",pid);
										end
									elseif r==2 then
										if true then
											say("公子当自持身份，不当如此。",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("公子乃真侠客，小女子敬公子。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二哥，请再上一壶酒！",eid);
									say("这位小姐，小店家底不足，已经没酒了。",164);
									say("小二哥，别担心，小女子还是略有家底，今日只欲买醉，还望小二哥勿要阻拦。这样对你我都好。",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("公子可是送酒来的？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
					[10]=	{
								[0]=function()
									say("咦？"..name2.."女侠？为何在此自斟自饮，暗自神伤？");
									say(name1.."兄，说来惭愧，本姑娘今日忘带盘缠，又不欲饮霸王之酒，真不知如何是好。对了，"..name1.."兄是否可以……",pid);
									local money=JY.Person[0]["等级"]+JY.Person[pid]["等级"]+60+Rnd(20)-Rnd(20);
									if instruct_31(money) and DrawStrBoxYesNo(-1,-1,string.format("是否支付酒水钱%d两？",money)) then
										instruct_32(CC.ModifyD,-money);
										say("呵呵，行走江湖，谁都难免有此时刻，"..name2.."女侠勿急，这酒钱在下还是付得起的。");
										say("多谢"..name1.."兄解我燃眉之急。",pid);
										AddPersonAttrib(pid,"友好",10);
									else
										say(name2.."女侠，实在抱歉，今日在下亦是囊中羞涩，心有余而力不足，还望恕罪。");
										say("罢了罢了，你不愿意便也算了，我另想他法。",pid);
									end
								end,
								[1]=function()
									say("真是人生何处不相逢啊。"..name2.."女侠，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("不必了。本姑娘还有要事在身，不便叨扰。得罪了。",pid);
								end,
								[2]=function()
									say("真是人生何处不相逢啊。"..name2.."女侠，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("哦？你可是觉得本姑娘酒量不行，只“浮得一白”？",pid);
									AddPersonAttrib(pid,"友好",5);
								end,
								[3]=function()
									say("真是人生何处不相逢啊。"..name2.."女侠，天下之大，能在这酒肆碰上，岂能不浮一大白？");
									say("哼！的确是人生何处不相逢啊！踏破蝶鞋无觅处，想喝酒，去跟阎王爷喝吧！",pid);
									if CommonFight(pid) then
										say("哈哈哈，这便是敬酒不喝喝罚酒了！");
									else
										say("今日之耻，来日必报！");
									end
									AddPersonAttrib(pid,"友好",-5);
								end,
								[4]=function(r)
									if r==1 then
										if true then
											say("好！"..name1.."兄此举，本姑娘自认做不到。敬你。",pid);
											AddPersonAttrib(pid,"友好",2);
										else
											say(name1.."兄自举虽不错，但只会助长其愈加堕落。",pid);
										end
									elseif r==2 then
										if true then
											say(name1.."兄自举未免太过分了。",pid);
											AddPersonAttrib(pid,"友好",-2);
										else
											say("人生在世，当随心所欲，"..name1.."兄，本姑娘敬你一杯。",pid);
										end
									end
								end,
								[5]=function(eid)
									say("小二！小二！拿酒来！",eid);
									say("这位女侠，小店家底不足，已经没酒了。",164);
									say("你这小二，可是怕本姑娘没钱？告诉你，快给本姑娘拿酒来，不然，本姑娘定叫你这破店开不下去！",eid);
									local menu=	{
													{"视而不见",1},
													{"上前阻止",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("（事不关己，我还是不要横插一手了。）");
										say("来来来，我们喝我们的。");
										say("这……好吧，喝。",pid);
									else
										say("住手！欺负一个店小二，算什么英雄？");
										say("你是谁？给本姑娘送酒来的？",eid);
										say("是给你醒酒来的！");
										if CommonFight(eid) then
										
										else
										
										end
										say("ZZZ……",eid);
										DrawStrBoxWaitKey(JY.Person[eid]["姓名"].."已然醉倒在地");
										say("这……唉，今日真是无妄之灾啊");
										say("呵呵。",pid);
										AddPersonAttrib(pid,"友好",2);
									end
								end,
							},
				};
	xg=JY.Person[pid]["闲聊"];
	if mp1<0 then
		if mp2<0 then
			mp=1;
		else
			mp=0;
		end
	else
		if mp2<0 then
			mp=2;
		else
			if mp1==mp2 then
				mp=3;
			elseif true then
				mp=4;
			elseif true then
				mp=5;
			end
		end
	end
	if xg==6 or xg==7 then
		msg[xg][0]();
	elseif Rnd(5)==1 then
		msg[xg][0]();
	else
		local n=JY.Person[pid]["友好"]+Rnd(100);
		if n<10 then
			msg[xg][3]();
		elseif n<50 then
			msg[xg][1]();
		else
			msg[xg][2]();
			Dark();
			if Rnd(5)>=1 then
				DrawStrBoxWaitKey("酒酣耳热之际",C_WHITE,CC.Fontbig,1);
				Light();
				say("好心的大爷，求求你给我一口酒喝吧。",163);
				local menu={{"好言相劝",nil,1},{"恶语相向",nil,1},};
				local r=EasyMenu(menu);
				if r==1 then
					say("这位大叔，你已经醉了，再喝伤身，还是早些回家歇息，明日再喝吧。");
					say("这位爷，您甭管他，他天天如此，闹一会没人理他就会自己回去了。",164);
					say("最近不甚太平，小二，你差人送他回家，银子我出。");
					say("好嘞！这位爷，您可真是好人啊。",164);
				elseif r==2 then
					say("哪里来的醉鬼？还不快滚？打扰小爷喝酒的兴致，小爷毙了你！");
					say("这位大爷，您消消气。他天天如此，闹一会没人理他就会自己回去了。",164);
					say("小二，快叫人把他弄走。不然小爷我拆了你这破店。");
					say("是是是，小的这就叫人，这就叫人。",164);
				end
				msg[xg][4](r);
			else
				DrawStrBoxWaitKey("二人尽欢而散",C_WHITE,CC.Fontbig,1);
				--Light();
			end
		end
	end
end
function CommonFight_Shell(pid)
	
	local msg=	{
					[0]=	{
								[0]=function()
									say("这位兄台，你面色不善，可是在下何时曾有冒犯？",pid);
								end,
								[1]=function()
									say("……技不如人，在下心服口服。只是不知兄台为何……",pid);
									say("无他，看你不顺尔。");
									say("……多谢解惑，告辞！",pid);
								end,
								[2]=function()
									say("兄台何以至此？若是在下有错，直言便可。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，现在如何？",pid);
									say("现在已没事了，多谢，多谢……");
								end,
							},
					[1]=	{
								[0]=function()
									say("这位兄弟，你目露凶光，可是某曾做过什么？",pid);
								end,
								[1]=function()
									say("……技不如人，某无话可说。不过就算是要某死，也该让某死个明白。",pid);
									say("无他，看你不顺尔。");
									say("……多谢相告，后会有期！",pid);
								end,
								[2]=function()
									say("兄台为何如此？若是某有错，大可直说。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，不是某的错便好",pid);
									say("恕罪，恕罪……");
								end,
							},
					[2]=	{
								[0]=function()
									say("突那小子，你做啥恶狠狠的盯着爷爷？爷爷可不记得招惹过你。",pid);
								end,
								[1]=function()
									say("……爷爷打不过你，认栽了！这顿打挨的莫名其妙的……",pid);
									say("无他，看你不顺尔。");
									say("……臭小子，下次爷爷一定要打你一顿！",pid);
								end,
								[2]=function()
									say("突那小子，爷爷又不是你杀父仇人，你做啥这么拼命？",pid);
									say("技不如人，无话可说！");
									say("这爷爷可真糊涂了……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("早说嘛，你小子，怪吓人的。",pid);
									say("不好意思，不好意思……");
								end,
							},
					[3]=	{
								[0]=function()
									say("……杀气……为何？",pid);
								end,
								[1]=function()
									say("……技不如人，服了。究竟为何……",pid);
									say("无他，看你不顺尔。");
									say("……多谢，告辞！",pid);
								end,
								[2]=function()
									say("……为何如此？",pid);
									say("技不如人，无话可说！");
									say("……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("……嗯。",pid);
									say("抱歉，抱歉……");
								end,
							},
					[4]=	{
								[0]=function()
									say("这位兄台，你如此凶煞，可是与我有怨？",pid);
								end,
								[1]=function()
									say("……兄台武功高强，在下佩服。只是在下自问不曾有何对不起兄台之事，不知兄台这是……",pid);
									say("无他，看你不顺尔。");
									say("……原来如此，多谢告之，告辞！",pid);
								end,
								[2]=function()
									say("兄台为何如此？若是在下有何对不起之处，大可直言，在下定当请罪。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，不知兄台可是有何难处？不如说出来，说不定在下还能助兄台一臂之力。",pid);
									say("没什么，没什么……");
								end,
							},
					[5]=	{
								[0]=function()
									say("这位兄台，不知在下可是有何不当之举，惹得兄台不悦？",pid);
								end,
								[1]=function()
									say("……兄台身手不凡，在下心里佩服。只是有一事不明，还望兄台解惑。为何兄台对在下……",pid);
									say("无他，看你不顺尔。");
									say("……兄台果然率真直爽。既是如此，在下告辞！",pid);
								end,
								[2]=function()
									say("兄台身手不凡，在下一时侥幸，只是有一事不明，还望兄台解惑。为何兄台对在下……",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("公子误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，那是在下唐突了。",pid);
									say("不敢，不敢……");
								end,
							},
					[6]=	{
								[0]=function()
									say("这位兄台，你面色不善，可是在下何时曾有冒犯？",pid);
								end,
								[1]=function()
									say("……技不如人，在下心服口服。只是不知兄台为何……",pid);
									say("无他，看你不顺尔。");
									say("……多谢解惑，告辞！",pid);
								end,
								[2]=function()
									say("兄台何以至此？若是在下有错，直言便可。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，现在如何？",pid);
									say("现在已没事了，多谢，多谢……");
								end,
							},
					[7]=	{
								[0]=function()
									say("这位兄台，你面色不善，可是在下何时曾有冒犯？",pid);
								end,
								[1]=function()
									say("……技不如人，在下心服口服。只是不知兄台为何……",pid);
									say("无他，看你不顺尔。");
									say("……多谢解惑，告辞！",pid);
								end,
								[2]=function()
									say("兄台何以至此？若是在下有错，直言便可。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("兄台误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，现在如何？",pid);
									say("现在已没事了，多谢，多谢……");
								end,
							},
					[8]=	{
								[0]=function()
									say("好弟弟~你这么盯着姐姐~是想和姐姐玩么~",pid);
								end,
								[1]=function()
									say("好弟弟~姐姐累了~不知弟弟为啥会找上姐姐呢~",pid);
									say("无他，看你不顺尔。");
									say("嘻嘻，那下次再来找姐姐继续玩吧~",pid);
								end,
								[2]=function()
									say("好弟弟~累了么~",pid);
									say("技不如人，无话可说！");
									say("嘻嘻~",pid);
								end,
								[3]=function()
									say("姐姐误会了，小弟只是想到了其他之事，一时有些情不自禁而已。");
									say("这样啊~那下次记得找姐姐玩啊~",pid);
									say("一定，一定……");
								end,
							},
					[9]=	{
								[0]=function()
									say("这位公子，小女子可是有何过错，在此向公子赔罪了。",pid);
								end,
								[1]=function()
									say("……公子武功高强，小女子自愧弗如。只是还望公子明示，小女子有何过错？",pid);
									say("无他，看你不顺尔。");
									say("……原来如此，多谢公子告之，小女子告退！",pid);
								end,
								[2]=function()
									say("公子，不知小女子究竟有何错过，还望公子明示。",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("姑娘误会了，在下只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，还望公子保重。",pid);
									say("有礼了，有礼了……");
								end,
							},
					[10]=	{
								[0]=function()
									say("这位兄台，本姑娘可是曾招惹过你？",pid);
								end,
								[1]=function()
									say("……你功夫厉害，本姑娘打不过你。不过你总该告诉本姑娘这架是为什么而打的吧……",pid);
									say("无他，看你不顺尔。");
									say("……明白了，告辞，哼！",pid);
								end,
								[2]=function()
									say("你打不过本姑娘的，不过你为啥要攻击本姑娘？",pid);
									say("技不如人，无话可说！");
									say("这……",pid);
								end,
								[3]=function()
									say("女侠误会了，我只是想到其他之事，一时有些情不自禁而已。");
									say("原来如此，可是有何难处？需要本姑娘帮你不？",pid);
									say("多谢抬爱，不敢劳烦女侠，在下可以自行处理。");
								end,
							},
				}
	local xg=JY.Person[pid]["闲聊"];
	msg[xg][0]();
	if DrawStrBoxYesNo(-1,-1,"是否确定要袭击"..JY.Person[pid]["姓名"]) then
		say("不必废话，看打！");
		if CommonFight(pid) then
			JY.Person[pid]["友好"]=-1;
			local skip=false;
			for ci,cv in pairs(PE.fight) do
				if cv.trigger(true)==1 then
					cv.go(true);
					skip=true;
					break;
				end
			end
			if not skip then
				msg[xg][1]();
			end
		else
			AddPersonAttrib(pid,"友好",-30);
			local skip=false;
			for ci,cv in pairs(PE.fight) do
				if cv.trigger(false)==1 then
					cv.go(false);
					skip=true;
					break;
				end
			end
			if not skip then
				msg[xg][2]();
			end
		end
	else
		msg[xg][3]();
	end
end
function CommonFight(pid)
	local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
	WAR={};
	WAR.Data={};
	WAR.Data["代号"]=0;
	WAR.Data["名称"]="战斗";
	WAR.Data["地图"]=JY.SubScene;
	if JY.Person[pid]["等级"]<16 then
		WAR.Data["音乐"]=307;
	elseif JY.Person[pid]["等级"]<31 then
		WAR.Data["音乐"]=305;
	elseif JY.Person[pid]["等级"]<46 then
		WAR.Data["音乐"]=304;
	elseif JY.Person[pid]["等级"]<51 then
		WAR.Data["音乐"]=303;
	end
	WAR.Data["经验"]=50--EXP;
	
	WAR.Data["自动选择参战人"  .. 1]=0;
	WAR.Data["我方X"  .. 1]=JY.Base["人X1"];
	WAR.Data["我方Y"  .. 1]=JY.Base["人Y1"];
	WAR.Data["敌人"  .. 1]=pid;
	WAR.Data["敌方X"  .. 1]=2;
	WAR.Data["敌方Y"  .. 1]=2;
	local result=WarMain(998,1);
	lib.LoadSur(sid,0,0);
	return result;
end
function CommonEvent(eventid,pid)
	if pid<=0 then
		return true;
	end
	local msg=	{
					[0]=	{
								[0]=function()
									say("有什么事吗？",pid);
								end,
								[1]=function()
									say("就此别过，日后有缘再见！",pid);
								end,
							},
					[1]=	{
								[0]=function()
									say("有什么要我帮忙吗？",pid);
								end,
								[1]=function()
									say("山高水长，后会有期！",pid);
								end,
							},
					[2]=	{
								[0]=function()
									say("你要干嘛！",pid);
								end,
								[1]=function()
									say("这就要走了啊！",pid);
								end,
							},
					[3]=	{
								[0]=function()
									say("何事？",pid);
								end,
								[1]=function()
									say("再见！",pid);
								end,
							},
					[4]=	{
								[0]=function()
									say("此处相遇，真是有缘啊！",pid);
								end,
								[1]=function()
									say("青山不改，绿水长流！他年相见，后会有期！",pid);
								end,
							},
					[5]=	{
								[0]=function()
									say("不知有什么事情要指教在下？",pid);
								end,
								[1]=function()
									say("再会，请慢走。",pid);
								end,
							},
					[6]=	{
								[0]=function()
									say("阿弥陀佛。",pid);
								end,
								[1]=function()
									say("阿弥陀佛！",pid);
								end,
							},
					[7]=	{
								[0]=function()
									say("贫道有礼了",pid);
								end,
								[1]=function()
									say("你我缘尽于此，回去吧．．",pid);
								end,
							},
					[8]=	{
								[0]=function()
									say("找姐姐我去做什么？",pid);
								end,
								[1]=function()
									say("怎么这就要走了啊",pid);
								end,
							},
					[9]=	{
								[0]=function()
									say("有什么事吗？",pid);
								end,
								[1]=function()
									say("就此别过，日后有缘再见！",pid);
								end,
							},
					[10]=	{
								[0]=function()
									say("有什么事吗？",pid);
								end,
								[1]=function()
									say("就此别过，日后有缘再见！",pid);
								end,
							},
				}
	if JY.Person[pid]["友好"]==0 then
		FirstTalk(pid);
		--[[
		DayPass(1);
		SetD(JY.SubScene,JY.CurrentD,0,0);
		SetD(JY.SubScene,JY.CurrentD,3,-1);
		SetD(JY.SubScene,JY.CurrentD,5,0);
		SetD(JY.SubScene,JY.CurrentD,6,0);
		SetD(JY.SubScene,JY.CurrentD,7,0);
		--return;
		]]--
	elseif JY.Person[pid]["友好"]<0 then
		say("我不想见到你。",pid);
		DayPass(1);
		Dark();
			SetD(JY.SubScene,JY.CurrentD,0,0);
			SetD(JY.SubScene,JY.CurrentD,3,-1);
			SetD(JY.SubScene,JY.CurrentD,5,0);
			SetD(JY.SubScene,JY.CurrentD,6,0);
			SetD(JY.SubScene,JY.CurrentD,7,0);
		Light();
		return;
	end
	local xg=JY.Person[pid]["闲聊"];
	local menu={
					{"聊天",nil,1},
					{"喝酒",nil,0},
					{"赌博",nil,0},
					{"打听",nil,1},
					{"袭击",nil,1},
					{"状态",nil,1},
					{"没事",nil,1},
				};
	if eventid==1 then
		--路边
	elseif eventid==2 then
		--酒馆
		menu[2][3]=1;
	elseif eventid==3 then
		--赌场
		menu[3][3]=1;
	elseif eventid==4 then
		--客栈
	elseif eventid==5 then
		--待定
	else
	end
	if JY.Person[0]["门派"]>=0 and JY.Person[0]["门派"]==JY.Person[pid]["门派"] then
		menu[5][3]=0;
	end
while true do
	msg[xg][0]();
	local r=ShowMenu(menu,7,0,0,0,0,0,1,0);
	if r==1 then
		RandomEvent(pid);
		break;
	elseif r==2 then
		CommonDrink(pid);
		break;
	elseif r==3 then
		CommonGamble(pid);
		break;
	elseif r==4 then
		Query(pid);
		DayPass(1);
	elseif r==5 then
		CommonFight_Shell(pid);
		break;
	elseif r==6 then
		PersonStatus(pid);
	elseif r==7 then
		msg[xg][1]();
		break;
	end
end
	Dark();
			SetD(JY.SubScene,JY.CurrentD,0,0);
			SetD(JY.SubScene,JY.CurrentD,3,-1);
			SetD(JY.SubScene,JY.CurrentD,5,0);
			SetD(JY.SubScene,JY.CurrentD,6,0);
			SetD(JY.SubScene,JY.CurrentD,7,0);
			local fid=JY.Person[pid]["门派"];
			if fid>=0 then
				JY.Person[pid]["所在"]=JY.Shop[fid]["据点"];
			end
	Light();
end

function PersonRePosition(sid)
	CityNPCUpdate[sid]=GetFlag(1);
	local sidtable={1,38,40,109,112,130,131,132,133,134};
	local flag=true;
	for i,v in pairs(sidtable) do
		if sid==v then
			flag=false;
			break;
		end
	end
	if flag then
		return;
	end
	local p={};
	local d={};
	local num=0;
	for i=1,CC.ToalPersonNum do
		if JY.Person[i]["所在"]==sid then
			table.insert(p,i);
			num=num+1;
		end
	end
	--打乱
	if num>1 then
		p=TableRandom(p);
	end
	--统计
	local dnum1,dnum2=0,0;
	for i=0,199 do
		if GetD(JY.SubScene,i,2)>1000 then
			dnum1=dnum1+1;
			local id=GetD(JY.SubScene,i,3);
			if id>0 and JY.Person[id]["所在"]==sid then
				for ii,v in pairs(p) do
					if v==id then
						table.remove(p,ii);
						break;
					end
				end
			else
				dnum2=dnum2+1;
				table.insert(d,i);
				SetD(JY.SubScene,i,0,0);
				SetD(JY.SubScene,i,3,-1);
				SetD(JY.SubScene,i,5,0);
				SetD(JY.SubScene,i,6,0);
				SetD(JY.SubScene,i,7,0);
			end
		end
	end
	--根据场景D数量，调整npc出现几率
	local blgl=0;
	if dnum2<10 then
		blgl=4;
	elseif dnum2<20 then
		blgl=3;
	elseif dnum2<30 then
		blgl=2;
	elseif dnum2<40 then
		blgl=1;
	end
	--打乱
	if dnum2>1 then
		d=TableRandom(d);
	end
	--重设
	--赌场单独考虑
	for i,v in pairs(d) do
		if GetD(JY.SubScene,v,2)==1003 and Rnd(10)<blgl+6 then
			for ii,id in pairs(p) do
				local gl=JY.Person[id]["赌博"]*10;
				if Rnd(100)<gl then
					table.remove(p,ii);
					SetD(JY.SubScene,v,0,1);
					SetD(JY.SubScene,v,3,id);
					SetD(JY.SubScene,v,5,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					SetD(JY.SubScene,v,6,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					SetD(JY.SubScene,v,7,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					break;
				end
			end
			
		end
	end
	--酒馆单独考虑
	for i,v in pairs(d) do
		if GetD(JY.SubScene,v,2)==1002 and Rnd(10)<blgl+7 then
			for ii,id in pairs(p) do
				local gl=JY.Person[id]["饮酒"]*10;
				if Rnd(100)<gl then
					table.remove(p,ii);
					SetD(JY.SubScene,v,0,1);
					SetD(JY.SubScene,v,3,id);
					SetD(JY.SubScene,v,5,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					SetD(JY.SubScene,v,6,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					SetD(JY.SubScene,v,7,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
					break;
				end
			end
			
		end
	end
	--其他
	for i,v in pairs(d) do
		if GetD(JY.SubScene,v,2)==1001 and Rnd(10)<blgl+5 then
			if p[1]==nil then
				break;
			else
				local id=p[1] or 0;
				table.remove(p,1);
				SetD(JY.SubScene,v,0,1);
				SetD(JY.SubScene,v,3,id);
				SetD(JY.SubScene,v,5,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
				SetD(JY.SubScene,v,6,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
				SetD(JY.SubScene,v,7,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
			end
		end
	end
end

function PersonMove()
	local sid={	1,38,40,109,112,
				130,131,132,133,134};
	local snum=10;
	for i=1,CC.ToalPersonNum do
		if JY.Person[i]["身份"]>0 and JY.Person[i]["登场"]==1 then
			if JY.Person[i]["所在"]~=-1 then
				local gl=JY.Person[i]["外出"];
				if Rnd(10)<gl then
					JY.Person[i]["所在"]=sid[math.random(snum)];
				else
					local fid=JY.Person[i]["门派"];
					if fid>=0 then
						JY.Person[i]["所在"]=JY.Shop[fid]["据点"];
					end
				end
			end
		end
	end
	CityNPCUpdate={};
end

function CommonGamble(pid)
	local xg=JY.Person[pid]["闲聊"];
	local name1=JY.Person[0]["姓名"];
	local name2=JY.Person[pid]["姓名"];
	local msg=	{
					[0]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."兄相邀，当不辞。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("多谢"..name1.."兄，不过今日算了，来日有机会，定当遵从。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈哈，某今日也是罕有的手顺。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("阴阳怪调，找打！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，在下少陪了，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄何必如此刻薄？",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[1]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("某正好有些手痒，来过两招吧。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("今日就算了，某看一会便走。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈哈，他奶奶的，今天爷爷这手气真邪了门了。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("牙尖嘴利，找打！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，某是瞎了眼了，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，某完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄何必如此刻薄？",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[2]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("他奶奶的，看爷爷我如何大杀四方！",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("他奶奶的，爷爷为啥要跟你小子赌？",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈哈，一时运气而已。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑爷爷作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("哇啊啊啊！找打！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，爷爷就不该跟你玩！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，他奶奶的，你小子有如神助，爷爷完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say("你小子虽然赢了，但是说话也别这么难听啊。",pid);
										say("说我？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！他奶奶的！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这混小子给爷爷记着！哼！",pid);
										end
									end
								end,
							},
					[3]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("……来。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("……免了。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("……运气。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("……我作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("……看招！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("……哼！");
									else
										say("……呸！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("……不赌了，胜不了。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say("……难看。",pid);
										say("说我？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("……哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("……哼！",pid);
										end
									end
								end,
							},
					[4]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("哈哈哈哈，好，今日便和"..name1.."兄来玩两把。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("今日有些不便，来日定当和"..name1.."兄赌个痛快！",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈，今日手风不错，"..name1.."兄，承让了。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("大丈夫，有话直说，何必如此阴阳怪气！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，在下识人不明，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄此话所讲，未免伤及和气。",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[5]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."兄有命，在下自是不敢不从。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."兄见谅，今日在下手风不顺，就不下场了。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."公子今日有如神助，在下不能胜，甘拜下风啊。");
									say("不敢不敢，还得多谢"..name1.."兄手下留情。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."公子今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."公子呢？我说的贵人，自然指的是那赌坊之神。");
									say("子不语，怪力乱神。你不必借此讥讽！",pid);
									if CommonFight(pid) then
										say(name2.."公子如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，是在下双目蒙尘，不识人心，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄此言，未免有些太过。",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[6]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."兄相邀，当不辞。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("多谢"..name1.."兄，不过今日算了，来日有机会，定当遵从。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈哈，一时运气而已。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("阴阳怪调，找打！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，在下少陪了，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄何必如此刻薄？",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[7]=	{
								[0]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."兄相邀，当不辞。",pid);
								end,
								[1]=function()
									say(name2.."兄。观之有何趣味，既来之，何不下场一赌？");
									say("多谢"..name1.."兄，不过今日算了，来日有机会，定当遵从。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."兄今日有如神助，在下不能胜，甘拜下风啊。");
									say("哈哈哈哈，一时运气而已。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."兄今日有贵人相助，在下不能胜矣。");
									say("嗯？你可是怀疑我串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."兄呢？我说的贵人，自然指的是那赌坊之神。");
									say("阴阳怪调，找打！",pid);
									if CommonFight(pid) then
										say(name2.."兄如此恼羞成怒，可是被我说中了？",pid);
										say("哼！");
									else
										say("想不到你如此输不起，在下少陪了，哼！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say(name1.."兄何必如此刻薄？",pid);
										say("说我刻薄？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("你这厮好生无礼！哼！",pid);
										end
									end
								end,
							},
					[8]=	{
								[0]=function()
									say(name2.."姐姐。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."好弟弟~姐姐就来陪你玩玩~",pid);
								end,
								[1]=function()
									say(name2.."姐姐。观之有何趣味，既来之，何不下场一赌？");
									say("好弟弟~姐姐今天有点累了~下次吧~",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."姐姐今日有如神助，在下不能胜，甘拜下风啊。");
									say("好弟弟~姐姐今天玩的很开心啊~",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."姐姐今日有贵人相助，在下不能胜矣。");
									say("好弟弟~你可是怀疑姐姐串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."姐姐呢？我说的贵人，自然指的是那赌坊之神。");
									say("油嘴滑舌~讨打~",pid);
									if CommonFight(pid) then
										say(name2.."X姐姐何必羞恼，可是被我说中了？",pid);
										say("嘻嘻~人家不玩了~");
									else
										say("原来弟弟如此输不起啊~下次姐姐会让着你的~");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("嘻嘻~弟弟有如神助，人家不玩了~",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say("咦？姐姐还真相见识见识弟弟有多厉害呢~",pid);
										say("找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("姐姐好怕~不跟你玩了~",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("姐姐怎么会这么做呢~嘻嘻~不跟你玩了~",pid);
										end
									end
								end,
							},
					[9]=	{
								[0]=function()
									say(name2.."姑娘。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."还望公子手下留情。",pid);
								end,
								[1]=function()
									say(name2.."姑娘。观之有何趣味，既来之，何不下场一赌？");
									say("小女子今日不便，不欲下场，请公子恕罪。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."姑娘今日有如神助，在下不能胜，甘拜下风啊。");
									say("是公子有心谦让而已。",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."姑娘今日有贵人相助，在下不能胜矣。");
									say("咦？公子此言可是怀疑小女子串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."姑娘呢？我说的贵人，自然指的是那赌坊之神。");
									say("公子莫欺人太甚。",pid);
									if CommonFight(pid) then
										say(name2.."姑娘何必羞恼，可是被我说中了？",pid);
										say("公子说是便是吧，小女子恕不奉陪。");
									else
										say("不曾想公子竟是如此之人，小女子好生失望，先行告退。");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("公子有如神助，小女子胜之不能。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say("公子请自持身份。",pid);
										say("说教？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("小女子技不如人，无话可说。",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("公子此言诛心，还望自重。",pid);
										end
									end
								end,
							},
					[10]=	{
								[0]=function()
									say(name2.."女侠。观之有何趣味，既来之，何不下场一赌？");
									say(name1.."来便来，本姑娘不怕你。",pid);
								end,
								[1]=function()
									say(name2.."女侠。观之有何趣味，既来之，何不下场一赌？");
									say("你？回去练练再来找本姑娘吧。",pid);
								end,
								[2]=function()
									say("不来了不来了，"..name2.."女侠今日有如神助，在下不能胜，甘拜下风啊。");
									say("那是，本姑娘是谁？",pid);
								end,
								[3]=function()
									say("不来了不来了，"..name2.."女侠今日有贵人相助，在下不能胜矣。");
									say("咦？你是说本姑娘串通赌场作弊？",pid);
									say("我怎么敢怀疑"..name2.."女侠呢？我说的贵人，自然指的是那赌坊之神。");
									say("口蜜腹剑，找打！",pid);
									if CommonFight(pid) then
										say(name2.."女侠何必羞恼，可是被我说中了？",pid);
										say("哼！");
									else
										say("本姑娘想不到你居然是这种人！");
										say("可恶……",pid);
									end
								end,
								[4]=function()
									say("不来了不来了，"..name1.."兄有如神助，在下完全胜不了啊。",pid);
									local menu=	{
													{"哪里哪里，都是运气而已。",1},
													{"明智之举，不然必叫你见识见识我的厉害。",1},
												};
									local sel=GenSelection(menu);
									if sel==1 then
										say("哪里哪里，都是运气而已。");
									else
										say("明智之举，不然必叫你见识见识我的厉害。");
										say("不用说到这个份上吧？",pid);
										say("说教？找打！");
										if CommonFight(pid) then
											say("赌也赌不过，打也打不过，看来你报仇无望咯。");
											say("哼！",pid);
										else
											say("怎么？赌不过就用武力压人？");
											say("本姑娘还不屑那么做！",pid);
										end
									end
								end,
							},
				}
	if Rnd(10)<8 then
		msg[xg][0]();
		local m1,m2=Gamble1(pid);
		if m1>200 and m2<200 and m1-m2>=100 then
			msg[xg][4]();
		elseif m1<200 and m2>200 then--and m2-m1>=100 then
			if m2-m1>=100 then
				msg[xg][3]();
			else
				msg[xg][2]();
				AddPersonAttrib(pid,"友好",10);
			end
		end
		--[[
		if r==1 then
			msg[xg][2]();
		elseif r==2 then
			msg[xg][3]();
		elseif r==3 then
			msg[xg][4]();
		elseif r==4 then
		
		else
		
		end]]--
	else
		msg[xg][1]();
	end
end
function Gamble1(pid)
	local player={};
	player.name={"庄家",JY.Person[pid]["姓名"],JY.Person[0]["姓名"],"赌徒"};--{"JY027","赌徒","主角","KA",}--JY.Person[pid]["姓名"],JY.Person[0]["姓名"]
	player.money={1000,200,200,200};
	player.dz={0,0,0,0};
	player.talk={"","","",""}--{"大家好*本版无版规，follow总坛规即可*游戏制作中，本版暂时只作宣传之用","都不让发帖，太无耻了！","恭喜开版！","这什么破版规！*版主都不在！"};
	player.talkx={CC.ScreenW/2+CC.Fontbig*3,CC.Fontbig,CC.ScreenW/2+CC.Fontbig*3,-CC.Fontbig};
	player.talky={CC.Fontbig,CC.ScreenH/2-CC.Fontbig-CC.Fontsmall-CC.MenuBorderPixel*4,CC.ScreenH-CC.Fontbig*3-CC.MenuBorderPixel*2,CC.ScreenH/2-CC.Fontbig-CC.Fontsmall-CC.MenuBorderPixel*4};
	local function redraw()
		if JY.WindowReSizeFlag then
			JY.WindowReSizeFlag=false;
			player.talkx={CC.ScreenW/2+CC.Fontbig*3,CC.Fontbig,CC.ScreenW/2+CC.Fontbig*3,-CC.Fontbig};
			player.talky={CC.Fontbig,CC.ScreenH/2-CC.Fontbig-CC.Fontsmall-CC.MenuBorderPixel*4,CC.ScreenH-CC.Fontbig*3-CC.MenuBorderPixel*2,CC.ScreenH/2-CC.Fontbig-CC.Fontsmall-CC.MenuBorderPixel*4};
		end
		lib.FillColor(0,0,0,0,0);
		lib.PicLoadCache(1,901*2,CC.ScreenW/2,CC.ScreenH/2);
		DrawStrBox_1(-1,CC.Fontbig,string.format("%s*银两:%4d两",player.name[1],player.money[1]),C_WHITE,CC.Fontbig);
		DrawStrBox_1(CC.Fontbig,-1,string.format("%s*银两:%4d两",player.name[2],player.money[2]),C_WHITE,CC.Fontbig);
		DrawStrBox_1(-1,-CC.Fontbig,string.format("%s*银两:%4d两",player.name[3],player.money[3]),C_WHITE,CC.Fontbig);
		DrawStrBox_1(-CC.Fontbig,-1,string.format("%s*银两:%4d两",player.name[4],player.money[4]),C_WHITE,CC.Fontbig);
		for i=1,4 do
			if player.talk[i]~="" then
				DrawStrCircleBox(player.talkx[i],player.talky[i],player.talk[i],C_WHITE,CC.Fontsmall);
			end
		end
	end
	local function touzi()
		--local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
		for i=3,14 do
			--lib.LoadSur(sid,0,0);
			redraw();
			lib.PicLoadCache(1,(900+i)*2,CC.ScreenW/2,CC.ScreenH/2-120);
			ShowScreen();
			Delay(1);
			getkey();
		end
		local num1,num2=math.random(6),math.random(6);
		if Rnd(100)<80-60 then--JY.Person[0]["福缘"] then
			if (num1+num2>6 and player.dz[3]<0) or (num1+num2<7 and player.dz[3]>0) then
				num1,num2=math.random(6),math.random(6);
			end
		elseif Rnd(100)>30*2 then
			if (num1+num2>6 and player.dz[3]>0) or (num1+num2<7 and player.dz[3]<0) then
				num1,num2=math.random(6),math.random(6);
			end
		end
		--lib.LoadSur(sid,0,0);
		redraw();
		lib.PicLoadCache(1,(914+num1)*2,CC.ScreenW/2-15+Rnd(5)-Rnd(5),CC.ScreenH/2-43+Rnd(5)-Rnd(5));
		lib.PicLoadCache(1,(914+num2)*2,CC.ScreenW/2+35+Rnd(5)-Rnd(5),CC.ScreenH/2-35+Rnd(5)-Rnd(5));
		ShowScreen();
		Delay(9);
		getkey();
		--lib.FreeSur(sid);
		return num1+num2;
	end
	local function ShowResult(s)
		DrawStrNewBox(-1,CC.ScreenH/2+CC.Fontbig,s,C_WHITE,CC.FontBig);
		ShowScreen();
		Delay(2);
		WaitKey();
	end
	local T={"一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二十一",};
	local T2={"十","二十","三十","四十","五十","六十","七十","八十","九十","一百","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error","Error",};
	local winmsg={"手气不错！","早知道就多下点！","庄家快赔钱！","哈哈！看我大杀四方！","是不是该见好就收呢？",
				"再赢一把就收手。","呵呵，不好意思我赢了！","多谢财神爷保佑！","发财了！发财了！","下一把继续赢！"};
	local losemsg={"真晦气！","幸好没多下。","庄家你不会是作弊吧。","再输就不玩了！","下次一定要赢！",
				"怎么又输了呢？","再输就要当裤子了！","钱财本是身外物。","应该看看黄历再出来赌的！","不是吧！老本都要输没了！"};
	local times=0;
	while true do
		times=times+1;
		for i=1,4 do
			player.talk[i]="";
		end
		redraw();
		ShowScreen();
		Delay(5);
		getkey();
		player.talk[1]="下注下注！";
		redraw();
		ShowScreen();
		Delay(10);
		getkey();
		for i=2,4 do
			if i==3 then
				local m1={{"十两",nil,1},{"二十两",nil,1},{"三十两",nil,1},{"四十两",nil,1},{"五十两",nil,1},};
				local m2={{"大",nil,1},{"小",nil,1}};
				player.talk[1]="客官，押多少？";
				redraw();
				ShowScreen();
				Delay(5);
				getkey();
				player.dz[i]=ShowMenu(m1,5,0,-1,-1,0,0,1,0,CC.Fontbig,C_ORANGE,C_WHITE);
				player.talk[1]="押大还是押小？";
				redraw();
				ShowScreen();
				Delay(5);
				getkey();
				if ShowMenu(m2,2,0,-1,-1,0,0,1,0,CC.Fontbig,C_ORANGE,C_WHITE)==1 then
					player.talk[i]=T2[player.dz[i]].."两，大！";
					player.dz[i]=player.dz[i]*10;
				else
					player.talk[i]=T2[player.dz[i]].."两，小！";
					player.dz[i]=-player.dz[i]*10;
				end
			else
				player.dz[i]=(1+math.max(Rnd(6)-Rnd(3),0));
				if Rnd(2)==1 then
					player.talk[i]=T2[player.dz[i]].."两，大！";
					player.dz[i]=player.dz[i]*10;
				else
					player.talk[i]=T2[player.dz[i]].."两，小！";
					player.dz[i]=-player.dz[i]*10;
				end
			end
			redraw();
			ShowScreen();
			Delay(7);
			getkey();
		end
		player.talk[1]="买定离手了！";
		redraw();
		ShowScreen();
		for i=2,4 do
			player.talk[i]="";
		end
		Delay(10);
		getkey();
		local num=touzi();
		if num>=12 then
			ShowResult(T[num].."点，庄家通杀");
			redraw();
			player.talk[1]="哈哈，通杀通杀！";
			redraw();
			ShowScreen();
			Delay(5);
			getkey();
			for i=2,4 do
				player.money[i]=player.money[i]-math.abs(player.dz[i]);
				player.money[1]=player.money[1]+math.abs(player.dz[i]);
				player.dz[i]=0;
				DrawStrBox(player.talkx[i],player.talky[i],losemsg[math.random(10)],C_WHITE,CC.Fontsmall);
				ShowScreen();
				Delay(5);
				getkey();
			end
		elseif num>6 then
			ShowResult(T[num].."点大");
			redraw();
			player.talk[1]=T[num].."点大";
			redraw();
			ShowScreen();
			Delay(5);
			getkey();
			for i=2,4 do
				player.money[i]=player.money[i]+player.dz[i];
				player.money[1]=player.money[1]-player.dz[i];
				if player.dz[i]>0 then
					player.talk[i]=winmsg[math.random(10)];
				else
					player.talk[i]=losemsg[math.random(10)];
				end
				player.dz[i]=0;
				redraw();
				ShowScreen();
				Delay(5);
				getkey();
			end
		else
			ShowResult(T[num].."点小");
			redraw();
			player.talk[1]=T[num].."点小";
			redraw();
			ShowScreen();
			Delay(5);
			getkey();
			for i=2,4 do
				player.money[i]=player.money[i]-player.dz[i];
				player.money[1]=player.money[1]+player.dz[i];
				if player.dz[i]<0 then
					player.talk[i]=winmsg[math.random(10)];
				else
					player.talk[i]=losemsg[math.random(10)];
				end
				player.dz[i]=0;
				redraw();
				ShowScreen();
				Delay(5);
				getkey();
			end
		end
		DayPass(1);
		local overflag=false;
		for i=1,4 do
			if player.money[i]<=10 then
				for j=1,4 do
					player.talk[j]="";
				end
				player.talk[i]="没钱了......";
				overflag=true;
				break;
			end
		end
		--
		redraw();
		ShowScreen();
		Delay(5);
		if overflag then
			if times<3 then
				player.talk[2]="怎么这么快就不玩了？*真扫兴！";
				redraw();
				ShowScreen();
				Delay(8);
			end
			break;
		end
		--
		if not DrawStrBoxYesNo(-1,-1,"还继续玩吗？") then
			for i=1,4 do
				player.talk[i]="";
			end
			if player.money[3]>300 then
				player.talk[3]="哈哈，赢了赢了！*我还有事，先走啦！";
			elseif player.money[3]<150 then
				player.talk[3]="不玩了，今天运气太差！";
			else
				player.talk[3]="我还有事，先走了。";
			end
			redraw();
			ShowScreen();
			Delay(8);
			if times<3 then
				player.talk[2]="怎么这么快就不玩了？*真扫兴！";
				redraw();
				ShowScreen();
				Delay(8);
			end
			break;
		end
	end
	for i,v in pairs({4,3,2}) do
		if player.money[v]<50 then
			player.talk[v]="棺材本都输没了！*不玩了不玩了！";
		elseif player.money[v]<160 then
			player.talk[v]="怎么这就不玩了？*我还要翻本啊！！";
		elseif player.money[v]<200 then
			player.talk[v]="还好没输多少。";
		elseif player.money[v]==200 then
			player.talk[v]="没输没赢，这算啥？";
		elseif player.money[v]>400 then
			player.talk[v]="发了，发了！！！";
		elseif player.money[v]>300 then
			player.talk[v]="哈哈，小赢了一点点。";
		elseif player.money[v]>240 then
			player.talk[v]="今天手气还行。";
		else
			player.talk[v]="明天咱们再来啊。";
		end
		redraw();
		ShowScreen();
		Delay(8);
	end
	if player.money[1]<300 then
		player.talk[1]="要亏死了！*求求你下次去别家吧！";
	elseif player.money[1]>1000 then
		player.talk[1]="哥几个下次再来啊！";
	else
		player.talk[1]="各位请慢走。";
	end
	redraw();
	ShowScreen();
	Delay(8);
	Delay(10);
	WaitKey();
	return player.money[3],player.money[2],player.money[4],player.money[1];--主角，NPC，赌徒，庄家
	--dubo1(pid);
end



