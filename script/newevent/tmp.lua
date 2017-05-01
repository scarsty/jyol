SceneEvent[1]={}
SceneEvent[1]={
				[1]=function()	--客栈门口,寻找岳灵珊事件
					if not (GetFlag(10001)==1 or GetFlag(11002)==1 or GetFlag(1)-GetFlag(2)>60) then
						return true;
					elseif GetFlag(16001)~=0 then
						return true;
					else
						Dark();
						ModifyD(JY.SubScene,20,-2,-2,-2,-2,-2,5178,5178,5178,-2,-2,-2);
						ModifyD(JY.SubScene,22,-2,-2,-2,-2,-2,8520,8520,8520,-2,-2,-2);
						Light();
					end
					--35贾人达,36余人彦,45青城弟子,14岳灵珊,9劳德诺,136林平之,137史镖头,138郑镖头,139-146镖师
					MoveSceneTo(24,17);	--视角:青城弟子
					say("贾兄，你看那妞",36);
					MoveSceneTo(19,16);	--视角:岳灵珊
					say("这妞儿长的倒是不错",35);
					say("......",14);
					say("师妹，小不忍则乱大谋。一切以师父的交代为主。切勿轻举妄动。",9);
					Dark();
					say("什么东西！两个不带眼的狗崽子，却到我们福州府来撒野！",136)
					SetD(JY.SubScene,2,5,2931*2);
					SetD(JY.SubScene,2,6,2931*2);
					SetD(JY.SubScene,2,7,2931*2);
					Light();
					Cls();
					MoveSceneTo(22,18);	--视角:林平之
					PlayMovie(2,2931*2,2943*2);
					say("贾老二，人家在骂街哪。你猜这兔儿爷是在骂谁？",36);
					say("这小子？画个妆上台去唱花旦，硬是勾引得人，要说打架，可还不成。",35);
					say("这位便是我们福威镖局的林少镖头。你天大胆子，竟敢太岁头上动土？",137);
					say("福威镖局？从来没听过！那是干啥子的？",36);
					say("专打狗崽子的！",136)
					MoveSceneTo();
					local r;
					if JY.Person[0]["门派"]==0 and GetFlag(10001)==1 then
						say("看那两人装束像是我华山派门人，又是一男一女，一老一少，莫非就是二师兄和小师妹？");
						say("不管如何，我且帮帮他们。");
						ModifyWarMap=function()
							SetWarMap(22,26,1,854*2);
						end
						--SetWarMap(22,26,1,0);
						ModifyD(JY.SubScene,20,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,22,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,11,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,12,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,13,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,14,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						ModifyD(57,28,1,-2,5,14,-1,4259*2,4259*2,4259*2,-2,-2,-2);
						ModifyD(57,29,1,-2,5,9,-1,5180,5180,5180,-2,-2,-2);
						SetFlag(10001,2);	--寻找岳灵珊OK
						SetFlag(11002,2);
						SetFlag(16001,1);	--开启福威镖局灭门
						SetFlag(16002,GetFlag(1));
						JY.Person[14]["友好"]=50;
						r=FIGHT(
										5,6,
										{
											0,	21,21,
											136,22,20,
											-1,22,22,
											-1,21,23,
											-1,22,24,
										},
										{
											35,21,16,
											36,19,19,
											41,18,18,
											42,22,18,
											43,25,20,
											44,21,20,
										},
										1000,0,1
									);
						--Light();
						--SetWarMap(22,26,1,0);
						if r then
							DrawStrBoxWaitKey("混战中，林平之误打误撞，居然刺死了余人彦",C_WHITE,CC.Fontbig);
							say("余师弟！余师弟你醒醒！",35);
							say("贾..贾师哥....通知....我....爹爹，为我....为我..报仇",36);
						else
							JY.Status=GAME_END;
							return;
						end
						say("莫非你就是我爹爹新收的小师弟？",14);
						say("是啊，弟子月前蒙恩师收入门墙");
						say("看你武功练的不错，看来师傅又收了个好徒弟啊。",9);
						AddPerformance(10);
						say("不敢。");
						say("二师兄，我看福威镖局和青城派已然势成水火。青城派必然会去找福威镖局的麻烦，那少镖头终究还是因为帮我才遭此一事，我们就去帮帮他们好吗？",14);
						say("不行！这次下山，师傅早有交待，不得多惹是非。你若有心，便早日回山向师父禀明，请他老人家做主才是。",9);
					elseif JY.Person[0]["门派"]==1 then
						say("余师兄，贾师兄，如此极品的兔儿爷，让小弟也来过一过手瘾可要得？");
						say("哈哈，要得要得。咱们过足了瘾后再好好饮酒。",36);
						ModifyWarMap=function()
							SetWarMap(22,26,1,854*2);
						end
						--SetWarMap(22,26,1,0);
						ModifyD(JY.SubScene,20,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,22,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,11,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,12,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,13,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,14,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						ModifyD(57,28,1,-2,5,14,-1,4259*2,4259*2,4259*2,-2,-2,-2);
						ModifyD(57,29,1,-2,5,9,-1,5180,5180,5180,-2,-2,-2);
						SetFlag(10001,2);	--寻找岳灵珊OK
						SetFlag(11002,2);
						SetFlag(16001,1);	--开启福威镖局灭门
						SetFlag(16002,GetFlag(1));
						r=FIGHT(
										5,8,
										{
											0,	22,25,
											35,24,16,
											36,26,17,
											-1,21,25
											-1,23,25
										},
										{
											136,22,19,
											137,21,18,
											138,23,20,
											142,21,21,
											143,22,21,
											144,21,23,
											145,23,23,
											146,22,24,
										},
										1000,0
									);
						--Light();
						if r then
							DrawStrBoxWaitKey("混战中，林平之误打误撞，居然伤到了余人彦",C_WHITE,CC.Fontbig);
							say("余师弟！余师弟你醒醒！",35);
							say("贾师哥，我没事，伤，这点，小伤不碍事。",36);
							say("赶紧送余师兄回去疗伤吧");
							say("我们这就送余师兄回去。",45);
							ModifyD(36,16,1,-2,6,36,-1,6038,6038,6038,-2,-2,-2);
						else
							DrawStrBoxWaitKey("混战中，林平之误打误撞，居然刺死了余人彦",C_WHITE,CC.Fontbig);
							say("余师弟！余师弟你醒醒！",35);
							say("贾..贾师哥....通知....我....爹爹，为我....为我..报仇",36);
						end
						say("福！威！镖！局！我势必屠尽你满门给余师兄报仇！",35);
						say("小弟虽不才，却愿意随师兄一同血染福州！");
						say("好。为兄先行一步，察看福威镖局的动静。你先回去向师父禀告此事。",35);
						say("是，师兄。待我把这里的事情料理一下，即刻回城。");
						--SetWarMap(22,26,1,0);
					else
						if JY.Person[0]["门派"]==0 then
							say("那两人的装束倒像是我华山派，但是为何我却从来没有见过？")
						end
						ModifyWarMap=function()
							SetWarMap(22,26,1,854*2);
						end
						ModifyD(JY.SubScene,20,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,22,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,11,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,12,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,13,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						ModifyD(JY.SubScene,14,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						ModifyD(57,28,1,-2,5,14,-1,4259*2,4259*2,4259*2,-2,-2,-2);
						ModifyD(57,29,1,-2,5,9,-1,5180,5180,5180,-2,-2,-2);
						SetFlag(10001,2);	--寻找岳灵珊OK
						SetFlag(11002,2);
						SetFlag(16001,1);	--开启福威镖局灭门
						SetFlag(16002,GetFlag(1));
						r=FIGHT(
										3,3,
										{
											136,22,19,
											137,21,18,
											138,23,20,
										},
										{
											35,24,16,
											36,26,17,
											45,24,19,
										},
										0,0
									);
						--SetWarMap(22,26,1,0);
						--Dark();
						--Light();
						if r then
							DrawStrBoxWaitKey("混战中，林平之误打误撞，居然刺死了余人彦",C_WHITE,CC.Fontbig);
							say("余师弟！余师弟你醒醒！",35);
							say("贾..贾师哥....通知....我....爹爹，为我....为我..报仇",36);
						end
						if JY.Person[0]["门派"]==0 then
							say("哎呀，那两个人什么时候不见了！我还是回华山去看看吧。")
						end
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
			}SceneEvent[27]={};--嵩山派各事件
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

						--say("")SceneEvent[29]={};--泰山派各事件
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

						--say("")SceneEvent[36]={};--青城派各事件
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

						--say("")SceneEvent[38]={};--长安城各事件
SceneEvent[38]={
				[1]=function()--读书习字
					say("要学习读书习字么？这几天我不收费的哦！",JY.Da);
					AddZIZHI(JY.Da);
				end,
				[2]=function()--回雁楼
					if GetFlag(10004)==0 and GetFlag(1)-GetFlag(2)>60 then
						Dark();
						say("怎么好像听到刀剑声似的，莫非有什么争斗发生？");
						SetS(JY.SubScene,28,32,1,3578*2);
						SetS(JY.SubScene,29,32,1,4223*2);
						SetS(JY.SubScene,29,36,1,4222*2);
						Light();
						say("嗯？那是？");
						MoveSceneTo(29,32);	--视角:令除冲
						say("令狐兄，我只道你是个天不怕、地不怕的好汉子，怎么一提到尼姑，便偏有这许多忌讳？",149);
						if JY.Person[0]["门派"]==0 then
							say("（令狐兄？！难道是大师哥？）");
						end
						say("嘿，我一生见了尼姑之后，倒的霉实在太多，可不由得我不信。你想，昨天晚上我还是好端端的，连这小尼姑的面也没见到，只不过听到了她说话的声音，就给你在身上砍了三刀，险些儿丧了性命。这不算倒霉，甚么才是倒霉？",8);
						if JY.Person[0]["门派"]==0 then
							say("（这边这个倒似是用刀的好手，怎么大师兄竟然给他砍上了三刀？）");
						end
						say("哈哈，这倒说得是。",149);
						say("田兄，我不跟尼姑说话，咱们男子汉大丈夫，喝酒便喝个痛快，你叫这小尼姑滚蛋罢！我良言劝你，你只消碰她一碰，你就交上了华盖运，以后在江湖上到处都碰钉子，除非你自己出家去做和尚，这“天下三毒”，你怎么不远而避之？",8);
						--令狐Vs田伯光
						if JY.Person[0]["门派"]==0 then
							say("（大师哥一口一个田兄，又似乎有意想让那个尼姑离开，难道这个用刀的家伙就是淫贼田伯光？不好，大师兄这次凶多吉少。）");
							if DrawStrBoxYesNo(-1,-1,"是否出手相助？",C_WHITE,CC.Fontbig) then
								say("大师兄，你怎么还在此处饮酒？若是让师父知道了，你可就惨了。");
								say("你久是师父刚收的小师弟？",8);
								say("好哇，令狐兄，想不到这附近还有你们华山派的人在，想来你也是要对田某动手了啊。",149);
								say("哼！动手便动手，难不成我堂堂华山，还怕了你一个淫贼不成？！");
								say("小师弟莫要轻举妄动！",8);
								ModifyWarMap=function()
									SetWarMap(28,32,1,0);
									SetWarMap(29,32,1,0);
									SetWarMap(29,36,1,0);
									SetWarMap(37,35,1,851*2);
								end
								local r=vs(0,35,35,149,29,36,1000);
								--[[SetWarMap(37,35,1,0);
								SetWarMap(28,32,1,3578*2);
								SetWarMap(29,32,1,4223*2);
								SetWarMap(29,36,1,4222*2);]]--
								if r then
									say("好，想不到华山派除了令狐兄以外还有你这样的小子。不过刚刚只是和你玩玩儿罢了，现在，我要动真格了。接我的飞沙走石刀吧！",149);
									Dark();
									say("啊，好快的刀法......");
									Light();
									say("小师弟！",8);
									say("放心，还死不了。就是比你的伤稍稍重一点而已。",149);
								else
									say("哼，你的华山剑法也算纯熟了，可就算比上你的大师兄，也还差了一大截。",149);
								end
							end
						end
						--迟百城Vs田伯光
						Dark();
						SetS(JY.SubScene,29,34,1,5461*2);
						say("你……你就是田伯光吗？",74);
						Light();
						if JY.Person[0]["门派"]==0 then
							say("怎样？你也想像这个小子一样么？",149);
						else
							say("怎样？",149);
						end
						say("我想怎样？你这淫贼，武林中人人都欲杀你而后快，你却在这里大摇大摆的大放厥词，可是活得不耐烦了？今日我便替天行道，为武林除去一害！",74);
						if JY.Person[0]["门派"]==3 then
							say("迟兄小心！");
						end
						Dark();
						SetS(JY.SubScene,29,34,1,0*2);
						say("啊，......",74);
						say("大言不惭！",149);
						if JY.Person[0]["门派"]==3 then
							say("你这小子，莫非也是泰山派的？",149);
							say("正是！");
							say("眼力不错，比刚才那小子强。",149);
						end
						Dark();
						SetS(JY.SubScene,31,36,1,5460*2);
						say("百城侄儿！",68);
						Light();
						say("淫贼受死！",68);
						local result;
						ModifyWarMap=function()
							SetWarMap(28,32,1,0);
							SetWarMap(29,32,1,0);
							SetWarMap(29,36,1,0);
							SetWarMap(37,35,1,851*2);
							SetWarMap(31,36,1,0*2);
						end
						if JY.Person[0]["门派"]==3 then
							say("师叔，咱们一起上！");
							result=FIGHT(
										5,1,
										{
											0,	35,35,
											68,31,36,
											-1,35,33,
											-1,35,31,
											-1,36,32,
										},
										{
											149,29,36,
										},
										1000,0
									);
						else
							result=FIGHT(
										1,1,
										{
											68,31,36,
										},
										{
											149,29,36,
										},
										1000,0
									);
						end
						--[[
						SetWarMap(37,35,1,0);
						SetWarMap(28,32,1,3578*2);
						SetWarMap(29,32,1,4223*2);
						SetWarMap(29,36,1,4222*2);]]--
						if result then
							Cls();
							say("哼，想不到堂堂泰山派，也不过是仗势欺人之辈",149);
							if JY.Person[0]["门派"]==3 then
								say("与除去你这淫贼相比，我泰山这一点微名又算得了什么！");
							end
							Dark();
							SetS(JY.SubScene,29,36,1,0);
							if JY.Person[0]["门派"]==3 then
								say("啊？人呢？");
							end
							Light();
							say("算了，那淫贼号称万里独行，这份逃跑的功夫，咱们确实是比不上。",68);
							if JY.Person[0]["门派"]==3 then
								say("下次一定要将他立毙当场！");
								say("咱们先带百城侄儿回去养伤吧。",68);
								say("唉，百城这孩子，倒是个好孩子，只是这个这性子，唉！",68);
							end
							say("等，等等。",8);
							say("华山弟子令狐冲多谢泰山派的师伯师兄们相助之恩！",8);
							say("哼，不敢当。刚刚你不是还和那淫贼称兄道弟吗？",68);
							say("你师傅乃江湖中人人称赞的君子剑，怎么就有你这个徒儿呢！",68);
							say("......师伯教训的是",8);
							say("师伯，不是这样子的！",95);
							say("嗯？你是恒山派的师侄？",68);
							say("是的，恒山仪琳，参见师伯。",95);
							say("为什么没和你师傅师姐在一起？",68);
							say("师傅带着我们去衡山，参加刘师叔金盆洗手大会，可是路上，我被那，那，给劫走了。",95);
							say("罢了，赶紧去找你师傅吧。想必她们也在找你。",68);
							say("师伯，令狐大哥他……",95);
							say("哼，不用说了！咱们走！",68);
							SetS(JY.SubScene,31,36,1,0);
							ModifyD(29,18,1,-2,2,74,-2,5170,5170,5170,0,-2,-2);
							ModifyD(29,19,1,-2,8,68,-2,5170,5170,5170,0,-2,-2);
							JY.Person[68]["门派"]=3;
							JY.Person[74]["门派"]=3;
						else
							SetS(JY.SubScene,31,36,1,0);
							Cls();
							say("这牛鼻子老道也不过如此！",149);
							say("令狐兄，我当你是朋友，你出兵刃攻我，我如仍然坐着不动，那就是瞧你不起。我武功虽比你高，心中却敬你为人，因此不论胜败，都须起身招架。对付这牛鼻子却又不同。",149);
							say("哼！承你青眼，令狐冲脸上贴金。",8);
							Dark();
							say("我一生之中，麻烦天天都有，管他娘的，喝酒，喝酒。田兄，你这一刀如果砍向我胸口，我武功不及天松师伯，那便避不了。",8);
							Light();
							say("刚才我出刀之时，确是手下留了情，那是报答你昨晚在山洞中不杀我的情谊。",149);
                                                        say("你是报恩了，我却又承你不杀之情。来，田兄，我敬你一杯。。",8);
							if JY.Person[0]["门派"]==0 then
								say("大师兄，你有伤在身，不可如此……");
								say("你这小子也真不开窍，何不和你师兄学学，倒在这唧唧歪歪，好生烦人。",149);
								DrawStrBoxWaitKey("哑穴被点",C_WHITE,CC.Fontbig);
							end
							say("田兄好功夫。这站着打，我的确不是你对手。不过这坐着打嘛……恐怕你便力有所不逮了。",8);
							say("哈哈哈哈！这个你可不知道了吧。我少年之时，腿上得过寒疾，有两年时光，我是坐着练习刀法，这坐着打正是我拿手好戏。",149);
							say("哦？既然如此，咱们不妨来比划比划？不过，咱们得订下一个规条，胜败未决之时，哪一个先站了起来，便算输。",8);
							say("不错！胜败未决之时，哪一个先站起身，便算输了。",149);
							if JY.Person[0]["门派"]==0 then
								say("（原来如此，师兄是想激他比试，好救出那恒山派的师姐。只是这“坐着比武”……想来大师兄自有他的想法。）");
							end
							Dark();
							say("怎么样？你这坐着打天下第二的剑法，我看也是稀松平常！",149);
							say("这小尼姑还不走，我怎打得过你？有她在，我命中注定要倒大霉。",8);
							Light();
							say("坐着打天下第二，爬着打天下第几？",149);
							say("哈哈，田兄，你输了！咱们先前怎么说来？",8);
							say("咱们约定坐着打，是谁先站起身来，屁股离了椅子……便……便……便……哼！田某无话可说。愿赌服输，小尼姑，你走吧。",149);
							say("那小尼姑，你还不快滚？！下次再让我见到你，我便一刀将你杀了。",8);
							Dark();
							SetS(JY.SubScene,29,36,1,0);
							DrawStrBoxWaitKey("田伯光离开",C_WHITE,CC.Fontbig,1);
							Light();
						end
						say("恒山派的师妹，这淫贼应该不会再来了，你赶紧找你师傅去吧。刚刚言语上多有得罪，还望见谅。",8);
						say("令狐大哥，不用说了，我明白你是为了救我。哎呀！你伤的这么重，我先给你止血。",95);
						if JY.Person[0]["门派"]==0 then
							say("我还没什么，你先帮我那小师弟治伤吧。",8);
							say("这位大哥，谢谢你出手相救，我来给你止血吧。",95);
							DrawStrBoxWaitKey("仪琳用天香断续膏给"..JY.Person[0]["姓名"].."治疗伤势",C_WHITE,CC.Fontbig);
							say("恒山派的灵药，果然名不虚传啊。");
						end
						--青城派
						Dark();
						SetS(JY.SubScene,28,34,1,5706*2);
						SetS(JY.SubScene,29,34,1,5706*2);
						SetS(JY.SubScene,30,34,1,5706*2);
						say("哈哈，令狐冲，你结交淫贼田伯光，今日我青城派罗人杰就要替天行道！",31);
						local n=1;
						if JY.Person[0]["门派"]==0 then
							say("你们真是武林败类，无耻之极！乘人之危，挟大义报私仇，还枉称什么名门正派！今日只要有我一口气在，你们就别想伤我师兄一分一毫！");
							n=5;
						else
							say("哼，一群蟊贼而已。你欺我伸手重伤，就想报之前受辱之恨？只是你这样的三脚猫功夫还不放在我眼里！",8);
						end
						ModifyWarMap=function()
							SetWarMap(28,32,1,0);
							SetWarMap(29,32,1,0);
							SetWarMap(28,34,1,0);
							SetWarMap(29,34,1,0);
							SetWarMap(30,34,1,0);
							SetWarMap(37,35,1,851*2);
						end
						result=FIGHT(
										n,7,
										{
											8,29,32,
											0,35,35,
											-1,35,33,
											-1,35,31,
											-1,36,32,
										},
										{
											31,28,33,
											37,30,33,
											38,30,31,
											39,28,31,
											40,34,35,
											41,35,33,
											42,35,37,
										},
										1000,0
									);
						--[[SetWarMap(37,35,1,0);
						SetWarMap(28,32,1,3578*2);]]--
						if result then
							SetS(JY.SubScene,28,34,1,0);
							SetS(JY.SubScene,29,34,1,0);
							SetS(JY.SubScene,30,34,1,0);
							SetS(JY.SubScene,29,32,1,4256*2);
							Cls();
							if JY.Person[0]["门派"]==1 then
								say("糟了，罗人杰有危险！");
								ModifyWarMap=function()
									SetWarMap(28,32,1,0);
									SetWarMap(29,32,1,0);
									SetWarMap(37,35,1,851*2);
								end
								local rr=vs(0,35,35,8,29,32,1000);
								--SetWarMap(28,32,1,3578*2);
								--SetWarMap(29,32,1,4223*2);
								--SetWarMap(37,35,1,0);
								if rr then
									SetS(JY.SubScene,28,32,1,0);
									SetS(JY.SubScene,29,32,1,0);
									say("你们几个送他回去疗伤吧。");
									say("多谢师兄出手相救！",40);
								else
									JY.Status=GAME_END;
								end
							else
								DrawStrBoxWaitKey("令狐冲刺死罗人杰后，也昏死过去了",C_WHITE,CC.Fontbig);
								say("令狐大哥！",95);
								say("要找个清静的地方给令狐大哥疗伤。",95);
								Dark();
								SetS(JY.SubScene,28,32,1,0);
								SetS(JY.SubScene,29,32,1,0);
								Light();
								DrawStrBoxWaitKey("仪琳带着令狐冲离开了",C_WHITE,CC.Fontbig);
							end
						else
							SetS(JY.SubScene,29,32,1,4223*2);
							SetS(JY.SubScene,28,34,1,5706*2);
							SetS(JY.SubScene,29,34,1,5706*2);
							SetS(JY.SubScene,30,34,1,5706*2);
							Cls();
							say("令狐冲，你还嘴硬吗！",31);
							if JY.Person[0]["门派"]==0 then
								say("（糟糕，大师兄的伤势越来越重，快要不行了。）");
							end
							say("嘿嘿，仪琳师妹，我……我有个大秘密，说给你听。那福……福威镖局的辟邪……辟邪剑谱，是在……是在……",8);
							Dark();
							say("在甚么？",31);
							SetS(JY.SubScene,28,34,1,0);
							SetS(JY.SubScene,29,34,1,0);
							SetS(JY.SubScene,30,34,1,0);
							Light();
							say("啊~~",31);
							DrawStrBoxWaitKey("令狐冲乘罗人杰俯耳过来时，将之刺死",C_WHITE,CC.Fontbig);
							DrawStrBoxWaitKey("刺死罗人杰后，令狐冲也昏死过去了",C_WHITE,CC.Fontbig);
							Dark();
							say("令狐大哥！",95);
							DrawStrBoxWaitKey("仪琳给令狐冲治疗伤势",C_WHITE,CC.Fontbig);
							SetS(JY.SubScene,29,32,1,4256*2);
							Light();
							say("恒山派的灵药，果然名不虚传",8);
							say("仪琳师妹，你快去找你师傅吧，她们想必都要急死了。",8);
							say("可是令狐大哥你的伤还没全好啊。",95);
							say("去吧，这点伤已经不碍事了。",8);
							say("嗯，那，令狐大哥，保重~",95);
							if JY.Person[0]["门派"]==0 then
								Dark();
								SetS(JY.SubScene,28,32,1,0);
								Light();
								say("大师兄，你伤势如此之重，想那恒山灵药也无法令你痊愈吧。还是回华山养伤吧。");
								say("不了，我受人所托，还有事要办。",8);
								Dark();
								say("看来师父又收了个好弟子.....",8);
								SetS(JY.SubScene,29,32,1,0);
								Light();
							else
								Dark();
								SetS(JY.SubScene,28,32,1,0);
								SetS(JY.SubScene,29,32,1,0);
								Light();
							end
						end
						ModifyD(38,10,0,-2,0,0,-2,0,0,0,0,-2,-2);
						SetFlag(10004,2);
					end
				end,
				[100]=function()--消灭魔教妖人
					if JY.Person[0]["门派"]>=0 then
						say("原来你躲在这里啊！拿命来吧！");
						if vs(0,39,26,JY.Da,38,22,500,0) then
							ModifyD(38,18,0,-2,0,0,-2,0,0,0,0,-2,-2);
							MyQuest[1]=2;
						else
							JY.Status=GAME_END;
						end
					end
				end,
				[11]=function()--
				end,
			}

						--say("")SceneEvent[5]={};
SceneEvent[5]={
				[1]=function()		--各种事件...进入场景后触发
					if JY.Person[0]["门派"]==2 and GetFlag(1)-GetFlag(2)>60 and GetFlag(12001)==0 and GetFlag(12005)==0 then
						for i=2,CC.TeamNum do
							if JY.Base["队伍"..i]>=0 then--队伍中有人，则不触发
								return true;
							end
						end
						Dark();
						SetS(JY.SubScene,29,19,1,4226*2);
						SetS(JY.SubScene,31,19,1,2635*2);
						Light();
						say("（咦？林中隐有琴箫合奏之音传出，莫不是师父在此处会友？我且去看一看。）");
						MoveSceneTo(30,18);
						say("哈哈哈哈，曲大哥，我今日实在是高兴啊。合你我二人之力，今日终于创出这《笑傲江湖》之曲了！",50);
						say("（曲大哥？《笑傲江湖》？）");
						say("是啊。你我虽然出身不同，但以乐会友，今日终于创出此曲，只是……",150)
						say("放心吧，曲大哥。我已决定金盆洗手，从此不再过问江湖之事。到时候什么正派邪教都与我无关了。",50);
						say("我也正有此意。",150);
						say("（听师父的意思，莫非此人非我正派中人？嗯？有人！）");
						SetS(JY.SubScene,48,12,1,2604*2);
						MoveSceneTo(48,12);
						say("（看此穿着，是嵩山派的人！嵩山派的人为何会在此？难道他是想……咦？人呢？）");
						Dark();
						JY.SubSceneX=0;
						JY.SubSceneY=0;
						SetS(JY.SubScene,29,19,1,0);
						SetS(JY.SubScene,31,19,1,0);
						SetS(JY.SubScene,48,12,1,0);
						SetS(JY.SubScene,48,32,1,4228*2);
						say("你可是在寻我？",113);
						Light();
						say("不知阁下是嵩山派的……");
						say("在下费彬。",113);
						say("（居然是他！）衡山弟子参见嵩山派费师叔。不知费师叔这是……");
						say("明人不说暗话。想来你也看见了。我问你，你可知那人是谁？",113);
						say("弟子不知。");
						say("那人便是魔教十长老之一的曲洋曲大魔头。",113);
						say("！！！（果然是魔教！）");
						say("哼，此事若是传出去，必将是我五岳剑派的第一大丑闻。不过还好左师兄早有对策，叫我前来处理此事，你可愿帮我？",113);
						say("（左冷禅早有对策？他早就知道了这事？我应不应该帮他呢？）");
						if DrawStrBoxYesNo(-1,-1,"是否帮助费彬？",C_WHITE,CC.Fontbig) then
							say("如此丑闻，自然不能传出去。只是弟子武功低微，不知该如何行事，还望费师叔指点。");
							say("好，你且回去，装作什么都不知道。等时机一到，自会有事需要你去做。",113);
							Dark();
							SetS(JY.SubScene,48,32,1,0);
							Light();
							SetFlag(12001,2);
						else
							say("多谢，师叔美意。只是师父终究还是我衡山之人，此事我会禀明掌门师伯，请他定夺。");
							say("哼！不识好歹！你会后悔的！",113);
							Dark();
							say("（说是这么说……只是掌门师伯他……）");
							SetS(JY.SubScene,48,32,1,2615*2);
							Light();
							say("掌门师伯？！你……你都看到了？");
							say("嗯。",49);
							say("掌门师伯……弟子实在是不知……");
							say("你，很好。你，什么都不知道。我，没来过。",49);
							Dark();
							SetS(JY.SubScene,48,32,1,0);
							Light();
							say("（掌门师伯是要我装作不知道这事？看来他心中已经有所想法了啊）");
							SetFlag(12001,1);
						end
					elseif GetFlag(12005)==2 and GetFlag(12006)==0 then
						--JY.Person[0]["门派"]=0;
						Dark();
							SetS(JY.SubScene,29,19,1,4226*2);
							SetS(JY.SubScene,31,19,1,2635*2);
							SetS(JY.SubScene,30,23,1,5002*2);
							SetS(JY.SubScene,30,21,1,4254*2);
						Light();
						MoveSceneTo(30,18);
						say("令狐冲，你此举可是岳掌门的意思？",113);
						say("在下此举乃是我自己的意思。嵩山派已经灭了刘师叔满门，为何还非要置刘师叔于死地呢？",8);
						say("刘正风勾结魔教，当视为我五岳剑派叛徒。左师兄给过他机会，但是他死不悔改。令狐冲，我奉劝你聪明一点。不然，我这剑下亡魂又要多少一条了。",113);
						script_say("令狐冲：哈哈，我令狐冲贱命一条，但若是一个不小心，说不定还能搏一搏让大嵩阳手折在这呢。");
						script_say("费彬：找死！");
						local menu=	{
												{"令狐兄，我来助你！",1},
												{"刘正风勾结魔教，咎由自取",1},
												{"令狐冲，这是天要你死！",0},
												{"费师叔，我来助你！",0},
												{"静观其变",1},
											};
						--local menu={"令狐兄，我来助你！","刘正风勾结魔教，咎由自取","静观其变"};
						if JY.Person[0]["门派"]==0 then
							menu[1][1]="大师兄！我来助你！";
							--menu[1][2]=0;
						elseif JY.Person[0]["门派"]==1 then
							menu[1][2]=0;
							menu[2][2]=0;
							menu[3][2]=1;
						elseif JY.Person[0]["门派"]==2 then
							menu[2][2]=0;
						elseif JY.Person[0]["门派"]==5 then
							menu[1][2]=0;
							menu[2][2]=0;
							menu[4][2]=1;
						end
						local sel=GenSelection(menu);
						if sel<5 then
							if sel==2 then
								script_say("主角：（那刘正风勾结魔教已是事实，这令狐冲却执意维护刘正风，当真不可取。）");
							elseif sel==3 then
								script_say("主角：（踏破铁鞋无觅处得来全不费工夫！令狐冲，这是天要你死！）");
							end
							JY.SubSceneX,JY.SubSceneY=0,0;
							JY.EnableKeyboard=false;
							JY.EnableMouse=false;
							walkto(31,22);
							walk(2);
							JY.EnableKeyboard=true;
							JY.EnableMouse=true;
						else
							script_say("主角：城门失火，殃及池鱼，我还是继续躲起来吧。");
							PlayWavAtk(9);
							script_say("主角：啊——");
							--Dark();
							ScreenFlash(C_WHITE);
							lib.Delay(400);
							DrawStrBoxWaitKey(JY.Person[0]["姓名"].."不知道被什么打昏了",C_WHITE,CC.Fontbig,1);
							lib.Delay(400);
							--
							JY.SubSceneX,JY.SubSceneY=0,0;
							SetS(JY.SubScene,29,19,1,0);
							SetS(JY.SubScene,31,19,1,0);
							SetS(JY.SubScene,30,23,1,0);
							SetS(JY.SubScene,30,21,1,0);
							Light();
							script_say("主角：啊，怎么回事？");
							SetFlag(12006,2);
							return
							--结束
						end
						local n1,n2=1,1;
						if sel==1 then
							SetFlag(12007,1);
							if JY.Person[0]["门派"]==0 then
								script_say("主角：大师兄！我来助你！");
							else
								script_say("主角：令狐兄，他嵩山以大欺小，好不要脸，我来助你！");
							end
							n1=2;
						elseif sel==2 then
							SetFlag(12007,2);
							script_say("主角：令狐兄，不管怎么样，那刘正风勾结魔教长老已是事实，切勿执迷不悟啊。");
							script_say("令狐冲：多谢你的劝告，只是令狐冲实在看不下嵩山灭人满门的行为，故而插手，不愿江湖多起杀戮。");
							if JY.Person[0]["门派"]==0 then
								script_say("主角：如此恐怕有结交魔教之嫌，师父必然会怪罪下来。");
								script_say("令狐冲：师弟为我之心，为兄甚为感动。只是平日师父亦曾教导，为人须得守信，言出则必行。我已许诺保他二人，怎可因怕师父责怪而自食其言呢？");
								script_say("主角：大师兄豪气过人，只是我却....");
								script_say("主角：罢了，就当我从未来过好了。");
								script_say("费彬：你小子倒是挺识时务的阿。");
								--事件结束
								JY.EnableKeyboard=false;
								JY.EnableMouse=false;
								walkto(57,32);
								walk(1);
								JY.EnableKeyboard=true;
								JY.EnableMouse=true;
								SetS(5,29,19,1,0);
								SetS(5,31,19,1,0);
								SetS(5,30,23,1,0);
								SetS(5,30,21,1,0);
								SetFlag(12006,2);
								return;
							else
								script_say("主角：那不如将那二人交与在下，如何？");
								script_say("令狐冲：多谢你的美意。只是大丈夫言出必行，我既然放出话来要保他二人，自当说到做到。");
								script_say("主角：既是如此，得罪了。");
								n2=2;
							end
						elseif sel==3 then
							SetFlag(12007,2);
							script_say("主角：格老子的，龟儿子令狐兄！今天你就给我师兄偿命吧！");
							n2=2;
						elseif sel==4 then
							SetFlag(12007,2);
							script_say("主角：师叔，咱们一起上。");
							script_say("费彬：有你师叔在，还需要你帮忙吗？你在一边看好了。");
						end
						ModifyWarMap=function()
							SetWarMap(29,19,1,0);
							SetWarMap(31,19,1,0);
							SetWarMap(30,23,1,0);
							SetWarMap(30,21,1,0);
							SetWarMap(49,32,1,1492*2);
						end
--（主角+令狐冲VS主角+费彬。输赢无碍）
						local r1=FIGHT(
										n1,n2,
										{
											8,31,19,
											0,33,23,
										},
										{
											113,29,25,
											0,33,23,
										},
										0,0
									);
						if true then
							script_say("费彬：令狐冲，受死吧！");
							if true then
								if JY.Person[0]["门派"]==1 then
									script_say("主角：龟儿子，今天就把命留下来吧！");
								elseif sel==2 then
									script_say("主角：且慢！令狐冲乃是华山弟子，虽然一时没有明断是非，但是终究没有铸成大错，还请饶他一命吧。");
									script_say("费彬：妇人之仁，滚开！");
								end
							end
						else
							if sel==2 then
								script_say("主角：好剑法。在下自愧不如。今日之事，是在下不自量力，多管闲事了。告辞。");
								return;
							else
								script_say("费彬：果然有几下子，那就让你们见识一下大嵩阳手的威力吧！");
							end
						end
--（突然传来一阵二胡声）
						Dark();
							SetS(5,29,22,1,2615*2);
							script_say("费彬：潇湘夜雨？！莫师兄，请出来一见。");
						Light();
--（莫大出现）
						script_say("莫大：费师兄，左师兄安好？");
						script_say("费彬：左师兄一切都好。莫师兄，今日你衡山门下有人勾结魔教，你说当杀还是不当杀？");
						script_say("莫大：自然……当杀！");
						ModifyWarMap=function()
							SetWarMap(29,19,1,0);
							SetWarMap(31,19,1,0);
							SetWarMap(30,23,1,0);
							SetWarMap(30,21,1,0);
							SetWarMap(29,22,1,0);
							SetWarMap(49,32,1,1492*2);
						end
						local n3=1;
						if JY.Person[0]["门派"]~=5 then
							JY.Person[49]["攻击"]=JY.Person[49]["攻击"]+30;
							JY.Person[49]["身法"]=JY.Person[49]["身法"]+30;
						else
							JY.Person[49]["攻击"]=JY.Person[49]["攻击"]-30;
							JY.Person[49]["身法"]=JY.Person[49]["身法"]-30;
							n3=2;
						end
						local rr=FIGHT(
										n3,1,
										{
											113,30,23,
											0,31,22,
										},
										{
											49,29,22,
										},
										0,0,4
									);--vs(113,30,23,49,29,22,0);
						if JY.Person[0]["门派"]~=5 then
							JY.Person[49]["攻击"]=JY.Person[49]["攻击"]-30;
							JY.Person[49]["身法"]=JY.Person[49]["身法"]-30;
						else
							JY.Person[49]["攻击"]=JY.Person[49]["攻击"]+30;
							JY.Person[49]["身法"]=JY.Person[49]["身法"]+30;
						end
--（莫大VS费彬，费彬败亡）
						if rr then
							script_say("主角：堂堂衡山派掌门也不过是暗中偷袭的小人！");
							script_say("费彬：你就和刘正风一起死在这里吧。");
							Dark();
								script_say("莫大：……哼！");
								SetS(5,29,22,1,0);
								SetS(5,30,21,1,0);
							Light();
							script_say("主角：跑了？！");
							script_say("费彬：想不到莫大居然没有把自己的师弟带走，反而把那华山派的小子带走了。");
							script_say("主角：那小子武功平平，跑了就跑了，又能如何！");
							script_say("费彬：刘正风，我看谁还救得了你！");
							ScreenFlash(C_RED);
							script_say("费彬：咱们回嵩山吧。");
							SetS(5,31,19,1,0);
							SetS(5,29,19,1,0);
							ModifyD(27,20,1,-2,8,113,0,8456,8456,8456,-2,-2,-2);
							SetFlag(12006,1)
							return;
						elseif JY.Person[0]["门派"]==5 then
							JY.Status=GAME_END;
							return;
						end
						local sel2
						if JY.Person[0]["门派"]~=1 then
							script_say("主角：（莫大看来是要杀费彬，我要不要插手呢？）");
							menu={{"费彬毕竟是五岳剑派中人"},{"如此恶人，自然当死"},};
--【是否插手 是/否】
--【是】
							sel2=GenSelection(menu);
						else
							sel2=2
						end
						if sel2==1 then
							script_say("主角：且慢！");
							script_say("主角：此人行为所为人所不齿，但仍旧是五岳剑派中人，如果就此杀死，恐怕……");
							script_say("莫大：……哼！滚！");
							script_say("费彬：多谢莫师兄剑下留情，告辞。");
						else
--（费彬消失）
							SetS(5,30,23,1,0);
							--SetS(JY.SubScene,28,15,1,0);
							Cls();
							lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,C_RED,128);
							ShowScreen();
							lib.Delay(80);
							lib.ShowSlow(50,1);
							Light();
							if JY.Person[0]["门派"]~=1 then
								script_say("令狐冲：多谢莫师伯救命之恩。");
								script_say("莫大：你们两个，很不错。");
								script_say("主角：这如今应该如何是好？");
								script_say("莫大：我没有来过这里，你们也不知道发生了什么。记住了。");
							else
								script_say("令狐冲：多谢莫师伯救命之恩。怎么，青城小子，现在还要取我性命不成？");
								script_say("主角：（莫大来了，必然杀他不得。只有先离开，再找机会）哼，龟儿子，算你命大。");
								JY.EnableKeyboard=false;
								JY.EnableMouse=false;
								walkto(57,32);
								walk(1);
								JY.EnableKeyboard=true;
								JY.EnableMouse=true;
								SetS(5,29,19,1,0);
								SetS(5,31,19,1,0);
								SetS(5,30,23,1,0);
								SetS(5,30,21,1,0);
								return
							end
						end
						Dark();
							SetS(5,30,23,1,0);
							SetS(5,29,22,1,0);
						Light();
--（莫大消失）
						script_say("令狐冲：莫师伯？");
						script_say("刘正风：不用喊了，师兄他已经走了。");
						script_say("曲洋：平日听闻你们师兄弟不合，今日一见，你师兄他还是很在意你这个师弟的啊。");
						script_say("刘正风：平日也只是意见相左，而师兄他不善言辞，自是较为疏远。我实在是愧对衡山列祖列宗啊……");
						script_say("主角：话不能这么说，如今你二人一个金盆洗手，一个脱离了魔教。既非江湖中人，为何还要在意江湖之事呢？");
						script_say("刘正风：是极是极。刘某这一生，绝不后悔与曲大哥相交一事。江湖中人的看法，与我何干？");
						script_say("曲洋：多谢两位小友相救。在下无以为报，只有将我二人合力作成的曲谱赠与你们。希望你们能找到合适的人来演奏。老友，我们走吧。");
						script_say("刘正风：嗯。我们找一处隐居之地，再不问世事了。");
						--script_say("曲非烟：两位大哥哥，你们是好人。曲非烟谢谢两位大哥哥救我爷爷。爷爷，我扶你走吧。");
						Dark();
							SetS(5,29,19,1,0);
							SetS(5,31,19,1,0);
						Light();
--（三人消失）
						if JY.Person[0]["门派"]==0 then
							script_say("令狐冲：师弟，我们也去找师父吧。");
						elseif sel==1 then--if JY.Person[0]["门派"]==3 then
							script_say("令狐冲：这位兄弟，令狐冲多谢你救命之恩。");
							script_say("主角：令狐兄侠义心肠，不畏强权，令人好生敬仰。且救命之言不敢谈，实在是惭愧，在下武功低微，还承蒙莫大先生出手，唉……罢了罢了，不管这劳什子了。我要回去了，下次有机会的话，我请你喝酒。");
							script_say("令狐冲：好！一言为定！我等着你的酒！");
							script_say("主角：后会有期。");
						elseif sel==2 then
							script_say("令狐冲：刚刚费彬要杀我，你出言相阻，令狐冲承你的情了。");
							script_say("主角：只是想不到费彬此人，如此卑鄙。");
							script_say("令狐冲：好在有莫师伯相救。我还有事要回华山，就此别过！");
							script_say("主角：后会有期。");
						end
						Dark();
							SetS(5,30,21,1,0);
						Light();
						SetFlag(12006,2);
					else
						return true;
					end
				end,
			}
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

						--say("")SceneEvent[57]={};--华山派各事件
SceneEvent[57]={
				[1]=function()--门卫
					--暂时不考虑华山公敌
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						local d=JY.Base["人方向"];
						if d==2 then
							say("阁下造访华山，不知有何贵干？",20);
						else
							say("少侠慢走，恕不远送。",20);
						end
						local menu={
												{"进入",nil,1},
												{"拜师",nil,1},
												{"离开",nil,1},
												{"灭门",nil,0},
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
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							say("我华山景色优美，尤其莲花峰有“石作莲花云作台”之誉，阁下若是有暇，不妨多四处走走。",20);
							Dark();
							JY.Base["人X1"]=45;
							Light();
						elseif r==2 then
							say("我这便向师尊通禀，小兄弟请随我来。",20);
							Dark();
							JY.Base["人X1"]=22;
							JY.Base["人Y1"]=28;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("我华山门规极严，若有违反，按情节轻重处罚，罪大恶极者立斩不赦。你可愿意？",1);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入华山派？",C_WHITE,CC.Fontbig) then
									say("师父在上，请受徒儿一拜！");
									say("好徒儿，你既拜入我华山派，还望你谨守门规，行侠仗义，好好发扬我华山派门风。Ｐ你若在武学上有什么疑问，可以向你三师兄梁发多多请教。",1);
									say("是！");
									JY.Person[0]["门派"]=0;
									JY.Shop[0]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ华山派",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="华山弟子";
									GetItem(0,1);
								else
									say("既然如此，那此事就此作罢吧。",1);
								end
							else
								say("你这种江湖匪类，也想拜入我华山门墙！",1);
							end
						elseif r==3 then
							say("下次有空，不妨再来华山看看。",20);
							Dark();
							JY.Base["人X1"]=47;
							Light();
						elseif r==4 then
							if DrawStrBoxYesNo(-1,-1,"是否真的要攻击华山派？",C_WHITE,CC.Fontbig) then
								say("狗贼，这是什么地方，你也不擦亮眼好好瞧瞧？",20);
								--Fight
								SetFlag(1000,1);
							else
								say("看你脸色不大好，没事吧？",20);
							end
						elseif r==5 then
							say("阁下既然无事，请不要在此逗留。",20);
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
							if d==2 then
								menu[6][3]=0;
							else
								menu[5][3]=0;
							end
							local r=ShowMenu(menu,7,0,0,0,0,0,1,0);
							if r==1 then
								--say("师父对门规最看重了，真怕哪天被他抓住痛骂。",JY.Da);
								RandomEvent(JY.Da);
							elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("好啊，咱俩来玩玩。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(47,28,1,1840);
									SetWarMap(47,29,1,1840);
									SetWarMap(47,30,1,1840);
									SetWarMap(47,31,1,1840);
									SetWarMap(26,28,1,2274);
									SetWarMap(26,29,1,2274);
									SetWarMap(26,30,1,2274);
									SetWarMap(36,19,1,2268);
									SetWarMap(37,19,1,2268);
									SetWarMap(38,19,1,2268);
								end
								local result=vs(0,38,38,JY.Da,33,35,300);
								--[[SetWarMap(47,28,1,1842);
								SetWarMap(47,29,1,0);
								SetWarMap(47,30,1,0);
								SetWarMap(47,31,1,1838);
								SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(36,19,1,2266);
								SetWarMap(37,19,1,0);
								SetWarMap(38,19,1,2270);]]--
								Cls();
								ShowScreen();
								if result then
									say("想不到师弟入门没几日，武功便如此了得，吾自愧不如。",JY.Da);
								else
									say("师弟你这几招应当如此这般……下去多练练，咱们下次再切磋切磋。",JY.Da);
								end
								DayPass(1,0);
							elseif r==3 then
								PersonStatus(JY.Da);
							elseif r==4 then
								--say("多谢师弟美意，可惜愚兄职责所在，不敢擅离啊。",JY.Da);
								E_guarding(JY.Da);
							elseif r==5 then
								say("师弟请进。",JY.Da);
								Dark();
								JY.Base["人X1"]=45;
								Light();
							elseif r==6 then
								say("江湖险恶，师弟多加小心。",JY.Da);
								Dark();
								JY.Base["人X1"]=47;
								Light();
							elseif r==7 then
								say("师弟若是无事，来聊聊天或者切磋下武功也好啊。",JY.Da);
							end
						else
							say("师弟请。",20);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							Light();
						end
					end
				end,
				[2]=function()--掌门
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("此处乃我华山正气堂，少侠如果无事，请去外面游玩。",JY.Da);
					else
						if GetFlag(12005)==0 and JY.Person[0]["体力"]>30 and GetFlag(10004)~=0 and GetFlag(16001)==2 then
							SetFlag(12005,1);
							say("衡山刘正风这几日就要金盆洗手退出江湖。你若无事最好也去参加观礼吧。",JY.Da);
							say("是！");
							return;
						end
						say("参见师父！");
						say("徒儿何事？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("世人皆言我华山剑法出众，殊不知我华山武功讲究以气御剑。气为主，剑为次。你修炼武功切切不可忘一味贪图练剑，否则入了魔道，就再难回头了。",1);
							RandomEvent(JY.Da);
						elseif r==2 then
							if JY.Db==1 or JY.Person[0]["等级"]>10 then
								local kflist={
													{1,10},
													{5,10,1},
													{10,10},
													{11,10,1},
													{13,10},
													{18,10,2},
													{15,10},
													{16,10,1},
													--{85,10},
													--{86,10},
													};
								LearnKF(0,JY.Da,kflist);
							else
								say("你的基本功火候不足，不要好高骛远，先向你三师兄请教吧。",JY.Da);
							end
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("你的武功还需多加练习，去找你师兄们切磋吧。",JY.Da);
							else
								say("好，只管出招吧，让为师看看你的武功有无进步。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(26,28,1,2274);
									SetWarMap(26,29,1,2274);
									SetWarMap(26,30,1,2274);
									SetWarMap(21,24,1,2268);
									SetWarMap(22,24,1,2268);
									SetWarMap(23,24,1,2268);
									SetWarMap(21,34,1,1708);
									SetWarMap(22,34,1,1708);
									SetWarMap(23,34,1,1708);
								end
								local result=vs(0,24,28,1,21,28,2000);
								--[[SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(21,24,1,2266);
								SetWarMap(22,24,1,0);
								SetWarMap(23,24,1,2270);
								SetWarMap(21,34,1,1710);
								SetWarMap(22,34,1,0);
								SetWarMap(23,34,1,1712);]]--
								Cls();
								ShowScreen();
								if result then
									say("这几招使得不错，大有进步，不过记得要戒骄戒躁，继续努力。",JY.Da);
								else
									say("好好努力，不要堕了我华山威名。",JY.Da);
								end
								--SetFlag(1,GetFlag(1)+1);
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("没事就去好好练功，不要四处闲逛。须知少壮不努力，老大徒伤悲。",JY.Da);
						end
					end
				end,
				[3]=function()--禁止进入内室
					if JY.Person[0]["性别"]~=1 then
						if JY.Person[0]["门派"]~=0 then	--非华山弟子
							say("里面是岳掌门夫妇内宅，世俗礼教男女大防，我还是不要乱闯比较好。");
							walkto_old(0,-1);
						else
							if GetFlag(10003)==2 then
								return true
							elseif  GetFlag(10003)~=1 then
								say("里面是师娘居住的内宅，乱闯会被师父骂死的，还是赶紧走比较好。");
								walkto_old(0,-1);
							else
								say("里面是师娘居住的内宅吧。");
								SetFlag(10003,2)
							end
						end
					end
				end,
				[4]=function()--室外，练武场
					--Menpaibiwu(2)
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("武学之道，在于坚持不懈的锻炼。",20);
					else
						say("这里是练武场，师弟要一起练武吗？",20);
						E_training(20);
					end
				end,
				[5]=function()--室外
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("欢迎少侠来我华山做客。",20);
					elseif JY.Da>0 then
						say("师父对门规最看重了，真怕哪天被他抓住痛骂。",JY.Da);
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
								SetWarMap(47,28,1,1840);
								SetWarMap(47,29,1,1840);
								SetWarMap(47,30,1,1840);
								SetWarMap(47,31,1,1840);
								SetWarMap(26,28,1,2274);
								SetWarMap(26,29,1,2274);
								SetWarMap(26,30,1,2274);
								SetWarMap(36,19,1,2268);
								SetWarMap(37,19,1,2268);
								SetWarMap(38,19,1,2268);
							end
								local result=vs(0,38,38,JY.Da,33,35,500);
								--[[SetWarMap(47,28,1,1842);
								SetWarMap(47,29,1,0);
								SetWarMap(47,30,1,0);
								SetWarMap(47,31,1,1838);
								SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(36,19,1,2266);
								SetWarMap(37,19,1,0);
								SetWarMap(38,19,1,2270);]]--
							Cls();
							ShowScreen();
							if result then
								say("想不到师弟入门没几日，武功便已如此了得，吾自愧不如。",JY.Da);
							else
								say("师弟你这几招应当如此这般……下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							--SetFlag(1,GetFlag(1)+1);
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("师弟若是无事，来聊聊天或者切磋下武功也好啊。",JY.Da);
						end
					else
						say("拳出少林，剑归华山。Ｈ这句话就是说少林派拳法最为了得，但要是说起天下第一的剑术，那就非我华山莫属了。",20);
					end
				end,
				[6]=function()--厨房
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("这里是厨房，没什么好看的。",20);
					elseif JY.Da>0 then
						if GetFlag(10005)==1 then
							if GetFlag(10006)==1 then
								if GetFlag(1)-lib.GetD(JY.SubScene,JY.CurrentD,4)<7 then
									say("赶紧给大师兄送去吧。",JY.Da);
								else
									say("都这么久了，你怎么还不给大师兄送饭！",JY.Da);
								end
							elseif GetFlag(1)-lib.GetD(JY.SubScene,JY.CurrentD,4)>GetFlag(10006) then
								say("给大师兄的饭菜已经做好了，你帮忙给送去吧！",JY.Da);
								lib.SetD(JY.SubScene,JY.CurrentD,4,GetFlag(1));
								if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
									say("好，把饭菜给我吧。");
									SetFlag(10006,1);
									return;
								else
									say("我还有事在身。");
									say("那我找其他人吧。",JY.Da);
									SetFlag(10006,7);
								end
							end
						end
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
						say("你别站这里添乱好不好，被师父看到骂死你。",20);
					end
				end,
				[7]=function()--禁止进入后山
					say("这里是通往华山后山的路，山路崎岖，还是不要过去比较好。",20);
					if GetFlag(10005)==0 then
						return;
					end
					if JY.Person[0]["门派"]==0 then	--华山弟子
						local menu={
												{"聊天",nil,0},
												{"进入",nil,1},
												{"切磋",nil,0},
												{"状态",nil,0},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==2 then
							if GetFlag(10006)==1 then
								say("我是去给大师兄送饭菜的。");
								say("山路崎岖，请小心。",20);
							else
								say("山路崎岖，请小心。",20);
							end
							Dark();
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1]*2;
							Light();
						end
					end
				end,
				[8]=function()--学武
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("阁下是要拜入我华山派吗？",20);
						say("我只是来随便转转。");
					elseif JY.Db==0 then
						say("你就是师父刚收的弟子吗？",JY.Da);
						say("正是，师父叫我来向师兄你学武。");
						say("好，我先传你一套华山入门武功吧。",JY.Da);
						Dark();
						Light();
						local add,str=AddPersonAttrib(0,"修炼点数",500);
						DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
						while JY.Person[0]["外功"..1]==0 do
							local kflist={
												{1,6},
												{9,6},
												};
							LearnKF(0,JY.Da,kflist);
						end
						say("多谢师兄指点。");
						say("这只是入门功夫而已，更多高深的本事还要靠你自己努力啊",JY.Da);
						lib.SetD(JY.SubScene,22,4,1);
						--JY.Person[0]["生命"]=500;
						--JY.Person[0]["生命最大值"]=500;
						--JY.Person[0]["生命Max"]=500;
						--JY.Person[0]["内力"]=500;
						--JY.Person[0]["内力最大值"]=500;
						--JY.Person[0]["内力Max"]=500;
						--JY.Person[0]["攻击"]=100;
						--JY.Person[0]["防御"]=100;
					elseif JY.Da>0 then
						say("师弟是来学武的吗？",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							--say("有闲聊的时间你还不如去练武场练功呢。",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
							local kflist={
												{1,6},
												{9,10},
												{10,6},
												{13,6},
												{15,6},
												};
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							say("好啊，咱俩来玩玩。",JY.Da);
							ModifyWarMap=function()
								SetWarMap(26,28,1,2274);
								SetWarMap(26,29,1,2274);
								SetWarMap(26,30,1,2274);
								SetWarMap(21,24,1,2268);
								SetWarMap(22,24,1,2268);
								SetWarMap(23,24,1,2268);
								SetWarMap(21,34,1,1708);
								SetWarMap(22,34,1,1708);
								SetWarMap(23,34,1,1708);
							end
								local result=vs(0,24,28,JY.Da,21,28,800);
								--[[SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(21,24,1,2266);
								SetWarMap(22,24,1,0);
								SetWarMap(23,24,1,2270);
								SetWarMap(21,34,1,1710);
								SetWarMap(22,34,1,0);
								SetWarMap(23,34,1,1712);]]--
							Cls();
							ShowScreen();
							if result then
								if JY.Db==1 then
									say("师弟你的基础功夫已经有一定火候，我看可以去向师父请教更高深的武功了。",JY.Da);
									lib.SetD(JY.SubScene,22,4,2);
									lib.SetD(JY.SubScene,1,4,1);
								else
									say("想不到师弟入门没几日，武功便已如此了得。",JY.Da);
								end
							else
								say("师弟你这几招应当如此这般……下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							--SetFlag(1,GetFlag(1)+1);
							DayPass(1);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("师弟闲着没事就去练功吧，被师父看到你闲逛又要骂了。",JY.Da);
						end
					else
						say("看到这句话，说明游戏哪里肯定出了问题，最大的可能就是你修改了。",20);
					end
				end,
				[9]=function()--正气堂门口
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("此乃华山正气堂，阁下如果是要找家师，便请进吧。",20);
					elseif JY.Da>0 then
						say("此处是我华山正气堂，师弟若是无事，请不要在此逗留。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							--say("师父就在里面，还是不要闲聊了吧",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("好啊，咱俩来玩玩。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(47,28,1,1840);
									SetWarMap(47,29,1,1840);
									SetWarMap(47,30,1,1840);
									SetWarMap(47,31,1,1840);
									SetWarMap(26,28,1,2274);
									SetWarMap(26,29,1,2274);
									SetWarMap(26,30,1,2274);
									SetWarMap(36,19,1,2268);
									SetWarMap(37,19,1,2268);
									SetWarMap(38,19,1,2268);
								end
								local result=vs(0,38,38,JY.Da,33,35,300);
								--[[SetWarMap(47,28,1,1842);
								SetWarMap(47,29,1,0);
								SetWarMap(47,30,1,0);
								SetWarMap(47,31,1,1838);
								SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(36,19,1,2266);
								SetWarMap(37,19,1,0);
								SetWarMap(38,19,1,2270);]]--
							Cls();
							ShowScreen();
							if result then
								say("想不到师弟入门没几日，武功便已如此了得。",JY.Da);
							else
								say("师弟你这几招应当如此这般……下去多练练，咱们下次再切磋切磋。",JY.Da);
							end
							--SetFlag(1,GetFlag(1)+1);
							DayPass(1);
						elseif r==3 then
							PersonStatus(JY.Da);
						elseif r==4 then
						end
					else
						say("这里是我华山正气堂，之所以取这名字，是因为我华山武学，「气」才是根本。武学正道，在于以气御剑。",20);
					end
				end,
				[10]=function()--休息
					if JY.Person[0]["门派"]==0 then
						local menuItem=	{
														{"休息",nil,1},
														{"拜访",nil,1},
														{"没事",nil,2},
													}
						local r=EasyMenu(menuItem);
						if r==1 then
							if rest() then
								say("一张一弛，文武之道。休息够了，继续努力吧。");
							end
						elseif r==2 then
							visit(0);
						end
					else
						visit(0);
					end
					walkto_old(-2,0);
				end,
				[11]=function()--讲武堂
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("师父每月初一十五都会来此给大家指导武功，师弟……啊，你不是我华山派的啊，不好意思。",20);
					else
								if JY.Person[0]["体力"]<30 then
									say("你来得正好，师傅正要给我们指导武功呢。啊！你气色怎么这么差，这次就算了吧，还是养好身体要紧。",JY.Da);
									return;
								end
						local day=GetFlag(1)%30;
						if day==0 or day==14 then
							Dark();
							ModifyWarMap=function()
								SetWarMap(21,24,1,2268);
								SetWarMap(22,24,1,2268);
								SetWarMap(23,24,1,2268);
							end
							SetWarMap(20,18,1,5958);
							SetWarMap(21,16,1,5184);
							SetWarMap(22,16,1,5184);
							SetWarMap(23,16,1,5184);
							SetWarMap(24,16,1,5184);
							SetWarMap(21,20,1,5184);
							SetWarMap(22,20,1,5184);
							SetWarMap(23,20,1,5184);
							SetWarMap(24,20,1,5184);
							SetWarMap(21,18,1,5184);
							SetWarMap(22,18,1,5184);
							SetWarMap(23,18,1,5184);
							SetWarMap(24,18,1,5184);
							Light();
							say("大家都不用顾忌，拿出真本事来，让为师看看你们的武功进展如何。",1);
							say("是！请师父指点。",20);
							SetWarMap(20,18,1,0);
							SetWarMap(21,16,1,0);
							SetWarMap(22,16,1,0);
							SetWarMap(23,16,1,0);
							SetWarMap(24,16,1,0);
							SetWarMap(21,20,1,0);
							SetWarMap(22,20,1,0);
							SetWarMap(23,20,1,0);
							SetWarMap(24,20,1,0);
							SetWarMap(21,18,1,0);
							SetWarMap(22,18,1,0);
							SetWarMap(23,18,1,0);
							SetWarMap(24,18,1,0);
							FIGHT(
										5,1,
										{
											0,	24,22,
											10,24,20,
											11,24,18,
											12,24,16,
											13,24,14,
										},
										{
											1,20,18,
										},
										5000,1
									);
							--[[SetWarMap(21,24,1,2266);
							SetWarMap(22,24,1,0);
							SetWarMap(23,24,1,2270);]]--
							Cls();
							ShowScreen();
							say("谢师父指点。",20)
							--SetFlag(1,GetFlag(1)+1);
							DayPass(1);
						else
							if JY.Da>0 then
								say("师父每月初一十五都会来这里给大家指导武功，师弟千万别错过啊。",JY.Da);
								local menu={
													{"聊天",nil,1},
													{"切磋",nil,1},
													{"状态",nil,1},
													{"没事",nil,1},
													};
								local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
								if r==1 then
									say("每次师父指点武功后，我都会感觉豁然开朗，要是师父天天都来指导就好了。",JY.Da);
								elseif r==2 then
									if JY.Person[0]["体力"]<30 then
										say("我看你气色不太好，还是先好好休息吧。",JY.Da);
										return;
									end
									say("好啊，师弟请指教。",JY.Da);
									ModifyWarMap=function()
										SetWarMap(21,24,1,2268);
										SetWarMap(22,24,1,2268);
										SetWarMap(23,24,1,2268);
									end
									local result=vs(0,21,22,JY.Da,21,13,400);
									--[[SetWarMap(21,24,1,2266);
									SetWarMap(22,24,1,0);
									SetWarMap(23,24,1,2270);]]--
									Cls();
									ShowScreen();
									if result then
										say("师弟好功夫。",JY.Da);
									else
										say("师弟别灰心，以后多学多练，武功自然就会好起来。",JY.Da);
									end
									--SetFlag(1,GetFlag(1)+1);
									DayPass(1);
								elseif r==3 then
									PersonStatus(JY.Da);
								elseif r==4 then
									say("师弟慢走。",JY.Da);
								end
							else
								say("师父每月初一十五都会来这里给大家指导武功，师弟千万别错过啊。",20);
							end
						end
					end
				end,
				[12]=function()--木桩
					if JY.Person[0]["门派"]~=0 then	--非华山弟子
						say("抓紧练功。",20);
					elseif JY.Da>0 then
						say("天天打木人桩，好生无趣，真想找个人对练啊。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						local r=ShowMenu(menu,4,0,0,0,0,0,1,0);
						if r==1 then
							--say("为什么没人来陪我练功呢？",JY.Da);
							RandomEvent(JY.Da);
						elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("好啊，一天到晚打木头人，我早就烦死了。",JY.Da);
								ModifyWarMap=function()
									SetWarMap(47,28,1,1840);
									SetWarMap(47,29,1,1840);
									SetWarMap(47,30,1,1840);
									SetWarMap(47,31,1,1840);
									SetWarMap(26,28,1,2274);
									SetWarMap(26,29,1,2274);
									SetWarMap(26,30,1,2274);
									SetWarMap(36,19,1,2268);
									SetWarMap(37,19,1,2268);
									SetWarMap(38,19,1,2268);
								end
								local result=vs(0,38,38,JY.Da,33,35,100);
								--[[SetWarMap(47,28,1,1842);
								SetWarMap(47,29,1,0);
								SetWarMap(47,30,1,0);
								SetWarMap(47,31,1,1838);
								SetWarMap(26,28,1,2276);
								SetWarMap(26,29,1,0);
								SetWarMap(26,30,1,2272);
								SetWarMap(36,19,1,2266);
								SetWarMap(37,19,1,0);
								SetWarMap(38,19,1,2270);]]--
							Cls();
							ShowScreen();
							if result then
								say("看来打木头人没什么用啊，还是得实战呢。",JY.Da);
							else
								say("哈～原来我的武功这么厉害了啊。",JY.Da);
							end
							--SetFlag(1,GetFlag(1)+1);
							DayPass(1);
						elseif r==3 then
							PersonStatus(JY.Da);
						elseif r==4 then
							say("既然没事，我就继续练功了。",JY.Da);
						end
					else
						say("魔教是武林的公敌，与我五岳剑派恩怨更深。师弟一定要好好练功，消灭魔教！",20);
					end
				end,
				[13]=function()	--宁中则
					if JY.Person[0]["门派"]~=0 then
						say("你是什么人？速速离开！",JY.Da);
					else
						say("师娘好。");
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
							say("想学什么呢？",JY.Da);
							local kflist;
							if GetFlag(10002)~=2 then
								kflist={
											{1,10},
										};
							else
								kflist={
											{1,10},
											{3,10},
											{4,10,1},
										};
							end
							if GetFlag(10017)==1 then
								for i=1,10 do
									if kflist[i]==nil then
										kflist[i]={83,10};
										break;
									end
								end
							end
							LearnKF(0,JY.Da,kflist);
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<5 then
								say("你的武功还需多加练习，去找你师兄们切磋吧。",JY.Da);
							else
								say("这里空间太小了，我们去演武堂吧",JY.Da);
								ModifyWarMap=function()
									SetWarMap(21,24,1,2268);
									SetWarMap(22,24,1,2268);
									SetWarMap(23,24,1,2268);
								end
								local result=vs(0,21,22,JY.Da,21,13,800);
								--[[SetWarMap(21,24,1,2266);
								SetWarMap(22,24,1,0);
								SetWarMap(23,24,1,2270);]]--
								Cls();
								ShowScreen();
								if result then
									say("这几招使得不错，大有进步，不过记得要戒骄戒躁，继续努力。",JY.Da);
								else
									say("好好努力，不要堕了我华山威名。",JY.Da);
								end
								--SetFlag(1,GetFlag(1)+1);
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("没事就去好好练功，不要四处闲逛。须知少壮不努力，老大徒伤悲。",JY.Da);
						end
					end
				end,
				[14]=function()	--正气堂入口
					if GetFlag(10005)==0 and GetFlag(16003)~=0 then
						--林平之入门
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,30);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,26);	--宁
							SetS(57,23,27,1,4256*2);	--令狐
							SetS(57,23,29,1,4685*2);	--平之
						Light();
						if JY.Person[0]["门派"]==0 then
							say("啊，师傅正在收徒呢。");
							SmartWalk(22,25,3);
						else
							say("华山派似乎有什么仪式，我且在一旁旁观吧。");
						end
						DrawStrBoxWaitKey("Ｏ岳不群Ｗ在香案前磕头祷告");
						say("弟子岳不群，今日收录福州林平之为徒，愿列代祖宗在天之灵庇，教林平之用功向学，洁身自爱，恪守本派门规，不让堕了华山派的声誉。",1);
						say("林平之，你今日入我华山派门下，须得恪守门规，若有违反，按情节轻重处罚，罪大恶极者立斩不赦。本派立足武林数百年，武功上虽然也能和别派互争雄长，但一时的强弱胜败，殊不足道。真正要紧的是，本派弟子人人爱惜师门令誉，这一节你须好好记住了。",1);
						say("是，弟子谨记师父教训。",136);
						if JY.Person[0]["门派"]==1 then
							say("林平之！他已经拜入华山派，看来不好对他下手了。");
						end
						say("令狐冲，背诵本派门规，好教林平之得知。",1);
						say("是，林师弟，你听好了。本派首戒欺师灭祖，不敬尊长。二戒恃强欺弱，擅伤无辜。三戒奸淫好色，调戏妇女。四戒同门嫉妒，自相残杀。五戒见利忘义，偷窃财物。六戒骄傲自大，得罪同道。七戒滥交匪类，勾结妖邪。这是华山七戒，本门弟子，一体遵行。",8);
						say("是，小弟谨记大师哥所揭示的华山七戒，努力遵行，不敢违犯。",136);
						say("好了，就是这许多。本派不像别派那样，有许许多多清规戒律。你只须好好遵行这七戒，时时记得仁义为先，做个正人君子，师父师娘就欢喜得很了。",1);
						say("是！",136);
						say("本门之中，大家亲如家人，不论哪一个有事，人人都是休戚相关，此后不须多礼。",1);
						say("平儿，咱们先给你父母安葬了，让你尽了人子的心事，这才传授本门的基本功夫。",2);
						say("多谢师父、师娘。",136);
						say("好了，平之你且退下吧。",1);
						say("是！",136);
						Dark();
							SetS(57,23,29,1,0);	--平之
							SetS(57,23,25,1,4262*2);	--平之
						Light();
						say("冲儿，你这次下山，犯了华山七戒的多少戒条？",1);
						say("弟子知罪了，弟子不听师父、师娘的教诲，犯了第六戒骄傲自大，得罪同道的戒条，在衡山回雁楼上，杀了青城派的罗人杰。",8);
						say("哼！",1);
						say("爹，那是罗人杰来欺侮大师哥的。当时大师哥和田伯光恶斗之后，身受重伤，罗人杰乘人之危，大师哥岂能束手待毙？",14);
						say("不要你多管闲事，这件事还是由当日冲儿足踢两名青城弟子而起。若无以前的嫌隙，那罗人杰好端端地，又怎会来乘冲儿之危？",1);
						say("大师哥足踢青城弟子，你已打了他三十棍，责罚过了，前帐已清，不能再算。大师哥身受重伤，不能再挨棍子了。",14);
						say("此刻是论究本门戒律，你是华山弟子，休得胡乱插嘴。",1);
						say("罗人杰乘你之危，大加折辱，你宁死不屈，原是男子汉大丈夫义所当为，那也罢了。可是你怎地出言对恒山派无礼，说甚么‘一见尼姑，逢赌必输’？又说连我也怕见尼姑？",1);
						say("爹！",14);
						say("弟子当时只想要恒山派的那个师妹及早离去。弟子自知不是田伯光的对手，无法相救恒山派的那师妹，可是她顾念同道义气，不肯先退，弟子只得胡说八道一番，这种言语听在恒山派的师伯、师叔们耳中，确是极为无礼。",8);
						say("你要仪琳师侄离去，用意虽然不错，可是甚么话不好说，偏偏要口出伤人之言？总是平素太过轻浮。这一件事，五岳剑派中已然人人皆知，旁人背后定然说你不是正人君子，责我管教无方。",1);
						say("是，弟子知罪。",8);
						say("那费彬要杀曲洋，你为何要插手！",1);
						say("师傅！弟子只是见费彬用卑劣的手段杀害刘正风满门，一时激于义愤，才——",8);
						say("费彬所为，固然宁人不齿，但是终究是刘正结交魔教在先。那曲洋乃魔教贼子，故意结交我五岳中人，暗中挑拨离间，刘正风是何等精明能干之人，却也不免着了人家的道儿，到头来闹得身败名裂，家破人亡。魔教这等阴险毒辣的手段，是你亲眼所见。冲儿，我瞧你于正邪忠奸之分这一点上，已然十分胡涂了。此事关涉到你以后安身立命的大关节，这中间可半分含糊不得。",1);
						say("师傅所言甚是，回想起当日所为，实在不该。",8);
						say("冲儿，此事关系到我华山一派的兴衰荣辱，也关系到你一生的安危成败，你不可对我有丝毫隐瞒。我只问你，今后见到魔教中人，是否嫉恶如仇，格杀无赦？",1);
						say("这——如果魔教众人为非作歹，我自当诛之，但若是——",8);
						say("罢了，这时就算勉强要你回答，也是无用。你此番下山，大损我派声誉，罚你面壁一年，将这件事从头至尾好好的想一想。",1);
						say("是，弟子恭领责罚。",8);
						say("面壁一年？那么这一年之中，每天面壁几个时辰？",14);
						say("甚么几个时辰？每日自朝至晚，除了吃饭睡觉之外，便得面壁思过。",1);
						say("那怎么成？岂不是将人闷也闷死了？难道连大小便也不许？",14);
						say("女孩儿家，说话没半点斯文！",2);
						say("面壁一年，有甚么希罕？当年你师祖犯过，便曾在这玉女峰上面壁三年零六个月，不曾下峰一步。",1);
						say("那么面壁一年，还算是轻的了？其实大师哥说‘一见尼姑，逢赌必输’，全是出于救人的好心，又不是故意骂人！",14);
						say("正因为出于好心，这才罚他面壁一年，要是出于歹意，我不打掉他满口牙齿、割了他的舌头才怪。",1);
						say("珊儿不要罗唆爹爹啦。大师哥在玉女峰上面壁思过，你可别去跟他聊天说话，否则爹爹成全他的一番美意，可全教你给毁了。",2);
						say("罚大师哥在玉女峰上坐牢，还说是成全哪！不许我去跟他聊天，那么大师哥寂寞之时，有谁给他说话解闷？这一年之中，谁陪我练剑？",14);
						say("你跟他聊天，他还面甚么壁、思甚么过？这山上多少师兄师姊，谁都可和你切磋剑术。",2);
						say("那么大师哥吃甚么呢？一年不下峰，岂不饿死了他？",14);
						say("你不用担心，自会有人送饭菜给他。",2);
						say("好了，令狐冲你去吧。",1);
						say("是。",8);
						SetFlag(10005,1);
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,24);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,44);	--宁
							ModifyD(57,16,-2,-2,-2,24,-2,-2,-2,-2,-2,-2,-2);	--厨房
							SetS(57,23,27,1,0);	--令狐
							SetS(57,23,25,1,0);	--平之
							ModifyD(57,30,1,-2,5,136,0,5862,5886,5862,3,-2,-2);	--平之
							--SetS(57,27,29,3,-1);	--关闭华山·平之拜师·令狐面壁事件
							ModifyD(81,0,1,-2,1,8,-2,4256*2,4256*2,4256*2,-2,-2,-2);
						Light();
					elseif JY.Person[0]["门派"]==0 and GetFlag(10007)==0 and GetFlag(16003)~=0 and GetFlag(1)-GetFlag(16004)>90 then
						--下山·分支
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,30);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,26);	--宁
							SetS(57,21,31,1,2591*2);
							SetS(57,22,31,1,2591*2);
							SetS(57,23,31,1,2591*2);
							SetS(57,22,25,1,2590*2);
						Light();
						say("怎么大家都在正气堂里？师傅似乎有什么事情要宣布。");
						SmartWalk(23,25,3);
						say("近日来江湖上恶名昭著的贼人田伯光屡屡在我华山境内犯案，身为武林正派，我们华山不能置之不理。此次下山，除了拿贼之外，我们也意欲练兵。闭门造车不可为，你们习武多年，如今正是检验的时候了。也好让你们见识一下江湖，免得夜郎自大。",1);
						say("是，师傅！。",24);
						SetFlag(10010,GetFlag(1));
						if DrawStrBoxYesNo(-1,-1,"是否下山？") then
							say("师傅，我们都下山了，那大师兄他……",13);
							say("嗯。冲儿在受罚，自是不能同去。只是，这样就须得有人留下了……",1);
							say("师傅，弟子武功低微，自思此去也无法达到师傅的要求。所以斗胆恳请师傅让我留下，每日给大师兄送饭。",13);
							say("习武之人怎可如此妄自菲薄！？不过，难得你们手足情深，我便允了。切记不可带酒。",1);
							say("是，师傅！",13);
							say("你这猴儿，嘴里答应的到快，只是到时候恐怕又只是一句空话吧。",1);
							say("呵呵……",13);
							say("哼！不象话！若是被我发现，你也上思过崖去吧。我们走。",1);
							SetFlag(10007,1);
						else
							say("师傅，大师兄仍在思过崖。弟子欲留下来每日送饭，求师傅应允。");
							say("难得你还记得冲儿，这件事，我替你师傅同意了。",2);
							say("嗯。不过，切记，只可送饭，不可带酒。他在思过崖本来是受罚的。若是带酒给他，哼哼!",1);
							say("是，师傅！（嘴上先这么说着，反正到时候师傅也看不到。）");
							say("大师兄的饭就麻烦你了。还有，我为大师兄准备了一些“好菜”，放在灶台左边的锅里用盖子焖上了。麻烦你到时候取出来送给大师兄。",13);
							say("师兄放心，我自省得。");
							SetFlag(10007,2);
							ModifyD(81,0,-2,-2,2,-2,-2,3812*2,3827*2,3812*2,3,-2,-2);	--修改令狐练剑
						end
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,24);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,44);	--宁
							SetS(57,21,31,1,0);
							SetS(57,22,31,1,0);
							SetS(57,23,31,1,0);
							SetS(57,22,25,1,0);
							--众人消失
							ModifyD(57,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,1);
							ModifyD(57,1,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,2);
							ModifyD(57,17,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,3);
							ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,4);
							ModifyD(57,26,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,5);
							ModifyD(57,6,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,6);
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,7);
							ModifyD(57,23,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,8);
							ModifyD(57,24,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,9);
							ModifyD(57,15,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,10);
							ModifyD(57,16,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,11);
							ModifyD(57,27,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,12);
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,13);
							ModifyD(57,30,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,14);
							ModifyD(57,2,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,15);
							ModifyD(57,29,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,16);
							ModifyD(57,3,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,17);
							ModifyD(57,4,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,18);
							ModifyD(57,18,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,19);
							ModifyD(57,19,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,20);
							ModifyD(57,20,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,21);
							ModifyD(57,21,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,22);
							SetS(57,52,29,3,201);
							SetS(57,52,30,3,201);
							SetS(57,30,13,3,202);
							SetS(57,31,13,3,202);
							SetS(62,50,25,3,201);
							SetS(62,50,26,3,201);
						Light();
					elseif GetFlag(10015)==0 and GetFlag(10013)>0 then	--剑宗上山
						SetFlag(10015,1);
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,30);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,26);	--宁
							ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,1);	--梁发
							SetS(57,21,31,1,2591*2);
							SetS(57,22,31,1,4706*2);
							if JY.Person[0]["门派"]==0 then
								SetS(57,23,25,1,4267*2);
							else
								SetS(57,23,31,1,2591*2);
							end
							SetS(57,21,25,1,4267*2)
							SetS(57,22,25,1,4271*2)
							SetS(57,23,25,1,2602*2)
						Light();
						if JY.Person[0]["门派"]==0 then
							SmartWalk(23,31,0);
						else
							SmartWalk(23,25,3);
						end
						say("岳师兄，贵派门户之事，我们外人本来不便插嘴。只是我五岳剑派结盟联手，共荣共辱，要是有一派处事不当，为江湖同道所笑，其余四派共蒙其羞。适才尊夫人说我嵩山派不该多管闲事，这话未免不对了。",112);
						say("（原来他们还在争执，并没有得手。）既然知道不便插嘴，为何还要多事？这岂不是自打嘴巴？",8);
						say("何人放肆！",112);
						say("冲儿！等此间事了再找你算私自下崖之账。还不向陆师兄赔礼。",1);
						say("哦。陆师叔对不起了。你们剑宗，想入我华山，可以。先向我这个大师兄行礼吧。",8);
						say("岳师兄，你就是如此管教弟子的么？快步的我在中天山也听闻华山落寞之言。",3);
						say("冲儿率性而为，见人说话，多有得罪之处，还望见谅。",1);
						say("你！算了，意气之言，不争也罢。你还是乖乖的把掌门之位让出来吧。",3);
						say("掌门一位，由先师所传，非我门下，不得下授。恕难从命。",1);
						say("不过你若拜入我师门下，还能跟我一争。",8);
						say("冲儿，休得无礼。",1);
						say("哼！",3);
						if JY.Person[0]["门派"]==0 then
							say("这掌门一位，须名至实归。若是不能服众，如何做得了掌门？");
							say("那依陆师兄之意？",1);
							say("比剑，胜者入主华山。");
						else
							say("这掌门一位，须名至实归。若是不能服众，如何做得了掌门？",112);
							say("那依阁下之意？",1);
							say("比剑，胜者入主华山。",112);
						end
						say("这……",8);
						say("好！不过，那谁谁谁想挑战我师父，先问过我这华山大师兄吧！",8);
						say("好！好！好！我念你年少，再三忍让！如今你自己跳出来，那就休怪我无情了！",3);
						say("你本就不坏好意，何来无情之言？你若想当掌门，拜入我师父门下，称我一声大师兄，然后兢兢业业的伺候好我华山上下才是正途。",8);
						say("竖子找死！",3);
						--fight
						ModifyWarMap=function()
							SetWarMap(21,31,1,0);
							SetWarMap(22,31,1,0);
							SetWarMap(23,31,1,0);
							SetWarMap(21,25,1,0);
							SetWarMap(22,25,1,0);
							SetWarMap(23,25,1,0);
							SetWarMap(26,28,1,2274);
							SetWarMap(26,29,1,2274);
							SetWarMap(26,30,1,2274);
							SetWarMap(21,24,1,2268);
							SetWarMap(22,24,1,2268);
							SetWarMap(23,24,1,2268);
							SetWarMap(21,34,1,1708);
							SetWarMap(22,34,1,1708);
							SetWarMap(23,34,1,1708);
						end
						vs(8,24,28,3,21,28,500);
						say("罢了罢了……我自诩剑宗掌门，却连气宗弟子都斗不过，实乃可笑之至。",3);
						say("是极是极。你还是称我为大师兄，才是……啊！",8);
						say("封不平！你身为师叔，居然偷袭一个后辈！给我把命留下！",2);
						say("哼！",3);
						say("慢！封师兄，我称你一声师兄，实在是不想让我们彻底决裂。虽你我分气剑两宗，但都为华山传人，如此自相残杀，只怕是正合某些奸人心意。",1);
						say("哼！",112);
						say("你不必再说了。从今以后，我绝不再出中条山。",3);
						say("多谢师兄深明大义。",1);
						Dark();
							say_2("啊！",8);
							say_2("冲儿！",2);
							SetS(57,22,31,1,0);
							SetS(57,22,28,1,4224*2);
							SetS(57,21,28,1,3398*2);
							SetS(57,23,28,1,3401*2);
							SetS(57,22,27,1,3399*2);
							SetS(57,22,29,1,3400*2);
							SetS(57,24,27,1,3401*2);
							SetS(57,24,29,1,3401*2);
						Light();
						say("你就是令狐冲？",152);
						say("刚刚不是那女人叫他冲儿吗？",153);
						say("叫冲儿的一定就是令狐冲吗？",154);
						say("不叫令狐冲为甚么叫冲儿呢？",155);
						say("我们问问她不就好了吗？",156);
						say("女人，你叫的冲儿是令狐冲吗？",157);
						say("自然。你们想要做什么？",2);
						say("他是令狐冲。",157);
						say("那我们就没找错人了。",156);
						say("就是他没跑了。",155);
						say("但是他受伤了，跑不了了。",154);
						say("那怎么办？",153);
						say("我们先帮他疗伤好了。",152);
						Dark();
							say("冲儿！",2);
							SetS(57,22,28,1,0);
							SetS(57,21,28,1,0);
							SetS(57,23,28,1,0);
							SetS(57,22,27,1,0);
							SetS(57,22,29,1,0);
							SetS(57,24,27,1,0);
							SetS(57,24,29,1,0);
						Light();
						say("你们嵩山欺人太甚！挑拨剑宗闹事在前，指使邪道绑架我弟子在后，今天你们若是不把冲儿还来，我叫你们下不了华山！",2);
						say("岳师兄，此六人我嵩山并不认识。",112);
						say("内人一时气愤之言，当不得真。只是遭此一事，我华山恐有怠慢，还望师兄见谅。恕不远送。",1);
						say("告辞。",112);
						Dark();
							ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,24);	--灵姗
							ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,44);	--宁
							ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,21,25);	--梁发
							SetS(57,21,31,1,0);
							SetS(57,23,31,1,0);
							SetS(57,21,25,1,0);
							SetS(57,22,25,1,0);
							SetS(57,23,25,1,0);
						Light();
						if JY.Person[0]["门派"]==0 then
							--say("（观那剑宗之人剑法似乎比师傅还厉害。我是不是应该跟着去呢？）");
							--say("（此次华山剑宗上山背后之影昭然若见。左冷禅这番动作实不像是武林之福啊。");
							say("（大师兄被那六个怪人带走了，不知如何。我去看看吧。刚刚他们好像往后山去了。）");
						elseif JY.Person[0]["门派"]<0 then
							say("（观那剑宗之人剑法似乎比华山掌门还厉害）");
							--say("师兄放心，我自省得。");
							--say("师兄放心，我自省得。");
						end
						SetS(81,49,36,3,201);
						SetS(62,9,21,1,4707*2);
						SetS(62,9,21,3,211);
					else
						return true;
					end
				end,
				[201]=function()	--华山众人下山-大门
					if JY.Person[0]["门派"]==0 then
						if GetFlag(10007)==1 then
							say("师兄弟们都出发了，我还是赶紧搜寻田伯光去吧。");
							walkto_old(2,0);
						elseif GetFlag(10007)==2 then
							say("大师兄还在后山，我得给他送饭，不能下山。");
							walkto_old(-2,0);
						end
					else
						say("华山派怎么空无一人？真奇怪。");
						SetS(57,30,13,3,-1);
						SetS(57,31,13,3,-1);
					end
				end,
				[202]=function()	--“好菜”
					if JY.Person[0]["门派"]==0 then
						say("哈哈，果然如此。如此“好菜”，只怕大师兄又醉了。");
						SetFlag(10008,1)
					end
					SetS(57,30,13,3,-1);
					SetS(57,31,13,3,-1);
				end,
			}

						--say("")
						--[[
						封不平：那边的小友，跟了我们一路，难道是岳不群想要赶尽杀绝不成？
玩家：非也。小子刚刚观封师叔剑法绝妙，令人沉迷，难以自拔。遂尾随至此，只愿拜入师傅门下，习得上乘剑法。
封不平：哦？你愿意入我这败军门下？
玩家：胜败乃一时之争而已。我观那华山上下不过岳不群夫妇与令狐冲三人。其中岳不群乃伪君子，令狐冲只一浪子，妇人不言，二十年后，气宗无人，而我剑宗人人可为之敌。到时我剑宗自可卷土重来。
封不平：你这想法不错。只是，我冷了心，不愿多做争执。你若愿意，每月十五可来此寻我学习剑法。拜师之言休得再提。
玩家：是。
]]--SceneEvent[58]={};--衡山派各事件
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
						--say("")SceneEvent[6]={};
SceneEvent[6]={
				[200]=function()
					JY.SubScene=7
					JY.Base["人X1"],JY.Base["人Y1"]=31,59
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
				[201]=function()
					JY.SubScene=8
					JY.Base["人X1"],JY.Base["人Y1"]=4,27
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
			}SceneEvent[62]={};--破庙/华山剑宗各事件
SceneEvent[62]={
				[211]=function()--令狐冲normal
					say("那边的小友，跟了我们一路，不知有何见教？",3);
					say("小子刚刚观封大师剑法绝妙，令人沉迷，难以自拔。遂尾随至此，只愿拜入师傅门下，习得上乘剑法。");
					say("哦？你愿意入我这败军门下？",3);
					say("胜败乃一时之争而已。我观那华山上下不过岳不群夫妇与令狐冲三人。其中岳不群乃伪君子，令狐冲只一浪子，妇人不言，二十年后，气宗无人，而我剑宗人人可为之敌。到时我剑宗自可卷土重来。");
					say("你这想法不错。只是，我冷了心，不愿多做争执。你若愿意，可来此寻我学习剑法。拜师之言休得再提。",3);
					say("是。");
					SetS(62,9,21,3,212);
				end,
				[212]=function()--令狐冲normal
					say("我剑宗剑术精妙非常，你想见识见识吗？",3);
					say("还请大师指教。");
					local kflist={
									{7,10},
									{8,10},
									{17,10},
								};
					LearnKF(0,3,kflist);
				end,
				[100]=function()--消灭魔教妖人
					if JY.Person[0]["门派"]>=0 then
						say("原来你躲在这里啊！拿命来吧！");
						if vs(0,39,26,JY.Da,38,22,500,0) then
							ModifyD(38,18,0,-2,0,0,-2,0,0,0,0,-2,-2);
							MyQuest[1]=2;
						else
							JY.Status=GAME_END;
						end
					end
				end,
				[11]=function()--
				end,
				[201]=function()	--围攻田伯光
					SetS(62,50,25,3,-1);
					SetS(62,50,26,3,-1);
					if JY.Person[0]["门派"]==0 then
						Dark();
							SetS(62,44,24,1,2590*2);
							SetS(62,44,26,1,2591*2);
							SetS(62,17,19,1,4222*2);
							SetS(62,17,18,1,4433*2);
						Light();
						SmartWalk(45,25,2);
						say("两位师兄，师傅要我们三人一组分开搜索田伯光。但是这里就只有破庙一间，想来也不会有所获了吧。");
						say("不可大意。还是仔细搜索一翻，要不师傅怪罪下来……",24);
						say("不错。");
						MoveSceneTo(17,19);	--视角:田伯光
						say("嘿嘿，小美人～这下你跑不掉了吧～让田大爷来让你快活快活吧～哈哈哈哈～",149);
						MoveSceneTo();
						say("不好！是田伯光！师兄快传信师傅！我先去周旋一番，看看能不能救人！");
						Dark();
							SetS(62,44,24,1,0);
							SetS(62,44,26,1,0);
							--SetS(62,17,19,1,0);
							--SetS(62,17,18,1,0);
							JY.Base["人X1"],JY.Base["人Y1"]=21,23;
						Light();
						--SetS(62,17,19,1,0);
						--SetS(62,18,21,1,6326*2);
						--SetS(62,17,18,1,0);
						--fight
						ModifyWarMap=function()
							SetWarMap(17,18,1,0);
							SetWarMap(18,21,1,0);
							SetWarMap(17,19,1,0);
							--SetWarMap(22,23,1,851*2);
							SetS(62,17,19,1,0);
							SetS(62,18,21,1,6326*2);
							SetS(62,17,18,1,0);
						end
						FIGHT(
									5,1,
									{
										0,23,23,
										-1,22,24,
										-1,24,24,
										-1,21,25,
										-1,25,25,
									},
									{
										149,18,21,
									},
									0,0
								);
						say("该死的，这淫贼武功确实高。");
						say("怎么？这就不行了？那田大爷也不跟你们玩了，纳命来吧！",149);
						say("小心！",24);
						say("（他刚刚居然还没尽全力！？我就要这么死在这了么……）");
						Dark();
							SetS(62,19,21,1,2982*2);
							say("多谢阁下一直不曾取我徒儿性命，这份礼，我就还给你好了。",1);
						Light();
						say("师傅！");
						say("你就是岳不群岳掌门？若是能打败你，说不定那些美丽女子会更加仰慕我田大爷呢～",149);
						say("君子有成人之美。你既然这样想，那我就成全你。",1);
						--fight
						ModifyWarMap=function()
							SetWarMap(17,18,1,0);
							SetWarMap(18,21,1,0);
							SetWarMap(19,21,1,0);
						end
						FIGHT(
									1,1,
									{
										1,23,23,
									},
									{
										149,18,21,
									},
									0,0
								);
						say("哈哈哈哈～岳掌门武功的确不凡，可惜今日我还有要事在身，先告辞了～",149);
						Dark();
							--SetS(62,20,20,1,0);
							--SetS(62,20,21,1,0);
							--SetS(62,20,22,1,0);
							--SetS(62,19,21,1,0);
							SetS(62,18,21,1,0);
						Light();
						say("师傅，为何不将他……");
						say("唉……此人号称万立独行，在轻功上的造诣的确非凡。我追他不上。你们几个，做的不错。能及时传信，并且阻止他行恶。",1);
						say("若不是师傅及时赶到，我们恐怕早已……");
						say("嗯……那贼人武功也不差。经此一战，只怕已记住你们的模样了。也罢，回山之后，我再传你们一路剑法，只盼你们以后行走江湖遇上，能替天行道。",1);
						say("谢师傅！");
						Dark();
							SetS(62,19,21,1,0);
						Light();
						
					else
						Dark();
							SetS(62,44,24,1,2590*2);
							SetS(62,44,26,1,2591*2);
							SetS(62,18,21,1,6326*2);
							SetS(62,17,18,1,4433*2);
						Light();
						SmartWalk(45,25,2);
						say("已经传信给师傅了，快去助师兄！",24);
						Dark();
							SetS(62,44,24,1,0);
							SetS(62,44,26,1,0);
							SetS(62,20,20,1,2592*2);
							SetS(62,20,21,1,2592*2);
							SetS(62,20,22,1,2592*2);
						Light();
						SmartWalk(27,23,2);
						MoveSceneTo(18,21);	--视角:田伯光
						say("淫贼田伯光！你屡屡在我华山境内犯案，多次对我华山挑衅！今日我们便要替那些受害的女子讨个公道！",24);
						say("哈哈哈哈～要是岳不群亲至，或许我还有所顾忌，但是你们几个？敢坏田大爷的兴致，就拿命来陪吧！",149);
						say("（此人就是万立独行田伯光？看来他并不知道岳掌门马上就要来了呢。看起来这三个华山弟子应该也撑不聊多久了。）");
						local menu=	{
												{"田伯光恶贯满盈，我当相助华山弟子，共诛此贼！",1},
												{"华山派以多欺少，无耻之极！",1},
												{"事不关己，高高挂起",1},
											};
						local sel=GenSelection(menu);
						if sel==1 then
							say("（虽然打不过田伯光，但是纠缠一番总是可以做到的，只要撑到岳掌门来到就行了。）华山的各位，我来助你！");
							say("哈哈哈哈～又来一个给田大爷助兴的了～",149);
							say("多说无益！田伯光！你好事多为，今日，就把命留在这吧！");
							ModifyWarMap=function()
								SetWarMap(20,20,1,0);
								SetWarMap(20,21,1,0);
								SetWarMap(20,22,1,0);
								SetWarMap(18,21,1,0);
								SetWarMap(17,18,1,0);
								SetS(62,17,18,1,0);
							end
							FIGHT(
									5,1,
									{
										0,23,23,
										-1,22,24,
										-1,24,24,
										-1,21,25,
										-1,25,25,
									},
									{
										149,18,21,
									},
									0,0
								);
							say("该死的，这淫贼武功确实高。");
							say("怎么？这就不行了？那田大爷也不跟你们玩了，纳命来吧！",149);
							say("小心！",24);
							say("（他刚刚居然还没尽全力！？我就要这么死在这了么……）");
							Dark();
								SetS(62,19,21,1,2982*2);
								say("多谢阁下一直不曾取我徒儿性命，这份礼，我就还给你好了。",1);
							Light();
							say("师傅！");
							say("你就是岳不群岳掌门？若是能打败你，说不定那些美丽女子会更加仰慕我田大爷呢～",149);
							say("君子有成人之美。你既然这样想，那我就成全你。",1);
							--fight
							ModifyWarMap=function()
								SetWarMap(20,20,1,0);
								SetWarMap(20,21,1,0);
								SetWarMap(20,22,1,0);
								SetWarMap(18,21,1,0);
								SetWarMap(17,18,1,0);
								SetWarMap(19,21,1,0);
							end
							FIGHT(
									1,1,
									{
										1,23,23,
									},
									{
										149,18,21,
									},
									0,0
								);
							say("哈哈哈哈～岳掌门武功的确不凡，可惜今日我还有要事在身，先告辞了～",149);
							Dark();
								SetS(62,18,21,1,0);
							Light();
							say("岳掌门，为何不将他……");
							say("唉……此人号称万立独行，在轻功上的造诣的确非凡。我追他不上。你们几个，做的不错。能及时传信，并且阻止他行恶。",1);
							say("若不是岳掌门及时赶到，我们恐怕早已……");
							say("嗯……那贼人武功也不差。经此一战，只怕已记住你们的模样了。也罢，我传少侠一路剑法，以谢少侠互我华山弟子。只盼将来少侠再次遇上此类事件，能够谨记今日的决定。",1);
							local kflist={
											{5,10},
										};
							LearnKF(0,1,kflist);
							say("谢岳掌门！在下自当谨记！");
							Dark();
								SetS(62,20,20,1,0);
								SetS(62,20,21,1,0);
								SetS(62,20,22,1,0);
								SetS(62,19,21,1,0);
							Light();
						elseif sel==2 then
							say("（虽然田伯光乃淫贼，但是身为名门正派的华山弟子居然群起而攻，这也太罔顾江湖道义了。我且助那田伯光一回。）身为名门正派，居然三个打一个！真是不要脸，田兄，我来助你。");
							say("此人居然帮助那淫贼，想来不是同伙也是贼人。一并拿下，交由师傅发落！",24);
							--fight
							ModifyWarMap=function()
								SetWarMap(20,20,1,0);
								SetWarMap(20,21,1,0);
								SetWarMap(20,22,1,0);
								SetWarMap(18,21,1,0);
								SetWarMap(17,18,1,0);
								SetS(62,17,18,1,0);
							end
							FIGHT(
									2,5,
									{
										0,23,23,
										149,18,21,
									},
									{
										9,17,19,
										10,18,19,
										11,20,19,
										12,20,21,
										13,20,23,
									},
									0,0
								);
							say("怎么？华山派的弟子只有这么三脚猫功夫？",149);
							say("该死的淫贼！修得猖狂！等我师傅来了，看你们怎么死！",24);
							say("哎呀～我好怕啊～哈哈哈哈～",149);
							say("田兄，速战速决吧。我来之时看到他们已传信岳不群了。");
							say("行，既然这位少侠开口了，那我就不再留手了，纳命来吧！",149);
							Dark();
								SetS(62,19,21,1,2982*2);
								say("多谢阁下一直不曾取我徒儿性命，这份礼，我就还给你好了。",1);
							Light();
							say("岳不群！");
							say("你就是岳不群岳掌门？若是能打败你，说不定那些美丽女子会更加仰慕我田大爷呢～",149);
							say("君子有成人之美。你既然这样想，那我就成全你。",1);
							--fight
							ModifyWarMap=function()
								SetWarMap(20,20,1,0);
								SetWarMap(20,21,1,0);
								SetWarMap(20,22,1,0);
								SetWarMap(18,21,1,0);
								SetWarMap(17,18,1,0);
								SetWarMap(19,21,1,0);
							end
							FIGHT(
									2,8,
									{
										0,19,22,
										149,19,23,
									},
									{
										1,24,23,
										2,25,22,
										9,26,21,
										10,26,23,
										11,26,25,
										12,27,22,
										13,27,24,
										9,25,24,
									},
									0,0
								);
							say("哈哈哈哈～岳掌门武功的确不凡，可惜今日我还有要事在身，先告辞了～少侠，我们走！",149);
							Dark();
								SetS(62,20,20,1,0);
								SetS(62,20,21,1,0);
								SetS(62,20,22,1,0);
								SetS(62,19,21,1,0);
								SetS(62,18,21,1,0);
								JY.SubScene=38;
								JY.SubSceneX,JY.SubSceneY=0,0;
								SetS(38,16,13,1,4708*2);
								JY.Base["人方向"]=0;
								JY.MyPic=GetMyPic();
								JY.Base["人X1"],JY.Base["人Y1"]=16,14;
							Light();
							say("多谢少侠相助。",149);
							say("哪里哪里，没有我，田兄一样可以来去自如。倒是我过于孟浪了。");
							say("少侠说笑了。只是你此番助我，只怕华山派依然将你视为我的同伙了。",149);
							say("哼！那又如何！？我就是看不惯他们标榜为名门正派，却行这以多欺少之事。那岳掌门人称君子剑，但门下弟子如此，只怕也是个伪君子而已。");
							say("说得好！少侠此言真是大快人心！那岳不群就是个伪君子！哈哈哈哈！不过，他的武功确实高强。我可凭轻功逃脱，只怕少侠……",149);
							say("那有什么，天下这么大，总不可能都是他华山派的地盘吧。");
							say("说得好！这样，如不嫌弃，在下将自己总结出来的一路刀法传给少侠，希望少侠能多一番自保之力。",149);
							local kflist={
											{80,10},
										};
							LearnKF(0,149,kflist);
							say("多谢田兄。");
							say("山高水长，后会有期！",149);
							Dark();
								SetS(38,16,13,1,0);
							Light();
						else
							say("城门失火，殃及池鱼。还是走吧。",24);
							SetS(62,44,24,1,0);
							SetS(62,44,26,1,0);
							SetS(62,18,21,1,0);
							SetS(62,17,18,1,0);
							SetS(62,20,20,1,0);
							SetS(62,20,21,1,0);
							SetS(62,20,22,1,0);
							JY.Status=GAME_MMAP;
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
					end
					
										--众人出现
										ModifyD(57,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,29);
										ModifyD(57,1,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,28);
										ModifyD(57,17,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,27);
										ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,21,25);
										ModifyD(57,26,-2,-2,-2,-2,-2,-2,-2,-2,-2,21,13);
										ModifyD(57,6,-2,-2,-2,-2,-2,-2,-2,-2,-2,24,40);
										ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,44);
										ModifyD(57,23,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,28);
										ModifyD(57,24,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,30);
										ModifyD(57,15,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,37);
										ModifyD(57,16,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,14);
										ModifyD(57,27,-2,-2,-2,-2,-2,-2,-2,-2,-2,40,36);
										ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,24);
										ModifyD(57,30,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,25);
										ModifyD(57,2,-2,-2,-2,-2,-2,-2,-2,-2,-2,39,22);
										ModifyD(57,29,-2,-2,-2,-2,-2,-2,-2,-2,-2,38,13);
										ModifyD(57,3,-2,-2,-2,-2,-2,-2,-2,-2,-2,46,29);
										ModifyD(57,4,-2,-2,-2,-2,-2,-2,-2,-2,-2,46,30);
										ModifyD(57,18,-2,-2,-2,-2,-2,-2,-2,-2,-2,50,32);
										ModifyD(57,19,-2,-2,-2,-2,-2,-2,-2,-2,-2,50,27);
										ModifyD(57,20,-2,-2,-2,-2,-2,-2,-2,-2,-2,51,27);
										ModifyD(57,21,-2,-2,-2,-2,-2,-2,-2,-2,-2,51,32);
										SetS(57,52,29,3,-1);
										SetS(57,52,30,3,-1);
										SetS(57,30,13,3,-1);
										SetS(57,31,13,3,-1);
					MoveSceneTo();
				end,
			}

						--say("")SceneEvent[JY.SubScene]={};
SceneEvent[7]={
				[1]=function()		--对话灵智上人
					local v=GetFlag(2010);
					if v==0 then
						say('３Ｏ（这灵智上人当真奇怪，每次见到他都是坐在椅子上闭目养神。）ＷＨ见过上人。');
						say('３阿弥陀佛，原来是小王爷驾到。请坐。',3);
						say('３（跟我说话还不肯张开眼睛，装模作样。）上人，父王今天让我来跟您学武。');
						say('３六王爷已经与老衲说过了，希望小王爷从今往后能专心学习，老衲也将每月向六王爷汇报你的学习情况。',3);
						say('３（唉，这老和尚真够绝的，每个月还要找家长，看来我真得学点东西了）还请上人今后多多教导小王。');
						say('３小王爷，若要学好武功，就必须先修习最基本的拳脚功夫，而要修练我佛门的基本拳脚功夫，则必须同时习研我禅宗的经义，了解宇宙苍生。从今天开始，我们就进行第一阶段的修习，每次学三个时辰理论课，课间一次休息。',3);
						say('３哦，知道了。');
						say('３好，今天老衲讲的是……',3);
						say('３阿弥陀佛，小王爷感觉如何？',3);
						say('３我，我感觉很累……');
						say('３第一次上课难免会累，以后会习惯的。今天老衲就讲到这里。小王爷回去要好好参悟。',3);
						say('３好的好的，小王告辞。');
					elseif v==1 then
						say('３上人我来了。');
						say('３小王爷请坐。今天我们要讲的是……',3);
						say('３（唔，又开始了。）……');
						say('３嗯，今天小王爷气色不错，老衲就多讲一点吧。￥%*！~%……',3);
						say('３上人……（每次都压堂，真受不了他。）');
						say('３……好，今天就讲这些。小王爷可以回去了。',3);
						say('３（终于结束了。）谢谢上人。小王告辞。（遁走。）');
						say('３仔细想想，今天的收获还不错。');
						say('３唔，老和尚叽叽歪歪，头疼得厉害，今天什么都没听进去。');
						say('３嗯，话说回来，那老和尚讲的一些东西还真有些道理，看来我回去还要细细品味。');
					elseif v==2 then
						say('３上人。');
						say('３小王爷来了，请坐。今天我们学的是……',3);
						say('３上人，我已经学了几个月的经书，能不能学一点别的？');
						say('３嗯，老衲看你现在已经有了一点基础，这样吧，今天就将我的独门武功“大手印”传给你吧。你看好……',3);
						say('３好了，今天就学这些。小王爷可以回去了。',3);
						say('３谢谢上人。（出寺门。）');
						say('３（也不知这大手印好不好使）哎，你过来。');
						say('３小王爷。',8);
						say('３不错不错，果然是个手印，不过小了点，看来还得多加练习。');
						say('３呜，我的脸……',8);
					elseif v==3 then
						say('３上人。');
						say('３小王爷请坐。',3);
						say('３……');
						say('３（奇怪，老和尚今天怎么不说话了）上人，我们今天不上课了吗？');
						say('３是啊，小王爷，今天我们不上课了。',3);
						say('３耶！太棒了，那小王就……');
						say('３且慢，今天不上课了，因为老衲安排的是考试。',3);
						say('３……（心里一下凉到底，真想趁现在老和尚还闭着眼睛一刀捅死他。）');
						say('３好，现在开始考试。请听题。在我密宗佛法中何为“金刚”？',3);
						say('３呃……横竖智杵，摧坏四魔，恒常不坏，其为"金刚"。');
						say('３答得好！那金刚界的“曼荼罗九会”都是指什么？',3);
						say('３……有成身会、三昧耶会、微细会、供养会、四印会、一印会、理趣会、降三世羯磨会、降三世三昧耶会。');
						say('３嗯，不错。我再问你，什么是“一切如来”？',3);
						say('３我想想……五智佛名"一切如来"，聚一切诸法共成五佛身，此五佛为诸佛的本性，诸法的根源，故名"一切如来".');
						say('３哎呀呀，小王爷，没想到你与我佛如此有缘。既然如此，老衲就将我密宗的心法传授与你吧。',3);
						say('３小王爷，这密宗心法博大精深，你回去要好好练习巩固。',3);
						say('３小王谨记上人教导。');
						say('３（出寺门后从怀中拿出金刚顶经）唔，幸好我刚巧带了这本书来，那老和尚又整天闭着眼睛，不知道我是照着书回答的。看来这书中的东西和老和尚讲的是同一套路，没什么好看的，放到家里算了。');
					end
				end,
				[200]=function()
					JY.SubScene=5
					JY.Base["人X1"],JY.Base["人Y1"]=59,31
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
				[201]=function()
					JY.SubScene=9
					JY.Base["人X1"],JY.Base["人Y1"]=34,60
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
				[202]=function()
					JY.SubScene=6
					JY.Base["人X1"],JY.Base["人Y1"]=26,6
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
			}SceneEvent[70]={};
SceneEvent[70]={
				[698]=function()		--拜见母亲
					--vs(1,20,15,2,25,16,500)
					--vs(1,20,15,3,25,16,500)
					--vs(1,20,15,5,25,16,500)
					--vs(1,20,15,6,25,16,500)
					--vs(1,20,15,27,25,16,500)
					--vs(1,20,15,49,25,16,500)
					--vs(1,20,15,50,25,16,500)
					--vs(1,20,15,66,25,16,500)
					--vs(1,20,15,67,25,16,500)
					--vs(1,20,15,68,25,16,500)
					--vs(1,20,15,69,25,16,500)
					--vs(1,20,15,70,25,16,500)
					--vs(1,20,15,71,25,16,500)
					--vs(1,20,15,72,25,16,500)
					for i=2,15 do
						JY.Base["队伍"..i]=i-1
					end
					--if JY.Person[0]["修炼点数"]==0 then
						JY.Person[0]["修炼点数"]=99999;
					--end
					local kflist={};
					for i=1,30 do
						kflist[i]={i,10};
					end
					LearnKF(0,1,kflist)
					--[[
					WAR={};
					WAR.Data={};
					WAR.Data["代号"]=0;
					WAR.Data["名称"]="测试战斗";
					WAR.Data["地图"]=0;
					WAR.Data["经验"]=0;
					WAR.Data["音乐"]=0;
					WAR.Data["自动选择参战人"  .. 1]=0;
					WAR.Data["我方X"  .. 1]=9;
					WAR.Data["我方Y"  .. 1]=21;
					WAR.Data["敌人"  .. 1]=19;
					WAR.Data["敌方X"  .. 1]=9;
					WAR.Data["敌方Y"  .. 1]=20;
					WarMain(999,0)]]--
				end,
			}
SceneEvent[8]={};
SceneEvent[8]={
				[200]=function()
					JY.SubScene=6
					JY.Base["人X1"],JY.Base["人Y1"]=57,34
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
			}







--[[
if inrect(1,26,2,28) then
	JY.SubScene=6
	JY.Base["人X1"],JY.Base["人Y1"]=57,34
	lib.ShowSlow(50,1);
	Init_SMap(1);
else--if lib.GetS(0,0,1,0)==1230 and inrect(29,17,45,26) then
	--比武招亲
	lib.SetS(3,39,22,1,2)
    WAR={};
    WAR.Data={};
    WAR.Data["代号"]=0;
    WAR.Data["名称"]="测试战斗";
    WAR.Data["地图"]=0;
    WAR.Data["经验"]=0;
    WAR.Data["音乐"]=0;
	WAR.Data["自动选择参战人"  .. 1]=0;
	WAR.Data["我方X"  .. 1]=24;
	WAR.Data["我方Y"  .. 1]=28;
	WAR.Data["敌人"  .. 1]=1;
	WAR.Data["敌方X"  .. 1]=23;
	WAR.Data["敌方Y"  .. 1]=26;
	WarMain(999,0)
	if true then return end
	lib.SetS(3,39,22,1,0)
	movesceneto(38,17)
	say("表哥，那边热闹得很，你说今天要陪我玩一整天，不许耍赖，陪我看看去",1)
	say("大丈夫一诺千金，你表哥我几时失言与人。（这侯通海怎地还不来接应我回王府= =）",0,1)
	say("真没羞，上次说好了我生日那天要教我武功，结果只送了我几本破秘籍，嘻嘻，不过本小姐大人有大量，看在这次你这么老实份上饶你一回，再不走可看不着热闹啦。",1)
	movesceneto()
	walkto(31,24)
	walkto(31,27)
	walkto(39,27)
	walkto(39,26)
	movesceneto(39,17)
	say("在下姓穆名易，山东人氏。路经贵地，一不求名，二不为利，只为小女年已及笄，尚未许得婆家。她曾许下一愿，不望夫婿富贵，但愿是个武艺超群的好汉，因此上斗胆比武招亲。凡年在三十岁以下，尚未娶亲，能胜得小女一拳一脚的，在下即将小女许配于他。在下父女两人，自南至北，经历七路，只因成名的豪杰都已婚配，而少年英雄又少肯于下顾，是以始终未得良缘。北京是卧虎藏龙之地，高人侠士必多，在下行事荒唐，请各位多多包涵。",100)
	say("原来是中原人比擂台的把式，表哥你看以我的本事上去能夺魁吗？",1,5)
	say("……",0,1)
	say("……",2,4)
	say("那个姑娘有何好看的，我看你魂都飞出来了，嘻嘻，不如我上去替表哥你将那个美人拿下来，送进宫里，如何？",1,5)
	say("庸脂俗粉而已，怎比得上表妹，看我去露两手。",0,1)
	say("每次有好玩的你都跟我抢，不过这次算你还会说话。",1,5)
	movesceneto()
	walkto(39,19)
	say("比武招亲的可是这位姑娘吗？",0,1)
	say("……",2,4)
	say("在下姓穆，公子爷有何见教？",100)
	say("我来试试",0,1)
	say("小人父女是江湖草莽，怎敢与公子爷放对？再说这不是寻常的赌胜较艺，事关小女终身大事，请公子爷见谅。",100)
	say("你们比武招亲已有几日了？",0,1)
	say("经历七路，已有大半年了。",100)
	say("难道竟然无人胜得了她？这个我却不信了。")
	say("小人父女是山野草莽之人，不敢与公子爷过招。咱们就此别过。（这人若是个寻常人家的少年，倒也和我孩儿相配。但他是富贵公子，此处是金人的京师，他父兄就算不在朝中做官，也必是有财有势之人。我孩儿若是胜过了他，难免另有后患；要是被他得胜，我又怎能跟这等人家结亲？）",100)
	say("切磋武艺，点到为止，你放心，我决不打伤打痛你的姑娘便是。这位姑娘，你只消打到我一拳，便算是你赢了，好不好？")
	say("比武过招，胜负自须公平。",2,4)
	say("（这公子爷娇生惯养，岂能真有甚么武功了？尽快将他打发了，我们这就出城，免得多生是非。）那么公子请吧。",100)
	say("你好ｎ",0)
	--lib.SetS(0,0,1,0,1)
end]]--SceneEvent[81]={};--思过崖各事件
SceneEvent[81]={
				[1]=function()--令狐冲normal
					if GetFlag(1)<=lib.GetD(JY.SubScene,JY.CurrentD,4) then
						say("............",JY.Da);
						return;
					end
					local str={
									"我日后见到魔教中人，是否不问是非，拔剑便将他们杀了？",
									"难道魔教之中当真便无一个好人？但若他是好人，为甚么又入魔教？",
									"数百年来，我华山派不知道有多少前辈曾在这里坐过，令狐冲是今日华山派第一捣蛋鬼，自当在此坐坐。",
									"小师妹好多天都没来了，莫非着凉了？",
									};
					say(str[math.random(4)],JY.Da);
					lib.SetD(JY.SubScene,JY.CurrentD,4,GetFlag(1));
					if GetFlag(10006)==1 then
						if GetFlag(1)-lib.GetD(JY.SubScene,JY.CurrentD,4)<7 then
							say("大师兄，我给你送饭菜来了。");
							say("怎么小师妹没来啊，啊，谢谢，放这边就行了。",JY.Da);
							AddPersonAttrib(JY.Da,"友好",1);
							SetFlag(10006,0);
						else
							say("大师兄，我给你送饭菜来了。");
							say("怎么这么久才送来啊。",JY.Da);
							SetFlag(10006,4);
						end
					end
				end,
				[2]=function()	--令狐与承志
					say("大师兄，且休息一下，该吃饭了。");
					say("今日怎么是你来送饭？陆猴儿呢？",8);
					say("师傅听闻田伯光在我华山境内犯案，就率众人下山去练兵了。");
					SetS(57,30,13,3,-1);
					SetS(57,31,13,3,-1);
					if GetFlag(10008)==1 then
						say("原来如此……哈！你居然还准备了如此好酒！有心了！",8);
						say("（这是一个误会，不过，是一个美丽的误会）知道大师兄好此杯中之物，不敢不备啊。");
						say("哈哈，有你的～",8);
					else
						say("原来如此……",8);
					end
					Dark();
						SetS(81,15,21,1,3409*2);	--袁承志
						SetS(81,13,21,1,1719*2);
						SetS(81,13,20,1,1720*2);
					Light();
					say("此处是哪？我只记得从洞中出来之后便是一片树林，不知原来还有此等地方。",160);
					say("你是何人！为何私闯我华山禁地思过崖？",8);
					say("原来此处便是思过崖？真是闻名不如见面啊。我是华山弟子袁承志。",160);
					say("你是华山弟子？袁承志？不可能，我华山众弟子之间没有一个叫袁承志的。你究竟是何人！",8);
					say("大师兄，此人擅闯我华山禁地，又假装我华山弟子，只怕其心不良。不如我们将其拿下，以交师傅处置？");
					say("好，就这么办。",8);
					say("要动手？也好，刚好试试这金蛇剑法威力。",160);
					--fight
					ModifyWarMap=function()
						SetWarMap(15,21,1,0);
					end
					vs(8,25,23,160,17,21,500);
					Dark();
						SetS(81,18,19,1,2951*2);
						SetS(81,18,21,1,6187*2);
						getkey();
					Light();
					say("真是榆木脑袋。我从未见过使得如此之死板的华山剑法。",7);
					say("唉，华山的没落岂非此一时而已？",159);
					say("你们又是何人？连番闯我华山禁地究竟意欲何为！",8);
					say("华山之上，自然是华山之人。老夫穆人清。",159);
					say("老夫风清扬。",7);
					say("穆人清？风清扬？莫不是我华山清字辈的前辈？",8);
					say("哦？你居然知道我们？",7);
					say("徒孙令狐冲，拜见两位太师叔。",8);
					say("徒孙拜见两位太师叔。");
					say("拜见就不用了。对了小子，我问你，我这徒弟武功如何？",159);
					say("这位……师叔武功高强，合我二人之力堪乃与之一战。若是单打独斗，我不是对手。",8);
					say("敢直言自己不行，不错不错。看来剑法死板但是人还行。你且过来，我就教教你真正的华山剑法，该怎么使。",7);
					Dark();
					Light();
						for i=1,10 do
							AddPersonAttrib(8,"经验",5000);
							War_AddPersonLevel(8,true);
						end
					say("多谢太师叔指点！",8);
					say("风老头，你这几下子真的有用？不会只是装装样子，误人子弟吧？",159);
					say("冲儿，你再去请你师叔指教一番。",7);
					say("是，太师叔。袁师叔，请指教。",8);
					say("指教不敢当，切磋切磋而已。",160);
					--fight
					ModifyWarMap=function()
						SetWarMap(15,21,1,0);
						SetWarMap(18,19,1,0);
						SetWarMap(18,21,1,0);
					end
					vs(8,25,23,160,17,21,500);
					say("师叔剑法犹如灵蛇一般，往往从意想不到的角度攻来，我堪堪只能抵挡，连反攻一剑都做不到。",8);
					say("哪里。你将一套基础的华山剑法使得浑然天成，滴水不漏，我连攻你数十剑，居然均被挡下，你这华山剑法已然大成啊。",160);
					say("如此说来居然是平局？风老头只是指点几句就能打成平局？我不信。承志，我们走。三个月后，再来领教。",159);
					say("冲儿，你且随我练剑。三个月后，指教一下他们。",7);
					say("哼！谁指教谁还说不定呢！",159);
					say("令狐兄，那便三个月后再见了。只是，今日我所使剑法，乃不久前刚所得到的一路高深剑法，三个月后，自是与今日所使大不一样，还望令狐兄不要大意。",160);
					say("多谢相告。（只是我只会基本的华山剑法，弱真如他所说，那恐怕……）",8);
					say("冲儿，我自会传你一套剑法。三个月后，你须胜他。",7);
					say("多谢太师叔。",8);
					say("恭喜大师兄。");
					Dark();
						ModifyD(81,0,-2,-2,3,-2,-2,-2,-2,-2,-2,-2,-2);	--修改令狐练剑
						SetS(81,15,21,1,0);	--袁承志
						SetS(81,18,19,1,0);
						SetS(81,18,21,1,0);
						SetFlag(10009,GetFlag(1));
						SetFlag(10012,1);
					Light();
				end,
				[3]=function()	--日常切磋
					if GetFlag(10009)>0 and GetFlag(1)-GetFlag(10009)>=90 then	--比试
						if GetFlag(10012)==1 then
							Dark();
								SetS(81,15,21,1,3409*2);	--袁承志
								SetS(81,18,19,1,2951*2);
								SetS(81,18,21,1,6187*2);
							Light();
							say("令狐兄，请指教。",160);
							say("莫敢不从。",8);
							SetFlag(10013,1);
							--fight
							ModifyWarMap=function()
								SetWarMap(15,21,1,0);
								SetWarMap(18,19,1,0);
								SetWarMap(18,21,1,0);
							end
							local resule=vs(8,25,23,160,17,21,500);
							Dark();
								say_2("大师兄！大师兄！",13);
								say_2("承志，我们走。",159);
								say_2("你二人记住，不得向任何人透露我三人之事。",7);
								say_2("是！",8);
								say_2("是！");
								SetS(81,15,21,1,0);	--袁承志
								SetS(81,18,19,1,0);
								SetS(81,18,21,1,0);
								--陆大有
								SetS(81,17,19,1,2592*2)
							Light();
						else
							Dark();
								say("大师兄！大师兄！",13);
								--陆大有
								SetS(81,17,19,1,2592*2)
							Light();
						end
						say("大师兄！",13);
						say("你这猴儿，什么事这么急啊。",8);
						say("大师兄！大事不好了！嵩山派的领着剑宗上门，逼师傅交出掌门之位来了。",13);
						say("什么！岂有此理！我们快去！",8);
						Dark();
							SetS(81,17,19,1,0)
							ModifyD(81,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,1);	--修改令狐
							SetFlag(10014,GetFlag(1)+5);
						Light();
						return;
					end
					--日常
						say("比剑之期将近，我需要努力啊。",JY.Da);
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
								SetWarMap(49,35,1,0);
							end
							local result=vs(0,25,23,JY.Da,17,21,500);
							Cls();
							ShowScreen();
							if result then
								say("好剑法！愚兄自愧不如。",JY.Da);
							else
								say("你的武功还不错，再加把劲吧。",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							--say("师弟若是无事，来聊聊天或者切磋下武功也好啊。",JY.Da);
						end
					
				end,
				[201]=function()	--桃谷六仙疗伤令狐冲
							SetS(81,22,26,1,4223*2);
							SetS(81,21,26,1,3398*2);
							SetS(81,23,26,1,3401*2);
							SetS(81,22,25,1,3399*2);
							SetS(81,22,27,1,3400*2);
							SetS(81,24,25,1,3401*2);
							SetS(81,24,27,1,3401*2);
					MoveSceneTo(22,26);
					say("令狐冲受伤了。",152);
					say("怎么治？",153);
					say("他被内力所伤，自然要用内力治疗。",154);
					say("不如我们将我们的内力注入，帮他疗伤？",155);
					say("那么如何注入呢？",156);
					say("不如我们各挑一条经脉注入？",157);
					say("这个方法不错。",156);
					say("就这么办好了。",155);
					say("但是最后怎么知道是谁的功劳呢？",154);
					say("不如等他好了我们问他？",153);
					say("嗯，那就先救醒他。",152);
					DrawStrBoxWaitKey("六人把内力注入令狐冲体内");
					Dark();
						say("啊……",8);
					Light();
					say("令狐冲醒了。",152);
					say("没醒没醒。",153);
					say("没醒他为什么会叫？",154);
					say("会叫也不一定是醒了。",155);
					say("那他究竟醒了没有？",156);
					say("喂！令狐冲，你醒了吗？",157);
					say("没有反应呢。",156);
					say("那就是没醒。",155);
					say("也有可能是他醒了故意不回答。",154);
					say("那我们把他撕成四块，看他回不回答。",153);
					say("撕成四块不就死了吗？死了自然回答不了。",152);
					say("（遭了，他们要把大师兄撕成四块！）师傅，师娘！大师兄在这！（咦！？那六个怪人呢？）");
					Dark();
						JY.SubSceneX,JY.SubSceneY=0,0;
							SetS(81,21,26,1,0);
							SetS(81,23,26,1,0);
							SetS(81,22,25,1,0);
							SetS(81,22,27,1,0);
							SetS(81,24,25,1,0);
							SetS(81,24,27,1,0);
						SetS(81,21,26,1,4258*2);
						SetS(81,22,25,1,2613*2);
						JY.Base["人X1"],JY.Base["人Y1"]=23,26;
					Light();
					say("冲儿！冲儿！你怎么样了冲儿！",2);
					say("师妹，别急，让我看看。……冲儿体内有六道一种真气横闯直撞，经脉乱作一团，只怕……",1);
					say("冲儿！嵩山派真可恶！",2);
					say("我观那六人不似嵩山之人。他们如此折磨冲儿究竟有何意图？",1);
					say("师兄，冲儿他还有救么？",2);
					say("性命无碍，只是这内力……容我再想想……你先把你大师兄扶回房。",1);
					say("是。");
					Dark();
						SetS(81,21,26,1,0);
						SetS(81,22,25,1,0);
						SetS(81,22,26,1,0);
						JY.SubScene=57;
						SetS(57,43,13,1,4323*2);
						JY.Base["人方向"]=0;
						JY.MyPic=GetMyPic();
						JY.Base["人X1"],JY.Base["人Y1"]=43,14;
					Light();
					say("师傅真这么说？",8);
					say("是的。大师兄你别急，好好养伤，师傅一定会有办法的。");
					say("但愿吧……",8);
					say("对了。华山九功，紫霞第一。我想紫霞神功一定可以帮你解决那些异种真气的。只是为何师傅不肯传你……是了。紫霞神功只传掌门。想来，师傅是希望大师兄早日振作，成为能肩负我华山的下任掌门，再传紫霞神功。大师兄切勿再颓废，不可浪费师傅的一片苦心啊。");
					say("言之有理。令狐冲受教了。我一定不会辜负师傅的期望的！",8);
					Dark();
						JY.Base["人方向"]=2;
						JY.MyPic=GetMyPic();
						JY.Base["人X1"],JY.Base["人Y1"]=38,17;
					Light();
				end,
				[11]=function()--
				end,
			}

						--say("")SceneEvent[9]={};
SceneEvent[9]={
				[1]=function()	--狄云对话
				end,
				[200]=function()
					JY.SubScene=7;
					JY.Base["人X1"],JY.Base["人Y1"]=31,7;
					lib.ShowSlow(50,1);
					Init_SMap(1);
				end,
				[201]=function()
					--JY.SubSceneX,JY.SubSceneY=0,0;
					MoveScene(0,0);
				end,
				[202]=function()
					--JY.SubSceneX,JY.SubSceneY=5,5;
					MoveScene(5,5);
				end,
				[203]=function()
					--JY.SubSceneX,JY.SubSceneY=-5,-5;
					MoveScene(-5,-5);
				end,
				[204]=function()
					JY.SubScene=2;
					for i=0,63 do
						for j=0,63 do
							SetS(JY.SubScene,i,j,0,-1);
							SetS(JY.SubScene,i,j,1,-1);
							SetS(JY.SubScene,i,j,2,-1);
							SetS(JY.SubScene,i,j,3,-1);
							SetS(JY.SubScene,i,j,4,0);
							SetS(JY.SubScene,i,j,5,0);
						end
					end
					migong(30,30);
					JY.Base["人X1"],JY.Base["人Y1"]=32,32;
					lib.ShowSlow(50,1);
					Init_SMap(1);
					--[[Timer[1].status='start';
					Timer[1].t=60;
					Timer[1].event=SceneEvent[2][200];
					Timer[2].status='start';
					Timer[2].t=5;
					Timer[2].event=SceneEvent[2][201];]]--
				end,
				[205]=function()
					for i=48,58 do
						SetS(9,26,i,3,-1);
					end
					say('３如此幽静的地方，怎么好像有打斗的声音？过去看看。');
					local x,y=JY.Base["人X1"],JY.Base["人Y1"];
					MoveSceneTo(12,51);
					DrawStrBoxWaitKey("狄云和戚芳练剑的动画",C_WHITE,CC.Fontbig);
					say('３师哥，你擦擦汗。',12,0);
					say('３嗯，师妹，你觉得今天我们这几招练得怎么样？',11,4);
					say('３师哥，我记得爹爹曾经说这两招“忽听喷惊风，连山若布逃”应该是让剑势象一匹布一样逃了开去。',12,0);
					say('３嗯，这样说来我这两招确实没有练到。师妹，看来我们还得好好的练，不懂的地方等师傅回来再问他老人家。',11,4);
					say('３师哥，爹爹每次出门都要好几个月甚至一二年，不知他什么时候才回来。',12,0);
					say('３总之我们在家好好种菜就是了，再练好这套“躺尸剑法”，师傅回来了肯定高兴。',11,4);
					say('３嗯，我们先进屋吧，我去做饭。',12,0);
					say('３好，师妹，那我去喂大黑它们。',11,4);
					say('３（原来是一对兄妹在这里练剑。“躺尸剑法”这名字还真有意思，不知道他们所说的那套剑法究竟怎样，以后有机会不妨过来看一看。）');
					MoveScene(5,5);
				end,
			}