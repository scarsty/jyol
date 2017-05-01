--金盆洗手
if WAR.tmp[1]==nil then
	if JY.Person[113]["生命"]/JY.Person[113]["生命最大值"]<1 then
		say("师叔，师兄弟们应该正在找我们，相必要不了多久就会来援！");
		--AddPersonAttrib(113,"经验",500000);
		--War_AddPersonLevel(113,true)--false); 
		WAR.tmp[1]=1;
	end
end
if WAR.tmp[2]==nil then
	WAR.tmp[2]=1;
elseif WAR.tmp[2]==-1 then
	
elseif WAR.tmp[2]<10 then
	WAR.tmp[2]=WAR.tmp[2]+1;
elseif JY.Person[113]["生命"]<=0 then
		lib.Delay(500);
		Dark();
		WE_addperson(120,46,30,2,900,true);
		WE_addperson(121,48,31,2,800,true);
		WE_addperson(122,46,32,2,700,true);
		WE_addperson(123,48,33,2,600,true);
		WE_addperson(124,46,34,2,500,true);
		WE_addperson(125,48,29,2,400,true);
		WE_addperson(126,46,28,2,300,true);
		WE_addperson(127,48,27,2,200,true);
		WAR.CurID=WAR.PersonNum-1;
		WarDrawMap(0);
		Light();
		say("师叔，总算找到您了！",120);
	WAR.tmp[2]=-1;
end
