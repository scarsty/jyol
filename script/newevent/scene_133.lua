SceneEvent[133]={};--洛阳各事件
SceneEvent[133]={
				[1]=function()--洛阳城跳转，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=223,240;
					return true;
				end,
				[2]=function()--渡口
					say("客官想去哪儿？",162);
					local m={
								{"风陵渡",nil,1},
								{"取消",nil,1},
							};
					local i=EasyMenu(m);
					if i==1 then
						if false then
							say("哎呀，银两似乎不够。");
						else
							say("好，赶紧启程吧。");
							--SmartWalk(62,29,1);
							JY.Status=GAME_MMAP;
							CleanMemory();
							lib.ShowSlow(50,1);
							if JY.MmapMusic<0 then
								JY.MmapMusic=JY.Scene[JY.SubScene]["出门音乐"];
							end
							JY.Base["乘船"]=1;
							JY.Base["人X"],JY.Base["人Y"]=216,240;
							JY.MyPic=GetMyPic();
							Init_MMap();
							JY.SubScene=-1;
							JY.oldSMapX=-1;
							JY.oldSMapY=-1;
							lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
							lib.ShowSlow(50,0)
							lib.GetKey();
							SmartWalk(192,269,0);
							CleanMemory();
							JY.SubScene=132;
							lib.ShowSlow(50,1)
							JY.Base["人X1"],JY.Base["人Y1"]=22,46;
							JY.Status=GAME_SMAP;
							JY.MmapMusic=-1;
							JY.Base["乘船"]=0;
							JY.MyPic=GetMyPic();
							Init_SMap(1);
						end
					else
						say("我只是随便看看。");
					end
				end,
				[100]=function()--消灭魔教妖人
					if JY.Person[0]["门派"]>=0 then
						say("原来你躲在这里啊！拿命来吧！");
						if vs(0,12,33,JY.Da,7,33,500,0) then
							ModifyD(JY.SubScene,JY.CurrentD,0,-2,0,0,-2,0,0,0,0,-2,-2);
							MyQuest[1]=2;
						else
							JY.Status=GAME_END;
						end
					end
				end,
				[11]=function()--小乞丐
					script_say("小乞丐：大哥哥，求求你好心打发一点吧……我好饿啊……")
					script_say("主角：这……")
					if DrawStrBoxYesNo(-1,-1,"是否施舍？",C_WHITE,CC.Fontbig) then
						script_say("主角：唉……可怜的孩子，只是我也并无太多钱财，只有这些，你先拿着吧。")
						script_say("小乞丐：谢谢大哥哥！谢谢！大哥哥你好人一定会有好报的！谢谢！")
						script_say("主角：唉……作孽啊……")
					else
						script_say("主角：小兄弟，你有手有脚，为何不去想法养活自己，反而做次乞讨之事？人需自强自爱方能自立啊。")
						script_say("小乞丐：大哥哥，你说的我都不懂。我好饿啊……求求你发发善心吧……")
						script_say("主角：唉……朽木不可雕也……")
					end
				end,
				[12]=function()--
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