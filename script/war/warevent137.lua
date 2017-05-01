local function f1()	--战斗前对话
	local dfbb=WE_getwarid(27)
	local zj=WE_getwarid(0)
	local ylt=WE_getwarid(270)
	say("莲弟，你带谁一起来了？",27,0)
	say("仇家来了，我不带他来，他便要杀我。我怎能不见你一面而死？",270,4)
	say("有谁这样大胆，敢欺侮你？你叫他进来！” ",27,0)
	say("东方不败，你在装疯吗？”",0,1)
	say("你终于来了！莲弟，你……你……怎么了？是给他打伤了吗？",27,0)
	WE_follow(27,270)
	say("疼得厉害吗？只是断了腿骨，不要紧的，你放心好啦，我立刻给你接好。",27,0)
	say("大敌当前，你跟我这般婆婆妈妈干什么？你能打发得了敌人，再跟我亲热不迟！",270,4)
	say("是，是！你别生气，我这就打发了他们。",27,0)
	WE_xiaoshi(27)
	WE_xiaoshi(270)
	WE_chuxian(27,22,19)
	WE_chuxian(270,17,18)
	WAR.Person[ylt]["AI"]=3
	say("好快的身法！！",0,1)
	WAR.tmp[1]=1
	return
end

local function f2()
	if WE_close(0,270,2) and JY.Person[270]["生命"]>0 then
		say("你……你这混蛋，离我莲弟远点！",27,0)
		WAR.Person[WE_getwarid(27)]["Time"]=0
		WAR.tmp[2]=1
		return
	end
end

local function f3()
	if JY.Person[270]["生命"]<JY.Person[270]["生命"]/2 and JY.Person[270]["生命"]>0 then
		say("别伤害他！",27,0)
		WAR.Person[WE_getwarid[27]]["Time"]=0
		WAR.tmp[3]=1
		return
	end
end

local function f4()
	if JY.Person[270]["生命"]<JY.Person[270]["生命"]/4 and JY.Person[270]["生命"]>0 then
		say("莲弟！",27,0)
		WAR.Person[WE_getwarid[27]]["Time"]=0
		WAR.tmp[4]=1
		return
	end
end

local function f5()
	if WE_close(0,27,1) then
		say("东方不败，恭喜你练成了《葵花宝典》上的武功。",0,1)
		say("你是谁？竟敢如此对我说话，胆子当真不小。",27,0)
		say("是须眉男儿汉也好，是千娇百媚的姑娘也好，我最讨厌的，是男扮女装的老旦。”",0,1)
		say("我问你，你是谁？",27,0)
		local name=JY.Person[0]["姓名"]
		say("我叫"..name.."。",0,1)
		say("啊！你便是"..name.."。我早想见你一见，今日你就死在这里吧！",27,0)
		WAR.Person[WE_getwarid(27)]["Time"]=1000		
		WAR.tmp[5]=1
		return
	end
end


local function f6()
	if JY.Person[270]["生命"]<=0 then
		say("你……你好狠毒！！我和你们拼了！",27,0)
		local dfbb=WE_getwarid(27)
		WAR.Person[dfbb]["Time"]=1000
		WAR.Person[dfbb]["AI"]=4
		WAR.tmp[6]=1
		return
	end
end


local function f7()
	if WAR.tmp[6]==1 and WAR.Person[WE_getwarid(27)]["Time"]>600 then
		say("莲弟，我马上就送他们去陪你！",27,0)
		WAR.Person[WE_getwarid(27)]["Time"]=1000
		return
	end
end


if WAR.tmp[1]==nil then
	f1()
end
if WAR.tmp[6]==nil then
	f6()
end
if WAR.tmp[4]==nil then
	f4()
end
if WAR.tmp[3]==nil then
	f3()
end
if WAR.tmp[2]==nil then
	f2()
end
if WAR.tmp[5]==nil then
	f5()
end
if WAR.tmp[7]==nil then
	f7()
end













