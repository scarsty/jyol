function SelectPersonMenu(id,x,y)
	id=id or 1;
	x=x or 10;
	y=y or 10;
	local menu={};
	for i=1,450 do
		menu[i]={JY.Person[i]["姓名"],PersonStatus_sub,0};
		if JY.Person[i]["等级"]>30 or (JY.Person[i]["身份"]>0 and JY.Person[i]["等级"]>20) then
			menu[i][3]=1;
		end
	end
	menu[id][3]=2;
	return ShowMenu(menu,450,20,x,y,0,0,1,0,CC.FontSmall,C_ORANGE,C_WHITE,1);
end
function SelectKungfuMenu(id,x,y)
	id=id or 1;
	x=x or 10;
	y=y or 10;
	local menu={};
	for i=1,520 do
		menu[i]={JY.Wugong[i]["名称"],kfshow,0};
		if JY.Wugong[i]["武功类型"]>0 and JY.Wugong[i]["武功类型"]<10 then
			if type(JY.Kungfu[i])=='table' then
				if JY.Wugong[i]["名称"]~='神秘武功' then--and JY.Wugong[i]["武功类型"]==8 then
					menu[i][3]=1;
				end
			end
		end
	end
	menu[id][3]=2;
	return ShowMenu(menu,520,20,x,y,0,0,1,0,CC.FontSmall,C_ORANGE,C_WHITE,1);
end
function kfshow(id)
		local p=JY.Wugong[id];
		local k=JY.Kungfu[id];
		local x,y=166,10;
		local font=16;
		DrawBox(x,y,CC.ScreenW-10,CC.ScreenH-10,C_WHITE);
		x=x+8;
		y=y+8;
		DrawString(x,y,p["名称"].."    Lv"..p["等阶"],C_WHITE,font);
		y=y+font;
		DrawString(x,y,k["说明"],C_WHITE,font);
		y=y+font;
		DrawString(x,y,"Hurt: "..p["伤害"].."x10 + "..p["伤害修正"].."xn".."      atk:"..p['攻击'].."   def:"..p['防御'].."   spd:"..p['身法'],C_WHITE,font);
		y=y+font;
		local dj={}
		for i,v in pairs(k["攻击范围"]) do
			dj[i]=1;
		end
		for i,v in pairs(k["伤害范围"]) do
			dj[i]=1;
		end
		local cx=x;
		local cy=y;
		local w=80;
		for i=1,100 do
			if type(k["攻击范围"][i])=='table' or type(k["伤害范围"][i])=='table' then
				DrawString(cx,cy,"Lv "..i,C_WHITE,font);
				ShowKungfuMove(cx,cy+font,w+font,w,id,i,font);
				ShowKungfuAtk(cx+w+font,cy+font,w+font,w,id,i,font);
				cx=cx+w*2+font*3;
				if cx>CC.ScreenW-w*2-font*3 then
					cx=x;
					cy=cy+w+font*1.5;
				end
			end
		end
		if cx>x then
			cx=x;
			cy=cy+w+font*1.5;
		end
		EasySmagic(id,cx,cy)
end
function KungfuEdit()
	local id;
	local p,k;
	local menu=	{
					{"Lv01",nil,1},
					{"Lv02",nil,1},
					{"Lv03",nil,1},
					{"Lv04",nil,1},
					{"Lv05",nil,1},
					{"Lv06",nil,1},
					{"Lv07",nil,1},
					{"Lv08",nil,1},
					{"Lv09",nil,1},
					{"Lv10",nil,1},
					{"Lv11",nil,1},
					{"Lv12",nil,1},
					{"Lv13",nil,1},
					{"Lv14",nil,1},
					{"Lv15",nil,1},
					{"Lv16",nil,1},
					{"Out",nil,1},
				}
	local function show()
		local x,y=10,10;
		local font=16;
		DrawBox(x,y,CC.ScreenW-10,CC.ScreenH-10,C_WHITE);
		x=x+8;
		y=y+8;
		DrawString(x,y,p["名称"].."    Lv"..p["等阶"],C_WHITE,font);
		y=y+font;
		DrawString(x,y,"Hurt: "..p["伤害"].."x10 + "..p["伤害修正"].."xn".."      atk:"..p['攻击'].."   def:"..p['防御'].."   spd:"..p['身法'],C_WHITE,font);
		y=y+font;
		local cx=x;
		local cy=y;
		local w=80;
		for i=1,100 do
			if type(k["攻击范围"][i])=='table' or type(k["伤害范围"][i])=='table' then
				DrawString(cx,cy,"Lv "..i,C_WHITE,font);
				ShowKungfuMove(cx,cy+font,w+font,w,id,i,font);
				ShowKungfuAtk(cx+w+font,cy+font,w+font,w,id,i,font);
				cx=cx+w*2+font*3;
				if cx>CC.ScreenW-w*2-font*3 then
					cx=x;
					cy=cy+w+font*2;
				end
			end
		end
	end
	while true do
		Cls();
		id=SelectKungfuMenu(id);
		lib.Debug("select".."  "..id)
		p=JY.Wugong[id];
		k=JY.Kungfu[id];
		show();
		ShowScreen();
		WaitKey();
		local r=ShowMenu(menu,17,17,700,10,0,0,1,1,CC.FontSmall,C_ORANGE,C_WHITE)
		if r>0 then
			if r>16 then
				lib.Debug(string.format("Current=%d,%s",id,p["名称"]))
				local s='';
				for i=1,999 do
					if type(k['攻击范围'][i])=='table' then
						s=s..string.format("[%d]={",i);
						for j=1,2 do
							if type(k['攻击范围'][i][j])=='number' then
								s=s..string.format("%d,",k['攻击范围'][i][j]);
							end
						end
						s=s.."},";
					end
				end
				lib.Debug(s)
				s='';
				for i=1,999 do
					if type(k['伤害范围'][i])=='table' then
						s=s..string.format("[%d]={",i);
						for j=1,5 do
							if type(k['伤害范围'][i][j])=='number' then
								s=s..string.format("%d,",k['伤害范围'][i][j]);
							end
						end
						s=s.."},";
					end
				end
				lib.Debug(s)
			else
				ResetFW(id,r);
			end
		end
	end
end

function ResetFW(kid,klv)
	
	local p={0,0,0,0,0,0,0};
	local id=1;
	for i=klv,1,-1 do
		if type(JY.Kungfu[kid]["攻击范围"][i])=='table' then
			for ii,vv in pairs(JY.Kungfu[kid]["攻击范围"][i]) do
				p[ii]=vv;
			end
			break;
		end
	end
	for i=klv,1,-1 do
		if type(JY.Kungfu[kid]["伤害范围"][i])=='table' then
			for ii,vv in pairs(JY.Kungfu[kid]["伤害范围"][i]) do
				p[ii+2]=vv;
			end
			break;
		end
	end
	local function redraw()
		lib.FillColor(0,0,0,0,0);
		DrawStrBox(25,10,"攻击范围*",C_WHITE,28);
		DrawStrBox(180,10," 伤 害 范 围 * ",C_WHITE,28);
		for i=1,2 do
			local color=C_WHITE;
			if i==id then
				color=C_ORANGE;
			end
			DrawString(50+28*(i-1),45,string.format("%2d,",p[i]),color,24);
		end
		for i=3,7 do
			local color=C_WHITE;
			if i==id then
				color=C_ORANGE;
			end
			DrawString(145+28*(i-1),45,string.format("%2d,",p[i]),color,24);
		end
		DrawString(40,45,"{     }      {            }",M_Yellow,24);
	end
	while true do
		redraw();
		JY.Kungfu[kid]["攻击范围"][klv]={p[1],p[2]};
		JY.Kungfu[kid]["伤害范围"][klv]={p[3],p[4],p[5],p[6],p[7]};
		ShowKungfuMove(10,120,380,380,kid,klv,24);
		ShowKungfuAtk(410,120,380,380,kid,klv,24);
		ShowScreen();
		local event,key,mx,my=WaitKey(1);
		lib.Delay(50)
		if event==1 then
			if key==VK_UP then
				p[id]=p[id]-1;
			elseif key==VK_DOWN then
				p[id]=p[id]+1;
			elseif key==VK_LEFT then
				id=id-1;
				id=limitX(id,1,7);
			elseif key==VK_RIGHT then
				id=id+1;
				id=limitX(id,1,7);
			elseif key==VK_ESCAPE then
				break;
			end
		end
		for i=1,7 do
			p[i]=limitX(p[i],0,20);
		end
		p[1]=limitX(p[1],0,3);
		p[3]=limitX(p[3],0,13);
	end
	if klv>1 then
		if p[1]==0 and p[2]==0 then
			JY.Kungfu[kid]["攻击范围"][klv]=nil;
		end
		if p[3]==0 and p[4]==0 and p[5]==0 and p[6]==0 and p[7]==0 then
			JY.Kungfu[kid]["伤害范围"][klv]=nil;
		end
	end
end
function EasySmagic(kfid,x,y)
	local p=JY.Kungfu[kfid]["特殊效果"]
	local kfstr,strnum=GenTalkString(JY.Kungfu[kfid]["说明"],13);
	local num=0;--=p[0];
	local flag_a=false;
	local flag_b=false;
	local flag_c=false;
	for i=1,p[0] do
		if true then--(p[i][2]>=0 and kflv>=p[i][2]) or (p[i][2]<0 and kflv<-p[i][2]) then
			num=num+1;
			if p[i][1]<=40 then
				flag_a=true;
			elseif p[i][1]>100 then
				flag_c=true;
			else
				flag_b=true;
			end
		end
	end
	if flag_a then
		num=num+1;
	end
	if flag_b then
		num=num+1;
	end
	if flag_c then
		num=num+1;
	end
	local function GenStr(i)
		local str="";
		local cp,cq;
		if type(p[i][4])=="function" then
			cp=p[i][4](JY.Person[0],1);
		else
			cp=p[i][4];
		end
		if type(p[i][3])=="function" then
			cq=p[i][3](JY.Person[0],1);
		else
			cq=p[i][3];
		end
		if p[i][1]==1 then
			str=string.format("攻击伤害%+d",cp);
		elseif p[i][1]==2 then
			str=string.format("攻击伤害%+d％",cp);
		elseif p[i][1]==3 then
			str=string.format("忽视%d％防御",cp);
		elseif p[i][1]==4 then
			str=string.format("化去内力%d",cp);
		elseif p[i][1]==5 then
			str=string.format("吸取内力%d",cp);
		elseif p[i][1]==6 then
			str=string.format("吸取生命%d",cp);
		elseif p[i][1]==7 then
			str=string.format("打退集气%d",cp);
		elseif p[i][1]==8 then
			str=string.format("杀伤体力%d",cp);
		elseif p[i][1]==9 then
			str=string.format("%d",cp);
		elseif p[i][1]==10 then
			str=string.format("%d％伤害打退集气",cp);
		elseif p[i][1]==11 then
			str=string.format("攻击后集气%+d％",cp);
		elseif p[i][1]==12 then
			str=string.format("守方特效发动率%+d％",-cp);
		elseif p[i][1]==13 then
			str=string.format("%d％伤害蓄力",cp);
		elseif p[i][1]==14 then
			str=string.format("扩大伤害范围",cp);
		elseif p[i][1]==15 then
			str=string.format("内功必出招式",cp);
		elseif p[i][1]==16 then
			str=string.format("攻击力%+d",cp);
		elseif p[i][1]==17 then
			str=string.format("攻击力%+d％",cp);
		elseif p[i][1]==21 then
			str=string.format("所受伤害%+d",-cp);
		elseif p[i][1]==22 then
			str=string.format("所受伤害%+d％",-cp);
		elseif p[i][1]==23 then
			str=string.format("攻方特效无效",cp);
		elseif p[i][1]==24 then
			str=string.format("反击",cp);
		elseif p[i][1]==25 then
			str=string.format("反弹%d％伤害",cp);
		elseif p[i][1]==26 then
			str=string.format("反震%d伤害",cp);
		elseif p[i][1]==27 then
			str=string.format("闪避",cp);
		elseif p[i][1]==28 then
			str=string.format("所受伤害%d％蓄力",cp);
		elseif p[i][1]==29 then
			str=string.format("防御力%+d",cp);
		elseif p[i][1]==30 then
			str=string.format("防御力%+d％",cp);
		elseif p[i][1]==31 then
			str=string.format("走火入魔，全属性%+d％",cp);
		elseif p[i][1]==41 then
			str=string.format("移动距离%+d",cp);
		elseif p[i][1]==42 then
			str=string.format("初始集气%+d",cp);
		elseif p[i][1]==43 then
			str=string.format("集气速度%+d",cp);
		elseif p[i][1]==44 then
			str=string.format("%d",cp);
		elseif p[i][1]==45 then
			str=string.format("%d",cp);
		elseif p[i][1]==46 then
			str=string.format("强行移动",cp);
		elseif p[i][1]==47 then
			str=string.format("瞬间移动",cp);
		elseif p[i][1]==48 then
			str=string.format("水上移动",cp);
		elseif p[i][1]==49 then
			str=string.format("行走加速",cp);
		elseif p[i][1]==50 then
			str=string.format("%d",cp);
		elseif p[i][1]==57 then
			str=string.format("特效发动率%+d",cp);
		elseif p[i][1]==58 then
			str=string.format("获取经验%+d％",cp);
		elseif p[i][1]==61 then
			str=string.format("生命上限%+d",cp);
		elseif p[i][1]==62 then
			str=string.format("内力上限%+d",cp);
		elseif p[i][1]==63 then
			str=string.format("生命上限%+d％",cp);
		elseif p[i][1]==64 then
			str=string.format("力道%+d",cp);
		elseif p[i][1]==65 then
			str=string.format("根骨%+d",cp);
		elseif p[i][1]==66 then
			str=string.format("机敏%+d",cp);
		elseif p[i][1]==67 then
			str=string.format("资质%+d",cp);
		elseif p[i][1]==68 then
			str=string.format("福缘%+d",cp);
		elseif p[i][1]==69 then
			str=string.format("攻击%+d",cp);
		elseif p[i][1]==70 then
			str=string.format("防御%+d",cp);
		elseif p[i][1]==71 then
			str=string.format("轻功%+d",cp);
		elseif p[i][1]==72 then
			str=string.format("攻击%+d％",cp);
		elseif p[i][1]==73 then
			str=string.format("防御%+d％",cp);
		elseif p[i][1]==74 then
			str=string.format("轻功%+d％",cp);
		elseif p[i][1]==75 then
			str=string.format("%d",cp);
		elseif p[i][1]==76 then
			str=string.format("%d",cp);
		elseif p[i][1]==77 then
			str=string.format("%d",cp);
		elseif p[i][1]==78 then
			str=string.format("%d",cp);
		elseif p[i][1]==81 then
			str=string.format("%d格内敌方攻击%+d％",cq,cp);
		elseif p[i][1]==82 then
			str=string.format("%d格内敌方防御%+d％",cq,cp);
		elseif p[i][1]==83 then
			str=string.format("%d格内敌方身法%+d％",cq,cp);
		elseif p[i][1]==91 then
			str=string.format("%d格内己方攻击%+d％",cq,cp);
		elseif p[i][1]==92 then
			str=string.format("%d格内己方防御%+d％",cq,cp);
		elseif p[i][1]==93 then
			str=string.format("%d格内己方身法%+d％",cq,cp);
		else
			str="神秘效果"
		end
		return str;
	end
		x=x+CC.MenuBorderPixel+CC.Fontbig/2;
		if flag_a then
			for i=0,CC.Fontbig/2-1 do
				lib.Background(x-i,y+CC.Fontbig/2+i,CC.ScreenW/2+CC.Fontbig*8+i,y+CC.Fontbig,240,C_WHITE);
				--lib.Background(x-CC.Fontbig/2-i,y+CC.Fontbig/2+i,x+CC.Fontbig*16-CC.MenuBorderPixel+i,y+CC.Fontbig/2,240,C_WHITE);
			end
			--lib.Background(x+CC.Fontbig*4,y+CC.Fontbig/2,x+CC.Fontbig*16,y+CC.Fontbig/2+8,128,C_WHITE);
			DrawString(x+CC.Fontbig*2,y,"武功招式",M_Yellow,CC.Fontbig);
			y=y+CC.Fontbig+CC.RowPixel;
		end
		for i=1,p[0] do
			if p[i][1]<=40 then
				--DrawString(x,y,p[i][5],C_ORANGE,CC.Fontbig);
				local cv;
				if type(p[i][3])=="function" then
					cv=p[i][3](JY.Person[0],1);
				else
					cv=p[i][3];
				end
				
				if true then--(p[i][2]>=0 and kflv>=p[i][2]) or (p[i][2]<0 and kflv<-p[i][2]) then
					--if cv>0 then
						--DrawString(x,y,p[i][5],M_Gray,CC.Fontbig);
					--end
					--DrawString(x+CC.Fontbig*7.5,y,"未完成",M_Gray,CC.Fontbig);
				--else
					if cv>0 then
						DrawString(x,y,p[i][5],C_ORANGE,CC.Fontbig);
					end
					DrawString(x+CC.Fontbig*7.5,y,GenStr(i),C_WHITE,CC.Fontbig);
					y=y+CC.Fontbig+CC.RowPixel;
				end
			end
		end
		if flag_b then
			for i=0,CC.Fontbig/2-1 do
				lib.Background(x-i,y+CC.Fontbig/2+i,CC.ScreenW/2+CC.Fontbig*8+i,y+CC.Fontbig,240,C_WHITE);
				--lib.Background(x-i,y+CC.Fontbig+i,x+CC.Fontbig*16-CC.MenuBorderPixel+i,y+CC.Fontbig,240,C_WHITE);
			end
			DrawString(x+CC.Fontbig*2,y,"被动效果",M_Yellow,CC.Fontbig);
			y=y+CC.Fontbig+CC.RowPixel;
		end
		--local nn=0;
		local T={"一","二","三","四","五","六","七","八","九","十",}
		for i=1,p[0] do
			if p[i][1]>40 and p[i][1]<=100 then
				--nn=nn+1;
				
				if true then--(p[i][2]>=0 and kflv>=p[i][2]) or (p[i][2]<0 and kflv<-p[i][2]) then
					--DrawString(x,y,"被动效果"..T[nn],M_Gray,CC.Fontbig);
					--DrawString(x+CC.Fontbig*7.5,y,"未完成",M_Gray,CC.Fontbig);
				--else
					--DrawString(x,y,"被动效果"..T[nn],C_ORANGE,CC.Fontbig);
					DrawString(x,y,GenStr(i),C_ORANGE,CC.Fontbig);--+CC.Fontbig*7.5
					y=y+CC.Fontbig+CC.RowPixel;
				end
			end
		end
		if flag_c then
			for i=0,CC.Fontbig/2-1 do
				lib.Background(x-i,y+CC.Fontbig+i,x+CC.Fontbig*16-CC.MenuBorderPixel+i,y+CC.Fontbig,240,C_WHITE);
			end
			DrawString(x+CC.Fontbig*2,y,"特殊指令",M_Yellow,CC.Fontbig);
			y=y+CC.Fontbig+CC.RowPixel;
		end
end

function SmapToWmap()
	LoadRecord(0);
	local data=Byte.create(JY.SceneNum*2*64*64*2);
	local data2=Byte.create(JY.SceneNum*4);
	local address=0;
	local address2=0;
	for sid=0,JY.SceneNum-1 do
		for level=0,1 do
			for y=0,63 do
				for x=0,63 do
					Byte.set16(data,address,lib.GetS(sid,x,y,level));
					address=address+2;
				end
			end
		end
		Byte.set32(data2,address2,address);
		address2=address2+4;
	end
	Byte.savefile(data,'.\\data\\Warfld.grp',0,JY.SceneNum*2*64*64*2);
	Byte.savefile(data2,'.\\data\\Warfld.idx',0,JY.SceneNum*4);
end
