SceneEvent[40]={};--洛阳城各事件
SceneEvent[40]={
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
					return CommanEvent(1,JY.Da)
				end,
			}

						--say("")