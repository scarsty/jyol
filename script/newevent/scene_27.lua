SceneEvent[27]={};--嵩山派各事件
SceneEvent[27]={
				[1]=function()	--看门弟子
					--暂时不考虑嵩山公敌
					if JY.Person[0]["门派"]~=5 then	--非泰山弟子
						local d=JY.Base["人方向"];
						if d==2 then
							say("此乃吾嵩山派重地，若无要事，请速离开。",JY.Da);
						else
							say("要走了吗？",JY.Da);
						end
						local menu={
												{"进入",nil,1},
												{"拜师",nil,1},
												{"离开",nil,1},
												{"没事",nil,1},
											};
						if d==2 then
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
							say("进来吧",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==2 then
							say("既然如此，待我通禀掌门。",JY.Da);
							Dark();
							JY.Base["人X1"]=16;
							JY.Base["人Y1"]=26;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("小兄弟，你可愿入我嵩山，共谋大事？",110);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入嵩山派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受徒儿一拜！");
									say("很好，今日起你便拜入我嵩山门下。只是为师我杂事缠身，无暇指点你的武功，你平日可找你堂师叔习武，亦可与门下其他弟子切磋。",110);
									JY.Person[0]["门派"]=5;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ嵩山派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="嵩山弟子";
									GetItem(5,1);
								else
									say("既是如此，恕不远送。",110);
								end
							else
								say("阁下在江湖上早有盛名，又何必来消遣我嵩山寻乐呢？",110);
							end
						elseif r==3 then
							--say("既然无事，就赶紧离开吧。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("阁下既然无事，便速速离去罢。",JY.Da);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("有何指教？",JY.Da);
							local menu={
													{"聊天",nil,1},
													{"切磋",nil,1},
													{"状态",nil,1},
													{"站岗",nil,1},
													{"进入",nil,1},
													{"外出",nil,1},
													{"没事",nil,1},
												};
							if d==2 then
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
								say("好啊，我们来比划比划吧。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(25,26,1,851*2);
									SetWarMap(25,27,1,851*2);
									SetWarMap(25,28,1,851*2);
									SetWarMap(25,29,1,851*2);
									SetWarMap(48,29,1,1285*2);
								end
								local result=vs(0,39,28,JY.Da,29,28,300);
								--[[SetWarMap(25,26,1,921*2);
								SetWarMap(25,27,1,0);
								SetWarMap(25,28,1,0);
								SetWarMap(25,29,1,919*2);
								SetWarMap(48,29,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("以你的武艺，必将被委以重任。",JY.Da);
								else
									say("功夫尚未到家阿，还要再多多努力。",JY.Da);
								end
								DayPass(1);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==4 then
								--say("多谢你的美意，可惜我身负守卫之责，无法脱身啊。",JY.Da);
								E_guarding(JY.Da);
							elseif r==5 then
								say("请进。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==6 then
								say("江湖险恶，师弟多加小心。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==7 then
								say("师弟若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
							end
						else
							say("请。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						end
					end
				end,
				[2]=function()	--切磋用弟子
					if JY.Person[0]["门派"]~=5 then	--非嵩山弟子
						say("那来的野小子，别看来看去的！",JY.Da);
					elseif JY.Da>0 then
						say("有事吗？",JY.Da);
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
								SetWarMap(25,26,1,851*2);
								SetWarMap(25,27,1,851*2);
								SetWarMap(25,28,1,851*2);
								SetWarMap(25,29,1,851*2);
								SetWarMap(48,29,1,1285*2);
							end
								local result=vs(0,39,28,JY.Da,29,28,300);
							--[[	SetWarMap(25,26,1,921*2);
								SetWarMap(25,27,1,0);
								SetWarMap(25,28,1,0);
								SetWarMap(25,29,1,919*2);
								SetWarMap(48,29,1,0);]]--
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
							say("你若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						say("我嵩山派剑法向来厚重沉稳，规矩谨严。",20);
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=5 then
						say("此乃我嵩山演武练功之所，请阁下速速离开。",80);
					else
						say("又来练功哪？",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--掌门
					if JY.Person[0]["门派"]~=5 then	--非嵩山弟子
						say("不要在此惹是生非。",JY.Da);
					else
						if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
							SetFlag(12005,1);
							say("衡山刘正风这几日就要金盆洗手退出江湖。你若无事最好也去参加观礼吧。",JY.Da);
							say("是！");
							say("且慢，你去衡山，需要与我做一件事情。",JY.Da);
							say("请师傅示下！");
							say("我要你潜入刘府内宅，将刘正风的家小擒下。然后你费彬师叔会带人去拿下刘正风。",JY.Da);
							say("师傅有命，徒儿子当遵从，只是我五岳剑派一向同气连枝，如此作为，只怕......");
							say("哼，那刘正风暗中勾结魔教，早有投靠之意。不然你以为他如今正当盛年，何以会退出江湖！",JY.Da);
							return;
						end
						say("参见师父！");
						say("徒儿，找为师有什么事吗？",JY.Da);
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
							if true then
								say("为师我俗务缠身，你先找你师叔去学武吧。",JY.Da);
								return;
							end
							say("哦，你想学点什么？",JY.Da);
							local kflist={
												{59,10},
												{60,10},
												{61,10,1},
												{62,10},
												{63,10},
												{64,10},
												{65,10,1},
												{77,10},
												{78,10,2},
												{79,10},
												};
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
				[5]=function()	--书架
					if JY.Person[0]["门派"]==5 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--休息
					if JY.Person[0]["门派"]==5 then
						local menuItem=	{
														{"休息",nil,1},
														{"拜访",nil,1},
														{"没事",nil,2},
													}
						local r=EasyMenu(menuItem);
						if r==1 then
							if rest() then
								say("一觉醒来，神清气爽。");
							end
						elseif r==2 then
							visit(5);
						end
					else
						visit(5);
					end
					walkto_old(0,3);
				end,
				[7]=function()	--传功
					if JY.Person[0]["门派"]~=5 then	--非泰山弟子
						say("此乃嵩山重地，速速离去。",JY.Da);
					else
						say("你有何事？",JY.Da);
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
							say("无事就去和师兄弟们切磋去。",JY.Da);
						end
					end
				end,
				[8]=function()	--传功费彬
					if JY.Person[0]["门派"]~=5 then	--非泰山弟子
						say("此乃嵩山重地，速速离去。",JY.Da);
					else
						say("你有何事？",JY.Da);
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
												{62,10},
												{63,10},
												{64,10},
												{65,10,1},
												{66,10,3},
												{77,10},
												{78,10,2},
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
							say("无事就去和师兄弟们切磋去。",JY.Da);
						end
					end
				end,
			}

						--say("")