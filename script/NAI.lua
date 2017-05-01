--testing....AI
function War_Auto()
	--[[
	callmovestep
	对移动点评分
	对 攻击(算上位置) 休息 吃药等等评分
	然后选择高的
	移动到分高的
	
	callmovestep后，记录下全部点
	对点评分，分两部分，远离我方  以及  和敌人的距离  
	然后 对吃药评分...休息评分...
	对各个武功评分，选出武功评分中最高的
	然后选最高的
	]]--
	local pid=WAR.Person[WAR.CurID]["人物编号"];
	WAR.ShowHead=1;
	WarDrawMap(0);
	ShowScreen();
	lib.Delay(CC.WarAutoDelay);
    if CC.AutoWarShowHead==0 then
	    WAR.ShowHead=0;
	end
	if WAR.Person[WAR.CurID]["封穴"]>0 then
		War_RestMenu();
		return 9;
	end
	local movearray=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);
	WarDrawMap(1);
	ShowScreen();
	local starttime=lib.GetTime();
	local selectKF=War_AutoSelectWugong(pid);
	if selectKF<1 then
		starttime=lib.GetTime()-starttime;
		if starttime<200 then
			lib.Delay(200-starttime);
		end
		AutoMove();
		War_RestMenu();
		return 9;
	end
	local us={[0]=0,};
	local notus={[0]=0,};
	for i=0,WAR.PersonNum-1 do
		if WAR.Person[i]["死亡"]==false and i~=WAR.CurID then
			if WAR.Person[i]["我方"]==WAR.Person[WAR.CurID]["我方"] then
				us[0]=us[0]+1;
				us[us[0]]=i;
			else
				notus[0]=notus[0]+1;
				notus[notus[0]]=i;
			end
		end
	end
	for i=0,WAR.Person[WAR.CurID]["移动步数"] do
		movearray[i].p={};
		for j=1,movearray[i].num do
			--给出移动位置的评分
			local x=movearray[i].x[j];
			local y=movearray[i].y[j];
			local p=0;
			for k=1,us[0] do
				local wid=us[k];
				local dx=math.abs(WAR.Person[wid]["坐标X"]-x);
				local dy=math.abs(WAR.Person[wid]["坐标Y"]-y);
				if dx<5 and dy<5 then
					p=p+math.min(dx,dy);
				else
					p=p+5;
				end
				if dx+dy<7 then
					p=p+dx+dy;
				else
					p=p+7;
				end
				if math.min(dx,dy)<2 then
					p=p+math.min(math.max(dx,dy),10);
				else
					p=p+10;
				end
				if dx==dy then
					p=p+math.min(dx,7);
				else
					p=p+7;
				end
			end
			for k=1,notus[0] do
				local wid=notus[k];
				local eid=WAR.Person[wid]["人物编号"];
				local dx=math.abs(WAR.Person[wid]["坐标X"]-x);
				local dy=math.abs(WAR.Person[wid]["坐标Y"]-y);
				if dx+dy>JY.Person[eid]["身法"]/15+JY.Person[eid]["等级"]/15 then
					p=p+2;
				end
			end
			movearray[i].p[j]=p;
		end
	end
	local atk_kf,mov_x,mov_y,atk_x,atk_y,atk_p;
	atk_kf={};
	mov_x={};
	mov_y={};
	atk_x={};
	atk_y={};
	atk_p={};
	for ii=selectKF,selectKF do
		CleanWarMap(4,-1);
		local kfid=JY.Person[pid]["外功"..ii];
		local kflv=GetLv(pid,ii)--1+div100(JY.Person[pid]["外功经验"..ii]);
			
		if kfid>0 and kflv>0 and JY.Person[pid]["内力"]>=JY.Wugong[kfid]["消耗内力点数"] then
			local movfw,atkfw;
			for lv=kflv,1,-1 do
				if JY.Kungfu[kfid]["攻击范围"][lv]~=nil then
					movfw=JY.Kungfu[kfid]["攻击范围"][lv];
					break;
				end
			end
			for lv=kflv,1,-1 do
				if JY.Kungfu[kfid]["伤害范围"][lv]~=nil then
					atkfw=JY.Kungfu[kfid]["伤害范围"][lv];
					break;
				end
			end
			--武功和武功等级计算出来了，这里计算下武功的威力。暂时略
			local hurt=GetAtk(pid,kfid,kflv);
			--movfw=JY.Kungfu[kfid]["攻击范围"][math.modf((kflv+2)/3)];
			--atkfw=JY.Kungfu[kfid]["伤害范围"][math.modf((kflv+2)/3)];
			for i=0,WAR.Person[WAR.CurID]["移动步数"] do
				for j=1,movearray[i].num do
					--给出武功的评分
					local x=movearray[i].x[j];
					local y=movearray[i].y[j];
					local p,ax,ay=GetAtkNum(x,y,movfw,atkfw,hurt);
					if p>0 then
						--这里加上位置评分,内力影响也加在这
						p=p+movearray[i].p[j];
						local idx=ii;
						for index,k in pairs{1,2,3,4,5,6,7,8,9,10} do
							if atk_p[k]==nil then
								atk_kf[k],mov_x[k],mov_y[k],atk_x[k],atk_y[k],atk_p[k]=idx,x,y,ax,ay,p;
								break
							elseif p>=atk_p[k] then
								--lib.Debug(k..'--'..p)
								atk_kf[k],mov_x[k],mov_y[k],atk_x[k],atk_y[k],atk_p[k],idx,x,y,ax,ay,p=idx,x,y,ax,ay,p,atk_kf[k],mov_x[k],mov_y[k],atk_x[k],atk_y[k],atk_p[k];
								--break;
							end
						end
					end
				end
			end
		end
	end
	
	local drug_p=0;	--吃药评分
	
	local rest_p=0;	--休息评分
	
	local wait_p=0;	--等待评分
	
	starttime=lib.GetTime()-starttime;
	--lib.Debug('time:'..starttime)
	if starttime<200 then
		lib.Delay(200-starttime);
	end
	local choose=math.random(5);
	if atk_p[choose]==nil then
		choose=0;
		for i=1,5 do
			if atk_p[i]~=nil then
				choose=i;
				break;
			end
		end
	end
	if choose~=0 then
		War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);
		War_MovePerson(mov_x[choose],mov_y[choose]);
		War_Fight_Sub(WAR.CurID,atk_kf[choose],atk_x[choose],atk_y[choose]);
		return 2;
	else
		AutoMove();
		War_RestMenu();
		return 9;
	end
end

--重写移动函数，主要是加入zoc，即当附近有敌人时，移动力额外减1
function War_CalMoveStep(id,stepmax,flag)
	
  	CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，

    local x=WAR.Person[id]["坐标X"];
    local y=WAR.Person[id]["坐标Y"];

	local steparray={};     --用数组保存第n步的坐标。
	for i=0,stepmax do
	    steparray[i]={};
		steparray[i].num=0;
		steparray[i].canmove={};
        steparray[i].x={};
        steparray[i].y={};
	end

	SetWarMap(x,y,3,0);
    steparray[0].num=1;
	steparray[0].canmove[1]=true;					--还能移动的步数
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	for i=0,stepmax-1 do
		War_FindNextStep(steparray,i,flag,id);
		if steparray[i+1].num==0 then
			break;
		end
	end
	return steparray;
end
--被上面的函数调用
function War_FindNextStep(steparray,step,flag,id)      --设置下一步可移动的坐标
	local num=0;
	local step1=step+1;
	for i=1,steparray[step].num do
		if steparray[step].canmove[i] then
			local x=steparray[step].x[i];
			local y=steparray[step].y[i];
			for direct=1,4 do
				local nx=x+CC.DirectX[direct];
				local ny=y+CC.DirectY[direct];
				if between(nx,1,62) and between(ny,1,62) then
					local v=GetWarMap(nx,ny,3);
					if v==255 and War_CanMoveXY(nx,ny,flag)==true then
						num=num+1;
						steparray[step1].x[num]=nx;
						steparray[step1].y[num]=ny;
						steparray[step1].canmove[num]=true;
						if flag==0 then
							for d=1,4 do
								local zx,zy=nx+CC.DirectX[d],ny+CC.DirectY[d];
								if between(zx,1,62) and between(zy,1,62) then
									local vv=GetWarMap(zx,zy,2);
									if vv>=0 then
										if WAR.Person[id]["我方"]~=WAR.Person[vv]["我方"] then
											steparray[step1].canmove[num]=false;
											break;
										end
									end
								end
							end
						end
						SetWarMap(nx,ny,3,step1);
					end
				end
			end
		end
	end
	steparray[step1].num=num;
end

function War_BeforeAction()
	local pid=WAR.Person[WAR.CurID]["人物编号"];
	local tmp1,tmp2;
	for i,v in pairs{"封穴","吃力","恍惚","入魔"} do
		if WAR.Person[WAR.CurID][v]>0 then
			local power=5+Rnd(5);
			WAR.Person[WAR.CurID][v]=limitX(WAR.Person[WAR.CurID][v]-power,0,100);
			if WAR.Person[WAR.CurID][v]==0 then
				AddShowString(WAR.CurID,v.."解除了",M_DarkOrange);
			end
		end
	end
	if WAR.Person[WAR.CurID]["封穴"]>0 then
		AddShowString(WAR.CurID,"封穴中，无法行动",M_Olive);
	elseif WAR.Person[WAR.CurID]["恍惚"]>0 then
		AddShowString(WAR.CurID,"恍惚中，随意行动",M_Olive);
	end
	ShowWarString();
end

function War_AfterAction(r)
	local pid=WAR.Person[WAR.CurID]["人物编号"];
	local tmp1,tmp2;
	tmp1,tmp2=smagic(pid,56,1);
	if myRnd100()<tmp1 then
		local yc=false;
		for i,v in pairs{"中毒","内伤","流血"} do
			if JY.Person[pid][v]>0 then
				JY.Person[pid][v]=0;
				yc=true;
			end
		end
		for i,v in pairs{"骨折","封穴","吃力","恍惚","入魔"} do
			if WAR.Person[WAR.CurID][v]>0 then
				WAR.Person[WAR.CurID][v]=0;
				yc=true;
			end
		end
		if yc then
			AddShowString(WAR.CurID,"异常状态全部解除",M_DarkOrange);
		end
	end
	for i,v in pairs{"中毒","内伤","流血"} do
		if JY.Person[pid][v]>0 then
			local gl=30-math.modf(JY.Person[pid][v]/5);
			if r==9 then
				gl=gl+10;
			end
			local vv=myRnd100();
			local power=Rnd(6);
			if math.random(5)==1 then
				power=power+4;
			end
			if vv<gl then
				AddPersonAttrib(pid,v,-power);
				AddShowString(WAR.CurID,v.."减轻了",M_DarkOrange);
			elseif vv<50 then
				AddPersonAttrib(pid,v,power);
				AddShowString(WAR.CurID,v.."加重了",M_Olive);
			end
		end
	end
	for i,v in pairs{"骨折"} do
		if WAR.Person[WAR.CurID][v]>0 then
			local gl=30-math.modf(WAR.Person[pid][v]/5);
			if r==9 then
				gl=gl+10;
			end
			local vv=myRnd100();
			local power=Rnd(6);
			if vv<gl then
				power=power+4;
				WAR.Person[WAR.CurID][v]=limitX(WAR.Person[WAR.CurID][v]-power,0,100);
				AddShowString(WAR.CurID,v.."减轻了",M_DarkOrange);
			elseif vv<50 then
				WAR.Person[WAR.CurID][v]=limitX(WAR.Person[WAR.CurID][v]+power,0,100);
				AddShowString(WAR.CurID,v.."加重了",M_Olive);
			end
		end
	end
	ResetPersonAttrib(pid);
	tmp1,tmp2=smagic(pid,45,1);
	if tmp1>0 then
		local v=AddPersonAttrib(pid,"生命",JY.Person[pid]["生命最大值"]*tmp1/100);
		if v>0 then
			AddShowString(WAR.CurID,string.format("生命恢复 +%d",v),M_Pink);
		end
	end
	tmp1,tmp2=smagic(pid,46,1);
	if tmp1>0 then
		local v=AddPersonAttrib(pid,"内力",JY.Person[pid]["内力最大值"]*tmp1/100);
		if v>0 then
			AddShowString(WAR.CurID,string.format("内力恢复 +%d",v),M_RoyalBlue);
		end
	end
	tmp1,tmp2=smagic(pid,47,1);
	if tmp1>0 then
		local v=AddPersonAttrib(pid,"体力",tmp1);
		if v>0 then
			AddShowString(WAR.CurID,string.format("体力恢复 +%d",v),M_Yellow);
		end
	end
	if JY.Person[pid]["流血"]>0 then
		local v=AddPersonAttrib(pid,"生命",-math.modf(JY.Person[pid]["流血"]+JY.Person[pid]["生命"]*JY.Person[pid]["流血"]/200));
		AddShowString(WAR.CurID,string.format("流血损伤 %d",v),M_Red);
	end
	ShowWarString();
end
function War_AutoSelectWugong(pid)           --自动选择合适的武功
    local probability={};       --每种武功选择的概率
    local wugongnum=0;         --从0开始计算武功总数目
	for i =1,5 do             --计算每种可选择武功的总攻击力
		local kfid=JY.Person[pid]["外功"..i];
		local kflv=GetLv(pid,i);
        if kfid>0 and JY.Wugong[kfid]["武功类型"]<=6 then
				if JY.Wugong[kfid]["消耗内力点数"]*kflv<=JY.Person[pid]["内力"] then
					wugongnum=wugongnum+1
					probability[wugongnum]={i,GetAtk(pid,kfid,kflv)*JY.Wugong[kfid]["等阶"]}
				end
        end
    end

    local maxoffense=0;       --计算最大攻击力
	for i =1, wugongnum do
        if  probability[i][2]>maxoffense then
            maxoffense=probability[i][2];
        end
    end

    local mynum=0;             --计算我方和敌人个数
	local enemynum=0;
	for i =1, wugongnum do       --考虑其他概率效果
        if probability[i][2]>0 then
		    if probability[i][2]<maxoffense/2 then       --去掉攻击力小的武功
			    probability[i][2]=0
			end
        end
    end

	local s={};           --按照概率依次累加
	local maxnum=0;
    for i=1,wugongnum do
        s[i]=maxnum;
		maxnum=maxnum+probability[i][2];
	end
	s[wugongnum+1]=maxnum;

	if maxnum==0 then    --没有可以选择的武功
	    return -1;
	end

    local v=Rnd(maxnum);            --产生随机数
	local selectid=0;
    for i=1,wugongnum do            --根据产生的随机数，寻找落在哪个武功区间
	    if v>=s[i] and v< s[i+1] then
		    selectid=probability[i][1];
			break;
		end
	end
    return selectid;
end
