SceneEvent[38]={};--衡阳城各事件
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
							JY.Person[68]["登场"]=0;
							JY.Person[68]["所在"]=-1;
							JY.Person[74]["登场"]=0;
							JY.Person[74]["所在"]=-1;
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
								JY.Person[31]["登场"]=0;
								JY.Person[31]["所在"]=-1;
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
				
				[3]=function()--衡阳城三方跳转，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=374,374;
					return true;
				end,
				[4]=function()--衡阳城三方跳转，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=371,371;
					return true;
				end,
				[5]=function()--衡阳城三方跳转，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=368,374;
					return true;
				end,
				[11]=function()--
				end,
				[12]=function()--
					say("韦陀门乃是当年少林寺达摩院首座无相禅师所创。",JY.Da);
					local kflist={
										{312,10},
										{344,10},
										{167,10},
										{355,10},
									};
					LearnKF(0,JY.Da,kflist);
				end,
				[13]=function()	--住宿
					if DrawStrBoxYesNo(-1,-1,"是否休息？",C_WHITE,CC.Fontbig) then
						SetFlag(1,GetFlag(1)+1);
						rest();
						say("休息够了，继续努力吧。");
					else
					
					end
				end,
				[1001]=function()--
					return CommonEvent(1,JY.Da)
				end,
			}

						--say("")