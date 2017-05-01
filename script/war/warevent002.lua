--福威镖局灭门
if WAR.tmp[1]==nil then
	local num=0;
	for i=0,WAR.PersonNum-1 do
		if not WAR.Person[i]["我方"] then
			if not WAR.Person[i]["死亡"] then
				num=num+1;
			end
		end
	end
	if num<4 then
		lib.Delay(500);
		Dark();
		WE_addperson(27,26,27,2,900,false);
		WAR.CurID=WAR.PersonNum-1;
		WarDrawMap(0);
		Light();
		say("怎么回事！为什么还没拿下林震南",27);
		if WAR.Person[WE_getwarid(35)]["死亡"] then
			say("师傅！不知道哪跑来个野小子，都是他在捣乱！",45);
		else
			say("师傅！不知道哪跑来个野小子，都是他在捣乱！",35);
		end
		say("不成器的家伙！",27);
		WAR.tmp[1]=1;
	end
end
