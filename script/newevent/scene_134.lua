SceneEvent[134]={};--长安城各事件
SceneEvent[134]={
				[1]=function()--读书习字
					say("要学习读书习字么？这几天我不收费的哦！",JY.Da);
					AddZIZHI(JY.Da);
				end,
				[2]=function()--华拳掌门
					say("为了光大华山一派的拳术，也不能再敝帚自珍了。",JY.Da);
					local kflist={
										{9,10},
										{10,10},
										{11,10},
									};
					LearnKF(0,JY.Da,kflist);
				end,
				[3]=function()--华拳门人
					say("华拳本是江湖一绝，只可惜华山剑气之争后，华山上下要么练气要么练剑，竟无人练拳了。",JY.Da);
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
				[11]=function()--
				end,
				[1001]=function()--
					return CommonEvent(1,JY.Da)
				end,
			}

						--say("")