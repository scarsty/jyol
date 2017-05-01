if WAR.tmp[1]==nil then
--return
--WE_move(1,5,5)
--WAR.Person[1]["死亡"]=true

WE_addperson(4,25,25,3,false)
WE_addperson(3,25,25,1,true)
--WE_sort()
WarDrawMap(0);
ShowScreen();
--WAR.Person[0]["我方"]=false
WE_atk(3,1,-1,55)
lib.Delay(200)
WE_atk(0,-1,1,55,10)
WAR.tmp[1]=1
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