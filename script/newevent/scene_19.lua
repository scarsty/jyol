SceneEvent[19]={};--全真教各事件
SceneEvent[19]={
				[0]=function()
					if JY.Da>0 then
						say("你好吗？",JY.Da);
					else
						script_say("全真弟子：你好吗？");
					end
				end,
				[1]=function()	--看门弟子
					--暂时不考虑全真公敌
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
						local d=JY.Base["人方向"];
						if d==0 then
							say("贫道有礼了，不知小兄弟所来何事？",JY.Da);
						else
							say("不多留几日吗？",JY.Da);
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
						menu[2][3]=0;
						if JY.Person[0]["门派"]>=0 then	--非无门派
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							say("请进！",JY.Da);
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
									JY.Person[0]["门派"]=14;
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
							say("小兄弟请自便。",JY.Da);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("道兄所来何事？",JY.Da);
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
								say("请手下留情！",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
								Cls();
								ShowScreen();
								if result then
									say("好俊的身手！",JY.Da);
								else
									say("承让了！",JY.Da);
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
								say("请。",JY.Da);
								Dark();
								JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
								JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
								Light();
							elseif r==7 then
								say("道兄请自便。",JY.Da);
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
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
						script_say("全真弟子：全真派武功是武学正宗。");
					elseif JY.Da>0 then
						say("道兄所来何事？",JY.Da);
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
								say("好俊的身手！",JY.Da);
							else
								say("承让了！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("道兄请自便。",JY.Da);
						end
					else
						script_say("全真弟子：全真派武功是武学正宗。");
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=14 or JY.Da<=0 then
						script_say("全真弟子：练功贵在持之以恒。");
					else
						say("来练功吧！",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--掌门
					if JY.Da==433 then--马钰
						say("一住行窝几十年，蓬头长日走如颠。",JY.Da);
					elseif JY.Da==438 then--谭处端
						say("手握灵珠常奋笔，心开天籁不吹箫。",JY.Da);
					elseif JY.Da==436 then--刘处玄
						say("鸣榔相唤知予意，濯出洪波万丈高。",JY.Da);
					elseif JY.Da==435 then--丘处机
						say("海棠亭下重阳子，莲叶舟中太乙仙",JY.Da);
					elseif JY.Da==434 then--王处一
						say("此地如此僻静，想不到你也能找来。",JY.Da);
					elseif JY.Da==439 then--郝大通
						say("无物可离虚壳外，有人能悟未生前。",JY.Da);
					elseif JY.Da==437 then--孙不二
						say("出门一笑无拘碍，云在西湖月在天！",JY.Da);
					else
						say("云在西湖月在天",JY.Da);
					end
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
						local menu={
												{"聊天",nil,1},
												{"拜师",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
									};
						if JY.Person[0]["门派"]>=0 then
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							say("......",JY.Da);
						elseif r==2 then
							say("弟子久仰"..JY.Person[JY.Da]["外号"].."仙师的仙风道骨，欲拜入门下，朝夕侍奉。不知仙师能应允否？");
							if JY.Da==437 then
								say("我不收男弟子的，你还是另寻他人吧。",JY.Da);
							else
								if true then
									say("ｎ，本门自祖师爷重阳真人立派以来，皆以修道养性为主，全真教武功虽然博大精深，学之无尽，但重阳宫的门规是非常严厉的，你愿意吗？。",JY.Da);
									if DrawStrBoxYesNo(-1,-1,"是否真的要拜入全真教？",C_WHITE,CC.Fontbig) then
										say("是！弟子愿意拜入重阳宫，接受师尊 教诲，试试听从师尊吩咐不敢违逆！");
										say("入了门拜了师就必须遵从师傅所说的话，练功时要勤奋刻苦，盼你好好用功，别损了全真弟子的威名。",JY.Da);
										JY.Person[0]["门派"]=14;
										JY.Shop[5]["入门时间"]=GetFlag(1);
										SetFlag(1003,JY.Da);
										DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ全真教",C_WHITE,CC.Fontbig);
										JY.Person[0]["外号"]="全真弟子";
										--GetItem(5,1);
									else
										say("哇！这么麻烦的啊！开什么玩笑，我不拜师了！");
									end
								else
									say("阁下在江湖上早有盛名，又何必来消遣我全真教寻乐呢？",378);
								end
							end
						elseif r==3 then
							PersonStatus(JY.Da);
						else
							return;
						end
					else
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						if GetFlag(1003)~=JY.Da then
							menu[2][3]=0;
						end
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							say("全真教武功博大精深，你要好好用功。",JY.Da);
							local kflist={
												{261,10},--全真剑
												{265,10},--全真掌
												{270,10},--全真心
												{273,10},--全真身
										};
							if JY.Da==433 then--马钰
								kflist={
												{261,10},--全真剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{267,10},--昊天掌
												{268,10},--三花掌
												{271,10},--道家心
												{272,10},--廿四诀
												{273,10},--全真身
												{274,10},--金雁功
										};
							elseif JY.Da==438 then--谭处端
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{267,10},--昊天掌
												{268,8},--三花掌
												{271,10},--道家心
												{272,10},--廿四诀
												{273,10},--全真身
												{274,8},--金雁功
										};
							elseif JY.Da==436 then--刘处玄
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{263,8},--同归剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{267,10},--昊天掌
												{270,10},--全真心
												{271,10},--道家心
												{272,10},--廿四诀
												{273,10},--全真身
												{274,10},--金雁功
										};
							elseif JY.Da==435 then--丘处机
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{264,6},--重阳剑
												{270,10},--全真心
												{272,8},--廿四诀
												{273,10},--全真身
												{274,10},--金雁功
										};
							elseif JY.Da==434 then--王处一
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{263,10},--同归剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{267,10},--昊天掌
												{270,10},--全真心
												{273,10},--全真身
												{274,10},--金雁功
												{276,10},--荷叶
										};
							elseif JY.Da==439 then--郝大通
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{263,7},--同归剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{267,10},--昊天掌
												{271,10},--道家心
												{272,10},--廿四诀
												{273,10},--全真身
												{274,10},--金雁功
										};
							elseif JY.Da==437 then--孙不二
								kflist={
												{261,10},--全真剑
												{262,10},--七星剑
												{263,10},--同归剑
												{265,10},--全真掌
												{266,10},--冲天掌
												{270,10},--全真心
												{271,10},--道家心
												{272,8},--廿四诀
												{273,10},--全真身
												{274,10},--金雁功
										};
							else
								kflist={
												{261,10},--全真剑
												{270,10},--全真心
												{273,10},--全真身
										};
							end
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<JY.Person[JY.Da]["等级"]-14 then
								say("你还是再练练吧。",JY.Da);
							else
								say("有什么能为，都施展出来吧！",JY.Da);
								local result=vs(0,-1,27,JY.Da,13,26,3000);
								Cls();
								ShowScreen();
								if result then
									say("不错，有进步！",JY.Da);
								else
									say("你近来是不是懈怠了！",JY.Da);
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
					if JY.Person[0]["门派"]==14 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--休息 无用
					if JY.Person[0]["门派"]==14 then
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
							visit(14);
						end
					else
						visit(14);
					end
					walkto_old(3,0);
				end,
				[7]=function()	--传功 无用
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
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
					if JY.Person[0]["门派"]~=14 then	--非全真弟子
						script_say("全真弟子：这里是厨房，没什么好看的。");
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
						script_say("全真弟子：你别站这里添乱好不好，被师父看到骂死你。");
					end
				end,
				[11]=function()		--琴
				end,
				[12]=function()		--棋
				end,
			}

						--say("")