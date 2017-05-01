SceneEvent[1]={}
SceneEvent[1]={
				[1]=function()	--客栈门口,寻找岳灵珊事件
					if not (GetFlag(10001)==1 or GetFlag(11002)==1 or GetFlag(1)-GetFlag(2)>60) then
						return true;
					elseif GetFlag(16001)~=0 then
						return true;
					else
						Dark();
						ModifyD(JY.SubScene,3,0,-2,-2,0,-2,0,0,0,-2,-2,-2);
						ModifyD(JY.SubScene,4,0,-2,-2,0,-2,0,0,0,-2,-2,-2);
						ModifyD(JY.SubScene,5,0,-2,-2,0,-2,0,0,0,-2,-2,-2);
						ModifyD(JY.SubScene,6,0,-2,-2,0,-2,0,0,0,-2,-2,-2);
						SetS(JY.SubScene,19,16,1,4260*2);
						SetS(JY.SubScene,18,17,1,2589*2);
						SetS(JY.SubScene,24,16,1,3020*2);
						SetS(JY.SubScene,23,17,1,3019*2);
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
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						SetS(JY.SubScene,19,16,1,0);
						SetS(JY.SubScene,18,17,1,0);
						SetS(JY.SubScene,24,16,1,0);
						SetS(JY.SubScene,23,17,1,0);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						JY.Person[9]["所在"]=JY.Shop[0]["据点"];
						JY.Person[14]["所在"]=JY.Shop[0]["据点"];
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
							JY.Person[36]["登场"]=0;
							JY.Person[36]["所在"]=-1;
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
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						SetS(JY.SubScene,19,16,1,0);
						SetS(JY.SubScene,18,17,1,0);
						SetS(JY.SubScene,24,16,1,0);
						SetS(JY.SubScene,23,17,1,0);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						JY.Person[9]["所在"]=JY.Shop[0]["据点"];
						JY.Person[14]["所在"]=JY.Shop[0]["据点"];
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
							JY.Person[36]["登场"]=0;
							JY.Person[36]["所在"]=-1;
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
						ModifyD(JY.SubScene,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
						SetS(JY.SubScene,19,16,1,0);
						SetS(JY.SubScene,18,17,1,0);
						SetS(JY.SubScene,24,16,1,0);
						SetS(JY.SubScene,23,17,1,0);
						--岳灵珊,劳德诺回华山
						JY.Person[9]["门派"]=0;
						JY.Person[14]["门派"]=0;
						JY.Person[9]["所在"]=JY.Shop[0]["据点"];
						JY.Person[14]["所在"]=JY.Shop[0]["据点"];
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
							JY.Person[36]["登场"]=0;
							JY.Person[36]["所在"]=-1;
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
			}