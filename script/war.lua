---------------------------------------------------------------------------
---------------------------------战斗-----------------------------------
--入口函数为WarMain，由战斗指令调用

--设置战斗全程变量
function WarSetGlobal()            --设置战斗全程变量
    --WAR={};

    --WAR.Data={};              --战斗信息，war.sta文件

    WAR.SelectPerson={}            --设置选择参战人  0 未选，1 选，不可取消，2 选，可取消。选择参展人菜单调用使用

    WAR.Person={};                 --战斗人物信息
    for i=0,49 do
        WAR.Person[i]={};
        WAR.Person[i]["人物编号"]=-1;
        WAR.Person[i]["我方"]=true;            --true 我方，false敌人
        WAR.Person[i]["坐标X"]=-1;
        WAR.Person[i]["坐标Y"]=-1;
        WAR.Person[i]["死亡"]=true;
        WAR.Person[i]["人方向"]=-1;
        WAR.Person[i]["贴图"]=-1;
        WAR.Person[i]["贴图类型"]=0;        --0 wmap中贴图，1 fight***中贴图
        WAR.Person[i]["轻功"]=0;
        WAR.Person[i]["移动步数"]=0;
        WAR.Person[i]["点数"]={[0]=0,};
        WAR.Person[i]["atk点数"]={[0]=0,};
        WAR.Person[i]["经验"]=0;
        WAR.Person[i]["自动选择对手"]=-1;     --自动战斗中每个人选择的战斗对手
		WAR.Person[i]["Time"]=0;
		WAR.Person[i]["TimeAdd"]=0;
		WAR.Person[i]["招架"]=-1;
		WAR.Person[i]["骨折"]=0;
		WAR.Person[i]["封穴"]=0;
		WAR.Person[i]["吃力"]=0;
		WAR.Person[i]["恍惚"]=0;
		WAR.Person[i]["入魔"]=0;
		WAR.Person[i]["RP"]=0;
		WAR.Person[i]["AI"]={};
							--[[{	
								0,		--0手动,1自动,2自动且不可取消,3原地待命,4移动到目标
								0,		-->0聪明,<0笨,绝对值越大,行动越随意
								0,		--0,远离敌人,>0,尽量和敌人保持的距离
								0,		--
								0,		--
							};]]--
		--AI:0手动1自动2不可取消的自动3只休息4只攻击5只逃跑
		--AI:0手动 1自动，弱智(我方用) 2自动，靠近敌人 3，自动，远离敌人 4坚守原地，反击 5移动到目标
		WAR.Person[i]["特效动画"]=-1;
		WAR.Person[i]["反击武功"]=-1;
		WAR.Person[i]["特效文字1"]=-1;
		WAR.Person[i]["特效文字2"]=-1;
		WAR.Person[i]["特效文字3"]=-1;
   end

    WAR.PersonNum=0;               --战斗人物个数
	WAR.Delay=0;					--延时时间
	WAR.LifeNum=0;					--存活人数

    WAR.CurID=-1;                  --当前操作战斗人id

	WAR.ShowHead=0;                --是否显示头像

    WAR.Effect=0;              --效果，用来确认人物头上数字的颜色
	                           --2 杀生命 , 3 杀内力, 4 医疗 ， 5 用毒 ， 6 解毒

    WAR.EffectColor={};      ---定义人物头上数字的颜色
    WAR.EffectColor[2]=RGB(236, 200, 40);
    WAR.EffectColor[3]=RGB(112, 12, 112);
    WAR.EffectColor[4]=RGB(236, 200, 40);
    WAR.EffectColor[5]=RGB(96, 176, 64)
    WAR.EffectColor[6]=RGB(104, 192, 232);

	WAR.EffectXY=nil            --保存武功效果产生的坐标
	WAR.EffectXYNum=0;          --坐标个数
	WAR["攻击"]=0;
	WAR["防御"]=0;
	WAR["身法"]=0;
	WAR.tmp={}
	WAR.Evade={[0]=0,}
--[[
		JY.Sight=200
		JY.Light=200
		setBright()]]--
end

--加载战斗数据
function WarLoad(warid)              --加载战斗数据
    WarSetGlobal();         --初始化战斗变量
	--[[
    local data=Byte.create(CC.WarDataSize);      --读取战斗数据
    Byte.loadfile(data,CC.WarFile,warid*CC.WarDataSize,CC.WarDataSize);
    LoadData(WAR.Data,CC.WarData_S,data);
	]]--
end

--战斗主函数
--warid  战斗编号
--isexp  输后是否有经验 0 没经验，1 有经验
--返回  true 战斗胜利，false 失败
function WarMain(warid,isexp)           --战斗主函数
	local tlbak=JY.Person[0]["体力"];
    --lib.Debug(string.format("war start. warid=%d",warid));
    WarLoad(warid);
    WarSelectTeam();          --选择我方
    WarSelectEnemy();         --选择敌人
    CleanMemory()
    --lib.PicInit();
 	lib.ShowSlow(50,1) ;      --场景变暗

    WarLoadMap(WAR.Data["地图"]);       --加载战斗地图

    JY.Status=GAME_WMAP;

	if warid==998 then
		warid=999;
		local x0,y0=WAR.Person[0]["坐标X"],WAR.Person[0]["坐标Y"];--=JY.Base["人X1"],JY.Base["人Y1"];
		local d=JY.Base["人方向"];
		WAR.CurID=0;
		--WAR.Person[0]["坐标X"]=x0;
		--WAR.Person[0]["坐标Y"]=y0;
		local movestep=War_CalMoveStepOld(WAR.CurID,6,0);           --标记每个位置的步数
		local m1={num=0,x={},y={}};
		local m2={num=0,x={},y={}};
		for i=0,6 do
			local step_num=movestep[i].num ;
			if step_num==nil or step_num==0 then
				break;
			end
			--lib.Debug("i="..i..',num='..step_num)
			for j=1,step_num do
				local xx=movestep[i].x[j];
				local yy=movestep[i].y[j];
				if (d==0 and yy<y0) or (d==1 and xx>x0) or (d==2 and xx<x0) or (d==3 and yy>y0) then
					m2.num=m2.num+1;
					m2.x[m2.num]=xx;
					m2.y[m2.num]=yy;
				else
					m1.num=m1.num+1;
					m1.x[m1.num]=xx;
					m1.y[m1.num]=yy;
				end
			end
		end
		for i=1,m1.num-1 do
			for j=i+1,m1.num do
				if Rnd(2)==1 then
					m1.x[i],m1.x[j]=m1.x[j],m1.x[i];
					m1.y[i],m1.y[j]=m1.y[j],m1.y[i];
				end
			end
		end
		for i=1,m2.num-1 do
			for j=i+1,m2.num do
				if Rnd(2)==1 then
					m2.x[i],m2.x[j]=m2.x[j],m2.x[i];
					m2.y[i],m2.y[j]=m2.y[j],m2.y[i];
				end
			end
		end
		local num1,num2=1,1;
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["我方"] then
				if num1<=m1.num then
					WAR.Person[i]["坐标X"]=m1.x[num1];
					WAR.Person[i]["坐标Y"]=m1.y[num1];
					num1=num1+1;
				else
					WAR.Person[i]["坐标X"]=m2.x[num2];
					WAR.Person[i]["坐标Y"]=m2.y[num2];
					num2=num2+1;
				end
			else
				if num2<=m2.num then
					WAR.Person[i]["坐标X"]=m2.x[num2];
					WAR.Person[i]["坐标Y"]=m2.y[num2];
					num2=num2+1;
				else
					WAR.Person[i]["坐标X"]=m1.x[num1];
					WAR.Person[i]["坐标Y"]=m1.y[num1];
					num1=num1+1;
				end
			end
		end
	end
	WarSetDirect();				--设置方向
	--加载贴图文件
--	lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
--	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
--	lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],2);
--	lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);

    PlayMIDI(WAR.Data["音乐"]);

    local warStatus;          --战斗状态

	WarPersonSort();    --战斗人按轻功排序

	--战斗主循环，改成半即时制，重写
	--首先随机决定各人的初始进度值
	local max_jiqi=0;
	for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
		lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[pid]["战斗动作"]),
		                string.format(CC.FightPicFile[2],JY.Person[pid]["战斗动作"]),
						4+i);
		WAR.Person[i]["Time"]=700-(i*1000/(WAR.PersonNum+2))+smagic(pid,42,1);
		WAR.Person[i]["贴图"]=WarCalPersonPic(i);
		if WAR.Person[i]["Time"]>max_jiqi then
			max_jiqi=WAR.Person[i]["Time"];
		end
	end
	if max_jiqi>1000 then
		max_jiqi=max_jiqi-1000;
		for i=0,WAR.PersonNum-1 do
			local pid=WAR.Person[i]["人物编号"];
			WAR.Person[i]["Time"]=WAR.Person[i]["Time"]-max_jiqi;
		end
	end
	WarSetPerson();     --设置战斗人物位置
	WAR.CurID=0
	WarDrawMap(0);
	lib.ShowSlow(50,0)
	warStatus=0;
	WAR.Delay=GetJiqi();
	while true do
		WarDrawMap(0);
		WAR.ShowHead=0;
		DrawTimeBar();
		--lib.Delay(wardelay)

		--如果进度大于1000，则行动
		for p=0,WAR.PersonNum-1 do
			if WAR.Person[p]["死亡"]==false then
				if WAR.Person[p]["Time"]>1000 then 
					WAR.ShowHead=0;
					WarDrawMap(0);
					ShowScreen();
					local surid=lib.SaveSur(CC.ScreenW-80,0,CC.ScreenW,200);
					for i=1,30 do
						local nowtime=lib.GetTime();
						lib.LoadSur(surid,CC.ScreenW-80,0);
						drawname(CC.ScreenW-40,0,JY.Person[WAR.Person[p]["人物编号"]]["姓名"],16+i);
						ShowScreen();
						if i==30 then
							lib.Delay(200+nowtime-lib.GetTime());
						elseif i>20 then
							lib.Delay(i-5+nowtime-lib.GetTime());
						else
							lib.Delay(15+nowtime-lib.GetTime());
						end
						local eventtype,keypress=getkey();
						if WAR.Person[p]["AI"][1]==1 then
							if eventtype==1 then
								if keypress==VK_SPACE or keypress==VK_RETURN or keypress==VK_ESCAPE then
									WAR.Person[p]["AI"]={0,0,0};
								end
							elseif eventtype==3 then
								if keypress==3 then
									WAR.Person[p]["AI"]={0,0,0};
								end
							end
						end
					end
					lib.FreeSur(surid);
					WAR.CurID=p;
					WAR.Person[p]["招架"]=-1;
					War_BeforeAction();
					--WAR.Person[p]["移动步数"]=math.modf(WAR.Person[p]["轻功"]/20)--JY.Person[WAR.Person[p]["人物编号"]]["受伤程度"]/40);
					local r;
					if WAR.Person[p]["人物编号"]==0 then--WAR.Person[p]["我方"]==true and inteam(WAR.Person[p]["人物编号"]) then
						if WAR.Person[p]["AI"][1]==0 then
							if WAR.Person[p]["恍惚"]>0 then
								r=War_Auto();
							else
								r=War_Manual();                  --手动战斗
							end
						else
							r=War_Auto();                  --自动战斗
						end
					else								--不屏蔽敌人行动
						r=War_Auto();                  --自动战斗
					end
					War_AfterAction(r);
					--WAR.Person[p]["TimeAdd"]=WAR.Person[p]["Time"]-1000;		
					WAR.Person[p]["Time"]=WAR.Person[p]["Time"]-1000;
					DrawTimeBar2()
		warStatus=WAR_CALLEVENT(warid);
		if warStatus~=0 then break end					--战场事件入口
		
					warStatus=War_isEnd();        --战斗是否结束？   0继续，1赢，2输
	
					if warStatus>0 then
						break;
					end
				end	
			end
		end	
		if warStatus>0 then
			break;
		end
		WAR.Delay=GetJiqi();
	end
    local r;

	WAR.ShowHead=0;
	if warStatus==1 then
        r=true;
    elseif warStatus==2 then
        r=false;
    end
	
	local meid=WE_getwarid(0);
	if meid==-1 then
		DrawStrBoxWaitKey("战斗结束",C_WHITE,CC.Fontbig);
	else
		if not WAR.Person[meid]["我方"] then
			warStatus=3-warStatus;
		end
		if warStatus==1 then
			DrawStrBoxWaitKey("战斗胜利",C_WHITE,CC.Fontbig);
		else
			DrawStrBoxWaitKey("战斗失败",C_WHITE,CC.Fontbig);
		end
	end

    War_EndPersonData(isexp,warStatus);    --战斗后设置人物参数

    CleanMemory();
    lib.ShowSlow(50,1);
--[[
    if JY.Scene[JY.SubScene]["进门音乐"]>=0 then
        PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"]);
    else
        PlayMIDI(0);
    end

    CleanMemory();
    lib.PicInit();
    lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end
]]--
    JY.Status=GAME_SMAP;
	Init_SMap(2);
	if JY.Person[0]["体力"]>tlbak then
		JY.Person[0]["体力"]=tlbak;
	end
    return r;
end

function DrawTimeBar()
	local x1,x2,y=CC.ScreenW*5/8,CC.ScreenW*15/16,CC.FontSmall*5;
	local xunhuan=true;
	local surid=lib.SaveSur(00,0,x2+5,y*2+2);
	local xscal=limitX(WAR.Delay/10,1,5);
	local delay=WAR.Delay/xscal;
	for i=0,WAR.PersonNum-1 do
		if WAR.Person[i]["死亡"]==false then
			WAR.Person[i]["TimeAdd"]=WAR.Person[i]["TimeAdd"]/xscal;
		end
	end
	while xunhuan do
		local stime=lib.GetTime();
		lib.LoadSur(surid,0,0)
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["死亡"]==false then
				WAR.Person[i]["Time"]=WAR.Person[i]["Time"]+WAR.Person[i]["TimeAdd"];
				if WAR.Person[i]["Time"]>1000 then
					xunhuan=false;
				end
			end
		end
		DrawTimeBar_sub(x1,x2,y,0);
		getkey();
		ShowScreen();
		local passed_t=lib.GetTime()-stime;
		if passed_t<delay then
			lib.Delay(delay-passed_t);
		end
	end
	for i=0,WAR.PersonNum-1 do
		if WAR.Person[i]["死亡"]==false then
			WAR.Person[i]["TimeAdd"]=0;
		end
	end
	lib.Delay(100);
	lib.FreeSur(surid);
end

function DrawTimeBar2()
	local x1,x2,y=CC.ScreenW*5/8,CC.ScreenW*15/16,CC.FontSmall*5;
	local draw;
	local surid=lib.SaveSur(0,0,x2+5,y*2+2);
	while true do
		local stime=lib.GetTime();
		draw=false;
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["死亡"]==false then
				if WAR.Person[i]["TimeAdd"]<0 then
					WAR.Person[i]["Time"]=WAR.Person[i]["Time"]-5;
					WAR.Person[i]["TimeAdd"]=WAR.Person[i]["TimeAdd"]+5;
					draw=true;
				end
			end
		end
		if draw then
			lib.LoadSur(surid,0,0)
			DrawTimeBar_sub(x1,x2,y,1);
			getkey();
			ShowScreen();
			lib.Delay(12+stime-lib.GetTime());
		else
			break;
		end
	end
	lib.Delay(100);
	lib.FreeSur(surid);
end

function DrawTimeBar_sub_old(x1,x2,y,flag)
	x1=x1 or CC.ScreenW*5/8;
	x2=x2 or CC.ScreenW*15/16;
	y=y or CC.FontSmall*5;
	local least=WAR.LifeNum*15;
	if flag==1 then
		least=0;
	end
	DrawBox_1(x1-3,y,x2+3,y+2,C_ORANGE)
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]["死亡"]then
			if WAR.Person[i]["Time"]>least then
				local cx=x1+math.modf((WAR.Person[i]["Time"]-least)*(x2-x1)/(1000-least));
				local color=M_White;
				if WAR.Person[i]["TimeAdd"]<5 then
					--color=M_Silver;
				end
				if WAR.Person[i]["我方"] then
					lib.FillColor(cx-1,CC.FontSmall*4,cx+1,CC.FontSmall*5-2,C_WHITE);
					--lib.LoadPicZoom(1,JY.Person[WAR.Person[i]["人物编号"]]["头像代号"],cx-18,CC.FontSmall*3,25,1);
					drawname(cx,0,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],CC.FontSmall,color)
				else
					lib.FillColor(cx-1,CC.FontSmall*5+2,cx+1,CC.FontSmall*6,C_WHITE);
					--lib.LoadPicZoom(1,JY.Person[WAR.Person[i]["人物编号"]]["头像代号"],cx-18,CC.FontSmall*4+20,25,1);
					drawname(cx,CC.FontSmall*6,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],CC.FontSmall,color)					
				end
			end
		end
	end
end
function DrawTimeBar_sub(x1,x2,y,flag)
	x1=x1 or CC.ScreenW*5/8;
	x2=x2 or CC.ScreenW*15/16;
	y=y or CC.FontSmall*5;
	local least=0;
	if flag==1 then
		DrawBox_1(x1*2-x2,y,x1,y+2,M_Silver);
		least=-1000;
	end
	DrawBox_1(x1-3,y,x2+2,y+2,C_ORANGE)
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]["死亡"]then
			if WAR.Person[i]["Time"]>=least then
				local cx=x1+math.modf(WAR.Person[i]["Time"]*(x2-x1)/1000);
				if flag==2 and WAR.CurID==i then
					cx=x2;
				end
				local color=M_White;
				if WAR.Person[i]["TimeAdd"]<5 then
					--color=M_Silver;
				end
				if WAR.Person[i]["我方"] then
					lib.FillColor(cx-1,CC.FontSmall*4,cx+1,CC.FontSmall*5-2,C_WHITE);
					--lib.LoadPicZoom(1,JY.Person[WAR.Person[i]["人物编号"]]["头像代号"],cx-18,CC.FontSmall*3,25,1);
					drawname(cx,0,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],CC.FontSmall,color)
				else
					lib.FillColor(cx-1,CC.FontSmall*5+2,cx+1,CC.FontSmall*6,C_WHITE);
					--lib.LoadPicZoom(1,JY.Person[WAR.Person[i]["人物编号"]]["头像代号"],cx-18,CC.FontSmall*4+20,25,1);
					drawname(cx,CC.FontSmall*6,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],CC.FontSmall,color)					
				end
			end
		end
	end
end
--返回延时时间，并设置人物集气速度
function GetJiqi(id)
	local num,total=0,0
	local id1,id2;
	if id==nil then
		id1=0;
		id2=WAR.PersonNum-1;
	else
		id1=id;
		id2=id;
	end
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]['死亡'] then
			local id=WAR.Person[i]['人物编号']
			--lib.Debug(id)
			WAR.Person[i]["移动步数"]=math.modf(JY.Person[id]["身法"]/15)+smagic(id,41,1);
			local v=1+JY.Person[id]["内力"]/750+JY.Person[id]["内力最大值"]/1500+WAR.Person[i]["轻功"]/100;
			if v<1 then
				v=1;
			end
			--lib.Debug(v)
			WAR.Person[i]["TimeAdd"]=math.modf(math.log(v)/math.log(1.15)+JY.Person[id]["体力"]/35-2)+smagic(id,43,1);--+JY.Person[id]["身法"]/20
			local tmp=smagic(id,53,1);
			if tmp~=0 then
				WAR.Person[i]["TimeAdd"]=math.modf(WAR.Person[i]["TimeAdd"]*(100+tmp)/100);
			end
			if WAR.Person[i]["TimeAdd"]<5 then WAR.Person[i]["TimeAdd"]=5 end
			--lib.Debug(WAR.Person[i]["TimeAdd"])
			num=num+1
			total=total+WAR.Person[i]["TimeAdd"]
		end
	end
	return math.modf(1.6*(total/num+num/2));
end

function War_EndPersonData(isexp,warStatus)            --战斗以后设置人物参数
--敌方人员参数恢复
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"]
        if WAR.Person[i]["我方"] and inteam(pid) then
            if JY.Person[pid]["生命"]<JY.Person[pid]["生命最大值"]/5 then
                JY.Person[pid]["生命"]=math.modf(JY.Person[pid]["生命最大值"]/5);
            end
            if JY.Person[pid]["体力"]<10 then
                JY.Person[pid]["体力"]=10 ;
            end
		else
            JY.Person[pid]["生命"]=JY.Person[pid]["生命最大值"];
            JY.Person[pid]["内力"]=JY.Person[pid]["内力最大值"];
            JY.Person[pid]["体力"]=CC.PersonAttribMax["体力"];
            JY.Person[pid]["内伤"]=0;
            JY.Person[pid]["中毒"]=0;
            JY.Person[pid]["流血"]=0;
        end
    end

    --我方人员参数恢复，输赢都有

    if isexp==-1 then  --输，没有经验，退出
        return ;
    end

    local liveNum=0;          --计算我方活着的人数
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["我方"]==true and JY.Person[WAR.Person[i]["人物编号"]]["生命"]>0  then
            liveNum=liveNum+1;
        end
    end

    --分配战斗经验---基本经验，战斗数据中的
    if warStatus~=1 then     --赢了才有
		if isexp==0 then
			WAR.Data["经验"]=0;
		else
			WAR.Data["经验"]=WAR.Data["经验"]/2;
		end
    end
	if liveNum==0 then
		liveNum=5;
	end

    --每个人经验增加，以及升级
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
        --AddPersonAttrib(pid,"物品修炼点数",math.modf(WAR.Person[i]["经验"]*8/10));

        if WAR.Person[i]["我方"]==true then
			local add1,str1=AddPersonAttrib(pid,"修炼点数",math.modf((WAR.Person[i]["经验"]/2+WAR.Data["经验"]/liveNum)*(100+smagic(pid,58,1))/100));
			local add2,str2=AddPersonAttrib(pid,"经验",math.modf((WAR.Person[i]["经验"]+WAR.Data["经验"]/liveNum)*(100+smagic(pid,58,1))/100));
			if inteam(pid) or JY.Person[pid]["门派"]==JY.Person[0]["门派"] then
				DrawStrBoxWaitKey(string.format("%s获得*经验点数 %d*修炼点数 %d",JY.Person[pid]["姓名"],add2,add1),C_WHITE,CC.Fontbig);
			end
			local r=War_AddPersonLevel(pid);     --人物升级

			--if r==true then
			--	DrawStrBoxWaitKey( string.format("%s 升级了",JY.Person[pid]["姓名"]),C_WHITE,CC.Fontbig);
			--end
        end

        --War_PersonTrainBook(pid);            --修炼秘籍
    --    War_PersonTrainDrug(pid);            --修炼药品
    end
end

--人物是否升级
--pid 人id
--返回 true 升级，false不升级
function War_AddPersonLevel(pid,show)      --人物是否升级
	if show==nil then
		show=inteam(pid) or JY.Person[pid]["门派"]==JY.Person[0]["门派"];
	end
	local p=JY.Person[pid];
	--考虑武功修炼
	local T={"一","二","三","四","五","六","七","八","九","十"}
	if pid~=0 then
		for i=1,5 do
			if p["外功"..i]>0 and p["外功经验"..i]<900 then
				local point=GetSkillPoint(p["外功"..i],p["外功经验"..i],pid);
				if JY.Person[pid]["经验"]>=point and math.random(100)>85 then
					JY.Person[pid]["经验"]=JY.Person[pid]["经验"]-point;
					p["外功经验"..i]=100*(1+math.modf(p["外功经验"..i]/100));
					for j=1,CC.MaxKungfuNum do
						if p["所会武功"..j]==p["外功"..i] then
							p["所会武功经验"..j]=p["外功经验"..i];
						end
					end
					if show then
						DrawStrBoxWaitKey(string.format("%s修炼%s到第%s级",p["姓名"],JY.Wugong[p["外功"..i]]["名称"],T[1+math.modf(p["外功经验"..i]/100)]),C_WHITE,CC.Fontbig,1);
					end
				end
			end
		end
		for i,v in pairs({"内功","轻功","特技"}) do
			if p[v]>0 and p[v.."经验"]<900 then
				local point=GetSkillPoint(p[v],p[v.."经验"],pid);
				if JY.Person[pid]["经验"]>=point and math.random(100)>85 then
					JY.Person[pid]["经验"]=JY.Person[pid]["经验"]-point;
					p[v.."经验"]=100*(1+math.modf(p[v.."经验"]/100));
					for j=1,CC.MaxKungfuNum do
						if p["所会武功"..j]==p[v] then
							p["所会武功经验"..j]=p[v.."经验"];
						end
					end
					if show then
						DrawStrBoxWaitKey(string.format("%s修炼%s到第%s级",p["姓名"],JY.Wugong[p[v]]["名称"],T[1+math.modf(p[v.."经验"]/100)]),C_WHITE,CC.Fontbig,1);
					end
				end
			end
		end
	end
	local data={
						["等级"]={p["等级"],},
						["生命"]={p["生命最大值"],},
						["内力"]={p["内力最大值"],},
						["攻击"]={p["攻击"],},
						["防御"]={p["防御"],},
						["身法"]={p["身法"],},
					};
	--[[				
	for i,v in pairs({"攻击","防御","身法"}) do
		local dd=p[v];
		for mi,mv in pairs({"内功","轻功","特技"}) do
			local mkfid,mkfexp=p[mv],p[mv..'经验'];
			if mkfid>0 then
				dd=dd+JY.Wugong[mkfid][v]*(1+div100(mkfexp));
			end
		end
		for ni=1,5 do
			local nid,nexp=p["外功"..ni],p["外功经验"..ni];
			if nid>0 then
				dd=dd+JY.Wugong[nid][v]*(1+div100(nexp));
			end
		end
		dd=math.modf(dd*100/(130-p[v]));
		data[v][1]=dd;
	end
	]]--
    local tmplevel=JY.Person[pid]["等级"];
    if tmplevel>=CC.Level then     --级别到顶
        return false;
    end
	local leveladd=0;
	while true do
		local EXP=NextLvExp(tmplevel+leveladd);
		if JY.Person[pid]["经验"]>=EXP then
			JY.Person[pid]["经验"]=JY.Person[pid]["经验"]-EXP;
			leveladd=leveladd+1;
		else
			break;
		end
	end
	if leveladd==0 then
		return false;
	end
	for i=1,leveladd do
		JY.Person[pid]["等级"]=JY.Person[pid]["等级"]+1;
		AddPersonAttrib(pid,"生命Max", math.modf(JY.Person[pid]["力道"]/4+10+Rnd(10)));
		AddPersonAttrib(pid,"内力Max",  math.modf(JY.Person[pid]["根骨"]/4+10+Rnd(10)));
		if myRnd100()<JY.Person[pid]["力道"]+(33+(JY.Person[pid]["力道"]+smagic(pid,64,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["攻击"])*math.abs((33+(JY.Person[pid]["力道"]+smagic(pid,64,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["攻击"])) then
			AddPersonAttrib(pid,"攻击",1);
		end
		if myRnd100()<JY.Person[pid]["根骨"]+(33+(JY.Person[pid]["根骨"]+smagic(pid,65,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["防御"])*math.abs((33+(JY.Person[pid]["根骨"]+smagic(pid,65,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["防御"])) then
			AddPersonAttrib(pid,"防御",1);
		end
		if myRnd100()<JY.Person[pid]["机敏"]+(33+(JY.Person[pid]["机敏"]+smagic(pid,66,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["身法"])*math.abs((33+(JY.Person[pid]["机敏"]+smagic(pid,66,1))*JY.Person[pid]["等级"]/100-JY.Person[pid]["身法"])) then
			AddPersonAttrib(pid,"身法",1);
		end
	end
    JY.Person[pid]["内伤"]=0;
    JY.Person[pid]["中毒"]=0;
	JY.Person[pid]["流血"]=0;
	if pid>0 then
		JY.Person[pid]["体力"]=CC.PersonAttribMax["体力"];
	end
	ResetPersonAttrib(pid);
    JY.Person[pid]["生命"]=JY.Person[pid]["生命最大值"];
	JY.Person[pid]["内力"]=JY.Person[pid]["内力最大值"];
    --AddPersonAttrib(pid,"攻击",  math.modf(myRnd100()/20));
    --AddPersonAttrib(pid,"防御",  math.modf(myRnd100()/20));
    --AddPersonAttrib(pid,"身法",  math.modf(myRnd100()/20));
	if show then
		data["等级"][2]=p["等级"];
		data["生命"][2]=p["生命最大值"];
		data["内力"][2]=p["内力最大值"];
		data["攻击"][2]=p["攻击"];
		data["防御"][2]=p["防御"];
		data["身法"][2]=p["身法"];
		data["等级"][1]=data["等级"][1]+4;
		data["等级"][2]=data["等级"][2]+4;
		
		--[[
		for i,v in pairs({"攻击","防御","身法"}) do
			local dd=p[v];
			for mi,mv in pairs({"内功","轻功","特技"}) do
				local mkfid,mkfexp=p[mv],p[mv..'经验'];
				if mkfid>0 then
					dd=dd+JY.Wugong[mkfid][v]*(1+div100(mkfexp));
				end
			end
			for ni=1,5 do
				local nid,nexp=p["外功"..ni],p["外功经验"..ni];
				if nid>0 then
					dd=dd+JY.Wugong[nid][v]*(1+div100(nexp));
				end
			end
			dd=math.modf(dd*100/(130-p[v]));
			data[v][2]=dd;
		end
		]]--
		local str="";
		for i,v in pairs({"等级","生命","内力"}) do--,"攻击","防御","身法"}) do
			if str~="" then
				str=str.."*";
			end
			if data[v][2]>data[v][1] then
				--str=str..string.format("%s:%4d ↗%4d",v,data[v][1],data[v][2]);
				str=str..string.format("%s:%4d →%4d",v,data[v][1],data[v][2]);
			elseif data[v][2]==data[v][1] then
				--str=str..string.format("%s:%4d →%4d",v,data[v][1],data[v][2]);
			else
				--str=str..string.format("%s:%4d ↘%4d",v,data[v][1],data[v][2]);
			end
		end
		for i,v in pairs({"攻击","防御","身法"}) do
			--if str~="" then
			--	str=str.."*";
			--end
			if data[v][2]>data[v][1] then
				--str=str..string.format("%s:%4d ↗%4d",v,data[v][1],data[v][2]);
				str=str.."*"..v.."上升"--string.format("%s:%4d →%4d",v,data[v][1],data[v][2]);
			elseif data[v][2]==data[v][1] then
				--str=str..string.format("%s:%4d →%4d",v,data[v][1],data[v][2]);
			else
				--str=str..string.format("%s:%4d ↘%4d",v,data[v][1],data[v][2]);
			end
		end
		JYMsgBox(p["姓名"].."升级了",str,{"确定"},1,p["头像代号"]);
	end
    return true;

end
function NextLvExp(lv)
	return 50*math.modf(lv^3/100+lv^2/40+lv*2)
end

--战斗是否结束
--返回：0 继续   1 赢    2 输
function War_isEnd()           --战斗是否结束

    for i=0,WAR.PersonNum-1 do
        if JY.Person[WAR.Person[i]["人物编号"]]["生命"]<=0 then
            WAR.Person[i]["死亡"]=true;
        end
    end
    WarSetPerson();     --设置战斗人物位置

    Cls();
    ShowScreen();

    local myNum=0;
    local EmenyNum=0;
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["死亡"]==false then
            if WAR.Person[i]["我方"]==true then
                myNum=1;
            else
                EmenyNum=1;
            end
        end
    end

    if EmenyNum==0 then
        return 1;
    end
    if myNum==0 then
        return 2;
    end
    return 0;
end

--选择我方参战人
function WarSelectTeam()            --选择我方参战人
    WAR.PersonNum=0;

    for i=1,6 do
	    local id=WAR.Data["自动选择参战人" .. i] or -1;
		if id>=0 then
            WAR.Person[WAR.PersonNum]["人物编号"]=id;
            WAR.Person[WAR.PersonNum]["我方"]=true;
            WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["我方X"  .. i];
            WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["我方Y"  .. i];
            WAR.Person[WAR.PersonNum]["死亡"]=false;
            WAR.Person[WAR.PersonNum]["人方向"]=2;
			WAR.Person[WAR.PersonNum]["RP"]=JY.Person[id]["福缘"];
			WAR.Person[WAR.PersonNum]["AI"]={0,0,0};
            WAR.PersonNum=WAR.PersonNum+1;
			WAR.LifeNum=WAR.LifeNum+1;
		end
    end
	if WAR.PersonNum>0 then
	    return ;
    end

    for i=1,CC.TeamNum do                 --设置事先确定的参战人
        WAR.SelectPerson[i]=0;
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            for j=1,6 do
                if WAR.Data["手动选择参战人" .. j]==id then
                    WAR.SelectPerson[i]=1;
                end
            end
        end
    end

    local menu={};
    for i=1, CC.TeamNum do
        menu[i]={"",WarSelectMenu,0};
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            menu[i][3]=1;
            local s=JY.Person[id]["姓名"];
            if WAR.SelectPerson[i]==1 then
                menu[i][1]="*" .. s;
            else
                menu[i][1]=" " .. s;
            end
        end
    end
    menu[CC.TeamNum+1]={" 结束",nil,1}

	while true do
		Cls();
		local x=(CC.ScreenW-7*CC.Fontbig-2*CC.MenuBorderPixel)/2;
		DrawStrBox(x,10,"请选择参战人物",C_WHITE,CC.Fontbig);
		local r=ShowMenu(menu,CC.TeamNum+1,0,x,10+CC.SingleLineHeight,0,0,1,0,CC.Fontbig,C_ORANGE,C_WHITE);
		Cls();

		for i=1,6 do
			if WAR.SelectPerson[i]>0 then
				WAR.Person[WAR.PersonNum]["人物编号"]=JY.Base["队伍" ..i];
				WAR.Person[WAR.PersonNum]["我方"]=true;
				WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["我方X"  .. i];
				WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["我方Y"  .. i];
				WAR.Person[WAR.PersonNum]["死亡"]=false;
				WAR.Person[WAR.PersonNum]["人方向"]=2;
				WAR.Person[WAR.PersonNum]["RP"]=JY.Person[JY.Base["队伍" ..i]]["福缘"];
				WAR.Person[WAR.PersonNum]["AI"]={0,0,0};
				WAR.PersonNum=WAR.PersonNum+1;
				WAR.LifeNum=WAR.LifeNum+1;
			end
		end
		if WAR.PersonNum>0 then   --选择了我方参战人
		   break;
		end
    end
end


--选中战斗人菜单调用函数
function WarSelectMenu(newmenu,newid)            --选择战斗人菜单调用函数
    local id=newmenu[newid][4];

    if WAR.SelectPerson[id]==0 then
        WAR.SelectPerson[id]=2;
    elseif WAR.SelectPerson[id]==2 then
        WAR.SelectPerson[id]=0;
    end

    if WAR.SelectPerson[id]>0 then
        newmenu[newid][1]="*" .. string.sub(newmenu[newid][1],2);
    else
        newmenu[newid][1]=" " .. string.sub(newmenu[newid][1],2);
    end
    return 0;
end

--选择敌方参战人
function WarSelectEnemy()            --选择敌方参战人
    for i=1,20 do
		WAR.Data["敌人"  .. i]=WAR.Data["敌人"  .. i] or -1
        if WAR.Data["敌人"  .. i]>=0 then
            WAR.Person[WAR.PersonNum]["人物编号"]=WAR.Data["敌人"  .. i];
            WAR.Person[WAR.PersonNum]["我方"]=false;
            WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["敌方X"  .. i];
            WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["敌方Y"  .. i];
            WAR.Person[WAR.PersonNum]["死亡"]=false;
            WAR.Person[WAR.PersonNum]["人方向"]=1;
			WAR.Person[WAR.PersonNum]["RP"]=JY.Person[WAR.Data["敌人"  .. i]]["福缘"];
			if WAR.Person[WAR.PersonNum]["人物编号"]==0 then
				WAR.Person[WAR.PersonNum]["AI"]={0,0,0};
			else
				WAR.Person[WAR.PersonNum]["AI"]={2,0,0};
            end
			WAR.PersonNum=WAR.PersonNum+1;
			WAR.LifeNum=WAR.LifeNum+1;
        end
    end
end

function ModifyWarMap()
	return;
end
--加载战斗地图
--共6层，包括了工作用地图
--        0层 地面数据
--        1层 建筑
--以上为战斗地图数据，从战斗文件中载入。下面为工作用的地图结构
--        2层 战斗人战斗编号，即WAR.Person的编号
--        3层 移动时显示可移动的位置
--        4层 命中效果
--        5层 战斗人对应的贴图

function WarLoadMap(mapid)      --加载战斗地图
	mapid=mapid or JY.SubScene
	if mapid<0 then mapid=JY.SubScene end
	--lib.Debug(string.format("load war map %d",mapid));
	lib.LoadWarMap(CC.WarMapFile[1],CC.WarMapFile[2],mapid,6,CC.WarWidth,CC.WarHeight);
	--[[if mapid==0 then
		for i=0,63 do
			for j=0,63 do
				lib.SetWarMap(i,j,0,lib.GetS(JY.SubScene,i,j,0))
				lib.SetWarMap(i,j,1,lib.GetS(JY.SubScene,i,j,1))
			end
		end	
	end]]--
	--ModifyWarMap();
end

function GetWarMap(x,y,level)   --取战斗地图数据
     return lib.GetWarMap(x,y,level);
end

function SetWarMap(x,y,level,v)  --存战斗地图数据
 	lib.SetWarMap(x,y,level,v);
end

--设置某层为给定值
function CleanWarMap(level,v)
	lib.CleanWarMap(level,v);
end


--绘战斗地图
--flag==0 基本
--      1 显示移动路径 (v1,v2) 当前移动位置
--      2 命中人物（武功，医疗等）另一个颜色显示
--      4 战斗动画, v1 战斗人物pic, v2战斗人物贴图类型(0 使用战斗场景贴图，4，fight***贴图编号 v3 武功效果贴图 -1没有效果

function WarDrawMap(flag,v1,v2,v3)
    local x=WAR.Person[WAR.CurID]["坐标X"];
    local y=WAR.Person[WAR.CurID]["坐标Y"];
	getkey();
    if flag==0 then
	    lib.DrawWarMap(0,x,y,0,0,-1,JY.SubScene);
    elseif flag==1 then
		if WAR.Data["地图"]==0 then     --雪地地图用黑色菱形
		    lib.DrawWarMap(1,x,y,v1,v2,-1,JY.SubScene);
        else
		    lib.DrawWarMap(2,x,y,v1,v2,-1,JY.SubScene);
			
		end
	elseif flag==2 then
	    lib.DrawWarMap(3,x,y,0,0,-1,JY.SubScene);
	elseif flag==4 then
	    lib.DrawWarMap(4,x,y,v1,v2,v3,JY.SubScene);
	end
	if WAR.ShowHead==1 then
        WarShowHead();
	end
	--[[
	if JY.Light>0 or JY.Sight>0 then
		lib.Background(0,0,CC.ScreenW,CC.ScreenH/2-JY.Sight,0)
		lib.Background(0,CC.ScreenH/2+JY.Sight,CC.ScreenW,CC.ScreenH,0)
		lib.Background(0,CC.ScreenH/2-JY.Sight,CC.ScreenW/2-JY.Sight,CC.ScreenH/2+JY.Sight,0)
		lib.Background(CC.ScreenW/2+JY.Sight,CC.ScreenH/-JY.Sight,CC.ScreenW,CC.ScreenH/2+JY.Sight,0)
		local step=math.modf(JY.Sight/30)+2;
		--for i=199,440,step do
		--	for j=119,360,step do
		for i=CC.ScreenW/2-JY.Sight,CC.ScreenW/2+JY.Sight,step do
			for j=CC.ScreenH/2-JY.Sight,CC.ScreenH/2+JY.Sight,step do
				lib.Background(i,j,i+step,j+step,Bright[i][j]);
			end
		end
	end]]--
end


function WarPersonSort(flag)               --战斗人物按轻功排序
    for i=0,WAR.PersonNum-1 do                ---计算各人的轻功，包括装备加成
        local id=WAR.Person[i]["人物编号"];
        local add=0;
		WAR.Person[WAR.PersonNum]["RP"]=JY.Person[id]["福缘"];
        if JY.Person[id]["武器"]>-1 then
            add=add+JY.Thing[JY.Person[id]["武器"]]["加轻功"];
        end
        if JY.Person[id]["防具"]>-1 then
            add=add+JY.Thing[JY.Person[id]["防具"]]["加轻功"];
        end
        WAR.Person[i]["轻功"]=GetSpeed(id)+add;
    end
	if flag then return end
    --按轻功排序，用比较笨的方法
    for i=0,WAR.PersonNum-2 do
        local maxid=i;
        for j=i,WAR.PersonNum-1 do
            if WAR.Person[j]["轻功"]>WAR.Person[maxid]["轻功"] then
                maxid=j;
            end
        end
        WAR.Person[maxid],WAR.Person[i]=WAR.Person[i],WAR.Person[maxid];
    end
end



--设置战斗人物位置和贴图
function WarSetPerson()            --设置战斗人物位置
 	CleanWarMap(2,-1);
 	CleanWarMap(5,-1);

	for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["死亡"]==false then
            SetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],2,i);
            SetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],5,WAR.Person[i]["贴图"]);
        end
    end
end


function WarCalPersonPic(id)       --计算战斗人物贴图
    local n=12002;            --战斗人物贴图起始位置
	WAR.Person[id]["人方向"]=WAR.Person[id]["人方向"] or 0
    n=n+JY.Person[WAR.Person[id]["人物编号"]]["战斗动作"]*8+WAR.Person[id]["人方向"]*2;
    return n;
end

-------------------------------------------------------------------------------------------
---------------------------------以下为手动战斗函数-------------------------------------------
-------------------------------------------------------------------------------------------

--手动战斗
--id 战斗人物编号
--返回，选中菜单编号，选中"等待"时有效，
function War_Manual()        --手动战斗
    local r;
	local flag=false;
	local x,y,move,pic=	WAR.Person[WAR.CurID]['坐标X'],
						WAR.Person[WAR.CurID]['坐标Y'],
						WAR.Person[WAR.CurID]["移动步数"],
						WAR.Person[WAR.CurID]["贴图"];
	while true do
	    WAR.ShowHead=1;          --显示头像
	    r=War_Manual_Sub(flag);  --手动战斗菜单
		--lib.Debug('R:'..r)
		if r==1 or r==-1 then
			WAR.Person[WAR.CurID]["移动步数"]=0
			flag=true;
		elseif r==0 then
			SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,-1);
			SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,-1);
			WAR.Person[WAR.CurID]['坐标X'],WAR.Person[WAR.CurID]['坐标Y'],WAR.Person[WAR.CurID]["移动步数"]=x,y,move
			SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,WAR.CurID);
			SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,pic);
			flag=false;
        else        --移动完毕后，重新生成菜单
		    break;
		end
	end
	WAR.ShowHead=0;
	return r;
end


function War_Manual_Sub(flag)                --手动战斗菜单
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local menu={ {"移动",War_MoveMenu,1},
                 {"攻击",War_FightMenu,1},
                 {"用毒",War_PoisonMenu,0},
                 {"解毒",War_DecPoisonMenu,0},
                 {"医疗",War_DoctorMenu,0},
                 {"物品",War_ThingMenu,1},
                 {"等待",War_WaitMenu,1},
                 {"状态",War_StatusMenu,1},
                 {"休息",War_RestMenu,1},
                 {"自动",War_AutoMenu,1},   };

    if flag or JY.Person[pid]["体力"]<=5 or WAR.Person[WAR.CurID]["移动步数"]<=0 then  --不能移动
        menu[1][3]=0;
    end

    local minv=War_GetMinNeiLi(pid);

    if JY.Person[pid]["内力"] < minv or JY.Person[pid]["体力"] <10 then  --不能战斗
        menu[2][3]=0;
    end
--[[
    if JY.Person[pid]["体力"]<10 or JY.Person[pid]["用毒"]<20 then  --不能用毒
        menu[3][3]=0;
    end

    if JY.Person[pid]["体力"]<10 or JY.Person[pid]["解毒"]<20 then  --不能解毒
        menu[4][3]=0;
    end

    if JY.Person[pid]["体力"]<50 or JY.Person[pid]["医疗"]<20 then  --不能医疗
        menu[5][3]=0;
    end
]]--
    getkey();
    Cls();
	DrawTimeBar_sub(CC.ScreenW*5/8,CC.ScreenW*15/16,CC.FontSmall*5,2);
    return ShowMenu(menu,10,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.Fontbig,C_ORANGE,C_WHITE);

end


function War_GetMinNeiLi(pid)       --计算所有武功中需要内力最少的
    local minv=math.huge;
    for i=1,CC.Kungfunum do
        local tmpid=JY.Person[pid]["外功"..i];
        if tmpid >0 then
            if JY.Wugong[tmpid]["消耗内力点数"]< minv then
                minv=JY.Wugong[tmpid]["消耗内力点数"];
            end
        end
    end
	return minv;
end

function WarShowHead1()               --显示战斗人头像
    local pid=WAR.Person[WAR.CurID]["人物编号"];
	local p=JY.Person[pid];

	local h=16+2;
    local width=160+2*CC.MenuBorderPixel;
	local height=160+2*CC.MenuBorderPixel+4*h;
	local x1,y1;
	local i=1;
    if WAR.Person[WAR.CurID]["我方"]==true then
	    x1=CC.ScreenW-width-10;
        y1=CC.ScreenH-height-10;
    else
	    x1=10;
        y1=10;
    end

    DrawBox(x1,y1,x1+width,y1+height,C_WHITE);
	local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
    local headx=(160-headw)/2;
	local heady=(100-headh)/2;

	lib.PicLoadCache(1,p["头像代号"]*2,x1+5+headx,y1+5+heady,1);
	x1=x1+5
	y1=y1+5+100;
    MyDrawString(x1,x1+160,y1+5,p["姓名"],C_WHITE,32);
	y1=y1+42
	
local hp=math.modf(JY.Person[pid]["生命"]*160/JY.Person[pid]["生命最大值"])
local mp=math.modf(JY.Person[pid]["内力"]*160/JY.Person[pid]["内力最大值"])
local tp=math.modf(JY.Person[pid]["体力"]*160/100)
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

    DrawString(x1+10,y1+5,"生命",C_WHITE,16);
    DrawString(x1+10,y1+35,"内力",C_WHITE,16);
    DrawString(x1+10,y1+65,"体力",C_WHITE,16);
	
		--开始绘制进度条及相关
		DrawBox_1(397,64,603,66,C_ORANGE)
		local least=0
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["死亡"]==false then
				least=least+20
			end
		end
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["死亡"]==false then
				if WAR.Person[i]["Time"]>least then
					local cx=400+math.modf((WAR.Person[i]["Time"]-least)*200/(1000-least))
					--DrawBox_1(cx,50,cx,60,C_WHITE)
					if WAR.Person[i]["我方"] then
						lib.FillColor(cx-1,50,cx+1,60,C_WHITE)
						drawname(cx,0,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],16)
					else
						lib.FillColor(cx-1,68,cx+1,78,C_WHITE)
						drawname(cx,82,JY.Person[WAR.Person[i]["人物编号"]]["姓名"],16)					
					end
				end
			end
		end
end
function WarShowHead(id)               --显示战斗人头像
	id=id or WAR.CurID
	if id<0 then return end
    local pid=WAR.Person[id]["人物编号"];
	local p=JY.Person[pid];

	local h=16+2;
    local width=160+2*CC.MenuBorderPixel;
	local height=160+2*CC.MenuBorderPixel+4*h;
	local x1,y1;
	local i=1;
    if WAR.Person[id]["我方"]==true then
	    x1=CC.ScreenW-width-10;
        y1=CC.ScreenH-height-10;
    else
	    x1=10;
        y1=10;
    end
    DrawBox(x1,y1,x1+width,y1+height,C_WHITE);
	local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
    local headx=(160-headw)/2;
	local heady=(100-headh)/2;

	lib.PicLoadCache(1,p["头像代号"]*2,x1+5+headx,y1+5+heady,1);
	x1=x1+5
	y1=y1+5+100;
	local color=C_WHITE;
    MyDrawString(x1,x1+160,y1+5,p["姓名"],color,32);
	y1=y1+42
	
local hp=math.modf(JY.Person[pid]["生命"]*160/JY.Person[pid]["生命最大值"])
local mp=math.modf(JY.Person[pid]["内力"]*160/JY.Person[pid]["内力最大值"])
local tp=math.modf(JY.Person[pid]["体力"]*160/100)
	lib.PicLoadCache(1,275*2,x1,y1,1);
	lib.PicLoadCache(1,275*2,x1,y1+30,1);
	lib.PicLoadCache(1,275*2,x1,y1+60,1);
lib.SetClip(x1,y1,x1+hp,y1+24)
	lib.PicLoadCache(1,274*2,x1,y1,1);
lib.SetClip(x1,y1+30,x1+mp,y1+54)
	lib.PicLoadCache(1,273*2,x1,y1+30,1);
lib.SetClip(x1,y1+30,x1+tp,y1+84)
	lib.PicLoadCache(1,276*2,x1,y1+60,1);
lib.SetClip(0,0,0,0)
    DrawString(x1+10,y1+5,string.format("生命:%5d/%5d",p["生命"],p["生命最大值"]),C_WHITE,16);
    DrawString(x1+10,y1+35,string.format("内力:%5d/%5d",p["内力"],p["内力最大值"]),C_WHITE,16);
    DrawString(x1+10,y1+65,string.format("体力:%6d",p["体力"]),C_WHITE,16);
	
	--RP
	--[[
	DrawString(10,CC.ScreenH-48,"RP:"..math.modf(WAR.Person[id]["RP"]),C_WHITE,16);
	DrawBox(64,CC.ScreenH-48,64+300,CC.ScreenH-32,C_WHITE);
	DrawBox(64,CC.ScreenH-48,64+limitX(WAR.Person[id]["RP"],0,100)*3,CC.ScreenH-32,C_WHITE,C_ORANGE);
	]]--
		--开始绘制进度条及相关
	--DrawStrBox(CC.FontSmall,CC.ScreenH-CC.FontSmall*5,string.format("中毒:%3d 内伤:%3d 流血:%3d*封穴:%3d 恍惚:%3d*吃力:%3d 骨折:%3d",
	 --                                                  p["中毒"],p["内伤"],p["流血"],WAR.Person[WAR.CurID]["封穴"],
	--												   WAR.Person[WAR.CurID]["恍惚"],WAR.Person[WAR.CurID]["吃力"],
	--												   WAR.Person[WAR.CurID]["骨折"]),M_White,CC.FontSmall);
end


--返回1：已经移动    0 没有移动
function War_MoveMenu()           --执行移动菜单
    WAR.ShowHead=0;   --不显示头像
    if WAR.Person[WAR.CurID]["移动步数"]<=0 then
        return 0;
    end

    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);   --计算移动步数

    local r;
    local x,y=War_SelectMove()             --选择移动位置
    if x ~=nil then            --空值表示没有选择，esc返回了，非空则表示选择了位置
        War_MovePerson(x,y);    --移动到相应的位置
        r=1;
	else
	    r=0
		WAR.ShowHead=1;
		Cls();
    end
    getkey();
    return r;
end

--计算可移动步数
--id 战斗人id，
--stepmax 最大步数，
--flag=0  移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路。
function War_CalMoveStepOld(id,stepmax,flag)
	
  	CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，

    local x=WAR.Person[id]["坐标X"];
    local y=WAR.Person[id]["坐标Y"];

	local steparray={};     --用数组保存第n步的坐标。
	for i=0,stepmax do
	    steparray[i]={};
        steparray[i].x={};
        steparray[i].y={};
	end

	SetWarMap(x,y,3,0);
    steparray[0].num=1;
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	War_FindNextStepOld(steparray,0,flag,id);

	return steparray;

end

--被上面的函数调用
function War_FindNextStepOld(steparray,step,flag,id)      --设置下一步可移动的坐标
    local num=0;
	local step1=step+1;
	if steparray[step1]==nil then
		return;
	end
	for i=1,steparray[step].num do
	    local x=steparray[step].x[i];
	    local y=steparray[step].y[i];
	    if x+1<CC.WarWidth-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x+1,y,3);
			if v ==255 and War_CanMoveXYOld(x+1,y,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
				SetWarMap(x+1,y,3,step1);
			end
		end

	    if x-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x-1,y,3);
			if v ==255 and War_CanMoveXYOld(x-1,y,flag)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
				SetWarMap(x-1,y,3,step1);
			end
		end

	    if y+1<CC.WarHeight-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x,y+1,3);
			if v ==255 and War_CanMoveXYOld(x,y+1,flag)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
				SetWarMap(x,y+1,3,step1);
			end
		end

	    if y-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x ,y-1,3);
			if v ==255 and War_CanMoveXYOld(x,y-1,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
				SetWarMap(x ,y-1,3,step1);
			end
		end
	end
	if num==0 then return end;
    steparray[step1].num=num;	
	War_FindNextStepOld(steparray,step1,flag,id)

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

function War_CanMoveXY(x,y,flag)  --坐标是否可以通过，判断移动时使用
	if GetWarMap(x,y,1)>0 then    --第1层有物体
		return false
	end
	if flag==0 then		
		if CC.WarWater[GetWarMap(x,y,0)]~=nil then          --水面，不可走
			local id=WAR.Person[WAR.CurID]["人物编号"]
			local kfnum=JY.Person[id]["轻功"] or 0
			if kfnum<=0 or kfnum>CC.Kungfunum then return false end
			local kf,kflv=JY.Person[id]["武功"][kfnum][1],div100(JY.Person[id]["武功"][kfnum][2])+1
			if smagic(id,kf,kflv,07)<1 then
				return false
			end
		end
		if GetWarMap(x,y,2)>=0 then    --有人
			return false
		end
	end
	return true;
end
function War_CanMoveXYOld(x,y,flag)  --坐标是否可以通过，判断移动时使用
	if GetWarMap(x,y,1)>0 then    --第1层有物体
		return false
	end
	if flag==0 then		
		if CC.WarWater[GetWarMap(x,y,0)]~=nil then          --水面，不可走
			return false
		end
	end
	return true;
end




function War_SelectMove()              ---选择移动位置
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local x=x0;
    local y=y0;
	local t=0;
    while true do
        local x2=x;
        local y2=y;

		if t==0 then
			WAR.Data["地图"]=0;
		elseif t==10 then
			WAR.Data["地图"]=1;
		end
        WarDrawMap(1,x,y);
		t=t+1;
		if t>20 then
			t=0;
		end
        ShowScreen();
		lib.Delay(30);
        local eventtype,key,mx,my=getkey();--WaitKey(1);
		if eventtype==1 then
			if key==VK_UP then
				y2=y-1;
			elseif key==VK_DOWN then
				y2=y+1;
			elseif key==VK_LEFT then
				x2=x-1;
			elseif key==VK_RIGHT then
				x2=x+1;
			elseif key==VK_SPACE or key==VK_RETURN then
				return x,y;
			elseif key==VK_ESCAPE then
				return nil;
			end
			if GetWarMap(x2,y2,3)<128 then
				x=x2;
				y=y2;
			end
		elseif eventtype==2 or eventtype==3 then
			mx=mx-CC.ScreenW/2
			my=my-CC.ScreenH/2+GetS(JY.SubScene,x0,y0,4)
			mx=mx/CC.XScale
			my=my/CC.YScale
			mx,my=(mx+my)/2,(my-mx)/2
			if mx>0 then mx=mx+0.99 else mx=mx-0.01 end
			if my>0 then my=my+0.99 else mx=mx-0.01 end
			mx=math.modf(mx)
			my=math.modf(my)
			for i=-10,10 do
				if between(x0+mx+i,0,63) and between(y0+my+i,0,63) then
					if math.abs(GetS(JY.SubScene,x0+mx+i,y0+my+i,4)-CC.YScale*i*2-GetS(JY.SubScene,x0,y0,4))<4 then
						mx=mx+i;
						my=my+i;
						break;
					end
				end
			end
			if GetWarMap(x0+mx,y0+my,3)<128 then
				x,y=x0+mx,y0+my
				if eventtype==3 then
					if key==1 then
						return x,y;
					elseif key==3 then
						return nil;
					end
				end
			end
		end

    end

end


function War_MovePerson(x,y)            --移动人物到位置x,y

    local movenum=GetWarMap(x,y,3);
    --WAR.Person[WAR.CurID]["移动步数"]=WAR.Person[WAR.CurID]["移动步数"]-movenum;    --可移动步数减小

    local movetable={};  --   记录每步移动
    for i=movenum,1,-1 do    --从目的位置反着找到初始位置，作为移动的次序
        movetable[i]={};
        movetable[i].x=x;
        movetable[i].y=y;
        if GetWarMap(x-1,y,3)==i-1 then
            x=x-1;
            movetable[i].direct=1;
        elseif GetWarMap(x+1,y,3)==i-1 then
            x=x+1;
            movetable[i].direct=2;
        elseif GetWarMap(x,y-1,3)==i-1 then
            y=y-1;
            movetable[i].direct=3;
        elseif GetWarMap(x,y+1,3)==i-1 then
            y=y+1;
            movetable[i].direct=0;
        end
    end
	
	if movenum>WAR.Person[WAR.CurID]["移动步数"] then 
		movenum=WAR.Person[WAR.CurID]["移动步数"]
		WAR.Person[WAR.CurID]["移动步数"]=0
	else
		WAR.Person[WAR.CurID]["移动步数"]=WAR.Person[WAR.CurID]["移动步数"]-movenum
	end
    for i=1,movenum do
        local t1=lib.GetTime();

		SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,-1);
		SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,-1);

        WAR.Person[WAR.CurID]["坐标X"]=movetable[i].x;
        WAR.Person[WAR.CurID]["坐标Y"]=movetable[i].y;
        WAR.Person[WAR.CurID]["人方向"]=movetable[i].direct;
        WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);

		SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,WAR.CurID);
		SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,WAR.Person[WAR.CurID]["贴图"]);
		WarDrawMap(0);
		ShowScreen();
        local t2=lib.GetTime();
		if i<movenum then
			if (t2-t1)< 2*CC.Frame then
				lib.Delay(2*CC.Frame-(t2-t1));
			end
		end
    end

end


function War_FightMenu()              --执行攻击菜单

    local pid=WAR.Person[WAR.CurID]["人物编号"];

    local numwugong=0;
    local menu={};
    for i=1,5 do
        local tmp=JY.Person[pid]["外功"..i];
        if tmp>0 then
			menu[i]={JY.Wugong[tmp]["名称"],nil,1};
			if JY.Wugong[tmp]["武功类型"]>5 or JY.Wugong[tmp]["消耗内力点数"] > JY.Person[pid]["内力"] then
				menu[i][3]=0;
			end
        else
			menu[i]={"ERROR",nil,0};
		end
		numwugong=numwugong+1;
    end

    if numwugong==0 then
        return 0;
    end
    local r;
    if numwugong==1 then
        r=1;
    else
        r=ShowMenu(menu,numwugong,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.Fontbig,C_ORANGE,C_WHITE);
    end
    if r==0 then
        return 0;
    end

    WAR.ShowHead=0;
    local r2=War_Fight_Sub(WAR.CurID,r);
    WAR.ShowHead=1;
	Cls();
	return r2;
	
end

--执行战斗，自动和手动战斗都调用
function War_Fight_Sub(id,wugongnum,x,y)          --执行战斗
	WAR.ShowHead=0
	WarDrawMap(0)
	lib.Delay(250)
    local pid=WAR.Person[id]["人物编号"];
	--PUSH(JY.Person[pid]["内功经验"]);

--	if JY.Person[pid]["内功"]>0 then
--		local dxx=math.abs(JY.Person[pid]["内力性质"]-JY.Wugong[JY.Person[pid]["内功"]]["思想"]);
--		if dxx>1 then
--			JY.Person[pid]["内功经验"]=JY.Person[pid]["内功经验"]*(24-dxx)/24;
--		end
--	end
	
    local wugong=0;
	--DrawString(320,240,tostring(wugongnum)..'|'..tostring(x)..","..tostring(y),C_RED,42)
	--ShowScreen()
	--lib.Delay(1500)
	local level;
	if wugongnum<6 then 
		wugong=JY.Person[pid]["外功"..wugongnum];
		level=math.modf(JY.Person[pid]["外功经验"..wugongnum]/100)+1;
		WAR.Person[id]["招架"]=wugongnum;
	else 
		x=WAR.Person[WAR.CurID]["坐标X"]-x;
		y=WAR.Person[WAR.CurID]["坐标Y"]-y;
		wugong=wugongnum-100;
		wugongnum=WAR.Person[id]["反击武功"];
		if wugongnum==6 then
			wugongnum=JY.Person[pid]["内功"];
			level=math.modf(JY.Person[pid]["内功经验"]/100)+1;
		elseif wugongnum==7 then
			wugongnum=JY.Person[pid]["轻功"];
			level=math.modf(JY.Person[pid]["轻功经验"]/100)+1;
		else
			wugongnum=JY.Person[pid]["特技"];
			level=math.modf(JY.Person[pid]["特技经验"]/100)+1;
		end										
		WarDrawMap(0);
		DrawStrNewBox(CC.ScreenW/2-CC.Fontbig*(#JY.Wugong[wugongnum]["名称"]+4)/4,CC.Fontbig,JY.Wugong[wugongnum]["名称"].."反击",C_ORANGE,CC.Fontbig);
		ShowScreen()
		lib.Delay(350)
	end;
	WAR.Person[id]["反击武功"]=9999;								--禁止斗转反击后反击
	if WAR.Person[id]["TimeAdd"]>0 then
		WAR.Person[id]["TimeAdd"]=0;
	end
   	CleanWarMap(4,0);

    local fightscope;--=JY.Kungfu[wugong]["攻击范围"][math.modf((level+2)/3)];
	local hurtscope;--=JY.Kungfu[wugong]["伤害范围"][math.modf((level+2)/3)];
	
	local hurt,atk,level=GetAtk(pid,wugong,level);
			for lv=level,1,-1 do
				if JY.Kungfu[wugong]["攻击范围"][lv]~=nil then
					fightscope=JY.Kungfu[wugong]["攻击范围"][lv];
					break;
				end
			end
			for lv=level,1,-1 do
				if JY.Kungfu[wugong]["伤害范围"][lv]~=nil then
					hurtscope=JY.Kungfu[wugong]["伤害范围"][lv];
					break;
				end
			end
	local r,x,y=War_FightSelectType(fightscope,hurtscope,x,y)
	if r==false then
		--JY.Person[pid]["内功经验"]=POP();
		return 0;
    end
	
	
	WAR["攻击"]=0;
	WAR["防御"]=0;
	WAR["身法"]=0;
	
    local fightnum=1;
	local tmp1,tmp2=smagic(pid,20);
	if tmp1~=-1 then
		fightnum=2;
		WAR.Person[id]["RP"]=limitX(WAR.Person[id]["RP"]-20,-100,200);
	end
for k=1,fightnum  do         --如果左右互搏，则攻击两次

	--预先读取所有被攻击方的属性最大值
	WAR["攻击"]=0;
	WAR["防御"]=0;
	WAR["身法"]=0;
    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
			local effect=GetWarMap(i,j,4);
            if effect>0 then              --攻击效果地方
  				local emeny=GetWarMap(i,j,2);
                 if emeny>=0 then          --有人
					local eid=WAR.Person[emeny]["人物编号"];
                    if WAR.Person[id]["我方"] ~= WAR.Person[emeny]["我方"]  then       --是敌人
						for ii,vv in pairs({"攻击","防御","身法"}) do
							if JY.Person[eid][vv]>WAR[vv] then
								WAR[vv]=JY.Person[eid][vv];
							end
						end
					end
				end
			end
		end
	end

	WAR.Person[id]["TimeAdd"]=WAR.Person[id]["TimeAdd"]+JY.Wugong[wugong]["集气"];
    
	while true do
        if math.modf((level+1)/2)*JY.Wugong[wugong]["消耗内力点数"] > JY.Person[pid]["内力"] then
            level=level-1;
        else
            break;
        end
    end

    if level<=0 then     --防止出现左右互博时第一次攻击完毕，第二次攻击没有内力的情况。
	    level=1;
    end
	
	if k==2 then
		DrawStrBox(-1,24,KfName(tmp2).."连击",C_ORANGE,24)
	end
	local magic={}
	--smagic(pid,wugongnum,magic)		--计算攻方特技发动情况//这里输入的是wugongnum，即人物的第几个武功，斗转的话，输入的是斗转星移的编号，所以不会有武功特效出现，当然可以加几个字 比如斗转星移反击之类的，也算是削弱反击吧，其实是个bug，现在看来也还不错呢。还有个bug，连击中被反击，第二次攻击位置错误，找找看
	atkmagic(pid,wugong,level,magic);
	
	
	WAR["攻击"]=JY.Person[pid]["攻击"];
	WAR["防御"]=JY.Person[pid]["防御"];
	WAR["身法"]=JY.Person[pid]["身法"];
	
	if fightnum==2 then 
		magic[0]={1,tmp1} 
	end
	--收招加快
	for i,v in pairs(magic) do
		if v[1]==11 then
			WAR.Person[id]["Time"]=WAR.Person[id]["Time"]+math.modf(1000*v[2]/100);
		end
	end
	--扩大范围
	for i,v in pairs(magic) do
		if v[1]==14 then
			hurtscope=JY.Kungfu[wugong]["伤害范围"][v[2]];
			War_FightSelectType(fightscope,hurtscope,x,y);
		end
	end
    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
			local effect=GetWarMap(i,j,4);
            if effect>0 then              --攻击效果地方
  				local emeny=GetWarMap(i,j,2);
                 if emeny>=0 then          --有人
					local eid=WAR.Person[emeny]["人物编号"];
					--PUSH(JY.Person[eid]["内功经验"]);
					
--					if JY.Person[eid]["内功"]>0 then
--						local dxx=math.abs(JY.Person[eid]["内力性质"]-JY.Wugong[JY.Person[eid]["内功"]]["思想"]);
--						if dxx>1 then
--							JY.Person[eid]["内功经验"]=JY.Person[eid]["内功经验"]*(24-dxx)/24;
--						end
--					end
					
                    if WAR.Person[id]["我方"] ~= WAR.Person[emeny]["我方"]  then       --是敌人
					     --只有点和面攻击可以杀内力。此时伤害类型有效
						 --[[
					     if JY.Wugong[wugong]["伤害类型"]==1 and (fightscope==0 or fightscope==3) then
                             WAR.Person[emeny]["点数"]=-War_WugongHurtNeili(emeny,wugong,level)
							 SetWarMap(i,j,4,3);
							 WAR.Effect=3;
                         else
                             WAR.Person[emeny]["点数"]=-War_WugongHurtLife(emeny,wugong,level)
							 WAR.Effect=2;
							 SetWarMap(i,j,4,2);
                         end
						 --]]
						 War_WugongHurt(id,emeny,magic,hurt,atk,wugong)
						 --lib.Debug(WAR.Person[WAR.CurID]["点数"])
						 WAR.Effect=2;
						 --if WAR.Person[emeny]["点数"]==0 then 
						--	SetWarMap(i,j,4,0)
						--else
							SetWarMap(i,j,4,2)
						--end
                     end
					 --[[
					if WAR.Person[id]["我方"] == WAR.Person[emeny]["我方"] and JY.Wugong[wugong]["伤害类型"]~=0 then
						War_WugongCure(id,emeny,magic,wugong,level)
						SetWarMap(i,j,4,2)
					end
					]]--
					-- end
					--JY.Person[eid]["内功经验"]=POP();
                 end
             end
         end
    end

    War_ShowFight(pid,wugong,JY.Wugong[wugong]["武功类型"],level,x,y,JY.Wugong[wugong]["武功动画&音效"]);



    WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+math.random(10)+1;

    --if JY.Person[pid]["武功等级" .. wugongnum]<900 then
    --   JY.Person[pid]["武功等级" .. wugongnum]=JY.Person[pid]["武功等级" .. wugongnum]+Rnd(2)+1;
    --end

    --if math.modf(JY.Person[pid]["武功等级" .. wugongnum]/100)+1 ~= level then    --武功升级了
    --    level=math.modf(JY.Person[pid]["武功等级" .. wugongnum]/100)+1;
    --    DrawStrBox(-1,-1,string.format("%s 升为 %d 级",JY.Wugong[wugong]["名称"],level),C_ORANGE,CC.Fontbig)
    --    ShowScreen();
    --    lib.Delay(500);
    --    Cls();
    --    ShowScreen();
    --end
	AddPersonAttrib(pid,"内力",-math.modf(JY.Wugong[wugong]["消耗内力点数"]*level*(1+WAR.Person[id]["吃力"]/25)));
    AddPersonAttrib(pid,"体力",-3);
	--空挥提高基础兵器值
	local dengjie=JY.Wugong[wugong]["等阶"];
	local bq_str;
	if JY.Wugong[wugong]["武功类型"]==1 then
		bq_str="拳掌";
	elseif JY.Wugong[wugong]["武功类型"]==2 then
		bq_str="御剑";
	elseif JY.Wugong[wugong]["武功类型"]==3 then
		bq_str="耍刀";
	elseif JY.Wugong[wugong]["武功类型"]==4 then
		bq_str="枪棍";
	end
	if bq_str~=nil then
		local now_bq=JY.Person[pid][bq_str];
		if now_bq<100 then
			local diff=dengjie*20+10-now_bq;
				if diff>0 then
					if math.random(dengjie+2)==1 then
						AddPersonAttrib(pid,bq_str,1);
						if JY.Person[pid][bq_str]%10==0 then
							DrawStrBoxWaitKey(string.format("%sＧ%sＷ上升",JY.Person[pid]["姓名"],bq_str),C_WHITE,CC.Fontbig);
						end
					end
				end
		end
	end
	if JY.Person[pid]["生命"]<=0 then break end
end


	local dz={}
	local dznum=0
	for i=0,WAR.PersonNum-1 do
		if WAR.Person[i]["反击武功"]~=-1 and WAR.Person[i]["反击武功"]~=9999 then  			--
			dznum=dznum+1;
			dz[dznum]={i,wugong,x-WAR.Person[WAR.CurID]["坐标X"],y-WAR.Person[WAR.CurID]["坐标Y"]}
		end
	end	
	--DrawTimeBar2();
	for i = 1, dznum do
		local tmp=WAR.CurID
		WAR.CurID=dz[i][1]
		--lib.Delay(100)
		War_Fight_Sub(dz[i][1],dz[i][2]+100,dz[i][3],dz[1][4])--dz[i][3],dz[i][4])          --执行战斗
		WAR.CurID=tmp		
		WAR.Person[WAR.CurID]["反击武功"]=-1
	end
	
	WAR.Person[id]["反击武功"]=-1										--解除禁止斗转反击后反击
		
	--JY.Person[pid]["内功经验"]=POP();
    return 1;
end

function QuickWar(warid)
	WarLoad(warid);	
	--JY.Status=GAME_WMAP;
	WarSelectTeam();          --选择我方
	WarSelectEnemy();         --选择敌人
	CleanMemory()
	WarLoadMap(WAR.Data["地图"]);       --加载战斗地图
	WarPersonSort();    --战斗人按轻功排序
	local warStatus=0;
	for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
		WAR.Person[i]["Time"]=800-(i*1000/(WAR.PersonNum+2))+smagic(pid,42,1);
	end
	GetJiqi();
	
	while true do
		
		for i=0,WAR.PersonNum-1 do
			if WAR.Person[i]["死亡"]==false then
				WAR.Person[i]["Time"]=WAR.Person[i]["Time"]+WAR.Person[i]["TimeAdd"];
			end
		end
		--如果进度大于1000，则行动
		for p=0,WAR.PersonNum-1 do
			if WAR.Person[p]["死亡"]==false then
				if WAR.Person[p]["Time"]>1000 then 
					WAR.CurID=p;
					local pid=WAR.Person[p]["人物编号"];
					local kfnum=0;
					for i=1,5 do
						if JY.Person[pid]["外功"..i]>0 then
							kfnum=i;
						else
							break;
						end
					end
					if kfnum>1 then
						kfnum=math.random(kfnum);
					end
					--lib.Debug(">>"..kfnum)
					if kfnum>0 then
						local hurt,atk,level=GetAtk(pid,JY.Person[pid]["外功"..kfnum],math.modf(JY.Person[pid]["外功经验"..kfnum]/100)+1);
						local magic={};
						atkmagic(pid,JY.Person[pid]["外功"..kfnum],level,magic);
						for emeny=0,WAR.PersonNum-1 do
							if emeny~=p then
								War_WugongHurt(p,emeny,magic,hurt,atk,JY.Person[pid]["外功"..kfnum]);
							end
						end
					end
					WAR.Person[p]["Time"]=WAR.Person[p]["Time"]-1000;
					WAR.Person[p]["Time"]=WAR.Person[p]["Time"]+WAR.Person[p]["TimeAdd"]
					warStatus=War_isEnd();        --战斗是否结束？   0继续，1赢，2输
					if warStatus>0 then
						break;
					end
				end	
			end
		end	
		if warStatus>0 then
			break;
		end
		GetJiqi();
	end
	for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
		AddPersonAttrib(pid,"生命",math.huge);
	end
	if warStatus==1 then
			return true;
    elseif warStatus==2 then
			return false;
    end
end

--计算人方向
--(x1,y1) 人位置     -(x2,y2) 目标位置
--返回： 方向
function War_Direct(x1,y1,x2,y2)             --计算人方向
    local x=x2-x1;
    local y=y2-y1;
	if x==0 and y==0 then return nil end
    if math.abs(y)>math.abs(x) then
        if y>0 then
            return 3;
        else
            return 0
        end
    else
        if x>0 then
            return 1;
        else
            return 2;
        end
    end
end


--显示战斗动画
--pid 人id
--wugong  武功编号， 0 表示用毒解毒等，使用普通攻击效果
--wogongtype =0 医疗用毒解毒，1,2,3,4 武功类型  -1 暗器
--level 武功等级
--x,y 攻击坐标
--eft  武功动画效果id  eft.idx/grp中的效果
function War_ShowFight(pid,wugong,wugongtype,level,x,y,eft)              --显示战斗动画
	local x0=WAR.Person[WAR.CurID]["坐标X"];
	local y0=WAR.Person[WAR.CurID]["坐标Y"];
	
	--攻击前显示武功名称
	local kfname=JY.Wugong[wugong]["名称"]
	local kfx=CC.ScreenW/2-string.len(kfname)*CC.Fontbig/4-4
	DrawStrNewBox(kfx,CC.FontBig*2,kfname,C_WHITE,CC.Fontbig);
	ShowScreen()
	lib.Delay(800)
	
    local fightdelay,fightframe,sounddelay;
	fightdelay=8;
	sounddelay=8;
    if wugongtype>=0 and wugongtype<5 then
		--lib.Debug(JY.Person[pid]["战斗动作"]..'<:>'..(wugongtype+1))
		fightframe=JY.fmp[JY.Person[pid]["战斗动作"]][wugongtype+1]
    else            ---暗器，这些数据什么意思？？
        fightframe=0;
    end
	
	--对那些没有动画帧数的，使用默认的帧数
	if fightframe==0 then
		for i=5,1,-1 do
			if JY.fmp[JY.Person[pid]["战斗动作"]][i]~=0 then
				fightframe=JY.fmp[JY.Person[pid]["战斗动作"]][i]
				wugongtype=i-1
			end
		end		
	end
	
    local framenum=fightdelay+CC.Effect[eft];            --总帧数

    local startframe=0;               --计算fignt***中当前出招起始帧
    if wugongtype>=0 then
        for i=0,wugongtype-1 do
            startframe=startframe+4*JY.fmp[JY.Person[pid]["战斗动作"]][i+1];
        end
    end

    local starteft=0;          --计算起始武功效果帧
    for i=0,eft-1 do
        starteft=starteft+CC.Effect[i];
    end

	WAR.Person[WAR.CurID]["贴图类型"]=0;
	WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);

    WarSetPerson();

	WarDrawMap(0);
	ShowScreen();

    local fastdraw;
    if CONFIG.FastShowScreen==0 or CC.AutoWarShowHead==1 then    --显示头像则全部重绘
        fastdraw=0;
	else
	    fastdraw=1;
	end

    --在显示动画前先加载贴图
    local oldpic=WAR.Person[WAR.CurID]["贴图"]/2;
	local oldpic_type=0;

    local oldeft=-1;

    for i=0,framenum-1 do
        local tstart=lib.GetTime();
		local mytype;
        if fightframe>0 then
            WAR.Person[WAR.CurID]["贴图类型"]=1;
		    mytype=4+WAR.CurID;
            if i<fightframe then
                WAR.Person[WAR.CurID]["贴图"]=(startframe+WAR.Person[WAR.CurID]["人方向"]*fightframe+i)*2;
            end
        else       --暗器，不使用fight中图像
            WAR.Person[WAR.CurID]["贴图类型"]=0;
            WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);
			mytype=0;
        end

        if i==sounddelay then
            PlayWavAtk(JY.Wugong[wugong]["出招音效"]);
        end
        if i==fightdelay then
            PlayWavE(eft);
        end
		local pic=WAR.Person[WAR.CurID]["贴图"]/2;
		if fastdraw==1 then
			local rr=ClipRect(Cal_PicClip(0,0,oldpic,oldpic_type,0,0,pic,mytype));
			if rr ~=nil then
				lib.SetClip(rr.x1,rr.y1,rr.x2,rr.y2);
			end
		else
			lib.SetClip(0,0,0,0);
		end
		oldpic=pic;
		oldpic_type=mytype;

		local atkdelay=0;
		if i<fightdelay then   --只显示出招
		
			atkdelay=0;
		    WarDrawMap(4,pic*2,mytype,-1);
			
			local hb=GetS(JY.SubScene,x0,y0,4);
			if CONFIG.Zoom==1 then
				hb=hb*2;
			end
			if i==1 then
				local myeft=WAR.Person[WAR.CurID]["特效动画"]
				local sf=0
				for ii=0,myeft do
					sf=sf+CC.Effect[ii];
				end
				--lib.FreeSur(ssid);
				-----------------
				local sssid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
				--
				local fontsize=CC.Fontbig;
				local starty=fontsize;
				local endy;
				if CONFIG.Zoom==0 then
					starty=starty-18;
					endy=starty+fontsize*2;
				else
					starty=starty+20;
					endy=starty+fontsize*3;
				end
				local showtime=endy-starty+fontsize*(WAR.Person[WAR.CurID]["atk点数"][0]-1);
				for ii=1,showtime do
					local yanshi=false
					if WAR.Person[WAR.CurID]["特效动画"]~=-1 then--and  ii<CC.Effect[myeft] then
						lib.PicLoadCache(3,(sf-1-math.modf(CC.Effect[myeft]*(ii-1)/showtime))*2,CC.ScreenW/2,CC.ScreenH/2-hb,2,192);
						
							local stime=lib.GetTime();
							for j=1,WAR.Person[WAR.CurID]["atk点数"][0] do
								local stry=starty+ii-(j-1)*fontsize;
								local strx;
								if between(stry,starty,endy) then
									stry=CC.ScreenH/2-stry;
									strx=CC.ScreenW/2-fontsize*string.len(WAR.Person[WAR.CurID]["atk点数"][j][1])/4;
									DrawString(strx,stry,WAR.Person[WAR.CurID]["atk点数"][j][1],WAR.Person[WAR.CurID]["atk点数"][j][2],fontsize);
								end
							end
						--[[
						for iii=1,3 do
							local spstr=WAR.Person[WAR.CurID]["特效文字"..iii];
							if type(spstr)=="string" then
								KungfuString(spstr,CC.ScreenW/2,CC.ScreenH/2,C_WHITE,CC.Fontbig,Font_Qiti,iii);
							end
						end
						]]--
						yanshi=true
					end
					for j = 1, WAR.Evade[0] do
						local wid=WAR.Evade[j];
						local theeft=WAR.Person[wid]["特效动画"]
						if theeft~=-1 then--and ii<CC.Effect[theeft] then
							local dx=WAR.Person[wid]["坐标X"]-WAR.Person[WAR.CurID]["坐标X"]
							local dy=WAR.Person[wid]["坐标Y"]-WAR.Person[WAR.CurID]["坐标Y"]
							local rx=CC.XScale*(dx-dy)+CC.ScreenW/2;
							local ry=CC.YScale*(dx+dy)+CC.ScreenH/2;
							local seft=1+math.modf(CC.Effect[theeft]*(ii-1)/showtime);
							for k=0,WAR.Person[wid]["特效动画"]-1 do
								seft=seft+CC.Effect[k];
							end
							local ehb=GetS(JY.SubScene,dx+x0,dy+y0,4)
							if CONFIG.Zoom==1 then
								ehb=ehb*2;
							end
							ry=ry-ehb
							lib.PicLoadCache(3,seft*2,rx,ry,2,192)
							for iii=1,3 do
								local spstr=WAR.Person[wid]["特效文字"..iii];
								if type(spstr)=="string" then
									KungfuString(spstr,rx,ry,C_GOLD,CC.Fontbig,Font_Qiti,iii);
								end
							end	
							yanshi=true
						end	
					end
					if yanshi then
						getkey();
						lib.ShowSurface(0)
						lib.Delay(10)
						lib.LoadSur(sssid,0,0)
					end
				end
				WAR.Person[WAR.CurID]["特效动画"]=-1;
				WAR.Person[WAR.CurID]["atk点数"]={[0]=0,};
				for i=1,WAR.Evade[0] do
					local wwid=WAR.Evade[i];
					WAR.Person[wwid]["贴图"]=-1;
					WAR.Person[wwid]["特效动画"]=-1;
					SetWarMap(WAR.Person[wwid]["坐标X"],WAR.Person[wwid]["坐标Y"],5,-1)
				end
				lib.FreeSur(sssid);
				------------------
			else
				--[[
				for ii=1,3 do
					local spstr=WAR.Person[WAR.CurID]["特效文字"..ii];
					if type(spstr)=="string" then
						KungfuString(spstr,CC.ScreenW/2,CC.ScreenH/2,C_WHITE,CC.Fontbig,Font_Qiti,ii);
						atkdelay=30;
					end
				end
				]]--
			end
			ShowScreen();
			--lib.Delay(atkdelay);
		else		--同时显示武功效果
            --starteft=starteft+1;            --此处似乎是eft第一个数据有问题，应该是10，现为9，因此加1
			--
			
			--
			if fastdraw==1 then
				local clip1={};
				clip1=Cal_PicClip(WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,oldeft,3,
										WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,starteft,3);
				local clip2={};
				clip2=Cal_PicClip(WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,oldeft,3,
										WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,starteft,3);
				local clip=ClipRect(MergeRect(clip1,clip2));

				if clip ~=nil then
					local area=(clip.x2-clip.x1)*(clip.y2-clip.y1);          --计算脏矩形面积
					if area <CC.ScreenW*CC.ScreenH/2 then        --面积足够小，则更新脏矩形。
						WarDrawMap(4,pic*2,mytype,starteft*2);
						lib.SetClip(clip.x1,clip.y1,clip.x2,clip.y2);
						WarDrawMap(4,pic*2,mytype,starteft*2);
					else    --面积太大，直接重绘
						lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
						WarDrawMap(4,pic*2,mytype,starteft*2);
					end
				else
				    WarDrawMap(4,pic*2,mytype,starteft*2);
				end
			else
				lib.SetClip(0,0,0,0);
				WarDrawMap(4,pic*2,mytype,starteft*2);
			end
			starteft=starteft+1;
			oldeft=starteft;
		end
		--DrawStrBox(kfx,CC.Fontbig*3,kfname,C_WHITE,CC.Fontbig);
		ShowScreen(fastdraw);
        lib.SetClip(0,0,0,0);

		local tend=lib.GetTime();
    	if tend-tstart<atkdelay+CC.Frame then
            lib.Delay(atkdelay+CC.Frame-(tend-tstart));
			atkdelay=0;
	    end

    end

	lib.SetClip(0,0,0,0);
    WAR.Person[WAR.CurID]["贴图类型"]=0;
    WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);
    WarSetPerson();
    WarDrawMap(0);

    ShowScreen();
    lib.Delay(200);

    WarDrawMap(2);          --全黑显示命中人物
    ShowScreen();
    lib.Delay(200);

    WarDrawMap(0);
    ShowScreen();
	for ii=1,3 do
		WAR.Person[WAR.CurID]["特效文字"..ii]=-1;
	end

	
	--显示守方特效
	--for x=0,63 do			--清除第四层，和后面的有些冲突，暂时先不管了--改了，现在应该不冲突了
	--	for y=0,63 do SetWarMap(x,y,4,0) end
	--end
	--local fanji=false
	--for i = 0, WAR.PersonNum-1 do
	--	if WAR.Person[i]["特效动画"]>100 then fanji=true break end;
	--	if WAR.Person[i]["特效动画"]~=-1 then SetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],4,1) end
	--end
	--if not fanji then
	local sssid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
	for ii=1,40 do
		local yanshi=false
		for i = 0, WAR.PersonNum-1 do		
			local theeft=WAR.Person[i]["特效动画"]
			if theeft~=-1 and ii<CC.Effect[theeft] then
				local dx=WAR.Person[i]["坐标X"]-WAR.Person[WAR.CurID]["坐标X"]
				local dy=WAR.Person[i]["坐标Y"]-WAR.Person[WAR.CurID]["坐标Y"]
				local rx=CC.XScale*(dx-dy)+CC.ScreenW/2;
				local ry=CC.YScale*(dx+dy)+CC.ScreenH/2;
				starteft=ii
				for i=0,WAR.Person[i]["特效动画"]-1 do
					starteft=starteft+CC.Effect[i];
				end
				lib.LoadSur(sssid,0,0)
				local hb=GetS(JY.SubScene,dx+x0,dy+y0,4)
				if CONFIG.Zoom==1 then
					hb=hb*2;
				end
				ry=ry-hb
				lib.PicLoadCache(3,starteft*2,rx,ry,2,192)
				for iii=1,3 do
					local spstr=WAR.Person[i]["特效文字"..iii];
					if type(spstr)=="string" then
						KungfuString(spstr,rx,ry,C_GOLD,CC.Fontbig,Font_Qiti,iii);
					end
				end
				--DrawString(0,0,tostring(WAR.Person[i]["特效文字1"]).."|"..tostring(WAR.Person[i]["特效文字2"]).."|"..tostring(WAR.Person[i]["特效文字3"]),C_WHITE,16)
				--lib.ShowSurface(0)
				--lib.Delay(10)		
				yanshi=true
			end	
		end
		if yanshi then
			getkey();
			lib.ShowSurface(0)
			lib.Delay(70)
		end
	end
	lib.FreeSur(sssid);
	--end
	ShowWarString();
	for i=1,WAR.Evade[0] do
		WAR.Person[WAR.Evade[i]]["贴图"]=WarCalPersonPic(WAR.Evade[i]);
	end
	WAR.Evade={[0]=0,}
	for i = 0, WAR.PersonNum-1 do
		WAR.Person[i]["特效动画"]=-1
		WAR.Person[i]["特效文字1"]=-1
		WAR.Person[i]["特效文字2"]=-1
		WAR.Person[i]["特效文字3"]=-1
	end
	
    lib.SetClip(0,0,0,0);
    WarDrawMap(0);
    ShowScreen();
end

function ShowWarString()
    WarDrawMap(0);
    ShowScreen();
	lib.Delay(100);
	local x0=WAR.Person[WAR.CurID]["坐标X"];
	local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local HitXY={};               --记录命中点数的坐标
	local HitXYNum=0;
    for i = 0, WAR.PersonNum-1 do
	    local x1=WAR.Person[i]["坐标X"];
	    local y1=WAR.Person[i]["坐标Y"];
		if WAR.Person[i]["死亡"]==false then
 		    --if GetWarMap(x1,y1,4)>1 then
			if WAR.Person[i]["点数"][0]>0 then
				SetWarMap(x1,y1,4,1);
				HitXY[HitXYNum]={
									x=x1,
									y=y1,
									str=WAR.Person[i]["点数"],
								}
				HitXYNum=HitXYNum+1;
 		    end
		end
	end
	if HitXYNum>0 then
		local fontsize=CC.Fontsmall;
		local starty=fontsize;
		local endy;
		if CONFIG.Zoom==0 then
			starty=starty+12;
			endy=starty+fontsize*3;
		else
			starty=starty+50;
			endy=starty+fontsize*4;
		end
		for i=0,HitXYNum-1 do
			local dx=HitXY[i].x-x0;
			local dy=HitXY[i].y-y0;
			HitXY[i].x=CC.XScale*(dx-dy)+CC.ScreenW/2;
			HitXY[i].y=CC.YScale*(dx+dy)+CC.ScreenH/2;
		end
		local surid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
		for hight=starty,480 do
			local stime=lib.GetTime();
			lib.LoadSur(surid,0,0);
			local drawed=false;
			for i=0,HitXYNum-1 do
				for j=1,HitXY[i].str[0] do
					local stry=hight-(j-1)*fontsize;
					local strx;
					if between(stry,starty,endy) then
						drawed=true;
						stry=HitXY[i].y-stry;
						strx=HitXY[i].x-fontsize*string.len(HitXY[i].str[j][1])/4;
						DrawString(strx,stry,HitXY[i].str[j][1],HitXY[i].str[j][2],fontsize);
					end
				end
			end
			if drawed then
				getkey();
				ShowScreen();
				stime=200/fontsize-(lib.GetTime()-stime);
				if stime>0 then
					lib.Delay(stime);
				end
			else
				break;
			end
		end
		lib.FreeSur(surid);
	end
    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["点数"]={[0]=0,};
    end
end


---用毒菜单
function War_PoisonMenu()              ---用毒菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(1);
	WAR.ShowHead=1;
	Cls();
	return r;
end

--计算敌人中毒点数
--pid 使毒人，
--emenyid  中毒人
function War_PoisonHurt(pid,emenyid)     --计算敌人中毒点数
    local v=math.modf((JY.Person[pid]["用毒能力"]-JY.Person[emenyid]["抗毒能力"])/4);
    if v<0 then
        v=0;
    end
    return AddPersonAttrib(emenyid,"中毒程度",v);
end

---解毒菜单
function War_DecPoisonMenu()          ---解毒菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(2);
	WAR.ShowHead=1;
	Cls();
	return r;
end

---医疗菜单
function War_DoctorMenu()            ---医疗菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(3);
	WAR.ShowHead=1;
	Cls();
	return r;
end

---执行医疗，解毒用毒
---flag=1 用毒， 2 解毒，3 医疗 4 暗器
---thingid 暗器物品id
function War_ExecuteMenu(flag,thingid)            ---执行医疗，解毒用毒暗器
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local step;

    if flag==1 then
        step=math.modf(JY.Person[pid]["用毒能力"]/15)+1;         --用毒步数
    elseif flag==2 then
        step=math.modf(JY.Person[pid]["解毒能力"]/15)+1;         --解毒步数
    elseif flag==3 then
        step=math.modf(JY.Person[pid]["医疗能力"]/15)+1;         --医疗步数
    elseif flag==4 then
        step=math.modf(JY.Person[pid]["暗器技巧"]/15)+1;         --暗器步数
    end

    War_CalMoveStep(WAR.CurID,step,1);

    local x1,y1=War_SelectMove();              --选择攻击对象

    if x1 ==nil then
        getkey();
		Cls();
        return 0;
    else
        return War_ExecuteMenu_Sub(x1,y1,flag,thingid);
    end
end


function War_ExecuteMenu_Sub(x1,y1,flag,thingid)     ---执行医疗，解毒用毒暗器的子函数，自动医疗也可调用
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];

    CleanWarMap(4,0);

	WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x1,y1) or WAR.Person[WAR.CurID]["人方向"]

	SetWarMap(x1,y1,4,1);

    local emeny=GetWarMap(x1,y1,2);
	if emeny>=0 then          --有人
		 if flag==1 then
			 if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then       --是敌人
				 WAR.Person[emeny]["点数"]=War_PoisonHurt(pid,WAR.Person[emeny]["人物编号"])
				 SetWarMap(x1,y1,4,5);
  			     WAR.Effect=5;
			 end
		 elseif flag==2 then
			 if WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then       --不是敌人
				 WAR.Person[emeny]["点数"]=ExecDecPoison(pid,WAR.Person[emeny]["人物编号"])
				 SetWarMap(x1,y1,4,6);
  			     WAR.Effect=6;
			 end
		 elseif flag==3 then
			 if WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then       --不是敌人
				 WAR.Person[emeny]["点数"]=ExecDoctor(pid,WAR.Person[emeny]["人物编号"])
				 SetWarMap(x1,y1,4,4);
  			     WAR.Effect=4;
			 end
		 elseif flag==4 then
			 if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then       --是敌人
				 WAR.Person[emeny]["点数"]=War_AnqiHurt(pid,WAR.Person[emeny]["人物编号"],thingid)
				 SetWarMap(x1,y1,4,2);
  			     WAR.Effect=2;
			 end
		 end

	end

    WAR.EffectXY={};
	WAR.EffectXY[1]={x1,y1};
	WAR.EffectXY[2]={x1,y1};

	if flag==1 then
		War_ShowFight(pid,0,0,0,x1,y1,30);
	elseif flag==2 then
		War_ShowFight(pid,0,0,0,x1,y1,36);
	elseif flag==3 then
		War_ShowFight(pid,0,0,0,x1,y1,0);
	elseif flag==4 then
		if emeny>=0 then
			War_ShowFight(pid,0,-1,0,x1,y1,JY.Thing[thingid]["暗器动画编号"]);
		end
	end

	for i=0,WAR.PersonNum-1 do
		WAR.Person[i]["点数"]=0;
	end
	if flag==4 then
		if emeny>=0 then
			instruct_32(thingid,-1);            --物品数量减少
			return 1;
		else
			return 0;                   --暗器打空，则等于没有打
		end
	else
		WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+1;
		AddPersonAttrib(pid,"体力",-2);
	end

	return 1;

end


--物品菜单
function War_ThingMenu()            --战斗物品菜单
	if true then
		return;
	end
    WAR.ShowHead=0;
    local thing={};
    local thingnum={};

    for i = 0,CC.MyThingNum-1 do
        thing[i]=-1;
        thingnum[i]=0;
    end

    local num=0;
    for i = 0,CC.MyThingNum-1 do
        local id = JY.Base["物品" .. i+1];
        if id>=0 then
            if JY.Thing[id]["类型"]==3 or JY.Thing[id]["类型"]==4 then
                thing[num]=id;
                thingnum[num]=JY.Base["物品数量" ..i+1];
                num=num+1;
            end
        end
    end

    local r=SelectThing(thing,thingnum);
	Cls();
	local rr=0;
    if r>=0 then
        if UseThing(r)==1 then
		    rr=1;
		end
    end
	WAR.ShowHead=1;
	Cls();
    return rr;
end

---使用暗器
function War_UseAnqi(id)          ---战斗使用暗器
    return War_ExecuteMenu(4,id);
end


function War_AnqiHurt(pid,emenyid,thingid)         --计算暗器伤害
    local num;
    if JY.Person[emenyid]["受伤程度"]==0 then
        num=JY.Thing[thingid]["加生命"]/4-Rnd(5);
    elseif JY.Person[emenyid]["受伤程度"]<=33 then
        num=JY.Thing[thingid]["加生命"]/3-Rnd(5);
    elseif JY.Person[emenyid]["受伤程度"]<=66 then
        num=JY.Thing[thingid]["加生命"]/2-Rnd(5);
    else
        num=JY.Thing[thingid]["加生命"]/2-Rnd(5);
    end

    num=math.modf((num-JY.Person[pid]["暗器技巧"]*2)/3);
    AddPersonAttrib(emenyid,"受伤程度",math.modf(-num/4));      --此处的num为负值

    local r=AddPersonAttrib(emenyid,"生命",math.modf(num));

    if JY.Thing[thingid]["加中毒解毒"]>0 then
        num=math.modf((JY.Thing[thingid]["加中毒解毒"]+JY.Person[pid]["暗器技巧"])/2);
        num=num-JY.Person[emenyid]["抗毒能力"];
        num=limitX(num,0,CC.PersonAttribMax["用毒能力"]);
        AddPersonAttrib(emenyid,"中毒程度",num);
    end
    return r;
end

--休息
function War_RestMenu()           --休息
    local pid=WAR.Person[WAR.CurID]["人物编号"];
	--AddShowString(WAR.CurID,"休息",C_WHITE);
    local v=3+Rnd(3);
    AddPersonAttrib(pid,"体力",v);
	--AddShowString(WAR.CurID,string.format("体力 +%d",v),M_Yellow);
    if JY.Person[pid]["体力"]>30 then
        v=3+JY.Person[pid]["生命最大值"]*(1+math.random()+Rnd(math.modf(JY.Person[pid]["体力"]/10)-1))/100;
        AddPersonAttrib(pid,"生命",v);
		--AddShowString(WAR.CurID,string.format("生命 +%d",v),M_Pink);
        v=3+JY.Person[pid]["内力最大值"]*(1+math.random()+Rnd(math.modf(JY.Person[pid]["体力"]/10)-1))/100;
        AddPersonAttrib(pid,"内力",v);
		--AddShowString(WAR.CurID,string.format("内力 +%d",v),M_Blue);
    end
    return 1;
end


--等待，把当前战斗人调到队尾
function War_WaitMenu()            --等待，把当前战斗人调到队尾
	
	WAR.Person[WAR.CurID]["Time"]=WAR.Person[WAR.CurID]["Time"]+350
	return 1
end

function War_StatusMenu()          --战斗中显示状态
    WAR.ShowHead=0;
	PersonStatus(WAR.Person[WAR.CurID]["人物编号"]);
	WAR.ShowHead=1;
end

function War_AutoMenu()           --设置自动战斗
    WAR.Person[WAR.CurID]["AI"]={1,0,0};
	WAR.ShowHead=0;
	Cls();
    War_Auto();
    return 1;
end
-------------------------------------------------------
-------------------重写部分函数---------------------
-------------------------------------------------------
function KfName(num)
	return JY.Wugong[num]["名称"];
end

function KungfuString(str,x,y,color,size,font,place)					--返回显示武功的特效文字
	local w,h=size,size+5;
	local len=string.len(str)/2
	x=x-len*w/2
	y=y-h*place
	lib.DrawStr(x,y,str,color,size,font,0,0)
	--lib.SetClip(x,y,x+len*w,y+h)
	--lib.ShowSurface(1)
	--lib.Delay(50)
end

--特效判定
--考虑以下几种情况
--#攻击时判定
--#攻击时不判定
--[[
1 额外提高伤害
2 提高伤害百分比
3 攻击时附加状态
4 攻击时吸内
5 攻击时化去内力
6 攻击时吸血
7 攻击时杀体力
8 攻击时杀集气
9 ]]--
function atkmagic(pid,kfid,kflv,sp)
	--返回攻击时的特效，参数分别为 人物id,攻击武功id,攻击武功lv,用于保存结果的表
	local p=JY.Person[pid];
	local id=WE_getwarid(pid);
	local wugong={
					{kfid,kflv},
					{p['内功'],1+div100(p['内功经验'])},
					{p['轻功'],1+div100(p['轻功经验'])},
					{p['特技'],1+div100(p['特技经验'])},
				}
	for i=1,4 do
		if wugong[i][1]>0 then
			sp[i]=smagic_sub(pid,wugong[i][1],wugong[i][2],1,20);
			sp[i][5]=wugong[i][1]
		else
			sp[i]={-1,-1,-1};
		end
	end
	for i,v in pairs{4,2,3,1} do
		if sp[v][1]>0 then
			AddAtkString(WE_getwarid(pid),sp[v][3],sp[v][4] or C_WHITE);
			for ii,vv in pairs{2,3,1} do
				if WAR.Person[WAR.CurID]['特效动画']==-1 then
					WAR.Person[WAR.CurID]['特效动画']=JY.Wugong[sp[v][5]]["武功动画&音效"];
				end
			
			--	if type(WAR.Person[WAR.CurID]['特效文字'..vv])~='string' then
			--		WAR.Person[WAR.CurID]['特效文字'..vv]=sp[v][3];
			--		WAR.Person[WAR.CurID]['特效动画']=JY.Wugong[sp[v][4]]["武功动画&音效"];
			--		break;
			--	end
			end
		end
	end
	local num=5;
	for i=1,4 do
		if sp[i][1]>0 then
			WAR.Person[id]["RP"]=limitX(WAR.Person[id]["RP"]-JY.Wugong[wugong[i][1]]["等阶"]*5,-100,200);
			local tsp=JY.Kungfu[wugong[i][1]]['特殊效果'];
			for ii=1,tsp[0] do
				local cv;
				if type(tsp[ii][3])=="function" then
					cv=tsp[ii][3](p,wugong[i][2]);
				else
					cv=tsp[ii][3];
				end
				if cv<0 then
					if tsp[ii][2]<=wugong[i][2] then
						if tsp[ii][5]==sp[i][3] then
							if type(tsp[ii][4])=="function" then
								sp[num]={tsp[ii][1],tsp[ii][4](p,wugong[i][2])};
							else
								sp[num]={tsp[ii][1],tsp[ii][4]};
							end
							num=num+1;
						end
					end
				end
			end
		end
	end
	--[[
	if sp[1][1]>0 then
		WAR.Person[WAR.CurID]['特效文字1']=sp[1][3];
	end
	if sp[2][1]>0 then
		WAR.Person[WAR.CurID]['特效文字2']=sp[2][3];
	end
	if sp[4][1]>0 then
		WAR.Person[WAR.CurID]['特效文字3']=sp[4][3];
	end]]--
end
function smagic(pid,magicid,flag)
	flag=flag or 0;
	local p=JY.Person[pid];
	local power;
	local str;
	local wugong={
					{p['内功'],p['内功经验']},
					{p['轻功'],p['轻功经验']},
					{p['特技'],p['特技经验']},
				}
	if p['内功']>0 then
		local dxx=math.abs(JY.Person[pid]["内力性质"]-JY.Wugong[p['内功']]["思想"]);
		if dxx>1 and flag==0 then
			--wugong[1][2]=p['内功经验']*(24-dxx)/24;
		end
	end
	if flag==1 then
		power=0;
	end
	for i=1,3 do
		if wugong[i][1]>0 then
			local tmp1,tmp2=smagic_sub(pid,wugong[i][1],1+math.modf(wugong[i][2]/100),magicid);
			if tmp1~=-1 and tmp2~=-1 then
				if flag==1 then
					power=power+tmp1;
					str=tmp2;
				else
					if power==nil or tmp1>power then
						power,str=tmp1,tmp2;
					end
				end
			end
		end
	end
	power=power or -1;
	return power,str;
end
function myRandom(k,luck_a,luck_b,luck_c)
	local t=1;
	local luck=0;
	if luck_b<luck_c then
		--luck=luck_a+luck_b-luck_c;
		luck_a=luck_a+luck_b-luck_c;
		luck_b=0;
	end
	if Rnd(100)<=luck_a then
		t=t+1;
	end
	if Rnd(100)<=luck_b then
		t=t+1;
	end
	for i=1,t do
		if Rnd(100)<=k then
			return true;
		end
	end
	return false;
end
function smagic_sub(pid,kf,kflv,magicid,magicid2)
	--magicid,判断特定特效,为空则随机选择(1-10)
	--输入武功id,lv,特效id,返回发动效果，和发动文字(-1表示否)
	--首先决定是否发动,然后在待选范围内随机
	local sp=JY.Kungfu[kf]['特殊效果'];
	local luck_a,luck_b,luck_c=0,0,0;
	local jl_add=0;
	local wid=WE_getwarid(pid);
	local RPMAX,RPMIN=false,false;
	if wid>=0 then
		if WAR.Person[wid]["RP"]>=100 then
			RPMAX=true;
		--elseif WAR.Person[wid]["RP"]<0 then
			--RPMIN=true;
		end
	end
	luck_a=JY.Person[pid]["福缘"];
	if magicid<=40 then
		jl_add=smagic(pid,57,1);
		luck_a=luck_a+smagic(pid,68,1);
		if JY.Wugong[kf]["武功类型"]<=5 then
			if JY.Wugong[kf]["倾向"]==1 then
				luck_b=JY.Person[pid]["攻击"];
				luck_c=WAR["攻击"];
			elseif JY.Wugong[kf]["倾向"]==2 then
				luck_b=JY.Person[pid]["防御"];
				luck_c=WAR["防御"];
			elseif JY.Wugong[kf]["倾向"]==3 then
				luck_b=JY.Person[pid]["身法"];
				luck_c=WAR["身法"];
			else
				luck_b=(JY.Person[pid]["攻击"]+JY.Person[pid]["防御"]+JY.Person[pid]["身法"])/3;
				luck_c=(WAR["攻击"]+WAR["防御"]+WAR["身法"])/3;
			end
		elseif JY.Wugong[kf]["武功类型"]==7 then
			luck_b=JY.Person[pid]["防御"];
			luck_c=WAR["防御"];
		elseif JY.Wugong[kf]["武功类型"]==8 then
			luck_b=JY.Person[pid]["身法"];
			luck_c=WAR["身法"];
		else
			luck_b=JY.Person[pid]["资质"]/2;
		end
	end
	local spkind,sppower,spword=-1,-1,-1;
	local spcolor;
	if magicid2==nil then	--特定效果是否发动，全部判断一次，返回效果高的
		for i=1,sp[0] do
			if sp[i][1]==magicid then
				if (sp[i][2]>=0 and kflv>=sp[i][2]) or (sp[i][2]<0 and kflv<-sp[i][2]) then
					local cv,cp;
					if type(sp[i][3])=="function" then
						cv=sp[i][3](JY.Person[pid],kflv);
					else
						cv=sp[i][3];
					end
					if type(sp[i][4])=="function" then
						cp=sp[i][4](JY.Person[pid],kflv);
					else
						cp=sp[i][4];
					end
					if magicid>80 then
						cp=cv*1000+cp;
					end
					if cp>sppower then
						if magicid>40 then
							spkind,sppower,spword,spcolor=sp[i][1],cp,sp[i][5],sp[i][6];
						else
							if RPMAX or ( (not RPMIN) and myRandom(cv+jl_add,luck_a,luck_b,luck_c)) then
								spkind,sppower,spword,spcolor=sp[i][1],cp,sp[i][5],sp[i][6];
							end
						end
					end
				end
			end
		end
		return sppower,spword,spcolor;
	else	--不定效果，先判断是否发动，然后在全部可发动效果(1-10)中随机
		local gl={[0]=0};
		local glh=1;
		for i=1,sp[0] do
			gl[i]=gl[i-1];
			if between(sp[i][1],magicid,magicid2) then
				if (sp[i][2]>=0 and kflv>=sp[i][2]) or (sp[i][2]<0 and kflv<sp[i][2]) then
					local cv;
					if type(sp[i][3])=="function" then
						cv=sp[i][3](JY.Person[pid],kflv);
					else
						cv=sp[i][3];
					end
					cv=cv+jl_add;
					gl[i]=gl[i-1]+cv;
					glh=glh*(1-cv/100);
				end
			end
		end
		glh=100-100*glh;
		if RPMAX or ( (not RPMIN) and myRandom(glh,luck_a,luck_b,luck_c)) then	--发动
			--决定具体发动哪一项
			local sel=gl[sp[0]]*Rnd(100)/100;
			for i=1,sp[0] do
				if sel>=gl[i-1] and sel<gl[i] then
					local cp;
					if type(sp[i][4])=="function" then
						cp=sp[i][4](JY.Person[pid],kflv);
					else
						cp=sp[i][4];
					end
					spkind,sppower,spword,spcolor=sp[i][1],cp,sp[i][5],sp[i][6];
					break;
				end
			end
		end
		return {spkind,sppower,spword,spcolor};
	end
end
	
function War_WugongHurt(id,emeny,magic,hurt,atk,kungfu)             --重写计算武功伤害生命,pid攻方人物编号,eid守方人物编号
	local pid=WAR.Person[id]["人物编号"]
	local eid=WAR.Person[emeny]["人物编号"]
	
	local def=JY.Person[eid]["防御"];
	local vaule;
	local defmagic={};
	local spkf={"内功","特技","轻功"};
	
	--守方特效发动率降低
	local sf_fdl=100;
	for i,v in pairs(magic) do
		if v[1]==12 then
			sf_fdl=sf_fdl-v[2];
		end
	end
	for i,v in pairs(spkf) do
		local kf={JY.Person[eid][v],JY.Person[eid][v..'经验']};
		defmagic[i]={-1,-1,-1};
		if kf[1]>0 then
			if math.random(100)<=sf_fdl then
				--计算特效
				defmagic[i]=smagic_sub(eid,kf[1],1+div100(kf[2]),21,40);
			end
		end
	end
	WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]+600/(100-limitX(JY.Person[eid]["福缘"]*JY.Person[eid]["等级"]/100,0,80)),-100,200);
	local num=4;
	for i=1,3 do
		if defmagic[i][1]>0 then
			--WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-JY.Wugong[JY.Person[eid][spkf[i]]]["等阶"]*4,-100,200);
			local kf={JY.Person[eid][spkf[i]],1+math.modf(JY.Person[eid][spkf[i]..'经验']/100)};
			if kf[1]>0 then
				local tsp=JY.Kungfu[kf[1]]['特殊效果'];
				for ii=1,tsp[0] do
					if type(tsp[ii][3])=="function" then
						tsp[ii][3]=tsp[ii][3](JY.Person[pid],kf[2]);
					end
					if type(tsp[ii][4])=="function" then
						tsp[ii][4]=tsp[ii][4](JY.Person[pid],kf[2]);
					end
					if tsp[ii][3]<0 then
						if tsp[ii][2]<=kf[2] then
							if tsp[ii][5]==defmagic[i][3] then
								defmagic[num]={tsp[ii][1],tsp[ii][4]};
								num=num+1;
							end
						end
					end
				end
			end
		end
	end
	local def_add1,def_dec1=0,0;
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]["死亡"] then
			if WAR.Person[i]["我方"]==WAR.Person[emeny]["我方"] then
				local cid=WAR.Person[i]["人物编号"];
				local v=smagic(cid,92,1);
				local len=math.modf(v/1000);
				local power=v-len*1000;
				if math.abs(WAR.Person[i]["坐标X"]-WAR.Person[emeny]["坐标X"])+math.abs(WAR.Person[i]["坐标Y"]-WAR.Person[emeny]["坐标Y"])<=len then
					if power>def_add1 then
						def_add1=power;
					end
				end
			else
				local cid=WAR.Person[i]["人物编号"];
				local v=smagic(cid,82,1);
				local len=math.modf(v/1000);
				local power=v-len*1000;
				if math.abs(WAR.Person[i]["坐标X"]-WAR.Person[emeny]["坐标X"])+math.abs(WAR.Person[i]["坐标Y"]-WAR.Person[emeny]["坐标Y"])<=len then
					if power>def_dec1 then
						def_dec1=power;
					end
				end
			end
		end
	end
	def=GetAttrib(eid,"防御")
	def=math.modf(def*(100+def_add1-def_dec1)/100);
	if def<0 then
		def=0;
	end
	--lib.Debug(string.format("hurt=%d,atk=%d,def=%d",hurt,atk,def))
	--def=def+100;
	--lib.Debug(JY.Person[pid]["姓名"]..':'..hurt..'|'..atk..','..def)
	
	--斗转
	for i,v in pairs(defmagic) do
		if v[1]==24 then
			if WAR.Person[emeny]["反击武功"]~=9999 then					
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
				WAR.Person[emeny]["反击武功"]=v[2];
				if i<4 then
					WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-25,-100,200);
				end
			end
		end
	end
	--如果发动了闪避，则斗转以外的特效全部无效
	for i,v in pairs(defmagic) do
		if v[1]==27 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			WAR.Evade[0]=WAR.Evade[0]+1;
			WAR.Evade[WAR.Evade[0]]=emeny;
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-20,-100,200);
			end
			return 0;
		end
	end
	--如果发动了抵抗特效，则攻方特效无效
	for i,v in pairs(defmagic) do
		if v[1]==23 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-15,-100,200);
			end
			--[[
			magic={
					{-1,-1,-1},
					{-1,-1,-1},
					{-1,-1,-1},
					{-1,-1,-1},
				}
				]]--
			for ii,vv in pairs(magic) do
				if vv[2]>0 then
					vv[2]=0;
				end
			end
		end
	end
	--会心
	for i,v in pairs(magic) do
		if v[1]==3 then
			def=def*(100-v[2])/100;
		end
	end
	--防御特效加防
	for i,v in pairs(defmagic) do
		if v[1]==29 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			def=def+v[2];
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-8,-100,200);
			end
		end
	end
	for i,v in pairs(defmagic) do
		if v[1]==30 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			def=def*(100+v[2])/100;
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-8,-100,200);
			end
		end
	end
	
	--反震
	for i,v in pairs(defmagic) do
		if v[1]==26 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			SetWarMap(WAR.Person[id]["坐标X"],WAR.Person[id]["坐标Y"],4,2);
			vaule=AddPersonAttrib(pid,"生命",-v[2])
			if vaule~=0 then
				AddShowString(id,string.format("反震 %d",vaule),M_Wheat);
			end
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-15,-100,200);
			end
		end
	end
	
	
	--加力-护体
	local dmg=0;
	for i,v in pairs(magic) do
		if v[1]==1 then
			dmg=dmg+v[2];
		end
	end
	for i,v in pairs(defmagic) do
		if v[1]==21 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			dmg=dmg-v[2];
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-10,-100,200);
			end
		end
	end
	--重创-卸力
	local per=100;
	for i,v in pairs(magic) do
		if v[1]==2 then
			per=per+v[2];
		end
	end
	for i,v in pairs(defmagic) do
		if v[1]==22 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-12,-100,200);
			end
			per=per-v[2];
		end
	end
	--考虑属性差异
	local sxc=0
	if JY.Wugong[kungfu]["倾向"]==1 then
		sxc=(JY.Person[pid]["攻击"]-JY.Person[eid]["攻击"])
	elseif JY.Wugong[kungfu]["倾向"]==2 then
		sxc=(JY.Person[pid]["防御"]-JY.Person[eid]["防御"])
	elseif JY.Wugong[kungfu]["倾向"]==3 then
		sxc=(JY.Person[pid]["身法"]-JY.Person[eid]["身法"])
	elseif JY.Wugong[kungfu]["倾向"]==4 then
		sxc=(JY.Person[pid]["攻击"]-JY.Person[eid]["攻击"]+JY.Person[pid]["防御"]-JY.Person[eid]["防御"]+JY.Person[pid]["身法"]-JY.Person[eid]["身法"])/3
	end
	if sxc>0 then
		per=per+sxc*3/4;
	elseif sxc<0 then
		per=per+sxc/2;
	end
	if per<10 then
		per=10;
	end
	--初步计算hurt
	if WAR.Person[emeny]["招架"]>0 and WAR.Person[emeny]["招架"]<6 then
		local zj=JY.Person[eid]["外功"..WAR.Person[emeny]["招架"]];
		local zjlv=math.modf(JY.Person[eid]["外功经验"..WAR.Person[emeny]["招架"]]/100)+1;
		if zj>0 then
			hurt=hurt-JY.Wugong[zj]["格挡"]*zjlv;
		end
	end
	if hurt<10 then
		hurt=10;
	end
	--lib.Debug(string.format("HURT:%d,per:%d,atk:%d,def:%d",hurt,per,atk,def));
	hurt=hurt*per/100+dmg+limitX((atk-def)*0.7,-def/5,atk/4);
	hurt=hurt*atk/(atk+def);
	--lib.Debug("F:"..hurt)
	--[[
	if atk-def>0 then
		hurt=hurt*(0.5+limitX((atk-def)/(200+def/2),0,0.4));
	else
		hurt=hurt*(0.5-limitX((def-atk)/(400+atk),0,0.3));
	end
	]]--
	--考虑距离因素
	
	local offset=math.abs(WAR.Person[WAR.CurID]["坐标X"]-WAR.Person[emeny]["坐标X"])+
                 math.abs(WAR.Person[WAR.CurID]["坐标Y"]-WAR.Person[emeny]["坐标Y"]);

    if offset <10 then
        hurt=hurt*(100-(offset-1)*3)/100;
    else
        hurt=hurt*2/3;
    end
	
	hurt=hurt*(1000+Rnd(100)-Rnd(100))/1000+(Rnd(10)-Rnd(10));
	hurt=math.modf(hurt);
	--[[
	local adf=JY.Person[pid]["攻击"]-JY.Person[eid]["防御"];
	if adf>0 then
		hurt=hurt+JY.Person[pid]["攻击"]*limitX(adf/12,0,1)+Rnd(10);
	elseif adf<0 then
		hurt=hurt-JY.Person[pid]["攻击"]*limitX(-adf/12,0,1)-Rnd(10);
	end
	]]--
	--反弹
	for i,v in pairs(defmagic) do
		if v[1]==25 then
			if i<=3 then
				WAR.Person[emeny]["特效动画"]=JY.Wugong[JY.Person[eid][spkf[i]][1]]["武功动画&音效"];
				WAR.Person[emeny]["特效文字"..i]=v[3];
			end
			SetWarMap(WAR.Person[id]["坐标X"],WAR.Person[id]["坐标Y"],4,2);
			local selfhurt=AddPersonAttrib(pid,"生命",-math.modf(hurt*v[2]/100));
			hurt=hurt+selfhurt;
			AddShowString(id,string.format("反弹 %d",selfhurt),M_Wheat);
			if i<4 then
				WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]-15,-100,200);
			end
		end
	end
    if hurt<10 then
        hurt=Rnd(10)+10;
    end
    hurt=-AddPersonAttrib(eid,"生命",-hurt);
	
	--化功
	for i,v in pairs(magic) do
		if v[1]==4 then
			local xinei=math.modf(hurt*v[2]/100);
			vaule=AddPersonAttrib(eid,"内力",-xinei);
			if vaule~=0 then
				AddShowString(emeny,string.format("内力 %d",vaule),M_Indigo);
			end
		end
	end
	--吸星
	for i,v in pairs(magic) do
		if v[1]==5 then
			local xinei=math.modf(hurt*v[2]/100);
			xinei=-AddPersonAttrib(eid,"内力",-xinei);
			AddShowString(emeny,string.format("内力 -%d",xinei),M_Indigo);
			vaule=AddPersonAttrib(pid,"内力",xinei);
			if vaule~=0 then
				AddShowString(id,string.format("内力 +%d",vaule),M_Blue);
			end
		end
	end
	--吸血
	for i,v in pairs(magic) do
		if v[1]==6 then
			local xixue=math.modf(hurt*v[2]/100);
			vaule=AddPersonAttrib(pid,"生命",xixue);
			if vaule~=0 then
				AddShowString(id,string.format("吸血 +%d",vaule),M_Pink);
			end
		end
	end
	--泄气
	WAR.Person[emeny]["TimeAdd"]=0;
	for i,v in pairs(magic) do
		if v[1]==7 then
			WAR.Person[emeny]["TimeAdd"]=WAR.Person[emeny]["TimeAdd"]-v[2];
			AddShowString(emeny,string.format("集气 -%d",v[2]),M_Gray);
		end
	end
	for i,v in pairs(magic) do
		if v[1]==10 then
			WAR.Person[emeny]["TimeAdd"]=WAR.Person[emeny]["TimeAdd"]-math.modf(hurt*v[2]/100);
			AddShowString(emeny,string.format("集气 -%d",math.modf(hurt*v[2]/100)),M_Gray);
		end
	end
	--虚脱
	for i,v in pairs(magic) do
		if v[1]==8 then
			vaule=AddPersonAttrib(eid,"体力",-v[2]);
			if vaule~=0 then
				AddShowString(emeny,string.format("体力 %d",vaule),M_Yellow);
			end
		end
	end
	--异常状态
	local kangmo=smagic(eid,57,1);
	for i,v in pairs(magic) do
		if v[1]==9 then
			local kind,power;
			kind=math.modf(v[2]/100);
			power=v[2]%100;
			power=math.modf(power*(100-kangmo)/100);
			if power==0 then
				power=100;
			end
			if kind==1 and smagic(eid,71)<0 then
				if JY.Person[eid]["中毒"]<power*2 then
					power=math.modf(power*(120-JY.Person[eid]["中毒"])/200);
				else
					power=0;
				end
				vaule=AddPersonAttrib(eid,"中毒",power);
				if vaule~=0 then
					AddShowString(emeny,string.format("中毒 +%d",vaule),M_Green);
				end
			elseif kind==2 and smagic(eid,72)<0 then
				if JY.Person[eid]["内伤"]<power*2 then
					power=math.modf(power*(120-JY.Person[eid]["内伤"])/200);
				else
					power=0;
				end
				vaule=AddPersonAttrib(eid,"内伤",power);
				if vaule~=0 then
					AddShowString(emeny,string.format("内伤 +%d",vaule),M_DarkRed);
				end
			elseif kind==3 and smagic(eid,73)<0 then
				if JY.Person[eid]["流血"]<power*2 then
					power=math.modf(power*(120-JY.Person[eid]["流血"])/200);
				else
					power=0;
				end
				vaule=AddPersonAttrib(eid,"流血",power);
				if vaule~=0 then
					AddShowString(emeny,string.format("流血 +%d",vaule),M_Red);
				end
			elseif kind==11 and smagic(eid,81)<0 then
				if WAR.Person[emeny]["骨折"]<power*2 then
					power=math.modf(power*(120-WAR.Person[emeny]["骨折"])/200);
				else
					power=0;
				end
				vaule=WAR.Person[emeny]["骨折"];
				WAR.Person[emeny]["骨折"]=limitX(vaule+power,0,100);
				vaule=WAR.Person[emeny]["骨折"]-vaule;
				if vaule~=0 then
					AddShowString(emeny,string.format("骨折 +%d",vaule),M_Sienna);
				end
			elseif kind==12 and smagic(eid,82)<0 then
				if WAR.Person[emeny]["封穴"]<power*2 then
					power=math.modf(power*(120-WAR.Person[emeny]["封穴"])/200);
				else
					power=0;
				end
				vaule=WAR.Person[emeny]["封穴"];
				WAR.Person[emeny]["封穴"]=limitX(vaule+power,0,100);
				vaule=WAR.Person[emeny]["封穴"]-vaule;
				if vaule~=0 then
					AddShowString(emeny,string.format("封穴 +%d",vaule),M_DimGray);
				end
			elseif kind==13 and smagic(eid,83)<0 then
				if WAR.Person[emeny]["吃力"]<power*2 then
					power=math.modf(power*(120-WAR.Person[emeny]["吃力"])/200);
				else
					power=0;
				end
				vaule=WAR.Person[emeny]["吃力"];
				WAR.Person[emeny]["吃力"]=limitX(vaule+power,0,100);
				vaule=WAR.Person[emeny]["吃力"]-vaule;
				if vaule~=0 then
					AddShowString(emeny,string.format("吃力 +%d",vaule),M_SlateGray);
				end
			elseif kind==14 and smagic(eid,84)<0 then
				if WAR.Person[emeny]["恍惚"]<power*2 then
					power=math.modf(power*(120-WAR.Person[emeny]["恍惚"])/200);
				else
					power=0;
				end
				vaule=WAR.Person[emeny]["恍惚"];
				WAR.Person[emeny]["恍惚"]=limitX(vaule+power,0,100);
				vaule=WAR.Person[emeny]["恍惚"]-vaule;
				if vaule~=0 then
					AddShowString(emeny,string.format("恍惚 +%d",vaule),M_MediumTurquoise);
				end
			end
		end
	end
    WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+math.modf(hurt/5)+JY.Person[eid]["等级"];

	WAR.Person[emeny]["RP"]=limitX(WAR.Person[emeny]["RP"]+hurt/20,-100,200);
    if JY.Person[eid]["生命"]<=0 then                 --打死敌人获得额外经验
		--tmp1,tmp2=smagic(eid,defnei,defneilv,8)
		--if tmp1==0 then									
			JY.Person[eid]["生命"]=0;
			local addexp=JY.Person[eid]["等级"]^2/3+JY.Person[eid]["等级"]*5;
			local lvdiff=JY.Person[pid]["等级"]-JY.Person[eid]["等级"]
			lvdiff=limitX(lvdiff,-12,6);
			if lvdiff>0 then
				addexp=addexp*(7-lvdiff)/7;
			else
				addexp=addexp*(12-lvdiff)/12;
			end
			addexp=math.modf(addexp+JY.Person[eid]["等级"]+50)+Rnd(10);
			WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+addexp;
			WAR.Person[emeny]["特效动画"]=-1
			WAR.Person[emeny]["特效文字1"]=-1
			WAR.Person[emeny]["特效文字2"]=-1
			WAR.Person[emeny]["特效文字3"]=-1
			WAR.Person[emeny]["反击武功"]=-1;
		--[[else														--神罩复活
			JY.Person[eid]["生命"]=math.modf(JY.Person[eid]["生命最大值"]*tmp2/100);
			WAR.Person[emeny]["特效动画"]=JY.Wugong[defnei]["武功动画&音效"]
			WAR.Person[emeny]["反击武功"]=-1;
			WAR.Person[emeny]["特效文字1"]=-1
			WAR.Person[emeny]["特效文字2"]=-1
			WAR.Person[emeny]["特效文字3"]=tmp2
			
		end]]--
    end
	AddShowString(emeny,string.format("生命 -%d",hurt),C_WHITE);
    --[[
	伤血的都是橙色
	伤内力的都是紫色
	伤体力的都是绿色
	中毒 墨绿
	流血 大红
	内伤 粉色
	恍惚 灰色
	吃力 蓝色
	封穴 黑色
	
	]]--
end

function AddShowString(id,str,color)
	local tid=WAR.Person[id]["点数"][0];
	tid=tid+1;
	WAR.Person[id]["点数"][0]=tid;
	WAR.Person[id]["点数"][tid]={str,color};
end
function AddAtkString(id,str,color)
	local tid=WAR.Person[id]["atk点数"][0];
	tid=tid+1;
	WAR.Person[id]["atk点数"][0]=tid;
	WAR.Person[id]["atk点数"][tid]={str,color};
end

--返回轻功
function GetSpeed(pid)
	local speed=JY.Person[pid]["身法"];
	speed=GetAttrib(pid,"身法");
	return speed;
end

function GetLv(pid,id)
	local kfnum=JY.Person[pid]["外功"..id];
	if kfnum<=0 then
		return 0;
	end
	local lv=1+math.modf(JY.Person[pid]["外功经验"..id]/100);
	for i=1,5 do
		local kfid,kfexp=JY.Person[pid]["外功"..i],JY.Person[pid]["外功经验"..i];
		if kfid>0 then
			for j=1,JY.Kungfu[kfid]["配合武功"][0] do
				if kfnum==JY.Kungfu[kfid]["配合武功"][j][1] then
					lv=lv+JY.Kungfu[kfid]["配合武功"][j][2]*(1+math.modf(kfexp/100))/10;
					break;
				end
			end
		end
	end
	for i,v in pairs({"内功","轻功","特技"}) do
		local kfid,kfexp=JY.Person[pid][v],JY.Person[pid][v.."经验"];
		if kfid>0 then
			for j=1,JY.Kungfu[kfid]["配合武功"][0] do
				if kfnum==JY.Kungfu[kfid]["配合武功"][j][1] then
					lv=lv+JY.Kungfu[kfid]["配合武功"][j][2]*(1+math.modf(kfexp/100))/10;
					break;
				end
			end
		end
	end
	lv=math.modf(lv);
	return lv;
end
function GetAtk(pid,kfnum,lv)							--返回攻击
	--local num=GetAtkKungfu(pid)
	--基础伤害
	lv=limitX(lv,1,10);
	--武功之间配合加伤害
	--只需要武功栏里有该武功即可
	for i=1,5 do
		local kfid,kfexp=JY.Person[pid]["外功"..i],JY.Person[pid]["外功经验"..i];
		if kfid>0 then
			for j=1,JY.Kungfu[kfid]["配合武功"][0] do
				if kfnum==JY.Kungfu[kfid]["配合武功"][j][1] then
					lv=lv+JY.Kungfu[kfid]["配合武功"][j][2]*(1+math.modf(kfexp/100))/10;
					break;
				end
			end
		end
	end
	for i,v in pairs({"内功","轻功","特技"}) do
		local kfid,kfexp=JY.Person[pid][v],JY.Person[pid][v.."经验"];
		if kfid>0 then
			for j=1,JY.Kungfu[kfid]["配合武功"][0] do
				if kfnum==JY.Kungfu[kfid]["配合武功"][j][1] then
					lv=lv+JY.Kungfu[kfid]["配合武功"][j][2]*(1+math.modf(kfexp/100))/10;
					break;
				end
			end
		end
	end
	lv=math.modf(lv);
	PUSH(lv);
			for i=lv,0,-1 do
				if JY.Person[pid]["内力"]>=JY.Wugong[kfnum]["消耗内力点数"]*i then
					lv=i;
					break;
				end
			end
	if lv<1 then
		lv=1;
	end
	local hurt=JY.Wugong[kfnum]["伤害"]*math.min(10,lv)+JY.Wugong[kfnum]["伤害修正"]*math.max(lv-10,0);
	hurt=math.modf(hurt);
	--内功武功配合
	local ng,nglv=JY.Person[pid]["内功"],1+div100(JY.Person[pid]["内功经验"]);
	if ng>0 then
		local dxx=math.abs(JY.Wugong[kfnum]["思想"]-JY.Wugong[ng]["思想"]);
		dxx=JY.Wugong[ng]["伤害"]--*(1-(dxx/JY.Wugong[ng]["伤害修正"])^2);
		if dxx>0 then
			hurt=hurt+math.modf(dxx*math.min(lv,nglv));
		end
	end
	local atk=JY.Person[pid]["攻击"];
	
	--武功武器配合加伤害
	
	--武器加攻击
	
	
	
	--计算攻击力
	atk=GetAttrib(pid,"攻击");
	local atk_add,atk_dec=0,0;
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]["死亡"] then
			if WAR.Person[i]["我方"]==WAR.Person[WAR.CurID]["我方"] then
				local cid=WAR.Person[i]["人物编号"];
				local v=smagic(cid,81,1);
				local len=math.modf(v/1000);
				local power=v-len*1000;
				if math.abs(WAR.Person[i]["坐标X"]-WAR.Person[WAR.CurID]["坐标X"])+math.abs(WAR.Person[i]["坐标Y"]-WAR.Person[WAR.CurID]["坐标Y"])<=len then
					if power>atk_add then
						atk_add=power;
					end
				end
			else
				local cid=WAR.Person[i]["人物编号"];
				local v=smagic(cid,91,1);
				local len=math.modf(v/1000);
				local power=v-len*1000;
				if math.abs(WAR.Person[i]["坐标X"]-WAR.Person[WAR.CurID]["坐标X"])+math.abs(WAR.Person[i]["坐标Y"]-WAR.Person[WAR.CurID]["坐标Y"])<=len then
					if power>atk_dec then
						atk_dec=power;
					end
				end
			end
		end
	end
	atk=math.modf(atk*(100+atk_add-atk_dec)/100);
	lv=POP();
	return hurt,atk,lv;
end

function GetDef(pid)							--返回防御
	--local num=GetAtkKungfu(pid)
	--基础防御力
	--local def=JY.Wugong[JY.Person[pid]["武功"..num]]["防御"]*(div100(JY.Person[pid]["武功"..num])+1)
	local def=0
	for i=6,8 do
		local num=0
		if i==6 then
			num=JY.Person[pid]["内功"] or 0
		elseif i==7 then
			num=JY.Person[pid]["轻功"] or 0
		elseif i==8 then
			num=JY.Person[pid]["特技"] or 0
		end
		if num>0 and num<=CC.Kungfunum then
			def=def+JY.Wugong[JY.Person[pid]["武功"][num][1]]["防御"]*(div100(JY.Person[pid]["武功"][num][2])+1)
		end
	end
	--以下防御公式被我省略，因为以下是基于攻击性武功装备了而言的
	--没有相好如何安置下面的
	--或者可以考虑设计一个格挡武功...
	
	--武功之间配合加防御
	
	--武功内功配合加防御
	
	--防具加防御
	
	--人物属性额外提高防御力
	
	return def;
	
end

function WarDrawAtt(x,y,fanwei,flag,x0,y0,atk)
	x0=x0 or WAR.Person[WAR.CurID]["坐标X"];
	y0=y0 or WAR.Person[WAR.CurID]["坐标Y"];
	local kind=fanwei[1]
	local len1=fanwei[2]
	local len2=fanwei[3]
	local len3=fanwei[4]
	local len4=fanwei[5]
	local xy={}
	local num=0
	
	if kind==0 then		--单点
		num=1
		xy[1]={x,y}				
	elseif kind==1 then					--定点米
		len1=len1 or 0
		len2=len2 or 0
		num=num+1
		xy[num]={x,y}
		for i=1,len1 do
			xy[num+1]={x+i,y}
			xy[num+2]={x-i,y}
			xy[num+3]={x,y+i}
			xy[num+4]={x,y-i}
			num=num+4
		end
		for i=1,len2 do
			xy[num+1]={x+i,y+i}
			xy[num+2]={x-i,y-i}
			xy[num+3]={x-i,y+i}
			xy[num+4]={x+i,y-i}
			num=num+4		
		end			
	elseif kind==2 then					--定点菱形
		for tx=x-len1,x+len1 do			--这个方法感觉有点浪费，1/2的点都是不符合要求的
			for ty=y-len1,y+len1 do
				if math.abs(tx-x)+math.abs(ty-y)>len1 then
				
				else
					num=num+1
					xy[num]={tx,ty}
				end
			end
		end			
	elseif kind==3 then					--定点方块
		len2=len2 or len1
		local dx,dy=math.abs(x-x0),math.abs(y-y0)
		if dx>dy then len1,len2=len2,len1 end
		for tx=x-len1,x+len1 do
			for ty=y-len2,y+len2 do
				num=num+1
				xy[num]={tx,ty}
			end
		end	
	elseif kind==5 then					--粗十字
		len1=len1 or 0
		len2=len2 or 0
		num=num+1
		xy[num]={x,y}
		for i=1,len1 do
			xy[num+1]={x+i,y}
			xy[num+2]={x-i,y}
			xy[num+3]={x,y+i}
			xy[num+4]={x,y-i}
			num=num+4
		end
		if len2>0 then
			xy[num+1]={x+1,y+1}
			xy[num+2]={x+1,y-1}
			xy[num+3]={x-1,y+1}
			xy[num+4]={x-1,y-1}
			num=num+4
		end
		for i=2,len2 do
			xy[num+1]={x+i,y+1}
			xy[num+2]={x-i,y-1}
			xy[num+3]={x-i,y+1}
			xy[num+4]={x+i,y-1}
			xy[num+5]={x+1,y+i}
			xy[num+6]={x-1,y-i}
			xy[num+7]={x-1,y+i}
			xy[num+8]={x+1,y-i}
			num=num+8		
		end	
	elseif kind==6 then					--定点井
		len2=len2 or len1
		xy[1]={x+1,y}
		xy[2]={x-1,y}
		xy[3]={x,y+1}
		xy[4]={x,y-1}
		num=num+4
		if len1>0 or len2>0 then
			xy[5]={x+1,y+1}
			xy[6]={x+1,y-1}
			xy[7]={x-1,y+1}
			xy[8]={x-1,y-1}
			num=num+4
			for i=2,len1 do
				xy[num+1]={x+i,y+1}
				xy[num+2]={x-i,y+1}
				xy[num+3]={x+i,y-1}
				xy[num+4]={x-i,y-1}
				num=num+4
			end
			for i=2,len2 do
				xy[num+1]={x+1,y+i}
				xy[num+2]={x+1,y-i}
				xy[num+3]={x-1,y+i}
				xy[num+4]={x-1,y-i}
				num=num+4
			end
		end
	elseif kind==7 then					--定点田
		len2=len2 or len1
		if len1==0 then
			for i=y-len2,y+len2 do
				num=num+1
				xy[num]={x,i}
			end
		elseif len2==0 then
			for i=x-len1,x+len1 do
				num=num+1
				xy[num]={i,y}
			end
		else
			for i=x-len1,x+len1 do
				num=num+1
				xy[num]={i,y}
				num=num+1
				xy[num]={i,y+len2}
				num=num+1
				xy[num]={i,y-len2}
			end
			for i=1,len2-1 do
				xy[num+1]={x,y+i}
				xy[num+2]={x,y-i}
				xy[num+3]={x-len1,y+i}
				xy[num+4]={x-len1,y-i}
				xy[num+5]={x+len1,y+i}
				xy[num+6]={x+len1,y-i}
				num=num+6
			end
		end
	elseif kind==8 then					--定点卍
		xy[1]={x,y}
		num=1
		for i=1,len1 do
			xy[num+1]={x+i,y}
			xy[num+2]={x-i,y}
			xy[num+3]={x,y+i}
			xy[num+4]={x,y-i}
			xy[num+5]={x+i,y+len1}
			xy[num+6]={x-i,y-len1}
			xy[num+7]={x+len1,y-i}
			xy[num+8]={x-len1,y+i}
			num=num+8
		end
	elseif kind==9 then					--定点卐
		xy[1]={x,y}
		num=1
		for i=1,len1 do
			xy[num+1]={x+i,y}
			xy[num+2]={x-i,y}
			xy[num+3]={x,y+i}
			xy[num+4]={x,y-i}
			xy[num+5]={x-i,y+len1}
			xy[num+6]={x+i,y-len1}
			xy[num+7]={x+len1,y+i}
			xy[num+8]={x-len1,y-i}
			num=num+8
		end
	elseif x==x0 and y==y0 then
		return 0
	elseif kind==10 then				--方向线
		len2=len2 or 0
		len3=len3 or 0
		len4=len4 or 0
		local fx,fy=x-x0,y-y0
		if fx>0 then fx=1
		elseif fx<0 then fx=-1 end
		if fy>0 then fy=1
		elseif fy<0 then fy=-1 end
		local dx1,dy1,dx2,dy2=-fy,fx,fy,-fx
	--	if fx~=0 and fy~=0 then
			dx1=-(dx1+fx)/2
			dx2=-(dx2+fx)/2
			dy1=-(dy1+fy)/2
			dy2=-(dy2+fy)/2
		if dx1>0 then dx1=1
		elseif dx1<0 then dx1=-1 end
		if dx2>0 then dx2=1
		elseif dx2<0 then dx2=-1 end
		if dy1>0 then dy1=1
		elseif dy1<0 then dy1=-1 end
		if dy2>0 then dy2=1
		elseif dy2<0 then dy2=-1 end
		--end
		--首先绘制中间一条
		for i=0,len1-1 do
			num=num+1
			xy[num]={x+i*fx,y+i*fy}
		end
			--然后是两边
		for i=0,len2-1 do
			num=num+1
			xy[num]={x+dx1+i*fx,y+dy1+i*fy}
			num=num+1
			xy[num]={x+dx2+i*fx,y+dy2+i*fy}
		end	
		for i=0,len3-1 do
			num=num+1
			xy[num]={x+2*dx1+i*fx,y+2*dy1+i*fy}
			num=num+1
			xy[num]={x+2*dx2+i*fx,y+2*dy2+i*fy}
		end	
		for i=0,len4-1 do
			num=num+1
			xy[num]={x+3*dx1+i*fx,y+3*dy1+i*fy}
			num=num+1
			xy[num]={x+3*dx2+i*fx,y+3*dy2+i*fy}
		end	
	elseif kind==11 then				--正三角
		local fx,fy=x-x0,y-y0
		if fx>1 then fx=1
		elseif fx<-1 then fx=-1 end
		if fy>1 then fy=1
		elseif fy<-1 then fy=-1 end
		local dx1,dy1,dx2,dy2=-fy,fx,fy,-fx
		if fx~=0 and fy~=0 then
			dx1=-(dx1+fx)/2
			dx2=-(dx2+fx)/2
			dy1=-(dy1+fy)/2
			dy2=-(dy2+fy)/2
			len1=math.modf(len1*0.7071)
			for i=0,len1 do
				num=num+1
				xy[num]={x+i*fx,y+i*fy}
				for j=1,2*i+1 do
					num=num+1
					xy[num]={x+i*fx+j*dx1,y+i*fy+j*dy1}
					num=num+1
					xy[num]={x+i*fx+j*dx2,y+i*fy+j*dy2}
				end
			end
		else
			for i=0,len1 do
				num=num+1
				xy[num]={x+i*fx,y+i*fy}
				for j=1,len1-i do
					num=num+1
					xy[num]={x+i*fx+j*dx1,y+i*fy+j*dy1}
					num=num+1
					xy[num]={x+i*fx+j*dx2,y+i*fy+j*dy2}
				end
			end
		end
	elseif kind==12 then				--倒三角
		local fx,fy=x-x0,y-y0
		if fx>1 then fx=1
		elseif fx<-1 then fx=-1 end
		if fy>1 then fy=1
		elseif fy<-1 then fy=-1 end
		local dx1,dy1,dx2,dy2=-fy,fx,fy,-fx
		if fx~=0 and fy~=0 then
			dx1=(dx1+fx)/2
			dx2=(dx2+fx)/2
			dy1=(dy1+fy)/2
			dy2=(dy2+fy)/2
			len1=math.modf(len1*1.41421)
			for i=0,len1 do
				if i<=len1/2 then
					num=num+1
					xy[num]={x+i*fx,y+i*fy}
				end
				for j=1,len1-i*2 do
					num=num+1
					xy[num]={x+i*fx+j*dx1,y+i*fy+j*dy1}
					num=num+1
					xy[num]={x+i*fx+j*dx2,y+i*fy+j*dy2}
				end
			end
		else
			for i=0,len1 do
				num=num+1
				xy[num]={x+i*fx,y+i*fy}
				for j=1,i do
					num=num+1
					xy[num]={x+i*fx+j*dx1,y+i*fy+j*dy1}
					num=num+1
					xy[num]={x+i*fx+j*dx2,y+i*fy+j*dy2}
				end
			end
		end
	elseif kind==13 then			--方向菱形
		local fx,fy=x-x0,y-y0;
		if fx>1 then fx=1
		elseif fx<-1 then fx=-1 end
		if fy>1 then fy=1
		elseif fy<-1 then fy=-1 end
		local xx=x+fx*len1;
		local yy=y+fy*len1;
		for tx=xx-len1,xx+len1 do			--这个方法感觉有点浪费，1/2的点都是不符合要求的
			for ty=yy-len1,yy+len1 do
				if math.abs(tx-xx)+math.abs(ty-yy)>len1 then
				
				else
					num=num+1
					xy[num]={tx,ty}
				end
			end
		end	
	elseif kind==14 then			--排山倒海
		local fx,fy=x-x0,y-y0;
		if fx>1 then fx=1
		elseif fx<-1 then fx=-1 end
		if fy>1 then fy=1
		elseif fy<-1 then fy=-1 end
		for i=0,len2-1 do
			for j=-len1,len1 do
				num=num+1;
				xy[num]={x+fx*i+fy*j,y+fy*i+fx*j};
			end
		end
	else
		return 0
	end	
		
		
		
	if flag==0 then
		return num,xy;
	elseif flag==1 then									--绘制攻击范围
		local function thexy(nx,ny)
			local dx,dy=nx-x0,ny-y0
			return CC.ScreenW/2+CC.XScale*(dx-dy),CC.ScreenH/2+CC.YScale*(dx+dy)-lib.GetS(JY.SubScene,nx,ny,4)
		end
		
		for i=1,num do
			local tx,ty=thexy(xy[i][1],xy[i][2],x0,y0)
			lib.PicLoadCache(0,0,tx,ty,2,128);
			--SetWarMap(xy[i][1],xy[i][2],4,1);
		end
	elseif flag==2 then													--返回攻击数目
		if WAR.Person[WAR.CurID]["恍惚"]>0 then
			return math.random(100);
		end
		local diwo=WAR.Person[WAR.CurID]["我方"]
		local atknum=0
		for i=1,num do
			if xy[i][1]>=0 and xy[i][1]<CC.WarWidth and xy[i][2]>=0 and xy[i][2]<CC.WarHeight then
				local id=GetWarMap(xy[i][1],xy[i][2],2);
				if id~=-1 and WAR.Person[id]["我方"]~=WAR.Person[WAR.CurID]["我方"] then--and id~=WAR.CurID then
					local hp=JY.Person[WAR.Person[id]["人物编号"]]["生命"]
					local xb;
					--local catk,cdef=JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["攻击"],JY.Person[WAR.Person[id]["人物编号"]]["防御"];
					local tatk=atk--*JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["攻击"]/(JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["攻击"]+JY.Person[WAR.Person[id]["人物编号"]]["防御"]);
					local offset=	math.abs(WAR.Person[WAR.CurID]["坐标X"]-WAR.Person[id]["坐标X"])+
										math.abs(WAR.Person[WAR.CurID]["坐标Y"]-WAR.Person[id]["坐标Y"]);
					if offset <10 then
						tatk=tatk*(100-(offset-1)*5)/100;
					else
						tatk=tatk/2;
					end
					if hp<tatk/5 then
						xb=23;
					elseif hp<tatk/4 then
						xb=18;
					elseif hp<tatk/3 then
						xb=14;
					elseif hp<tatk/2 then
						xb=11;
					elseif hp<tatk/1.5 then
						xb=9;
					elseif hp<tatk then
						xb=7;
					elseif hp<tatk*1.5 then
						xb=6;
					elseif hp<tatk*2 then
						xb=5;
					else
						xb=3;
					end
					atknum=atknum+xb;
				end;
			end
		end--[[
		if atknum>0 then
			atknum=atknum+math.modf(atk/10);
		end]]--
		return atknum;
	elseif flag==3 then							--设置武功效果作用层，第四层
		CleanWarMap(4,0)
		for i=1,num do
			SetWarMap(xy[i][1],xy[i][2],4,1);
		end
	
	end
		
		
end

function War_FightSelectType(movefanwei,atkfanwei,x,y)		--
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    if x==nil and y==nil then
        x,y=War_KfMove(movefanwei,atkfanwei);              --未指定攻击地点，选择攻击对象
		if x ==nil then
			getkey();
			Cls();
			return false;
		end
	else																	--自动战斗时，以指定攻击地点，针对斗转的情况对坐标修正	
		WarDrawAtt(x,y,atkfanwei,1)								--显示攻击范围，斗转时显示不正确，应该是人物没有移动到场景中心-修复了
		getkey();
		ShowScreen();
		lib.Delay(500);
    end

    WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x,y) or WAR.Person[WAR.CurID]["人方向"]

	SetWarMap(x,y,4,1);

    WAR.EffectXY={};
	WarDrawAtt(x,y,atkfanwei,3)
	return true,x,y;
end

function War_KfMove(movefanwei,atkfanwei)              ---选择移动位置,武功专用
--kind 0菱形1方块 2四向 3八向
	local kind=movefanwei[1] or 0
	local len=movefanwei[2] or 0
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local x=x0;
    local y=y0;
	local t=0;
	if kind~=nil then
		if kind==0 then
			War_CalMoveStep(WAR.CurID,len,1);
		elseif kind==1 then
			War_CalMoveStep(WAR.CurID,len*2,1);
			for r=1,len*2 do
				for i=0,r do
					local j=r-i
					if i>len or j>len then
						SetWarMap(x0+i,y0+j,3,255)
						SetWarMap(x0+i,y0-j,3,255)
						SetWarMap(x0-i,y0+j,3,255)
						SetWarMap(x0-i,y0-j,3,255)
					end
				end
			end
		elseif kind==2 then
			War_CalMoveStep(WAR.CurID,len,1);
			for i=1,len-1 do
				for j=1,len-1 do
					SetWarMap(x0+i,y0+j,3,255)
					SetWarMap(x0-i,y0+j,3,255)
					SetWarMap(x0+i,y0-j,3,255)
					SetWarMap(x0-i,y0-j,3,255)
				end
			end
		elseif kind==3 then
			War_CalMoveStep(WAR.CurID,2,1);
			SetWarMap(x0+2,y0,3,255)
			SetWarMap(x0-2,y0,3,255)
			SetWarMap(x0,y0+2,3,255)
			SetWarMap(x0,y0-2,3,255)
		else
			War_CalMoveStep(WAR.CurID,0,1);
		end
	end
    while true do
        local x2=x;
        local y2=y;
		if t==0 then
			WAR.Data["地图"]=0;
		elseif t==10 then
			WAR.Data["地图"]=1;
		end
		t=t+1;
		if t>=20 then
			t=0;
		end
        WarDrawMap(1,x,y);
		if kind<2 or x~=x0 or y~=y0 then
			WarDrawAtt(x,y,atkfanwei,1)
		end
		WarShowHead(GetWarMap(x,y,2))
        ShowScreen();
		lib.Delay(30);
        local eventtype,key,mx,my=getkey();--WaitKey(1);
		if eventtype==1 then
			if key==VK_UP then
				y2=y-1;
			elseif key==VK_DOWN then
				y2=y+1;
			elseif key==VK_LEFT then
				x2=x-1;
			elseif key==VK_RIGHT then
				x2=x+1;
			elseif key==VK_SPACE or key==VK_RETURN then
				if kind<2 or x~=x0 or y~=y0 then
					return x,y;
				end
			elseif key==VK_ESCAPE then
				return nil;
			end
			if GetWarMap(x2,y2,3)<128 then
				x=x2;
				y=y2;
			end
		elseif eventtype==2 or eventtype==3 then
			mx=mx-CC.ScreenW/2
			my=my-CC.ScreenH/2+GetS(JY.SubScene,x0,y0,4)
			mx=mx/CC.XScale
			my=my/CC.YScale
			mx,my=(mx+my)/2,(my-mx)/2
			if mx>0 then mx=mx+0.99 else mx=mx-0.01 end
			if my>0 then my=my+0.99 else mx=mx-0.01 end
			mx=math.modf(mx)
			my=math.modf(my)
			for i=-10,10 do
				if between(x0+mx+i,0,63) and between(y0+my+i,0,63) then
					if math.abs(GetS(JY.SubScene,x0+mx+i,y0+my+i,4)-CC.YScale*i*2-GetS(JY.SubScene,x0,y0,4))<4 then
						mx=mx+i;
						my=my+i;
						break;
					end
				end
			end
			if GetWarMap(x0+mx,y0+my,3)<128 then
				x,y=x0+mx,y0+my
				if eventtype==3 then
					if key==1 then
						if kind<2 or x~=x0 or y~=y0 then
							return x,y;
						end
					elseif key==3 then
						return nil;
					end
				end
			end
		end
    end
end

function drawname(x,y,name,size,color)
	x=x-math.modf(size/2)
	color=color or M_White;
	local namelen=string.len(name)/2
	--local zi={}		
	for i=1,namelen do
		local s=string.sub(name,i*2-1,i*2)
		DrawString(x,y,s,color,size)
		y=y+size
	end
end

function WarSetDirect()
	for i=0,49 do
		if not WAR.Person[i]["死亡"] then
			local x,y,cx,cy,min_x,min_y,len,min_len;
			min_len=10000;
			cx,cy=WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"];
			for j=0,49 do
				if not WAR.Person[j]["死亡"] then
					if WAR.Person[i]["我方"]~=WAR.Person[j]["我方"] then
						x,y=WAR.Person[j]["坐标X"],WAR.Person[j]["坐标Y"];
						len=(cx-x)^2+(cy-y)^2;
						if len<min_len then
							min_len=len;
							min_x,min_y=x,y;
						end
					end
				end
			end
			if min_len<10000 then
				WAR.Person[i]["人方向"]=War_Direct(cx,cy,min_x,min_y);
			end
		end
	end
end













------------WE------------------

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