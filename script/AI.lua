------------------------------------------------------------------------------------
-----------------------------------自动战斗---------------------------------------
function War_Auto()             --自动战斗主函数

	WAR.ShowHead=1;
	WarDrawMap(0);
	ShowScreen();
	lib.Delay(CC.WarAutoDelay);

    if CC.AutoWarShowHead==0 then
	    WAR.ShowHead=0;
	end

    local autotype=War_Think();         --思考如何战斗
	
	if WAR.Person[WAR.CurID]["AI"]==4 then
		autotype=1 
	end
	
    if autotype==0 then  --休息
        War_AutoEscape();  --先跑开
        War_RestMenu();
    elseif autotype==1 then
        War_AutoFight();      --自动战斗
    elseif autotype==2 then    --吃药加生命
        War_AutoEscape();
        War_AutoEatDrug(2);
    elseif autotype==3 then    --吃药加内力
        War_AutoEscape();
         War_AutoEatDrug(3);
    elseif autotype==4 then    --吃药加体力
        War_AutoEscape();
        War_AutoEatDrug(4);
    elseif autotype==5 then    --自己医疗，先屏蔽掉
        War_AutoEscape();
        --War_AutoDoctor();
    elseif autotype==6 then    --吃药解毒
        War_AutoEscape();
        War_AutoEatDrug(6);
    end

    return 0;
end

--思考如何战斗
--返回：0 休息， 1 战斗，2 使用物品增加生命， 3 使用物品增加内力 4 吃药加体力， 5 医疗
--     6 使用物品解毒

function War_Think()           --思考如何战斗
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local r=-1;         --考虑的结果

    if JY.Person[pid]["体力"] <10 then         --休息
        r=War_ThinkDrug(4);
        if r>=0 then
            return r;
        end
        return 0;
    end

    if JY.Person[pid]["生命"]<20 then--or JY.Person[pid]["受伤程度"]>50 then
        r=War_ThinkDrug(2);       --考虑增加生命
        if r>=0 then
            return r;
        end
    end

    local rate=-1;         --增加生命的百分比
    if JY.Person[pid]["生命"] <JY.Person[pid]["生命最大值"] /5 then
        rate=90;
    elseif JY.Person[pid]["生命"] <JY.Person[pid]["生命最大值"] /4 then
        rate=70;
    elseif JY.Person[pid]["生命"] <JY.Person[pid]["生命最大值"] /3 then
        rate=50;
    elseif JY.Person[pid]["生命"] <JY.Person[pid]["生命最大值"] /2 then
        rate=25;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(2);       --考虑增加生命
        if r>=0 then
            return r;
        else             --没有增加生命的药，考虑是否自己医疗
		    r=War_ThinkDoctor();
		    if r>=0 then
		       return r;
		    end
        end
    end

    rate=-1;         --增加内力的百分比
    if JY.Person[pid]["内力"] <JY.Person[pid]["内力最大值"] /5 then
        rate=75;
    elseif JY.Person[pid]["内力"] <JY.Person[pid]["内力最大值"] /4 then
        rate=50;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(3);       --考虑增加内力
        if r>=0 then
            return r;
        end
    end

	--[[
    rate=-1;         --解毒的百分比
    if JY.Person[pid]["中毒程度"] > CC.PersonAttribMax["中毒程度"] *3/4 then
        rate=60;
    elseif JY.Person[pid]["中毒程度"] >CC.PersonAttribMax["中毒程度"] /2 then
        rate=30;
    end

    if Rnd(100)<rate then
        r=War_ThinkDrug(6);       --考虑解毒
        if r>=0 then
            return r;
        end
    end
]]--
    local minNeili=War_GetMinNeiLi(pid);     --所有武功的最小内力

    if JY.Person[pid]["内力"]>=minNeili then
        r=1;
    else
        r=0;
    end
	if WAR.Person[WAR.CurID]["AI"]==3 or WAR.Person[WAR.CurID]["AI"]==5 then
		r=0
	end
    return r;
end

--能否吃药增加参数
--flag=2 生命，3内力；4体力  6 解毒
function War_ThinkDrug(flag)             --能否吃药增加参数
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local str;
    local r=-1;

    if flag==2 then
        str="加生命";
    elseif flag==3 then
        str="加内力";
    elseif flag==4 then
        str="加体力";
    elseif flag==6 then
        str="加中毒解毒";
    else
        return r;
    end

    local function Get_Add(thingid)    --定义局部函数。取得物品thingid增加的值
		if flag==6 then
			return -JY.Thing[thingid][str];   --解毒为负值
		else
			return JY.Thing[thingid][str];
		end
    end

    if WAR.Person[WAR.CurID]["我方"]==true then
        for i =1, CC.MyThingNum do
            local thingid=JY.Base["物品" ..i];
            if thingid>=0 then
                if JY.Thing[thingid]["类型"]==3 and Get_Add(thingid)>0 then
                    r=flag;                     ---有增加生命的药，则动作：使用物品加生命
                    break;
                end
            end
        end
    else
        for i =1, 4 do
            local thingid=JY.Person[pid]["携带物品" ..i];
            if thingid>=0 then
                if JY.Thing[thingid]["类型"]==3 and Get_Add(thingid)>0  then
                    r=flag;                     ---有增加生命的药，则动作：使用物品加生命
                    break;
                end
            end
        end
    end

    return r;

end


--考虑是否自己医疗
function War_ThinkDoctor()          --考虑是否给自己医疗
    local pid=WAR.Person[WAR.CurID]["人物编号"];

	if JY.Person[pid]["体力"]<50 or JY.Person[pid]["医疗"]<20 then
	    return -1;
	end
--[[
	if JY.Person[pid]["受伤程度"]>JY.Person[pid]["医疗"]+20 then
	    return -1;
	end
]]--
	local rate = -1;
	local v=JY.Person[pid]["生命最大值"]-JY.Person[pid]["生命"];
	if JY.Person[pid]["医疗"] < v/4 then
        rate=30;
	elseif JY.Person[pid]["医疗"] < v/3 then
	    rate=50;
	elseif JY.Person[pid]["医疗"] < v/2 then
	    rate=70;
	else
	    rate=90;
	end

	if Rnd(100) <rate then
	    return 5;
	end

	return -1;
end

---自动战斗
function War_AutoFight()             ---执行自动战斗

	local wugongnum=War_AutoSelectWugong();    --选择武功

	if wugongnum <=0 then --没有选择到武功，休息
        War_AutoEscape();
        War_RestMenu();
		return
	end
	newAI(wugongnum)
	--[[
	local r=War_AutoMove(wugongnum);         -- 往敌人方向移动
	if r==1 then   --如果在攻击范围
		War_AutoExecuteFight(wugongnum);     --攻击
	else
   	    War_RestMenu();           --休息
	end
	]]--
end


function War_AutoSelectWugong()           --自动选择合适的武功
    local pid=WAR.Person[WAR.CurID]["人物编号"];

    local probability={};       --每种武功选择的概率

    local wugongnum=0;         --从0开始计算武功总数目
	for i =1, CC.Kungfunum do             --计算每种可选择武功的总攻击力
        local wugongid=JY.Person[pid]["武功" ][i];
		if wugongid~=nil then wugongid=wugongid[1]
		else wugongid=0 
		end
		--lib.Debug(JY.Wugong[wugongid]["名称"])
        if wugongid>0 and JY.Wugong[wugongid]["武功类型"]<=6 and JY.Wugong[wugongid]["伤害类型"]==0 then
		       --选择杀生命的武功，必须消耗内力比现有内力小，起码可以发出一级的武功。
            --if JY.Wugong[wugongid]["伤害类型"]==0 then
				if JY.Wugong[wugongid]["消耗内力点数"]<=JY.Person[pid]["内力"] then
					local level=math.modf(JY.Person[pid]["武功"][i][2]/100)+1;
					--总攻击力即为概率
					wugongnum=wugongnum+1
					probability[wugongnum]={i,GetAtk(pid,wugongid,level)}              --(JY.Person[pid]["攻击力"]*3+JY.Wugong[wugongid]["攻击力" .. level ])/2;
					--lib.Debug(probability[wugongnum][1].."|"..probability[wugongnum][2]..'|'..level)
				else
					--probability[i]=0;
				end
			--else            --杀内力的武功
            --   probability[i]=10;  --很小的概率选择杀内力
			--end
		else
			--probability[i]=0;
		    --wugongnum=i-1;
			--break;
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
	for i=0, WAR.PersonNum-1 do
	    if WAR.Person[i]["死亡"]==false then
		    if WAR.Person[i]["我方"]==WAR.Person[WAR.CurID]["我方"] then
			    mynum=mynum+1;
			else
			    enemynum=enemynum+1;
			end
		end
	end
--[[
    local factor=0;       --敌人人数影响因子，敌人多则对线面等攻击多人武功的选择概率增加
	if enemynum>mynum then
	    factor=2;
	else
	    factor=1;
	end
]]--
	for i =1, wugongnum do       --考虑其他概率效果
        local wugongid=JY.Person[pid]["武功"][i][1];
        if probability[i][2]>0 then
		    if probability[i][2]<maxoffense/2 then       --去掉攻击力小的武功
			    probability[i][2]=0
			end
			--[[
			local extranum=0;           --武功武器配合的攻击力
			for j,v in ipairs(CC.ExtraOffense) do
				if v[1]==JY.Person[pid]["武器"] and v[2]==wugongid then
					extranum=v[3];
					break;
				end
			end
			]]--
    		--local level=math.modf(JY.Person[pid]["武功等级" .. i]/100)+1;
			--local mmove=JY.Wugong[wugongid]["范围"..math.modf((level+2)/3)]
			--mmove=mmove-100*div100(mmove)
			--probability[i]=probability[i]--+JY.Wugong[wugongid]["攻击范围"]*factor*mmove*20;
        end
    end

	local s={};           --按照概率依次累加
	local maxnum=0;
    for i=1,wugongnum do
		--lib.Debug(probability[i][1]..'|'..probability[i][2])
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


function War_AutoSelectEnemy()             --选择战斗对手
    local enemyid=War_AutoSelectEnemy_near()
    WAR.Person[WAR.CurID]["自动选择对手"]=enemyid;
    return enemyid;
end


function War_AutoSelectEnemy_near()              --选择最近对手

    War_CalMoveStep(WAR.CurID,100,1);           --标记每个位置的步数

    local maxDest=math.huge;
    local nearid=-1;
    for i=0,WAR.PersonNum-1 do           --查找最近步数的敌人
        if WAR.Person[WAR.CurID]["我方"] ~=WAR.Person[i]["我方"] then
            if WAR.Person[i]["死亡"]==false then
			   local step=GetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],3);
                if step<maxDest then
                    nearid=i;
                    maxDest=step;
                end
            end
        end
    end
    return nearid;
end

--自动往敌人方向移动
--人物武功编号，不是武功id
--返回 1=可以攻击敌人， 0 不能攻击
function War_AutoMove(wugongnum)              --自动往敌人方向移动
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local wugongid=JY.Person[pid]["武功"][wugongnum][1];
    local level=math.modf(JY.Person[pid]["武功"][wugongnum][2]/100)+1;
	--local kind,len1,len2

    local wugongtype=JY.Wugong[wugongid]["攻击范围"];
	local move=JY.Wugong[wugongid]["攻击范围"][math.modf((level+2)/3)][2];
	local movescope=div100(move);
	--kind=movescope
	if movescope>7 then movescope=0 end
	local fightscope=math.fmod(move,10);
	--len2=fightscope
    local scope=movescope+fightscope;
	--len1=math.modf(math.fmod(move,100)/10)


    local x,y;
	local move=128;
    local maxenemy=0;

	local movestep=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);   --计算移动步数

	--War_AutoCalMaxEnemyMap(wugongid,level);  --计算该武功各个坐标可以攻击到敌人的个数

	for i=0,WAR.Person[WAR.CurID]["移动步数"] do
	    local step_num=movestep[i].num ;
		if step_num==nil or step_num==0 then
		    break;
		end
		for j=1,step_num do
		    local xx=movestep[i].x[j];
			local yy=movestep[i].y[j]

			local num=0;
			--[[
			if wugongtype==0 or wugongtype==2 or wugongtype==3 then
				num=GetWarMap(xx,yy,4)      --计算这个位置可以攻击到的最多敌人个数
			elseif wugongtype==1  then
				local v=GetWarMap(xx,yy,4)      --计算这个位置可以攻击到的最多敌人个数
				if v>0 then
					num=War_AutoCalMaxEnemy(xx,yy,wugongid,level);
				end
			end
			]]--
			--以上感觉就是先根据人物移动步数循环，获取走到的xy
			--然后，根据该xy第四层的信息——获取改点能攻击到的敌人数目
			--War_AutoCalMaxEnemyMap感觉意义不大，可以考虑改造War_AutoCalMaxEnemy
			--使其返回攻击敌人的最大数目
			num=GetAtkNum(xx,yy,wugongid,level)
			if num>maxenemy then
				maxenemy=num
				x=xx;
				y=yy;
				move=i;
			elseif num==maxenemy and num>0 then
			    if Rnd(3)==0 then
					maxenemy=num
					x=xx;
					y=yy;
					move=i;
				end
			end
		end
	end


    if maxenemy>0 then
	    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);   --重新计算移动步数
        War_MovePerson(x,y);    --移动到相应的位置
		return 1;
	else   --任何移动都直接攻击不到敌人，寻找一条可以移动到攻击到敌人位置的路线
		x,y=War_GetCanFightEnemyXY(scope);       --计算可以攻击到敌人的最近位置

		local minDest=math.huge;
        if x==nil then   --无法走到可以攻击敌人的地方，可能敌人被围住，或者被敌人围住。
             local enemyid=War_AutoSelectEnemy()   --选择最近敌人

			 War_CalMoveStep(WAR.CurID,100,0);   --计算移动步数 假设最大100步

			 for i=0,CC.WarWidth-1 do
                for j=0,CC.WarHeight-1 do
					local dest=GetWarMap(i,j,3);
                    if dest <128 then
                        local dx=math.abs(i-WAR.Person[enemyid]["坐标X"])
                        local dy=math.abs(j-WAR.Person[enemyid]["坐标Y"])
                        if minDest>(dx+dy) then        --此时x,y是距离敌人的最短路径，虽然可能被围住
                            minDest=dx+dy;
                            x=i;
                            y=j;
                        elseif minDest==(dx+dy) then
                            if Rnd(2)==0 then
                                x=i;
                                y=j;
                            end
                        end
                    end
                end
            end
		else
            minDest=0;        --可以走到
		end


		if minDest<math.huge then   --有路可走
		    while true do    --从目的位置反着找到可以移动的位置，作为移动的次序
				local i=GetWarMap(x,y,3);
                if i<=WAR.Person[WAR.CurID]["移动步数"] then
                    break;
                end

                if GetWarMap(x-1,y,3)==i-1 then
                    x=x-1;
                elseif GetWarMap(x+1,y,3)==i-1 then
                    x=x+1;
                elseif GetWarMap(x,y-1,3)==i-1 then
                    y=y-1;
                elseif GetWarMap(x,y+1,3)==i-1 then
                    y=y+1;
                end
            end
            War_MovePerson(x,y);    --移动到相应的位置
        end
    end

    return 0;
end

--得到可以走到攻击到敌人的最近位置。
--scope可以攻击的范围
--返回 x,y。如果无法走到攻击位置，返回空
function War_GetCanFightEnemyXY()
	local num,x,y
	num,x,y=War_realjl(WAR.CurID)
	--lib.Debug(num..'|'..x..','..y)
	if num==-1 then 
		return --WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"]
	else
		return x,y
	end
end
--[[
function War_GetCanFightEnemyXY(scope)             --得到可以走到攻击到敌人的最近位置

    local minStep=math.huge;
	local newx,newy;

	War_CalMoveStep(WAR.CurID,100,0);   --计算移动步数 假设最大100步
	for x=0,CC.WarWidth-1 do
		for y=0,CC.WarHeight-1 do
			if GetWarMap(x,y,4)>0 then    --这个位置可以攻击到敌人
				local step=GetWarMap(x,y,3);
				if step<128 then
					if minStep>step then
						minStep=step;
						newx=x;
						newy=y;
					elseif minStep==step then
						if Rnd(2)==0 then
							newx=x;
							newy=y;
						end
					end
				end
			end
		end
	end

	if minStep<math.huge then
	    return newx,newy;
    end
end
]]--

function War_AutoCalMaxEnemyMap(wugongid,level)       --计算地图上每个位置可以攻击的敌人数目

    local wugongtype=JY.Wugong[wugongid]["攻击范围"];
	local move=JY.Wugong[wugongid]["范围"..math.modf((level+2)/3)];
	local movescope=div100(move);
	local fightscope=move-100*movescope;

	local x0=WAR.Person[WAR.CurID]["坐标X"];
	local y0=WAR.Person[WAR.CurID]["坐标Y"];

 	CleanWarMap(4,0);    --用level 4地图表示哪些位置可以攻击到敌人

----点攻击和面攻击, 每个坐标可以攻击的敌人个数（显然只能为0和1）
---这里面攻击和点攻击一样处理，会导致面攻击可能不能攻击到最多的敌人，但是这样速度快
	if wugongtype==0 or wugongtype==3 then
		for n=0,WAR.PersonNum-1 do
			if n~=WAR.CurID and WAR.Person[n]["死亡"]==false and
				WAR.Person[n]["我方"] ~=WAR.Person[WAR.CurID]["我方"] then   --敌人
				local xx=WAR.Person[n]["坐标X"];
				local yy=WAR.Person[n]["坐标Y"];
				local movestep=War_CalMoveStep(n,movescope,1);   --计算武功移动步数
				for i=1,movescope do
					local step_num=movestep[i].num ;
					if step_num==0 then
						break;
					end
					for j=1,step_num do
						SetWarMap(movestep[i].x[j],movestep[i].y[j],4,1);  --标记武功移动的地方，即为可攻击到敌人之处
					end
				end
		end
		end
--线攻击和十字 记录每个的点可以攻击到敌人的个数。对线攻击，数组并不准确，需要进一步核实。
	elseif wugongtype==1 or wugongtype==2  then
		for n=0,WAR.PersonNum-1 do
			if n~=WAR.CurID and WAR.Person[n]["死亡"]==false and
				WAR.Person[n]["我方"] ~=WAR.Person[WAR.CurID]["我方"] then   --敌人
				local xx=WAR.Person[n]["坐标X"];
				local yy=WAR.Person[n]["坐标Y"];
				for direct=0,3 do
					for i=1,movescope do
						local xnew=xx+CC.DirectX[direct+1]*i;
						local ynew=yy+CC.DirectY[direct+1]*i;
						if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
							local v=GetWarMap(xnew,ynew,4);
							SetWarMap(xnew,ynew,4,v+1);
						end
					end
				end
			end
		end

	end

end

function War_AutoCalMaxEnemy(x,y,wugongid,level)       --计算从(x,y)开始攻击最多能够击中几个敌人

    local wugongtype=JY.Wugong[wugongid]["攻击范围"];
	local move=JY.Wugong[wugongid]["范围"..math.modf((level+2)/3)];
	local movescope=div100(move);
	local fightscope=move-100*movescope;

	local maxnum=0;
	local xmax,ymax;

	if wugongtype==0 or wugongtype==3 then

		local movestep=War_CalMoveStep(WAR.CurID,movescope,1);   --计算武功移动步数
		for i=1,movescope do
			local step_num=movestep[i].num ;
			if step_num==0 then
				break;
			end
			for j=1,step_num do
				local xx=movestep[i].x[j];
				local yy=movestep[i].y[j];
				local enemynum=0;

				for n=0,WAR.PersonNum-1 do   --计算武功攻击范围内的敌人个数
					 if n~=WAR.CurID and WAR.Person[n]["死亡"]==false and
					    WAR.Person[n]["我方"] ~=WAR.Person[WAR.CurID]["我方"] then
						 local x=math.abs(WAR.Person[n]["坐标X"]-xx);
						 local y=math.abs(WAR.Person[n]["坐标Y"]-yy);
						 if x<=fightscope and y <=fightscope then
							  enemynum=enemynum+1;
						 end
					 end
				end

				if enemynum>maxnum then        --记录最多敌人和位置
					maxnum=enemynum;
					xmax=xx;
					ymax=yy;
				end
			end
		end

	elseif wugongtype==1 then    --线攻击
		for direct=0,3 do           -- 对每个方向循环，找出敌人最多的
			local enemynum=0;
			for i=1,movescope do
				local xnew=x+CC.DirectX[direct+1]*i;
				local ynew=y+CC.DirectY[direct+1]*i;

				if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
					local id=GetWarMap(xnew,ynew,2);
					if id>=0 then
						if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[id]["我方"] then
							enemynum=enemynum+1;                  --武功攻击范围内的敌人个数
						end
					end
				end
			end
			if enemynum>maxnum then        --记录最多敌人和位置
				maxnum=enemynum;
				xmax=x+CC.DirectX[direct+1];       --线攻击记录一个代表方向的坐标
				ymax=y+CC.DirectY[direct+1];
			end
		end

	elseif wugongtype==2 then --十字攻击
		local enemynum=0;
		for direct=0,3 do           -- 对每个方向循环
			for i=1,movescope do
				local xnew=x+CC.DirectX[direct+1]*i;
				local ynew=y+CC.DirectY[direct+1]*i;
				if xnew>=0 and xnew<CC.WarWidth and ynew>=0 and ynew<CC.WarHeight then
					local id=GetWarMap(xnew,ynew,2);
					if id>=0 then
						if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[id]["我方"] then
							enemynum=enemynum+1;                  --武功攻击范围内的敌人个数
						end
					end
				end
			end
		end
		if enemynum>0 then
			maxnum=enemynum;
			xmax=x;
			ymax=y;
		end
	end
	return maxnum,xmax,ymax;
end

--自动执行战斗，此时的位置一定可以打到敌人
function War_AutoExecuteFight(wugongnum)            --自动执行战斗，显示攻击动画
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local wugongid=JY.Person[pid]["武功"][wugongnum][1];
    local level=math.modf(JY.Person[pid]["武功"][wugongnum][2]/100)+1;

    local maxnum,x,y=GetAtkNum(x0,y0,wugongid,level);

    if x ~= nil then
        War_Fight_Sub(WAR.CurID,wugongnum,x,y);
	end

end

--逃跑
function War_AutoEscape()                --逃跑
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    if JY.Person[pid]["体力"]<=5  then
	    return
	end

    local x,y;

    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);   --计算移动步数
	WarDrawMap(1)
	ShowScreen()
	local starttime=lib.GetTime();
	local array={}
	local num=0
    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
			if GetWarMap(i,j,3)<128 then
                local minDest=math.huge;
                for k=0,WAR.PersonNum-1 do
                    if WAR.Person[WAR.CurID]["我方"]~=WAR.Person[k]["我方"] and WAR.Person[k]["死亡"]==false then
                        local dx=math.abs(i-WAR.Person[k]["坐标X"])
                        local dy=math.abs(j-WAR.Person[k]["坐标Y"])
                        if minDest>(dx+dy) then        --计算当前距离敌人最近的位置
                            minDest=dx+dy;
                        end
                    end
                end
				num=num+1
				array[num]={}
				array[num].x=i
				array[num].y=j
				array[num].p=minDest
            end
        end
    end
	for i=1,num-1 do
		for j=i,num do
			if array[i].p<array[j].p then
				array[i],array[j]=array[j],array[i]
			end
		end
	end
	for i=2,num do
		if array[i].p<array[1].p/2 then
			num=i-1
			break
		end
	end
	for i=1,num do
		array[i].p=array[i].p*5+GetMovePoint(array[i].x,array[i].y,1)
	end
	for i=1,num-1 do
		for j=i,num do
			if array[i].p<array[j].p then
				array[i],array[j]=array[j],array[i]
			end
		end
	end
	x=array[1].x
	y=array[1].y
	
	local endtime=starttime+200-lib.GetTime()
	if endtime>0 then
		lib.Delay(endtime)
	end
	War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0); 
    War_MovePerson(x,y);    --移动到相应的位置

end


---吃药
----flag=2 生命，3内力；4体力  6 解毒
function War_AutoEatDrug(flag)          ---吃药加参数
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local life=JY.Person[pid]["生命"];
    local maxlife=JY.Person[pid]["生命最大值"];
    local selectid;
    local minvalue=math.huge;

    local shouldadd;
    local maxattrib;
    local str;
    if flag==2 then
        maxattrib=JY.Person[pid]["生命最大值"];
        shouldadd=maxattrib-JY.Person[pid]["生命"];
        str="加生命";
    elseif flag==3 then
        maxattrib=JY.Person[pid]["内力最大值"];
        shouldadd=maxattrib-JY.Person[pid]["内力"];
        str="加内力";
    elseif flag==4 then
        maxattrib=CC.PersonAttribMax["体力"];
        shouldadd=maxattrib-JY.Person[pid]["体力"];
        str="加体力";
    elseif flag==6 then
        maxattrib=CC.PersonAttribMax["中毒程度"];
        shouldadd=JY.Person[pid]["中毒程度"];
        str="加中毒解毒";
    else
        return ;
    end

    local function Get_Add(thingid)     --定义物品增加的值
	    if flag==6 then
		    return -JY.Thing[thingid][str]/2;   --解毒为负值
		else
            return JY.Thing[thingid][str];
		end
	end

    if WAR.Person[WAR.CurID]["我方"]==true then
        local extra=0;
        for i =1, CC.MyThingNum do
            local thingid=JY.Base["物品" ..i];
            if thingid>=0 then
                local add=Get_Add(thingid);
                if JY.Thing[thingid]["类型"]==3 and add>0 then
                    local v=shouldadd-add;
                    if v<0 then               --可以加满, 用其他方法找合适药品
                        extra=1;
                        break;
                    else
                        if v<minvalue then        --寻找加生命后生命最大的
                            minvalue=v;
                            selectid=thingid;
                        end
                    end
                end
            end
        end
        if extra==1 then
            minvalue=math.huge;
            for i =1, CC.MyThingNum do
                local thingid=JY.Base["物品" ..i];
                if thingid>=0 then
                    local add=Get_Add(thingid);
                    if JY.Thing[thingid]["类型"]==3 and add>0 then
                        local v=add-shouldadd;
                        if v>=0 then               --可以加满生命
                            if v<minvalue then
                                minvalue=v;
                                selectid=thingid;
                            end
                        end
                    end
                end
            end
        end
        if UseThingEffect(selectid,pid)==1 then       --使用有效果
            instruct_32(selectid,-1);            --物品数量减少
        end
    else
        local extra=0;
        for i =1, 4 do
            local thingid=JY.Person[pid]["携带物品" ..i];
            if thingid>=0 then
                local add=Get_Add(thingid);
                if JY.Thing[thingid]["类型"]==3 and add>0 then
                    local v=shouldadd-add;
                    if v<0 then               --可以加满生命, 用其他方法找合适药品
                        extra=1;
                        break;
                    else
                        if v<minvalue then        --寻找加生命后生命最大的
                            minvalue=v;
                            selectid=thingid;
                        end
                    end
                end
            end
        end
        if extra==1 then
            minvalue=math.huge;
            for i =1, 4 do
                local thingid=JY.Person[pid]["携带物品" ..i];
                if thingid>=0 then
                    local add=Get_Add(thingid);
                    if JY.Thing[thingid]["类型"]==3 and add>0 then
                        local v=add-shouldadd;
                        if v>=0 then               --可以加满生命
                            if v<minvalue then
                                minvalue=v;
                                selectid=thingid;
                            end
                        end
                    end
                end
            end
        end

        if UseThingEffect(selectid,pid)==1 then       --使用有效果
            instruct_41(pid,selectid,-1);            --物品数量减少
        end
    end

    lib.Delay(500);
end


--自动医疗
function War_AutoDoctor()            --自动医疗
    local x1=WAR.Person[WAR.CurID]["坐标X"];
    local y1=WAR.Person[WAR.CurID]["坐标Y"];

    War_ExecuteMenu_Sub(x1,y1,3,-1);
end

function newAI(kfid)
	local pid=WAR.Person[WAR.CurID]["人物编号"]
	local kungfuid=JY.Person[pid]["武功"][kfid][1]
    local kungfulv=JY.Person[pid]["武功"][kfid][2];
	if kungfulv==999 then 
		kungfulv=11
	else
		kungfulv=math.modf(kungfulv/100)+1
	end
	--local kungfulv=math.modf(JY.Person[pid]["武功等级"..kfid]/100)+1
	--local m1,m2,a1,a2,a3,a4,a5= refw(kungfuid,kungfulv)
	--local mfw={m1,m2}
	--local atkfw={a1,a2,a3,a4,a5}
	local mfw=JY.Wugong[kungfuid]["攻击范围"][math.modf((kungfulv+2)/3)]
	local atkfw=JY.Wugong[kungfuid]["伤害范围"][math.modf((kungfulv+2)/3)]
	if kungfulv==11 then kungfulv=10 end
	local kungfuatk=JY.Wugong[kungfuid]["攻击"]*kungfulv--GetAtk(pid,kungfuid,kungfulv)										--武功攻击力
	--local fanwei=JY.Wugong[kungfuid]["范围"][math.modf(kungfulv/3)+1]		--实际武功范围
	local atkarray={}
	local num=0
	
 	CleanWarMap(4,-1);    --用level 4地图表示该位置可以攻击的数目
									-- -1表示此点还没计算
	local movearray=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)		--移动表
	WarDrawMap(1)
	ShowScreen()
	local starttime=lib.GetTime();
	--lib.Delay(400)
	for i=0,WAR.Person[WAR.CurID]["移动步数"] do
		local step_num=movearray[i].num ;
		if step_num==nil or step_num==0 then
			break;
		end
		
		for j=1,step_num do
			local xx=movearray[i].x[j]
			local yy=movearray[i].y[j]
			num=num+1
			atkarray[num]={}
			atkarray[num].x,atkarray[num].y=xx,yy
			atkarray[num].p,atkarray[num].ax,atkarray[num].ay=GetAtkNum(xx,yy,mfw,atkfw,kungfuatk)
		end
		
	end
	
	--排序
	for i=1,num-1 do
		for j=i+1,num do
			if atkarray[i].p<atkarray[j].p then
				atkarray[i],atkarray[j]=atkarray[j],atkarray[i]
			end
		end
	end
	--[[
	for i=1,num do
			lib.Debug(JY.Person[pid]["姓名"]..'|'..JY.Wugong[kungfuid]["名称"]..'|'..atkarray[i].x..','..atkarray[i].y..'|'..atkarray[i].ax..','..atkarray[i].ay..'|'..atkarray[i].p)
	end
	]]--
	if atkarray[1].p>0 then
		for i=1,num do
			if atkarray[i].p==0 or atkarray[i].p<atkarray[1].p/2 then
				num=i-1
				break;
			end
		end
		for i=1,num do
			atkarray[i].p=atkarray[i].p+GetMovePoint(atkarray[i].x,atkarray[i].y)--string.format("%s,mxy:%d,%d|axy:%d,%d|point:%d")
		end
		for i=1,num-1 do
			for j=i+1,num do
				if atkarray[i].p<atkarray[j].p then
					atkarray[i],atkarray[j]=atkarray[j],atkarray[i]
				elseif atkarray[i].p==atkarray[j].p then
					if math.random(2)==1 then
						atkarray[i],atkarray[j]=atkarray[j],atkarray[i]
					end
				end
			end
		end
		for i=2,num do
			if atkarray[i].p<atkarray[1].p-15 then
				num=i-1
				break;
			end
		end
		if num>6 then
			for i=num,6 do
				if atkarray[i].p<atkarray[1].p-50 then
					num=i-1
					break
				end
			end
		end
		local endtime=starttime+300-lib.GetTime()
		if endtime>0 then
			lib.Delay(endtime)
		end
		local select
		--if num>3 then num=3 end
		select=1--math.random(num) 
		War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)
		War_MovePerson(atkarray[select].x,atkarray[select].y)
		War_Fight_Sub(WAR.CurID,kfid,atkarray[select].ax,atkarray[select].ay)
	else
		local endtime=starttime+300-lib.GetTime()
		if endtime>0 then
			lib.Delay(endtime)
		end
		local jl,nx,ny=War_realjl()
		if jl==-1 then
			AutoMove()
		else
			local vv
			vv=GetWarMap(nx+1,ny,2)
			if vv>-1 and WAR.Person[vv]["我方"]~=WAR.Person[WAR.CurID]["我方"] then
		
			else
				vv=GetWarMap(nx-1,ny,2)
				if vv>-1 and WAR.Person[vv]["我方"]~=WAR.Person[WAR.CurID]["我方"] then
			
				else
					vv=GetWarMap(nx,ny+1,2)
					if vv>-1 and WAR.Person[vv]["我方"]~=WAR.Person[WAR.CurID]["我方"] then
				
					else
						vv=GetWarMap(nx,ny-1,2)
					end
				end
			end
			local array={}
			local an=0
			local movearray=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)
			--MY_CalMoveStep(nx,ny,jl,0)
			War_CalMoveStep(vv,jl,0)
			for i=1,WAR.Person[WAR.CurID]["移动步数"] do
				local step_num=movearray[i].num ;
				if step_num==nil or step_num==0 then
					break;
				end		
				for j=1,step_num do
					local xx=movearray[i].x[j]
					local yy=movearray[i].y[j]
					local Dest=GetWarMap(xx,yy,3)
					if Dest<255 then
						an=an+1
						array[an]={}
						array[an].x=xx
						array[an].y=yy
						array[an].p=jl-Dest
						--lib.Debug(an..','..array[an].p)
					end
				end
			end
			for i=1,an-1 do
				for j=i+1,an do
					if array[i].p<array[j].p then
						array[i],array[j]=array[j],array[i]
					end
				end
			end
			for i=2,an do
				if array[i].p<array[1].p/2 then
					an=i-1
					break
				end
			end
			for i=1,an do
				array[i].p=array[i].p+GetMovePoint(array[i].x,array[i].y)
			end
			for i=1,an-1 do
				for j=i+1,an do
					if array[i].p<array[j].p then
						array[i],array[j]=array[j],array[i]
					end
				end
			end
			--if jl==-1 then
			--	AutoMove()
			--else
			if an>0 then
				War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)
				War_MovePerson(array[1].x,array[1].y)
			end
			--end
			--AutoMove()
		end
		War_RestMenu(); 
	end
	return
end

function GetAtkNum(x,y,movfw,atkfw,atk)
	local point={}		--记录可以攻击的点
	local num=0			--记录点的个数
	local kind,len=movfw[1],movfw[2]
	--kind,len1,len2=fenjie(JY.Wugong[kfnum]["范围"..math.modf((lv+2)/3)])
	

	--攻击范围类型 0菱形1方块2十字3八向
	
	if kind==0 then
		local array=MY_CalMoveStep(x,y,len,1);
		for i=0,len do
			local step_num=array[i].num ;
			if step_num==nil or step_num==0 then
				break;
			end		
			for j=1,step_num do
				num=num+1
				point[num]={array[i].x[j],array[i].y[j]}
			end
		end
	elseif kind==1 then
		local array=MY_CalMoveStep(x,y,len*2,1);
			for r=1,len*2 do
				for i=0,r do
					local j=r-i
					if i>len or j>len then
						SetWarMap(x+i,y+j,3,255)
						SetWarMap(x+i,y-j,3,255)
						SetWarMap(x-i,y+j,3,255)
						SetWarMap(x-i,y-j,3,255)
					end
				end
			end
		for i=0,len do
			local step_num=array[i].num ;
			if step_num==nil or step_num==0 then
				break;
			end		
			for j=1,step_num do
				if GetWarMap(array[i].x[j],array[i].y[j],3)<128 then
					num=num+1
					point[num]={array[i].x[j],array[i].y[j]}
				end
			end
		end
	elseif kind==2 then
		--四向
		len=len or 1
		for i=1,len do
			if x+i<CC.WarWidth-1 and GetWarMap(x+i,y,1)>0 and CC.WarWater[GetWarMap(x+i,y,0)]==nil then break end
			num=num+1
			point[num]={x+i,y}
		end
		for i=1,len do
			if x-i>0 and GetWarMap(x-i,y,1)>0 and CC.WarWater[GetWarMap(x-i,y,0)]==nil then break end
			num=num+1
			point[num]={x-i,y}
		end
		for i=1,len do
			if y+i<CC.WarHeight-1 and GetWarMap(x,y+i,1)>0 and CC.WarWater[GetWarMap(x,y+i,0)]==nil then break end
			num=num+1
			point[num]={x,y+i}
		end
		for i=1,len do
			if y-i>0 and GetWarMap(x,y-i,1)>0 and CC.WarWater[GetWarMap(x,y-i,0)]==nil then break end
			num=num+1
			point[num]={x,y-i}
		end
	elseif kind==3 then
		--八向(方块)
		if x+1<CC.WarWidth-1 and GetWarMap(x+1,y,1)==0 and CC.WarWater[GetWarMap(x+1,y,0)]==nil then
			num=num+1
			point[num]={x+1,y}
		end
		if x-1>0 and GetWarMap(x-1,y,1)==0 and CC.WarWater[GetWarMap(x-1,y,0)]==nil then
			num=num+1
			point[num]={x-1,y}
		end
		if y+1<CC.WarHeight-1 and GetWarMap(x,y+1,1)==0 and CC.WarWater[GetWarMap(x,y+1,0)]==nil then
			num=num+1
			point[num]={x,y+1}
		end
		if y-1>0 and GetWarMap(x,y-1,1)==0 and CC.WarWater[GetWarMap(x,y-1,0)]==nil then
			num=num+1
			point[num]={x,y-1}
		end
		if x+1<CC.WarWidth-1 and y+1<CC.WarHeight-1 and GetWarMap(x+1,y+1,1)==0 and CC.WarWater[GetWarMap(x+1,y+1,0)]==nil then
			num=num+1
			point[num]={x+1,y+1}
		end
		if  x-1>0 and y+1<CC.WarHeight-1 and GetWarMap(x-1,y+1,1)==0 and CC.WarWater[GetWarMap(x-1,y+1,0)]==nil then
			num=num+1
			point[num]={x-1,y+1}
		end
		if x+1<CC.WarWidth-1 and y-1>0 and GetWarMap(x+1,y-1,1)==0 and CC.WarWater[GetWarMap(x+1,y-1,0)]==nil then
			num=num+1
			point[num]={x+1,y-1}
		end
		if  x-1>0 and  y-1>0 and GetWarMap(x-1,y-1,1)==0 and CC.WarWater[GetWarMap(x-1,y-1,0)]==nil then
			num=num+1
			point[num]={x-1,y-1}
		end
	end
	--从第一个点开始，分别获取该点攻击敌人的数目，并保存最大点的坐标，攻击数目
	local maxx,maxy,maxnum,atknum=0,0,0,0
	for i=1,num do
		atknum=GetWarMap(point[i][1],point[i][2],4)				--取第四层数据，若为-1,则调用函数计算
		if atknum==-1 or atkfw[1]>9 or (atkfw[1]==3 and atkfw[3]~=nil and atkfw[3]~=atkfw[2])then		--如果不是定点类，则必须重复计算
			atknum=WarDrawAtt(point[i][1],point[i][2],atkfw,2,x,y,atk)
			SetWarMap(point[i][1],point[i][2],4,atknum)
		end
		if atknum>maxnum then
			maxnum,maxx,maxy=atknum,point[i][1],point[i][2]
		end
	end
	--SetWarMap(x,y,4,maxnum);
	return maxnum,maxx,maxy;
	
end

function AutoMove()
    local x,y;
	local minDest=math.huge;
	local enemyid=War_AutoSelectEnemy()   --选择最近敌人
	War_CalMoveStep(WAR.CurID,100,0);   --计算移动步数 假设最大100步
	for i=0,CC.WarWidth-1 do
		for j=0,CC.WarHeight-1 do
			local dest=GetWarMap(i,j,3);
			if dest <128 then
				local dx=math.abs(i-WAR.Person[enemyid]["坐标X"])
                local dy=math.abs(j-WAR.Person[enemyid]["坐标Y"])
                if minDest>(dx+dy) then        --此时x,y是距离敌人的最短路径，虽然可能被围住
					minDest=dx+dy;
                    x=i;
                    y=j;
                elseif minDest==(dx+dy) then
                    if Rnd(2)==0 then
                        x=i;
                        y=j;
                    end
                end
            end
        end
    end
	if minDest<math.huge then   --有路可走
	    while true do    --从目的位置反着找到可以移动的位置，作为移动的次序
			local i=GetWarMap(x,y,3);
            if i<=WAR.Person[WAR.CurID]["移动步数"] then
                break;
            end

            if GetWarMap(x-1,y,3)==i-1 then
                x=x-1;
            elseif GetWarMap(x+1,y,3)==i-1 then
                x=x+1;
            elseif GetWarMap(x,y-1,3)==i-1 then
                y=y-1;
            elseif GetWarMap(x,y+1,3)==i-1 then
                y=y+1;
            end
        end
        War_MovePerson(x,y);    --移动到相应的位置
    end
end

function AutoMove11()
	local movearray=War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)
	local p,tx,ty=-999,0,0
	for i=1,WAR.Person[WAR.CurID]["移动步数"] do
		local step_num=movearray[i].num ;
		if step_num==nil or step_num==0 then
			break;
		end		
		for j=1,step_num do
			local xx=movearray[i].x[j]
			local yy=movearray[i].y[j]
			local len=-2*War_realjl()+GetMovePoint(xx,yy)
			if len>p then
				p=len
				tx=xx
				ty=yy
			end
		end
	end
	War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0)
	War_MovePerson(tx,ty);    --移动到相应的位置
end

function GetMovePoint(x,y,flag)
	local point=0
	local wofang=WAR.Person[WAR.CurID]["我方"]
	local movearray=MY_CalMoveStep(x,y,9,1)
	for i=1,9 do
		local step_num=movearray[i].num;
		if step_num==nil or step_num==0 then
			break;
		end		
		for j=1,step_num do
			local xx=movearray[i].x[j]
			local yy=movearray[i].y[j]
			local v=GetWarMap(xx,yy,2)
			if v==-1 or v==WAR.CurID then
				--point=point+10
			elseif WAR.Person[v]["我方"]==wofang then
				point=point+i*2-17
			elseif WAR.Person[v]["我方"]~=wofang then
				--local qg=math.modf(WAR.PersonNum/2)-WAR.CurID
				if flag~=nil then
					point=point+i*-20
				else
					if not inteam(WAR.Person[WAR.CurID]["人物编号"]) then--WAR.Person[WAR.CudID]["我方"] then
						point=point+i-10
					else 
						point=point+10-i
					end
					--point=point+8
				end
			end
		end		
	end
	return point
end
 function MY_CalMoveStep(x,y,stepmax,flag)
	CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，
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
		War_FindNextStep(steparray,i,flag);
		if steparray[i+1].num==0 then
			break;
		end
	end
	return steparray;
end
--[[
function MY_realjl(ida,idb)
	if ida==nil then
		ida=WAR.CurID
	end
	local num
	local movearray=War_CalMoveStep(ida,255,0)
	for i=1,255 do
		num=i
		local step_num=movearray[i].num ;
		if step_num==nil or step_num==0 then
			break;
		end		
		for j=1,step_num do
			local xx=movearray[i].x[j]
			local yy=movearray[i].y[j]
			local v=GetWarMap(xx,yy,2)
			if idb==nil then
				if v~=-1 then
					if WAR.Person[v]["我方"]~=WAR.Person[ida]["我方"] then
						return v,num--,xx,yy
					end
				end
			else
				if v==idb then
					return v,num--,xx,yy
				end
			end
		end
	end
end
]]--