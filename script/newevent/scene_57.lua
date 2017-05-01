SceneEvent[57]={};--华山派各事件
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
						--local add,str=AddPersonAttrib(0,"修炼点数",50000);
							local kflist={
												{1,6},
												{9,10},
												{10,6},
												{13,6},
												{15,6},
												--[[{101,10},
												{102,10},
												{103,10},
												{104,10},
												{105,10},
												{106,10},
												{107,10},
												{108,10},
												{109,10},
												{110,10},
												{111,10},
												{121,10},
												{122,10},
												{123,10},
												{124,10},
												{125,10},
												{126,10},
												{127,10},
												{128,10},
												{129,10},
												{130,10},
												{131,10},
												{132,10},
												{133,10},
												{134,10},
												{135,10},
												{136,10},
												{137,10},
												{138,10},
												{139,10},
												{151,10},
												{152,10},
												{153,10},
												{154,10},
												{155,10},
												{156,10},
												{157,10},
												{158,10},
												{159,10},
												{160,10},
												{161,10},
												{162,10},
												{163,10},
												{164,10},
												{165,10},
												{166,10},
												{167,10},
												{168,10},
												{169,10},
												{170,10},
												{171,10},
												{172,10},]]--
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
]]--