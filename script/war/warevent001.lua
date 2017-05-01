--平之杀余人彦
if JY.Person[0]["生命"]<50 then
	if WAR.tmp[1]==nil then
		lib.Delay(500);
		Dark();
		WE_addperson(9,32,21,2,500,true);
		WE_addperson(14,32,22,2,700,true);
		WAR.CurID=WAR.PersonNum-1;
		WarDrawMap(0);
		Light();
		say("二师哥，咱们去帮帮他们吧。",14);
		say("也好，看那人武功路数，像是我华山派的，莫非师傅又收弟子了？",9);
		say("先把那群坏人打跑再说吧。",14);
		JY.Person[14]["友好"]=25;
		WAR.tmp[1]=1;
	end
end

if WAR.tmp[2]==nil then
	if WE_close(0,36,1) then
		Cls();
		say("哪来的野小子，敢管本大爷的闲事！",36);
		say("你这样的败类，人人得而诛之");
		WAR.tmp[2]=1;
	end
end

if WAR.tmp[3]==nil then
	if WE_close(0,136,1) then
		Cls();
		say("少镖头，你没事吧。");
		say("嗯，多谢少侠相助，这几个败类武功却是了得。",136);
		say("咱们且小心迎战。");
		WAR.tmp[3]=1;
	end
end

if WAR.tmp[4]==nil then
	if WE_close(36,136,1) then
		Cls();
		say("格老子的，你骂哪个是龟儿子？",36);
		say("谁骂我我骂谁！",136);
		WAR.tmp[4]=1;
	end
end

if WAR.tmp[5]==nil then
	if WE_close(0,14,2) then
		Cls();
		say("小师弟挺住，看师姐来指点指点你的剑法。",14);
		WAR.tmp[5]=1;
	end
end

if WAR.tmp[6]==nil then
	if WE_close(136,14,2) then
		Cls();
		say("想不到你武功如此厉害，还还以为你只是个弱女子呢。",136);
		WAR.tmp[6]=1;
	end
end















--[[
local hu
for i=0,WAR.PersonNum-1 do
	if WAR.Person[i]["人物编号"]==1 then hu=i end
end

local cx,cy=WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"]
WAR.CurID=hu
cx,cy=36,36
say("大哥你好！ｐ现在开始测试战斗事件！Ｐ首先我来试试移动一步",1,0)
say("我的Ｈ目标"..cx.."|"..cy.."|",1,0)
--	WarDrawMap(0);
--	ShowScreen();
--	lib.Delay(CC.WarAutoDelay);
--while true do
--WAR.Person[WAR.CurID]["移动步数"]=100
--local x,y=War_SelectMove() 
--War_SelectMove() 
cx,cy=WE_xy(cx,cy,hu)
say("更改Ｈ目标"..cx.."|"..cy.."|",1,0)
--War_CalMoveStep(WAR.CurID,100,0); 
War_MovePerson(cx,cy)
say("６Ｒ恭喜！",1,0)
say("你功夫开厉害了，等我叫帮手来",1,0)

				WAR.Person[WAR.PersonNum]["人物编号"]=3;
				WAR.Person[WAR.PersonNum]["我方"]=false;
				WAR.Person[WAR.PersonNum]["坐标X"]=cx;
				WAR.Person[WAR.PersonNum]["坐标Y"]=cy;
				WAR.Person[WAR.PersonNum]["死亡"]=false;
				WAR.Person[WAR.PersonNum]["人方向"]=2;
				WAR.PersonNum=WAR.PersonNum+1
				WarPersonSort()
	for i=0,WAR.PersonNum-1 do
		lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[3]["头像代号"]),
		                string.format(CC.FightPicFile[2],JY.Person[3]["头像代号"]),
						4+i);
						end
        for i=0,WAR.PersonNum-1 do
            WAR.Person[i]["贴图"]=WarCalPersonPic(i);
        end
		SetWarMap(cx,cy,2,WAR.CurID);
		SetWarMap(cx,cy,5,WAR.Person[WAR.CurID]["贴图"]);
	WarDrawMap(0);
	ShowScreen();
--end
--]]





--[[
人物出来后，要设置其编号，属于地方我方，坐标，是否死亡，方向
然后把战斗总人物加1
读取人物攻击动作贴图，以及站立图
再在其坐标，写入地图第二层(战斗人物编号)第五层信息（贴图）
还有按轻功排序
最后drawwarmap，显示即可

移动的话，考虑不同需要，应该是 move和moveto
关键在于先callmovestep，再move
而且目标点应该是可以到达的
这个在程序上应注意，最好是如果不能到达，则找最近的目标
这个恐怕就得从那个函数那里看起了，先弄懂再说

]]--