SceneEvent[29]={};--泰山派各事件
SceneEvent[29]={
				[1]=function()	--看门弟子
					--暂时不考虑泰山公敌
					if JY.Person[0]["门派"]~=3 then	--非泰山弟子
						local d=JY.Base["人方向"];
						if d==2 then
							say("请问阁下来我泰山有何贵干？",80);
						else
							say("少侠慢走，恕不远送。",80);
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
							say("我泰山乃五岳之首，天柱雄奇，云桥飞瀑，阁下若是有暇，不妨多四处走走。",80);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==2 then
							say("我这便向掌门通禀，少侠请随我来。",80);
							Dark();
							JY.Base["人X1"]=20;
							JY.Base["人Y1"]=28;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("小兄弟想入我泰山派门墙？",66);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入泰山派？",C_WHITE,CC.Fontbig) then
									say("师尊在上，请受徒儿一拜！");
									say("既入我门下，就自当遵循我门规。",66);
									JY.Person[0]["门派"]=3;
									JY.Shop[3]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ泰山派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="泰山弟子";
									GetItem(3,1);
								else
									say("既然如此，此事就此作罢。",49);
								end
							else
								say("大胆狂徒！凭你这等江湖匪类，也想拜入我泰山门墙？！",49);
							end
						elseif r==3 then
							say("阁下他日有闲，不妨再来泰山看看。",80);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("阁下既然无事，便速速离去罢。",80);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("师弟找我何事？",JY.Da);
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
								say("好啊，咱哥俩切磋切磋。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(26,27,1,1137*2);
									SetWarMap(26,28,1,1137*2);
									SetWarMap(26,29,1,1137*2);
									SetWarMap(43,26,1,2243*2);
									SetWarMap(43,27,1,2242*2);
									SetWarMap(43,28,1,2242*2);
									SetWarMap(43,29,1,2241*2);
								end
								local result=vs(0,33,29,JY.Da,27,28,300);
								--[[SetWarMap(26,27,1,1138*2);
								SetWarMap(26,28,1,0);
								SetWarMap(26,29,1,1136*2);
								SetWarMap(43,26,1,2251*2);
								SetWarMap(43,27,1,0);
								SetWarMap(43,28,1,0);
								SetWarMap(43,29,1,2246*2);]]--
								Cls();
								ShowScreen();
								if result then
									say("想不到师弟入门没几日，武功便已如此了得，愚兄惭愧。",JY.Da);
								else
									say("师弟这几招练得不错，不过想赢师兄我，还是万万不能啊，哈哈哈！你先下去多练练，咱们下次再切磋切磋。",JY.Da);
								end
								DayPass(1);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==4 then
								--say("多谢师弟美意，可惜吾身负守卫之责，无法脱身啊。",JY.Da);
								E_guarding(JY.Da);
							elseif r==5 then
								say("师弟请进。",JY.Da);
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
							say("师弟请。",20);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						end
					end
				end,
				[2]=function()	--切磋用弟子
					if JY.Person[0]["门派"]~=3 then	--非泰山弟子
						say("难得阁下来我泰山做客，不胜荣幸。",80);
					elseif JY.Da>0 then
						say("跟个道士师父，嘴巴就是寡淡，真怀念上个月吃的红烧驴肉，啧啧。",JY.Da);
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
								SetWarMap(26,27,1,1137*2);
								SetWarMap(26,28,1,1137*2);
								SetWarMap(26,29,1,1137*2);
								SetWarMap(43,26,1,2243*2);
								SetWarMap(43,27,1,2242*2);
								SetWarMap(43,28,1,2242*2);
								SetWarMap(43,29,1,2241*2);
							end
								local result=vs(0,37,24,JY.Da,38,33,300);
							--[[	SetWarMap(26,27,1,1138*2);
								SetWarMap(26,28,1,0);
								SetWarMap(26,29,1,1136*2);
								SetWarMap(43,26,1,2251*2);
								SetWarMap(43,27,1,0);
								SetWarMap(43,28,1,0);
								SetWarMap(43,29,1,2246*2);]]--
							Cls();
							ShowScreen();
							if result then
								say("想不到师弟入门没几日，武功便已如此了得，愚兄惭愧。",JY.Da);
							else
								say("师弟这几招练得不错，不过想赢师兄我，还是万万不能啊，哈哈哈！你先下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("师弟若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						say("我泰山派剑法向来厚重沉稳，规矩谨严。",20);
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=3 then
						say("此乃我泰山演武练功之所，请阁下速速离开。",80);
					else
						say("师弟好生勤勉，又来练功哪？",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--掌门
					if JY.Person[0]["门派"]~=3 then	--非泰山弟子
						say("少侠难得来到泰山，不妨四处游玩一番。",66);
					else
						if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
							SetFlag(12005,1);
							say("衡山刘正风这几日就要金盆洗手退出江湖。你若无事最好也去参加观礼吧。",JY.Da);
							say("是！");
							return;
						end
						say("参见师父！");
						say("嗯？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("泰山乃五岳魁首，我泰山派也是武林名门。你他日行走江湖，不可坏了我泰山派的名声。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							say("哦，你想学点什么？",JY.Da);
							local kflist={
												{41,10},
												{42,10},
												{43,10,1},
												{46,10},
												{47,10,2},
												{48,10},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("你基础太差。",JY.Da);
							else
								say("让为师考较考较你。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(26,27,1,1137*2);
									SetWarMap(26,28,1,1137*2);
									SetWarMap(26,29,1,1137*2);
									SetWarMap(23,24,1,854*2);
									SetWarMap(23,33,1,854*2);
								end
								local result=vs(0,23,28,JY.Da,18,27,3000);
								--[[SetWarMap(26,27,1,1138*2);
								SetWarMap(26,28,1,0);
								SetWarMap(26,29,1,1136*2);
								SetWarMap(23,24,1,0);
								SetWarMap(23,33,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("我泰山后继有人了，哈哈哈哈！",JY.Da);
								else
									say("就这种水平？回去再练！",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("业精于勤荒于嬉，你没事就去好好用功，不要四处闲逛。",JY.Da);
						end
					end
				end,
				[5]=function()--上香
					if JY.Person[0]["门派"]==3 then
						if JY.Da==GetFlag(1) then
							say("今天上香已毕，改日再来吧。");
						else
							 DrawStrBoxWaitKey("先师东灵道人之灵位",C_WHITE,CC.Fontbig);
							 Cls();
							if DrawStrBoxYesNo(-1,-1,"是否上香？",C_WHITE,CC.Fontbig) then
								say("师祖在上，望您在天有灵，佑我泰山长盛不衰，称雄武林。");
								Dark();
								lib.Delay(500);
								Light();
								lib.SetD(JY.SubScene,JY.CurrentD,3,GetFlag(1));
								if Rnd(20)==1 then
									AddPerformance(1);
								end
							else
								say("改日再来吧。");
							end
						end
					end
				end,
				[6]=function()	--书架
					if JY.Person[0]["门派"]==3 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[7]=function()	--休息
					if JY.Person[0]["门派"]==3 then
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
							visit(3);
						end
					else
						visit(3);
					end
					walkto_old(0,-2);
				end,
				[8]=function()	--天松
					if JY.Person[0]["门派"]~=3 then	--非泰山弟子
						say("少侠难得来到泰山，不妨四处游玩一番。",66);
					else
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
							say("泰山乃五岳魁首，我泰山派也是武林名门。你他日行走江湖，不可坏了我泰山派的名声。",JY.Da);
							--RandomEvent(JY.Da);
						elseif r==2 then
							say("哦，你想学点什么？",JY.Da);
							local kflist={
												{41,10},
												{45,10,1},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("你基础太差。",JY.Da);
							else
								say("好，我来指点你一下。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(26,27,1,1137*2);
									SetWarMap(26,28,1,1137*2);
									SetWarMap(26,29,1,1137*2);
									SetWarMap(23,24,1,854*2);
									SetWarMap(23,33,1,854*2);
								end
								local result=vs(0,23,28,JY.Da,18,27,3000);
								--[[SetWarMap(26,27,1,1138*2);
								SetWarMap(26,28,1,0);
								SetWarMap(26,29,1,1136*2);
								SetWarMap(23,24,1,0);
								SetWarMap(23,33,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("好功夫！",JY.Da);
								else
									say("还要努力啊",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("业精于勤荒于嬉，你没事就去好好用功，不要四处闲逛。",JY.Da);
						end
					end
				end,
			}

						--say("")