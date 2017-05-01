SceneEvent[112]={};--姑苏城各事件
SceneEvent[112]={
				[1]=function()--出城，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=308,197;
					return true;
				end,
				[2]=function()--渡口
					say("姑苏城真是好风景啊。",162);
					if GetFlag(20001)==1 then
						script_say("主角：请问船家，去燕子坞三合庄怎么走？");
						say("原来是Ｎ公子啊，庄主早有交代，我会安排船只送您过去。",162);
						say("现在就要出发吗？",162);
						local m={
									{"确定",nil,1},
									{"取消",nil,1},
								};
						local i=EasyMenu(m);
						if i==1 then
							say("好，赶紧启程吧。");
							--SmartWalk(3,23,2);
							JY.Status=GAME_MMAP;
							CleanMemory();
							lib.ShowSlow(50,1);
							if JY.MmapMusic<0 then
								JY.MmapMusic=JY.Scene[JY.SubScene]["出门音乐"];
							end
							JY.Base["乘船"]=1;
							JY.Base["人X"],JY.Base["人Y"]=302,196;
							JY.MyPic=GetMyPic();
							Init_MMap();
							JY.SubScene=-1;
							JY.oldSMapX=-1;
							JY.oldSMapY=-1;
							lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
							lib.ShowSlow(50,0)
							lib.GetKey();
						else
							say("我过两日再去拜访你家庄主吧。");
						end
					end
				end,
				[11]=function()--
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