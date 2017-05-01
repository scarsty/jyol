SceneEvent[52]={};--大理段氏各事件
SceneEvent[52]={
				[2]=function()	--藏书架
					if JY.Person[0]["门派"]==10 then
						say("今天就来参详这本秘籍吧。");
						local kflist=	{
											{JY.Da,10},
										};
						LearnKF(0,320,kflist);
					else
						say("这就是姑苏慕容的还施水阁啊！");
					end
				end,
				[3]=function()	--语嫣
					if JY.Person[0]["门派"]~=10 then	--非慕容家将
						say("啊，您好！",JY.Da);
					elseif JY.Da>0 then
						say("我对他好，他当然知道。他待我也是很好的。可是……可是……",JY.Da);
						local menu={
												{"聊天",nil,1},
												{"切磋",nil,1},
												{"锻炼",nil,0},
												{"学武",nil,0},
												{"状态",nil,1},
												{"没事",nil,1},
											};
						if GetFlag(20003)==1 then
							menu[4][3]=1;
						end
						local r=ShowMenu(menu,5,0,0,0,0,0,1,0);
						if r==1 then
							RandomEvent(JY.Da);
						elseif r==2 then
							say("我什么武功都不会啊，还是算了吧。",JY.Da);
						elseif r==3 then
							E_learning(JY.Da);
						elseif r==4 then
							local kflist={
											{195,10},
											};
							LearnKF(0,JY.Da,kflist);
						elseif r==5 then
							PersonStatus(JY.Da);
						elseif r==6 then
							--say("你若是无事，不妨来聊聊天，或者切磋下武功也好。",JY.Da);
						end
					else
						script_say("王语嫣：我对他好，他当然知道。他待我也是很好的。可是……可是……");
					end
				end,
				[4]=function()	--慕容复
					if JY.Person[0]["门派"]~=10 then	--非慕容家将
						say("想不到阁下居然能找到燕子坞来。",JY.Da);
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
							RandomEvent(JY.Da);
						elseif r==2 then
							if true then
								say("久闻姑苏慕容斗转星移威震武林，不知能否拜入门下？");
								say("我慕容氏本位大燕皇族后裔，你要入我们下也很容易，只要你能发誓助我兴复大燕。",JY.Da);
								if DrawStrBoxYesNo(-1,-1,"是否真的要加入姑苏慕容？",C_WHITE,CC.Fontbig) then
									say("在下愿助公子一臂之力。");
									JY.Person[0]["门派"]=10;
									JY.Shop[5]["入门时间"]=GetFlag(1);
									DrawStrBoxWaitKey(JY.Person[0]["姓名"].."加入Ｏ姑苏慕容",C_WHITE,CC.Fontbig);
									JY.Person[0]["外号"]="慕容家将";
									--GetItem(5,1);
								else
									say("抱歉。");
								end
							end
						elseif r==3 then
							PersonStatus(JY.Da);
						else
							
						end
					else
						say("参见公子爷！");
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
							if GetFlag(20002)==0 and JY.Person[0]["门派"]==10 then
								local n=0;
								for i=1,CC.MaxKungfuNum do
									if JY.Person[0]["所会武功"..i]>0 then
										n=n+1;
									end
								end
								if n>5 then
									SetFlag(20002,1)
									script_say("慕容复：我的一身功夫，大多来自还施水阁中的各派秘籍。你与其找我，不如自去还施水阁查阅各派秘籍。")
									script_say("主角：禀公子，小人亦曾翻阅还施水阁中的秘籍，可是却发现其中并没有高深的心法和身法的记录。")
									script_say("慕容复：嗯。你说的问题，我当年也曾遇到过，这一方面的确是稍有欠缺。这样吧，今日起，我便传你一套[燕灵身法]。至于心法嘛，你可以去向表妹请教。表妹虽不会武，但熟                           知天下武学。相信她能给你一个答复。")
									script_say("主角：谢公子！")
									return;
								end
							end
							if GetFlag(20004)==0 and GetFlag(20002)==1 and JY.Person[0]["门派"]==10 then
								local n=0;
								for i=1,CC.MaxKungfuNum do
									if JY.Person[0]["所会武功"..i]>0 then
										n=n+1;
									end
								end
								if n>10 then
									SetFlag(20004,1)
									script_say("主角：禀公子，小人在还施水阁中寻找多日，却发现各门各派的绝学均没有被收藏进来，不知……")
									script_say("慕容复：不怪你找不到。其实，今日的还施水阁，只是后建成的。而最早我慕容家的祖先收藏各门各派绝学武功的地方，乃是一名叫‘琅嬛福地’的地方。只可惜那‘琅嬛福地’的位置，却早已失传了啊。")
									if GetFlag(20005)==2 then
										script_say("主角：琅嬛福地！我曾经在无量山发现一个山洞，里面有一处收藏武功秘籍的所在，正是叫琅嬛福地")
										script_say("慕容复：是吗！快快带我前去。")
										script_say("主角：公子，我去的时候，那里已经什么收藏都没有了，似乎已经被人取走了啊。")
										script_say("慕容复：什么！什么人居然敢偷盗我慕容家藏书！我定当揪出此人，寻回藏书！")
									end
									return;
								end
							end
							if GetFlag(20002)==0 then
								say("你去还施水阁吧，那里收藏有天下各门各派的武功秘籍。",JY.Da);
							else
								say("哦，你想学点什么？",JY.Da);
								local kflist={
												{193,10},
												{194,10},
												{196,10},
												};
								LearnKF(0,JY.Da,kflist);
							end
						elseif r==3 then
								if JY.Person[0]["体力"]<30 then
									say("我看你气色不太好，还是先好好休息吧。",JY.Da);
									return;
								end
							if JY.Person[0]["等级"]<1 then
								say("你？还是先练好基本功吧",JY.Da);
							else
								say("好，来陪本公子练练！",JY.Da);
								local result=vs(0,21,27,JY.Da,13,26,3000);
								Cls();
								ShowScreen();
								if result then
									say("......",JY.Da);
								else
									say("哈哈，真愉快！",JY.Da);
								end
								DayPass(1);
							end
						elseif r==4 then
							PersonStatus(JY.Da);
						elseif r==5 then
							say("退下！",JY.Da);
						end
					end
				end,
				[5]=function()	--书架
					if JY.Person[0]["门派"]==14 then
						say("咦！这里似乎有很多前辈的练功心得。");
						E_readbook();
					end
				end,
				[6]=function()	--进入 预留以后事件使用
					return true;
				end,
			}

SceneEvent[116]=SceneEvent[52];