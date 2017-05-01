say("１师傅，您到底什么时候才教徒儿武艺啊？ｐＨ每天都是打坐，闷死了",0,1)
say("１我教你每天打坐运气，是让你修炼我道家正宗内功。Ｈ对你以后学武将会大有裨益！",68,0)
say("１那我要练到什么程度，您才能教我全真剑法呢？",0,1)
say("１也罢，今天就简单的教你两招。ｐ你很快就会知道我让你每天修炼内功的用处了",68,0)
say("多谢师傅",0,1)
say("１首先你要学会移动，你先试着移动到我身边来。",68,0)
local firstmove=0
local cid=WE_getwarid(0)
WAR.CurID=cid
while firstmove==0 do
	WAR.Person[cid]["移动步数"]=3
	 
    local menu={ {"移动",War_MoveMenu,1},
                 {"攻击",War_FightMenu,0},
                 {"用毒",War_PoisonMenu,0},
                 {"解毒",War_DecPoisonMenu,0},
                 {"医疗",War_DoctorMenu,0},
                 {"物品",War_ThingMenu,1},
                 {"等待",War_WaitMenu,0},
                 {"状态",War_StatusMenu,1},
                 {"休息",War_RestMenu,1},
                 {"自动",War_AutoMenu,0},   };

    

    lib.GetKey();
    Cls();
    ShowMenu(menu,10,0,CC.MainMenuX,CC.MainMenuY,0,0,1,0,CC.DefaultFont,C_ORANGE,C_WHITE);
	
	if WE_close(0,68) then
		say("１很好，看来你已经学会了移动，下面我教你全真剑法的入门招式",68,0)
		firstmove=1
	elseif Rnd(10)>7 then
		say("１还没到吗？不要着急，慢慢移动过来。ｐ１你以后轻功练好了，移动速度就能变快。",68,0)	
	end
	
end
		say("１康儿，你看仔细了！",68,0)
		WE_atk(68,1,0,39,10)
		say("１师傅，您的剑招太快了，徒儿没看清",0,1)
		say("１好，我再多演示几遍！",68,0)
		WE_atk(68,1,0,39,10)
		lib.Delay(100)
		WE_atk(68,1,1,39,10)
		lib.Delay(100)
		WE_atk(68,0,1,39,10)
		lib.Delay(100)
		WE_atk(68,-1,1,39,10)
		lib.Delay(100)
		WE_atk(68,-1,0,39,10)
		lib.Delay(100)
		WE_atk(68,-1,-1,39,10)
		lib.Delay(100)
		WE_atk(68,0,-1,39,10)
		lib.Delay(100)
		WE_atk(68,1,-1,39,10)
		lib.Delay(100)
		say("１康儿，你来试试。",68,0)
		say("１是",0,1)
		WE_atk(0,1,0,39)
		say("１咦？奇怪",0,1)
		WE_atk(0,1,0,39)
		WE_atk(0,1,0,39)
		say("１师傅，为什么我总是使不好！",0,1)
		say("１康儿，上乘武功都需要精纯的内力。ｐＨ你内力修为还不够，自然无法使出这精妙的剑法",68,0)
		say("１哦，难怪师傅一直教我打坐练气。",0,1)
		say("１正是，须知武功内功为体，招式为用。ｐＨ内力不到家，什么精妙招式都毫无用处。Ｐ好了，今天就到这吧。",68,0)
		local qcj=WE_getwarid(68)
		WAR.Person[qcj]["死亡"]=true
		return 1