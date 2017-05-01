
----------------------------------------------------------
-----------金庸群侠传复刻之Lua版----------------------------

--版权所无，敬请复制
--您可以随意使用代码

---本代码由游泳的鱼编写

--本模块是lua主模块，由C主程序JYLua.exe调用。C程序主要提供游戏需要的视频、音乐、键盘等API函数，供lua调用。
--游戏的所有逻辑都在lua代码中，以方便大家对代码的修改。
--为加快速度，显示主地图/场景地图/战斗地图部分用C API实现。

--导入其他模块。之所以做成函数是为了避免编译查错时编译器会寻找这些模块。
function IncludeFile()              --导入其他模块
    --dofile("config.lua");       --此文件在C函数中预先加载。这里就不加载了
    dofile(CONFIG.ScriptPath .. "jyconst.lua");
    dofile(CONFIG.ScriptPath .. "common.lua");
    dofile(CONFIG.ScriptPath .. "event.lua");
    dofile(CONFIG.ScriptPath .. "war.lua");
    dofile(CONFIG.ScriptPath .. "AI.lua");
    --dofile(CONFIG.ScriptPath .. "WE.lua");
	--dofile(CONFIG.ScriptPath .. "migong.lua");
    dofile(CONFIG.ScriptPath .. "NAI.lua");
    dofile(CONFIG.ScriptPath .. "PY.lua");
    --dofile(CONFIG.ScriptPath .. "window.lua");
    --dofile(CONFIG.ScriptPath .. "Endless.lua");
    dofile(CONFIG.ScriptPath .. "Edit.lua");
    --dofile(CONFIG.ScriptPath .. "ForceAI.lua");
end

function SetGlobal()   --设置游戏内部使用的全程变量
	JY={};
	MyQuest={};
	PE=	{
			meet={},
			talk={},
			fight={},
			entrance={},
		};
	QuestEvent={};
	SceneEvent={};
	ForceEvent={};
	ForceTalk={};
	PersonEvent={};
	PersonTalk={};
	TimeEvent={};
	DelayEvent={num=0};
	Stack={[0]=0,};
	CityNPCUpdate={};
	JY.Status=GAME_INIT;  --游戏当前状态
	--保存R×数据
	JY.Base={};           --基本数据
	JY.PersonNum=0;      --人物个数
	JY.Person={};        --人物数据
	JY.ThingNum=0        --物品数量
	JY.Thing={};         --物品数据
	JY.SceneNum=0        --场景数量
	JY.Scene={};         --场景数据
	JY.WugongNum=0        --武功数量
	JY.Wugong={};         --武功数据
	JY.ShopNum=0        --商店数量
	JY.Shop={};         --商店数据
	JY.ShichengNum=0
	JY.Shicheng={};
	JY.fmp={};
	JY.Rnd100={};
	JY.Data_Base=nil;     --实际保存R*数据
	JY.Data_Person=nil;
	JY.Data_Thing=nil;
	JY.Data_Scene=nil;
	JY.Data_Wugong=nil;
	JY.Data_Shop=nil;
	JY.Name={};
	JY.MyCurrentPic=0;       --主角当前走路贴图在贴图文件中偏移
	JY.MyPic=0;              --主角当前贴图
	JY.MyTick=0;             --主角没有走路的持续帧数
	JY.TimeStep=0;
	JY.MyTick2=0;            --显示事件动画的节拍

	JY.EnterSceneXY=nil;     --保存进入场景的坐标，有值可以进入，为nil则重新计算。

	JY.oldMMapX=-1;          --上次显示主地图的坐标。用来判断是否需要全部重绘屏幕
	JY.oldMMapY=-1;
	JY.oldMMapPic=-1;        --上次显示主地图主角贴图

	JY.SubScene=-1;          --当前子场景编号
	JY.SubSceneX=0;          --子场景显示位置偏移，场景移动指令使用
	JY.SubSceneY=0;

	JY.Darkness=0;             --=0 屏幕正常显示，=1 不显示，屏幕全黑

	JY.CurrentD=-1;          --当前调用D*的编号
	JY.OldDPass=-1;          --上次触发路过事件的D*编号, 避免多次触发
	JY.CurrentEventType=-1   --当前触发事件的方式 1 空格 2 物品 3 路过
	JY.Da=-1;
	JY.Db=-1;

	JY.oldSMapX=-1;          --上次显示场景地图的坐标。用来判断是否需要全部重绘屏幕
	JY.oldSMapY=-1;
	JY.oldSMapXoff=-1;       --上次场景偏移
	JY.oldSMapYoff=-1;
	JY.oldSMapPic=-1;        --上次显示场景地图主角贴图
	JY.WindowReSizeFlag=false;
	JY.D_Valid=nil           --记录当前场景有效的D的编号，提高速度，不用每次显示都计算了。若为nil则重新计算
	JY_D_Valld_Num=0;        --当前场景有效的D个数

	JY.D_PicChange={}        --记录事件动画改变，以计算Clip
	JY.NumD_PicChange=0;     --事件动画改变的个数

	JY.CurrentThing=-1;      --当前选择物品，触发事件使用

	JY.MmapMusic=-1;         --切换大地图音乐，返回主地图时，如果设置，则播放此音乐

	JY.CurrentMIDI=-1;       --当前播放的音乐id，用来在关闭音乐时保存音乐id。
	JY.EnableMusic=1;        --是否播放音乐 1 播放，0 不播放
	JY.EnableSound=1;        --是否播放音效 1 播放，0 不播放

	JY.ThingUseFunction={};          --物品使用时调用函数，SetModify函数使用，增加新类型的物品
	JY.SceneNewEventFunction={};     --调用场景事件函数，SetModify函数使用，定义使用新场景事件触发的函数
	
	JY.LastSayPosition=1;
	JY.LastSayPid=0;
	
	JY.EnableKeyboard=true;
	JY.EnableMouse=true;
	JY.EnableQuit=true;
	JY.CurID=0;
	JY.CurTID=0;
	WAR={};     --战斗使用的全程变量。。这里占个位置，因为程序后面不允许定义全局变量了。具体内容在WarSetGlobal函数中
	--[[
	Timer={
			[1]=base_timer.new(nil),
			[2]=base_timer.new(nil),
			[3]=base_timer.new(nil),
			};
	]]--
	AutoMoveTab={[0]=0};			--自动移动
	Bright={};
	JY.Light=0;
	JY.Sight=0;
	JY.Menu_keep=false;
	JY.Menu_start=1;
	JY.Menu_current=1;
	--[[
	Timer[1]=base_timer.new(demostr);
	Timer[1]:start();
	]]--
	SceneEvent={};
    dofile(CONFIG.ScriptPath .. "fmp.lua");
    dofile(CONFIG.ScriptPath .. "newevent\\scene.lua");
    dofile(CONFIG.NewEventPath .. "event.lua");
end

function demostr(t)
	local tt;
	tt=math.modf(t/20)%(CC.ScreenW+40*CC.FontSmall);
	runword('你现在使用的是不算工作室制作的《猪4》测试版，请支持铁血丹心论坛！www.txdx.net',C_WHITE,CC.FontSmall,1,tt);
end

function runword(str,color,size,place,offset)
	offset=CC.ScreenW-offset;
	--if -offset>string.len(str)*size/2 then
	--	return 1;
	--end
	if place==0 then
		lib.Background(0,0,CC.ScreenW,size,128);
		DrawString(offset,0,str,color,size);
	elseif place==1 then
		lib.Background(0,CC.ScreenH-size,CC.ScreenW,CC.ScreenH,128);
		DrawString(offset,CC.ScreenH-size,str,color,size);
	end
end

function JY_Main()        --主程序入口
	os.remove("debug.txt");        --清除以前的debug输出
    xpcall(JY_Main_sub,myErrFun);     --捕获调用错误
end

function myErrFun(err)      --错误处理，打印错误信息
    lib.Debug(err);                 --输出错误信息
    lib.Debug(debug.traceback());   --输出调用堆栈信息
end

function JY_Main_sub()        --真正的游戏主程序入口
    IncludeFile();         --导入其他模块
    SetGlobalConst();    --设置全程变量CC, 程序使用的常量
    SetGlobal();         --设置全程变量JY
	EventInitialize();
    --禁止访问全程变量
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
    lib.Debug("JY_Main start.");

	math.randomseed(os.time());          --初始化随机数发生器

	lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval);   --设置键盘重复率
	
	
    PlayMIDI(1);
	--Welcome();
    lib.PlayMPEG(CONFIG.DataPath .. "start.mpg",VK_ESCAPE);
	
    JY.Status=GAME_START;

    Game_Cycle();
end

function CleanMemory()            --清理lua内存
    if CONFIG.CleanMemory==1 then
		 collectgarbage("collect");
		 --lib.Debug(string.format("Lua memory=%d",collectgarbage("count")));
    end
end

function NewGame()     --选择新游戏，设置主角初始属性
	
    LoadRecord(0); --  载入新游戏数据
	--DrawMMap()
	--PersoninItialize();
	--SelectPersonMenu();
	--ShowEFT();
	--KungfuEdit();
	--lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	for x=0,63 do
		for y=0,63 do
			for i=0,5 do
				lib.SetS(90,x,y,i,0)
				lib.SetS(91,x,y,i,0)
			end
		end
	end
	SetFlag(1,math.random(30000));
	SetFlag(2,GetFlag(1));
	SetFlag(3,1);
	--Cls();
	if false then
		return;
	end
	Dark();
	Cls();
	Light();
	DrawStrBoxWaitKey("在进入这个未知的世界前",C_WHITE,CC.Fontbig);
	--lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("我可以问一下你的姓名吗？",C_WHITE,CC.Fontbig);
	local name="";
	while name=="" do
		name=Shurufa();
	end
	--lib.FillColor(0,0,0,0,0);
	Dark();
	Cls();
	Light();
	DrawStrBoxWaitKey("Ｙ"..name.."Ｗ吗？真是奇怪的名字",C_WHITE,CC.Fontbig);
	
	
--[[
if DrawStrBoxYesNo(-1,-1,"你要使用新的方式决定属性吗？",C_WHITE,CC.Fontbig) then
	lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("接下来",C_WHITE,CC.Fontbig,1);
	lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("你需要回答几个问题",C_WHITE,CC.Fontbig,1);
	lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("我会给出一句话，以及四个选项",C_WHITE,CC.Fontbig,1);
	lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("请选出完全相同的一项",C_WHITE,CC.Fontbig,1);
	lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("它将决定你的天生属性，请谨慎",C_WHITE,CC.Fontbig,1);
	lib.FillColor(0,0,0,0,0);
	local p1,p2,p3,p4,p5=dofile(".\\script\\qs.lua");
	--总正确数，连续对，连续错，总时间，最快连续对
	--资质，福缘，根骨，力道，机敏
	local ld=(100-p4/20)*limitX(p1/12,0.2,1)+p1+Rnd(5);
	local gg=-limitX(p3-0.5,0,5)*10+p1*2+p2*3+30+Rnd(5);
	local jm=limitX(50-p5,0,50)*2*limitX(p1/12,0.2,1)+p1+Rnd(5);
	local fy=p2*7+Rnd(5);
	local zz=p1*5+Rnd(5)-Rnd(5);
	JY.Person[0]["力道"]=limitX(math.modf(ld),5,100);
	JY.Person[0]["根骨"]=limitX(math.modf(gg),5,100);
	JY.Person[0]["机敏"]=limitX(math.modf(jm),5,100);
	JY.Person[0]["福缘"]=limitX(math.modf(fy),5,100);
	JY.Person[0]["资质"]=limitX(math.modf(zz),5,100);
end
]]--
	
	
	--lib.FillColor(0,0,0,0,0);
	DrawStrBoxWaitKey("你需要回答几个问题",C_WHITE,CC.Fontbig);
	--lib.FillColor(0,0,0,0,0);
	local ld,gg,jm,fy,zz=50,50,50,50,50;
	local r;
	r=JYMsgBox("请谨慎回答","请问，您的家乡在哪儿？",{"西域","河朔","中原","江南"},4,16);
	if r==1 then
		JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"]=108,441;
		JY.Scene[70]["出门音乐"]=105;
		gg=gg+10;
	elseif r==2 then
		JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"]=137,203;
		JY.Scene[70]["出门音乐"]=108;
		ld=ld+10;
	elseif r==3 then
		JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"]=240,293;
		JY.Scene[70]["出门音乐"]=103;
		jm=jm+10;
	elseif r==4 then
		JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"]=356,235;
		JY.Scene[70]["出门音乐"]=107;
		zz=zz+10;
	end
	JY.Scene[70]["外景入口X2"],JY.Scene[70]["外景入口Y2"]=JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"];
	JY.Scene[70]["外景入口X3"],JY.Scene[70]["外景入口Y3"]=JY.Scene[70]["外景入口X1"],JY.Scene[70]["外景入口Y1"];
	JY.Base["人X"],JY.Base["人Y"]=JY.Scene[70]["外景入口X1"]+1,JY.Scene[70]["外景入口Y1"];
	r=JYMsgBox("请谨慎回答","在天龙三兄弟里面*你最向往谁？",{"萧峰","虚竹","段誉"},3,16);
	if r==1 then
		ld=ld+30;
		gg=gg+15;
		jm=jm-15
		zz=zz+15;
		fy=fy-10;
	elseif r==2 then
		gg=gg+30;
		jm=jm-10;
		fy=fy+30;
		zz=zz-15;
	elseif r==3 then
		jm=jm+30;
		fy=fy+15;
		ld=ld-10
		gg=gg+5
		zz=zz-5;
	end
	r=JYMsgBox("请谨慎回答","如果可能*你最希望谁赢得华山论剑？",{"王重阳","黄药师","欧阳锋","段智兴","洪七公"},5,16);
	if r==1 then
		fy=fy+15
		jm=jm+10;
		ld=ld-5;
	elseif r==2 then
		jm=jm+15;
		zz=zz+10;
		fy=fy-5;
	elseif r==3 then
		zz=zz+15;
		ld=ld+10;
		gg=gg-5;
	elseif r==4 then
		gg=gg+15;
		fy=fy+10;
		zz=zz-5;
	elseif r==5 then
		ld=ld+15;
		gg=gg+10;
		jm=jm-5;
	end
	JY.Person[0]["力道"]=limitX(ld+Rnd(10)-Rnd(5),10,100);
	JY.Person[0]["根骨"]=limitX(gg+Rnd(10)-Rnd(5),10,100);
	JY.Person[0]["机敏"]=limitX(jm+Rnd(10)-Rnd(5),10,100);
	JY.Person[0]["福缘"]=limitX(fy+Rnd(10)-Rnd(5),10,100);
	JY.Person[0]["资质"]=limitX(zz+Rnd(10)-Rnd(5),10,100);
	if JY.Person[0]["力道"]+JY.Person[0]["根骨"]+JY.Person[0]["机敏"]+JY.Person[0]["福缘"]+JY.Person[0]["资质"]<120 then
		lib.FillColor(0,0,0,0,0);
		DrawStrBoxWaitKey("看起来，你的回答并不怎么好",C_WHITE,CC.Fontbig,1);
		lib.FillColor(0,0,0,0,0);
		DrawStrBoxWaitKey("再给你一次机会，我可以完全重新随机你的天生属性",C_WHITE,CC.Fontbig,1);
		lib.FillColor(0,0,0,0,0);
		local r=JYMsgBox("请谨慎回答","是否放弃之前的作答*完全随机决定属性",{"好的","不要"},2,-1);
		if r==1 then
			JY.Person[0]["力道"]=40+Rnd(40)-Rnd(25);
			JY.Person[0]["根骨"]=40+Rnd(40)-Rnd(25);
			JY.Person[0]["机敏"]=40+Rnd(40)-Rnd(25);
			JY.Person[0]["福缘"]=40+Rnd(40)-Rnd(25);
			JY.Person[0]["资质"]=40+Rnd(40)-Rnd(25);
		end
	end
	
	--Dark();
	--Cls();
	--Light();
	--[[
		JY.Person[0]["力道"]=JY.Person[8]["力道"]--100;
		JY.Person[0]["根骨"]=JY.Person[8]["根骨"]--100;
		JY.Person[0]["机敏"]=JY.Person[8]["机敏"]--100;
		JY.Person[0]["福缘"]=JY.Person[8]["福缘"]--100;
		JY.Person[0]["资质"]=JY.Person[8]["资质"]--100;
		]]--
	NewGameSetting();
	JY.Person[0]["生命Max"]=80+math.modf(JY.Person[0]["力道"]*0.8+JY.Person[0]["福缘"]*0.4);
	JY.Person[0]["生命最大值"]=JY.Person[0]["生命Max"];
	JY.Person[0]["生命"]=JY.Person[0]["生命最大值"];
	JY.Person[0]["内力Max"]=80+math.modf(JY.Person[0]["根骨"]*0.8+JY.Person[0]["福缘"]*0.4);
	JY.Person[0]["内力最大值"]=JY.Person[0]["内力Max"];
	JY.Person[0]["内力"]=JY.Person[0]["内力最大值"];
	JY.Person[0]["姓名"]=name;
	JY.Person[0]["修炼点数"]=500;
	for i=0,CC.ToalPersonNum do
		ResetPersonAttrib(i);
		AddPersonAttrib(i,"生命",math.huge);
		AddPersonAttrib(i,"内力",math.huge);
	end
end


function Game_Cycle()       --游戏主循环
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END do
		
		for i=1,DelayEvent.num do
			DelayEvent[i].kind=0;
			DelayEvent[i].go();
		end
		DelayEvent.num=0;
		
        local tstart=lib.GetTime();

	    JY.MyTick=JY.MyTick+1;    --20个节拍无击键，则主角变为站立状态
	    JY.MyTick2=JY.MyTick2+1;    --20个节拍无击键，则主角变为站立状态

		if JY.MyTick==20 then
            JY.MyCurrentPic=0;
			JY.MyTick=0;
		end

        if JY.MyTick2==1000 then
            JY.MYtick2=0;
        end
		if JY.TimeStep==64 then
			JY.TimeStep=0;
			--local t=GetFlag(1);
			--SetFlag(1,t+1);
			DayPass(1);
			AddPersonAttrib(0,"体力",-1);
		end
		if JY.Status==GAME_START then
			Game_Start();
        elseif JY.Status==GAME_FIRSTMMAP then  --首次显示主场景，重新调用主场景贴图，渐变显示。然后转到正常显示
			CleanMemory();
            lib.ShowSlow(50,1)
            JY.MmapMusic=-1;--16;
            JY.Status=GAME_MMAP;

            Init_MMap();

            lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
			lib.ShowSlow(50,0);
        elseif JY.Status==GAME_MMAP then
            Game_MMap();
			if JY.MyCurrentPic~=0 then
				JY.TimeStep=JY.TimeStep+1;
			end
 		elseif JY.Status==GAME_SMAP then
            Game_SMap()
		end

		collectgarbage("step",0);

		local tend=lib.GetTime();

		if tend-tstart<CC.Frame then
            lib.Delay(CC.Frame-(tend-tstart));
		else
			--lib.Debug("Delay:"..(tend-tstart))
	    end
	end
	Dark();
	DrawStrBoxWaitKey("Game Over",C_RED,CC.FontBig,1);
end
function Game_Start()
    lib.PicInit(CC.PaletteFile);       --加载原来的256色调色板
	lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],2);
    lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);
    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],99);
	lib.LoadMMap(CC.MMapFile[1],CC.MMapFile[2],CC.MMapFile[3],
			CC.MMapFile[4],CC.MMapFile[5],CC.MWidth,CC.MHeight,JY.Base["人X"],JY.Base["人Y"]);
	

	Cls();

    PlayMIDI(1);
	lib.ShowSlow(50,0);

	--[[
	local data=Byte.create(4*11649);
	local idx={[0]=0,};
	Byte.loadfile(data,CC.SMAPPicFile[1],0,4*11649);
	for i=0,11649-1 do
		idx[i+1]=Byte.get32(data,i*4);
	end
	local newidx=0;
	for i=1,11649 do
		if  idx[i]-idx[i-1]<=0 then
		else
			local old=Byte.create(idx[i]-idx[i-1]);
			Byte.loadfile(old,CC.SMAPPicFile[2],idx[i-1],idx[i]-idx[i-1]);
			local height=Byte.getu16(old,2);
			local length=8;
			for j=1,height do
				local raw=Byte.get8(old,length);
				if raw<0 then
					raw=256+raw;
				end
				length=length+raw+1;
			end
			lib.Debug((i-1)..','..height..','..length..','..newidx..','..idx[i-1])
			local new=Byte.create(length);
			Byte.loadfile(new,CC.SMAPPicFile[2],idx[i-1],length);
			Byte.savefile(new,'.\\data\\nsmap.grp',newidx,length);
			newidx=newidx+length;
		end
		Byte.set32(data,(i-1)*4,newidx);
	end
	Byte.savefile(data,'.\\data\\nsmap.idx',0,4*11649);
	
	
	
	
	
	
	]]--
	
	
	
	local menu={  {"普通模式",nil,1},
	              {"战略模式",nil,1},
	              {"无尽模式",nil,1},
	              {"模拟比武",nil,1},
	              {"新建人物",nil,1},
	              {"新建武功",nil,1},
	              {"人物编辑",nil,1},
	              {"物品编辑",nil,1},
	              {"武功编辑",nil,1},
	              {"门派编辑",nil,1},
	              {"战斗场景",nil,0},
	              {"离开游戏",nil,1},  };
	local menux=(CC.ScreenW-4*CC.FontBig-2*CC.RowPixel)/2
	while true do
		local menuReturn=ShowMenu(menu,12,0,10,10,0,0,1,0,CC.Fontbig,C_WHITE,C_ORANGE);--C_STARTMENU, C_RED)

		if menuReturn == 1 then        --重新开始游戏
			--Cls();
			--NewGameString(2);
			Cls();
			DrawString(menux,CC.StartMenuY,"请稍候...",C_ORANGE,CC.FontBig);
			ShowScreen();

			NewGame();          --设置新游戏数据
			--dofile('.\\script\\newevent\\scene_0.lua');

			JY.SubScene=CC.NewGameSceneID;         --新游戏直接进入场景
			JY.Base["人X1"]=CC.NewGameSceneX;
			JY.Base["人Y1"]=CC.NewGameSceneY;
			JY.SubSceneX=0;
			JY.SubSceneY=0;
			JY.MyPic=CC.NewPersonPic;
			JY.Scene[CC.NewGameSceneID]["名称"]=JY.Person[0]["姓名"].."居";
			lib.ShowSlow(50,1)
			JY.Status=GAME_SMAP;
			JY.MmapMusic=-1;

			CleanMemory();

			Init_SMap(2);

			if CC.NewGameEvent>0 then
				SceneEvent[CC.NewGameSceneID][CC.NewGameEvent]();
			end
			--SceneEvent[JY.SubScene][1]();
			while false do
				local id1=SelectPersonMenu();
				local id2=SelectPersonMenu(id1);
				vs(id1,38,38,id2,33,35,300);
			
			end
			
			
			break

		elseif menuReturn == 2 then         --载入旧的进度
			Cls();
			local loadMenu={ {"进度一",nil,1},
							{"进度二",nil,1},
							{"进度三",nil,1} };
	
			local menux=(CC.ScreenW-3*CC.FontBig-2*CC.RowPixel)/2

			local r=ShowMenu(loadMenu,3,0,menux,CC.StartMenuY,0,0,0,1,CC.FontBig,C_WHITE,C_ORANGE);--C_STARTMENU, C_RED)
			Cls();
			if r~=0 then
				DrawString(menux,CC.StartMenuY,"请稍候...",C_ORANGE,CC.FontBig);
				ShowScreen();
				LoadRecord(r);
				Cls();
				if JY.Base["场景"]~=-1 then
					JY.Status=GAME_SMAP
					JY.SubScene=JY.Base["场景"]
					JY.MmapMusic=-1;
					JY.MyPic=GetMyPic();
					Init_SMap(2);
				else JY.Status=GAME_FIRSTMMAP;
				end
				ShowScreen();
				break;
			end
		elseif menuReturn == 3 then         --无尽模式
			Cls();
			DrawString(menux,CC.StartMenuY,"请稍候...",C_ORANGE,CC.FontBig);
			ShowScreen();
			NewGame();          --设置新游戏数据
			JY.SubScene=CC.NewGameSceneID;         --新游戏直接进入场景
			JY.Base["人X1"]=32--CC.NewGameSceneX;
			JY.Base["人Y1"]=32--CC.NewGameSceneY;
			JY.SubSceneX=0;
			JY.SubSceneY=0;
			JY.MyPic=CC.NewPersonPic;

			--lib.ShowSlow(50,1)

			CleanMemory();

			--Init_SMap(2);
			EndlessMain(0);
		elseif menuReturn ==4 then
			LoadRecord(0);
			JY.SubScene=27;
			PersoninItialize();
			E_kungfugamefree();
		elseif menuReturn ==9 then
			LoadRecord(0);
			SelectKungfuMenu();
		elseif menuReturn == 11 then
			SmapToWmap();
		elseif menuReturn == 12 then
			JY.Status=GAME_END;
			break;
		end
	end
	--lib.LoadPicture("",0,0);
    lib.GetKey();
end

function Init_MMap()   --初始化主地图数据
	--lib.PicInit();
	--lib.LoadMMap(CC.MMapFile[1],CC.MMapFile[2],CC.MMapFile[3],
	--		CC.MMapFile[4],CC.MMapFile[5],CC.MWidth,CC.MHeight,JY.Base["人X"],JY.Base["人Y"]);
--[[
	lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0);
	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
	    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end
]]--
	JY.EnterSceneXY=nil;         --设为空，强制重新生成场景入口数据。防止有事件更改了场景入口。
	JY.oldMMapX=-1;
	JY.oldMMapY=-1;

    PlayMIDI(JY.MmapMusic);
end


function Game_MMap()      --主地图

    local direct = -1;
    local eventtype,keypress,mx,my = getkey();
    if eventtype == 1 then
	    JY.MyTick=0;
		if keypress==VK_ESCAPE then
			MMenu();
			if JY.Status==GAME_FIRSTMMAP then
				return ;
			end
			JY.oldMMapX=-1;         --强制重绘
			JY.oldMMapY=-1;
		elseif keypress==VK_UP then
			direct=0;
		elseif keypress==VK_DOWN then
			direct=3;
		elseif keypress==VK_LEFT then
			direct=2;
		elseif keypress==VK_RIGHT then
			direct=1;
		elseif keypress==9 then
			console()
		end
	elseif eventtype==3 then
		if keypress==1 then
			mx=mx-CC.ScreenW/2
			my=my-CC.ScreenH/2
			mx=mx/CC.XScale
			my=my/CC.YScale
			mx,my=(mx+my)/2,(my-mx)/2
			if mx>0 then mx=mx+0.99 else mx=mx-0.01 end
			if my>0 then my=my+0.99 else mx=mx-0.01 end
			mx=math.modf(mx)
			my=math.modf(my)
			walkto(mx+JY.Base["人X"],my+JY.Base["人Y"])
		elseif keypress==3 then
			MMenu();
			if JY.Status==GAME_FIRSTMMAP then
				return ;
			end
			JY.oldMMapX=-1;         --强制重绘
			JY.oldMMapY=-1;
		end
    end
	
	if AutoMoveTab[0]~=0 then
		if direct==-1 then
			direct=AutoMoveTab[AutoMoveTab[0]]
			AutoMoveTab[AutoMoveTab[0]]=nil
			AutoMoveTab[0]=AutoMoveTab[0]-1
		else
			AutoMoveTab={[0]=0}
		end
	end
    local x,y;              --按照方向键要到达的坐标

	if direct ~= -1 then
        AddMyCurrentPic();         --增加主角贴图编号，产生走路效果
		x=JY.Base["人X"]+CC.DirectX[direct+1];
		y=JY.Base["人Y"]+CC.DirectY[direct+1];
		JY.Base["人方向"]=direct;
    else
        x=JY.Base["人X"];
        y=JY.Base["人Y"];
    end
	
	if JY.Status~=GAME_MMAP then
		return
	end
	
	if direct~=-1 then
		JY.SubScene=CanEnterScene(x,y);   --判断是否进入子场景
	else
		JY.SubScene=-1;
	end
	if  CanPass(x,y) then
			JY.Base["人X"]=x;
			JY.Base["人Y"]=y;
	end
	
    JY.Base["人X"]=limitX(JY.Base["人X"],10,CC.MWidth-10);           --限制坐标不能超出范围
    JY.Base["人Y"]=limitX(JY.Base["人Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["人X"],JY.Base["人Y"],0)]==1 then
	    JY.Base["乘船"]=1;
	else
	    JY.Base["乘船"]=0;
	end

	local pic=GetMyPic();
	lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],pic);             --显示主地图
	DrawState();
	DrawMMapMini()
	ShowScreen(CONFIG.FastShowScreen);
	lib.SetClip(0,0,0,0);

	--JY.oldMMapX=JY.Base["人X"];
	--JY.oldMMapY=JY.Base["人Y"];
	--JY.oldMMapPic=pic;

    if JY.SubScene >= 0 then          --进入子场景
        CleanMemory();
		--lib.UnloadMMap();
        --lib.PicInit();
        lib.ShowSlow(50,1)

		JY.Status=GAME_SMAP;
        JY.MmapMusic=-1;

        JY.MyPic=GetMyPic();
		if x==JY.Scene[JY.SubScene]["外景入口X1"] and y==JY.Scene[JY.SubScene]["外景入口Y1"] then
			JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"]
			JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"]
		elseif x==JY.Scene[JY.SubScene]["外景入口X2"] and y==JY.Scene[JY.SubScene]["外景入口Y2"] then
			JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X2"]
			JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y2"]
		else
			JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X3"]
			JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y3"]
		end
        Init_SMap(1);
    end

end

function CanPass(x,y)
	if lib.GetMMap(x,y,3)~=0 or lib.GetMMap(x,y,4)~=0 then
		return false;
	end
	if JY.Base["乘船"]==0 and CC.MMapBoat[lib.GetMMap(x,y,0)]==1 then
		return false;
	end
	if JY.Base["乘船"]==1 and CC.MMapBoat[lib.GetMMap(x,y,0)]~=1 then
		return false;
	end
	return true;
end

function DrawMMapMini()
	local len=CC.MapSize;
	local c1=RGB(0,128,0);
	local c2=RGB(160,82,45);
	local c3=RGB(65,105,225);
	for x=JY.Base["人X"]-len,JY.Base["人X"]+len do
		for y=JY.Base["人Y"]-len,JY.Base["人Y"]+len do
			local dx,dy;
			local xx=x-JY.Base["人X"];
			local yy=y-JY.Base["人Y"];
			dx=CC.ScreenW-len*8+(xx-yy)*4;
			dy=len*4+(xx+yy)*2;
			if x==JY.Base["人X"] and y==JY.Base["人Y"] then
				lib.FillColor(dx,dy,dx+5,dy+5,C_RED)
			elseif x>=0 and y>=0 and x<=479 and y<=479 then
				if lib.GetMMap(x,y,1)~=0 then
					lib.Background(dx,dy,dx+4,dy+4,196)
				elseif lib.GetMMap(x,y,2)~=0 then
					lib.FillColor(dx,dy,dx+3,dy+3,c1)
				elseif lib.GetMMap(x,y,3)~=0 then
					lib.FillColor(dx,dy,dx+3,dy+3,c2)
				elseif CC.MMapBoat[lib.GetMMap(x,y,0)]==1 then
					lib.FillColor(dx,dy,dx+3,dy+3,c3)
				end
			end
		end
	end
	for i=0,JY.SceneNum-1 do
		if JY.Scene[i]["进入条件"]==0 then
			if math.abs(JY.Scene[i]["外景入口X1"]-JY.Base["人X"])<=len and math.abs(JY.Scene[i]["外景入口Y1"]-JY.Base["人Y"])<=len then
				local dx,dy;
				local xx=JY.Scene[i]["外景入口X1"]-JY.Base["人X"];
				local yy=JY.Scene[i]["外景入口Y1"]-JY.Base["人Y"];
				dx=CC.ScreenW-len*8+(xx-yy)*4;
				dy=len*4+(xx+yy)*2;
				local str=JY.Scene[i]["名称"];
				lib.FillColor(dx,dy,dx+3,dy+3,C_ORANGE);
				lib.Background(dx-#str*4,dy+4,dx+#str*4,dy+20,128);
				DrawString(dx-#str*4,dy+4,str,C_WHITE,16);
			end
		end
	end
end


--showname  =1 显示场景名 0 不显示
function Init_SMap(showname)   --初始化场景数据
	showname=showname or 0;
	
	if CityNPCUpdate[JY.SubScene]==nil then
		PersonRePosition(JY.SubScene);
	elseif GetFlag(1)-CityNPCUpdate[JY.SubScene]>=10 then
		PersonRePosition(JY.SubScene);
	end
	
--[[
	lib.PicInit();
	lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
	if CC.LoadThingPic==1 then
	    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
	end
]]--
	if JY.SubScene==42 then
		JY.Light=240;
		JY.Sight=220;
		setBright();
	else
		JY.Light=0;
		JY.Sight=0;
		setBright();
	end
	PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"]);

	JY.oldSMapX=-1;
	JY.oldSMapY=-1;

	if showname~=2 then
		JY.SubSceneX=0;
		JY.SubSceneY=0;
	end
	JY.OldDPass=-1;

    JY.D_Valid=nil;
	for i=1,3 do
		--Timer[i].status='stop';
	end
	--[[
	JY.Sight=JY.Scene[JY.SubScene]['Sight']
	JY.Light=JY.Scene[JY.SubScene]['Light']
	if JY.Sight>0 or JY.Light>0 then
		JY.Sight=400--JY.Sight+GetFlag(1000)
		JY.Light=255--JY.Light+GetFlag(1001)
		setBright()
	end
	]]--
	
    DtoSMap();
	DrawSMap();
	lib.ShowSlow(50,0)
	if showname==1 then
		DrawStrBox(-1,10,JY.Scene[JY.SubScene]["名称"],C_WHITE,CC.Fontbig);
		ShowScreen();
		lib.Delay(200)
		WaitKey();
		lib.Delay(300)
		Cls();
		ShowScreen();
		
							for ci,cv in pairs(PE.entrance) do
								if cv.trigger()==1 then
									cv.go();
									break;
								end
							end
    end
end

--计算贴图改变形成的Clip裁剪
--(dx1,dy1) 新贴图和绘图中心点的坐标偏移。在场景中，视角不同而主角动时用到
--pic1 旧的贴图编号
--id1 贴图文件加载编号
--(dx2,dy2) 新贴图和绘图中心点的偏移
--pic2 旧的贴图编号
--id2 贴图文件加载编号
--返回，裁剪矩形 {x1,y1,x2,y2}
function Cal_PicClip(dx1,dy1,pic1,id1,dx2,dy2,pic2,id2)   --计算贴图改变形成的Clip裁剪

	local w1,h1,x1_off,y1_off=lib.PicGetXY(id1,pic1*2);
	local old_r={};
	old_r.x1=CC.XScale*(dx1-dy1)+CC.ScreenW/2-x1_off;
    old_r.y1=CC.YScale*(dx1+dy1)+CC.ScreenH/2-y1_off;
    old_r.x2=old_r.x1+w1;
	old_r.y2=old_r.y1+h1;

	local w2,h2,x2_off,y2_off=lib.PicGetXY(id2,pic2*2);
	local new_r={};
	new_r.x1=CC.XScale*(dx2-dy2)+CC.ScreenW/2-x2_off;
    new_r.y1=CC.YScale*(dx2+dy2)+CC.ScreenH/2-y2_off;
    new_r.x2=new_r.x1+w2;
	new_r.y2=new_r.y1+h2;

	return MergeRect(old_r,new_r);
end

function MergeRect(r1,r2)     --合并矩形
	local res={};
	res.x1=math.min(r1.x1, r2.x1);
	res.y1=math.min(r1.y1, r2.y1);
	res.x2=math.max(r1.x2, r2.x2);
	res.y2=math.max(r1.y2, r2.y2);
	return res;
end

----对矩形进行屏幕剪裁
--返回剪裁后的矩形，如果超出屏幕，返回空
function ClipRect(r)    --对矩形进行屏幕剪裁
	if r.x1>=CC.ScreenW or r.x2<= 0 or r.y1>=CC.ScreenH or r.y2 <=0 then
	    return nil
	else
	    local res={};
        res.x1=limitX(r.x1,0,CC.ScreenW);
        res.x2=limitX(r.x2,0,CC.ScreenW);
        res.y1=limitX(r.y1,0,CC.ScreenH);
        res.y2=limitX(r.y2,0,CC.ScreenH);
        return res;
	end
end

function GetMyPic()      --计算主角当前贴图
    local n;
	if JY.Status==GAME_MMAP and JY.Base["乘船"]==1 then
		if JY.MyCurrentPic >=4 then
			JY.MyCurrentPic=0
		end
	else
		if JY.MyCurrentPic >6 then
			JY.MyCurrentPic=1
		end
	end

	if JY.Status==GAME_SMAP or JY.Base["乘船"]==0 then
        n=CC.MyStartPic+JY.Base["人方向"]*7+JY.MyCurrentPic;
	else
	    n=CC.BoatStartPic+JY.Base["人方向"]*4+JY.MyCurrentPic;
	end
	return n;
end
function GetNPCPic(pid)
	return 10001+JY.Person[pid]["战斗动作"]*4
end
--增加当前主角走路动画帧, 主地图和场景地图都使用
function AddMyCurrentPic()        ---增加当前主角走路动画帧,
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end

--场景是否可进
--id 场景代号
--x,y 当前主地图坐标
--返回：场景id，-1表示没有场景可进
function CanEnterScene(x,y)         --场景是否可进
    if JY.EnterSceneXY==nil then    --如果为空，则重新产生数据。
	    Cal_EnterSceneXY();
	end

    local id=JY.EnterSceneXY[y*CC.MWidth+x];
    if id~=nil then
        local e=JY.Scene[id]["进入条件"];
		if e==0 then        --可进
			return id;
		elseif e==1 then    --不可进
			return -1
		elseif e==2 then    --有轻功高者进
			for i=1,CC.TeamNum do
				local pid=JY.Base["队伍" .. i];
				if pid>=0 then
					if JY.Person[pid]["轻功"]>=70 then
						return id;
					end
				end
			end
		end
	end
    return -1;
end

function Cal_EnterSceneXY()   --计算哪些坐标可以进入场景
    JY.EnterSceneXY={};
    for id = 0,JY.SceneNum-1 do
		local scene=JY.Scene[id];
        if scene["外景入口X1"]>0 and scene["外景入口Y1"] then
            JY.EnterSceneXY[scene["外景入口Y1"]*CC.MWidth+scene["外景入口X1"]]=id;
		end
        if scene["外景入口X2"]>0 and scene["外景入口Y2"] then
            JY.EnterSceneXY[scene["外景入口Y2"]*CC.MWidth+scene["外景入口X2"]]=id;
		end
        if scene["外景入口X3"]>0 and scene["外景入口Y3"] then
            JY.EnterSceneXY[scene["外景入口Y3"]*CC.MWidth+scene["外景入口X3"]]=id;
		end
    end
end

--主菜单
function MMenu()      --主菜单
    local menu={
					{" 状 态 ",Menu_Status,1},
					{" 武 功 ",Menu_Kungfu,1},
					{" 物 品 ",Menu_Thing,1},
					{" 系 统 ",Menu_System,1},      
				};
	
	--lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],90);
	--lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],91);
    return ShowMenu2(menu,4,0,CC.MainX,CC.MainY,0,0,2,1,CC.MainSize,M_DarkOrange,M_Yellow,1);--C_ORANGE,C_GOLD)
end
function Menu_System(aa,bb,justshow)
	local menu={
				{"  读取进度  ",Menu_Sys_Load,1},
				{"  保存进度  ",Menu_Sys_Save,1},
				{"  游戏设置  ",Menu_Sys_Set,1},
				{"  制作小组  ",Menu_Sys_About,1},
				{"  离开游戏  ",Menu_Sys_Quit,1},
				};
	DrawStrBox(CC.MainX_L,CC.MainY,"  系统菜单  ",C_WHITE,CC.MainSize);
	if justshow~=0 then
		justshow=2;
	else
		justshow=1;
	end
    return ShowMenu(menu,5,0,CC.MainX_L,CC.MainY2,0,0,1,1,CC.MainSize,M_DarkOrange,M_Yellow,justshow);
end
function Menu_Sys_Load(aa,bb,justshow)
	local menu={
				{"存档一",Menu_Sys_Load_sub,1},
				{"存档二",Menu_Sys_Load_sub,1},
				{"存档三",Menu_Sys_Load_sub,1},
				{"自动档",Menu_Sys_Load_sub,1},
				};
	if justshow~=0 then
		justshow=2;
	else
		justshow=1;
	end
	return ShowMenu2(menu,4,0,CC.MainX,CC.MainY2,0,0,1,1,CC.MainSize,M_DarkOrange,M_Yellow,justshow);
end
function Menu_Sys_Load_sub(aa,id,justshow)
	if justshow==0 then
		LoadRecord(id);
		if JY.Base["场景"]~=-1 then 
			if JY.SubScene < 0 then          --处于大地图
				CleanMemory();
				--lib.UnloadMMap();
			end
			--lib.PicInit();
			lib.ShowSlow(50,1)
			JY.Status=GAME_SMAP
			JY.SubScene=JY.Base["场景"]
			JY.MmapMusic=-1;
			JY.MyPic=GetMyPic();
			Init_SMap(2);
		else JY.Status=GAME_FIRSTMMAP;
		end
		return -1;
	else
		Menu_Sys_SL_Show(id);
	end
end
function Menu_Sys_Save(aa,bb,justshow)
	local menu={
				{"存档一",Menu_Sys_Save_sub,1},
				{"存档二",Menu_Sys_Save_sub,1},
				{"存档三",Menu_Sys_Save_sub,1},
				{"自动档",Menu_Sys_Save_sub,1},
				};
	if justshow~=0 then
		justshow=2;
	else
		justshow=1;
	end
	return ShowMenu2(menu,4,0,CC.MainX,CC.MainY2,0,0,1,1,CC.MainSize,M_DarkOrange,M_Yellow,justshow);
end
function Menu_Sys_Save_sub(aa,id,justshow)
	if justshow==0 then
		if JY.Status==GAME_SMAP then 			--保存部分和场景地图存档相关信息
			JY.Base["场景"]=JY.SubScene
		else
			JY.Base["场景"]=-1
		end
        --DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.Fontbig);
        --ShowScreen();
		SaveRecord(id);
		return -1;
	else
		Menu_Sys_SL_Show(id);
	end
end
function Menu_Sys_SL_Show(id,cx1,cy1,cx2,cy2)
	local data=Byte.create(14);
	Byte.loadfile(data,CC.R_GRPFilename[id],100,14);
	local s=Byte.get16(data,2);
	local rx=Byte.get16(data,4);
	local ry=Byte.get16(data,6);
	local rx1=Byte.get16(data,8);
	local ry1=Byte.get16(data,10);
	local d=Byte.get16(data,12);
	local width=cx2-cx1;
	local height=cy2-cy1;
	--local width=CC.ScreenW-CC.MainX_L-CC.MainX-2*CC.MenuBorderPixel;
	--local height=CC.ScreenH-CC.MainY-CC.MainY2-CC.MainSize-5*CC.MenuBorderPixel;
	--local cx=CC.MainX+CC.MenuBorderPixel+width/2;
	--local cy=CC.MainY2+CC.MainSize+3*CC.MenuBorderPixel*2+height/2;
	local len=10+math.abs(math.modf((width/2)/CC.XScale),math.modf((height/2)/CC.YScale));
	--DrawBox(CC.MainX,CC.MainY2+CC.MainSize+3*CC.MenuBorderPixel,CC.ScreenW-CC.MainX_L,CC.ScreenH-CC.MainY,C_WHITE);
	--lib.SetClip(CC.MainX+CC.MenuBorderPixel,CC.MainY2+CC.MainSize+4*CC.MenuBorderPixel,
	--			CC.ScreenW-CC.MainX_L-CC.MenuBorderPixel,CC.ScreenH-CC.MainY-CC.MenuBorderPixel);
	--lib.FillColor(CC.MainX+CC.MenuBorderPixel,CC.MainY2+CC.MainSize+4*CC.MenuBorderPixel,
	--			CC.ScreenW-CC.MainX_L-CC.MenuBorderPixel,CC.ScreenH-CC.MainY-CC.MenuBorderPixel,C_BLACK);
	lib.SetClip(cx1+CC.MenuBorderPixel,cy1+CC.MenuBorderPixel,cx2-CC.MenuBorderPixel,cy2-CC.MenuBorderPixel);
	local cx=(cx1+cx2)/2;
	local cy=(cy1+cy2)/2;
	
	if s>-1 then
		local s_data=Byte.create(49152);
		Byte.loadfile(s_data,CC.S_Filename[id],49152*s,49152);
		local function MyGetS(sid,sx,sy,level)
			return Byte.get16(s_data,8192*level+128*sy+2*sx);
		end
		local d_data=Byte.create(4400);
		Byte.loadfile(d_data,CC.D_Filename[id],4400*s,4400);
		local function MyGetD(sid,did,level)
			return Byte.get16(d_data,22*did+2*level);
		end
		for i=-len,len do
			for j=-len,len do
				if between(rx1+i,0,63) and between(ry1+j,0,63) then
					local drawx=cx+CC.XScale*(i-j);
					local drawy=cy+CC.YScale*(i+j);
					if between(drawx,cx1-CC.XScale,cx2+CC.XScale) then--and between(drawy,cy1-CC.YScale,cy2+CC.YScale*2) then
						local d0=MyGetS(s,rx1+i,ry1+j,0);
						local d1=MyGetS(s,rx1+i,ry1+j,1);
						local d2=MyGetS(s,rx1+i,ry1+j,2);
						local d3=MyGetS(s,rx1+i,ry1+j,3);
						local d4=MyGetS(s,rx1+i,ry1+j,4);
						local d5=MyGetS(s,rx1+i,ry1+j,5);
						if CONFIG.Zoom==1 then
							d4=d4*2;
							d5=d5*2;
						end
						if d0>0 then
							lib.PicLoadCache(0,d0,drawx,drawy);
						else
--							lib.PicLoadCache(90,d0,drawx,drawy);
						end
						if d1>0 then
							lib.PicLoadCache(0,d1,drawx,drawy-d4);
						end
						if d2>0 then
							lib.PicLoadCache(0,d2,drawx,drawy-d5);
						end
						if between(d3,0,199) then
							local v=MyGetD(s,d3,5);
							if v>0 then
								lib.PicLoadCache(0,v,drawx,drawy-d4);
							end
						end
						if i==0 and j==0 then
							lib.PicLoadCache(0,(CC.MyStartPic+d*7)*2,drawx,drawy-d4);
						end
					end
				end
			end
		end
	else
		lib.DrawMMap(rx,ry,GetMyPic());--JY.MyPic);
	end
	lib.SetClip(0,0,0,0);
	if s>=0 then--and JY.Scene[s]~=nil then
		DrawStrBox(cx1,cy1,JY.Scene[s]["名称"],C_WHITE,CC.Fontbig);
	else
		DrawStrBox(cx1,cy1,"大地图",C_WHITE,CC.Fontbig);
	end
end
function Menu_Sys_Set(size)
	local screen=1;
	local T={
			w={640,800,800,854,960,960,1024,1024,1280,1280,1366,1440},
			h={480,480,600,480,540,720, 576, 768, 760,1024, 768, 900},
			};
	for i=1,11 do
		if CC.ScreenW==T.w[i] and CC.ScreenH==T.h[i] then
			screen=i;
			break;
		end
	end
	local select=1;
	local height=(size+CC.RowPixel)*10;
	local width=height*1.6;
	local num=math.modf(2*(width-CC.MenuBorderPixel*2-size*5)/size);
	local step=math.modf(128/num);
	DrawBoxTitle(width+size*2,height,'系统设置',C_ORANGE);
	local function Menu_Sys_Set_Show()
		--DrawBox(CC.MainX,CC.MainY2,CC.ScreenW-CC.MainX_L,CC.MainY2+9*(size+CC.RowPixel)+4*CC.MenuBorderPixel,C_WHITE);
		local color;
		local x,y=(CC.ScreenW-width)/2+size/2,(CC.ScreenH-height)/2+size;
		if select==1 then
			color=M_Yellow;
		else
			color=C_WHITE;
		end
		DrawString(x,y,"音乐音量",color,size);
		for i=1,num do
			if math.modf(CONFIG.MusicVolume/step)+1==i then
				DrawString(x+size*(4+i/2),y,"+",M_Yellow,size);
			else
				DrawString(x+size*(4+i/2),y,"-",C_WHITE,size);
			end
		end
		y=y+size+CC.RowPixel;
		if select==2 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"音效音量",color,size);
		for i=1,num do
			if math.modf(CONFIG.SoundVolume/step)+1==i then
				DrawString(x+size*(4+i/2),y,"+",M_Yellow,size);
			else
				DrawString(x+size*(4+i/2),y,"-",C_WHITE,size);
			end
		end
		y=y+size+CC.RowPixel;
		if select==3 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"打开声音",color,size);
		DrawString(x+size*4.5,y,"□",C_WHITE,size);
		if CONFIG.EnableSound==1 then
			DrawString(x+size*4,y-size/2,"√",C_RED,size*2);
		end
		y=y+size+CC.RowPixel;
		if select==4 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"按键设置",color,size);
		y=y+size+CC.RowPixel;
		if select==5 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"分辨率",color,size);
		DrawString(x+size*4.5,y,string.format("%dＸ%d",T.w[screen],T.h[screen]),color,size);
		y=y+size+CC.RowPixel;
		if select==6 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"窗口游戏",color,size);
		DrawString(x+size*4.5,y,"□",C_WHITE,size);
		if CONFIG.FullScreen==0 then
			DrawString(x+size*4,y-size/2,"√",C_RED,size*2);
		end
		y=y+size+CC.RowPixel;
		if select==7 then
			color=M_Yellow;
		else
			color=C_WHITE
		end
		DrawString(x,y,"繁体中文",color,size);
		DrawString(x+size*4.5,y,"□",C_WHITE,size);
		if CC.OSCharSet==1 then
			DrawString(x+size*4,y-size/2,"√",C_RED,size*2);
		end
		y=y+size*1.5+CC.RowPixel;
		if select==8 then
			DrawStrBox(CC.ScreenW/2-size*2,y,"保存退出",M_Yellow,size,M_DarkOrange);
		else
			DrawStrBox(CC.ScreenW/2-size*2,y,"保存退出",C_WHITE,size);
		end
		y=y+size+CC.RowPixel;
	end
		local surid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
		while true do
			lib.LoadSur(surid,0,0);
			Menu_Sys_Set_Show();
			ShowScreen();
			local event,key,mx,my=WaitKey(1);
			lib.Delay(50)
			if event==1 then
				if key==VK_UP then
					select=select-1;
					select=limitX(select,1,8);
				elseif key==VK_DOWN then
					select=select+1;
					select=limitX(select,1,8);
				elseif key==VK_LEFT then
					if select==1 then
						CONFIG.MusicVolume=CONFIG.MusicVolume-step;
						CONFIG.MusicVolume=limitX(CONFIG.MusicVolume,0,step*num);
					elseif select==2 then
						CONFIG.SoundVolume=CONFIG.SoundVolume-step;
						CONFIG.SoundVolume=limitX(CONFIG.SoundVolume,0,step*num);
					elseif select==5 then
						screen=screen-1;
						screen=limitX(screen,1,12);
					end
				elseif key==VK_RIGHT then
					if select==1 then
						CONFIG.MusicVolume=CONFIG.MusicVolume+step;
						CONFIG.MusicVolume=limitX(CONFIG.MusicVolume,0,step*num-1);
					elseif select==2 then
						CONFIG.SoundVolume=CONFIG.SoundVolume+step;
						CONFIG.SoundVolume=limitX(CONFIG.SoundVolume,0,step*num-1);
					elseif select==5 then
						screen=screen+1;
						screen=limitX(screen,1,12);
					end
				elseif key==VK_SPACE or key==VK_RETURN then
					if select==3 then
						if CONFIG.EnableSound==1 then
							CONFIG.EnableSound=0;
						else
							CONFIG.EnableSound=1;
						end
					elseif select==4 then
						if JYMsgBox("注意","即将重新设置按键*请谨慎设置",{"确定","取消"},2,19)==1 then
							local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
							local eventtype,keypress;
							PUSH(JY.EnableMouse);
							JY.EnableMouse=false;
							DrawStrBox(-1,-1,"【上】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_UP=keypress;
							lib.LoadSur(sid,0,0);
							DrawStrBox(-1,-1,"【下】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_DOWN=keypress;
							lib.LoadSur(sid,0,0);
							DrawStrBox(-1,-1,"【左】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_LEFT=keypress;
							lib.LoadSur(sid,0,0);
							DrawStrBox(-1,-1,"【右】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_RIGHT=keypress;
							lib.LoadSur(sid,0,0);
							DrawStrBox(-1,-1,"【确定】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_RETURN=keypress;
							lib.LoadSur(sid,0,0);
							DrawStrBox(-1,-1,"【取消】，请按键",C_WHITE,CC.Fontbig);
							ShowScreen();
							eventtype,keypress=WaitKey(1);
							VK_ESCAPE=keypress;
							lib.LoadSur(sid,0,0);
							JYMsgBox("设置完毕","此设置不会保存*重新开始后还原",{"确定"},1,2);
							lib.FreeSur(sid)
							JY.EnableMouse=POP();
						end
					elseif select==6 then
						if CONFIG.FullScreen==1 then
							CONFIG.FullScreen=0;
						else
							CONFIG.FullScreen=1;
						end
					elseif select==7 then
						if CC.OSCharSet==1 then
							CC.OSCharSet=0;
						else
							CC.OSCharSet=1
						end
					elseif select==8 then
						CC.ScreenW,CC.ScreenH=T.w[screen],T.h[screen];
						lib.LoadConfig(	CONFIG.MusicVolume,
												CONFIG.SoundVolume,
												CONFIG.EnableSound,
												CC.ScreenW,
												CC.ScreenH,
												CONFIG.FullScreen);
						SetFlag(100,1);
						SetFlag(101,CONFIG.MusicVolume);
						SetFlag(102,CONFIG.SoundVolume);
						SetFlag(103,CONFIG.EnableSound);
						SetFlag(104,CC.ScreenW);
						SetFlag(105,CC.ScreenH);
						SetFlag(106,CONFIG.FullScreen);
						SetFlag(107,CC.OSCharSet);
						lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    					lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
						lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],2);
					    lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);
					    lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],99);
						--[[
						if JY.Status==GAME_MMAP then
							lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0);
						elseif JY.Status==GAME_SMAP then
							lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
						end
						lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
						if CC.LoadThingPic==1 then
							lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
						end
						]]--
						lib.FreeSur(surid);
	if CC.ScreenW<800 then
		CONFIG.Zoom=0;
	else
		CONFIG.Zoom=1;
	end
if CONFIG.Zoom==1 then
	CONFIG.XScale = 36		-- 贴图宽度的一半
	CONFIG.YScale = 18		-- 贴图高度的一半
else
	CONFIG.XScale = 18		-- 贴图宽度的一半
	CONFIG.YScale = 9		-- 贴图高度的一半
end
	CC.XScale =CONFIG.XScale;
	CC.YScale =CONFIG.YScale;
	CC.FontBIG=math.modf(math.min(CC.ScreenW,CC.ScreenH)/12)	--最大，未使用	640x480时size=40
	CC.FontBig=math.modf(math.min(CC.ScreenW,CC.ScreenH)/15)	--较大，游戏开始菜单使用	640x480时size=32
	CC.Fontbig=math.modf(math.min(CC.ScreenW,CC.ScreenH)/20)	--通常字号，对话菜单等使用	640x480时size=24
	CC.Fontsmall=math.modf(math.min(CC.ScreenW,CC.ScreenH)/24)	--稍小字号	640x480时size=20
	CC.FontSmall=math.modf(math.min(CC.ScreenW,CC.ScreenH)/30)	--较小字号	640x480时size=16
	CC.FontSMALL=math.modf(math.min(CC.ScreenW,CC.ScreenH)/40)	--最小字号	640x480时size=12
	CC.RowPixel=math.modf(math.min(CC.ScreenW,CC.ScreenH)/100)         -- 每行字的间距像素数
    CC.StartMenuY=CC.ScreenH-3*(CC.FontBig+CC.RowPixel)-20;
	CC.NewGameY=CC.ScreenH-4*(CC.Fontbig+CC.RowPixel)-10;
	CC.MainSize=math.modf(CC.ScreenW/24);
	CC.MainX_L=math.modf((CC.ScreenW-CC.MainSize*20-CC.RowPixel*4-CC.MenuBorderPixel*10)/2);
	CC.MainX=CC.MainX_L+(CC.MainSize*6+CC.RowPixel)+CC.MenuBorderPixel*2;
	CC.MainY=(CC.ScreenH-CC.MainSize-CC.MenuBorderPixel*4-160-(CC.Fontsmall+CC.RowPixel)*11)/2;--CC.ScreenH/20;
	CC.MainY2=CC.MainY+CC.MainSize+4+CC.MenuBorderPixel*2;
	--子菜单的开始坐标
	CC.MainSubMenuX=CC.MainMenuX+4*CC.MenuBorderPixel+2*CC.Fontbig+5;       --主菜单为两个汉字
	CC.MainSubMenuY=CC.MainMenuY;

	--二级子菜单开始坐标
	CC.MainSubMenuX2=CC.MainSubMenuX+4*CC.MenuBorderPixel+4*CC.Fontbig+5;   --子菜单为四个字符

	CC.SingleLineHeight=CC.Fontbig+2*CC.MenuBorderPixel+5;  --带框的单行字符高
						setBright();
						return 0;
					end
				elseif key==VK_ESCAPE then
					return 1;
				end
			elseif event==2 or event==3 then
				
			end
		end
		lib.FreeSur(surid);
end

function Menu_Sys_Quit()
	--Show
	local button={"返回桌面","开始选单","我点错了"};
	local r=JYMsgBox("离开游戏","   抵制不良游戏 拒绝盗版游戏   *   注意自我保护 谨防受骗上当   *   适度游戏益脑 沉迷游戏伤身   *   合理安排时间 享受健康生活   ",button,3,195);
	if r==1 then
		JY.Status =GAME_END;
	elseif r==2 then
		JY.Status =GAME_START;
	end
	if r==3 then
		return 1;
	else
		return 0;
	end
end
--物品子菜单
function Menu_Thing(aa,bb,justshow)
	local menu={
				{"全部",Menu_Thing_Show,1},
				{"剧情",Menu_Thing_Show,0},
				{"丹药",Menu_Thing_Show,0},
				{"秘籍",Menu_Thing_Show,0},
				{"装备",Menu_Thing_Show,0},
				};
	for i=1,CC.MyThingNum do
		if JY.Base["物品"..i]>0 and JY.Base["物品数量"..i]>0 then
			local k=2+JY.Thing[JY.Base["物品"..i]]["类型"];
			k=limitX(k,2,5);
			menu[k][3]=1;
		else
			break;
		end
	end
	DrawStrBox(CC.MainX_L,CC.MainY,"  队伍列表  ",C_WHITE,CC.MainSize);
	if justshow~=0 then
		justshow=2;
	else
		justshow=1;
	end
    ShowMenu2(menu,5,0,CC.MainX,CC.MainY2,0,0,1,1,CC.MainSize,M_DarkOrange,M_Yellow,justshow);
end
function Thing_Use(aa,id,justshow)
	if justshow==0 then
		--Thing_Use_sub();
	else
		--Thing_Use_Show();
		local pid=JY.Base["队伍"..id];
		local p=JY.Person[pid];
		local x=CC.MainX;
		local y=CC.MainY2+CC.Fontbig*2+CC.MainSize+8*CC.MenuBorderPixel+2*CC.RowPixel;
		local x_bak,y_bak=x,y;
		local size=CC.Fontsmall;
		DrawBox(x,y,CC.ScreenW-CC.MainX_L,CC.ScreenH-CC.MainY,C_WHITE);
		x=x+10;
		local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
		local headx=(math.max(160,size*2+120)-headw)/2;
		local heady=(160-headh)/2;
		lib.PicLoadCache(1,p["头像代号"]*2,x+headx,y+heady,1);
		for i=headx+x,headx+x+headw do
			lib.Background(i,y+155-size,i+1,y+155,64+128*math.abs(x+headx+headw/2-i)/75);
		end
		y=y+155-size;
		local len=string.len(p["姓名"])/2;
		x=x+(160-size*(len+3))/2;
		DrawString(x,y,p["姓名"],M_Yellow,size);
		DrawString(x+size*(len+1),y,string.format("%2d",p["等级"]+4),M_Yellow,size);
		DrawString(x+size*(len+2),y,"级",M_DarkOrange,size);
		
		
		x=math.max(size*7,size*2+120,160);
		x=math.max(x,CC.ScreenW-CC.MainX_L-CC.MainX-x-math.max(size*10,size*2+90*2));
		x=x_bak+20+x;
--		y=y_bak+math.max((160-(CC.Fontbig+CC.RowPixel)*4)/2,10);--y_bak+15;
		x_bak=x;
		y=y_bak+160+CC.RowPixel;
		x=CC.MainX+10;
		local t=JY.Thing[JY.CurTID];
		local canuse=true;
		for i=1,t["条件"][0] do
			local str;
			local tj=t["条件"][i];
			if tj[2]>=0 then
				if p[tj[1]]<tj[2] then
					if tj[3]~=nil then
						str=string.format(tj[3],tj[2]);
					else
						str=tj[1].."不足";
					end
					canuse=false;
					DrawString(x,y,str,C_WHITE,size);
					y=y+size+CC.RowPixel;
				end
			else
				if p[tj[1]]>-tj[2] then
					if tj[3]~=nil then
						str=string.format(tj[3],-tj[2]);
					else
						str=tj[1].."过高";
					end
					canuse=false;
					DrawString(x,y,str,C_WHITE,size);
					y=y+size+CC.RowPixel;
				end
			end
		end
		if canuse then
			DrawStrBox(x,y,"可以使用",M_DarkOrange,CC.Fontbig);
		else
			DrawStrBox(x,y,"无法使用",M_DarkOrange,CC.Fontbig);
		end
		
		y=y_bak;
		y=y+math.max(0,(160-size*3+CC.RowPixel*2)/2);
		local T1={
					{"生命",p["生命最大值"],502},
					{"内力",p["内力最大值"],503},
					{"体力",100,504},
					--{"经验",CC.Exp[p["等级"]],502},
				};
		size=CC.Fontbig;
		for i,v in pairs(T1) do
			x=x_bak;
			DrawString(x,y,v[1],M_DarkOrange,size);
--			local bf=math.modf(p[v[1]]*160/v[2]);
--			lib.PicLoadCache(2,501*2,x+size*2,y+(size-24)/2,1);
--			lib.SetClip(x+size*2,y,x+size*2+bf,y+size+CC.RowPixel);
--			lib.PicLoadCache(2,v[3]*2,x+size*2,y+(size-24)/2,1);
--			lib.SetClip(0,0,0,0);
			local numstr=string.format("%d/%d",p[v[1]],v[2]);
			DrawString(x+size*2+(160-CC.Fontsmall*string.len(numstr)/2)/2,y+4,numstr,C_WHITE,CC.Fontsmall);
			y=y+size+CC.RowPixel;
		end
		size=CC.Fontsmall;
		
		x=x_bak;
		--y=math.abs(y,y_bak+160)+CC.RowPixel;
		y=y_bak+200;
		local TStr1={"拳掌","剑术","刀法","枪棍","暗器",};
		local TStr2={"刚猛","内力","轻灵",};
		local TStr3={
						[0]="无法使用%s类武功",
						"降低%s类武功威力·极",
						"降低%s类武功威力·大",
						"降低%s类武功威力·中",
						"降低%s类武功威力·小",
						"可以使用%s类武功",
						"提高%s类武功威力·小",
						"提高%s类武功威力·中",
						"提高%s类武功威力·大",
						"提高%s类武功威力·极",
					}
		for i=1,t["效果"][0] do
			local str;
			local xg=t["效果"][i];
			if t["类型"]==1 then
				if xg[2]>=0 then
					str=xg[3] or xg[1].."提高%d";
					str=string.format(str,xg[2]);
				else
					str=xg[3] or xg[1].."降低%d";
					str=string.format(str,-xg[2]);
				end
			elseif t["类型"]==2 then
				if xg[1]==1 then
					str=xg[4] or string.format(TStr3[xg[3]],TStr1[xg[2]]);
				elseif xg[1]==2 then
					str=xg[4] or string.format(TStr3[xg[3]],TStr2[xg[2]]);
				elseif xg[1]==3 then
					str=xg[3] or string.format("额外降低%d伤害",xg[2]);
				elseif xg[1]==4 then
					str=xg[3] or string.format("额外降低伤害%d％",xg[2]);
				elseif xg[1]==5 then
					if xg[3]==nil then
						if xg[2]>0 then
							str=string.format("提高身法%d",xg[2]);
						else
							str=string.format("降低身法%d",-xg[2]);
						end
					else
						str=xg[3];
					end
				end
			end
			DrawString(x,y,str,M_Yellow,size);
			y=y+size+CC.RowPixel;
		end
	end
end
function Menu_Thing_Show(aa,kind,justshow)
	if justshow==0 then
		Menu_Thing_Select(kind);
	else
		Menu_Thing_Show_sub(kind,0);
		TeamMenu(nil,2);
	end
end
function Menu_Thing_Select(kind)
	local select;
	local width=CC.ScreenW-CC.MainX_L-CC.MainX;
	local height=CC.ScreenH-CC.MainY-(CC.MainY2+CC.Fontbig*2+4*CC.MenuBorderPixel+CC.RowPixel*2);
	local pic_w,pic_h=80+2,80+2;
	local lie=math.modf((width-2*CC.MenuBorderPixel)/pic_w);
	local hang=math.modf((height-2*CC.MenuBorderPixel)/pic_h);
	local x=CC.MainX+(width-lie*pic_w)/2;
	local y=CC.MainY2+CC.Fontbig*2+5*CC.MenuBorderPixel+2*CC.RowPixel;
	local item={};
	local num;
	local function reget()
		num=0
		for i=1,CC.MyThingNum do
			local tid=JY.Base["物品"..i];
			local tnum=JY.Base["物品数量"..i];
			if tid<1 or tnum<1 then
				break;
			end
			local tkind=JY.Thing[tid]["类型"]+2;
			tkind=limitX(tkind,2,5);
			if kind==1 or kind==tkind then
				num=num+1;
				item[num]=i;
			end
		end
	end
	reget();
	select=item[1];
	local Cur_line=0;
	local Cur_x,Cur_y=1,1;
	local surid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
	while true do
		if num==0 then
			return;
		end
		lib.LoadSur(surid,0,0);
		Menu_Thing_Show_sub(kind,Cur_line,select);
		TeamMenu(nil,2);
		ShowScreen();
		local eventtype,key,mx,my=WaitKey(1);
		if eventtype==1 then
			local x_bak=Cur_x;
			local y_bak=Cur_y;
			if key==VK_UP then
				if Cur_y>1 then
					Cur_y=Cur_y-1;
				elseif Cur_y==1 and Cur_line>0 then
					Cur_line=Cur_line-1;
				end
			elseif key==VK_DOWN then
				if (Cur_line+Cur_y)*lie<num then
					if Cur_y<hang then
						Cur_y=Cur_y+1;
					elseif Cur_y==hang then
						Cur_line=Cur_line+1;
					end
				end
			elseif key==VK_LEFT then
				if Cur_x>1 then
					Cur_x=Cur_x-1;
				else
					Cur_x=lie;
				end
			elseif key==VK_RIGHT then
				if Cur_x<lie then
					Cur_x=Cur_x+1;
				else
					Cur_x=1;
				end
			elseif key==VK_SPACE or key==VK_RETURN then
				JY.CurTID=JY.Base["物品"..select];
				if JY.Thing[JY.CurTID]["类型"]>0 then
					lib.SetClip(0,CC.MainY2,CC.MainX-CC.MenuBorderPixel,CC.ScreenH);
					lib.LoadSur(surid,0,0);
					lib.SetClip(CC.MainX,CC.MainY2+CC.MainSize+CC.Fontbig*2+CC.MenuBorderPixel*7+CC.RowPixel*2,CC.ScreenW,CC.ScreenH);
					lib.LoadSur(surid,0,0);
					lib.SetClip(0,0,0,0);
					TeamMenu(Thing_Use,1);
					reget();
				end
			elseif key==VK_ESCAPE then
				break;
			end
			local tmp=(Cur_line+Cur_y-1)*lie+Cur_x;
			if between(tmp,1,num) then
				select=item[tmp];
			else
				Cur_x,Cur_y=x_bak,y_bak;
			end
		elseif eventtype==2 or eventtype==3 then
			local x_bak=Cur_x;
			local y_bak=Cur_y;
			Cur_x=math.modf((mx-x)/pic_w)+1;
			Cur_y=math.modf((my-y)/pic_h)+1;
			local tmp=(Cur_line+Cur_y-1)*lie+Cur_x;
			if between(tmp,1,num) then
				select=item[tmp];
				if eventtype==3 then
					break;
				end
			else
				Cur_x,Cur_y=x_bak,y_bak;
			end
		end
	end
	lib.FreeSur(surid);
end
function Menu_Thing_Show_sub(kind,Cur_line,select)
	local width=CC.ScreenW-CC.MainX_L-CC.MainX;
	DrawBox(CC.MainX,CC.MainY2+CC.MainSize+3*CC.MenuBorderPixel,CC.MainX+width,CC.MainY2+CC.Fontbig+CC.MainSize+5*CC.MenuBorderPixel,C_WHITE);
	DrawBox(CC.MainX,CC.MainY2+CC.Fontbig+CC.MainSize+5*CC.MenuBorderPixel+CC.RowPixel,CC.MainX+width,CC.MainY2+CC.Fontbig*2+CC.MainSize+7*CC.MenuBorderPixel+CC.RowPixel,C_WHITE);
	local height=CC.ScreenH-CC.MainY-(CC.MainY2+CC.Fontbig*2+4*CC.MenuBorderPixel+CC.RowPixel*2);
	--DrawBox(CC.MainX,CC.MainY2+CC.Fontbig*2+4*CC.MenuBorderPixel+2*CC.RowPixel,CC.MainX+width,CC.ScreenH-CC.MainY,C_WHITE);
	local pic_w,pic_h=80+2,80+2;
	local lie=math.modf((width-2*CC.MenuBorderPixel)/pic_w);
	local hang=math.modf((height-2*CC.MenuBorderPixel)/pic_h);
	local x=CC.MainX+(width-lie*pic_w)/2;
	local y=CC.MainY2+CC.Fontbig*2+CC.MainSize+8*CC.MenuBorderPixel+2*CC.RowPixel;--(CC.MainY2+CC.Fontbig*2+4*CC.MenuBorderPixel+CC.RowPixel*2)+(height-hang*pic_h)/2;
	DrawBox(x-CC.MenuBorderPixel,y-CC.MenuBorderPixel,x+lie*pic_w+CC.MenuBorderPixel,y+hang*pic_h+CC.MenuBorderPixel,C_WHITE);
	local num=0;
	local id=Cur_line*lie;
	while num<hang*lie do
		id=id+1;
		if id>CC.MyThingNum then
			break;
		end
		local tid=JY.Base["物品"..id];
		local tnum=JY.Base["物品数量"..id];
		if tid<1 or tnum<1 then
			break;
		end
		local tkind=JY.Thing[tid]["类型"]+2;
		tkind=limitX(tkind,2,5);
		if kind==1 or kind==tkind then
			if select==nil then
				select=id;
			end
			if id==select then
				DrawBox(x+pic_w*(num%lie)-1,y+pic_h*math.modf(num/lie)-1,
						x+pic_w*((num%lie)+1)+1,y+pic_h*(math.modf(num/lie)+1)+1,C_WHITE,M_Yellow);
				DrawString((CC.ScreenW-CC.MainX_L+CC.MainX)/2-CC.Fontbig*string.len(JY.Thing[tid]["名称"])/4,
							CC.MainY2+CC.MainSize+4*CC.MenuBorderPixel,
							JY.Thing[tid]["名称"],M_Yellow,CC.Fontbig);
				DrawString(x+pic_w*lie-CC.Fontbig*4,CC.MainY2+CC.MainSize+4*CC.MenuBorderPixel,string.format("Ｘ %d",tnum),C_WHITE,CC.Fontbig);
				DrawString((CC.ScreenW-CC.MainX_L+CC.MainX)/2-CC.Fontbig*string.len(JY.Thing[tid]["说明"])/4,
							CC.MainY2+CC.Fontbig+CC.MainSize+6*CC.MenuBorderPixel+CC.RowPixel,
							JY.Thing[tid]["说明"],M_Yellow,CC.Fontbig);
			end
			lib.PicLoadCache(99,tid*2,x+pic_w*(num%lie)+1,y+pic_h*math.modf(num/lie)+1,1);
			num=num+1;
		end
	end
end

--保存进度
function Menu_SaveRecord()         --保存进度菜单
	local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.Fontbig,C_ORANGE, C_WHITE);
    if r>0 then
		if JY.Status==GAME_SMAP then 			--保存部分和场景地图存档相关信息
			JY.Base["场景"]=JY.SubScene
		else
			JY.Base["场景"]=-1
		end
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.Fontbig);
        ShowScreen();
        SaveRecord(r);
        --Cls(CC.MainSubMenuX2,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
		return 1;
	end
    return 0;
end

--读取进度
function Menu_ReadRecord()        --读取进度菜单
	local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.Fontbig,C_ORANGE, C_WHITE);

    if r == 0 then
        return 0;
    elseif r>0 then
        DrawStrBox(CC.MainMenuX,CC.MainMenuY,"请稍候......",C_WHITE,CC.Fontbig);
        ShowScreen();
        LoadRecord(r);
		if JY.Base["场景"]~=-1 then 
			if JY.SubScene < 0 then          --处于大地图
				CleanMemory();
				--lib.UnloadMMap();
			end
			--lib.PicInit();
			lib.ShowSlow(50,1)
			JY.Status=GAME_SMAP
			JY.SubScene=JY.Base["场景"]
			JY.MmapMusic=-1;
			JY.MyPic=GetMyPic();
			Init_SMap(2);
		else JY.Status=GAME_FIRSTMMAP;
		end
        return 1;
	end
end

--队伍菜单
function TeamMenu(menufun,justshow)
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["队伍" .. i];
		if id>=0 then
            if JY.Person[id]["生命"]>0 then
                menu[i][1]=fillblank(JY.Person[id]["姓名"],12);
				--lib.Debug(string.len(menu[i][1]))
				menu[i][2]=menufun;
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,CC.MainX_L,CC.MainY2,CC.MainX_L+CC.MainSize*6+2*CC.MenuBorderPixel,CC.ScreenH-CC.MainY,1,1,CC.MainSize,M_DarkOrange,M_Yellow,justshow);
end
function fillblank(s,num)
	local len=num-string.len(s);
	if len<=0 then
		return string.sub(s,1,num);
	else
		local left,right;
		left=math.modf(len/2);
		right=len-left;
		return string.format(string.format("%%%ds%%s%%%ds",left,right),"",s,"")
	end
end

--离队Exit
function Menu_PersonExit()        --离队Exit
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要求谁离队",C_WHITE,CC.Fontbig);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

	local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r==1 then
        DrawStrBoxWaitKey("抱歉！没有你游戏进行不下去",C_WHITE,CC.Fontbig,1);
    elseif r>1 then
        local personid=JY.Base["队伍" .. r];
        for i,v in ipairs(CC.PersonExit) do         --在离队列表中调用离队函数
             if personid==v[1] then
                 oldCallEvent(v[2]);
             end
        end
    end
    Cls();
    return 0;
end

--队伍选择人物菜单
function SelectTeamMenu(x,y)          --队伍选择人物菜单
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["队伍" .. i];
		if id>=0 then
            if JY.Person[id]["生命"]>0 then
                menu[i][1]=JY.Person[id]["姓名"];
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.Fontbig,C_ORANGE, C_WHITE);
end

function GetTeamNum()            --得到队友个数
    local r=CC.TeamNum;
	for i=1,CC.TeamNum do
	    if JY.Base["队伍" .. i]<0 then
		    r=i-1;
		    break;
		end
    end
	return r;
end

function ShowKungfuMove(x,y,w,h,kfid,kflv,size)
	local move;
	for i=kflv,1,-1 do
		if JY.Kungfu[kfid]["攻击范围"][i]~=nil then
			move=JY.Kungfu[kfid]["攻击范围"][i];
			break;
		end
	end
	if type(move)~='table' then
		return;
	end
	local num=3+2*move[2];
	if num<7 then num=7 end;
	local center=math.modf(num/2)+1;
	local len=math.modf(math.min(w,h)/num)-1;
	--lib.Background(x,y,x+w,y+h,128);
	if len<2 then
		DrawString(x,y,'Error',C_WHITE,CC.Fontbig);
		return;
	end
	DrawBox_1(x,y,x+w,y+h,C_WHITE);
	DrawBox(x,y,x+size+CC.MenuBorderPixel*2,y+h,C_WHITE);
	DrawStrBox_2(x,y+(h-size*4-CC.RowPixel*3+CC.MenuBorderPixel)/2,'攻*击*范*围',C_WHITE,size);
	x=x+CC.MenuBorderPixel*2+size;
	w=w-CC.MenuBorderPixel*2-size;
	x=x+math.modf((w-len*num)/2);
	y=y+math.modf((h-len*num)/2);
	for i=1,num do
		for j=1,num do
			local color=C_BLACK;
			local xlen,ylen=math.abs(i-center),math.abs(j-center);
			if move[1]==0 then
				if xlen+ylen<=move[2] then
					color=M_Yellow;
				end
			elseif move[1]==1 then
				if xlen<=move[2] and ylen<=move[2] then
					color=M_Yellow;
				end
			elseif move[1]==2 then
				if (xlen<=move[2] and ylen==0) or (ylen<=move[2] and xlen==0) then
					color=M_Yellow;
				end
			elseif move[1]==3 then
				if xlen<=move[2] and ylen<=move[2] then
					color=M_Yellow;
				end
			end
			if xlen==0 and ylen==0 then
				color=C_RED;
			end
			if color~=C_BLACK then
				lib.Background(x+len*(i-1),y+len*(j-1),x+len*i-1,y+len*j-1,128,color);
			end
			--lib.DrawRect(x+len*(i-1)+1,y+len*(j-1)+1,x+len*i+1,y+len*j+1,C_BLACK);
			--lib.DrawRect(x+len*(i-1),y+len*(j-1),x+len*i,y+len*j,C_WHITE);
		end
	end
end

function ShowKungfuAtk(x,y,w,h,kfid,kflv,size)
	local fanwei;
	for i=kflv,1,-1 do
		if JY.Kungfu[kfid]["伤害范围"][i]~=nil then
			fanwei=JY.Kungfu[kfid]["伤害范围"][i];
			break;
		end
	end
	if type(fanwei)~='table' then
		return;
	end
	local num=0;
	local cx,cy;
	if fanwei[1]==10 then
		for i=2,5 do
			if fanwei[i]~=nil and fanwei[i]>num then
				num=fanwei[i]+2-i;
				if fanwei[i]>0 and num<i*2-1 then
					num=i*2-1;
				end
			end
		end
		--[[
		]]--
		cy=0;
		for i=3,5 do
			if fanwei[i]~=nil then
				cy=cy+1;
			end
		end
		num=num+cy+2;
		if num/2==math.modf(num/2) then
			num=num+1;
		end
		cy=num-cy-1;
		cx=math.modf(num/2)+1;
	elseif fanwei[1]==13 then
		num=math.modf(fanwei[2]*3/2)*2+3;
		cy=math.modf(num*2/3)+1;
		cx=math.modf(num/2)+1;
	else
		for i=2,5 do
			if fanwei[i]~=nil and fanwei[i]>num then
				num=fanwei[i];
			end
		end
		num=num*2+3;
		if num<7 then num=7 end
		cx=math.modf(num/2)+1;
		cy=cx;
	end
	local len=math.modf(math.min(w,h)/num)-1;
	--lib.Background(x,y,x+w,y+h,128);
	if len<2 then
		DrawString(x,y,'Error',C_WHITE,CC.Fontbig);
		return;
	end
	DrawBox_1(x,y,x+w,y+h,C_WHITE);
	DrawBox(x,y,x+size+CC.MenuBorderPixel*2,y+h,C_WHITE);
	DrawStrBox_2(x,y+(h-size*4-CC.RowPixel*3+CC.MenuBorderPixel)/2,'伤*害*范*围',C_WHITE,size);
	x=x+CC.MenuBorderPixel*2+size;
	w=w-CC.MenuBorderPixel*2-size;
	x=x+math.modf((w-len*num)/2);
	y=y+math.modf((h-len*num)/2);
	local pointnum,xy;
	pointnum,xy=WarDrawAtt(cx,cy,fanwei,0,cx,cy+1);
	for i=1,pointnum do
		--lib.FillColor(x+len*(xy[i][1]-1),y+len*(xy[i][2]-1),x+len*xy[i][1],y+len*xy[i][2],C_WHITE);
		lib.Background(x+len*(xy[i][1]-1),y+len*(xy[i][2]-1),x+len*xy[i][1]-1,y+len*xy[i][2]-1,128,M_Yellow)
	end
	--lib.FillColor(x+len*(cx-1),y+len*(cy-1),x+len*cx,y+len*cy,C_RED);
	lib.Background(x+len*(cx-1),y+len*(cy-1),x+len*cx-1,y+len*cy-1,128,C_RED);
	for i=1,num do
		for j=1,num do
		--	lib.DrawRect(x+len*(i-1)+1,y+len*(j-1)+1,x+len*i+1,y+len*j+1,C_BLACK);
		--	lib.DrawRect(x+len*(i-1),y+len*(j-1),x+len*i,y+len*j,C_WHITE);
			--lib.Background(x+len*(i-1),y+len*(j-1),x+len*i-1,y+len*j-1,196,C_WHITE);
		end
	end
	
	--DrawString(x,y,string.format('%02d',pointnum),C_GOLD,CC.Fontsmall);
end

function ResetPersonAttrib(pid)
	--重设人物属性，主要是用于生命内力最大值等
	local p=JY.Person[pid];
	local percent,add;
	percent,add=100,0;
	add=smagic(pid,61,1);
	percent=100+smagic(pid,63,1)-p["中毒"]*0.7;
	--lib.Debug(add..','..percent)
	p["生命最大值"]=math.modf((p["生命Max"]+add)*percent/100);
	AddPersonAttrib(pid,"生命",0);
	percent,add=100,0;
	add=smagic(pid,62,1);
	percent=100+smagic(pid,64,1)-p["内伤"]*0.7;
	p["内力最大值"]=math.modf((p["内力Max"]+add)*percent/100);
	AddPersonAttrib(pid,"内力",0);
end

function div100(num)
	if num<0 then return -1
	elseif num<100 then return 0
	elseif num<200 then return 1
	elseif num<300 then return 2
	elseif num<400 then return 3
	elseif num<500 then return 4
	elseif num<600 then return 5
	elseif num<700 then return 6
	elseif num<800 then return 7
	elseif num<900 then return 8
	elseif num<1000 then return 9
	else return 10
	end
	return num
end


--新的显示物品菜单，模仿原游戏
--显示物品菜单
--返回选择的物品编号, -1表示没有选择
function SelectThing(thing,thingnum)    --显示物品菜单

    local xnum=CC.MenuThingXnum;
    local ynum=CC.MenuThingYnum;

	local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --总体宽度
	local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --物品栏高度

	local dx=(CC.ScreenW-w)/2;
	local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+5))/2;


    local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --名称，说明和图片的Y坐标

    local cur_line=0;
    local cur_x=0;
    local cur_y=0;
    local cur_thing=-1;

	while true do
	    Cls();
		y1_1=dy;
        y1_2=y1_1+CC.ThingFontSize+2*CC.MenuBorderPixel;
        DrawBox(dx,y1_1,dx+w,y1_2,C_WHITE);
		y2_1=y1_2+5
		y2_2=y2_1+CC.ThingFontSize+2*CC.MenuBorderPixel
        DrawBox(dx,y2_1,dx+w,y2_2,C_WHITE);
        y3_1=y2_2+5;
        y3_2=y3_1+h;
		DrawBox(dx,y3_1,dx+w,y3_2,C_WHITE);

        for y=0,ynum-1 do
            for x=0,xnum-1 do
                local id=y*xnum+x+xnum*cur_line         --当前待选择物品
				local boxcolor;
                if x==cur_x and y==cur_y then
				    boxcolor=C_WHITE;
                    if thing[id]>=0 then
                        cur_thing=thing[id];
                        local str=JY.Thing[thing[id]]["名称"];
                        if JY.Thing[thing[id]]["类型"]==1 or JY.Thing[thing[id]]["类型"]==2 then
                            if JY.Thing[thing[id]]["使用人"] >=0 then
                                str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["使用人"]]["姓名"] .. ")";
                            end
                        end
                        str=string.format("%s X %d",str,thingnum[id]);
						local str2=JY.Thing[thing[id]]["物品说明"];

     			        DrawString(dx+CC.ThingGapOut,y1_1+CC.MenuBorderPixel,str,C_GOLD,CC.ThingFontSize);
     			        DrawString(dx+CC.ThingGapOut,y2_1+CC.MenuBorderPixel,str2,C_ORANGE,CC.ThingFontSize);

                    else
                        cur_thing=-1;
                    end
                else
 				    boxcolor=C_BLACK;
                end
				local boxx=dx+CC.ThingGapOut+x*(CC.ThingPicWidth+CC.ThingGapIn);
				local boxy=y3_1+CC.ThingGapOut+y*(CC.ThingPicHeight+CC.ThingGapIn);
                lib.DrawRect(boxx,boxy,boxx+CC.ThingPicWidth+1,boxy+CC.ThingPicHeight+1,boxcolor);
                if thing[id]>=0 then
				    if CC.LoadThingPic==1 then
					    lib.PicLoadCache(99,thing[id]*2,boxx+1,boxy+1,1);
					else
                        lib.PicLoadCache(0,(thing[id]+CC.StartThingPic)*2,boxx+1,boxy+1,1);
					end
                end
            end
        end

        ShowScreen();
	    local eventtype,keypress,mx,my=WaitKey(1);
        lib.Delay(100);
	if eventtype==1 then
        if keypress==VK_ESCAPE then
            cur_thing=-1;
            break;
        elseif keypress==VK_RETURN or keypress==VK_SPACE then
            break;
        elseif keypress==VK_UP then
            if  cur_y == 0 then
                if  cur_line > 0 then
                    cur_line = cur_line - 1;
                end
            else
                cur_y = cur_y - 1;
            end
        elseif keypress==VK_DOWN then
            if  cur_y ==ynum-1 then
                if  cur_line < (math.modf(200/xnum)-ynum) then
                    cur_line = cur_line + 1;
                end
            else
                cur_y = cur_y + 1;
            end
        elseif keypress==VK_LEFT then
            if  cur_x > 0 then
                cur_x=cur_x-1;
            else
                cur_x=xnum-1;
            end
        elseif keypress==VK_RIGHT then
            if  cur_x ==xnum-1 then
                cur_x=0;
            else
                cur_x=cur_x+1;
            end
		end
	elseif eventtype==2 then
			if mx>dx and my>dy and mx<CC.ScreenW-dx and my<CC.ScreenH-dy then
				cur_x=math.modf((mx-dx-CC.ThingGapOut/2)/(CC.ThingPicWidth+CC.ThingGapIn))
				cur_y=math.modf((my-y3_1-CC.ThingGapOut/2)/(CC.ThingPicHeight+CC.ThingGapIn))
			end
	elseif eventtype==3 then
		if keypress==888 and cur_line>0 then
			cur_line=cur_line-1
		elseif keypress==999 and cur_line<(math.modf(200/xnum)-ynum) then
			cur_line=cur_line+1
		else
			if mx>dx and my>dy and mx<CC.ScreenW-dx and my<CC.ScreenH-dy then
				cur_x=math.modf((mx-dx-CC.ThingGapOut/2)/(CC.ThingPicWidth+CC.ThingGapIn))
				cur_y=math.modf((my-y3_1-CC.ThingGapOut/2)/(CC.ThingPicHeight+CC.ThingGapIn))
				break;
			end
        end
	end
	end
    Cls();
    return cur_thing;
end



function newdirect(oldd)
	if oldd==-1 then 
		return -1 
	end
	if true  then return oldd end
	local x,y
	if JY.Status==GAME_SMAP then
		x,y=JY.Base["人X1"],JY.Base["人Y1"]
	elseif JY.Status~=GAME_MMAP then
		x,y=JY.Base["人X"],JY.Base["人Y"]
	else
		return -1
	end
	local function CanMove(od1,od2)
		local nx,ny
		nx=x+CC.DirectX[od1+1]
		ny=y+CC.DirectY[od1+1]
		if od2~=nil then
			nx=nx+CC.DirectX[od2+1]
			ny=ny+CC.DirectY[od2+1]
		end
		if JY.Status==GAME_SMAP then
			if SceneCanPass(nx,ny) then
				return true
			end
		else
			if (lib.GetMMap(nx,ny,3)==0 and lib.GetMMap(nx,ny,4)==0) or CanEnterScene(nx,ny)~=-1 then
				return true
			end
		end
		return false
	end
	local d1,d2,d3
	d1=oldd
	if oldd==0 then
		d2=1
		d3=2
	elseif oldd==1 then
		d2=3
		d3=0
	elseif oldd==2 then
		d2=0
		d3=3
	elseif oldd==3 then
		d2=2
		d3=1
	end
	if CanMove(d1) then
		return d1
	elseif CanMove(d2) and CanMove(d1,d2) then
		return d2
	elseif CanMove(d3) and CanMove(d1,d3) then
		return d3
	else
		return d1
	end
end

--场景处理主函数
function Game_SMap()         --场景处理主函数
	
	DrawSMap(CONFIG.FastShowScreen);
	for i=1,3 do
		--Timer[i]:go();
	--[[
		if Timer[i].status=='start' then
			Timer[i].t=Timer[i].t-0.05;
			if Timer[i].t<0 then
				Timer[i].status='stop';
				if type(Timer[i].event)=='function' then
					Timer[i].event();
				end
			end
			DrawString(0,i*CC.FontSmall,string.format('%.1f',Timer[i].t),C_WHITE,CC.FontSmall);
		end
	]]--
	end
	ShowScreen(CONFIG.FastShowScreen);

	lib.SetClip(0,0,0,0);

	if JY.OldDPass==-1 then
		local s_event=GetS(JY.SubScene,JY.Base['人X1'],JY.Base['人Y1'],3);
		JY.OldDPass=s_event;
		JY.CurrentD=s_event;
		if s_event>=200 then
			JY.LastSayPosition=1;
			JY.LastSayPid=0;
			SceneEvent[JY.SubScene][s_event]();
			JY.oldSMapX=-1;
			JY.oldSMapY=-1;
			JY.D_Valid=nil;
			return;
		else
			local d_event=lib.GetD(JY.SubScene,s_event,2)
			if d_event>0 then
				JY.LastSayPosition=1;
				JY.LastSayPid=0;
				JY.Da=lib.GetD(JY.SubScene,s_event,3);
				JY.Db=lib.GetD(JY.SubScene,s_event,4);
				local continue;
				if d_event>1000 then
					continue=CommonEvent(d_event-1000,JY.Da);
				else
					continue=SceneEvent[JY.SubScene][d_event]();
				end
				JY.oldSMapX=-1;
				JY.oldSMapY=-1;
				JY.D_Valid=nil;
				if not continue then
					return;
				end
			end
		end
		--lib.Debug(string.format('sceneid%d,eventid%d,x%d,y%d',JY.SubScene,JY.OldDPass,JY.Base['人X1'],JY.Base['人Y1']))
	end

	
	
    local isout=0;                --是否碰到出口
    if (JY.Scene[JY.SubScene]["出口X1"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] ==JY.Base["人Y1"]) or
       (JY.Scene[JY.SubScene]["出口X2"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y2"] ==JY.Base["人Y1"]) or
       (JY.Scene[JY.SubScene]["出口X3"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] ==JY.Base["人Y1"]) then
       isout=1;
    end

    if isout==1 then    --出去，返回主地图
        JY.Status=GAME_MMAP;

		--lib.PicInit();
		CleanMemory();
        lib.ShowSlow(50,1)

        if JY.MmapMusic<0 then
            JY.MmapMusic=JY.Scene[JY.SubScene]["出门音乐"];
        end

		Init_MMap();



        JY.SubScene=-1;
		JY.oldSMapX=-1;
		JY.oldSMapY=-1;

        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
        lib.ShowSlow(50,0)
        lib.GetKey();
        return;
    end

    --是否跳转到其他场景
    if JY.Scene[JY.SubScene]["跳转场景"] >=0 then
        if (JY.Base["人X1"]==JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"]==JY.Scene[JY.SubScene]["跳转口Y1"])
			or (JY.Base["人X1"]==JY.Scene[JY.SubScene]["跳转口X2"] and JY.Base["人Y1"]==JY.Scene[JY.SubScene]["跳转口Y2"]) then
			local OldScene=JY.SubScene;
            JY.SubScene=JY.Scene[JY.SubScene]["跳转场景"];
            lib.ShowSlow(50,1);
--[[
            if JY.Scene[JY.SubScene]["外景入口X1"]==0 and JY.Scene[JY.SubScene]["外景入口Y1"]==0 then
                JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"];            --新场景的外景入口为0，表示这是一个内部场景
                JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"];
            else
                JY.Base["人X1"]=JY.Scene[JY.SubScene]["跳转口X2"];         --外部场景，即从其他内部场景跳回。
                JY.Base["人Y1"]=JY.Scene[JY.SubScene]["跳转口Y2"];
            end
]]--
            if JY.Scene[OldScene]["外景入口X1"]~=0 then
				JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"];            --新场景的外景入口为0，表示这是一个内部场景
                JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"];
            else
                JY.Base["人X1"]=JY.Scene[OldScene]["跳转入口X"];         --外部场景，即从其他内部场景跳回。
                JY.Base["人Y1"]=JY.Scene[OldScene]["跳转入口Y"];
			end
			Init_SMap(1);

            return;
        end
    end
	
	--if CC.moved then
	--	ForceEnemy()
	--end
    local x,y;
    local eventtype,keypress,mx,my = getkey();
    local direct=-1;
    if eventtype == 1 then
		JY.MyTick=0;
		if keypress==VK_ESCAPE then
			MMenu();
			JY.oldSMapX=-1;
	        JY.oldSMapY=-1;
		elseif keypress==VK_UP then
			direct=0;
		elseif keypress==VK_DOWN then
			direct=3;
		elseif keypress==VK_LEFT then
			direct=2;
		elseif keypress==VK_RIGHT then
			direct=1;
		elseif keypress==9 then
			console()
		elseif keypress==VK_SPACE or keypress==VK_RETURN  then
            if JY.Base["人方向"]>=0 then        --当前方向下一个位置
				local nx,ny=JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1],JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1]
                local s_event=GetS(JY.SubScene,nx,ny,3);
				JY.CurrentD=s_event;
				local d_event=-1;
                if not SceneCanPass(nx,ny) then
					if between(s_event,0,199) then
						d_event=lib.GetD(JY.SubScene,s_event,2);
					elseif s_event>200 then
						SceneEvent[JY.SubScene][s_event]();
						return;
					end
					if d_event>0 then
						JY.Da=lib.GetD(JY.SubScene,s_event,3);
						JY.Db=lib.GetD(JY.SubScene,s_event,4);
						local skip=false;
						for ci,cv in pairs(MyQuest) do
							if cv~=0 then
								JY.LastSayPosition=1;
								JY.LastSayPid=0;
								skip=QuestEvent[ci](JY.Da);
							end
						end
						if not skip then
							for ci,cv in pairs(PE.meet) do
								if cv.trigger()==1 then
									cv.go();
									skip=true;
									break;
								end
							end
						end
						if not skip then
							JY.LastSayPosition=1;
							JY.LastSayPid=0;
							if d_event>1000 then
								CommonEvent(d_event-1000,JY.Da);
							else
								SceneEvent[JY.SubScene][d_event]();
							end
							JY.oldSMapX=-1;
							JY.oldSMapY=-1;
							JY.D_Valid=nil;
						end
						return;
					end
                end
            end
		end
	elseif eventtype==3 then
		if keypress==1 and JY.SubScene~=87 then
			local CenterX=CC.ScreenW/2;
			local CenterY=CC.ScreenH/2-GetS(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],4);
			--CenterX=CenterX-(JY.SubSceneX-JY.SubSceneY)*CC.XScale/2;
			--CenterY=CenterY+(JY.SubSceneX+JY.SubSceneY)*CC.YScale/2;
			mx=mx-CenterX;
			my=my-CenterY;
			mx=mx/CC.XScale;
			my=my/CC.YScale;
			mx,my=(mx+my)/2,(my-mx)/2;
			if mx>0 then mx=mx+0.99 else mx=mx-0.01 end
			if my>0 then my=my+0.99 else mx=mx-0.01 end
			mx=JY.Base["人X1"]+math.modf(mx);
			my=JY.Base["人Y1"]+math.modf(my);
			local best,minp=0,36;
			for i=-20,20 do
				if between(mx+i,0,63) and between(my+i,0,63) then
					local vv=math.abs(CC.ScreenH/2-GetS(JY.SubScene,mx+i,my+i,4)+CC.YScale*i*2-CenterY)+math.abs(i);
					--if math.abs(GetS(JY.SubScene,mx+i,my+i,4)-GetS(JY.SubScene,mx,my,4)-CC.YScale*i*2)<4 then
					if vv<minp then
						--if SceneCanPass(mx+i+JY.SubSceneX,my+i+JY.SubSceneY) then
							best=i;
							minp=vv;
						--end
					end
				end
			end
			mx,my=mx+best,my+best;
			if math.abs(mx)+math.abs(my)==1 then
				--[[
                local d_num=GetS(JY.SubScene,JY.Base["人X1"]+mx,JY.Base["人Y1"]+my,3);
                if d_num>=0 then
                    EventExecute(d_num,1);       --空格触发事件
					JY.oldSMapX=-1;
					JY.oldSMapY=-1;
					JY.D_Valid=nil;
                end
				]]--
			end
			if JY.SubScene~=99 then
				walkto(mx+JY.SubSceneX,my+JY.SubSceneY)
			end
		elseif keypress==3 then
			MMenu();
			JY.oldSMapX=-1;
	        JY.oldSMapY=-1;
		end
    end
	if AutoMoveTab[0]~=0 then
		if direct==-1 then
			direct=AutoMoveTab[AutoMoveTab[0]];
			AutoMoveTab[AutoMoveTab[0]]=nil;
			AutoMoveTab[0]=AutoMoveTab[0]-1;
		else
			AutoMoveTab={[0]=0}
		end
	end

    if JY.Status~=GAME_SMAP then
        return ;
    end
	
    if direct ~= -1 then
		--CC.moved=true;
        AddMyCurrentPic();
        x=JY.Base["人X1"]+CC.DirectX[direct+1];
        y=JY.Base["人Y1"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
    else
		--CC.moved=false;
        x=JY.Base["人X1"];
        y=JY.Base["人Y1"];
    end

    JY.MyPic=GetMyPic();

    DtoSMap();

    if direct~=-1 and (CC.cq~=nil or SceneCanPass(x,y)==true) then          --新的坐标可以走过去
		JY.OldDPass=-1;
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
    end

    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);
end

--场景坐标(x,y)是否可以通过
--返回true,可以，false不能
function SceneCanPass(x,y,flag)  --场景坐标(x,y)是否可以通过
    local ispass=true;        --是否可以通过
    if GetS(JY.SubScene,x,y,1)>0 then     --场景层1有物品，不可通过
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --事件层4
    if between(d_data,0,199) then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*数据为不能通过
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --水面，不可进入
        ispass=false;
    end
	if flag==nil then
		local hb1,hb2
		hb1=GetS(JY.SubScene,JY.Base['人X1'],JY.Base['人Y1'],4)
		hb2=GetS(JY.SubScene,x,y,4)
		if math.abs(hb1-hb2)>14 then
			ispass=false
		end
	end
    return ispass;
end


function Cal_D_Valid()     --计算200个D中有效的D
    if JY.D_Valid~=nil then
	    return ;
	end

    local sceneid=JY.SubScene;
	JY.D_Valid={};
	JY.D_Valid_Num=0;
    for i=0,CC.DNum-1 do
        local x=GetD(sceneid,i,9);
        local y=GetD(sceneid,i,10);
        local v=GetS(sceneid,x,y,3);
		if v>=0 then
            JY.D_Valid[JY.D_Valid_Num]=i;
			JY.D_Valid_Num=JY.D_Valid_Num+1;
		end
	end
end

function DtoSMap()          ---D*中的事件处理动画效果。
    local sceneid=JY.SubScene;
    JY.NumD_PicChange=0;
    JY.D_PicChange={};

	if JY.D_Valid==nil then
	    Cal_D_Valid();
	end

	for k=0,JY.D_Valid_Num-1 do
	    local i=JY.D_Valid[k];

		local p1=GetD(sceneid,i,5);
		if p1>0 then
			local p2=GetD(sceneid,i,6);
			local p3=GetD(sceneid,i,7);
			if p1 ~= p2 then
				local old_p3=p3;
				local delay=3--GetD(sceneid,i,8);
				if not (p3>=CC.SceneFlagPic[1]*2 and p3<=CC.SceneFlagPic[2]*2 and CC.ShowFlag==0) then --是否显示旗帜
					if p3<=p1 then     --动画已停止
						if JY.MyTick2 %100 > delay then
							p3=p3+2;
						end
					else
						if JY.MyTick2 % 4 ==0 then      --4个节拍动画增加一次
							p3=p3+2;
						end
					end
					if p3>p2 then
						 p3=p1;
					end
				end
				if old_p3 ~=p3 then    --动画改变了，增加一个
                    local x=GetD(sceneid,i,9);
                    local y=GetD(sceneid,i,10);
					local dy=GetS(sceneid,x,y,4);       --海拔
					JY.D_PicChange[JY.NumD_PicChange]={x=x, y=y, dy=dy, p1=old_p3/2, p2=p3/2}
					JY.NumD_PicChange=JY.NumD_PicChange+1;
					SetD(sceneid,i,7,p3);
				end
			end
		end
    end
end

--fastdraw = 0 or nil 全部重绘。用于事件中
--           1 考虑脏矩形 用于显示场景循环
function DrawSMap(fastdraw)         --绘场景地图
	local x,y=JY.SubSceneX,JY.SubSceneY;

	lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);
	JY.oldSMapX=JY.Base["人X1"];
	JY.oldSMapY=JY.Base["人Y1"];
	JY.oldSMapPic=JY.MyPic;
    JY.oldSMapXoff=x;
    JY.oldSMapYoff=y;
	
	DrawState();
	----[[
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
	end--]]--
	
	--if GetFlag(0)==0 then
	--end
end
function DrawState()
		local TyearA={[0]='甲','乙','丙','丁','戊','己','庚','辛','壬','癸'}
		local TyearB={[0]='子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'}
		local Tmonth={
						[0]='正月','二月','三月','四月',
						'五月','六月','七月','八月',
						'九月','十月','十一月','腊月'
					}
		local Tday={
						[0]='初一','初二','初三','初四','初五','初六',
						'初七','初八','初九','初十','十一','十二',
						'十三','十四','十五','十六','十七','十八',
						'十九','二十','廿一','廿二','廿三','廿四',
						'廿五','廿六','廿七','廿八','廿九','三十',
					}
		local t=GetFlag(1);
		local y,m,d;
		y=math.modf(t/360);
		m=math.modf((t%360)/30);
		d=t%30;
		lib.PicLoadCache(99,500*2,185,35)
		lib.PicLoadCache(99,501*2,155,48)
		lib.SetClip(75,36,75+math.modf(160*JY.Person[0]['体力']/100),60)
		lib.PicLoadCache(99,504*2,155,48)
		lib.SetClip(0,0,0,0)
		DrawString(25,10,TyearA[y%10]..TyearB[y%12]..'年'..Tmonth[m]..Tday[d],C_ORANGE,20)
		DrawString(80,38,JY.Person[0]['体力'],C_WHITE,20)
		if not CC.Debug then
			
		elseif JY.SubScene>=0 then
			DrawString(240,10,JY.Scene[JY.SubScene]['名称'],C_ORANGE,20)
		else
			DrawString(240,10,"大地图",C_ORANGE,20)
		end
end
function setBright()
	--CC.Light
	local step=math.modf(JY.Sight/30)+2;
	for i=CC.ScreenW/2-JY.Sight,CC.ScreenW/2+JY.Sight,step do
		for j=CC.ScreenH/2-JY.Sight,CC.ScreenH/2+JY.Sight,step do
			local light=JY.Light-math.sqrt((i-CC.ScreenW/2)^2+(j-CC.ScreenH/2)^2)*(JY.Light)/JY.Sight
			if light>255 then
				light=255;
			elseif light<0 then
				light=0;
			end
			for ii=i,i+step-1 do
				for jj=j,j+step-1 do
					if type(Bright[ii])~='table' then
						Bright[ii]={};
					end
					Bright[ii][jj]=light;
				end
			end
		end
	end
end


-- 读取游戏进度
-- id=0 新进度，=1/2/3 进度
--
--这里是先把数据读入Byte数组中。然后定义访问相应表的方法，在访问表时直接从数组访问。
--与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
function LoadRecord(id)       -- 读取游戏进度
    local t1=lib.GetTime();

    --读取R*.idx文件
    local data=Byte.create(4*7);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,4*7);

	local idx={}
	idx[0]=100;
	for i =1,7 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end
   CC.Mem_Base={}
   CC.Mem_Person={}
   CC.Mem_Thing={}
   CC.Mem_Scene={}
   CC.Mem_Wugong={}
   CC.Mem_Shop={}
   CC.Mem_Shicheng={}
    --读取R*.grp文件
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --基本数据
    Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);

    --设置访问基本数据的方法，这样就可以用访问表的方式访问了。而不用把二进制数据转化为表。节约加载时间和空间
	local meta_t={
	    __index=function(t,k)
	        return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
		end,

		__newindex=function(t,k,v)
	        SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
	 	end
	}
    setmetatable(JY.Base,meta_t);
	
	
    JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize);   --人物

	JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum);
	Byte.loadfile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);

	for i=0,JY.PersonNum-1 do
		JY.Person[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
			end
		}
        setmetatable(JY.Person[i],meta_t);
	end

	
	
    JY.ThingNum=math.floor((idx[3]-idx[2])/CC.ThingSize);     --物品
	JY.Data_Thing=Byte.create(CC.ThingSize*JY.ThingNum);
	Byte.loadfile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],CC.ThingSize*JY.ThingNum);
	for i=0,JY.ThingNum-1 do
		JY.Thing[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k,v);
			end
		}
        setmetatable(JY.Thing[i],meta_t);
	end

	
    JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize);     --场景
	JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum);
	Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);
	for i=0,JY.SceneNum-1 do
		JY.Scene[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v);
			end
		}
        setmetatable(JY.Scene[i],meta_t);
	end

	
    JY.WugongNum=math.floor((idx[5]-idx[4])/CC.WugongSize);     --武功
	JY.Data_Wugong=Byte.create(CC.WugongSize*JY.WugongNum);
	Byte.loadfile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],CC.WugongSize*JY.WugongNum);
	for i=0,JY.WugongNum-1 do
		JY.Wugong[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k,v);
			end
		}
        setmetatable(JY.Wugong[i],meta_t);
	end

	
	
    JY.ShopNum=math.floor((idx[6]-idx[5])/CC.ShopSize);     --小宝商店
	JY.Data_Shop=Byte.create(CC.ShopSize*JY.ShopNum);
	Byte.loadfile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],CC.ShopSize*JY.ShopNum);
	for i=0,JY.ShopNum-1 do
		JY.Shop[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k,v);
			end
		}
        setmetatable(JY.Shop[i],meta_t);
    end
	
    JY.ShichengNum=math.floor((idx[7]-idx[6])/CC.ShichengSize);     --师承
	JY.Data_Shicheng=Byte.create(CC.ShichengSize*JY.ShichengNum);
	Byte.loadfile(JY.Data_Shicheng,CC.R_GRPFilename[id],idx[6],CC.ShichengSize*JY.ShichengNum);
	for i=0,JY.ShichengNum-1 do
		JY.Shicheng[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Shicheng,i*CC.ShichengSize,CC.Shicheng_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Shicheng,i*CC.ShichengSize,CC.Shicheng_S,k,v);
			end
		}
        setmetatable(JY.Shicheng[i],meta_t);
    end
	
	--
	if id>0 then
		local hs={};
		hs[0]=Byte.hash(JY.Data_Base,idx[1]-idx[0]);
		hs[1]=Byte.hash(JY.Data_Person,CC.PersonSize*JY.PersonNum);
		hs[2]=Byte.hash(JY.Data_Thing,CC.ThingSize*JY.ThingNum);
		hs[3]=Byte.hash(JY.Data_Scene,CC.SceneSize*JY.SceneNum);
		hs[4]=Byte.hash(JY.Data_Wugong,CC.WugongSize*JY.WugongNum);
		hs[5]=Byte.hash(JY.Data_Shop,CC.ShopSize*JY.ShopNum);
		hs[6]=fileHash(CC.S_Filename[id])
		hs[7]=fileHash(CC.D_Filename[id])
		local hash=Byte.create(8*8);
		Byte.loadfile(hash,CC.R_GRPFilename[id],0,64);
	end
	
    lib.LoadSMap(CC.S_Filename[id],CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight,CC.D_Filename[id],CC.DNum,11);
	dofile '.\\script\\Kungfu.lua'
	dofile '.\\script\\Item.lua'
	
	if id>0 then
		for i=0,1000 do
			JY.Rnd100[i]=GetFlag(4000+i);
			--lib.Debug(i..'|'..JY.Rnd100[i])
		end
	else
		myRnd100();
	end
	local time1,time2,OldTime;
	time1=GetFlag(110);
	time2=GetFlag(111);
	if time1<0 then
		time1=time1+65536;
	end
	if time2<0 then
		time2=time2+65536;
	end
	OldTime=time1*65536+time2;
	if CC.Debug==false and math.abs(os.time()-OldTime)<60 then
		CC.SL=10;
	end
	MyQuest={};
	for i=1,90 do
		local v=GetFlag(900+i);
		if v~=0 then
			MyQuest[i]=v;
		end
	end
	if id>0 and GetFlag(100)==1 then
		CONFIG.MusicVolume=GetFlag(101);
		CONFIG.SoundVolume=GetFlag(102);
		CONFIG.EnableSound=GetFlag(103);
		CC.ScreenW=GetFlag(104);
		CC.ScreenH=GetFlag(105);
		CONFIG.FullScreen=GetFlag(106);
		CC.OSCharSet=GetFlag(107);
		lib.LoadConfig(	CONFIG.MusicVolume,
								CONFIG.SoundVolume,
								CONFIG.EnableSound,
								CC.ScreenW,
								CC.ScreenH,
								CONFIG.FullScreen);
		lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    	lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
		lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],2);
		lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);
		lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],99);
		if CC.ScreenW<800 then
			CONFIG.Zoom=0;
		else
			CONFIG.Zoom=1;
		end
		if CONFIG.Zoom==1 then
			CONFIG.XScale = 36		-- 贴图宽度的一半
			CONFIG.YScale = 18		-- 贴图高度的一半
		else
			CONFIG.XScale = 18		-- 贴图宽度的一半
			CONFIG.YScale = 9		-- 贴图高度的一半
		end
		CC.XScale =CONFIG.XScale;
		CC.YScale =CONFIG.YScale;
		CC.FontBIG=math.modf(math.min(CC.ScreenW,CC.ScreenH)/12)	--最大，未使用	640x480时size=40
		CC.FontBig=math.modf(math.min(CC.ScreenW,CC.ScreenH)/15)	--较大，游戏开始菜单使用	640x480时size=32
		CC.Fontbig=math.modf(math.min(CC.ScreenW,CC.ScreenH)/20)	--通常字号，对话菜单等使用	640x480时size=24
		CC.Fontsmall=math.modf(math.min(CC.ScreenW,CC.ScreenH)/24)	--稍小字号	640x480时size=20
		CC.FontSmall=math.modf(math.min(CC.ScreenW,CC.ScreenH)/30)	--较小字号	640x480时size=16
		CC.FontSMALL=math.modf(math.min(CC.ScreenW,CC.ScreenH)/40)	--最小字号	640x480时size=12
		CC.RowPixel=math.modf(math.min(CC.ScreenW,CC.ScreenH)/100)         -- 每行字的间距像素数
		CC.StartMenuY=CC.ScreenH-3*(CC.FontBig+CC.RowPixel)-20;
		CC.NewGameY=CC.ScreenH-4*(CC.Fontbig+CC.RowPixel)-10;
		CC.MainSize=math.modf(CC.ScreenW/24);
		CC.MainX_L=math.modf((CC.ScreenW-CC.MainSize*20-CC.RowPixel*4-CC.MenuBorderPixel*10)/2);
		CC.MainX=CC.MainX_L+(CC.MainSize*6+CC.RowPixel)+CC.MenuBorderPixel*2;
		CC.MainY=(CC.ScreenH-CC.MainSize-CC.MenuBorderPixel*4-160-(CC.Fontsmall+CC.RowPixel)*11)/2;--CC.ScreenH/20;
		CC.MainY2=CC.MainY+CC.MainSize+4+CC.MenuBorderPixel*2;
	--子菜单的开始坐标
	CC.MainSubMenuX=CC.MainMenuX+4*CC.MenuBorderPixel+2*CC.Fontbig+5;       --主菜单为两个汉字
	CC.MainSubMenuY=CC.MainMenuY;

	--二级子菜单开始坐标
	CC.MainSubMenuX2=CC.MainSubMenuX+4*CC.MenuBorderPixel+4*CC.Fontbig+5;   --子菜单为四个字符

	CC.SingleLineHeight=CC.Fontbig+2*CC.MenuBorderPixel+5;  --带框的单行字符高
		setBright();
	end
	--lib.Debug(lib.GetTime())
	JY.SubSceneX=GetFlag(998);
	JY.SubSceneY=GetFlag(999);
	JY.Name={};
	JY.Name["主角"]=0;
	for i=1,CC.ToalPersonNum do
		local name=JY.Person[i]["姓名"];
		if JY.Name[name]==nil then
			JY.Name[name]=i;
		end
	end
	dofile(CONFIG.NewEventPath .. "event.lua");
	collectgarbage();
	lib.Debug(string.format("Loadrecord%d time=%d",id,lib.GetTime()-t1));

		
end

-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id)         -- 写游戏进度
    --读取R*.idx文件
    local t1=lib.GetTime();
	local NowTime=os.time();
	local time1=math.modf(NowTime/65536);
	local time2=NowTime%65536;
	if time1>32767 then
		time1=time1-65536;
	end
	if time2>32767 then
		time2=time2-65536;
	end
	SetFlag(110,time1);
	SetFlag(111,time2);
	for i=1,90 do
		SetFlag(900+i,0);
	end
	for i,v in pairs(MyQuest) do
		SetFlag(900+i,v);
	end
	
    local data=Byte.create(4*6);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,4*6);

	local idx={};
	idx[0]=100;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end
	for i=0, 1000 do
		SetFlag(4000+i,JY.Rnd100[i]);
	end
    --写R*.grp文件
    Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);

	Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);

	Byte.savefile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],CC.ThingSize*JY.ThingNum);

	Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);

	Byte.savefile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],CC.WugongSize*JY.WugongNum);

	Byte.savefile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],CC.ShopSize*JY.ShopNum);
	
	SetFlag(998,JY.SubSceneX);
	SetFlag(999,JY.SubSceneY);
    lib.SaveSMap(CC.S_Filename[id],CC.D_Filename[id]);
	--
	local hs={};
	hs[0]=Byte.hash(JY.Data_Base,idx[1]-idx[0]);
	hs[1]=Byte.hash(JY.Data_Person,CC.PersonSize*JY.PersonNum);
	hs[2]=Byte.hash(JY.Data_Thing,CC.ThingSize*JY.ThingNum);
	hs[3]=Byte.hash(JY.Data_Scene,CC.SceneSize*JY.SceneNum);
	hs[4]=Byte.hash(JY.Data_Wugong,CC.WugongSize*JY.WugongNum);
	hs[5]=Byte.hash(JY.Data_Shop,CC.ShopSize*JY.ShopNum);
	hs[6]=fileHash(CC.S_Filename[id])
	hs[7]=fileHash(CC.D_Filename[id])
    local hash=Byte.create(8*8);
	for i=0,7 do
		Byte.set64(hash,8*i,hs[i]);
	end
    Byte.savefile(hash,CC.R_GRPFilename[id],0,64);
    lib.Debug(string.format("SaveRecord%d time=%d",id,lib.GetTime()-t1));
end

function VersionCheck()
	local file1={
						{"config.lua",228927340},
					}
	local file2={
						{"jyconst.lua",-232625492},{"war.lua",-2055656993},{"WE.lua",28760294},{"window.lua",356290792},
						{"AI.lua",-1282717221},{"NAI.lua",-581414820},{"event.lua",-1765423930},{"common.lua",1630964412},
						{"fmp.lua",-1397969097},{"kungfu.lua",1005068201},{"qs.lua",-1383251903},{"migong.lua",-1388042250},
						{"PY.lua",-457465211},{"Item.lua",1084645502},
					}
	local file3={
						{"event.lua",700139663},{"scene.lua",1782295507},
						--{"scene_1.lua",-136110709},{"scene_29.lua",1568379065},
						--{"scene_36.lua",-1176855034},{"scene_56.lua",379159996},{"scene_57.lua",-188270430},{"scene_58.lua",219002946},
						--{"scene_70.lua",1193941773},
					}
	local file4={
						{"warevent001.lua",204097031},{"warevent002.lua",631019546},{"warevent003.lua",848494482},{"warevent004.lua",-1047065775},
					}
	local file5={
						{CC.R_GRPFilename[0],214417108},{CC.R_IDXFilename[0],-1574662774},
						{CC.S_Filename[0],-1845472630},{CC.D_Filename[0],-1061735822},
					}
	local hs;
	hs=fileHash(CONFIG.ScriptPath.."jymain.lua",1)
	if hs~=1 then
		if CC.Debug then
			lib.Debug("jymain.lua="..hs);
		else
			return false;
		end
	end
	for i,v in pairs (file1) do
		hs=fileHash(CONFIG.CurrentPath..v[1]);
		if hs~=v[2] then
			if CC.Debug then
				lib.Debug(v[1].."="..hs);
			else
				return false;
			end
		end
	end
	for i,v in pairs (file2) do
		hs=fileHash(CONFIG.ScriptPath..v[1]);
		if hs~=v[2] then
			if CC.Debug then
				lib.Debug(v[1].."="..hs);
			else
				return false;
			end
		end
	end
	for i,v in pairs (file3) do
		hs=fileHash(CONFIG.NewEventPath..v[1]);
		if hs~=v[2] then
			if CC.Debug then
				lib.Debug(v[1].."="..hs);
			else
				return false;
			end
		end
	end
	for i,v in pairs (file4) do
		hs=fileHash(CONFIG.ScriptPath.."war\\"..v[1]);
		if hs~=v[2] then
			if CC.Debug then
				lib.Debug(v[1].."="..hs);
			else
				return false;
			end
		end
	end
	for i,v in pairs (file5) do
		hs=fileHash(v[1]);
		if hs~=v[2] then
			if CC.Debug then
				lib.Debug(v[1].."="..hs);
			else
				return false;
			end
		end
	end
	return true;
end

function fileHash(str,flag)
	flag= flag or 0;
	local len=filelength(str);
	local data=Byte.create(len);
    Byte.loadfile(data,str,0,len);
	return Byte.hash(data,len,flag);
end