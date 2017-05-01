SceneEvent[109]={};--江陵城各事件
SceneEvent[109]={
				[1]=function()--江陵城跳转，坐标修改
					JY.Base["人X"],JY.Base["人Y"]=298,312;
					return true;
				end,
				[2]=function()--渡口
					say("客官想去哪儿？",162);
					local m={
								{"姑苏",nil,1},
								{"取消",nil,1},
							};
					local i=EasyMenu(m);
					if i==1 then
						if false then
							say("哎呀，银两似乎不够。");
						else
							say("好，赶紧启程吧。");
							SmartWalk(62,29,1);
							JY.Status=GAME_MMAP;
							CleanMemory();
							lib.ShowSlow(50,1);
							if JY.MmapMusic<0 then
								JY.MmapMusic=JY.Scene[JY.SubScene]["出门音乐"];
							end
							JY.Base["乘船"]=1;
							JY.Base["人X"],JY.Base["人Y"]=302,310;
							JY.MyPic=GetMyPic();
							Init_MMap();
							JY.SubScene=-1;
							JY.oldSMapX=-1;
							JY.oldSMapY=-1;
							lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
							lib.ShowSlow(50,0)
							lib.GetKey();
							SmartWalk(302,201,1);
							CleanMemory();
							JY.SubScene=130;
							lib.ShowSlow(50,1)
							JY.Base["人X1"],JY.Base["人Y1"]=8,23;
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
				[11]=function()--
				end,
				[1001]=function()--
					return CommonEvent(1,JY.Da)
				end,
			}

						--say("")