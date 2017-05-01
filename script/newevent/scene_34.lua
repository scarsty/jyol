SceneEvent[34]={};--崆峒派各事件
SceneEvent[34]={
				[1]=function()	--看门弟子
					--暂时不考虑崆峒公敌
					if JY.Person[0]["门派"]~=12 then	--非崆峒弟子
						local d=JY.Base["人方向"];
						if d==2 then
							say("崆峒派名震江湖，阁下莫非是来拜师的吗？",JY.Da);
						else
							say("这就要走了吗？",JY.Da);
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
							say("看你资质平平，就算拜师，想来师傅也不会收的。进去吧，不要到处乱跑！",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==2 then
							say("哈哈，果然是仰慕我崆峒武学来了。我送你进去吧，祝你好运！",JY.Da);
							Dark();
							JY.Base["人X1"]=16;
							JY.Base["人Y1"]=28;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("ｎ，看你根基还不错，希望你日后能努力用功。",378);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入崆峒派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受徒儿一拜！");
									say("甚好，甚好！",378);
									JY.Person[0]["门派"]=12;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ崆峒派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="崆峒弟子";
									--GetItem(5,1);
								else
									say("哼，居然戏耍于我！",378);
								end
							else
								say("阁下在江湖上早有盛名，又何必来消遣我崆峒寻乐呢？",378);
							end
						elseif r==3 then
							--say("既然无事，就赶紧离开吧。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("若是无事，便请速速离开！",JY.Da);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("有事吗？",JY.Da);
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
								say("好，就让我来指点指点你！",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
								Cls();
								ShowScreen();
								if result then
									say("不过一时侥幸而已。",JY.Da);
								else
									say("哈哈，被我指点下是不是受益匪浅啊！",JY.Da);
								end
								DayPass(1);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==4 then
								--say("多谢你的美意，可惜我身负守卫之责，无法脱身啊。",JY.Da);
								E_guarding(JY.Da);
							elseif r==5 then
								say("进来吧。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==6 then
								say("去吧。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==7 then
								say("没事你还老在这晃悠！",JY.Da);
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
					if JY.Person[0]["门派"]~=12 then	--非昆仑弟子
						say("崆峒派名列武林六大派之一，高手辈出。",JY.Da);
					elseif JY.Da>0 then
						say("可是要和我较量较量？",JY.Da);
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
							say("好，就让我来指点指点你！",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("不过一时侥幸而已。",JY.Da);
							else
								say("哈哈，被我指点下是不是受益匪浅啊！",JY.Da);
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
						script_say("崆峒弟子：崆峒派名列武林六大派之一，高手辈出。");
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=12 or JY.Da<=0 then
						script_say("崆峒弟子：练功贵在持之以恒。");
					else
						say("来练功吧！",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--掌门
					if JY.Person[0]["门派"]~=12 then	--非崆峒弟子
						say("阁下远来是客，请随意参观。",JY.Da);
					else
						say("练功有遇到什么难题了吗？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							say("我想想，再教你点什么好呢？",JY.Da);
							local kflist={
												{231,10},
												{232,10},
												{233,10,3},
												{234,10},
												{235,10},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<14 then
								say("你小子这两手功夫，哪是我的对手！",JY.Da);
							else
								say("好，让我看看你功夫练得有没有进步！",JY.Da);
								local result=vs(0,-1,27,JY.Da,13,26,3000);
								Cls();
								ShowScreen();
								if result then
									say("不错，看来我应该多用两层功力的。",JY.Da);
								else
									say("不错，能坚持这么久算是难能可贵了。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("下去吧。",JY.Da);
						end
					end
				end,
				[5]=function()	--书架
					if JY.Person[0]["门派"]==12 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--休息 无用
					if JY.Person[0]["门派"]==12 then
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
							visit(12);
						end
					else
						visit(12);
					end
					walkto_old(3,0);
				end,
				[7]=function()	--传功 无用
					if JY.Person[0]["门派"]~=12 then	--非昆仑弟子
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
					if JY.Person[0]["门派"]~=12 then	--非崆峒弟子
						script_say("崆峒弟子：这里是厨房，没什么好看的。");
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
						script_say("崆峒弟子：你别站这里添乱好不好，被师父看到骂死你。");
					end
				end,
				[11]=function()		--琴
				end,
				[12]=function()		--棋
				end,
			}

						--say("")