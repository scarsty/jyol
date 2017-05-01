function ForcePersonPosition()
	local s_table={57};
	for idx1,sid in pairs(s_table) do
		local p_table={};
		AutoSelect(p_table,JY.Person,"身份",">",0);
		AutoSelect(p_table,JY.Person,"所在","==",sid);
		for idx2,pid in pairs(p_table) do
			for did=1,100 do
				GetD(sid,did,2)
			end
		end
	end
end
function PersoninItialize()
	local cx=(CC.ScreenW-460)/2-4;
	local cy=(CC.ScreenH-CC.FontBig)/2-4;
	local tx=(CC.ScreenW-CC.Fontbig*6)/2;
	local ty=(CC.ScreenH-CC.Fontbig)/2-4;
	lib.FillColor(0,0,0,0,0);
	for pid=1,460 do
			DrawNewBox(cx,cy,cx+460,cy+CC.FontBig,C_WHITE);
			DrawNewBox(cx,cy,cx+pid,cy+CC.FontBig,C_WHITE,C_ORANGE);
			DrawString(tx,ty," 数据初始化 ",C_WHITE,CC.Fontbig);
			ShowScreen();
			--lib.Delay(10)
		local p=JY.Person[pid];
		for i=1,80 do
			p["所会武功"..i]=0;
			p["所会武功经验"..i]=0;
		end
		for i=1,5 do
			SetKF(pid,p["外功"..i],p["外功经验"..i]);
		end
		SetKF(pid,p["内功"],p["内功经验"]);
		SetKF(pid,p["轻功"],p["轻功经验"]);
		SetKF(pid,p["特技"],p["特技经验"]);
		--[[for ii=1,3 do
			local sc=p["师承"..ii];
			if sc>0 then
				for j=1,7 do
					local kfid=JY.Shicheng[sc]["武功"..j];
					if kfid>0 then
						if true then--IfCanLearn(pid,kfid) and p["等级"]>JY.Wugong[kfid]["等阶"]^2 then--can learn
							local kflv=10*p["等级"]*(50+p["资质"])/(50+JY.Wugong[kfid]["修炼经验"])/(1+JY.Wugong[kfid]["等阶"]);
							if JY.Wugong[kfid]["武功类型"]>=6 then
								kflv=kflv*0.7;
							end
							kflv=math.modf(kflv);
							if kflv>9 then
								kflv=9;
							end
							if Getkflv(pid,kfid)<kflv then
								SetKF(pid,kfid,kflv*100);
							end
						end
					end
				end
			end
		end]]--
		PersonKungfuSetup(pid);
		ResetPersonAttrib(pid);
		AddPersonAttrib(pid,"生命",math.huge);
		AddPersonAttrib(pid,"内力",math.huge);
	end
	Cls();
end
function PersonKungfuSetup(pid,kind)
	kind=kind or 0;
	pid=pid or 0;
	local p=JY.Person[pid];
	local k={};
	local num=0;
	for i=1,80 do
		local kfid=p["所会武功"..i];
		if kfid<=0 then
			num=i-1;
			break;
		end
		local kflv=1+math.modf(p["所会武功经验"..i]/100);
		local point=-1;
		if kind==0 then
			point=JY.Wugong[kfid]["等阶"]+JY.Wugong[kfid]["伤害"]/10+JY.Wugong[kfid]["攻击"]+JY.Wugong[kfid]["防御"]+JY.Wugong[kfid]["身法"];
			point=point*kflv;
			if point<1 then
				point=1
			end
		end
		k[i]={kfid,p["所会武功经验"..i],point};
	end
	for i=1,num-1 do
		for j=i+1,num do
			if k[i][3]<k[j][3] then
				k[i],k[j]=k[j],k[i];
			end
		end
	end
	for i=1,5 do
		p["外功"..i]=0;
		p["外功经验"..i]=0;
	end
	p["内功"]=0;
	p["内功经验"]=0;
	p["轻功"]=0;
	p["轻功经验"]=0;
	p["特技"]=0;
	p["特技经验"]=0;
	for i=1,num do
		if JY.Wugong[k[i][1]]["武功类型"]<7 then
			for j=1,5 do
				if p["外功"..j]==0 then
					p["外功"..j]=k[i][1];
					p["外功经验"..j]=k[i][2];
					break;
				end
			end
		elseif JY.Wugong[k[i][1]]["武功类型"]==7 then
			p["内功"]=k[i][1];
			p["内功经验"]=k[i][2];
		elseif JY.Wugong[k[i][1]]["武功类型"]==8 then
			p["轻功"]=k[i][1];
			p["轻功经验"]=k[i][2];
		elseif JY.Wugong[k[i][1]]["武功类型"]==9 then
			p["特技"]=k[i][1];
			p["特技经验"]=k[i][2];
		end
		if p["外功1"]>0 and p["外功2"]>0 and p["外功3"]>0 and p["外功4"]>0 and p["外功5"]>0 and p["内功"]>0 and p["轻功"]>0 and p["特技"]>0 then
			break;
		end
	end
end

function DrawMMap()--50 18/9
	local cx,cy=JY.Base["人X"],JY.Base["人Y"];
	local pic_w,pic_h=18,9;
	local sf=50;
	local tx,ty=JY.Base["人X"],JY.Base["人Y"];
	local len=10;
	lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],5,sf);
	--lib.SetClip(CC.ScreenW*1/6,CC.ScreenH*1/6,CC.ScreenW*5/6,CC.ScreenH*5/6);
	local function ReDraw()
		lib.DrawMMapEnhance(cx,cy,5,sf,tx,ty,len);
		DrawStrNewBox(10,10,sf,C_WHITE,32)
		ShowScreen();
	end
	--[[
	for t=1,10 do
		for i=0,479,5 do
			for j=0,479,5 do
				cx,cy=i,j;
				ReDraw();
				getkey();
			end
		end
	end]]--
	while true do
		ReDraw();
		lib.Delay(50);
		local eventtype,keyPress,mx,my=WaitKey(1);
		if eventtype==1 then
			if keyPress==VK_ESCAPE then                  --Esc 退出
				if isEsc==1 then
					break;
				end
			elseif keyPress==VK_UP then                  --Up
				cx=cx-math.modf(100/sf);
				cy=cy-math.modf(100/sf);
			elseif keyPress==VK_DOWN then                --Down
				cx=cx+math.modf(100/sf);
				cy=cy+math.modf(100/sf);
			elseif keyPress==VK_LEFT then                  --Left
				cx=cx-math.modf(100/sf);
				cy=cy+math.modf(100/sf);
			elseif keyPress==VK_RIGHT then                --Right
				cx=cx+math.modf(100/sf);
				cy=cy-math.modf(100/sf);
			end
			cx=limitX(cx,10,470);
			cy=limitX(cy,10,470);
		elseif eventtype==3 then
			mx=mx-CC.ScreenW/2;
			my=my-CC.ScreenH/2;
			mx=mx/math.modf(CC.XScale*sf/100);
			my=my/math.modf(CC.YScale*sf/100);
			mx,my=(mx+my)/2,(my-mx)/2;
			if mx>0 then mx=mx+0.99 else mx=mx-0.01 end
			if my>0 then my=my+0.99 else mx=mx-0.01 end
			mx=cx+math.modf(mx);
			my=cy+math.modf(my);
			local yyx=lib.GetMMap(mx,my,3);
			local yyy=lib.GetMMap(mx,my,4);
			local flag=false;
			if yyx>0 and yyy>0 then
				local v=lib.GetMMap(yyx,yyy,2);
				for i=-5,5 do
					for j=-5,5 do
						if lib.GetMMap(yyx+i,yyy+j,3)==yyx and lib.GetMMap(yyx+i,yyy+j,4)==yyy then
							local sid=CanEnterScene(yyx+i,yyy+j);
							if sid>=0 then
								if true then
									tx=yyx+i;
									ty=yyy+j;
									len=10+math.modf(sid/10);
									flag=true;
								end
							end
							if flag then
								break;
							end
						end
					end
					if flag then
						break;
					end
				end
			end
			if not flag then
				len=-1;
			end
		elseif eventtype==4 then
			local oldsf=sf;
			local off=10;
			if sf<50 then
				off=5;
			end
			if keyPress==4 then
				if sf<50 then
					sf=sf+5;
				else
					sf=sf+10;
				end
			elseif keyPress==5 then
				if sf<=50 then
					sf=sf-5;
				else
					sf=sf-10;
				end
			end
			sf=limitX(sf,25,100);
			if sf~=oldsf then
				lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],5,sf);
				lib.Delay(5);
				lib.GetKey();
			end
		end
	end
	lib.SetClip(0,0,0,0);
end