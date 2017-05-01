SceneEvent[42]={};--无量山洞
SceneEvent[42]={
				[1]=function()--福地
					if GetFlag(20005)==0 then
						if GetFlag(20004)==1 then
							SetFlag(20005,1)
							script_say("主角：（这……这难道就是传说中的‘琅嬛福地’？不行，我要赶紧通知公子！）")
							Dark();
								SetS(42,32,13,1,6304);
							Light();
							script_say("慕容复：这……这……没错！这就是我慕容家先祖所提及的‘琅嬛福地’！老天开眼，终于在复这一代使我慕容家的传家宝地得以寻回！这次你立了大功了！来，跟我一起将这些典籍搬回燕子坞。日后，你可自去还施水阁翻阅这些典籍，作为你立功的奖励。")
							script_say("主角：谢公子恩典！")
							Dark();
								SetS(42,32,13,1,0);
								for i,v in pairs(CC.Scene_S) do
									JY.Scene[116][i]=JY.Scene[52][i];
								end
								JY.Scene[52]["进入条件"]=1;
								JY.Shop[10]["据点"]=116
								Cal_EnterSceneXY();
							Light();
						else
							SetFlag(20005,2)
							script_say("主角：这是？似乎收藏了很多秘笈啊。")
							Dark();
							Light();
							script_say("主角：这书架上的签条......“昆仑派”、“少林派”、“四川青城派”、“山东蓬莱派”......")
							Dark();
							Light();
							script_say("主角：嗯？怎么是白纸！！莫非是有人捷足先登了！？")
							local add,str=AddPersonAttrib(0,"经验",5000);
							DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
							War_AddPersonLevel(0);
							local add,str=AddPersonAttrib(0,"修炼点数",10000);
							DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
						end
					else
						return true;
					end
				end,
				[1001]=function()--
					return CommanEvent(1,JY.Da)
				end,
			}

						--say("")