SceneEvent[5]={};
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
