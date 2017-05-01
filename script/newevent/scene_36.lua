SceneEvent[36]={};--青城派各事件
SceneEvent[36]={
				[1]=function()--守门弟子
					if JY.Person[0]["门派"]~=1 then
						say("格老子的，这里是青城派，瓜娃子不要乱闯。",45);
					else
						say("入他个先人板板，掌门正在里面休息哇，龟儿子再大声喧哗看？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"守卫",nil,1},
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
							say("你娃硬是要得，就让师兄我好好指点你。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(28,44,1,1021*2);
								SetWarMap(29,44,1,1022*2);
								SetWarMap(30,44,1,1023*2);
								SetWarMap(28,43,1,0);
								SetWarMap(30,43,1,0);
							end
							local result=vs(0,29,32,JY.Da,29,25,100);
							--[[SetWarMap(29,24,1,0);
							SetWarMap(28,44,1,1024*2);
							SetWarMap(29,44,1,0);
							SetWarMap(30,44,1,1026*2);
							SetWarMap(28,43,1,1025*2);
							SetWarMap(30,43,1,1027*2);]]--
							Cls();
							ShowScreen();
							if result then
								say("龟儿子你等着！",JY.Da);
							else
								say("哈哈，真痛快！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_guarding(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("先人板板！没事别来烦我！",JY.Da);
						end
					end
				end,
				[2]=function()--禁止无关人进入
					if JY.Person[0]["门派"]~=1 then
						if JY.Base["人方向"]==0 then
							say("站住！你个龟儿子不要乱闯。",45);
							local menu={
													{"进入",nil,1},
													{"拜师",nil,1},
													{"离开",nil,1},
												};
							if JY.Person[0]["门派"]>-1 then
								menu[2][3]=0;
							end
							local r=ShowMenu(menu,3,0,0,0,0,0,1,0);
							if r==1 then
								if JY.Da>=1 then
									say("你们几个还想讨打？。");
									say("不敢，小兄弟请。",45);
									return;
								end
								say("格老子的，青城派是你个瓜娃儿想进就进的吗？",45);
								ModifyWarMap=function()
									SetWarMap(29,24,1,854*2);
									SetWarMap(28,44,1,1021*2);
									SetWarMap(29,44,1,1022*2);
									SetWarMap(30,44,1,1023*2);
									SetWarMap(28,43,1,0);
									SetWarMap(30,43,1,0);
								end
								local result=FIGHT(
																5,2,
																{
																	0,29,31,
																	-1,27,31,
																	-1,28,31,
																	-1,30,31,
																	-1,31,31,
																},
																{
																	46,28,25,
																	47,30,25,
																},
																50,0
															);
								--[[SetWarMap(29,24,1,0);
								SetWarMap(28,44,1,1024*2);
								SetWarMap(29,44,1,0);
								SetWarMap(30,44,1,1026*2);
								SetWarMap(28,43,1,1025*2);
								SetWarMap(30,43,1,1027*2);]]--
								Cls();
								ShowScreen();
								if result then
									say("什么人在此喧哗？！",27);
									say("师父，这龟儿子擅闯咱们松风观，还敢打伤我们！",45);
									say("胡闹，我看是你们故意为难这位小兄弟吧。Ｐ我青城派乃是名门大派，你们怎能仗势欺人呢！还不退下！",27);
									say("多谢余观主，久闻余观主通情达理，今日一见，果然名不虚传。");
									lib.SetD(JY.SubScene,JY.CurrentD,3,1);
								else
									say("还不快滚！",45);
									walkto_old(0,10);
								end
							elseif r==2 then
								say("在下仰慕青城派的威名，特来拜师。");
								say("好，你等着，我去问问师父。",45);
								Dark();
								Light();
								say("算你娃运气好，师父叫你进来。跟我走吧。",45);
								walkto_old(0,-5);
								say("刚刚门外喧哗的就是你吗？",27);
								say("余观主恕罪，我仰慕青城派威名已久，特意前来拜师。");
								if JY.Da==2 then
									say("哼，原来阁下又来取笑余某么？余某何德何能，配做你的师傅？",27);
									return;
								end
								say("让我看看···",27);
								say("嗯，根骨还行。好，这徒弟我就收下来了。跪下来拜师吧。",27);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入青城派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受小徒一拜。");
									JY.Person[0]["门派"]=1;
									JY.Shop[1]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ青城派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="青城弟子";
									GetItem(1,1);
								else
									say("大胆！莫非你在戏弄老夫不成！给我拿下！",27);
									ModifyWarMap=function()
										SetWarMap(29,24,1,854*2);
										SetWarMap(23,18,1,903*2);
										SetWarMap(34,18,1,903*2);
									end
									local result=FIGHT(
																	5,2,
																	{
																		0,29,21,
																		-1,28,21,
																		-1,30,21,
																		-1,27,21,
																		-1,31,21,
																	},
																	{
																		46,26,15,
																		47,31,15,
																	},
																	50,0
																);
									--[[SetWarMap(29,24,1,0);
									SetWarMap(23,18,1,0);
									SetWarMap(34,18,1,0);]]--
									if result then
										say("阁下好身手，我这几个不成器的徒儿倒让你笑话了。",27);
										say("就让贫道和你比划几招吧。",27);
										ModifyWarMap=function()
											SetWarMap(29,24,1,854*2);
											SetWarMap(23,18,1,903*2);
											SetWarMap(34,18,1,903*2);
										end
										local rr=vs(0,29,21,27,28,14,100);
										--[[SetWarMap(29,24,1,0);
										SetWarMap(23,18,1,0);
										SetWarMap(34,18,1,0);]]--
										Cls();
										ShowScreen();
										if rr then
											say("哼，阁下是特意来消遣余某的吧。你武功如此之高，我青城派庙小，容不下你这尊大佛！",27);
											lib.SetD(JY.SubScene,JY.CurrentD,3,2);
										else
											say("我看也不过如此，这点微末伎俩，也敢如此嚣张！",27);
											say("哼，今日就暂且饶你一条狗命，滚吧！",27);
											walkto_old(0,15);
										end
									else
										say("哼，今日就暂且饶你一条狗命，滚吧！",27);
										walkto_old(0,15);
									end
								end
							elseif r==3 then
								say("好汉饶命，我这就走。");
								walkto_old(0,3);
							end
						end
					else
						return true;
					end
				end,
				[3]=function()--掌门
					if JY.Person[0]["门派"]~=1 then	--非青城弟子
						say("............",JY.Da);
					else
						if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
							SetFlag(12005,1);
							say("衡山刘正风这几日就要金盆洗手退出江湖。你若无事最好也去参加观礼吧。",JY.Da);
							say("是！");
							return;
						end
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
							--say("当年你师祖长青子一代人杰，可惜......",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							local kflist={
												{21,10},
												{23,10,1},
												{22,10},
												{24,10,1},
												{25,10},
												{26,10,2},
												{27,10},
												{28,10,2},
												};
							if GetFlag(11003)==1 then
								kflist[9]={67,10};
							end
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("去找你师兄们切磋吧，你的功夫还差得远呢。",JY.Da);
							else
								say("好，只管出招吧，让我看看你的武功有没有进步。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(29,24,1,854*2);
									SetWarMap(23,18,1,903*2);
									SetWarMap(34,18,1,903*2);
								end
								local result=vs(0,29,21,JY.Da,28,14,100);
								--[[SetWarMap(29,24,1,0);
								SetWarMap(23,18,1,0);
								SetWarMap(34,18,1,0);]]--
								Cls();
								ShowScreen();
								if result then
									say("不错，武功大有进展啊",JY.Da);
								else
									say("好好努力吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("没事就去好好练功。",JY.Da);
						end
					end
				end,
				[4]=function()--左边院子弟子
					if JY.Person[0]["门派"]~=1 then
						say("你是哪来的，别到处乱转。",45);
						--E_kungfugame(-4);
					else
						say("听说扬州丽春院春色无边，真想去玩玩啊。",JY.Da);
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
							say("好啊，就让师兄我好好指点下你。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(28,44,1,1021*2);
								SetWarMap(29,44,1,1022*2);
								SetWarMap(30,44,1,1023*2);
								SetWarMap(28,43,1,0);
								SetWarMap(30,43,1,0);
							end
							local result=vs(0,23,38,JY.Da,14,36,100);
							--[[SetWarMap(29,24,1,0);
							SetWarMap(28,44,1,1024*2);
							SetWarMap(29,44,1,0);
							SetWarMap(30,44,1,1026*2);
							SetWarMap(28,43,1,1025*2);
							SetWarMap(30,43,1,1027*2);]]--
							Cls();
							ShowScreen();
							if result then
								say("......",JY.Da);
							else
								say("哈哈，真痛快！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							
						end
					end
				end,
				[5]=function()--右边院子弟子A
					if JY.Person[0]["门派"]~=1 then
						say("我青城派人才济济，小一辈当中，「青城四秀」那也是江湖中有数的少年才俊。",45);
					else
						say("要师兄我指点你的功夫吗？。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"锻炼",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							say("我青城派的摧心掌也是武林一绝，不过名气却不是很大。",JY.Da);
							say("为什么呢？");
							say("哈哈！因为中了这招的人，自己都没察觉，但其实已经伤入肺腑，只能等死了。",JY.Da);
						elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							say("好啊，就让师兄我好好指点下你。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(28,44,1,1021*2);
								SetWarMap(29,44,1,1022*2);
								SetWarMap(30,44,1,1023*2);
								SetWarMap(28,43,1,0);
								SetWarMap(30,43,1,0);
							end
							local result=vs(0,41,34,JY.Da,35,31,100);
							--[[SetWarMap(29,24,1,0);
							SetWarMap(28,44,1,1024*2);
							SetWarMap(29,44,1,0);
							SetWarMap(30,44,1,1026*2);
							SetWarMap(28,43,1,1025*2);
							SetWarMap(30,43,1,1027*2);]]--
							Cls();
							ShowScreen();
							if result then
								say("......",JY.Da);
							else
								say("哈哈，真痛快！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							
						end
					end
				end,
				[6]=function()--右边院子弟子B
					if JY.Person[0]["门派"]~=1 then
						say("川中武林，以我青城与峨嵋为尊。",45);
					else
						say("闯荡江湖时，切不可弱了我青城派的威风。",JY.Da);
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
							say("好啊，就让师兄我好好指点下你。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(29,24,1,854*2);
								SetWarMap(28,44,1,1021*2);
								SetWarMap(29,44,1,1022*2);
								SetWarMap(30,44,1,1023*2);
								SetWarMap(28,43,1,0);
								SetWarMap(30,43,1,0);
							end
							local result=vs(0,41,34,JY.Da,37,29,100);
							--[[SetWarMap(29,24,1,0);
							SetWarMap(28,44,1,1024*2);
							SetWarMap(29,44,1,0);
							SetWarMap(30,44,1,1026*2);
							SetWarMap(28,43,1,1025*2);
							SetWarMap(30,43,1,1027*2);]]--
							Cls();
							ShowScreen();
							if result then
								say("......",JY.Da);
							else
								say("哈哈，真痛快！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							
						end
					end
				end,
				[7]=function()--练功房
					if JY.Person[0]["门派"]~=1 then
						say("此处是我青城派练功之处，你这瓜娃儿还不速速离开！。",45);
					else
						say("师弟是来练功的吗？",JY.Da);
						E_training(JY.Da);
					end
				end,
				[8]=function()--看书
					if JY.Person[0]["门派"]==1 then
						say("这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[9]=function()--上香
					if JY.Person[0]["门派"]==1 then
						if JY.Da==GetFlag(1) then
							say("今天已经上过香了，明天再来吧。");
						else
							 DrawStrBoxWaitKey("先师长青子之灵位",C_WHITE,CC.Fontbig);
							 Cls();
							if DrawStrBoxYesNo(-1,-1,"是否上香？",C_WHITE,CC.Fontbig) then
								say("师祖在上，您在天有灵，请佑我青城长盛不衰。");
								Dark();
								lib.Delay(500);
								SetFlag(11001,GetFlag(11001)+1);
								Light();
								lib.SetD(JY.SubScene,JY.CurrentD,3,GetFlag(1));
								if Rnd(20)==1 then
									AddPerformance(1);
								end
							else
								say("下次再来吧。");
							end
						end
					end
				end,
				[10]=function()--休息
					if JY.Person[0]["门派"]==1 then
						local menuItem=	{
														{"休息",nil,1},
														{"拜访",nil,1},
														{"没事",nil,2},
													}
						local r=EasyMenu(menuItem);
						if r==1 then
							if rest() then
								say("休息好了，真舒服。");
							end
						elseif r==2 then
							visit(1);
						end
					else
						visit(1);
					end
					walkto_old(2,0);
				end,
				[11]=function()--
				end,
			}

						--say("")