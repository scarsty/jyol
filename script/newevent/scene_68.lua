SceneEvent[68]={};--昆仑派各事件
SceneEvent[68]={
				[1]=function()	--看门弟子
					--暂时不考虑昆仑公敌
					if JY.Person[0]["门派"]~=13 then	--非昆仑弟子
						local d=JY.Base["人方向"];
						if d==2 then
							say("昆仑山地处西域，阁下不远千里而来，不知有何贵干？",JY.Da);
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
							if GetFlag(1)-GetFlag(23001)<=0 or Rnd(100)>JY.Person[0]["福缘"] then
								SetFlag(23001,GetFlag(1)+2);
							end
						else
							menu[1][3]=0;
							menu[2][3]=0;
						end
						if JY.Person[0]["门派"]>=0 then	--非无门派
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							if GetFlag(1)-GetFlag(23001)<=0 then
								say("十分抱歉，掌门今日有事外出，不在派中，不便接待远客。",JY.Da);
								say("阁下远来不易，不如在山下找间客栈休息几日。",JY.Da);
								return;
							end
							say("请进！",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
							say("此处风景甚好，尤异于中原，阁下不妨多盘桓几日。",JY.Da);
						elseif r==2 then
							if GetFlag(1)-GetFlag(23001)<=0 then
								say("十分抱歉，掌门今日有事外出，不在派中。",JY.Da);
								say("阁下远来不易，不如在山下找间客栈休息几日。",JY.Da);
								return;
							end
							say("是吗，看小兄弟谈吐非常，师傅肯定非常喜好的。",JY.Da);
							Dark();
							JY.Base["人X1"]=17;
							JY.Base["人Y1"]=35;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("我昆仑派素来独居西域，从不参与中原纷争。ｎ入我门来，须得谨守门规，行端表正。",402);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入昆仑派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受徒儿一拜！");
									say("甚好，甚好！",402);
									JY.Person[0]["门派"]=13;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ昆仑派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="昆仑弟子";
									--GetItem(5,1);
								else
									say("如此，小兄弟请回吧。",402);
								end
							else
								say("阁下在江湖上早有盛名，又何必来消遣我昆仑寻乐呢？",402);
							end
						elseif r==3 then
							--say("既然无事，就赶紧离开吧。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("请慢走！",JY.Da);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("有什么事情吗？",JY.Da);
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
								local result=vs(0,-1,28,JY.Da,29,28,300);
								Cls();
								ShowScreen();
								if result then
									say("好功夫！",JY.Da);
								else
									say("不错，再努力下吧。",JY.Da);
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
								say("若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
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
					if JY.Person[0]["门派"]~=13 then	--非昆仑弟子
						say("阁下造访昆仑，不知有何贵干？",JY.Da);
					elseif JY.Da>0 then
						say("昆仑山真是个好地方。",JY.Da);
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
							say("好啊，咱们点到为止。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("好功夫！",JY.Da);
							else
								say("不错，再努力下吧。",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						script_say("昆仑弟子：昆仑山真是个好地方。");
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=13 or JY.Da<=0 then
						script_say("昆仑弟子：此乃我昆仑演武练功之地。");
					else
						say("又来练功哪？",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--掌门
					if JY.Person[0]["门派"]~=13 then	--非昆仑弟子
						say("阁下远来是客，请随意参观。",JY.Da);
					else
						say("参见师父！");
						say("何事？",JY.Da);
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
								say("你根基未固，先去找你师叔震山子吧。",JY.Da);
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
							if JY.Person[0]["等级"]<10 then
								say("还不是时候，你不要好高骛远。",JY.Da);
							else
								say("好，你要小心了！",JY.Da);
								local result=vs(0,-1,27,JY.Da,13,26,3000);
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
							say("若是倦了，也可以弹琴下棋以作消遣。",JY.Da);
						end
					end
				end,
				[5]=function()	--书架
					if JY.Person[0]["门派"]==13 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--休息
					if JY.Person[0]["门派"]==13 then
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
							visit(13);
						end
					else
						visit(13);
					end
					walkto_old(3,0);
				end,
				[7]=function()	--传功
					if JY.Person[0]["门派"]~=13 then	--非昆仑弟子
						say("掌门正在琴室休息。",JY.Da);
					else
						say("可是要我指点你武功？",JY.Da);
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
												{241,10},
												{242,10},
												{243,10},
												{244,10},
												{245,10},
												{248,10},
												{250,10},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if true then
								say("咱们点到即止，来吧！",JY.Da);
								local result=vs(0,-1,27,JY.Da,13,26,3000);
								Cls();
								ShowScreen();
								if result then
									say("看来你很努力了啊。",JY.Da);
								else
									say("没受伤吧，去休息下吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("去吧。",JY.Da);
						end
					end
				end,
				[8]=function()--厨房
					if JY.Person[0]["门派"]~=13 then	--非昆仑弟子
						script_say("昆仑弟子：这里是厨房，没什么好看的。");
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
						script_say("昆仑弟子：你别站这里添乱好不好，被师父看到骂死你。");
					end
				end,
				[11]=function()		--琴
				end,
				[12]=function()		--棋
				end,
			}

						--say("")