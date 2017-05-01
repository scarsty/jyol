SceneEvent[51]={};--丐帮各事件
SceneEvent[51]={
				[1]=function()	--看门弟子
					--暂时不考虑丐帮公敌
					if JY.Person[0]["门派"]~=9 then	--非丐帮弟子
						local d=JY.Base["人方向"];
						if JY.Base["人X1"]+CC.DirectX[d+1]~=40 or JY.Base["人Y1"]+CC.DirectY[d+1]~=30 then
							say("丐帮是天下第一大帮。",JY.Da);
							return;
						end
						if d==2 then
							say("你不是丐帮的人，来到这里想必是有事情吧",JY.Da);
						else
							say("要出去吗？",JY.Da);
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
							say("请进吧。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==2 then
							say("看你的样子好像是走投无入了，要加入我们丐帮吗？这样出去外面也有个照应，别人才不会欺负你。",JY.Da);
							say("我来就是想加入丐帮，希望你们能收留我。");
							Dark();
							JY.Base["人X1"]=17;
							JY.Base["人Y1"]=29;
							JY.Base["人方向"]=2;
							 JY.MyPic=GetMyPic();
							Light();
							--暂时不考虑拜师条件
							if true then
								say("想入本帮不难，但必须遵守帮规，ｎ你可以做到吗？",261);
								if DrawStrBoxYesNo(-1,-1,"是否真的要拜入丐帮派？",C_WHITE,CC.Fontbig) then
									say("弟子当谨遵帮规！");
									JY.Person[0]["门派"]=9;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ丐帮",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="丐帮弟子";
									--GetItem(5,1);
								else
									say("我误入此地，请你别见怪。");
								end
							else
								say("阁下在江湖上早有盛名，又何必来消遣我丐帮寻乐呢？",261);
							end
						elseif r==3 then
							--say("既然无事，就赶紧离开吧。",JY.Da);
							Dark();
							JY.Base["人X1"]=JY.Base["人X1"]+CC.DirectX[d+1]*2;
							JY.Base["人Y1"]=JY.Base["人Y1"]+CC.DirectY[d+1]*2;
							Light();
						elseif r==4 then
							say("请便。",JY.Da);
						end
					else
						local d=JY.Base["人方向"];
						if JY.Da>0 then
							say("兄弟有需要帮忙的吗？",JY.Da);
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
							if JY.Base["人X1"]+CC.DirectX[d+1]~=40 or JY.Base["人Y1"]+CC.DirectY[d+1]~=30 then
								menu[5][3]=0;
								menu[6][3]=0;
							end
							local r=ShowMenu(menu,7,0,0,0,0,0,1,0);
							if r==1 then
								RandomEvent(JY.Da);
							elseif r==2 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
								say("嗯，咱们比划比划。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
								Cls();
								ShowScreen();
								if result then
									say("好功夫！",JY.Da);
								else
									say("兄弟你还要努力啊，不然日后行走江湖很危险的！",JY.Da);
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
								say("如果有需要，随时来找我。",JY.Da);
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
					if JY.Person[0]["门派"]~=9 then	--非丐帮弟子
						say("丐帮是天下第一大帮。",JY.Da);
					elseif JY.Da>0 then
						say("兄弟有需要帮忙的吗？",JY.Da);
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
							say("嗯，咱们比划比划。",JY.Da);
								local result=vs(0,-1,28,JY.Da,29,28,300);
							Cls();
							ShowScreen();
							if result then
								say("好功夫！",JY.Da);
							else
								say("兄弟你还要努力啊，不然日后行走江湖很危险的！",JY.Da);
							end
							DayPass(1);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("如果有需要，随时来找我。",JY.Da);
						end
					else
						script_say("丐帮弟子：丐帮是天下第一大帮。");
					end
				end,
				[3]=function()	--练功场
					if JY.Person[0]["门派"]~=9 or JY.Da<=0 then
						script_say("丐帮弟子：练功贵在持之以恒。");
					else
						say("来练功吧！",JY.Da);
						E_training(JY.Da);
					end
				end,
				[4]=function()	--帮主
					if JY.Person[0]["门派"]~=9 then	--非丐帮弟子
						say("丐帮向为天下第一大帮，帮众子弟遍及大江南北。",JY.Da);
					else
						say("丐帮向为天下第一大帮，帮众子弟遍及大江南北。",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"学武",nil,0},
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
							if JY.Person[0]["等级"]<25 then
								say("你还是先和你其他人练练吧。",JY.Da);
							else
								say("某正好技痒，就和你比划两招吧！",JY.Da);
								local result=vs(0,-1,27,JY.Da,13,26,3000);
								Cls();
								ShowScreen();
								if result then
									say("哈哈，果然厉害，佩服佩服！",JY.Da);
								else
									say("一时侥幸，小兄弟你没事吧。",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							--say("下去吧。",JY.Da);
						end
					end
				end,
				[5]=function()	--书架
					if JY.Person[0]["门派"]==9 then
						say("咦！这里似乎有很多我派前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--休息 无用
					if JY.Person[0]["门派"]==9 then
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
							visit(9);
						end
					else
						visit(9);
					end
					walkto_old(0,3);
				end,
				[7]=function()	--传功 无用
					if JY.Person[0]["门派"]~=9 then	--非丐帮弟子
						say("丐帮弟子人人都行侠仗义，扶危济困。",JY.Da);
					else
						say("丐帮弟子人人都行侠仗义，扶危济困。",JY.Da);
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
							say("长老可以教我点武功防身吗？不然出去外面真的有一点可怕。");
							say("好！我这就叫你武功，你可以好好记得。",JY.Da);
							local kflist={
												{151,10},
												{152,10},
												{153,10},
												{154,10},
												{155,10},
												{158,10},
												{159,10},
												{160,10},
												{161,10},
												{166,10},
												{167,10},
												{168,10},
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
				[8]=function()	--厨房
					if JY.Person[0]["门派"]~=9 then	--非丐帮弟子
						script_say("丐帮弟子：这里是厨房，没什么好看的。");
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
						script_say("丐帮弟子：你别站这里添乱好不好，被师父看到骂死你。");
					end
				end,
				[9]=function()
					if JY.Person[0]["门派"]~=9 or JY.Da<=0 then
						script_say("丐帮弟子：丐帮是天下第一大帮。");
					else
						say("看你刚刚学武的样子，好像少了点什么，我帮你安排切磋的对象，或许可以帮你改正这些缺点。",JY.Da); 
						if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
							say("是！");
							local eid={};
							local num=0;
							for i=1,CC.ToalPersonNum do
								local p=JY.Person[i];
								if p["门派"]==JY.Person[0]["门派"] then
									if p["身份"]<=JY.Person[0]["身份"] then
										num=num+1;
										eid[num]=i;
									end
								end
							end
							for i=1,num-1 do
								for j=i+1,num do
									if JY.Person[eid[i]]["等级"]>JY.Person[eid[j]]["等级"] then
										eid[i],eid[j]=eid[j],eid[i];
									end
								end
							end
							for i=1,num do
								if JY.Person[eid[i]]["等级"]>JY.Person[0]["等级"] then
									num=i;
									break;
								end
							end
							say(string.format("%s和你武功差不多，你们比试一下吧。",JY.Person[eid[num]]["姓名"]),JY.Da);
							if vs(0,-1,28,eid[num],29,28,300) then
								say("不错，看起来你很努力啊。",JY.Da);
								say("指点一下你的武功吧.",JY.Da);
								local add,str=AddPersonAttrib(0,"经验",(4+JY.Person[0]["等级"])*15+200+math.random(50));
								DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
								War_AddPersonLevel(0);
							else
								say("不要灰心，好好努力吧。",JY.Da);
								say("稍微指点一下你的武功吧.",JY.Da);
								local add,str=AddPersonAttrib(0,"经验",(4+JY.Person[0]["等级"])*5+50+math.random(50));
								DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
								War_AddPersonLevel(0);
							end
							DayPass(3);
						else
							say("阿，那个，今天有点不舒服。");
							say("没用的家伙，退下吧。",JY.Da);
							DayPass(1);
						end
					end
				end,
				[11]=function()		--琴
				end,
				[12]=function()		--棋
				end,
			}

						--say("")