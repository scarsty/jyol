--金盆洗手
if WAR.tmp[2]==nil then
	if JY.Person[0]["门派"]==5 then
		if JY.Person[113]["生命"]/JY.Person[113]["生命最大值"]<1 then
			lib.Delay(500);
			Dark();
			WE_addperson(0,29,16,0,200,false);
			WAR.CurID=WAR.PersonNum-1;
			WarDrawMap(0);
			Light();
			say("师叔，此战速战速决！");
			WAR.tmp[2]=1;
		end
	else
		WAR.tmp[2]=1;
	end
end
if WAR.tmp[1]==nil then
	if JY.Person[50]["生命"]/JY.Person[50]["生命最大值"]<0.95 then
		lib.Delay(500);
		Dark();
		WE_addperson(52,24,13,3,900,true);
		WE_addperson(53,33,13,3,800,true);
		--WE_addperson(65,25,13,3,700,true);
		--WE_addperson(63,32,13,3,600,true);
		WE_addperson(64,26,13,3,500,true);
		WE_addperson(62,31,13,3,400,true);
		if JY.Person[0]["门派"]==2 then
			WE_addperson(0,30,14,3,300,true);
		end
		WAR.CurID=WAR.PersonNum-1;
		WarDrawMap(0);
		Light();
		say("师傅，我们来帮您！",52);
		say("嵩山派欺人太甚了！",53);
		say("今日之事，本和你们无关，你们又何必......",50);
		if JY.Person[0]["门派"]==2 then
			say("我们受师门厚恩，义不相负，刘门弟子，和恩师同生共死。");
		else
			say("我们受师门厚恩，义不相负，刘门弟子，和恩师同生共死。",52);
		end
		say("哼，来几个送死的又能怎样！",113);
		JY.Person[50]["外功2"]=35;
		JY.Person[50]["外功经验2"]=900;
		--AddPersonAttrib(50,"经验",500000);
		--War_AddPersonLevel(50,true)--false); 
		if JY.Person[0]["门派"]==2 then
			if GetFlag(12001)==1 then
				say("嵩山派今日所作所为，诸位掌门莫非要袖手旁观不成！");
				say("五岳剑派一向同气连枝，费师兄你今日所为实在不对啊。",1);
				say("正是，他日必要去向左师兄讨个公道",66);
					Dark();
					SetWarMap(25,17,1,0);
					SetWarMap(25,16,1,0);
					SetWarMap(25,15,1,0);
					WE_addperson(1,24,16,1,750,true);
					WE_addperson(8,24,15,1,550,true);
					SetWarMap(32,17,1,0);
					SetWarMap(32,16,1,0);
					SetWarMap(32,15,1,0);
					WE_addperson(66,33,16,2,750,true);
					WE_addperson(75,33,15,2,550,true);
				Light();
				say("诸位掌门援手之恩，我衡山上下没齿难忘");
			end
		elseif JY.Person[0]["门派"]~=1 and JY.Person[0]["门派"]~=5 then
			if DrawStrBoxYesNo(-1,-1,"是否帮助刘正风？",C_WHITE,CC.Fontbig) then
				say("嵩山派今日所作所为，实在欺人太甚！");
				if JY.Person[0]["门派"]==0 then
					say("胡闹！还不快退下",1);
					if true then
						say("是....");
					else
					say("师傅！我五岳剑派一向同气连枝，刘正风虽然误交匪人，但已决定退出江湖，何必非要为难于他！");
					say("这个......",1);
					say("好啊，你华山派原来也是要相助刘正风不成！",113);
					say("今日之事，原只为刘正风一人，还请费师弟不要多造杀孽。",1);
					say("衡山派刘府上下，刘门弟子，俱是同党，一个不留！",113);
					say("如此，得罪了。",1);
					Dark();
					SetWarMap(25,17,1,0);
					SetWarMap(25,16,1,0);
					SetWarMap(25,15,1,0);
					WE_addperson(0,24,17,1,650,true);
					WE_addperson(1,24,16,1,750,true);
					WE_addperson(8,24,15,1,550,true);
					WarDrawMap(0);
					Light();
					end
				elseif JY.Person[0]["门派"]==2 then
				
				elseif JY.Person[0]["门派"]==3 then
					say("胡闹！还不快退下",66);
					if true then
						say("是....");
					else
					say("师傅！我五岳剑派一向同气连枝，刘正风虽然误交匪人，但已决定退出江湖，何必非要为难于他！");
					say("这个......",66);
					say("好啊，你华山派原来也是要相助刘正风不成！",113);
					say("今日之事，原只为刘正风一人，还请费师弟不要多造杀孽。",66);
					say("衡山派刘府上下，刘门弟子，俱是同党，一个不留！",113);
					say("如此，得罪了。",66);
					Dark();
					SetWarMap(25,21,1,0);
					SetWarMap(25,20,1,0);
					SetWarMap(25,19,1,0);
					WE_addperson(0,24,21,1,650,true);
					WE_addperson(88,24,20,1,750,true);
					WE_addperson(95,24,19,1,550,true);
					WarDrawMap(0);
					Light();
					end
				
				elseif JY.Person[0]["门派"]==4 then
					say("胡闹！还不快退下",88);
					if true then
						say("是....");
					else
					say("师傅！我五岳剑派一向同气连枝，刘正风虽然误交匪人，但已决定退出江湖，何必非要为难于他！");
					say("这个......",88);
					say("好啊，你华山派原来也是要相助刘正风不成！",113);
					say("今日之事，原只为刘正风一人，还请费师弟不要多造杀孽。",88);
					say("衡山派刘府上下，刘门弟子，俱是同党，一个不留！",113);
					say("如此，得罪了。",88);
					Dark();
					SetWarMap(32,17,1,0);
					SetWarMap(32,16,1,0);
					SetWarMap(32,15,1,0);
					WE_addperson(0,33,17,1,650,true);
					WE_addperson(66,33,16,1,750,true);
					WE_addperson(75,33,15,1,550,true);
					WarDrawMap(0);
					Light();
					end
				
				else
					WE_addperson(0,JY.Base["人X1"],JY.Base["人Y1"],1,650,true);
					WarDrawMap(0);
					Light();
				
				end
			else
				say("刘正风勾结魔教，咎由自取，我还是离他远一点吧。");
			end
		end
		WAR.tmp[1]=1;
	end
end
