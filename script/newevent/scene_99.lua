SceneEvent[99]={};--无量山
SceneEvent[99]={
				[1]=function()--入口，迷宫
					Dark();
					migong(14,28);
					if Rnd(2)==0 then
						SetS(JY.SubScene,14,5,1,0)
						SetS(JY.SubScene,15,5,1,0)
						SetS(JY.SubScene,16,5,1,0)
						SetS(JY.SubScene,17,5,1,0)
						SetS(JY.SubScene,18,5,1,0)
						SetS(JY.SubScene,19,5,1,0)
					else
						SetS(JY.SubScene,14,56,1,0)
						SetS(JY.SubScene,15,56,1,0)
						SetS(JY.SubScene,16,56,1,0)
						SetS(JY.SubScene,17,56,1,0)
						SetS(JY.SubScene,18,56,1,0)
						SetS(JY.SubScene,19,56,1,0)
					end
					SetS(JY.SubScene,45,36,1,0)
					SetS(JY.SubScene,46,36,1,0)
					SetS(JY.SubScene,47,36,1,0)
					SetS(JY.SubScene,48,36,1,0)
					SetS(JY.SubScene,49,36,1,0)
					JY.Base["人X1"]=JY.Base["人X1"]-1
					Init_SMap(1);
				end,
				[1001]=function()--
					return CommanEvent(1,JY.Da)
				end,
			}

						--say("")