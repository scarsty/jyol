SceneEvent[0]={}
SceneEvent[0]={
				[1]=function()	--胡斐
							say("小兄弟，到此寒天雪地，不知有何指教？",JY.Da);
							local menu={
													{"聊天",nil,1},
													{"切磋",nil,1},
													{"状态",nil,1},
													{"没事",nil,1},
												};
							local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
							if r==1 then
								RandomEvent(JY.Da);
							elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("敢情你是来考较我功夫的，那就动手吧！",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,600);
								Cls();
								ShowScreen();
								if result then
									say("不掂掂自己的份量，就敢上我辽东胡家．",JY.Da);
								else
								if 	GetFlag(65001)==0 and
									Rnd(10)==1 and
									JY.Person[0]["等级"]>JY.Person[JY.Da]["等级"] and
									SetFlag(65001,1);
									script_say("胡斐：唉……要不是我家传刀谱缺了两页……")
									script_say("主角：咦？胡大哥，这是怎么事？")
									script_say("胡斐：唉，说来惭愧。当年家中遭逢大难，我尚年幼，有心无力，只想拼命保住家传的刀谱，以期日后能练成武功，以报家仇。孰知竟有一跌打医生，在慌乱之中，却是将刀谱中的两页撕下带走。导致我现在所练的，乃是残缺的刀法。要是我当年……唉……不提也罢……")
									script_say("主角：（一名跌打医生？我日后需留意，看看能不能帮胡大哥寻回刀谱。）")
								else
									say("侥幸，侥幸！");
								end
								DayPass(1);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==7 then
								say("他日再向胡大哥领教刀法．");
							end
				end,
				[2]=function()	--倥侗弟子
				end,
				[3]=function()	--丐帮弟子
				end,
				[4]=function()	--住宿
					if DrawStrBoxYesNo(-1,-1,"是否休息？",C_WHITE,CC.Fontbig) then
						SetFlag(1,GetFlag(1)+1);
						rest();
						say("休息够了，继续努力吧。");
					else
					
					end
				end,
				[5]=function()	--青城弟子
				end,
			}