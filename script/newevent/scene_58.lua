SceneEvent[58]={};--衡山派各事件
SceneEvent[58]={
				[1]=function()	--看门弟子
					--暂时不考虑衡山公敌
								--ResetFW();
					--ShowEFT()
					--vs(149,38,51,66,29,49,300);
					--GetItem(0,1);
					if JY.Person[0]["门派"]~=2 and  GetFlag(12005)==1 then
						SceneEvent[58][201]();
						return;
					end
					if JY.Person[0]["门派"]~=2 then	--非衡山弟子
						local d=JY.Base["人方向"];
						if d==0 then
							say("阁下造访衡山，不知有何贵干？",60);
						else
							say("少侠要走了吗？",60);
						end
						local menu={
												{"进入",nil,1},
												{"拜师",nil,1},
												{"离开",nil,1},
												{"没事",nil,1},
											};
						if d==0 then
							menu[3][3]=0;
						else
							menu[1][3]=0;
							menu[2][3]=0;
						end
						if JY.Person[0]["门派"]>=0 then	--非无门派
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							say("我衡山处处茂林修竹，奇花异草，阁下若是有暇，不妨多四处走走。",60);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==2 then
							say("我这便向师尊通禀，小兄弟请随我来。",60);
							Dark();
							JY.Base["人X1"]=28;
							JY.Base["人Y1"]=14;
							JY.Base["人方向"]=0;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("你愿入我衡山？",49);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入衡山派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受徒儿一拜！");
									say("我无意收徒，你且拜于我师弟刘正风门下",49);
									say("是！");
									JY.Person[0]["门派"]=2;
									JY.Shop[2]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ衡山派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="衡山弟子";
									GetItem(2,1);
								else
									say("如此，在此做甚。",49);
								end
							else
								say("凭你这种江湖匪类，也想拜入我衡山门墙！",49);
							end
						elseif r==3 then
							say("小兄弟下次有空，不妨再来衡山看看。",60);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("既然无事，请阁下不要在此逗留。",60);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("师弟，有什么事吗？",JY.Da);
							local menu={
													{"聊天",nil,1},
													{"切磋",nil,1},
													{"状态",nil,1},
													{"站岗",nil,1},
													{"进入",nil,1},
													{"外出",nil,1},
													{"没事",nil,1},
												};
							if d==0 then
								menu[6][3]=0;
							else
								menu[5][3]=0;
							end
							local r=ShowMenu(menu,7,0,0,0,0,0,1,0);
							if r==1 then
								RandomEvent(JY.Da);
							elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("好啊，咱俩来玩玩。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(27,47,1,1021*2);
									SetWarMap(28,47,1,1022*2);
									SetWarMap(29,47,1,1022*2);
									SetWarMap(30,47,1,1023*2);
									SetWarMap(27,46,1,0);
									SetWarMap(30,46,1,0);
									SetWarMap(48,55,1,1144*2);
									SetWarMap(49,55,1,1144*2);
									SetWarMap(25,53,1,1144*2);
								end
								local result=vs(0,38,51,JY.Da,29,49,300);
								--[[SetWarMap(27,47,1,1024*2);
								SetWarMap(28,47,1,0);
								SetWarMap(29,47,1,0);
								SetWarMap(30,47,1,1026*2);
								SetWarMap(27,46,1,1025*2);
								SetWarMap(30,46,1,1027*2);
								SetWarMap(48,55,1,0);
								SetWarMap(49,55,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("想不到师弟入门没几日，武功就已如此了得。",JY.Da);
								else
									say("师弟你还得多练哪，咱们下次再切磋吧。",JY.Da);
								end
								DayPass(1);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==4 then
								--say("多谢师弟美意，可惜愚兄职责所在，无法脱身啊。",JY.Da);
								E_guarding(JY.Da);
							elseif r==5 then
								say("师弟请进。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==6 then
								say("江湖险恶，人心诡谲，师弟多加小心。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==7 then
								say("师弟若是无事，来聊聊天或者切磋下武功也好啊。",JY.Da);
							end
						else
							say("师弟请。",20);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						end
					end
				end,
				[2]=function()	--切磋用弟子
					if JY.Person[0]["门派"]~=2 then	--非衡山弟子
						say("欢迎阁下来我衡山做客。",60);
					elseif JY.Da>0 then
						say("恒山如行，岱山如坐，华山如立，嵩山如卧，惟有南岳独如飞。",JY.Da);
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
							say("好啊，咱俩来玩玩。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(27,47,1,1021*2);
								SetWarMap(28,47,1,1022*2);
								SetWarMap(29,47,1,1022*2);
								SetWarMap(30,47,1,1023*2);
								SetWarMap(27,46,1,0);
								SetWarMap(30,46,1,0);
								SetWarMap(28,40,1,1429*2);
								SetWarMap(29,40,1,1429*2);
								SetWarMap(30,40,1,1429*2);
							end
								local result=vs(0,33,43,JY.Da,25,43,500);
								--[[SetWarMap(27,47,1,1024*2);
								SetWarMap(28,47,1,0);
								SetWarMap(29,47,1,0);
								SetWarMap(30,47,1,1026*2);
								SetWarMap(27,46,1,1025*2);
								SetWarMap(30,46,1,1027*2);
								SetWarMap(28,40,1,0);
								SetWarMap(29,40,1,0);
								SetWarMap(30,40,1,0);]]--
							Cls();
							ShowScreen();
							if result then
								say("想不到师弟入门没几日，武功便已如此了得。",JY.Da);
							else
								say("师弟你还得多练哪，咱们下次再切磋吧。",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("师弟若是无事，来聊聊天或者切磋下武功也好啊。",JY.Da);
						end
					else
						say("我衡山派剑法变幻莫测，其中百变千幻云雾十三剑尤其精妙绝伦。",20);
					end
				end,
				[3]=function()	--掌门左边弟子-刘正风
					if JY.Person[0]["门派"]~=2 then	--非华山弟子
						say("少侠有事吗？",60);
					else
						--[[	if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
								say("为师这几天就要金盆洗手，退出江湖了，你有空就来帮帮忙吧。",JY.Da);
								say("是。");
								Dark();
								DayPass(5,-1);
								if GetFlag(12001)==2 then
									say("跟我来！",113);
									SetS(58,36,58,1,4228*2);
									JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=37,58,2;
									JY.MyPic=GetMyPic();
									script_say("主角：费师叔！");
									script_say("费彬：你且过来，有事要你来做。");
									script_say("主角：一切听从师叔安排。");
									script_say("费彬：很好，我需要你将刘正风的家小给我抓来。");
									script_say("主角：这……");
									script_say("费彬：怎么？事到如今，还想反悔不成？");
									script_say("主角：弟子不敢！弟子去了！");
									Dark();
										SetS(58,36,58,1,0);
										JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=14,32,2;
										JY.MyPic=GetMyPic();
										SetS(JY.SubScene,13,32,1,3679*2);
									Light();
									say("哈哈，得来全不费功夫。");
									SetS(JY.SubScene,13,32,1,0);
									say("去参加师傅金盆洗手吧。");
								else
									Light();
									say("今天师傅金盆洗手，我可别错过了时辰。");
								end
								SceneEvent[58][201]();
								return;
							end]]--
						say("参见师父！");
						say("有什么事吗？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							say("广陵散，广陵散……嵇康之后，此调绝矣。",JY.Da);
							if GetFlag(12008)<100 and Rnd(100)>50 then
								SetFlag(12008,GetFlag(12008)+1);
							end
						elseif r==2 then
							say("徒儿想学些什么？",JY.Da);
							local kflist={
												{31,10},
												{33,10,1},
												{37,10},
												{39,10},
												{40,10,2},
												};
							if GetFlag(12008)>5 then
								kflist[6]={84,10};
							end
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("徒儿你的修为还需磨练，去找你师兄们切磋吧。",JY.Da);
							else
								say("好，只管出招，让为师看看你的武功进境如何。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(28,28,1,1429*2);
									SetWarMap(29,28,1,1429*2);
									SetWarMap(30,28,1,1429*2);
									SetWarMap(23,23,1,903*2);
									SetWarMap(35,25,1,903*2);
								end
								local result=vs(0,28,20,JY.Da,26,13,2000);
								--[[SetWarMap(28,28,1,0);
								SetWarMap(29,28,1,0);
								SetWarMap(30,28,1,0);
								SetWarMap(23,23,1,0);
								SetWarMap(35,25,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("不错，大有进展。",JY.Da);
								else
									say("这几招应当如此这般……徒儿继续努力吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("你若是练功累了，可以学些曲乐，或有触类旁通之妙。",JY.Da);
						end
					end
				end,
				[4]=function()	--掌门右边弟子-鲁连荣
					if JY.Person[0]["门派"]~=2 then	--非华山弟子
						say("少侠有事吗？",60);
					else
						--[[	if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
								say("你师傅这几天J就要金盆洗手，你没什么事就去帮帮忙吧。",JY.Da);
								say("是。");
								Dark();
								DayPass(5,-1);
								if GetFlag(12001)==2 then
									say("跟我来！",113);
									SetS(58,36,58,1,4228*2);
									JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=37,58,2;
									JY.MyPic=GetMyPic();
									script_say("主角：费师叔！");
									script_say("费彬：你且过来，有事要你来做。");
									script_say("主角：一切听从师叔安排。");
									script_say("费彬：很好，我需要你将刘正风的家小给我抓来。");
									script_say("主角：这……");
									script_say("费彬：怎么？事到如今，还想反悔不成？");
									script_say("主角：弟子不敢！弟子去了！");
									Dark();
										SetS(58,36,58,1,0);
										JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=14,32,2;
										JY.MyPic=GetMyPic();
										SetS(JY.SubScene,13,32,1,3679*2);
									Light();
									say("哈哈，得来全不费功夫。");
									SetS(JY.SubScene,13,32,1,0);
									say("去参加师傅金盆洗手吧。");
								else
									Light();
									say("今天师傅金盆洗手，我可别错过了时辰。");
								end
								SceneEvent[58][201]();
								return;
							end]]--
						say("参见师叔！");
						say("有什么事吗？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							say("师叔我有些事情要静静想想，你先退下吧。",JY.Da);
						elseif r==2 then
							say("想学什么呢？",JY.Da);--JY.Person[0]["身份"]=5
							local kflist={
												{32,10},
												{34,10,1},
												{37,10},
												{38,10,2},
												{39,10},
												--{83,10},
												--{84,10},
												--{45,10},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("你的修为太浅，去找你师兄们切磋吧。",JY.Da);
							else
								say("好，只管出招吧，让师叔我看看你的武功进境如何。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(28,28,1,1429*2);
									SetWarMap(29,28,1,1429*2);
									SetWarMap(30,28,1,1429*2);
									SetWarMap(23,23,1,903*2);
									SetWarMap(35,25,1,903*2);
								end
								local result=vs(0,28,20,JY.Da,30,13,2000);
								--[[SetWarMap(28,28,1,0);
								SetWarMap(29,28,1,0);
								SetWarMap(30,28,1,0);
								SetWarMap(23,23,1,0);
								SetWarMap(35,25,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("不错，武功大有进步啊。",JY.Da);
								else
									say("师侄你这几招使得还行，继续努力吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("没事就去好好练功，不要四处闲逛。",JY.Da);
						end
					end
				end,
				[5]=function()	--掌门
					if JY.Person[0]["门派"]~=2 then	--非华山弟子
						say("何事？",49);
					else
						if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
							if GetFlag(12001)==1 then
								say("你师傅这几日就要金盆洗手，你无需参与门中杂事，专心保护刘门家眷即可。",49);
								say("是。");
								SmartWalk(14,32,1);
								Dark();
								DayPass(5,-1);
								script_say("嵩山弟子：快，抓住刘正风的家眷，别被人发现了。")
								say_2("哼，贼子休走！。")
								local r1=FIGHT(
											5,2,
											{
												0,13,32,
												-1,13,33,
												-1,13,34,
												-1,13,35,
												-1,13,36,
											},
											{
												132,16,32,
												134,16,34,
											},
											0,0
											);
							--Light()
								if r1 then
									say("去参加师傅金盆洗手大会吧。");
								else
									JY.Status=GAME_END;
									return;
								end
							else
								say("你师傅这几日就要金盆洗手，你没什么事就去帮帮忙吧。",49);
								say("是。");
								Dark();
								DayPass(5,-1);
								if GetFlag(12001)==2 then
									say("跟我来！",113);
									SetS(58,36,58,1,4228*2);
									JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=37,58,2;
									JY.MyPic=GetMyPic();
									script_say("主角：费师叔！");
									script_say("费彬：你且过来，有事要你来做。");
									script_say("主角：一切听从师叔安排。");
									script_say("费彬：很好，我需要你将刘正风的家小给我抓来。");
									script_say("主角：这……");
									script_say("费彬：怎么？事到如今，还想反悔不成？");
									script_say("主角：弟子不敢！弟子去了！");
									Dark();
										SetS(58,36,58,1,0);
										JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=14,32,2;
										JY.MyPic=GetMyPic();
										SetS(JY.SubScene,13,32,1,3679*2);
									Light();
									say("哈哈，得来全不费功夫。");
									local flag=0;
									for i=2,CC.TeamNum do
										local ppid=JY.Base["队伍"..i];
										if ppid>0 and JY.Person[ppid]["门派"]==2 then
											flag=flag+1;
											e[flag]=ppid;
										end
									end
									if flag>0 then
										local maxp=e[1];
										for i=2,flag do
											if JY.Person[e[i]]["身份"]>JY.Person[maxp]["身份"] then
												maxp=e[i];
											elseif JY.Person[e[i]]["身份"]==JY.Person[maxp]["身份"] then
												if JY.Person[e[i]]["等级"]>JY.Person[maxp]["等级"] then
													maxp=e[i];
												end
											end
										end
										Dark();
											say("贼子好大胆！",maxp);
										Light();
										say("你要做什么！");
										say("枉我和你相交一场，想不到你却暗中勾结嵩山派，要暗害师傅，贼子受死吧！",maxp);
										local r2=FIGHT(
													5,flag,
													{
														0,13,32,
														-1,13,33,
														-1,13,34,
														-1,13,35,
														-1,13,36,
													},
													{
														e[1],16,32,
														e[2],16,34,
														e[3],16,36,
														e[4],16,38,
														e[5],17,31,
														e[6],17,33,
														e[7],17,35,
														e[8],17,37,
														e[9],15,31,
														e[10],15,33,
														e[11],15,35,
														e[12],15,37,
														e[13],14,36,
														e[14],14,34,
													},
													0,0
													);
									end
									SetS(JY.SubScene,13,32,1,0);
									say("去参加师傅金盆洗手吧。");
								else
									Light();
									say("今天师傅金盆洗手，我可别错过了时辰。");
								end
							end
							SceneEvent[58][201]();
							return;
						end
						say("参见师伯！");
						say("何事？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,0},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						if GetFlag(12005)==3 then
							menu[2][3]=1;
						end
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("你平日若是有暇，不妨也学些曲乐。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							say("想学什么？",JY.Da);
							local kflist={
												{33,10,1},
												{35,10,2},
												{38,10,2},
												{40,10,2},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("不。",JY.Da);
							else
								say("幽幽咽咽冷冷，淒淒慘慘哀哀。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(28,28,1,1429*2);
									SetWarMap(29,28,1,1429*2);
									SetWarMap(30,28,1,1429*2);
									SetWarMap(23,23,1,903*2);
									SetWarMap(35,25,1,903*2);
								end
								local result=vs(0,28,20,JY.Da,28,13,2000);
								--[[SetWarMap(28,28,1,0);
								SetWarMap(29,28,1,0);
								SetWarMap(30,28,1,0);
								SetWarMap(23,23,1,0);
								SetWarMap(35,25,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("不错。",JY.Da);
								else
									say("再练。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							--say("你若是无事，来品一品师伯这首《潇湘夜雨》吧。",JY.Da);
						end
					end
				end,
				[6]=function()	--书架
					if JY.Person[0]["门派"]==2 then
						say("这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[7]=function()	--练功场
					if JY.Person[0]["门派"]~=2 then
						say("此处是我衡山派练功之处，还请速速离开。",60);
					else
						say("师弟是来练功的吗？",JY.Da);
						E_training(JY.Da);
					end
				end,
				[8]=function()	--厨房
					if JY.Person[0]["门派"]~=2 then	--非衡山弟子
						say("这里是厨房，没什么好看的。",60);
					elseif JY.Da>0 then
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							say("等我有空了再聊吧，忙死了。",JY.Da);
						elseif r==2 then
							say("这里是厨房，你别添乱了，去找别的师兄弟切磋去吧",JY.Da);
						elseif r==3 then
							PersonStatus(JY.Da);
						elseif r==4 then
							say("没事就赶紧出去吧。",JY.Da);
						end
					else
						say("你别站这里好不好，影响我做菜的心情。",60);
					end
				end,
				[9]=function()	--休息
					if JY.Person[0]["门派"]==2 then
						local menuItem=	{
														{"休息",nil,1},
														{"拜访",nil,1},
														{"没事",nil,2},
													}
						local r=EasyMenu(menuItem);
						if r==1 then
							if rest() then
								say("早睡早起，方能养生……为什么我觉得这句很熟悉……。");
							end
						elseif r==2 then
							visit(2);
						end
					else
						visit(2);
					end
					walkto_old(-3,0);
				end,
				[201]=function()	--金盆洗手
					--前半段,寒暄
					if JY.Person[0]["门派"]==0 then
						say("诸位师兄，在下乃华山弟子，奉师命来此恭贺刘师叔金盆洗手。");
						say("原来是华山少侠，快快有请。对了，尊师岳掌门已在内堂观礼。",JY.Da);
					elseif JY.Person[0]["门派"]==1 then
						say("诸位师兄，在下乃青城弟子，奉师命来此恭贺刘师叔金盆洗手。");
						say("原来是青城少侠，快快有请。对了，尊师余道长已在内堂观礼。",JY.Da);
					--elseif JY.Person[0]["门派"]==2 then
					elseif JY.Person[0]["门派"]==3 then
						say("诸位师兄，在下乃泰山弟子，奉师命来此恭贺刘师叔金盆洗手。");
						say("原来是泰山少侠，快快有请。对了，尊师天门师伯已在内堂观礼。",JY.Da);
					elseif JY.Person[0]["门派"]==4 then
						--恒山
						--say("诸位师兄，在下乃华山弟子，奉师命来此恭贺刘师叔金盆洗手。");
						--say("原来是华山少侠，快快有请。对了，尊师岳掌门已在内堂观礼。",JY.Da);
					elseif JY.Person[0]["门派"]==5 then
						--嵩山
						say("诸位师兄，在下乃嵩山弟子，奉师命来此恭贺刘师叔金盆洗手。");
						say("原来是嵩山少侠，快快有请。只是不知贵派其他师伯师兄怎么还没有到？",JY.Da);
						say("在下奉师命先行一步，费师叔稍后便到。");
						say("原来如此，还望费师叔早些到才好。再下便先领师兄去内堂见过众位掌门吧。",JY.Da);
						say("不必，师弟你继续迎接其他宾客吧。在下久闻衡山衡山大名，也想随处走走，看看这云横天柱雁回祝融。");
						say("如此，师兄请便。",JY.Da);
						Dark();
							say("哼，今日刘正风金盆洗手，衡山派中江湖人物甚多，正好乘人多眼杂，去把刘正风的小崽子抓来。");
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=14,32,2;
							JY.MyPic=GetMyPic();
							SetS(JY.SubScene,13,32,1,3679*2);
						Light();
						say("哈哈，得来全不费功夫。");
						say("现在去看看刘正风金盆洗手吧。");
						SetS(JY.SubScene,13,32,1,0);
					end
					if JY.Person[0]["门派"]~=5 and JY.Person[0]["门派"]~=2 then
						say("有劳师兄领我前去内堂。");
						say("不敢，这边请。",JY.Da);
					end
					Dark();
						--莫大等人移走
						ModifyD(58,9,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,2);
						ModifyD(58,10,-2,-2,-2,-2,-2,-2,-2,-2,-2,28,2);
						ModifyD(58,11,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,2);
						ModifyD(58,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,26,3);
						ModifyD(58,13,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,3);
						--刘正风+五岳众人登场
						--SetS(JY.SubScene,28,13,1,5188);	--刘
						SetS(JY.SubScene,24,16,1,2979*2);	--岳
						SetS(JY.SubScene,24,15,1,4261*2);
						SetS(JY.SubScene,24,17,1,2589*2);
						SetS(JY.SubScene,24,20,1,4239*2);	--定
						SetS(JY.SubScene,24,19,1,2597*2);
						SetS(JY.SubScene,24,21,1,2597*2);
						SetS(JY.SubScene,33,16,1,2986*2);	--天门
						SetS(JY.SubScene,33,15,1,2588*2);
						SetS(JY.SubScene,33,17,1,2588*2);
						SetS(JY.SubScene,33,20,1,2966*2);	--余
						SetS(JY.SubScene,33,19,1,3022*2);
						SetS(JY.SubScene,33,21,1,3022*2);
						if JY.Person[0]["门派"]==0 then
							SetS(JY.SubScene,24,17,1,0);
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=24,17,1;
						elseif JY.Person[0]["门派"]==1 then
							SetS(JY.SubScene,33,21,1,0);
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=33,21,2;
						elseif JY.Person[0]["门派"]==2 then
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=30,14,3;
						elseif JY.Person[0]["门派"]==3 then
							SetS(JY.SubScene,33,17,1,0);
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=33,17,2;
						elseif JY.Person[0]["门派"]==4 then
							SetS(JY.SubScene,24,21,1,0);
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=24,21,1;
						elseif JY.Person[0]["门派"]==5 then
							JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=33,22,2;
						elseif JY.Person[0]["门派"]==6 then
							
						else
						end
						JY.MyPic=GetMyPic();
					Light();
					if JY.Person[0]["门派"]==5 or JY.Person[0]["门派"]==2 then
						say("弟子"..JY.Person[0]["姓名"].."参见众位师叔");
						say("免礼。",1);
					elseif JY.Person[0]["门派"]==0 then
						say("弟子参见师父。");
						say("免礼，退下吧。",1);
					elseif JY.Person[0]["门派"]==1 then
						say("弟子参见师父。");
						say("免礼，退下吧。",27);
					elseif JY.Person[0]["门派"]==3 then
						say("弟子参见师父。");
						say("免礼，退下吧。",66);
					end
					if GetFlag(10004)==1 and JY.Person[0]["门派"]==0 then	--回雁楼发生
						say("岳师兄，此子当真是你徒弟？",66);
						say("日前他上我华山拜山而入，我观其根骨尚可，便收入门墙。不知天门道兄何有此问？",1);
						say("岳师兄为人谦谦君子，想来不曾理会小人思想。只是看来，你门下弟子并非都如你一般君子度人啊。",66);
						say("师父！我……");
						say("放肆！为师与你天门师伯说话，你怎可插嘴！天门道兄，在下几个徒儿虽然顽劣，但在在下看来并无小人，不知天门道人此言……",1);
						say("哼！你这好徒儿，那日……对了，还有一人，名唤令狐冲，可也是你门下？",66);
						say("劣子添为在下首徒。",1);
						say("原来这倒不曾作假。那日在长安回雁楼，我门下天松见到此子与那令狐，竟与江湖匪类田伯光同坐一席，旁边还有一恒山弟子，听闻是被那淫贼挟持。此二子不看在我五岳剑派，同气连枝的份上，救那恒山弟子，居然还与那淫贼称兄道弟，共饮一壶，哼哼！当真好不威风啊！",66);
						say("真有此事？孽畜！跪下！",1);
						say("师父，我们那是……");
						say("休得狡辩！把华山七戒给我背一遍！",1);
						say("是……本派首戒欺师灭祖，不敬尊长。二戒恃强欺弱，擅伤无辜。三戒奸淫好色，调戏妇女。四戒同门嫉妒，自相残杀。五戒见利忘义，偷窃财物。六戒骄傲自大，得罪同道。七戒滥交匪类，勾结妖邪。");
						say("很好啊！既然你都记得，那也不算是冤死了。今日我便清理门户，毙了你这逆徒！",1);
						say("师父！我……");
						Dark();
						say("请岳师伯剑下留情！",95);
					else
						say("岳师兄，你为人谦谦君子，想来不曾理会小人思想。只是看来，你门下弟子并非都如你一般君子度人啊。",66);
						say("天门道兄，在下几个徒儿虽然顽劣，但在在下看来并无小人，不知此言……",1);
						say("哼！有一人，名唤令狐冲，可是你门下？",66);
						say("劣子添为在下首徒。",1);
						say("原来这倒不曾作假。那日在长安回雁楼，我门下天松见到那令狐冲，竟与江湖匪类田伯光同坐一席，旁边还有一恒山弟子，听闻是被那淫贼挟持。此子不看在我五岳剑派，同气连枝的份上，救那恒山弟子，居然还与那淫贼称兄道弟，共饮一壶，哼哼！当真好不威风啊！",66);
						if JY.Person[0]["门派"]==1 then
							script_say("主角：当时在下在场，天松道长所言非虚。")
						end
						say("真有此事？！孽畜，居然做出如此之事！饶他不得！",1);
						Dark();
						say("不是这样的！",95);
					end
					SetS(JY.SubScene,27,22,1,2599*2);
					Light();
					say("你是？",1);
					say("仪琳！你没事？",88);
					say("是的，师伯。我没事。多亏了这位师兄以及令狐大哥的救助，我才可以脱险的。",95);
					say("事情的经过究竟是怎样的，你速速道来。",88);
					say("是，师伯。",95);
					DrawStrBoxWaitKey("仪琳将回雁楼的经过一一道出",C_WHITE,CC.Fontbig);
					say("哦？此话当真。",1);
					say("当着各位师叔伯的面，佛祖在上，弟子不敢诳语。",95);
					say("那不知我那劣徒现在人在何处？",1);
					say("当日令狐大哥神受重伤，在比武之后发作昏迷，弟子只好将他扶至一安全之处，帮他疗伤。刚刚弟子上街听闻师父已到刘府，就先赶来拜见师父了。",95);
					if true and JY.Person[0]["门派"]==0 then	--回雁楼发生
						say("既是如此，想来是我错怪了你们。起来吧。",1);
						say("谢师父。");
					else
						say("既是如此，想来是我错怪了他。",1);
					end
					say("岳师兄，因我听信一片之言，造成令徒声誉受损，实属不该，还望见谅。",66);
					say("不敢不敢。天门师兄嫉恶如仇，有此反应，想来也是因我五岳剑派，同气连枝，恨其不争，恐我华山之名毁于一旦。此番拳拳为我华山之心，岳某感谢都来不及，何敢言怪？",1);
					say("岳师兄客气了。",66);
					say("哼！好一副和谐的同盟之谊啊！哼！",27);
					say("余观主这是……",1);
					say("你那徒弟，三番两次找我青城派弟子的麻烦，更是在回雁楼行卑鄙手段，杀我弟子。怎么，还不许我说了？",27);
					say("余观主稍安勿躁。华山青城素无恶交，想来此番事情，其中另有缘由，若因误会造成你我两派不合，怕是只会让亲者恨，仇者快啊。",88);
					if JY.Person[0]["门派"]==1 then
						script_say("主角：误会？令狐冲杀我师兄你们就用一句误会了事？好一个五岳剑派啊！好一个同气连枝啊！");
					else
						say("误会？令狐冲杀我弟子你们就用一句误会了事？好一个五岳剑派啊！好一个同气连枝啊！",27);
					end
					say("不是的。令狐大哥之所以杀那位青城的师兄，是因为他趁令狐大哥身受重伤，想要趁机报仇。令狐大哥没法，才杀了他的。",95);
					say("余观主，你看这……",1);
					if JY.Person[0]["门派"]==1 then
						script_say("主角：哼！你们五岳剑派，同气连枝。你们说是什么，就是什么。")
						script_say("余沧海：不得无礼。我小小青城一观，怎敢对五岳大派多做言语？否则，说不定连我也只能使出那只有华山弟子才会的青城绝学了。")
					else
						say("哼！你们五岳剑派，同气连枝。我小小青城一观，怎敢再做多言。否则，说不定连我也只能使出那只有华山弟子才会的青城绝学了。",27);
					end
					say("恕在下不明白余观主此言。",1);
					say("哼！不就是你们华山上下一脉相承的……",27);
					Dark();
						SetS(JY.SubScene,29,22,1,4479*2);
						say("屁股向后，平沙落雁式。",8);
					Light();
					if JY.Person[0]["门派"]==0 then
						say("大师兄！");
					end
					say("令狐大哥！",95);
					say("弟子令狐冲，拜见师父，以及各位师伯师叔。",8);
					say("冲儿，你的伤？",1);
					say("回师父，弟子的伤已经好了。对了，定闲师伯，多谢恒山灵丹妙药，不然弟子也不可能恢复的如此之快。",8);
					say("不必。说起来，贫尼还要谢谢你救我弟子呢。",88);
					say("我们五岳剑派同气连枝，见到师妹有难，自然不能不管。",8);
					say("哼！",27);
					say("对了，余观主，刚刚你说错了一点，这屁股向后，平沙落雁式，可一直都是青城派的绝学啊。至少我华山弟子，是使不出来的。",8);
					say("你！",27);
					say("对了，余观主。岳某不日前新收一弟子，听闻他父母乃在松风观里做客。本不该打扰余观主待客的，可惜小徒思亲至极，固斗胆望余观主能成人之美，让其一家共享天伦。",1);
					say("哼！我不知道什么有什么人在我松风观里。岳掌门，你怕是被某些小人给诳了吧。",27);
					say("你胡说！我爹娘明明就是被你青城派的人给抓走了！你们还灭我福威镖局全家！",136);
					say("小徒一时气愤，或许言语之中有所夸张，还望余观主见谅。但去其九分，想那父母之言，不曾作假，还望余观主高抬贵手。",1);
					say("我说不在便是不在！",27);
					say("瞧他那样，多半已是被其……",8);
					say("！！！余沧海！我跟你拼了！！！",136);
					say("竖子放肆！",27);
					Dark();
						SetS(JY.SubScene,28,13,1,5188);	--刘
						SetS(JY.SubScene,27,22,1,0);
						SetS(JY.SubScene,29,22,1,0);
						SetS(JY.SubScene,24,14,1,4224*2);
						say("各位各位，请听刘某一言。",50);
					Light();
					say("今日是不才在下金盆洗手之日，还望各位看在在下的薄面上，将各自的恩怨暂且放下。",50);
					say("是岳某失礼了。冲儿，平之，还不给余观主道歉？",1);
					say("是师父。余观主，多有得罪，抱歉了。",8);
					say("……得罪。",136);
					say("哼！",27);
					say("多谢各位承情。眼下时刻将近，虽然嵩山的各位师兄还没到，但是恐怕也等不得了。",50);
					say("各位！各位！承蒙各位英雄看得起，来到我这小小的弹丸之地来观我洗手之礼。刘某不胜感激！刘某决定，今日之后，再不参与江湖之事，就此隐居，与好友谈谈音乐，与家人共享天伦！",50);
					--洗手 后半段
					Dark();
						SetS(JY.SubScene,28,15,1,2603*2);
						SetS(JY.SubScene,31,17,1,2603*2);
						SetS(JY.SubScene,31,19,1,2603*2);
						SetS(JY.SubScene,31,21,1,2603*2);
						SetS(JY.SubScene,26,17,1,2603*2);
						SetS(JY.SubScene,26,19,1,2603*2);
						SetS(JY.SubScene,26,21,1,2603*2);
						SetS(JY.SubScene,28,27,1,2603*2);
						SetS(JY.SubScene,29,27,1,2603*2);
						SetS(JY.SubScene,23,23,1,2601*2);
						SetS(JY.SubScene,35,25,1,2604*2);
						say("且慢！五岳令旗到！",113);
					Light();
					say("左盟主有令，请刘正风暂缓洗手，请接旗！",113);
					say("这……洗手之事，在下早已知会过左盟主了，一直没有得到回应，何故今日突然以五岳令旗阻止在下呢？",50);
					say("个中缘由，稍后自会解说。",113);
					if GetFlag(12001)==2 then
						say("小子，我吩咐你的事，可曾办好？",113);
						say("............");
						say("............",50);
						say("哈哈哈哈！小子还不过来更待何时！",113);
						JY.Person[0]["门派"]=5;
					end
					if JY.Person[0]["门派"]==5 then
						SmartWalk(29,15,2);
						say("（私语）师叔，刚刚已经............");
						say("知道了，你做的很好。",113);
						if GetFlag(12001)==2 then
							say("我看你今后也没办法在衡山立足了，此事一了，就随我回嵩山吧。",113);
							say("............");
									JY.Person[0]["门派"]=5;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ嵩山派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="嵩山弟子";
						end
					else
						Dark();
							SetS(JY.SubScene,29,15,1,2604*2);
						Light();
						say("（私语）师叔，刚刚已经............",123);
						say("知道了，你下去吧。",113);
						Dark();
							SetS(JY.SubScene,29,15,1,0);
						Light();
					end
					say("嗯。左盟主有令，刘正风私通魔教，凡我五岳剑派同盟，见到其立刻拿下！",113);
					say("你！",50);
					say("私通魔教？这……这不太可能吧？ ",66);
					say("此事还是说清楚为好，免得误会了，伤了我五岳剑派之间的和气。",88);
					say("不知左师兄可有证据？这空口无凭的，莫不是误信谗言？",1);
					say("自然不是毫无证据。请各位稍等。",113);
					if GetFlag(12001)==1 then
					
						script_say("主角：费师叔，如果你是在等内堂的那些嵩山弟子的话，我怕你是等不到了。");
						script_say("费彬：！！！你！！！");
						script_say("主角：你嵩山派何等居心，居然准备挟持我师父的家属来逼我师父就范！");
						script_say("费彬：休得信口雌黄！小儿看掌！");

					else
						Dark();
							SetS(JY.SubScene,28,15,1,5002*2);
							SetS(JY.SubScene,28,14,1,3679*2);
						Light();
						say("费师兄，你这是何意？",50);
						say("没有什么其他的意思。只是希望刘师兄能够老老实实回答我一个问题而已。你，认不认识魔教长老曲洋？",113);
						say("……曲大哥已经答应我不再参与魔教之事了，你们又何苦如此相逼呢？",50);
						say("魔教中人，出尔反尔丝毫不出奇。刘师兄，左盟主说了，只要杀了曲洋，一切都既往不咎。",113);
						say("……",50);
						say("刘师弟，你只需要点一点头，岳某代替你料理了那个魔头。",1);
						say("……多谢岳师兄好意。只是人生在世，知己难求。而且曲大哥对我有情有义，我不能出卖他。",50);
						say("既是如此，那就休怪我无情了。动手！",113);
						SetS(JY.SubScene,28,14,1,0);
						lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_RED,128);
						ShowScreen();
						lib.Delay(80);
						lib.ShowSlow(50,1);
						DrawStrBoxWaitKey("嵩山弟子将刘府众人杀死",C_WHITE,CC.Fontbig);
						say("你！我跟你拼了！",50);
						say("来得好！",113);
					end
					ModifyWarMap=function()
									SetWarMap(24,14,1,0);
									SetWarMap(24,15,1,0);
									SetWarMap(24,16,1,0);
									SetWarMap(24,17,1,0);
									SetWarMap(24,19,1,0);
									SetWarMap(24,20,1,0);
									SetWarMap(24,21,1,0);
									SetWarMap(33,15,1,0);
									SetWarMap(33,16,1,0);
									SetWarMap(33,17,1,0);
									SetWarMap(33,19,1,0);
									SetWarMap(33,20,1,0);
									SetWarMap(33,21,1,0);
									
									SetWarMap(28,13,1,0);
									SetWarMap(28,15,1,0);
									SetWarMap(31,17,1,0);
									SetWarMap(31,19,1,0);
									SetWarMap(31,21,1,0);
									SetWarMap(26,17,1,0);
									SetWarMap(26,19,1,0);
									SetWarMap(26,21,1,0);
									SetWarMap(28,27,1,0);
									SetWarMap(29,27,1,0);
									SetWarMap(23,23,1,0);
									SetWarMap(35,25,1,0);
					end
					local r=FIGHT(
										1,11,
										{
											50,28,13,
										},
										{
											113,28,15,
											120,31,17,
											123,31,19,
											125,31,21,
											121,26,17,
											124,26,19,
											126,26,21,
											127,28,27,
											128,29,27,
											129,23,23,
											122,35,25,
										},
										0,0,3
									);
					if r then
						if JY.Person[0]["门派"]==5 then
							JY.Status=GAME_END;
							return;
						end
						Dark();
							SetS(JY.SubScene,31,17,1,0);
							SetS(JY.SubScene,31,19,1,0);
							SetS(JY.SubScene,31,21,1,0);
							SetS(JY.SubScene,26,17,1,0);
							SetS(JY.SubScene,26,19,1,0);
							SetS(JY.SubScene,26,21,1,0);
							SetS(JY.SubScene,28,27,1,0);
							SetS(JY.SubScene,29,27,1,0);
							SetS(JY.SubScene,23,23,1,0);
							SetS(JY.SubScene,35,25,1,0);
						Light();
						say("想不到你刘门弟子中高手不少啊。",113);
						say("五岳剑派弟子听令！刘正风勾结魔教，凡我五岳中人，俱得出力，捉拿刘正风！",113);
						say("这......",1);
						Dark();
							SetS(JY.SubScene,28,14,1,6208*2);
							say("衡山之人，自然由衡山掌门来定夺。",49);
						Light();
						say("哼！莫师兄的意思，看来是硬要保下他了？",113);
						say("……",49);
						JY.Person[49]["攻击"]=JY.Person[49]["攻击"]+30;
						JY.Person[49]["身法"]=JY.Person[49]["身法"]+30;
						ModifyWarMap=function()
									SetWarMap(28,14,1,0);
									SetWarMap(24,14,1,0);
									SetWarMap(24,15,1,0);
									SetWarMap(24,16,1,0);
									SetWarMap(24,17,1,0);
									SetWarMap(24,19,1,0);
									SetWarMap(24,20,1,0);
									SetWarMap(24,21,1,0);
									SetWarMap(33,15,1,0);
									SetWarMap(33,16,1,0);
									SetWarMap(33,17,1,0);
									SetWarMap(33,19,1,0);
									SetWarMap(33,20,1,0);
									SetWarMap(33,21,1,0);
									
									SetWarMap(28,13,1,0);
									SetWarMap(28,15,1,0);
									SetWarMap(31,17,1,0);
									SetWarMap(31,19,1,0);
									SetWarMap(31,21,1,0);
									SetWarMap(26,17,1,0);
									SetWarMap(26,19,1,0);
									SetWarMap(26,21,1,0);
									SetWarMap(28,27,1,0);
									SetWarMap(29,27,1,0);
									SetWarMap(23,23,1,0);
									SetWarMap(35,25,1,0);
						end
						vs(113,28,15,49,28,14,0);
						JY.Person[49]["攻击"]=JY.Person[49]["攻击"]-30;
						JY.Person[49]["身法"]=JY.Person[49]["身法"]-30;
						SetS(JY.SubScene,28,15,1,0);
						Cls();
						lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_RED,128);
						ShowScreen();
						lib.Delay(80);
						lib.ShowSlow(50,1);
						say("左……左师兄不会……放过你们的……",113);
						say("……",113);
						say("阿弥陀佛……",88);
						say("莫师兄，这……",1);
						if JY.Person[0]["门派"]==2 then
							say("各位师叔伯，各位兄弟。今有江湖宵小，欲趁我师父洗手之时，对其亲属不轨。虽是被我掌门师伯当场击毙，但仍然搅了各位的兴致，我代表衡山弟子，向各位道一声抱歉了。");
						else
							say("各位师叔伯，各位兄弟。今有江湖宵小，欲趁我师父洗手之时，对其亲属不轨。虽是被我掌门师伯当场击毙，但仍然搅了各位的兴致，我代表衡山弟子，向各位道一声抱歉了。",52);
						end
						say("这……",66);
						say("阿弥陀佛。罗汉怒亦伏虎，不怪，不怪。",88);
						say("正是如此。祸不及家人，宵小之辈连此等江湖公理都不知晓，若不是被莫师兄击毙，不知以后还要害及多少人。只是，刘师弟他……",1);
						say("……师兄，是我对不起你，对不起衡山……",50);
						say("……你可知罪？",49);
						say("……弟子乃衡山罪人，罪大于天。",50);
						say("你既知罪，那自该当罚。",49);
						say("弟子认罚，请师兄发落。",50);
						say("……凡我衡山弟子听着，从今以后，刘正风不再是我衡山弟子，我今日将他逐出师门，他的一切不再于我衡山有任何瓜葛！",49);
						say("（！！！这！！！）");
						say("！！！谢……谢师兄恩典！！！",50);
						say("善哉善哉。",88);
						say("如此甚好！如此甚好啊！",66);
						say("莫师兄处处高人一步，岳某佩服。",1);
						say("……凡刘正风门下，可自随他去，我不阻拦。亦可继续留于衡山。",49);
						if JY.Person[0]["门派"]==2 then
							say("（世人都只道掌门师伯与师父不合，没想到掌门师伯为了师父居然做到如斯地步啊。）");
							say("你。",49);
							say("弟子在！");
							say("很不错。可愿入我门下？",49);
							say("！！！");
							say("还……还不叩谢师……莫大掌门恩典！",50);
							say("弟子……拜见师父！");
						end
						Dark();
							SetS(JY.SubScene,28,14,1,0);
						Light();
						say("府上事多，不便打扰，岳某就此告辞了。",1);
						say("多谢岳……掌门，只是多有不便，恕不远送。",50);
						say("贫尼也当回山了。",88);
						say("师太保重。",50);
						say("刘……你多保重。",66);
						say("多谢，告辞。",50);
						Dark();
							SetS(JY.SubScene,24,14,1,0);
							SetS(JY.SubScene,24,16,1,0);	--岳
							SetS(JY.SubScene,24,15,1,0);
							SetS(JY.SubScene,24,17,1,0);
							SetS(JY.SubScene,24,20,1,0);	--定
							SetS(JY.SubScene,24,19,1,0);
							SetS(JY.SubScene,24,21,1,0);
							SetS(JY.SubScene,33,16,1,0);	--天门
							SetS(JY.SubScene,33,15,1,0);
							SetS(JY.SubScene,33,17,1,0);
							SetS(JY.SubScene,33,20,1,0);	--余
							SetS(JY.SubScene,33,19,1,0);
							SetS(JY.SubScene,33,21,1,0);
						if JY.Person[0]["门派"]==2 then
							Light();
							say("师父……");
							say("不可如此。你我师徒缘分已尽，为师……我，也没有什么好送你的，这是我和曲大哥合作的一首曲谱，希望你以后能够找到可以将它演奏出来的人。",50);
							say("多谢师……多谢。我以后有空，会来看望师……你的。");
							say("有心便好。",50);
							Dark();
						end
						say("师父……");
							SetS(JY.SubScene,28,13,1,0);
							ModifyD(58,9,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,12);
							ModifyD(58,10,-2,-2,-2,-2,-2,-2,-2,-2,-2,28,12);
							ModifyD(58,11,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,12);
							--ModifyD(58,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,26,3);
							ModifyD(58,13,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,13);
						Light();
						SetFlag(12005,3);
						SetFlag(12006,2);
					else
						say("纳命来吧！",113);
						Dark();
							say("走！",150);
							SetS(JY.SubScene,28,13,1,0);
						Light();
						say("贼子休走！",113);
						Dark();
							SetS(JY.SubScene,28,15,1,0);
						Light();
						say("这……这该如何是好？",66);
						say("想来他们也走不远，不如我们各遣门下弟子，去寻找一番如何？",1);
						say("只好如此了。",88);
						script_say("余沧海：此乃你们五岳家事，我青城无意插手，就此告辞！");
						--Dark();
						
						if JY.Person[0]["门派"]==1 then
							script_say("主角：师父，我看那令狐冲一个人往那边去了，我想……");
							script_say("余沧海：我们回观，你可自行四处游历，与人切磋，多长见识。");
							script_say("主角：谢师父成全！");
						elseif JY.Person[0]["门派"]==5 then
							say("这里毕竟是衡山派所在，师叔单身一人，未免危险，得赶紧去帮忙啊。");
							--Dark();
								JY.Base["人X1"],JY.Base["人Y1"],JY.Base["人方向"]=30,50,3;
								JY.MyPic=GetMyPic();
							--Light();
						end
						Dark();
							SetS(JY.SubScene,31,17,1,0);
							SetS(JY.SubScene,31,19,1,0);
							SetS(JY.SubScene,31,21,1,0);
							SetS(JY.SubScene,26,17,1,0);
							SetS(JY.SubScene,26,19,1,0);
							SetS(JY.SubScene,26,21,1,0);
							SetS(JY.SubScene,28,27,1,0);
							SetS(JY.SubScene,29,27,1,0);
							SetS(JY.SubScene,23,23,1,0);
							SetS(JY.SubScene,35,25,1,0);
							SetS(JY.SubScene,24,14,1,0);
							SetS(JY.SubScene,24,16,1,0);	--岳
							SetS(JY.SubScene,24,15,1,0);
							SetS(JY.SubScene,24,17,1,0);
							SetS(JY.SubScene,24,20,1,0);	--定
							SetS(JY.SubScene,24,19,1,0);
							SetS(JY.SubScene,24,21,1,0);
							SetS(JY.SubScene,33,16,1,0);	--天门
							SetS(JY.SubScene,33,15,1,0);
							SetS(JY.SubScene,33,17,1,0);
							SetS(JY.SubScene,33,20,1,0);	--余
							SetS(JY.SubScene,33,19,1,0);
							SetS(JY.SubScene,33,21,1,0);		
							ModifyD(58,9,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,12);
							ModifyD(58,10,-2,-2,-2,-2,-2,-2,-2,-2,-2,28,12);
							ModifyD(58,11,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,12);
							--ModifyD(58,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,26,3);
							ModifyD(58,13,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,13);				
						Light();
						SetFlag(12005,2);
					end
					JY.Person[50]["门派"]=-1;
					SetS(58,48,55,3,202);
					SetS(58,49,55,3,202);
				end,
				[202]=function()
					if JY.Person[0]["福缘"]>75 and (JY.Person[0]["门派"]==0 or JY.Person[0]["门派"]==1) then
						SetFlag(16004,GetFlag(1));	--记录林震南死亡时间
						--SetS(57,27,29,3,201);	--开启华山·平之拜师·令狐面壁事件
						say("嗯，哪里传来的人声？我且过去看看。");
						JY.SubScene=62;
						lib.ShowSlow(50,1);
						JY.Base["人X1"],JY.Base["人Y1"]=44,25;
						JY.Base["人方向"]=2;
						SetS(JY.SubScene,17,18,1,3512*2);
						SetS(JY.SubScene,18,18,1,4425*2);
						Init_SMap(1);
						
						if JY.Person[0]["门派"]==1 then
							SetFlag(16003,2);
							MoveSceneTo(21,19);
							script_say("主角：（那是！看来今天老天爷还是站在我这边的。我且听听他们在说什么。）");
							Dark();
							JY.SubSceneX,JY.SubSceneY=0,0;
							Light();
--（主角偷听中）
							SmartWalk(19,15,3);
							script_say("林震南：夫人，此处想来也并不安全，我们还是快些离去吧。");
							script_say("林夫人：可是平之他……");
							script_say("林震南：听说他拜入了华山君子剑岳掌门的门下，你还有什么好担心的呢？");
							script_say("林夫人：可是我……");
							script_say("林震南：好了，别再磨蹭了。想来青城派的人已经离开福州了，我们这个时候杀回去，把向阳巷老宅的“东西”取出来。");
							script_say("林夫人：平之……");
							script_say("主角：（向阳巷老宅！可是我们搜遍了也不曾找到那《辟邪剑谱》啊，难道有机关暗室一说？不行，我得再逼问清楚！）");
--（主角冲出去）
							Dark();
							JY.Base["人X1"],JY.Base["人Y1"]=18,21;
							JY.Base["人方向"]=0;
							JY.MyPic=GetMyPic();
							Light();
							script_say("主角：林总镖头，请留步。");
							script_say("林震南：可恶，被追上了！夫人！你快走，我来挡他一挡！");
							script_say("主角：不自量力！");
--（白光一闪，林震南倒地）
							ScreenFlash(C_WHITE);
							script_say("林夫人：老爷！");
							script_say("主角：放心，他还没死，不过，为了能问出小爷我想知道的答案，夫人，你必须死。");
							ScreenFlash(C_WHITE);
							script_say("林震南：夫人！");
--（白光一闪，林夫人倒地）
							script_say("主角：林总镖头，尊夫人只是受伤了而已。但是若不及时就医止血，恐怕会血流尽而亡。只要你肯乖乖的回答我一个问题，我就放你们离去，如何？");
							script_say("林震南：我死也不会告诉你《辟邪剑谱》的下落的！");
							script_say("主角：好，那我也不问这个。我只问你，福州向阳巷老宅，哪里可以藏东西？");
							script_say("林震南：你！你！你偷听到了！");
							script_say("主角：我可不是故意的，是你说的声音大了一点。好了，别磨蹭了，快说！");
							script_say("林震南：……");
							script_say("主角：不说？那就只好请尊夫人帮忙劝劝你了！");
							Dark();
--（画外音）
							script_say("令狐冲：住手！");
							SetS(JY.SubScene,20,20,1,4256*2);
							Light();
--（令狐冲出现）
							script_say("主角：格老子的！又是你！给老子死来！");
							ModifyWarMap=function()
								SetWarMap(17,18,1,0);
								SetWarMap(18,18,1,0);
								SetWarMap(20,20,1,0);
								SetWarMap(22,23,1,851*2);
							end
							if not vs(0,18,18,8,21,23,0) then
								JY.Status=GAME_END;
								return;
							end
--（主角VS令狐冲，败则GAMEOVER）
							script_say("主角：哈哈哈！死吧！");
							Dark();
--（画外音）
							script_say("岳灵珊：爹，你说大师兄怎么还不追上来啊？我们都放慢脚步等他半天了。");
							lib.FillColor(0,0,0,0,0);
							script_say("岳不群：或许他遇到了什么事，耽搁了也说不定。");
							lib.FillColor(0,0,0,0,0);
							script_say("主角：岳不群！哼！算你命大！");
							SetS(JY.SubScene,17,18,1,0);
							SetS(JY.SubScene,18,18,1,0);
							SetS(JY.SubScene,20,20,1,0);
--（主角离开城郊）
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
							script_say("主角：（林震南是活不成了，如果不是岳不群来到，说不定我现在都……不过，既然那林平之拜入华山，想来也应该跟着来了。这样一来，林震南肯定会将藏剑谱之处告诉他的。之后只要从他那逼出剑谱所在，或者等他取剑谱之时夺取剑谱就行了。）");
--（与衡山交恶）
--【青城线 结束】
						elseif JY.Person[0]["门派"]==0 then
							SetFlag(16003,1);
							SetS(JY.SubScene,18,20,1,4946*2);
							MoveSceneTo(21,19);
							script_say("余沧海：快说！那辟邪剑谱藏于何处！");
							script_say("林震南：我……林家……辟邪剑法……皆为……口传……不曾有……曾有剑谱……留下……");
							script_say("余沧海：死到临头还敢嘴硬！我倒要看你还能支持多久！");
							Dark();
								script_say("令狐冲：住手！");
								lib.FillColor(0,0,0,0,0);
								say("大师兄，你也来了！")
								JY.Base["人X1"],JY.Base["人Y1"]=19,22;
								JY.Base["人方向"]=0;
								JY.MyPic=GetMyPic();
								SetS(JY.SubScene,20,20,1,4256*2);
								JY.SubSceneX,JY.SubSceneY=0,0;
							Light();
--（二人VS余沧海，败则GAMEOVER）
							ModifyWarMap=function()
								SetWarMap(17,18,1,0);
								SetWarMap(18,18,1,0);
								SetWarMap(18,20,1,0);
								SetWarMap(20,20,1,0);
								SetWarMap(22,23,1,851*2);
							end
							FIGHT(
										2,1,
										{
											0,19,22,
											8,21,20,
										},
										{
											27,18,18,
										},
										0,0
									);
							script_say("余沧海：你们两个瓜娃子屡屡坏我大事！真当我不杀人么！纳命来！");
--（画外音）
							Dark();
							script_say("岳灵珊：爹，你说大师兄和师弟怎么还不追上来啊？我们都放慢脚步等他们半天了。");
							lib.FillColor(0,0,0,0,0);
							script_say("岳不群：或许他们遇到了什么事，耽搁了也说不定。");
							lib.FillColor(0,0,0,0,0);
							script_say("余沧海：哼！算你们两个瓜娃子命大！");
							SetS(JY.SubScene,18,20,1,0);
							Light();
--（余沧海消失）
							script_say("主角：幸好师父他们来了，不然……");
							script_say("令狐冲：是啊。林总镖头，林夫人，你们……");
							script_say("林震南：我……我们是……不行了……烦少侠……告诉小儿……那……福州……向阳巷……老宅……的东西……凡我子孙……皆……皆……不得……翻看……");
							script_say("令狐冲：晚辈记下了。");
							script_say("林震南：谢……");
							script_say("林夫人：……");
							script_say("主角：大师兄，二位可是已经……");
							script_say("令狐冲：二位已经走了……");
--（画外音）
							Dark();
								SetS(JY.SubScene,20,20,1,0);
								SetS(JY.SubScene,23,23,1,4224*2);
								SetS(JY.SubScene,25,23,1,2982*2);
								SetS(JY.SubScene,26,22,1,2592*2);
								SetS(JY.SubScene,27,22,1,2592*2);
								SetS(JY.SubScene,28,22,1,2592*2);
								SetS(JY.SubScene,26,24,1,2592*2);
								SetS(JY.SubScene,27,24,1,2592*2);
								SetS(JY.SubScene,28,24,1,2592*2);
								JY.Base["人X1"],JY.Base["人Y1"]=23,24;
								JY.Base["人方向"]=1;
								JY.MyPic=GetMyPic();
								script_say("岳不群：冲儿？");
--（华山众人出现）
							
							Light();
							script_say("林平之：爹！娘！");
							script_say("岳不群：冲儿，这是怎么回事？");
							script_say("令狐冲：师父，刚刚我与师弟至此，发现那余沧海正在逼问林总镖头夫妇辟邪剑谱的下落，我与师弟二人合力也斗他不过，正当他要下杀手的时候，幸好师父及时赶到，把他吓跑了。可林总镖头他们伤势太重……所以……");
							script_say("岳不群：这余沧海枉为一观之主，居然做出如此下作之事。");
							script_say("主角：下次见到他，一定要让他知道我华山剑法的厉害！");
							script_say("令狐冲：对了，林师弟，你父亲让我转告你……（私语）");
							script_say("林平之：……谢谢大师兄……");
							script_say("岳不群：平之，虽然不合时宜，但是我还是需要问你一问，这尸身你准备……");
							script_say("林平之：我希望能将爹娘带回福州……");
							script_say("岳不群：可福州与我华山并不同路，此去怕是……");
							script_say("主角：师父，不如将两位就地火化，将其骨灰带回华山，日后林师弟回福州之时，再带回去可好？");
							script_say("岳不群：胡闹！死者为大，怎可焚其尸身？");
							script_say("林平之：不，就按师兄所说的做吧……");
							script_say("岳不群：唉……");
								SetS(JY.SubScene,23,23,1,0);
								SetS(JY.SubScene,25,23,1,0);
								SetS(JY.SubScene,26,22,1,0);
								SetS(JY.SubScene,27,22,1,0);
								SetS(JY.SubScene,28,22,1,0);
								SetS(JY.SubScene,26,24,1,0);
								SetS(JY.SubScene,27,24,1,0);
								SetS(JY.SubScene,28,24,1,0);
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
						end
					else
						SetS(58,48,55,3,-1);
						SetS(58,49,55,3,-1);
						return true;
					end
				end,
			}
						--say("")