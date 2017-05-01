SceneEvent[56]={};--福威镖局各事件
--福威镖局灭门事件，仅青城派能开启
SceneEvent[56]={
				[1]=function()--大门
					if GetFlag(16001)==1 then	--灭门开启
						if GetFlag(1)-GetFlag(16002)<=15 then	--时限以内
							if JY.Person[0]["门派"]==1 then	--青城派
								say("师兄，咱们上");
								walkto_old(-3,0);
								SetFlag(16000,1);	--福威镖局公敌标记
							else--拯救镖局
								ModifyD(JY.SubScene,0,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,1,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,2,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,3,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,6,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,7,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
								ModifyD(JY.SubScene,8,0,0,0,0,0,0,0,0,0,-2,-2);
								SetS(JY.SubScene,13,28,1,3021*2);
								SetS(JY.SubScene,15,28,1,3021*2);
								SetS(JY.SubScene,13,24,1,3020*2);
								SetS(JY.SubScene,15,24,1,3020*2);
								SetS(JY.SubScene,17,27,1,3022*2);
								SetS(JY.SubScene,17,25,1,3022*2);
								MoveSceneTo(19,27);	--视角:青城弟子
								say("林震南，你还不肯说出剑谱的下落吗？",35);
								say("狗贼！有种你便一刀杀了我！可笑我还年年向你们青城进贡。真是瞎了我狗眼认不清你们的狼子野心！",135);
								MoveSceneTo();
								say("万幸，赶上了。");
								walkto_old(-26,0);
								say("什么人，找死！",35);
								
								SetS(JY.SubScene,13,28,1,0);
								SetS(JY.SubScene,15,28,1,0);
								SetS(JY.SubScene,13,24,1,0);
								SetS(JY.SubScene,15,24,1,0);
								SetS(JY.SubScene,17,27,1,0);
								SetS(JY.SubScene,17,25,1,0);
								ModifyWarMap=function()
									SetWarMap(26,39,1,854*2);
									SetWarMap(26,17,1,854*2);
								end
								local r=FIGHT(
														5,10,
														{
															0,	19,27,
															135,13,26,
															-1,20,26,
															-1,20,28,
															-1,21,27,
														},
														{
															35,14,24,
															37,14,28,
															38,22,26,
															39,15,23,
															40,15,29,
															41,17,23,
															42,17,29,
															43,20,29,
															44,20,25,
															45,22,28,
														},
														2000,0,2
													);
								--[[SetWarMap(26,39,1,0);
								SetWarMap(26,17,1,0);]]--
						
								ModifyD(JY.SubScene,9,0,0,0,0,0,0,0,0,0,-2,-2);
								if r then
									say("恭喜你，取得了难以想象的胜利，我甚至都来不及为这场胜利准备剧情！",1);
								else
									say_2("你这小子，多管闲事，去死吧！",35);
									ScreenFlash(C_WHITE);
									--Dark();
									say_2("嗯，好象有人！",40);
									say_2("去看看！",35);
									Dark();
									lib.Delay(300);
									WaitKey();
									lib.Delay(600);
									Light();
									say_2("似乎有谁救了我。");
									--JY.Status=GAME_END;
								end
							end
						else	--遍地尸体
							
							ModifyD(JY.SubScene,0,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,1,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,2,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,3,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,6,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,7,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,8,0,0,0,0,0,0,0,0,0,-2,-2);
							ModifyD(JY.SubScene,9,0,0,0,0,0,0,0,0,0,-2,-2);
							if JY.Person[0]["门派"]==1 then	--青城派
								say("来晚了，贾师兄似乎已经把镖局的人杀光了。还是赶紧回松风观吧，希望师父不会责罚我。");
							else
								say("来晚了，青城派好狠辣的手段！");
							end
						end
						SetFlag(16001,2);
					elseif GetFlag(16001)==2 and GetFlag(16000)==1 then
						say("余师兄的仇还没报呢！");
						walkto_old(-3,0);
					else
						return true;
					end
				end,
				[2]=function()--镖师
					if JY.Da>0 then
						RandomEvent(JY.Da);
					else
						say("阁下如果有镖要保，请去找总镖头。",145);
					end
				end,
				[3]=function()--宝箱
				end,
				[4]=function()--林震南
					if JY.Da>0 then
						RandomEvent(JY.Da);
					else
						say("显示这句话，表示游戏出错了。",135);
					end
				end,
				[5]=function()--灵牌
					--辟邪剑谱后续时间，暂无
				end,
				[6]=function()--林平之
					say("如果要保镖，请去找我家父。",136);
				end,
				[7]=function()--灭门-平之
					if GetFlag(16000)==1 and GetFlag(16003)==0 then
						say("什么人！",140);
						say("要你命的人！");
						ModifyWarMap=function()
							SetWarMap(18,26,1,902*2);
							SetWarMap(18,27,1,902*2);
							SetWarMap(18,28,1,902*2);
							SetWarMap(26,39,1,854*2);
						end
						local r=FIGHT(
										5,5,
										{
											0,	25,21,
											35,27,21,
											-1,25,22,
											-1,26,22,
											-1,27,22,
										},
										{
											136,20,13,
											139,24,19,
											140,28,19,
											141,25,22,
											142,27,22,
										},
										1000,1
									);
						--[[
						SetWarMap(18,26,1,0);
						SetWarMap(18,27,1,0);
						SetWarMap(18,28,1,0);
						SetWarMap(26,39,1,0);]]--
						if r then
							SetFlag(16006,1);	--平之捕获
							SetFlag(16003,1);
							ModifyD(JY.SubScene,6,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,7,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,8,0,0,0,0,0,0,0,0,0,-2,-2);
							SetS(JY.SubScene,20,13,3,-1);
							say("哈哈，小子看你往哪逃！回头带去见师傅，为师兄报仇。");
						else
							JY.Status=GAME_END;
						end
					else
						return true;
					end
				end,
				[8]=function()--灭门-财宝
					if GetFlag(16000)==1 and GetFlag(16004)==0 then
						say("什么人！",140);
						say("要你命的人！");
						ModifyWarMap=function()
							SetWarMap(18,26,1,902*2);
							SetWarMap(18,27,1,902*2);
							SetWarMap(18,28,1,902*2);
							SetWarMap(26,17,1,854*2);
						end
						local r=FIGHT(
										5,6,
										{
											0,	25,35,
											35,27,35,
											-1,25,34,
											-1,26,34,
											-1,27,34,
										},
										{
											141,24,34,
											142,28,33,
											143,24,37,
											144,28,37,
											145,24,40,
											146,27,42,
										},
										1000,1
									);
						--[[SetWarMap(18,26,1,0);
						SetWarMap(18,27,1,0);
						SetWarMap(18,28,1,0);
						SetWarMap(26,17,1,0);]]--
						if r then
							SetFlag(16004,1);
							ModifyD(JY.SubScene,0,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,2,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
						else
							JY.Status=GAME_END;
						end
					else
						return true;
					end
				end,
				[9]=function()--灭门-震南
					if GetFlag(16000)==1 and GetFlag(16005)==0 then
						say("什么人！",140);
						say("要你命的人！");
						SetFlag(16000,2);
						ModifyWarMap=function()
							SetWarMap(26,39,1,854*2);
							SetWarMap(26,17,1,854*2);
						end
						local r=FIGHT(
										5,11,
										{
											0,	16,27,
											35,16,25,
											-1,20,26,
											-1,20,28,
											-1,21,27,
										},
										{
											135,13,26,
											137,14,24,
											138,14,28,
											139,15,23,
											140,15,29,
											141,17,23,
											142,17,29,
											143,20,29,
											144,20,25,
											145,22,28,
											146,22,26,
										},
										2000,0
									);
						--[[SetWarMap(26,39,1,0);
						SetWarMap(26,17,1,0);]]--
						if r then
							SetFlag(16003,1);
							SetFlag(16004,1);
							SetFlag(16005,1);
							ModifyD(JY.SubScene,0,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,1,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,2,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,3,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,6,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,7,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
							ModifyD(JY.SubScene,8,0,0,0,0,0,0,0,0,0,-2,-2);
							ModifyD(JY.SubScene,9,0,0,0,0,0,0,0,0,0,-2,-2);
							SetS(JY.SubScene,20,20,13,-1);
							SetS(JY.SubScene,20,13,26,-1);
							say("林总镖头。要恨，就恨你的曾祖为什么是林远图，要怪，就怪你的儿子为什么要杀我少观主吧！");
						else
							
							JY.Status=GAME_END;
						end
					else
						return true;
					end
				end,
				[10]=function()--镖师尸体
					DrawStrBoxWaitKey("镖师的尸体",C_WHITE,CC.Fontbig);
				end,
				[77]=function()--BAK
				end,
			}

						--say("")