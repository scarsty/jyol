SceneEvent[115]={};--大理段氏各事件
SceneEvent[115]={
				[1]=function()	--看门弟子
					--暂时不考虑大理段氏公敌
					if JY.Person[0]["门派"]~=7 then
						script_say("段氏家将：此处乃是大理镇南王府。");
					else
						if JY.Da>0 then
							say("有何指教？",JY.Da);
							local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"守卫",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
										};
							local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
							if r==1 then
								RandomEvent(JY.Da);
							elseif r==2 then
									if JY.Person[0]["体力"]<30 then
										say("我看你气色不太好，还是先好好休息吧。",JY.Da);
										return;
									end
								say("好，咱们较量看看。",JY.Da);
								local result=vs(0,-1,32,JY.Da,29,25,100);
								Cls();
								ShowScreen();
								if result then
									say("多谢指点！",JY.Da);
								else
									say("侥幸侥幸！",JY.Da);
								end
								DayPass(1);
							elseif r==3 then
								E_guarding(JY.Da);
							elseif r==4 then
								PersonStatus(JY.Da);
							elseif r==5 then
								say("再会！",JY.Da);
							end
						else
							script_say("段氏家将：再会！");
						end
					end
				end,
				[2]=function()	--切磋+传功弟子
					if JY.Person[0]["门派"]~=7 then	--非段氏弟子
						say("此处乃是大理镇南王府。",JY.Da);
					elseif JY.Da>0 then
						say("有何指教？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"锻炼",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,6,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							local n=0;
							local kflist={};
							for i=1,10 do
								if JY.Person[JY.Da]["所会武功"..i]>0 then
									n=n+1;
									table.insert(kflist,{JY.Person[JY.Da]["所会武功"..i],limitX(1+math.modf(JY.Person[JY.Da]["所会武功经验"..i]/100),1,100)})
								end
							end
							if n>0 then
								say("哦，你想学点什么？",JY.Da);
								LearnKF(0,JY.Da,kflist);
							else
								say("我没有什么可教给你的。",JY.Da);
							end
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							say("好啊，咱俩来玩玩。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("好厉害！",JY.Da);
							else
								say("你先下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							DayPass(1);
						elseif r==4 then
							E_learning(JY.Da);
						elseif r==5 then
							PersonStatus(JY.Da);
						else
							--say("你若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						script_say("段氏家将：此处乃是大理镇南王府。");
					end
				end,
				[3]=function()	--文臣
					if JY.Person[0]["门派"]~=7 then	--非段氏弟子
						say("此处乃是大理镇南王府。",JY.Da);
					elseif JY.Da>0 then
						say("有何指教？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"锻炼",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,6,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							local n=0;
							local kflist={};
							for i=1,10 do
								if JY.Person[JY.Da]["所会武功"..i]>0 then
									n=n+1;
									table.insert(kflist,{JY.Person[JY.Da]["所会武功"..i],limitX(1+math.modf(JY.Person[JY.Da]["所会武功经验"..i]/100),1,100)})
								end
							end
							if n>0 then
								say("哦，你想学点什么？",JY.Da);
								LearnKF(0,JY.Da,kflist);
							else
								say("我没有什么可教给你的。",JY.Da);
							end
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							say("好啊，咱俩来玩玩。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("好厉害！",JY.Da);
							else
								say("你先下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							DayPass(1);
						elseif r==4 then
							E_learning(JY.Da);
						elseif r==5 then
							PersonStatus(JY.Da);
						else
							--say("你若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						script_say("段氏家将：此处乃是大理镇南王府。");
					end
				end,
				[4]=function()	--掌门
					if JY.Person[0]["门派"]~=7 then	--非段氏弟子
						say("大理素来好客，阁下请随意游览。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"求官",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						if JY.Person[0]["门派"]>=0 then
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							if true then
								say("我段氏本是中原武人，最喜结交你这样的江湖人物。若是不介意，不妨先在此做个家将吧。",JY.Da);
								if DrawStrBoxYesNo(-1,-1,"是否真的要加入大理段氏？",C_WHITE,CC.Fontbig) then
									say("是！拜见王爷！");
									JY.Person[0]["门派"]=7;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ大理段氏",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="段氏家将";
									--GetItem(5,1);
								else
									say("哇！才是个家将啊，我才不要呢！");
								end
							end
						elseif r==3 then
							PersonStatus(JY.Da);
						else
							
						end
					else
						say("参见王爷！");
						say("何事禀告？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("我嵩山武功博大精深，你要好好研习。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							say("哦，你想学点什么？",JY.Da);
							local kflist={
												{101,10},
												{102,10},
												{103,10},
												{109,10},
												};
							if GetFlag(17004)==1 then
								kflist=	{
												{101,10},
												{102,10},
												{103,10},
												{109,10},
												{110,10},
										};
							end
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<15 then
								say("你？还是先练好基本功吧",JY.Da);
							else
								say("也好，你总要见识到天有多高的。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(25,26,1,851*2);
									SetWarMap(25,27,1,851*2);
									SetWarMap(25,28,1,851*2);
									SetWarMap(25,29,1,851*2);
								end
								local result=vs(0,21,27,JY.Da,13,26,3000);
								--[[SetWarMap(25,26,1,921*2);
								SetWarMap(25,27,1,0);
								SetWarMap(25,28,1,0);
								SetWarMap(25,29,1,919*2);]]--
								Cls();
								ShowScreen();
								if result then
									say("......",JY.Da);
								else
									say("见识到了就赶紧去练功。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("无事就去和师兄弟们切磋去。",JY.Da);
						end
					end
				end,
				[5]=function()	--段誉
					if JY.Person[0]["门派"]~=7 then	--非段氏弟子
						say("有朋至远方来，不亦乐乎！",JY.Da);
					elseif JY.Da>0 then
						say("有朋至远方来，不亦乐乎！",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"锻炼",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if true then
								say("打打杀杀，有伤和气，还是不要了。",JY.Da);
								return;
							end
							say("好啊，咱俩来玩玩。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("好厉害！",JY.Da);
							else
								say("你先下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							--say("你若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						script_say("段氏家将：此处乃是大理镇南王府。");
					end
				end,
				[6]=function()	--进入 预留以后事件使用
					return true;
				end,
				[7]=function()	--高升泰
					if JY.Person[0]["门派"]~=7 then	--非段氏弟子
						say("此处乃是大理镇南王府。",JY.Da);
					else
						say("此处乃是大理镇南王府。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,0},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("我嵩山武功博大精深，你要好好研习。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							say("哦，你想学点什么？",JY.Da);
							local kflist={
												{59,10},
												{60,10},
												--{61,10,1},
												{62,10},
												{63,10},
												{64,10},
												--{65,10,1},
												{77,10},
												--{78,10,2},
												{79,10},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if true then
								say("哈哈，就你也敢和我过招。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(25,26,1,851*2);
									SetWarMap(25,27,1,851*2);
									SetWarMap(25,28,1,851*2);
									SetWarMap(25,29,1,851*2);
								end
								local result=vs(0,21,27,JY.Da,13,26,3000);
								--[[SetWarMap(25,26,1,921*2);
								SetWarMap(25,27,1,0);
								SetWarMap(25,28,1,0);
								SetWarMap(25,29,1,919*2);]]--
								Cls();
								ShowScreen();
								if result then
									say("不错不错，虽然是我大意了，但你能做到这一步，也算难能可贵了。",JY.Da);
								else
									say("回去再练几年吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("退下吧。",JY.Da);
						end
					end
				end,
				[8]=function()	--厨房
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
						script_say("段氏家将：这里是厨房，没什么好看的。");
					elseif JY.Da>0 then
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							--say("去去去，还没到吃饭时候呢。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							say("这里是厨房，师弟你就别添乱了，去找别的师兄弟切磋吧",JY.Da);
						elseif r==3 then
							PersonStatus(JY.Da);
						elseif r==4 then
							say("没事就别添乱了，赶紧出去吧。",JY.Da);
						end
					else
						script_say("段氏家将：你别站这里添乱好不好，被师父看到骂死你。");
					end
				end,
			}

						--say("")