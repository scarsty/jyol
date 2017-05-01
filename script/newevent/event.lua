function Query(pid)
	say("你想问什么？",pid);
	local str="";
	str=Shurufa();
	if str=="" then
		say("没什么想问的话，那就算了吧。",pid);
	else
		if JY.Name[str]==nil then
			say("我没有听说过"..str.."，你再问问别人吧。",pid);
		else
			local id=JY.Name[str];
			if id==pid then
				say("我吗？没有什么特别想说的。",pid);
				DayPass(1);
				return;
			end
			local n=JY.Person[pid]["友好"]/30;
			n=n+JY.Person[pid]["闲聊"];
			if JY.Person[pid]["门派"]==JY.Person[id]["门派"] then
				n=n+2;
			end
			n= math.modf(n);
			if n>1 then
				n=Rnd(n);
			end
			local talk="";
			if n>4 and JY.Person[id]["所在"]>=0 and JY.Person[id]["外功1"]>0 and JY.Person[id]["门派"]>=0 then
				talk=string.format("%s师出%s，擅长%s，现在应该在%s吧，你有事要找他吗？",JY.Person[id]["姓名"],JY.Shop[JY.Person[id]["门派"]]["名称"],JY.Wugong[JY.Person[id]["外功1"]]["名称"],JY.Scene[JY.Person[id]["所在"]]["名称"]);
			elseif n>3 and JY.Person[id]["外功1"]>0 and JY.Person[id]["门派"]>=0 then
				talk=string.format("%s师出%s，擅长%s。",JY.Person[id]["姓名"],JY.Shop[JY.Person[id]["门派"]]["名称"],JY.Wugong[JY.Person[id]["外功1"]]["名称"]);
			
			elseif n>2 and JY.Person[id]["门派"]>=0 then
				talk=string.format("%s师出%s，你和他认识吗？",JY.Person[id]["姓名"],JY.Shop[JY.Person[id]["门派"]]["名称"]);
			
			elseif n>1 then
				talk=string.format("你也认识%s吗？。",JY.Person[id]["姓名"]);
			
			elseif n>0 then
				talk=string.format("%s啊，我知道。",JY.Person[id]["姓名"]);
			
			else
				talk="没听说过";
			end
			say(talk,pid);
		end
	end
end
function RandomEvent(pid)
	local notalk=false;
	DayPass(1);
	if JY.Person[pid]["友好"]<40 and math.random(100)>50+JY.Person[pid]["友好"] then
		local T=	{
							"我今天有点事，没时间聊天。",
							"你去找别人聊吧。",
							"好好练功，别无所事事。",
							"今天有点不方便，改天吧",
							"我和你没什么好聊的。",
						};
		say(T[math.random(5)],pid);
		notalk=true;
	else
		local flag=true;
		if flag and (type(PersonEvent[pid])=="function") then
			flag=PersonEvent[pid](pid);
		end
		if flag and (JY.Person[0]["门派"]==JY.Person[pid]["门派"] and type(ForceEvent[JY.Person[pid]["门派"]])=="function") then
			flag=ForceEvent[JY.Person[pid]["门派"]](pid);
		end
		if flag and (JY.Person[0]["门派"]<0 or JY.Person[0]["门派"]~=JY.Person[pid]["门派"]) then
			flag=CommenEvent(pid);
		end
		if flag then
			for ci,cv in pairs(PE.talk) do
				if cv.trigger()==1 then
					cv.go();
					flag=false;
					break;
				end
			end
		end
		if flag and (type(PersonTalk[pid])=="function" and Rnd(10)<18) then
			flag=PersonTalk[pid](pid);
		end
		if flag and (JY.Person[0]["门派"]==JY.Person[pid]["门派"] and type(ForceTalk[JY.Person[pid]["门派"]])=="function" and Rnd(10)<17) then
			flag=ForceTalk[JY.Person[pid]["门派"]](pid);
		end
		if flag then--and (JY.Person[0]["门派"]<0 or JY.Person[0]["门派"]~=JY.Person[pid]["门派"]) then
			flag=CommenTalk(pid);
		end
		if flag then
			say("您好！",pid);
		end
	end
	if not notalk then
		if JY.Person[pid]["友好"]<40 and math.random(100)<100-JY.Person[pid]["友好"] then
			JY.Person[pid]["友好"]=JY.Person[pid]["友好"]+1+Rnd(2);
		end
	end
end
function RandomTalk(talk)
	local num=math.random(talk[0]);
	local str=talk[num];
	for i=1,999,2 do
		if str[i]<0 then
			break;
		end
		say(str[i+1],str[i]);
	end
	return false;
end
function CommenEvent(pid)
	if GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
function CommenTalk(pid)
	--随机说话
	local talk={
						[0]=100,
						{pid,"这天下武功，虽然层出不穷，但是总逃不脱力道、内劲、灵巧这三类。",-1},
						{pid,"天赋属性虽然没有直接用处，但是却决定着你一生的最高成就。",-1},
						{pid,"天赋再好，不努力也一样是白费。",-1},
						{pid,"力道高的人力量十足。",-1},
						{pid,"根骨高的人体魄强健。",-1},
						{pid,"机敏高的人反应敏锐。",-1},
						{pid,"力道高的人适合修练外家功夫，一力降十会。",-1},
						{pid,"根骨高的人应该修炼内家功，以巧破千斤。",-1},
						{pid,"机敏高的人应该学灵巧的功夫，须知天下武功，唯快不破。",-1},
						{pid,"资质高的人就是好啊，学什么都快。",-1},
						
						{pid,"福缘高的人，运气就是好啊，容易遇到奇遇。",-1},
						{pid,"内功和招式也是有配合的，如果不合适的话，或许会事倍功半呢。",-1},
						{pid,"有的人好酒，有的人好赌，有的人好打架。",-1},
						{pid,"有的人好琴，有的人好棋，有的人好书，有的人好画。",-1},
						{pid,"福威镖局可是江湖上数一数二的大镖局啊，只是......",-1},
						{pid,"琴棋书画诗酒花，当年样样不离它。",-1},
						{pid,"华山派君子剑岳掌门当真是谦谦君子。",-1},
						{pid,"铁血丹心，不知道你有没有听说过。",-1},
						{pid,"相传黄顺口大大已经退隐江湖了。",-1},
						{pid,"你有听过天涯歌手的故事吗？",-1},
						
						{pid,"相传武林中曾经有一个叫独孤求败的人，真是狂妄的名字啊。",-1},
						{pid,"为什么江湖中知名的拳法剑法这么多，刀法却这么少呢？",-1},
						{pid,"传说将人皮面具套在头上可以变换面目，乔装他人。",-1},
						{pid,"所谓外功者，乃专练刚劲，如铁臂膊等。这种功夫制人有余，自卫则不足了。",-1},
						{pid,"内功是专练柔劲，行气入膜，以充全身，虽不足以制人，可是练到炉火纯青的时候，不但拳脚不能伤其毫发，就用刀劈剑刺亦难使其毫发，就用刀劈剑刺亦难使其受损。",-1},
						{pid,"内练一口气，外练筋骨皮。",-1},
						{pid,"内功为武术之体，外功为武术之用。",-1},
						{pid,"你可知驭剑四妙？即轻、灵、疾、固四字。",-1},
						{pid,"你可知江湖四忌？即僧、道、妇、孺。因这类人物，虽貌不惊人，却常常身情绝技，深不可测。",-1},
						{pid,"“扯乎”是江湖黑话，逃跑之意。",-1},
						
						{pid,"金盆洗手是武林中人退隐时举行的一种仪式。洗手人双手插入盛满清水的金盆，宣誓从今以后再也不出拳动剑，决不过问武林中的是非恩怨。仪式常邀武林同道观摩作证。洗手人有的是因为一生杀人如麻，晚年放下屠刀，忏悔罪愆；有的是看破武林中的种种纷争丑恶，矢志退出漩涡，洁身自好，以求全躯。",-1},
						{pid,"泰山派创始祖师东灵道人遗下铁铸短剑一柄，是后世掌门人的信物。",-1},
						{pid,"据说佛教禅宗初祖菩提达摩寓止于嵩山少林寺，曾面壁面坐，终日默然静修九年。",-1},
						{pid,"练金钟罩、铁布衫一类外功的人，身上总会有一两处功夫练不到的地方，这就是罩门。",-1},
						{pid,"金钟罩等功练成，全身可以刀枪不入；但只有罩门例外，罩门如果被人发现，用重手法一戳，武功即废。",-1},
						{pid,"明教中埋葬死者讲究裸葬，入葬前须将死者的衣衫除得一丝不挂。",-1},
						{pid,"华山乃五岳之一，古称西岳，在陕西省东部华阴县南，有壁立千仞之势。",-1},
						{pid,"嵩山乃五岳之一，位于河南省西部，古时称「外方」，夏商时称「嵩高」，五代后称中岳嵩山，由太室山与少室山组成。",-1},
						{pid,"衡山乃五岳之一，古称南岳，位于湖南省。处处是茂林修竹，终年翠绿，奇花异草，四时飘香，因而又有「南岳独秀」的美称。",-1},
						{pid,"恒山乃五岳之一，古称北岳，位于山西省。山脉祖于阴山，横跨塞外，东连太行，西跨雁门，南障三晋，北瞰云代，东西绵延五百里。",-1},
						
						{pid,"泰山乃五岳之首，古称东岳，在山东省中部，有「天下第一山」之美誉。数千年来，先后有十二位皇帝来泰山「封禅」 。",-1},
						{pid,"据说黑玉断续胶乃外伤圣药。",-1},
						{pid,"如果不肯接受师傅交给的任务，师傅会生气的哦。",-1},
						{pid,"当初，如果我能......唉",-1},
						{pid,"恒山派有两大治伤灵药，外敷的天香断续胶，内服的白云熊胆丸。",-1},
						{pid,"丐帮可称天下第一大帮，门人弟子遍及天下。",-1},
						{pid,"江湖上有四大淫贼，不知道你听说过没有。",-1},
						{pid,"相传天山之北，极寒之地，有名为天山雪莲的奇花。",-1},
						{pid,"你是谁呀？",0,"......",pid,"哈哈，我开玩笑呢~",-1},
						{pid,"修练武功一定要循序渐进，如果强行修炼，很容易走火入魔的。",-1},
						
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"五岳剑派共制一面锦旗，名为「五色令旗」，见旗如见五岳剑派盟主。",-1},
						{pid,"相传用大雪山上的乌蚕蚕丝，可以织成一件护身宝衣，穿上后刀枪不入。",-1},
						{pid,"玄铁指环那是峨眉派掌门的信符，乃该派祖师的遗物，指环内刻有「留贻襄女」四字。",-1},
						{pid,"当年武林中有一件金丝甲，乃是防身至宝，穿在身上则刀枪不入、水火不伤，为争夺金丝甲，以便诛杀梅花盗，无数武林人士为之喋血。",-1},
						{pid,"听说有人用精铁铸成一对罗汉，肚腹之中装有机括，扭紧弹簧之后，能对拆一套少林拳法。",-1},
						{pid,"极北苦寒之地，数百丈坚冰之下挖出的寒玉，是修炼内功的极好工具。",-1},
						{pid,"有快到了赏善罚恶令出现的时候了。",-1},
						{pid,"据传说，西域大宛有一种天马，肩上出汗时殷红如血，胁如插翅，日行千里。",-1},
						{pid,"西藏雪山之顶，有奇物彩雪蛛，形体有酒盅杯口大小，全身条纹红绿相间，色彩鲜艳，乃天下三绝毒之一。",-1},
						
						{pid,"佛经上曾有记载菩斯曲蛇，遍身隐隐发出金光，头顶上生有肉角，行走如风，极难捕捉。",-1},
						{pid,"西藏大雪山上一种怪物，其形状与人相似，高有丈余，周身生有寸长白毛，刀枪不入。",-1},
						{pid,"临近北极的一个荒无人烟的火山岛。岛上有一座活火山，时常喷发。",-1},
						{pid,"青城山在四川省灌县城西南，山形如城，故名。北接岷山，连峰不绝，以青城为第一高峰。山中有八大洞，七十二小洞，风景秀丽。",-1},
						{pid,"拉哈苏乃是东北方言，意为“老屋”。",-1},
						{pid,"茅山位于江苏句容县东南，本名句曲山，汉代茅盈和他两个弟弟茅固、茅衷得道成仙于此，世称三茅君，因此山名曰茅山，亦称三茅山。",-1},
						{pid,"斩龙岛是位于云南大理洱海深处的一个荒岛，长约一里，宽有百丈。",-1},
						{pid,"侠客岛位于南海，距大陆有四天的航程，三十年中有三批武林高手前赴侠客岛，竟无一人回还。",-1},
						{pid,"昆仑山麓有一条谷道，名为恶人谷，由于恶人麋集而得名。",-1},
						{pid,"峨眉山在四川省峨眉县西南。山势雄伟，有山峰相对如蛾眉，故名。",-1},
						
						{pid,"野猪林是陕西一处有名的荒险之地。",-1},
						{pid,"辽东北岛南端渤海中一岛屿，岛上毒蛇遍地，千百年来，一直极少有人前往探险，因此颇为神秘。",-1},
						{pid,"楼兰乃汉时西域诸城国之一。晋时城市废弃，日久逐被沙石掩埋。",-1},
						{pid,"九华山位于安徽省南部，今青阳市西南，即汉时泾县、陵阳二地。",-1},
						{pid,"九华剑派的弟子极少，行踪更少出现江湖，他们供奉的两位就是诗酒风流的李白，据说这位青莲居士不但是诗仙，也是剑仙，九华剑派的剑法，就是他一脉相传的。",-1},
						{pid,"无量山便是无量剑派的根据地，在此山剑湖之畔建有剑湖宫，为无量剑扔的大本营。",-1},
						{pid,"安徽当涂有采石矶，是长江下游著名的风景古迹，其周十五里，高百仞，西接大江，三面俱绕清溪，在历史上向来是兵家必争之地。",-1},
						{pid,"浙江杭州市钱塘江滨月轮山上有塔，名为六和塔，外观八角十三层，内为七层，高约60米。",-1},
						{pid,"古墓派祖师林朝英居住古墓后，先参透了王重阳遗下的武功，潜心思索，创出的「玉女心经」一招一式皆为全真派武功的克星。",-1},
						{pid,"刀以雄浑、豪迈、挥如猛虎的风格而驰名。",-1},
						
						{pid,"刀，到也。以斩伐其所乃击之也。",-1},
						{pid,"剑是君子所佩，刀乃侠盗所使。",-1},
						{pid,"玉蜂针是古墓派的独门暗器，乃是细如毛发的金针，六成黄金、四成精钢，以玉蜂尾刺上毒液炼过，虽然细小，但因黄金沉重，掷出时仍可及远。",-1},
						{pid,"打狗棒系丐帮中历代帮主相传之物，质地柔韧，棒身绿莹，比单剑约长一尺。凡持此棒之人，必为帮主或帮主所托传令之人，帮中人等必须绝对服从。若以打狗棒法使此御敌，威力无穷。",-1},
						{pid,"冰魄银针是「赤练仙子」李莫愁所使暗器。针身镂刻花纹，打造精致。此针剧毒无比，一碰即中毒，皮肤全成黑色，若被碰破皮肤，顷刻便要丧命。",-1},
						{pid,"明教紫衫龙王黛绮丝，取灵蛇岛海底特产珊瑚金制成珊瑚金拐杖，削铁如切豆腐，打石如敲棉花。",-1},
						{pid,"真武剑乃是武当派创始之祖的佩剑，中年时用它扫荡群邪，威震江湖，晚年则极少使用。",-1},
						{pid,"明教五散人之一布袋和尚说有乾坤一气袋，常以此擒敌。此袋密不通风，质料奇妙，非丝非革，寻常刀剑斫它不破。",-1},
						{pid,"相传越王占勾践以白马白牛祀昆吾之神，从昆吾山（今河南濮阳西南）采精金铸冶八剑，即掩日、断水、转魄、悬翦、惊鲵、灭魂、却邪、真刚八大名剑。",-1},
						{pid,"七星海棠与寻常海棠无异，花瓣紧贴枝干而生，花枝如铁，花瓣上有七个小小的黄点。",-1},
						
						{pid,"相传北宋围棋国手刘仲甫在骊山与一乡下老媪对弈一百二十着，被杀得大败，登时呕血数升。人称这位老太婆为骊山仙姥。这局着着精警、实非常人所能的棋谱称呕谱。",-1},
						{pid,"送裴将军诗帖传为唐代颜真卿所书。该帖楷、行、草相混而书，书法大小、长短、肥瘦、斜正变化多端，间杂隶书笔法，气雄力厚。",-1},
						{pid,"清心普善咒，曲调柔和之至，似朝露暗润花瓣，如晓风低拂柳梢，有催眠作用",-1},
						{pid,"溪山行旅图是北宋著名画家范宽的传世之作。",-1},
						{pid,"江湖上有四大高手，东邪西毒南帝北丐！",-1},
						{pid,"东邪便是黄药师，擅使玉箫剑法。",-1},
						{pid,"西毒欧阳锋，蛤蟆功堪称一绝。",-1},
						{pid,"南帝家传绝学一阳指威力惊人。",-1},
						{pid,"北丐洪七公降龙十八掌盖世无双。",-1},
						{pid,"「中神通」王重阳「华山论剑」，力压东邪西毒南帝北丐，堪称天下第一",-1},
						
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
						{pid,"你有听过天涯歌手的歌声吗？",-1},
					};
	RandomTalk(talk);
	say("......原来如此啊");
	return false;
end
ForceEvent[0]=function(pid)	--华山
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==0 then
		if math.random(100)<10 then
			NPCQiecuo(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if GetFlag(1)-JY.Shop[0]["入门时间"]>30 and GetFlag(10001)==0 then	--寻找岳灵珊
			say("小师妹怎么还没回来啊。",pid);
			say("小师妹？我怎么从没见过？");
			say("小师妹和二师兄去福州了，那时候你还没有来华山，所以没见过。",pid)
			say("原来如此。")
			say("师弟你进来武功也有所长进，如果最近无事，不妨去福州打探下小师妹岳灵珊和二师兄劳德诺的消息",pid);
			say("好，我即刻起程。")
			SetFlag(10001,1);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[0]=function(pid)	--华山
	--随机说话
	local talk={
						[0]=14,
						{pid,"师父对门规最看重了，真怕哪天被他抓住痛骂。",-1},
						{pid,"据说我华山派几十年前也是武林中有数的大派，可惜啊，现在居然沦落到只是五派之一了。",
							0,"为什么呢？",
							pid,"听说当年，我华山因故分为剑气两支，在玉女峰前一场大战，那真是Ｈ哎呀，这个可不能再说了，要是被师傅听见了，我可吃不消。",-1},
						{pid,"师弟入门以来，可有不习惯的吗？",0,"一切都好。",-1},
						{pid,"在华山一切都好，就是师傅太严厉了。",-1},
						{pid,"师娘待人真的很好。",-1},
						{pid,"大师兄嗜酒如命，你要是得了什么好酒，记得叫上大师兄啊。",-1},
						{pid,"咱们华山门规很严的，你最好不要犯错。",-1},
						{pid,"要是犯了错，很有可能去后山思过崖面壁，那里可无聊了。",-1},
						{pid,"别看咱们华山现在人丁稀少，想当年咱们可是少林武当齐名的大派啊。",-1},
						{pid,"玉女峰的石像真漂亮，不知道是以何人的模样塑的。",-1},
						{pid,"莫以为师娘女子之身便娇娇弱弱，实际上她的武功不在师父之下哦。",-1},
						{pid,"小师妹不但人漂亮，剑法也漂亮，听说她曾经和大师兄合创过一门剑法。",-1},
						{pid,"听说这“正气堂”，以前是叫别的名字，不知道是什么。",-1},
						{pid,"咱们华山派人丁单薄，什么师叔师伯的都没有，真奇怪。",-1},
					};
	RandomTalk(talk);
	return false;
end
ForceEvent[1]=function(pid)	--青城
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==1 then
		if math.random(100)<10 then
			NPCQiecuo(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[1]=function(pid)	--青城
	--随机说话
	local talk={
						[0]=7,
						{pid,"格老子的，几个师兄逛窑子又不带我们……",-1},
						{pid,"听说咱们青城派有一门绝学叫摧心掌，和一本江湖上大大有名的秘笈有关系。",-1},
						{pid,"咱们青城派虽然是道士，却是火居道士，可以讨老婆的，想不到吧？哈哈！",-1},
						{pid,"听说咱们青城派和全真教的丘处机有点关系，不知是真是假。",-1},
						{pid,"咱们青城派在江湖上大大有名，很多镖局都要给咱们上供呢。",-1},
						{pid,"别看师父平时很凶，他对上余师兄的时候脾气很好了。",-1},
						{pid,"你有钱没？先借点给我吧。",-1},
					};
	RandomTalk(talk);
	return false;
end
ForceEvent[2]=function(pid)	--衡山
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==2 then
		if math.random(100)<10 then
			NPCQiecuo(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[2]=function(pid)	--衡山
	--随机说话
	local talk={
						[0]=8,
						{pid,"咱们衡山派很多人都喜欢音乐，你有选修什么乐器吗？",-1},
						{pid,"咱们衡山当年有一门非常厉害的剑法，叫做“衡山五神剑”，可惜失传了。",-1},
						{pid,"掌门的胡琴拉得非常好，可惜老是让人听哭出来，我实在怕了。",-1},
						{pid,"当年和魔教一场大战，咱们衡山派损失很大。当年师祖年纪还轻，结果很多武功都失传了。",-1},
						{pid,"刘师叔在箫艺上的造诣非常深，你要是有空，可以多听听。",-1},
						{pid,"刘师叔的女儿非常漂亮呢，你见过没？",-1},
						{pid,"听说刘师叔经常出去和人讨论音乐，你跟去过没？",-1},
						{pid,"听说上次有个很漂亮的小姑娘来刘师叔府上做客，你见到没？",-1},
					};
	RandomTalk(talk);
	return false;
end
ForceEvent[3]=function(pid)	--泰山
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==3 then
		if math.random(100)<10 then
			NPCQiecuo(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[3]=function(pid)	--泰山
	--随机说话
	local talk={
						[0]=8,
						{pid,"哎，嘴里又淡出鸟来，认识你这么久了，你还没请过客呢。",-1},
						{pid,"你不知道吧？咱们还有三个师叔祖呢，不过平时都看不到人。",-1},
						{pid,"听说当年师父当了掌门，三个师叔祖不大高兴呢。",-1},
						{pid,"若是三位师叔祖有什么吩咐，最好还是向师父禀告一声为妙啊。",-1},
						{pid,"师父的脾气比较……那个……刚烈，千万别惹师父生气啊。",-1},
						{pid,"你要是没事，去山涧溪流里找找，也许能找到美味的赤鳞鱼。",-1},
						{pid,"咱们泰山有三美——白菜、豆腐、水。",-1},
						{pid,"师父最喜欢吃肥城桃了，你要是出门，可以带点回来，顺便帮我带点东平槽鱼什么的……",-1},
						{pid,"听说咱们泰山派当年有一招剑法冠绝武林，可惜失传了……",-1},
					};
	RandomTalk(talk);
	return false;
end
ForceEvent[5]=function(pid)	--嵩山
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==5 then
		if math.random(100)<10 then
			NPCQiecuo(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[5]=function(pid)	--嵩山
	--随机说话
	local talk={
						[0]=11,
						{pid,"少林和尚有十八罗汉，武当七子有真武七截，却都只是靠阵法，而我们嵩山派的十三太保却个个都能独当一面。",-1},
						{pid,"我们要好好练功，争取能帮上师傅。",-1},
						{pid,"我们的师傅才是武林第一人。",-1},
						{pid,"有谁能胜任五岳掌门？毫无疑问，必然是师傅。",-1},
						{pid,"听说表现好的师兄弟，有机会获得师傅赏识，得传师傅独门武学呢！",-1},
						{pid,"听说表现好的师兄弟，有机会获得几位师叔的赏识，得传他们的独门武学呢！",-1},
						{pid,"华山早年便已一分为二，不足为惧。",-1},
						{pid,"泰山掌门辈分不高，有机可乘。",-1},
						{pid,"衡山派玩物丧志，不可造就。",-1},
						{pid,"恒山女尼，也就能青灯古佛。",-1},
						{pid,"我们嵩山被称为「中岳」，是因为我们这里是武林的中心。",-1},
					};
	RandomTalk(talk);
	return false;
end
ForceTalk[9]=function(pid)	--丐帮
	--随机说话
	local talk={
						[0]=6,
						{pid,"我们丐帮可是天下第一大帮。",-1},
						{pid,"武功是用来强身健体，但是就有人拿来烧杀掳掠，是在真不应该。",-1},
						{pid,"丐帮中人各个虽非大英雄，但也不失英雄气概。",-1},
						{pid,"每次聚会会因功论赏，甚至还会有人升袋子",-1},
						{pid,"在我们帮里只要有人立功，就有机会学到好的武功。",-1},
						{pid,"我帮中人必须行侠仗义，不要因为别人对我们的鄙视而自暴自弃",-1},
					};
	RandomTalk(talk);
	return false;
end
--你不是丐帮的人，来到这里想必是有事情吧
--看你的样子好像是走投无入了，要加入我们丐帮吗？这样出去外面也有个照应，别人才不会欺负你。 我来就是想加入丐帮，希望你们能收留我。  我误入此地，请你别见怪。
--想入本帮不难，但必须遵守帮规，你可以做到吗？
--长老可以教我点武功防身吗？不然出去外面真的有一点可怕。 好！我这就叫你武功，你可以好好记得。
--看你刚刚学武的样子，好像少了点什么，我帮你安排切磋的对象，或许可以帮你改正这些缺点
ForceTalk[14]=function(pid)	--全真教
	--随机说话
	local talk={
						[0]=17,
						{pid,"全真教乃是武林道上的名门正宗，万法之根源，所以我们必须让自己维持于正道之上，否则时会被逐出师门的。",-1},
						{pid,"听说活死人墓里常有白衣女鬼，晚上便会出现抓人吸阳气，好可怕呀！",-1},
						{pid,"晚上的时候后山林子那里是不能去了，那里鬼影憧憧......不要命的才会想去呢！",-1},
						{pid,"据说，后山之前有一位姑娘，因为被心上人遗弃，所以在哪里上吊自尽，后来那附近便时常的出现鬼魂......",-1},
						{pid,"掌教真人说了，擅闯活死人墓禁地的弟子一定会重重惩罚，绝不宽待！",-1},
						{pid,"太师叔又出去游玩了，这下不知道哪一天他才会回来。",-1},
						{pid,"饶君了悟真如性，未免抛身却入身。何以更兼修大药，顿起无福作真人。",-1},
						{pid,"修炼之余，不要忘了多多修炼养身之道。",-1},
						{pid,"江湖传闻「倚天屠龙」，不知道这世界上是不是真的有龙呢？",-1},
						{pid,"终南山风光明媚，但是品行太坏的人我们是不欢迎的。",-1},
						{pid,"道教的基本教义是人本主义，认为道在人身上的表现就是「生」，得道者必能长生。所以才要实践「生道合一」。",-1},
						{pid,"全真教还有一个人物，就是外号「老顽童」的周太师叔祖，可是他老人家不知道到哪里云游去了。",-1},
						{pid,"如果你想多为本派出点力，等你有一些历练之后，可以去找我们的师兄师父们。",-1},
						{pid,"三花聚顶掌法是祖师爷花了许多心血所创之掌法，威力惊人，你要好好用心学。",-1},
						{pid,"天罡北斗阵为祖师爷竭尽心力所创之阵法，如果想要阵法发挥最大功效，必须找齐七名伙伴，团队默契可是很重要的！",-1},
						{pid,"我全真教是名门正派，所以弟子都要洁身自好，不可为非作歹。",-1},
						{pid,"是滴，全真教之武功非一朝一夕就可练成，你可得多用点心，切莫贪快。欲速则不达的道理你该懂吧！",-1},
					};
	RandomTalk(talk);
	return false;
end
--鹿清笃 别烦我！我可是忙得很呢！  我好烦恼！别来吵我！  又还没到时间吃饭，找我干什么？
ForceEvent[99]=function(pid)	--BAK
	--每人的事件，一月最多一次
	if GetFlag(1)-GetFlag(5000+pid)>30 and JY.Person[0]["门派"]==99 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
ForceTalk[99]=function(pid)	--BAK
	--随机说话
	local talk={
						[0]=5,
						{pid,"师娘待人真的很好。",-1},
						{pid,"师娘使的那手剑法似乎从来都没有见过呢。",-1},
						{pid,"师娘人又好武功又高，跟咱师父还伉俪情深。",-1},
						{pid,"师娘似乎很喜欢别人称她为“宁女侠”。",-1},
						{pid,"师娘就像亲娘一样照顾我们，所以记住千万不要做出让她伤心的事啊。",-1},
					};
	RandomTalk(talk);
	return false;
end

PersonEvent[1]=function(pid)	--岳不群
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if MyQuest[1]==nil and math.random(100)<10 then
			QuestEvent[1](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if MyQuest[2]==nil and math.random(90)<10 then
			QuestEvent[2](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if math.random(80)<10 then
			KaochaKungfu(pid);
			return false;
		end
		if JY.Person[0]["等级"]>5 and GetFlag(10017)==0 then
			say("我华山诸弟子人人识文断字，你若有暇，可去向你师娘请教，想必对你以后习武也会有所裨益。",pid);
			SetFlag(10017,1);
			SetFlag(5000+pid,GetFlag(1));
			if GetFlag(10003)==0 then
				SetFlag(10003,1);
			end
			return false;
		end
		if false then	--随机事件格式
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[1]=function(pid)	--岳不群
	--随机说话
	local talk={
						[0]=5,
						{pid,"我华山派向来的宗旨是“人不犯我，我不犯人”，除了跟魔教是死对头之外，与武林中各门各派均无甚嫌隙。",-1},
						{pid,"本派首戒欺师灭祖，不敬尊长。二戒恃强欺弱，擅伤无辜。三戒奸淫好色，调戏妇女。四戒同门嫉妒，自相残杀。五戒见利忘义，偷窃财物。六戒骄傲自大，得罪同道。七戒滥交匪类，勾结妖邪。",-1},
						{pid,"本派不像别派那样，有许许多多清规戒律。你只须好好遵行七戒，时时记得仁义为先，做个正人君子，师父师娘就欢喜得很了。",-1},
						{pid,"武林之中，变故日多。我和你师娘近年来四处奔波，眼见所伏祸胎难以消解，来日必有大难，心下实是不安。",-1},
						{pid,"华山一派功夫，要点是在一个‘气’字，气功一成，不论使拳脚也好，动刀剑也好，便都无往而不利，这是本门练功正途。",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[2]=function(pid)	--宁中则
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[2]=function(pid)	--宁中则
	--随机说话
	local talk={
						[0]=3,
						{pid,"你师父平日规矩严谨，也是怕你们误入歧途。",-1},
						{pid,"找师娘有什么事吗？",-1},
						{pid,"又跟人打架受伤了？怎地脸色这样难看？伤得重不重？",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[14]=function(pid)	--岳灵珊
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if JY.Person[pid]["友好"]>50 and GetFlag(10002)==0 then	--开启传授淑女剑法
			say("小师妹，为什么你用的武功我从来没学过呢？");
			say("嘻嘻，这是我娘教我的淑女剑法哦，只有我和我娘会，爹爹都没学过呢。",pid);
			say("想学吗？快叫声师姐来听听。",pid);
			local menu={
									{"师姐",nil,1},
									{"师妹",nil,2},
								};
			local r=ShowMenu(menu,2,0,0,0,0,0,1,0);
			if r==1 then
				say("师姐....");
				say("呵呵，真乖。今天太晚了，过几天你再来找我学吧。",pid);
				SetFlag(10002,1);
				SetFlag(5000+pid,GetFlag(1)-20);
			elseif r==2 then
				say("小师妹，别开玩笑了");
				say("谁跟你开玩笑了，不学就算了",pid);
				SetFlag(5000+pid,GetFlag(1));
			end
			return false;
		end
		if GetFlag(10002)==1 and Getkflv(0,3)>5 then	--开启宁中则
			say("师姐，淑女剑法里还有几招我不太会，再教教我吧");
			say("那个，我也不会....",pid);
			say("要不你去找我娘吧。",pid);
			SetFlag(5000+pid,GetFlag(1));
			SetFlag(10002,2);
			if GetFlag(10003)==0 then
				SetFlag(10003,1);
			end
			return false;
		end
		if GetFlag(10002)==1 and math.random(100)<30 then	--传授淑女剑法
			say("师姐，今天能教我剑法吗？");
			say("好啊",pid);
			local kflist={
								{2,10},
								{3,6},
							};
			LearnKF(0,pid,kflist);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[14]=function(pid)	--岳灵珊
	--随机说话
	local talk={
						[0]=3,
						{pid,"小师弟，快叫声师姐来听听。",-1},
						{pid,"小师弟，来陪师姐练会剑吧。",-1},
						{pid,"小师弟，你有看到大师兄吗？",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[27]=function(pid)	--余沧海
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if GetFlag(1)-JY.Shop[1]["入门时间"]+GetFlag(11001)>30 and GetFlag(11002)==0 then	--随机事件格式
			say("当年你师祖长青子一代人杰，可惜......",pid);
			say("师傅，当年师祖是怎么死的？");
			say("当年你师祖少年英雄，乃是我青城派数一数二的人物。但是却栽在了林远图的辟邪剑法之下",pid);
			say("那林远图的什么剑法，如此厉害？");
			say("当年林远图以七十二路辟邪剑法，开创了福威镖局，当真是打遍黑道无敌手，白道上的英雄见他太过威风，也有去找他比试的，你师祖当年就是斗剑不过，郁郁而终。",pid);
			say("林远图？福威镖局？莫非这个林远图就是现在福威镖局总镖头林震南的父亲？");
			say("不，林远图是林震南的祖父。",pid);
			say("我且问你，林震南功夫如何？",pid);
			say("江湖上的人都说林震南出手豪阔，够义气，因此都不去动他的镖。至于他真是的功夫如何，则不得而知。");
			say("不错！现在福威镖局兴旺发达，一半是忌惮他家的七十二路辟邪剑法，一半却是黑白两道卖他面子。哼，他林震南出手豪阔确实不假，这些年，年年都给我青城派送来厚礼。",pid);
			say("长青子师祖就是因福威镖局的林远图而亡，这礼我们怎么能收！");
			say("不错，这些年，我年年都是将礼物拒之门外。但是，今年的礼物我却收了，你可知道为了什么？",pid);
			say("这个......弟子愚鲁，请师傅明示。");
			say("因为......我要将福威镖局满门上下杀个鸡犬不留！",pid);
			say("！！！");
			say("我先假意收下礼物，以安其心，然后再以回礼为名，让你的师兄去福州。名为回礼，实则要灭他满门。",pid);
			say("他福威镖局辟邪剑法如此厉害，当年师祖都不是对手，我们又如何......");
			say("哼，刚刚不是问过你林震南武功如何吗？",pid);
			say("这个......");
			say("我曾暗中看过他教他儿子辟邪剑法。依我看来，这剑法平平无奇！",pid);
			say("平平无奇？然道是假的？");
			say("不然，依我看来，是这剑法另有奥妙，只是林震南资质蠢笨，无法参透。",pid);
			say("师傅，这次既然要灭他福威镖局满门，何不细心寻找，若是找到他前人留下的剑谱，我青城派岂不就能威震武林了！");
			say("正是！那你就赶紧动身去福州吧，好好和你师兄们寻找剑谱的下落！",pid);
			say("是！");
			say("且慢，福威镖局毕竟人多势众，你单身一人太过危险。我且将林震南所练之辟邪剑法传授与你，日后交战之时也好有所准备",pid);
			say("谢师傅！");
			SetFlag(11002,1);
			SetFlag(11003,1);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if math.random(80)<10 then
			KaochaKungfu(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[27]=function(pid)	--余沧海
	--随机说话
	local talk={
						[0]=4,
						{pid,"当年你师祖长青子一代人杰，可惜......",-1},
						{pid,"辟邪剑法，哼！",-1},
						{pid,"福威镖局，哼！",-1},
						{pid,"林震南阿林震南。",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[49]=function(pid)	--莫大
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if MyQuest[1]==nil and math.random(100)<10 then
			QuestEvent[1](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if MyQuest[2]==nil and math.random(90)<10 then
			QuestEvent[2](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if math.random(80)<10 then
			KaochaKungfu(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[49]=function(pid)	--莫大
	--随机说话
	local talk={
						[0]=6,
						{pid,"天柱，紫盖，芙蓉，石禀，祝融......",-1},
						{pid,"可曾习乐？",-1},
						{pid,"剑，未必只杀人。乐，未必只闻声。",-1},
						{pid,"正，未必不邪。邪，未必不正。",-1},
						{pid,"衡山虽高，却不防鼠祸",-1},
						{pid,"多多陪陪你师父。",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[66]=function(pid)	--天门
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if MyQuest[1]==nil and math.random(100)<10 then
			QuestEvent[1](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if MyQuest[2]==nil and math.random(90)<10 then
			QuestEvent[2](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if math.random(80)<10 then
			KaochaKungfu(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[66]=function(pid)	--天门
	--随机说话
	local talk={
						[0]=5,
						{pid,"我泰山剑法多源于登山之路。",-1},
						{pid,"拔地五千丈，冲销十八盘。",-1},
						{pid,"去给师祖上香。",-1},
						{pid,"唉，师傅为何传位于我，却又不......长非长，尊非尊啊。",-1},
						{pid,"那几个老匹夫......",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[110]=function(pid)	--左冷禅
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if MyQuest[1]==nil and math.random(100)<10 then
			QuestEvent[1](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if MyQuest[2]==nil and math.random(90)<10 then
			QuestEvent[2](pid);
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
		if math.random(80)<10 then
			KaochaKungfu(pid);
			return false;
		end
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[110]=function(pid)	--左冷禅
	--随机说话
	local talk={
						[0]=5,
						{pid,"五岳剑派......五岳派......哼！",-1},
						{pid,"少林虽是武林北斗，但也只是嵩山一峰而已。",-1},
						{pid,"武当三丰真人独步天下，可其弟子？徒有其名而已。",-1},
						{pid,"想那东方不败堪称天下无敌，而今魔教却日渐式微，可见其终究只是个武夫而已。",-1},
						{pid,"何人能与吾共赏这胜观峰之景？",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[131]=function(pid)	--汤英鹗
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[131]=function(pid)	--汤英鹗
	local talk={
						[0]=5,
						{pid,"掌门师兄雄才伟略，你也须好好努力，不可负你师傅之名。",-1},
						{pid,"五岳并派之日，便是武林大洗牌之时。",-1},
						{pid,"三丰真人，独领风骚。少林众僧，德高望重。却都是方外之人，并不是武林盟主的好人选。",-1},
						{pid,"不知几位师兄之行，可还顺利？",-1},
						{pid,"天下是五岳的天下，五岳是掌门师兄的五岳。",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[196]=function(pid)	--段誉
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[196]=function(pid)	--段誉
	--随机说话
	local talk={
						[0]=10,
						{pid,"映门淮水绿，留骑主人心。明月随良椽，春潮夜夜深。",-1},
						{pid,"波渺渺，柳依依，孤村芳草远，斜日杏花飞。",-1},
						{pid,"月出皎兮，佼人僚兮；舒缭纠兮，劳心悄兮！",-1},
						{pid,"人生得意须尽欢，莫使金樽空对月。天生我才必有用，千金散尽还复来。",-1},
						{pid,"绿杨芳草长亭路，年少抛人容易去。",-1},
						{pid,"烽火燃不息，征战无已时。野战格斗死，败马号鸣向天悲。鸟鸢啄人肠，冲飞上挂枯树枝。士卒涂草莽，将军空尔为。乃知兵者是凶器，圣人不得已而用之。",-1},
						{pid,"春沟水动茶花白，夏谷云生荔枝红，青裙玉面如相识，九月茶花满路开。",-1},
						{pid,"不知子都之美者，无目者也。不识彼姝之美者，非人者也。爱美之心，人皆有之。",-1},
						{pid,"诸法从缘生，诸法从缘灭。我佛大沙门，常作如是说。",-1},
						{pid,"得失随缘，心无增减！",-1},
					};
	RandomTalk(talk);
	return false;
end
PersonEvent[9999]=function(pid)	--BAK
	local hasQuest=false;
	for i,v in pairs(MyQuest) do
		if pid==7000+10*(i-1) then
			hasQuest=true;
		end
	end
	--每人的事件，一月最多一次
	if hasQuest==false and GetFlag(1)-GetFlag(5000+pid)>30 then
		if false then	--随机事件格式
			
			SetFlag(5000+pid,GetFlag(1));
			return false;
		end
	end
	return true;
end
PersonTalk[9999]=function(pid)	--BAK
	--随机说话
	local talk={
						[0]=5,
						{pid,"师娘待人真的很好。",-1},
						{pid,"师娘待人真的很好。",-1},
						{pid,"师娘待人真的很好。",-1},
						{pid,"师娘待人真的很好。",-1},
						{pid,"师娘待人真的很好。",-1},
					};
	RandomTalk(talk);
	return false;
end

function DayPass(n,d)
	if n<1 then
		return;
	end
	d=d or 0;
	local now=GetFlag(1);
	local num=DelayEvent.num;
	for i=1,n do
		if d<0 and JY.SubScene>=0 and JY.Person[0]["体力"]<20 then
			say("身体好难受，不能坚持下去了。");
			return false;
		end
		if d>0 then
			for c=1,d do
				AddPersonAttrib(0,"体力",1);
				getkey();
				DrawState();
				ShowScreen();
				lib.Delay(CC.Frame);
			end
		elseif d<0 then
			for c=1,-d do
				AddPersonAttrib(0,"体力",-1);
				getkey();
				DrawState();
				ShowScreen();
				lib.Delay(CC.Frame);
			end
		end
		SetFlag(1,now+i);
		--AddPersonAttrib(0,"体力",d);
		for ii,v in pairs(TimeEvent) do
			if v.triggrt() then
				if v.kind==0 then
					v.kind=-1;
					num=num+1;
					DelayEvent[num]=v;
				elseif v.kind==1 then
					v.go();
					return false;
				elseif v.kind==2 then
					v.go();
				end
			end
		end
	end
		--Cls(0,0,400,100);
	DelayEvent.num=num;
	return true;
end

TimeEvent[1]={--NPC属性自然增长
							kind=2,	-- -1,临时关闭,0,延时,1,立即,2,后台
							triggrt=	function()
											local t=GetFlag(1);
											if t%30==0 then
												return true;
											end
											return false;
										end,
							go=	function()
										--DrawStrBoxWaitKey("NPC属性自然增长",C_WHITE,CC.Fontbig);
										for i=1,CC.ToalPersonNum do
											if not inteam(i) then
												local p=JY.Person[i];
												AddPersonAttrib(i,"经验",math.modf(p["等级"]*5000/(120-p["资质"])*(100+smagic(i,58,1))/100));
												War_AddPersonLevel(i,false); 
											end
										end
										return;
									end,
							
						};
TimeEvent[2]=	{--门派比武
							kind=0,
							triggrt=	function()
											local t=GetFlag(1);
											if t%360==0 then
												return true;
											end
											return false;
										end,
							go=	function()
										if JY.Person[0]["门派"]<0 then
											return;
										end
										if JY.SubScene==JY.Shop[JY.Person[0]["门派"]]["据点"] then
											Dark();
											Light();
											say("今天刚好是门派比武的日子呢，要去参加吗？");
											if DrawStrBoxYesNo(-1,-1,"是否参加门派比武？",C_WHITE,CC.Fontbig) then
												say("今天的优胜一定是我！");
												Dark();
												local pid=1;
												if JY.SubScene==27 then
													JY.Base["人X1"],JY.Base["人Y1"]=16,26;
													JY.Base["人方向"]=2;
													pid=110;
												elseif JY.SubScene==29 then
													JY.Base["人X1"],JY.Base["人Y1"]=22,27;
													JY.Base["人方向"]=2;
													pid=66;
												elseif JY.SubScene==36 then
													JY.Base["人X1"],JY.Base["人Y1"]=28,21;
													JY.Base["人方向"]=0;
													pid=27;
												elseif JY.SubScene==57 then
													JY.Base["人X1"],JY.Base["人Y1"]=23,28;
													JY.Base["人方向"]=2;
													pid=1;
												elseif JY.SubScene==58 then
													JY.Base["人X1"],JY.Base["人Y1"]=28,16;
													JY.Base["人方向"]=0;
													pid=49;
												else
												
												end
												JY.MyPic=GetMyPic();
												Light();
												say("今天是一年一度的"..JY.Shop[JY.Person[0]["门派"]]["名称"].."比武大会，大家要好好努力。",pid);
												E_kungfugame(JY.Person[0]["门派"],pid);
												return;
											end
										end
										StrTalk=function()
											DrawStrCenter("Ｙ"..JY.Shop[JY.Person[0]["门派"]]["名称"].."Ｗ举行了门派比武",CC.Fontbig);
											ShowScreen();
											WaitKey();
											say_2("没能参加真可惜，不过下次应该还有机会的。");
										end
										ShowStrTalk();
										--
										--Dark();
										--lib.Delay(200);
										--DrawStrCenter("Ｙ"..JY.Shop[JY.Person[0]["门派"]]["名称"].."Ｗ举行了门派比武",CC.Fontbig);
										--ShowScreen();
										--WaitKey();
										--say("没能参加真可惜，不过下次应该还有机会的。");
										--Cls();
										--Light();
									end,
						}
TimeEvent[3]={--寻找岳灵珊
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10001)==2 then
												TimeEvent[3]=nil;
												return false;
											end
											if GetFlag(1)-GetFlag(2)>90 then
												return true;
											end
											return false;
										end,
							go=	function()
										ModifyD(1,20,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
										ModifyD(1,22,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
										ModifyD(1,2,-2,-2,-2,-2,-2,-1,-1,-1,-2,-2,-2);
										ModifyD(1,11,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
										ModifyD(1,12,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
										ModifyD(1,13,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
										ModifyD(1,14,-2,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
										--岳灵珊,劳德诺回华山
										JY.Person[9]["门派"]=0;
										JY.Person[14]["门派"]=0;
										ModifyD(57,28,1,-2,5,14,-1,4259*2,4259*2,4259*2,-2,-2,-2);
										ModifyD(57,29,1,-2,5,9,-1,5180,5180,5180,-2,-2,-2);
										SetFlag(10001,2);	--寻找岳灵珊OK
										SetFlag(11002,2);
										SetFlag(16001,1);	--开启福威镖局灭门
										SetFlag(16002,GetFlag(1));
										StrTalk=function()
											DrawStrCenter("福州，青城派弟子余人彦调戏华山岳不群之女岳灵珊，为福威镖局少镖头林平之所杀。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("听说小师妹已经回华山了，去看望一下吧。");
												say_2("青城贼子真是死有余辜，那福威镖局的小子倒是不错，只是青城派势大，此事恐怕不会这么简单就结束吧。");
											elseif JY.Person[0]["门派"]==1 then
												say_2("福威镖局！我看你们是活的不耐烦了！");
											else
												say_2("青城贼子真是死有余辜，那福威镖局的小子倒是不错，只是青城派势大，此事恐怕不会这么简单就结束吧。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[4]={--福威镖局灭门
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(16001)==2 then
												TimeEvent[4]=nil;
												return false;
											end
											if GetFlag(16001)==1 and GetFlag(1)-GetFlag(16002)>30 then
												return true;
											end
											return false;
										end,
							go=	function()
										ModifyD(56,0,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,1,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,2,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,3,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,6,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,7,-2,-2,10,-2,-2,2724*2,2724*2,2724*2,-2,-2,-2);
										ModifyD(56,8,0,0,0,0,0,0,0,0,0,-2,-2);
										ModifyD(56,9,0,0,0,0,0,0,0,0,0,-2,-2);
										SetFlag(16001,2);
										StrTalk=function()
											DrawStrCenter("福州，青城派掌门余沧海为报林平之杀徒之仇，带领门人将福威镖局灭门。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==1 then
												say_2("这就是和我青城派作对的下场，可惜我身有要事，未能亲自报仇！");
											else
												say_2("青城派的手段，也未免太狠辣了一些吧。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[5]={--回雁楼
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10004)~=0 then
												TimeEvent[5]=nil;
												return false;
											end
											if GetFlag(1)-GetFlag(2)>180 then
												return true;
											end
											return false;
										end,
							go=	function()
										ModifyD(38,10,0,-2,0,0,-2,0,0,0,0,-2,-2);
										SetFlag(10004,2);
										StrTalk=function()
											DrawStrCenter("衡阳·回雁楼，华山弟子令狐冲和淫贼田伯光同桌共饮。泰山派迟百城及天松道长杀田伯光不成，反为所害。青城派弟子罗人杰等也为令狐冲所杀。据说恒山弟子仪琳和令狐冲在一起。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("令狐冲乃我华山首徒，怎么会和田伯光混在一起了？此事必有隐情。");
											elseif JY.Person[0]["门派"]==1 then
												say_2("令狐冲！你结交淫贼田伯光，还杀我师兄，我倒要看看你能猖狂到几时！");
											elseif JY.Person[0]["门派"]==3 then
												say_2("好个令狐冲，同为五岳剑派，居然勾结田伯光那恶贼。我师叔虽不是你亲手所杀，却也饶你不得！");
											elseif JY.Person[0]["门派"]==4 then
												say_2("仪琳师姐，希望你没事才好。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[6]={--洗手
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(12005)>1 then
												TimeEvent[6]=nil;
												return false;
											end
											if GetFlag(1)-GetFlag(2)>360 then
												return true;
											end
											return false;
										end,
							go=	function()
										ModifyD(58,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,26,3);
										SetFlag(12005,2);
										SetFlag(12006,2);
										StrTalk=function()
											DrawStrCenter("衡山，刘正风金盆洗手大会。嵩山派费彬等人传左冷禅五岳令，揭露了刘正风勾结魔教妖人曲洋的阴谋，并设下埋伏，成功地将其一网打尽。但是奇怪的是，事后费彬却离奇地被人杀死。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==2 then
												say_2("想不到师傅他居然会结交魔教中人......");
											elseif JY.Person[0]["门派"]==5 then
												say_2("左掌门神机妙算，才识破了这等大阴谋。只是费师叔之死，却实在奇怪，莫非是被衡山高手暗算了不成？");
											else
												say_2("刘正风风光一辈子，却不想落得个家破人亡，这魔教实在害人不浅阿。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[7]={--莫大杀费彬
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(12006)>0 then
												TimeEvent[7]=nil;
												return false;
											end
											if GetFlag(12005)==2 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(12006,2);
										StrTalk=function()
											DrawStrCenter("衡山，嵩山高手费彬离奇地被人杀死。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==5 then
												say_2("费师叔之死，实在奇怪，莫非是被衡山高手暗算了不成？");
											else
												say_2("费彬武功高强，谁又杀的了他呢？");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[8]={--林震南结局
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(16003)>0 then
												TimeEvent[8]=nil;
												return false;
											end
											if GetFlag(12006)==2 and Rnd(5)==1 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(16003,5);
										SetFlag(16004,GetFlag(1));	--记录林震南死亡时间
										--SetS(57,27,29,3,201);	--开启华山·平之拜师·令狐面壁事件
										StrTalk=function()
											DrawStrCenter("衡山郊外，林震南夫妇被人杀死。其子林平之拜入华山·岳不群门下为徒。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("师傅又收了一个弟子阿。");
											elseif JY.Person[0]["门派"]==1 then
												say_2("林震南，死得好！师兄的仇算是报了一半了。还有个林平之，哼，又是你华山派！");
											else
												say_2("林平之也怪可怜的。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[9]={--令狐冲面壁
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10005)>0 then
												TimeEvent[9]=nil;
												return false;
											end
											if GetFlag(16003)>0 and GetFlag(1)-GetFlag(16004)>50 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10005,1)
										--SetS(57,27,29,3,-1);	--关闭华山·平之拜师·令狐面壁事件
										StrTalk=function()
											DrawStrCenter("华山·正气堂，岳不群祭奠华山先辈，正式收林平之为徒。同时，令狐冲因多次违反华山门规，被责罚思过崖面壁一年。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("师傅也太严厉了点，大师兄虽然违反了一些门归，但都是出于好心的权宜之计阿。");
											elseif JY.Person[0]["门派"]==1 then
												say_2("令狐冲这小子真是活该！只是这林平之既已拜入华山，恐怕就再难对其出手了。");
											else
												say_2("华山不愧是名门正派，门规谨严。");
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[10]={--华山众人离山
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10007)>0 then
												TimeEvent[10]=nil;
												return false;
											end
											if GetFlag(16003)>0 and GetFlag(1)-GetFlag(16004)>150 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10007,1)
										SetFlag(10010,GetFlag(1));
										if JY.Person[0]["门派"]==0 then
											StrTalk=function()
												DrawStrCenter("华山，岳不群带领众弟子下山，围剿采花淫贼·田伯光",CC.Fontbig);
												ShowScreen();
												WaitKey();
												say_2("师兄，可算找到你了。师傅有令，命你不必回山，先四处搜寻田伯光的下落。",24);
												say_2("好！");
											end
											ShowStrTalk();
										end
										--众人消失
										ModifyD(57,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,1);
										ModifyD(57,1,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,2);
										ModifyD(57,17,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,3);
										ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,4);
										ModifyD(57,26,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,5);
										ModifyD(57,6,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,6);
										ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,7);
										ModifyD(57,23,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,8);
										ModifyD(57,24,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,9);
										ModifyD(57,15,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,10);
										ModifyD(57,16,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,11);
										ModifyD(57,27,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,12);
										ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,13);
										ModifyD(57,30,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,14);
										ModifyD(57,2,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,15);
										ModifyD(57,29,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,16);
										ModifyD(57,3,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,17);
										ModifyD(57,4,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,18);
										ModifyD(57,18,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,19);
										ModifyD(57,19,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,20);
										ModifyD(57,20,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,21);
										ModifyD(57,21,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,22);
										SetS(57,52,29,3,201);
										SetS(57,52,30,3,201);
										SetS(57,30,13,3,202);
										SetS(57,31,13,3,202);
										SetS(62,50,25,3,201);
										SetS(62,50,26,3,201);
										return;
									end
							
						};
TimeEvent[11]={--围攻田伯光&华山弟子回山&袁承志出山
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10011)>0 then
												TimeEvent[11]=nil;
												return false;
											end
											if GetFlag(10010)>0 and GetFlag(1)-GetFlag(10010)>42 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10011,1);
										SetFlag(10009,GetFlag(1));
										ModifyD(81,0,-2,-2,3,-2,-2,-2,-2,-2,-2,-2,-2);	--修改令狐练剑
										StrTalk=function()
											DrawStrCenter("岳不群带领众弟子将淫贼·田伯光赶出了长安地界。华山派侠义之名，一时广为称赞。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("田伯光已经跑了，师傅想必也回山了吧");
											else
												say_2("田伯光不愧是「万里独行」，居然能从岳不群手里跑了。");
											end
										end
										ShowStrTalk();
										--众人出现
										ModifyD(57,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,29);
										ModifyD(57,1,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,28);
										ModifyD(57,17,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,27);
										ModifyD(57,22,-2,-2,-2,-2,-2,-2,-2,-2,-2,21,25);
										ModifyD(57,26,-2,-2,-2,-2,-2,-2,-2,-2,-2,21,13);
										ModifyD(57,6,-2,-2,-2,-2,-2,-2,-2,-2,-2,24,40);
										ModifyD(57,5,-2,-2,-2,-2,-2,-2,-2,-2,-2,20,44);
										ModifyD(57,23,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,28);
										ModifyD(57,24,-2,-2,-2,-2,-2,-2,-2,-2,-2,27,30);
										ModifyD(57,15,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,37);
										ModifyD(57,16,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,14);
										ModifyD(57,27,-2,-2,-2,-2,-2,-2,-2,-2,-2,40,36);
										ModifyD(57,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,29,24);
										ModifyD(57,30,-2,-2,-2,-2,-2,-2,-2,-2,-2,30,25);
										ModifyD(57,2,-2,-2,-2,-2,-2,-2,-2,-2,-2,39,22);
										ModifyD(57,29,-2,-2,-2,-2,-2,-2,-2,-2,-2,38,13);
										ModifyD(57,3,-2,-2,-2,-2,-2,-2,-2,-2,-2,46,29);
										ModifyD(57,4,-2,-2,-2,-2,-2,-2,-2,-2,-2,46,30);
										ModifyD(57,18,-2,-2,-2,-2,-2,-2,-2,-2,-2,50,32);
										ModifyD(57,19,-2,-2,-2,-2,-2,-2,-2,-2,-2,50,27);
										ModifyD(57,20,-2,-2,-2,-2,-2,-2,-2,-2,-2,51,27);
										ModifyD(57,21,-2,-2,-2,-2,-2,-2,-2,-2,-2,51,32);
										SetS(57,52,29,3,-1);
										SetS(57,52,30,3,-1);
										SetS(57,30,13,3,-1);
										SetS(57,31,13,3,-1);
										SetS(62,50,25,3,-1);
										SetS(62,50,26,3,-1);
										return;
									end
							
						};
TimeEvent[12]={--令狐Vs承志
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10013)>0 then
												TimeEvent[12]=nil;
												return false;
											end
											if GetFlag(10009)>0 and GetFlag(1)-GetFlag(10009)>120 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10013,2);
										ModifyD(81,0,-2,-2,-2,-2,-2,-2,-2,-2,-2,1,1);	--修改令狐
										SetFlag(10014,GetFlag(1)+20);
										if GetFlag(10012)==1 then
											StrTalk=function()
												say_2("哎呀，我把大师兄和袁承志的比剑给忘记了！");
											end
											ShowStrTalk();
										end
										return;
									end
						};
TimeEvent[13]={--剑宗上山
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10015)>0 then
												TimeEvent[13]=nil;
												return false;
											end
											if GetFlag(10015)==0 and GetFlag(10014)>0 and GetFlag(1)-GetFlag(10014)>0 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10015,2);
										SetFlag(10016,2);
										TimeEvent[14]=nil;
										SetS(57,43,13,1,4323*2);
										SetS(62,9,21,1,4707*2);
										SetS(62,9,21,3,1);
										StrTalk=function()
											DrawStrCenter("华山·剑宗弟子·封不平在嵩山派的协助下，威逼岳不群交出掌门之位，可笑的是却被岳不群之徒·令狐冲击败。令狐冲同时也深受重伤，内力全失。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("大师兄的武功怎么这么厉害了！");
											else
												say_2("怎么剑宗的武功如此不堪，连一个二代弟子都不如？");
											end
										end
										ShowStrTalk();
										return;
									end
						};
TimeEvent[14]={--令狐受伤
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(10016)>0 then
												TimeEvent[14]=nil;
												return false;
											end
											if GetFlag(10016)==0 and GetFlag(10015)>0 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(10016,1);
										SetS(57,43,13,1,4323*2);
										StrTalk=function()
											SetS(81,49,36,3,-1);
											DrawStrCenter("华山·令狐冲被六个怪人所伤，内力全失。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==0 then
												say_2("大师兄的伤势不知道如何了。");
											elseif JY.Person[0]["门派"]==1 then
												say_2("这下子令狐冲就不足为惧了，下次让我碰上，绝对一剑杀了！");
											else
												say_2("六个怪人？不知道是何等人物。");
											end
										end
										ShowStrTalk();
										return;
									end
						};
						
TimeEvent[15]={--马大元之死
							kind=0,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if GetFlag(19001)~=0 then
												TimeEvent[15]=nil;
												return false;
											end
											if GetFlag(1)-GetFlag(2)>380 and Rnd(10)==1 then
												return true;
											end
											return false;
										end,
							go=	function()
										SetFlag(19001,3);
										StrTalk=function()
											DrawStrCenter("江湖传言，丐帮马副帮主被人用其绝学所杀，真凶不明。",CC.Fontbig);
											ShowScreen();
											WaitKey();
											if JY.Person[0]["门派"]==9 then
												script_say("主角：（什么？我马帮主居然被神秘人物用其绝学所杀？不行！我要马上禀报帮主！）")
											else
												script_say("主角：（丐帮马副帮主被神秘人物所杀，这下江湖又要乱了啊……）")
											end
										end
										ShowStrTalk();
										return;
									end
							
						};
TimeEvent[35]={--NPC自行移动
							kind=2,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											local t=GetFlag(1);
											if t%30==0 then
												return true;
											end
											return false;
										end,
							go=	function()
										PersonMove();
										return;
									end
							
						};
--延时,等待daypass后一起触发
--立即,立刻停止daypass,触发
--后台,daypass同时触发
TimeEvent[999]={--BAK
							kind=2,	--,0,延时,1,立即,2,后台
							triggrt=	function()
											if false then
												return true;
											end
											return false;
										end,
							go=	function()
										
										return;
									end
							
						};

						
						
--MyQuest:nil/0未开启,1开启						
QuestEvent[1]=function(pid)
	local oid=GetFlag(7000);
	if oid==0 then
		say("我听说今日有魔教中人潜入长安城。我派一向与魔教势不两立，你可愿代我去长安城走一趟？",pid);
		if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
			say("我这就出发！");
			SetFlag(7000,pid);
			ModifyD(134,18,1,-2,100,147,-2,5888,5888,5888,0,-2,-2);
			MyQuest[1]=1;
		else
			say("不中用的家伙！",pid);
			AddPersonAttrib(pid,"友好",-5);
			AddPerformance(-5);
		end
	elseif oid==pid then
		if MyQuest[1]==2 then
			say("长安城里的魔教妖人已经被我赶跑了。");
			say("很好！你真是立下了大功一件阿！",pid);
			local add,str=AddPersonAttrib(0,"修炼点数",(4+JY.Person[0]["等级"])*5+200+math.random(50));
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
			AddPersonAttrib(pid,"友好",1);
			AddPerformance(10);
			SetFlag(7000,0);
			MyQuest[1]=nil;
			return true;
		end
	end
	return false;
end
QuestEvent[2]=function(pid)
	local oid=GetFlag(7010);
	local p=	{
						{1,"华山派的岳掌门","岳掌门"},
						{27,"松风观的余观主","余沧海"},
						{49,"衡山派的莫大先生","莫掌门"},
						{66,"泰山派的天门道长","天门道长"},
						{110,"嵩山派的左师兄","左掌门"},
					}
	if oid==0 then
		local n;
		for i,v in pairs(p) do
			if pid==v[1] then
				n=i;
			end
		end
		while p[n][1]==pid do
			n=math.random(5);
		end
		say("你来得正好，我有一封书信，要送给"..p[n][2].."，你能帮我跑一趟吗？",pid);
		if DrawStrBoxYesNo(-1,-1,"是否接受？",C_WHITE,CC.Fontbig) then
			say("我这就出发！");
			SetFlag(7010,pid);
			SetFlag(7011,n);
			MyQuest[2]=1;
		else
			say("算了，我找其他人吧。",pid);
			AddPersonAttrib(pid,"友好",-3);
			AddPerformance(-2);
		end
	elseif pid==oid then
		if MyQuest[2]==2 then
			say("我已经把信送出去了。");
			say("很好，一路辛苦了，好好休息吧。",pid);
			local add,str=AddPersonAttrib(0,"经验",(4+JY.Person[0]["等级"])*10+300+math.random(50));
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
			AddPersonAttrib(pid,"友好",1);
			AddPerformance(5);
			MyQuest[2]=nil;
			return true;
		end
	elseif pid==p[GetFlag(7011)][1] then
		if MyQuest[2]==1 then
			say("这是给您的信，"..p[GetFlag(7011)][3].."。");
			say("嗯，我已经收到了，你回去复命吧。",pid);
			MyQuest[2]=2;
			return true;
		end
	end
	return false;
end

function EventInitialize()
	local SE={};
	SE[1]={
				kind="会面",
				trigger=function()
							if GetFlag(17001)==0 and JY.SubScene==115 and JY.Person[JY.Da]["姓名"]=="段誉" and GetFlag(1)-GetFlag(2)>30 and JY.Person[0]["门派"]==7 and Rnd(10)==1 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						Dark();
						Light();
						script_say("主角：见过世子。咦？世子你这是……")
						script_say("段誉：刚刚爹爹来逼我习武，我不愿意，爹爹就用一阳指点了我穴。你快帮我解开，我站着这半天都快累死了。")
						script_say("主角：这……我的内力不足，没法帮世子解穴。")
						script_say("段誉：啊……爹爹也真是的，我自幼爱读佛经，他原本也是知道的。佛说众生平等，不应杀生，他现在却偏偏要我去练什么杀人的武学。若真是要学武爹爹才肯帮我解穴，那我宁愿一辈子就站在这算了")
						script_say("主角：……（我要不要帮助世子呢？）")
						if DrawStrBoxYesNo(-1,-1,"要不要帮助世子") then
							SetFlag(17001,1);
							script_say("主角：世子莫急，我想王爷也只是一时之气，不如让我前去劝劝王爷，王爷的气消了，应该就会来帮世子解穴了。")
							script_say("段誉：太好了，那就麻烦你了。")
						else
							SetFlag(17001,2);
							script_say("主角：世子，王爷说的对，在这乱世江湖之中，不会武功，终将寸步难行。世子更是贵为我大理世子，这武不可不学。世子还是答应王爷吧，王爷气消了，自然是会帮世子解穴的。")
							script_say("段誉：不学！不学！这杀人的东西我才不要学！就让我在这站死算了！")
						end
					end,
				
			};
	SE[2]={
				kind="会面",
				trigger=function()
							if GetFlag(17001)==2 and GetFlag(17002)==0 and JY.SubScene==115 and JY.Person[JY.Da]["姓名"]=="段誉" and JY.Person[0]["门派"]==7 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						script_say("段誉：不学！不学！这杀人的东西我才不要学！就让我在这站死算了！")
						script_say("主角：哎，还是去劝劝王爷吧。")
					end,
				
			};
	SE[3]={
				kind="会面",
				trigger=function()
							if GetFlag(17001)==1 and GetFlag(17002)==0 and JY.SubScene==115 and JY.Person[JY.Da]["姓名"]=="段誉" and JY.Person[0]["门派"]==7 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						script_say("段誉：可是爹爹气消了？")
						script_say("主角：世子莫急，王爷公务繁忙，一时未能觐见，我这便再去瞧瞧。")
						script_say("段誉：有劳你了。")
					end,
				
			};
	SE[4]={
				kind="会面",
				trigger=function()
							if GetFlag(17001)~=0 and GetFlag(17002)==0 and JY.SubScene==115 and JY.Person[JY.Da]["姓名"]=="段正淳" and JY.Person[0]["门派"]==7 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(17002,1);
						script_say("主角：参见王爷。")
						script_say("段正淳：哦？你找本王有事？")
						script_say("主角：王爷，属下乃是为世子而来的。世子自幼喜读佛经，如今更是菩萨心肠。硬逼其学武，属下觉得，实在有些强人所难。")
						script_say("段正淳：哼！")
						script_say("主角：王爷，其实有如此一位宅心仁厚的世子，是我大理之福啊。古人曾云，当以仁爱治天下，世子兼爱众生，假以时日，必是仁君。")
						script_say("段正淳：哼！我大理段氏传人，不会武功，岂不是惹天下耻笑？更何况如此一来，我段氏一脉绝学一阳指也将成绝学，这让段某如何面对我大理段氏的列祖列宗？")
						script_say("主角：王爷所言甚是。只是世子此时尚且年幼，一时不曾想到这一层，如今习武一事已惹其厌恶，强行迫其学武只能是适得其反。王爷，世子久居于镇南王府之中，不曾涉入江湖，自是不知江湖凶险，无武不行。我想，等世子见识过这乱世之道以后，便会醒悟。")
						script_say("段正淳：……嗯，你言之有理。那……就饶了他这次？")
						script_say("主角：王爷，世子从未习武，不比我等，王爷已用一阳指点起穴道令其站足几个时辰，世子恐怕已再难忍耐，如此，岂不是更令其厌恶武学？")
						script_say("段正淳：……走！")
						Dark();
							--主角
							JY.Base["人X1"],JY.Base["人Y1"]=41,34;
							JY.Base["人方向"]=0;
							JY.MyPic=GetMyPic();
							--王爷
							ModifyD(115,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,41,32);
							--世子
							ModifyD(115,28,-2,-2,-2,-2,-2,-2,-2,-2,-2,0,0);
						Light();
						script_say("段正淳：嗯？誉儿人呢？")
						script_say("主角：这……属下之前离开之时，世子还在的啊。莫不是时辰已到，世子的穴道已自行解开？")
						script_say("段正淳：不可能。我点了他的穴，没有一天是不可能自行解开了。看来是有人解了誉儿的穴道放跑了他。")
						script_say("主角：王爷，那现在该如何是好？")
						script_say("段正淳：誉儿没有武功，仅凭双脚，不可能走得太远。这样，你速去附近寻查。若是发现了誉儿，就把他给我带回来。")
						script_say("主角：是！")
						Dark();
							ModifyD(115,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,28,12);
						Light();
					end,
				
			};
	SE[5]={
				kind="会面",
				trigger=function()
							if GetFlag(17002)==1 and JY.SubScene==115 and JY.Person[JY.Da]["姓名"]=="段誉" and JY.Person[0]["门派"]==7 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(17003,1);
						script_say("主角：啊！世子！")
						script_say("段誉：咦？爹爹！")
						script_say("主角：王爷来了？")
						script_say("段誉：我闪！")
						Dark();
								SetD(JY.SubScene,JY.CurrentD,0,0);
								SetD(JY.SubScene,JY.CurrentD,3,-1);
								SetD(JY.SubScene,JY.CurrentD,5,0);
								SetD(JY.SubScene,JY.CurrentD,6,0);
								SetD(JY.SubScene,JY.CurrentD,7,0);
						Light();
						script_say("主角：王爷没来啊。咦？怎么一瞬间世子就不见了？")
					end,
				
			};
	SE[6]={
				kind="会面",
				trigger=function()
							if GetFlag(17003)==1 and JY.SubScene==115 and GetFlag(17004)==0 and JY.Person[JY.Da]["姓名"]=="段正淳" and JY.Person[0]["门派"]==7 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(17004,1);
						script_say("主角：王爷，属下无能，虽然发现了世子，但是一时大意，却又让世子跑了。")
						script_say("段正淳：嗯。无妨，只要确认他平安无事便好，他也该见识见识江湖了。既然他能从你眼皮底下跑掉，证明他还是有点小聪明的。这次的事你做的不错，我便传你这[乾坤易阳决]吧。")
						script_say("主角：谢王爷！")
						local kflist=	{
											{110,10},
										};
						LearnKF(0,JY.Da,kflist);
					end,
				
			};
	SE[51]={
				kind="进入",
				trigger=function()
							if GetFlag(19001)==0 and GetFlag(1)-GetFlag(2)>180 and Rnd(15)==1 and (JY.SubScene==38 or JY.SubScene==40 or JY.SubScene==109 or JY.SubScene==112 or JY.SubScene==133 or JY.SubScene==134) then
								return 1;
							end
							return 0;
						end,
				go=	function()
						JY.Person[263]["头像代号"]=319*4+1001;
						JY.Person[263]["战斗动作"]=319;
						JY.Person[263]["姓名"]='神秘人';
						JY.Person[263]["外号"]='神秘人';
						JY.Person[263]["攻击"]=JY.Person[263]["攻击"]+30;
						JY.Person[263]["防御"]=JY.Person[263]["防御"]+30;
						JY.Person[263]["身法"]=JY.Person[263]["身法"]+30;
						ModifyD(51,12,-2,-2,-2,-2,-2,-2,-2,-2,-2,0,0);
						local x0,y0=JY.Base["人X1"],JY.Base["人Y1"];
						local d=JY.Base["人方向"];
						local x1,y1=x0+3*CC.DirectX[d+1],y0+3*CC.DirectY[d+1];
						local x2,y2=x1,y1+1;
						Dark();
							SetS(JY.SubScene,x1,y1,1,10552*2);
							SetS(JY.SubScene,x2,y2,1,11277*2);
						Light();
						if JY.Person[0]["门派"]==9 then
							script_say("主角：（咦？那不是我丐帮的马帮主么？他怎么在与人战斗？不好，马帮主快撑不住了！）")
							script_say("主角：马帮主！我来助你！")
							if FIGHT(2,1,{262,x1,y1,0,1,1},{263,x2,y2},100,-1,998,false) then
								SetFlag(19001,1)
								script_say("神秘人：哼！")
								Dark()
									SetS(JY.SubScene,x2,y2,1,0);
								Light()
								DrawStrBoxWaitKey("神秘人消失");
								script_say("主角：算你跑得快！马帮主，你的伤……")
								script_say("马大元：我伤的太重，怕是……")
								script_say("主角：马帮主！都怪我来的太晚……")
								script_say("马大元：若不是你相助……我怕早已是命丧黄泉……你不必太自责……")
								script_say("主角：马帮主，究竟是何人欲下此毒手？")
								script_say("马大元：我也不知道……我自问不曾与人结下如此深仇大恨……而且，以他的武功……即使有仇，也不必等到如今才动手啊……")
								script_say("主角：武功？对了！我观那人并不年迈，而且……而且使得是马帮主您的……难不成是那以彼之道还施彼身的姑苏慕容？")
								script_say("马大元：不……那人的身形我看着眼熟……想来也是我识得之人……不然……他也不必……做如此打扮……")
								script_say("主角：难道会是帮中某人所为？")
								script_say("马大元：我不行了……一身修为就此随我而去未免可惜……你救我有恩……我便在临死前将这恩情还了……也好走的了无牵挂……")
								DrawStrBoxWaitKey("马大元传授内力给"..JY.Person[0]["姓名"]);
								local add,str=AddPersonAttrib(0,"经验",8000);
								DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
								War_AddPersonLevel(0);
								local add,str=AddPersonAttrib(0,"修炼点数",8000);
								DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str,C_ORANGE,CC.Fontbig);
								local kflist=	{
													{169,10},
												};
								LearnKF(0,262,kflist);
								script_say("马大元：……")
								script_say("主角：马帮主！马帮主！可恶的神秘人！")
								Dark()
									SetS(JY.SubScene,x1,y1,1,0);
								Light()
								DrawStrBoxWaitKey("马大元死亡");
							else
								SetFlag(19001,2)
								script_say("马大元：啊……")
								script_say("神秘人：哼！")
								Dark()
									SetS(JY.SubScene,x2,y2,1,0);
								Light()
								DrawStrBoxWaitKey("神秘人消失");
								script_say("主角：马帮主！马帮主！可恶的神秘人！")
								Dark()
									SetS(JY.SubScene,x1,y1,1,0);
								Light()
								DrawStrBoxWaitKey("马大元死亡");
							end
						else
							SetFlag(19001,2)
							script_say("主角：（咦？那不是丐帮的马副帮主么？怎么会在这与人交手？）")
							script_say("马大元：啊……")
							Dark()
								SetS(JY.SubScene,x1,y1,1,0);
							Light()
							script_say("神秘人：哼！")
							Dark()
								SetS(JY.SubScene,x2,y2,1,0);
							Light()
							script_say("主角：（丐帮马副帮主被神秘人物用其绝学所杀，这下江湖又要乱了啊……）")
						end
						JY.Person[262]["登场"]=0;
						JY.Person[262]["所在"]=-1;
						JY.Person[263]["姓名"]='白世镜';
						JY.Person[263]["外号"]='执法长老';
						JY.Person[263]["头像代号"]=1549;
						JY.Person[263]["战斗动作"]=137;
						JY.Person[263]["攻击"]=JY.Person[263]["攻击"]-30;
						JY.Person[263]["防御"]=JY.Person[263]["防御"]-30;
						JY.Person[263]["身法"]=JY.Person[263]["身法"]-30;
					end,
				
			};
	SE[52]={
				kind="会面",
				trigger=function()
							if GetFlag(19001)~=0 and GetFlag(19002)==0 and JY.Da==261 and JY.Person[0]["门派"]==9 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(19002,1);
						local i=GetFlag(19001);
						if i==1 then
							script_say("主角：帮主！帮主你一定要为马帮主报仇啊！")
							script_say("萧峰：马大哥出事了？你快快说来！")
							script_say("主角：是！帮主，我前日偶遇马帮主，却发现他正与一神秘人物打斗。马帮主不敌，我便上前帮马帮主对敌，总算是降其打跑，可是马帮主他……他伤势太重……在传完我[浑天气功]之后……便……便……")
							script_say("萧峰：啊！马大哥！是谁！究竟是谁杀了马大哥！快说！")
							script_say("主角：帮主，那人蒙着面，使得却是马帮主的绝学，无法辨认究竟是何人。我曾猜测是以彼之道还施彼身的姑苏慕容，但是马帮主临终前却告诉我说此人背影看着眼熟，许是他相识之人。")
							script_say("萧峰：马大哥！我乔峰发誓，定会查明真凶，手刃此人，以慰你在天之灵！")
							script_say("主角：帮主！请让属下也随您一同，为马帮主报仇！")
							script_say("萧峰：你有此心，那再好不过了。不过你目前武力不足，马大哥既然已传你[浑天气功]，你便勤加修炼，有什么不懂的，可以来问我。")
							script_say("主角：多谢帮主指点！")
						elseif i==2 then
							script_say("主角：帮主！帮主你一定要为马帮主报仇啊！")
							script_say("萧峰：马大哥出事了？你快快说来！")
							script_say("主角：是我没用……我前日偶遇马帮主，却发现他正在与一神秘人物打斗。马帮主不敌，我便上前帮马帮主对敌。可那人武功太高，马帮主他……马帮主被他……")
							script_say("萧峰：啊！马大哥！是谁！究竟是谁杀了马大哥！快说！")
							script_say("主角：那人蒙着面，我无法辨认究竟是何人，但是……但是他所使的，却是马帮主的绝学……莫不会是那以彼之道还施彼身的……")
							script_say("萧峰：姑苏慕容？我们丐帮与他无冤无仇，我也不曾听说马大哥曾得罪于他，他不至于下此毒手啊。此事看来有些蹊跷，需小心查证。若真是他，我必手刃其以慰马大哥他在天之灵。")
							script_say("主角：帮主！届时请让属下也随您一同，为马帮主报仇！")
							script_say("萧峰：你有此心，那再好不过了。不过你目前武力不足，还需勤加修炼才是。")
							script_say("主角：是！帮主！")
						elseif i==3 then
							script_say("主角：帮主！不好了，帮主！")
							script_say("萧峰：有什么事？")
							script_say("主角：属下听闻，马帮主他……他被人害了！")
							script_say("萧峰：啊！这究竟是怎么回事？快说！")
							script_say("主角：江湖传言会说，说马帮主他被人用他自己的绝学所杀。帮主，您一定要为马帮主报仇啊帮主！")
							script_say("萧峰：马大哥！是谁！究竟是谁！")
							script_say("主角：帮主，江湖传言马帮主死于自己的绝学之下，江湖上有此身手，又有此能力的，属下思极只那以彼之道还施彼身的姑苏慕容方能做到。")
							script_say("萧峰：慕容复？我丐帮与他无冤无仇，我也不曾听说马大哥曾得罪于他，他不至于下此毒手啊。此事看来有些蹊跷，需小心查证。你等在江湖上行走的时间较多，多打听打听慕容复其人，若真是他，我必手刃其以为马大哥他在天之灵。")
							script_say("主角：是！帮主！")
						else
							say("貌似出现Ｂｕｇ了，正常时不可能见到这句对话的");
						end
					end,
			};
	SE[53]={
				kind="会面",
				trigger=function()
							if GetFlag(19002)~=0 and GetFlag(19003)==0 and JY.Da==261 and JY.Person[0]["门派"]==9 and GetD(JY.SubScene,JY.CurrentD,2)==1002 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(19003,1);
						local x,y=GetD(JY.SubScene,JY.CurrentD,9),GetD(JY.SubScene,JY.CurrentD,10);
						local d;
						for i=-1,1,2 do
							for j=-1,1,2 do
								d=GetS(JY.SubScene,x+i,y+i,3);
								if d>=0 then
									if GetD(JY.SubScene,d,2)==1002 then
										SetD(JY.SubScene,d,0,0);
										SetD(JY.SubScene,d,3,-1);
										SetD(JY.SubScene,d,5,0);
										SetD(JY.SubScene,d,6,0);
										SetD(JY.SubScene,d,7,0);
										break;
									end
									d=-1;
								end
							end
						end
						script_say("主角：属下参见帮主！")
						script_say("萧峰：哦？难得在这遇到你，来，陪我喝酒。")
						script_say("主角：那属下就恭敬不如从命了。")
						Dark();
						Light();
						DrawStrBoxWaitKey("与萧峰共饮")
						script_say("萧峰：哈哈哈！好！痛快！不愧是我丐帮兄弟！")
						script_say("主角：还是比不过帮主海量。")
						Dark();
							for i=1,199 do
								if GetD(JY.SubScene,i,3)==196 then
									SetD(JY.SubScene,i,0,0);
									SetD(JY.SubScene,i,3,-1);
									SetD(JY.SubScene,i,5,0);
									SetD(JY.SubScene,i,6,0);
									SetD(JY.SubScene,i,7,0);
									break;
								end
							end
							if d>=0 then
								local id=196;
								SetD(JY.SubScene,d,0,1);
								SetD(JY.SubScene,d,3,id);
								SetD(JY.SubScene,d,5,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
								SetD(JY.SubScene,d,6,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
								SetD(JY.SubScene,d,7,2*(10000+JY.Person[id]["战斗动作"]*4+GetD(JY.SubScene,v,8)));
							end
						Light();
						script_say("段誉：这位可是顶顶大名的“北乔峰”——乔帮主？")
						script_say("萧峰：在下正是，不知这位小兄弟是……")
						script_say("段誉：在下大理段誉。久闻乔帮主大名，今日得见，果然英雄豪气，心里难耐，故厚颜前来讨一杯水酒。")
						script_say("萧峰：哈哈哈！那有何不可，小二，给这位小兄弟拿个碗来。")
						script_say("段誉：多谢乔帮主！")
						DrawStrBoxWaitKey("三人斗酒一番")
						script_say("主角：帮主……我不行了……")
						script_say("萧峰：哈哈哈！你可不行哦，还没有这位小兄弟能喝。")
						script_say("主角：这位小兄弟竟然能与帮主共饮如此多碗，在下真是自愧不如啊。")
						script_say("段誉：好叫两位看了笑话，其实小弟这酒量，是作弊得来的。")
						script_say("萧峰：哦？乔某行走江湖多年，却不知这酒量也能作弊？")
						script_say("段誉：说来惭愧，小弟出身大理段氏，练过一阳指。刚刚喝酒之时，便是以一阳指将酒水逼出，因此才能与乔帮主对饮这么久。")
						script_say("萧峰：哈哈哈！久闻大理一阳指乃天下一绝，没想到居然还有如此妙用。小兄弟你能坦诚相告，足矣证明你是一片赤子之心啊。")
						script_say("段誉：乔帮主能不怪罪小弟，有这等胸襟，不愧是天下一等一的大英雄。")
						script_say("萧峰：小兄弟，你我一见如故，不如今日就结为异姓兄弟如何？")
						script_say("段誉：难得乔帮主不嫌弃，莫敢不从。")
						script_say("萧峰：哈哈哈！好！")
						DrawStrBoxWaitKey("两人三拜")
						script_say("萧峰：我乔峰，今日与段誉结为异姓兄弟，今后有福同享，有难同当。")
						script_say("段誉：我段誉，今日与乔峰结为异姓兄弟，今后有福同享，有难同当。")
						script_say("萧峰：哈哈哈！二弟！")
						script_say("段誉：大哥！")
						script_say("主角：恭喜帮主，恭喜段兄弟。")
						Dark();
						Light();
						script_say("丐帮弟子：帮主。时间已经到了。")
						script_say("萧峰：嗯。二弟，我丐帮还有帮务需要处理，就不陪你了。")
						script_say("段誉：大哥，不知我是否方便一同前去呢？")
						script_say("萧峰：哈哈哈，那有何不可。离此地也不远，就在附近的杏子林。我们走吧。")
					end,
			};
	SE[54]={
				kind="进入",
				trigger=function()
							if GetFlag(19003)==0 and GetFlag(19004)==0 and JY.SubScene==131 then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(19004,1);
						local cx,cy=22,22;
						local function set(t)
							local x,y=t[1],t[2];
							if GetS(JY.SubScene,x,y,1)>0 then
								SetS(JY.SubScene,x,y,1,0);
							else
								SetS(JY.SubScene,x,y,1,2*(GetNPCPic(JY.Name[t[3]])+t[4]));
							end
						end
						local function clean(t)
							local x,y=t[1],t[2];
							if GetS(JY.SubScene,x,y,1)>0 then
								SetS(JY.SubScene,x,y,1,0);
							end
						end
						local s1=	{
										{22,22,"萧峰",1},
									};	--萧峰
						local s2=	{
										{25,21,"丐帮弟子",2},
										{25,22,"丐帮弟子",2},
										{25,23,"丐帮弟子",2},
										{25,19,"段誉",2},--段誉
									};	--丐帮弟子
						local s3=	{
										{21,19,"包不同",3},
										{22,19,"王语嫣",3},
										{23,18,"阿朱",3},
										{21,18,"阿碧",3},
										{20,19,"风波恶",3},
									};
						local s4=	{
										{22,25,"全冠清",0},
										{20,26,"宋清溪",0},
										{21,26,"奚山河",0},
										{23,26,"陈孤雁",0},
										{24,26,"吴长风",0},
										{18,27,"丐帮弟子",0},
										{19,28,"丐帮弟子",0},
										{20,28,"丐帮弟子",0},
										{21,28,"丐帮弟子",0},
										{22,28,"丐帮弟子",0},
										{23,28,"丐帮弟子",0},
										{24,28,"丐帮弟子",0},
										{25,28,"丐帮弟子",0},
										{18,29,"丐帮弟子",0},
										{20,29,"丐帮弟子",0},
										{22,29,"丐帮弟子",0},
										{24,29,"丐帮弟子",0},
										{19,30,"丐帮弟子",0},
										{21,30,"丐帮弟子",0},
										{23,30,"丐帮弟子",0},
									};
										--
						local s5=	{
										{23,24,"白世镜",3},
										{26,19,"吴六奇",2},
										{27,20,"丐帮弟子",2},
										{27,21,"丐帮弟子",2},
										{27,22,"丐帮弟子",2},
										{27,23,"丐帮弟子",2},
										{27,24,"丐帮弟子",2},
										{27,25,"丐帮弟子",2},
										{27,26,"丐帮弟子",2},
										{28,22,"丐帮弟子",2},
										{28,24,"丐帮弟子",2},
										{28,26,"丐帮弟子",2},
										{29,21,"丐帮弟子",2},
										{29,23,"丐帮弟子",2},
										{29,25,"丐帮弟子",2},
									};
						local s6=	{
										{21,25,"徐长老",0},
										{19,23,"马夫人",1},
										{19,22,"谭公",1},
										{19,21,"谭婆",1},
										{19,20,"赵钱孙",1},
										{18,25,"单伯山",1},
										{18,23,"单仲山",1},
										{17,26,"单叔山",1},
										{17,24,"单季山",1},
										{17,22,"单小山",1},
										{19,24,"单正",1},
										{20,24,"智光",0},
									};
						Dark();
							set(s1[1]);
							for i,v in pairs(s2) do
								set(v);
							end
						Light();
						script_say("主角：乔帮主好快的脚程！");
						SmartWalk(cx+3,cx+2,2);
						script_say("丐帮弟子众：参见帮主！")
						script_say("萧峰：弟兄们好！")
						Dark();
							for i=1,4 do
								set(s3[i])
							end
						Light();
						script_say("包不同：你可是丐帮帮主？")
						script_say("萧峰：在下正是。阁下一行可是姑苏慕容氏？？")
						script_say("包不同：非也非也。包不同只是公子家仆，又不姓慕容，又没有嫁人，自然不是姑苏慕容氏。")
						script_say("萧峰：原来是包三先生，久仰英明。")
						script_say("包不同：非也非也。江湖人人皆知，包不同没有什么英明，只有一张臭嘴，出口便伤人。乔帮主，你随随便便来到江南，便是你的不是了。")
						script_say("萧峰：哦？倒要请教如何是在下的不是了。")
						script_say("包不同：我家公子听闻乔帮主是个人物，丐帮也有不少才俊，特前往洛阳拜会阁下，乔帮主却自得其乐的来到了江南。嘿嘿，岂有此理，岂有此理啊？")
						script_say("萧峰：慕容公子驾临洛阳敝帮，乔某若是事先得知，必当恭迎大驾。失迎之罪，先行谢了。")
						script_say("包不同：这是失迎之罪，确实要谢过，虽然常言道得好：不知者不罪。但是到底要罚要打，全在别人啊")
						DrawStrBoxWaitKey("远处传来几声大笑");
						script_say("陈孤雁：久闻包不同说话有如狗屁，果然名不虚传。")
						Dark();
							for i,v in pairs(s4) do
								set(v);
							end
							set(s4[1]);
						Light();
						script_say("包不同：俗话说，响屁不臭，臭屁不响，这又臭又响的，莫不是丐帮六长老所放？")
						script_say("陈孤雁：既然知道我丐帮六长老威名，包不同为何还在这胡言乱语呢？")
						script_say("包不同：四个老儿可是要跟包不同打上一场？还有两个老儿怎么不见了？难不成是准备暗算包不同么？好啊，很好。包不同最爱打架了。")
						script_say("风波恶：世间最爱打架的是谁？是包三先生吗？错了错了，是江南一阵风风波恶！")
						Dark();
							set(s3[5]);
						Light();
						script_say("阿碧：风四哥，可是有公子的消息了？")
						script_say("风波恶：公子的消息等下再说，风波恶要先打上一架，看打！")
						script_say("陈孤雁：怕了你不成！")
						script_say("萧峰：统统住手！")
						script_say("风波恶：……竟然一招就分开我们四人……罢了罢了，打不过，不在这丢人了。")
						Dark();
							set(s3[5]);
						Light();
						script_say("包不同：走吧走吧，技不如人兮，脸上无光！再练十年兮，又输精光！不如罢休兮，吃尽当光！")
						Dark();
							set(s3[1]);
						Light();
						script_say("萧峰：几位，请了。")
						script_say("全冠清：且慢！")
						Dark();
							set(s4[1]);
						Light();
						script_say("全冠清：启禀帮主，马副帮主惨死的大仇尚未得报，帮主岂能随随便便放走敌人？")
						script_say("段誉：（这人虽称大哥帮主，但是言语咄咄逼人，好生无礼。）")
						script_say("萧峰：咱们到江南来，原是为报马大哥的大仇而来。但这几日来我多方查察，觉得杀害马大哥的凶手，未必便是慕容公子。")
						script_say("全冠清：帮主何所见而云然？")
						script_say("萧峰：当日听闻马大哥死于自己的绝学「锁喉擒拿手」，便即想起了姑苏慕容氏的以彼之道还施彼身。马大哥的「擒拿锁喉手」天下无双无对，除了慕容氏，再无旁人能以此技伤他。")
						script_say("全冠清：不错。")
						script_say("萧峰：但近日来，我越来越觉得，我们先前的想法只怕未必尽然。")
						script_say("全冠清：众兄弟都愿闻其详，请帮主开导。")
						script_say("萧峰：（此人辞意不善，众兄弟神奇大异平常，怕是帮中已生重大变故。）")
						script_say("萧峰：传功、执法两位长老呢？")
						script_say("全冠清：属下今日并没见到两位长老。")
						script_say("萧峰：大仁、大信、大勇、大礼四舵的舵主又在何处？四位长老，究竟出了何事？")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=22,24,3;
							set(s1[1]);
						Light();
						DrawStrBoxWaitKey("说话间，萧峰已将全冠清拿下");
						script_say("萧峰：你既已知罪，那便跪下受罚吧。来人，去把传功、执法以及四位舵主“请”来。")
						script_say("丐帮弟子：是！")
						DrawStrBoxWaitKey("远处传来一阵怒喊");
						script_say("白世镜：四位长老，你们将我等关于船上究竟是为何？")
						Dark();
							for i,v in pairs(s5) do
								set(v);
							end
						Light();
						script_say("吴长风：……咱们身为丐帮弟子，须当遵守祖宗遗法。大丈夫行事，对就是对，错就是错，敢作敢为，也敢担当。乔帮主，我们大伙儿商量了，要废去你的帮主之位。这件大事，宋奚陈吴四长老都是参与的。我们怕传功执法两位长老不允，是以设法将他们囚禁起来。这是为了本帮的大业着想，不得不冒险而为。今日势头不利，被你占了上风，我们由你处置便是。吴长老在丐帮三十年，谁都知道我不是贪生怕死的小人。")
						script_say("白世镜：宋奚陈吴四长老背叛帮主，违犯帮规第一条。我即为执法长老，自当秉公执法。执法弟子，将四长老绑上了。")
						script_say("执法弟子：是！")
						script_say("白世镜：众位兄弟，乔帮主继任上代汪帮主为本帮帮主，并非巧取豪夺，用什么不正当手段而得此位。当年汪帮主试了他三大难题，命他为本帮立七大功劳，这才以打狗棒相授。那一年泰山大会，本帮受人围攻，处境十分凶险，全仗乔帮主连创九名强敌，丐帮这才转危为安，这里许多兄弟都是亲眼得见。这八年来本帮声誉日隆，人人均知是乔帮主主持之功。乔帮主待人仁义，处事么允，咱们大伙儿拥戴尚自不及，为什么居然有人猪油蒙了心，意会起意叛乱？全冠清，你当众说出来！")
						script_say("萧峰：全舵主，我乔峰做了什么对不起众兄弟这事，你尽管当面指证，不必害怕，不用顾忌。")
						DrawStrBoxWaitKey("萧峰解开全冠清穴道");
						script_say("全冠清：对不起众兄弟的大事，你现今虽然还没有做，但不久就要做了。")
						script_say("白世镜：胡说八道！乔帮主为人处事，光明磊落，他从前既没做过歹事，将来更加不会做。你只凭一些全无佐证的无稽之言，便煽动人心，意图背叛帮主。老实说，这些谣言也曾传进我的耳里，我只当他是大放狗屁，老子一拳头便将放屁之人打断了三条肋骨。偏有这么些胡涂透顶的家伙，听信了你的胡说八道，你说来说去，也不过是这么几句话，快快自行了断吧。")
						script_say("萧峰：白长老，你不用性急，让全舵主从头至尾，详详细细说个明白。连宋长老、奚长老他们也都反对我，想必我乔峰定有不对之处。")
						script_say("奚山河：我反叛你，是我不对，你不用再提。回头定案之后，我自行把矮脖子上的大头割下来给你便是。")
						script_say("白世镜：帮主吩咐的是。全冠清，你说吧。")
						script_say("全冠清：马副帮主为人所害，我相信是出于乔峰的指使。")
						script_say("萧峰：不是。我和马副帮主交情虽不甚深，言谈虽不甚投机，但从来没存过害他的念头。皇天后土，实所共鉴。乔峰若有加害马大元之意，教我身败名裂，受千刀之祸，为天下好汉所笑。")
						script_say("全冠清：然则咱们大伙到姑苏来找慕容复报仇，为什么你一而再、再而三的与敌人勾结？这三人是慕容复的家人眷属，你却加以庇护。")
						script_say("萧峰：我丐帮开帮数百年，在江湖上受人尊崇，并非恃了人多势众、武功高强，乃是由于行侠仗义、主持公道之故。全舵主，你责我庇护这三位年轻姑娘，不错，我确是庇护她们，那是因为我爱惜本帮数百年来的令名，不肯让天下英雄说一句‘丐帮众长老合力欺侮三个稚弱女子’。宋奚陈吴四长老，那一位不是名重武林的前辈？丐帮和四位长老的名声，你不爱惜，帮中众兄弟可都爱惜。")
						script_say("白世镜：全冠清，你还有什么话说？帮主，这等不识大体的叛徒，不必跟他多费唇舌，按照叛逆犯上的帮规处刑便了。")
						script_say("萧峰：全舵主能说得动这许多人密谋作乱，必有极重大的原因。大丈夫行事，对就是对，错就是错。众位兄弟，乔峰的所作所为，有何不对，请大家明言便是。")
						script_say("吴长风：帮主，你或者是个装腔作势的大奸雄，或者是个直肠直肚的好汉子，我吴长风没本事分辨，你还是及早将我杀了吧。")
						script_say("萧峰：吴长老，你为什么说我是个欺人的骗子？你……你……什么地方疑心我？")
						script_say("吴长风：这件事说起来牵连太多，传了出去，丐帮在江湖上再也抬不起头来，人人要瞧我们不起。我们本来想将你一刀杀死，那就完了。")
						script_say("萧峰：为什么？为什么？我救了慕容复手下的两员大将，你们就疑心我和他有所勾结，是不是？可是你们谋叛在先，我救人在后，这两件事拉不上干系。再说，此事是对是错，这时候还难下断语，但我总觉得马副帮主不是慕容复所害。")
						script_say("全冠清：何以见得？")
						script_say("萧峰：这两个月来，江湖上被害的高手着实不少，都是死于各人本身的成名绝技之下。人人皆道是姑苏慕容氏所下毒手。可是有人可曾想过，两个月的时间他慕容复一人，轻功再高，也不可能于这么多处之间往返奔波啊。")
						script_say("吴长风：这……帮主，咱们所以叛你，皆因误信人言，只道你与马副帮主不和，暗里勾结姑苏慕容氏下手害他。种种小事凑在一起，竟不由得人不信。现下一想，咱们实在太过胡涂。白长老，你请法刀来，依照帮规，咱们自行了断便是。")
						script_say("白世镜：执法弟子，请本帮法刀。")
						script_say("执法弟子：是！")
						script_say("执法弟子：法刀齐集，验明无误。")
						script_say("白世镜：本帮宋奚陈吴四长老误信人言，图谋叛乱，危害本帮大业，罪当一刀处死。大智分舵舵主全冠清，造遥惑众，鼓动内乱，罪当九刀处死。参与叛乱的各舵弟子，各领罪责，日后详加查究，分别处罚。")
						script_say("吴长风：帮主，吴长风对你不起，自行了断。盼你知我胡涂，我死之后，你原谅了吴长风。吴长风自行了断，执法弟子松绑。")
						script_say("执法弟子：是！")
						script_say("萧峰：且慢！")
						script_say("吴长风：帮主，我罪孽太大，你不许我自行了断？")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=20,25,3;
							set(s1[1]);
						Light();
						script_say("萧峰：十五年前，契丹国入侵雁门关，宋长老得知讯息，三日不，四晚不睡，星夜赶回，报知紧急军情，途中连毙九匹好马，他也累得身受内伤，口吐异血。终于我大宋守军有备，契丹胡骑不逞而退。这是有功于国的大事，江湖上英雄虽然不知内中详情，咱们丐帮却是知道的。执法长老，宋长老功劳甚大，盼你体察，许他将功赎罪。")
						script_say("白世镜：帮主代宋长老求情，所说本也有理。但本帮帮规有云：‘叛帮大罪，决不可赦赦，纵有大功，亦不能赎。以免自恃有功者骄横生事，危及本帮百代基业。’帮主，你的求情于帮规不合，咱们不能坏了历代帮主传下来的规矩。")
						script_say("宋清溪：执法长老的话半点也不错。咱们既然身居长老之位，哪一个不是有过不少汗马功劳？倘若人人追论旧功，那么什么罪行都可犯了。帮主，请你见怜，许我自行了断。")
						DrawStrBoxWaitKey("萧峰夺过法刀，插入自己左肩");
						script_say("段誉：大哥！")
						script_say("丐帮弟子：帮主！")
						script_say("萧峰：白长老，本帮帮规之中，有这么一条：‘本帮弟子犯规，不得轻赦，帮主却加宽容，亦须自流鲜血，以洗净其罪。’是也不是？")
						script_say("白世镜：帮规是有这么一条，但帮主自流鲜血，洗人之罪，亦须想想是否值得。")
						script_say("萧峰：只要不坏祖宗遗法，那就好了。");
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=21,25,3;
							set(s1[1]);
						Light();
						script_say("萧峰：奚长老当年指点我的武功，虽无师父之名，却有师父之实。这尚是私人的恩德。想当年汪帮主为契丹国五大高手设伏擒获，办于祈连山黑风洞中，威逼我丐帮向契丹降服。汪帮主身材矮胖，奚长老与之有三分相似，便乔装汪帮主的模样，甘愿代死，使汪帮主得以脱险。这是有功于国家和本帮的大事，本人非免他的罪名不可。")
						DrawStrBoxWaitKey("萧峰再取一刀，插入自己左肩");
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=23,25,3;
							set(s1[1]);
						Light();
						script_say("陈孤雁：乔帮主，我跟你没什么交情，平时得罪你的地方太多，不敢要你流血赎命。")
						script_say("萧峰：陈长老，我乔峰是个粗鲁汉子，不爱结交为人谨慎、事事把细的朋友，也不喜欢不爱喝酒、不肯多说多话、大笑大吵之人，这是我天生的性格，勉强不来。我和你性情不投，平时难得有好言好语。我也不喜马大哥的为人，见他到来，往往避开，宁可去和一袋二袋的低辈弟子喝烈酒、吃狗肉。我这脾气，大家都知道的。但如你以为我想除去你和马大哥，那可就大错而特错了。你和马大哥老成持重，从不醉酒，那是你们的好处，我乔峰及你们不上。刺杀契彤国左路副元帅耶律不鲁的大功劳，旁人不知，难道我也不知么？")
						DrawStrBoxWaitKey("萧峰再取一刀，插入自己左肩");
						script_say("丐帮弟子：当年此事竟是陈长老所为？")
						script_say("丐帮弟子：这可是天大的功劳啊，陈长老竟然直到今天都不言明？")
						script_say("陈孤雁：我陈孤雁名扬天下，深感帮主大恩大德。")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=24,25,3;
							set(s1[1]);
						Light();
						script_say("萧峰：吴长老，当年你独守鹰愁峡，力抗西夏‘一品堂’的高手，使其行刺杨家将的阴谋无法得逞。单凭杨元帅赠给你的那面‘记功金牌’，便可免了你今日之罪。你取出来给大家瞧瞧吧！")
						script_say("吴长风：我那面记功金牌嘛，不瞒帮主说，是……这个……那个……那一天我酒瘾大发，没钱买酒，把金牌卖了给金铺子啦。")
						script_say("萧峰：爽快，爽快，只是未免对不起杨元帅了。")
						DrawStrBoxWaitKey("萧峰再取一刀，插入自己左肩");
						script_say("吴长风：帮主，你大仁大义，吴长风这条性命，从此交了给你。人家说你这个那个，我再也不信了。")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=22,24,3;
							set(s1[1]);
						Light();
						script_say("萧峰：全舵主，你有什么话说？")
						script_say("全冠清：我所以反你，是为了大宋的江山，为了丐帮百代的基业，可惜跟我说了你身世真相之人，畏事怕死，不敢现身。你将我一刀杀死便是。姓乔的，痛痛快快，一刀将下杀了。免得我活在世上，眼看大九丐帮落入胡人手中，我大宋的锦绣江山，更将沦亡于夷狄。我这时说了，众兄弟谁也不信，还道我全冠清贪生怕死，乱嚼舌根。我早已拚着一死，何必死后再落骂名。")
						script_say("萧峰：全舵主，你说知道我身世真相，又说此事与本帮安危有关，到底直相如何，却又不敢吐实。你煽动叛乱，一死难免，只是今日暂且寄下，待真相大白之后，我再亲自杀你。乔峰并非一味婆婆妈妈的买好示惠之辈，既决心杀你，谅你也逃不出我的手掌。你去吧，解下背上布袋，自今而后，丐帮中没了你这号人物。")
						script_say("全冠清：……")
						DrawStrBoxWaitKey("突然路口出现一丐帮弟子");
						script_say("丐帮弟子：西夏……紧急……军情……")
						DrawStrBoxWaitKey("丐帮弟子身亡");
						Dark();
							set(s6[1]);
						Light();
						script_say("徐长老：乔峰，军情大事，你不能看。")
						script_say("白世镜：徐长老，何事大驾光临？")
						script_say("萧峰：徐长老安好。")
						script_say("徐长老：得罪！马大元马兄弟的遗孀马夫人即将到来，向诸位有请陈说，大伙儿请待她片刻如何？")
						script_say("萧峰：假若此事关连重大，大伙儿等候便是。")
						script_say("徐长老：此事关联重大。")
						DrawStrBoxWaitKey("等了许久");
						Dark();
							set(s6[2]);
							set(s6[3]);
							set(s6[4]);
							
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=22,22,2;
							set(s1[1]);
						Light();
						script_say("萧峰：太行山冲霄洞谭公、谭婆贤伉俪驾到，有失远迎，乔峰这里谢过。")
						Dark();
							set(s6[5]);
						Light();
						script_say("谭婆：师兄，你又来做什么？我打你的屁股！")
						script_say("谭公：我道是谁，原来是你。")
						script_say("赵钱孙：小娟，近来过得快活么？")
						Dark();
							set(s6[6]);
							set(s6[7]);
							set(s6[8]);
							set(s6[9]);
							set(s6[10]);
						Light();
						script_say("吴长风：泰山五雄到了，好极，好极！什么风把你们哥儿五个都吹来了？")
						script_say("单叔山：吴四叔，爹爹也来了。")
						Dark();
							set(s6[11]);
						Light();
						script_say("单正：乔帮主，单正不请自来，打扰了。")
						script_say("萧峰：若知单老前辈大驾光临，早该远迎才是。")
						script_say("赵钱孙：好哇！铁面判官到来，就该远迎。我‘铁屁股判官’到来，你就不该远迎了。")
						script_say("单正：请马夫人出来叙话。")
						script_say("马夫人：未亡人马门温氏，参见帮主。")
						script_say("萧峰：嫂嫂，有礼！")
						script_say("马夫人：先夫不幸亡故，多承帮主及众位伯伯叔叔照料丧事，未亡人衷心铭感。")
						script_say("萧峰：一日之间，能会见众位前辈高人，是不胜荣幸之至。不知众位驾到，有何见教？")
						script_say("单正：乔帮主，贵帮是江湖上第一大帮，数百年来侠名播于天下，武林中提起‘丐帮’二字，谁都十分敬重，我单某向来也是极为心仪的。")
						script_say("萧峰：不敢！")
						script_say("徐长老：泰山单兄父子，太行山谭氏夫妇，以及这位兄台，今日惠然驾临，敝帮全帮上下均感光宠。马夫人，你来从头说起罢。")
						script_say("马夫人：先夫不幸身故，小女子只有自怨命苦，更悲先夫并未遗下一男半女，接续马氏香烟……小女子殓葬先夫之后，检点遗物，在他收藏拳经之处，见到一封用火漆密密封固的书信。封皮上写道：‘余若寿终正寝，此信立即焚化，拆视者即为毁余遗体，令余九泉不安。余若死于非命，此信立即交本帮诸长老会同拆阅，事关重大，不得有误。’我见先夫写得郑重，知道事关重大，当即便要去求见帮主，呈这遗书，幸好帮主率同诸位长老，到江南为先夫报仇来了，亏得如此，这才没能见到此信。我知此信涉及帮中大事，帮主和诸长老既然不在洛阳，我生怕耽误时机，当即赴郑州求见徐长老，呈上书信，请他老人家作主。以后的事情，请徐长老告知各位。")
						script_say("徐长老：此事说来恩恩怨怨，老叫花真好生为难。这封便是马大元的遗书。大元的曾祖、祖父、父亲，数代都是丐帮中人，不是长老，便是八袋弟子。我眼见大元自幼长大，他的笔迹我是认得很清楚的。这信封上的字，确是大元所写。马夫人将信交到我手中之时，信上的火漆仍然封固完好，无人动过。我也担心误了大事，不等会同诸位长老，便即拆来看了。拆信之时，太行山铁面判官单兄也正在座，可作明证。")
						script_say("单正：不错，其时在下正在郑州徐老府上作客，亲眼见到他拆阅这封书信。")
						script_say("徐长老：我一看这张信笺，见信上字迹笔致遒劲，并不是大元所写，微感惊奇，见上款写的是‘剑髯吾兄’四字，更是奇怪。众位都知道，‘剑髯’两字，是本帮前任汪帮主的别号，若不是跟他交厚相好之人，不会如此称呼，而汪帮主逝世已久，怎么有人写信与他？我不看笺上所写何字，先看信尾署名之人，一看之下，更是诧异。当时我不禁‘咦’的一声，说道：‘原来是他！’单兄好奇心起，探头过来一看，也奇道：‘咦！原来是他！’众位兄弟，到底写这封信的人是谁，我此刻不便言明。徐某在丐帮七十余年，近三十年来退隐山林，不再闯荡江湖，与人无争，不结怨仇。我在世上已为日无多，既无子孙，又无徒弟，自问绝无半分私心。我说几句话，众位信是不信？")
						script_say("丐帮弟子：徐长老的话，有谁不信？")
						script_say("徐长老：帮主意下如何？")
						script_say("萧峰：乔某对徐长老素来敬重，前辈深知。")
						script_say("徐长老：我看了此信之后，思索良久，心下疑惑难明，唯恐有甚差错，当即将此信交于单兄过目。单兄和写信之人向来交好，认得他的笔迹。此事关涉太大，我要单兄验明此信的真伪。单兄，请你向大伙儿说说，此信是真是伪。")
						script_say("单正：在下和写信之人多年相交，舍下并藏有此人书信多封，当即和徐长老、马夫人一同赶到舍下，检出旧信对比，字迹固然相同，连信笺信封也是一般，那自是真迹无疑。")
						script_say("徐长老：老朽多活了几年，做事万求仔细，何况此事牵涉本帮兴衰气运，有关一位英雄豪杰的声名性命，如何可以冒昧从事？老朽得知太行山谭氏伉俪和写信之人颇有渊源，于是去冲霄洞向谭氏伉俪请教。谭公、谭婆将这中间的一切原委曲折，一一向在下说明，唉，在下实是不忍明言，可怜可惜，可悲可叹！谭婆说道，她有一位师兄，于此事乃是身经目击，如请他亲口述说，最是明白不过，她这位师兄，便是赵钱孙先生了。这位先生的脾气和别人略有不同，等闲请他不到。总算谭婆的面子极大，片笺飞去，这位先生便应召而到……")
						script_say("谭公：怎么？是你去叫他来的么？怎地事先不跟我说，瞒着我偷偷摸摸？")
						script_say("谭婆：么瞒着你偷偷摸摸？我写了信，要徐长老遣人送去，乃是光明正大之事。就是你爱喝干醋，我怕你唠叨哆唆，宁可不跟你说。")
						script_say("谭公：背夫行事，不守妇道，那就不该！")
						DrawStrBoxWaitKey("谭婆打了谭公一个耳光");
						script_say("徐长老：赵钱孙先生，请你当众说一句，这信中所写之事，是否不假。")
						script_say("谭婆：师哥，徐长老问你，当年在雁门关外，乱石谷前那一场血战，你是亲身参预的，当时情形若何，你跟大伙儿说说。")
						script_say("赵钱孙：雁门关……雁门关……啊！！！")
						script_say("智光：阿弥陀佛。")
						Dark();
							set(s6[12]);
							
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=22,22,3;
							set(s1[1]);
						Light();
						script_say("徐长老：台山知光大师到了，三十余年不见，大师仍然这等清健。智光大师德泽广初，无人不敬。但近十余年来早已不问江湖上事务。今日佛驾光降，实是丐帮之福。在下感激不尽。")
						script_say("智光：丐帮徐长老和太行山单判官联名折柬相召，老衲怎敢不来？天台山与无锡相距不远，两位信中又道，此事有关天下苍生气运，自当奉召。")
						script_say("赵钱孙：雁门关外乱石谷前的大战，智光和尚也是有份的，你来说吧。")
						script_say("智光：好，老衲从前做错了的事，也不必隐瞒，错便错了，又何必自欺欺人？三十年前，中原豪杰接到讯息，说契丹国有大批武士要来偷袭少林寺，想将寺中秘藏数百年的武功图谱，一举夺去。这件事当真非同小可，要是契丹此举成功，大宋便有亡国之祸，我黄帝子孙说不定就此灭种，尽数死于辽兵的长矛利刀之下，我们以事在紧急，不及详加计议，听说这些契丹武士要道经雁门，一面派人通知少林寺严加戒备，各人立即兼程赶去，要在雁门关外迎击，纵不能尽数将之歼灭，也要令他们的奸谋难以得逞。乔帮主，倘若你得知了这项讯息，那便如何？")
						script_say("萧峰：智光大师，乔某见识浅陋，才德不足以服众，致令帮中兄弟见疑，说来好生惭愧。但乔某纵然无能，却也是个有肝胆、有骨气的男儿汉，于这大节大义份上决不致不明是非。我大宋受辽狗欺凌，家国之仇，谁不思报？倘若得知了这项讯息，自当率同本帮弟兄，星夜赶去阻截。")
						script_say("智光：如此说来，我们前赴雁门关外伏击辽人之举，以乔帮主看来，是不错的？")
						script_say("萧峰：诸位前辈英风侠烈，乔某敬仰得紧，恨不早生三十年，得以追随先贤，共赴义举手刃胡虏。")
						script_say("智光：过得雁门关时，已将近黄昏。我们出关行了十余里，一路小心戒备，突然之间，西北角上传来马匹奔跑之声，听声音至少也有十来骑。带头大哥高举右手，大伙儿便停了下来。各人心中又是欢喜，又是担优，没一人说一句话。欢喜的是，消息果然为假，幸好我们毫不耽搁的赶到，终于能及时拦阻。但人人均知来袭的契丹武士定是十分厉害之辈，善者不来，来者不善，既敢向中土武学的泰山北斗少林寺挑衅，自然人人是契丹千中挑、万中选的勇士。大宋和契丹打仗，向来败多胜少，今日之战能否得胜，实在难说之极。乔帮主，此事成败，关连到大宋国运，中土千千万万百姓的生死，而我们却又确无制胜把握。唯一的便宜，只不过是敌在明处而我在暗里，你想我们该当如何才是？")
						script_say("萧峰：自来兵不厌诈。这等两国交兵，不能讲什么江湖道义、武林规矩。辽狗杀戮我大宋百姓之时，又何尝手下容情了？依在下之见，当用暗器。暗器之上，须喂剧毒。")
						script_say("智光：正是。乔帮主之见，恰与我们当时所想一模一样。我们用喂毒的暗器杀光了那十七人，正在奇怪他们的反抗如此之弱时，远处又来了两人。我们以为先前这十七人乃是诱饵，后面这两人方是正主，于是便一拥而上。这两人为一对男女，男的武功之高，足足缠住了我们有七八人之多。可是那女子却是全然不懂武学，有一人只一剑便将她手斩下，此时，我们才发现她怀中尚抱着一个婴孩也随着那一下跌落地上。我们觉得事情有些不对，可全都杀红了眼，那女子便被杀了。那男的见女子惨死，痛呼一声，却是一发狠将众人一一击退点倒。我们只当他要将我们一一折磨致死，却没想到那男子在雁门关一巨石上刻下些许文字，便抱起女子的尸身和那婴孩转身跳入了悬崖。那时老衲乃被那男子掌风所袭，摔于一旁，却麻了半边身子，却也因此没被其点穴。待那男子跳崖之后，我便挣扎着想要过去查看，那知一阵风响，却是那个婴孩被那男子抛了上来，落在了汪帮主的身上，正在嚎啕大哭。我解开了众人的穴道，大家均觉得此事诡异，不似我们当初所想，有心想看那男子的遗言，却无人认识契丹文字，只得用血水将那碑文拓下来，找了几个识得契丹文的小贩翻译，最终得知了事情的真相。唉，那真相若确实如此，不但我们殉难的兄弟死得冤枉，那些契丹人也是无辜受累，那对夫妇我们更是万分的对他们不起啊。")
						script_say("萧峰：那真相究竟是何？")
						script_say("智光：非是老衲有意卖关子。但是若这石壁上所写确是实情，那么带头大哥、汪帮主和我等的所作所为，却是大错特错。我智光乃是无名小卒，算不得什么。但是带头大哥和汪帮主何等身份地位？何况汪帮主依然逝世，我再不该妄语，有损二位声名。")
						script_say("萧峰：这……既然如此，那在下便不再过问了。")
						script_say("智光：我们三人不愿相性事实如此，但又不得不信。当下决定寄下这婴孩的性命，先行到少林去查看动静。若是契丹武士果然大举来袭，再斩草除根也不迟。那次少林聚会，各路来援的英雄越来越多，然而三个月过去了，契丹那边却毫无半点警耗，而当初报讯之人却也消失无踪。我们这才料定，讯息是假，可这大错，已是铸成。我们对那契丹夫妇有愧，自是不能再伤他孩儿，但终究还是怕养虎贻患，于是，便在少室山脚寻了一户农家，请他们养育那婴孩，只是待其成长，切不可让其得知领养之事。那农人夫妇本无子息，自是欢喜的答应了。")
						script_say("萧峰：智光大师……那……那农人……他……他……他姓什么？")
						script_say("智光：你记忆猜到，我也不必隐瞒。那农人姓乔，名字叫作三槐。")
						script_say("萧峰：不！不！你胡说八道！我堂堂汉人，三槐公是我亲生爹爹！你胡说！")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=20,23,3;
							set(s1[1]);
						Light();
						DrawStrBoxWaitKey("萧峰一把抓住智光");
						script_say("徐长老：乔帮主！智光大师江湖上人人敬仰，你不得伤害他性命！")
						script_say("萧峰：我乔峰和你们无冤无仇，你们……你们要出去我帮主之位，那也罢了，我拱手让人便是。为何……为何要编造如此谎言来诬蔑于我？我……乔某到底做了什么坏事，你们如此苦苦逼我？")
						Dark();
							set(s1[1]);
							s1[1][1],s1[1][2],s1[1][4]=22,22,2;
							set(s1[1]);
						Light();
						script_say("赵钱孙：可笑可笑！汉人未必高人一等，契丹人也未必猪狗不如！明明是契丹人，却硬要冒充汉人，那有什么滋味？连自己的亲生父母也不肯认，枉自称什么男子汉大丈夫？")
						script_say("萧峰：你也说我是契丹人？")
						script_say("赵钱孙：我不知道。我知道当日雁门关一役，那契丹武士将我杀破了胆子，成为我多年的噩梦，而那人的相貌，与你有九成相似。")
						script_say("智光：当初，玄苦大师授命，寻你上山，教你武学，同时传你佛法，以期能磨去你契丹血脉之中的戾气。而后更是让你加入了丐帮，由汪帮主亲自教导。起初，汪帮主对你还是分提防。但后来见你为人慷慨豪迈，待人仁厚，为丐帮立下不少汗马功劳，更令丐帮上下一心。便有心立你为帮主，但因你是契丹人之故，便试你三大难题，立七大功劳之后，他才将打狗棒法相授。你出任丐帮帮主之后，我自江湖中得知，你行侠仗义，造福于民，处事公允，将丐帮整顿的好生兴旺，当之无愧天下第一帮，又听你数度坏了契丹人的奸谋，之前养虎贻患的想法，已是杞人忧天。这事本可永不必提起。今日却被抖了出来，这对丐帮，对乔帮主自身，都不是什么好事啊。")
						script_say("徐长老：乔帮主，这是汪帮主的手书，你当认得出他的笔迹。")
						script_say("书信：字谕丐帮马副帮主、传功长老、执法长老、暨诸长老：乔峰若有亲辽叛汉、助契丹而厌大宋之举者，全帮即行合力击杀，不得有误。下毒行刺，均无不可，下手者有功无罪。汪剑通亲笔。——大宋元丰六年五月初七日")
						script_say("徐长老：乔帮主休怪我们无礼。原本这手谕本只有马副帮主一人知晓。几年来帮主行事光明磊落，决计没有丝毫通辽叛宋的事情，这遗令本该是用不着的。直到马副帮主惨死，马夫人才寻到了这封书信。本来嘛，大家疑心马副帮主是姑苏慕容所害，若帮主能为大元兄弟报了此仇，帮主的身世来历，原无揭破必要。老朽思之再三，为大局着想，本想毁了这封书信，可是……一来马夫人痛切夫仇。二来乔帮主袒护胡人，所作所为，实已危及本帮……")
						script_say("萧峰：我袒护胡人？此事从何说起？")
						script_say("徐长老：‘慕容’两字，便是胡姓。慕容氏是鲜卑后裔，与契丹一般，同为胡虏夷狄。")
						script_say("萧峰：你们之所以反我，是因为知道我是契丹后裔，是也不是？")
						script_say("全冠清：没错。")
						script_say("马夫人：其实，还有一事。在我接到先夫噩耗之前的一日晚间，忽然有人摸到我家中偷盗。贼子用了下三滥的熏香，将我及两名婢奴熏倒，翻箱倒柜的搜去了十来两银子。次日我便接到噩耗，哪里还有心思去理会此事？只是后来发现这封书信，又在窗口墙脚之下拾到贼子遗留之物，心下惊慌，方知此事非同小可。请众位伯伯叔叔作主。")
						DrawStrBoxWaitKey("马夫人拿出一把扇子");
						script_say("徐长老：这……这是……")
						script_say("萧峰：徐长老，这把扇子是我的。")
						script_say("徐长老：汪帮主啊汪帮主……非我族类其心必异啊……")
						script_say("萧峰：乔某身世来历，惭愧得紧，我自己未能确知。但既有着许多前辈指正，乔某须当尽力查明真相。这丐帮帮主的职位，自当退位让贤。")
						DrawStrBoxWaitKey("萧峰交出打狗棒");
						script_say("宋清溪：乔帮主！我相信你！我不知道什么契丹人什么汉人，但是乔帮主这么多年以来的所作所为大家都看在眼里，乔帮主到底是怎么样的人，自己心里有数。不要受了小人的挑拨。")
						script_say("丐帮弟子：对！我们相信帮主！")
						script_say("全冠清：各位兄弟！我们都是大宋百姓，岂能听从一个契丹人的号令？乔峰的本事越大，大伙越是危险啊！")
						script_say("奚山河：你放屁！")
						script_say("丐帮弟子：我看你才是契丹走狗！一心想要赶走帮主！")
						script_say("萧峰：众兄弟停手，听我一言。这丐帮帮主，我是决计不当了。恩师汪帮主的笔迹，无人能造假。但是，丐帮乃是天下第一大帮，尚若自相残杀，岂不让人笑话？乔某临去时有一言奉告，若有谁以一拳一脚加于本帮兄弟身上，便是本帮莫大的罪人。")
						script_say("马夫人：那有人杀了本帮副帮主又当如何？")
						script_say("萧峰：杀人者抵命。马副帮主到底是谁所害，又是谁陷害乔某，终究会查个水落石出。马夫人，以乔某的身手，若要到你府上取什么事物，谅来不会空手而归，更不会失落什么随身饰物。别说只不过三两个女流之辈，便是皇宫内院，千军万马之中，乔某要取什么事物，也未必不能办到。青山不改，绿水长流，众位兄弟，咱们再见了。乔某是汉人也好，是契丹人也好，有生之年，决不伤一条汉人的性命，若违此誓，有如此刀。")
						DrawStrBoxWaitKey("萧峰夺过单正单刀，弹成两截");

						if true then--JY.Person[0]["门派"]==9 and JY.Person[261]["友好"]>=40 then
							script_say("主角：乔帮主......");
							if DrawStrBoxYesNo(-1,-1,"是否跟随萧峰离开丐帮") then
								SetFlag(19005,1);
							end
						end
						script_say("萧峰：乔峰去也。")
						JY.Person[261]["门派"]=0;
						script_say("丐帮弟子：帮主别走！")
						script_say("丐帮弟子：丐帮全仗你主持大局！")
						script_say("丐帮弟子：帮主快回来！")
						if GetFlag(19005)==1 then--【主角为丐帮弟子，与萧峰好感足够，选择跟随萧峰】
							script_say("主角：乔帮主，不管你是汉人还是契丹人，我都只认你一个。瞧瞧今天的丐帮，只因为一个还没有弄清的怀疑，便将往日帮主的所为全数抹去，甚至群起而攻之。我虽一匹夫，却也知耻。我耻于与他们称兄道弟。自今日起，我便不再是丐帮弟子了！乔帮主，天涯海角，你要走，我便跟你走，你要查身世，我便帮你查。")
							script_say("萧峰：好！没想到今时今日，还有兄弟能如此看得起乔某。你以后便是我乔峰的兄弟了。我们走。")
							JY.MyPic=0;
						end
						Dark();
							set(s1[1]);
						Light();
						script_say("吴六奇：什么狗屁第一大帮！就因为一封死人的书信，就把昔日乔帮主为丐帮立下的汗马功劳全部抹杀了。四位长老，乔帮主刚刚还用自己的血，洗清了你们的罪。看看你们现在的样子，你们配么？呸！这什么破丐帮弟子，我还不稀罕了！自今天起，我吴六奇再也不是丐帮中人！一群狼心狗肺的东西！呸！")
						JY.Person[289]["门派"]=0;
						script_say("徐长老：……今日就这么散了吧。改日再议重选帮主之事。")
						script_say("段誉：大哥……")
						Dark();
							for i,v in pairs(s2) do
								clean(v);
							end
							for i,v in pairs(s3) do
								clean(v);
							end
							for i,v in pairs(s4) do
								clean(v);
							end
							for i,v in pairs(s5) do
								clean(v);
							end
							for i,v in pairs(s6) do
								clean(v);
							end
						Light();
						if GetFlag(19005)==1 then--【萧峰带着主角离开，某处】
							Dark();
								JY.Base["人X1"],JY.Base["人Y1"]=59,59;
								JY.MyPic=GetMyPic();
								s1[1][1],s1[1][2],s1[1][4]=58,59,1;
								set(s1[1]);
							Light();
							script_say("萧峰：兄弟，乔某要去探查身世，少不得要得罪江湖上许多朋友。只是兄弟……")
							script_say("主角：帮主，我知道自己武功低微，你放心的去吧，我会一边苦练武功，一边在市井之中打听消息的。")
							script_say("萧峰：那就有劳兄弟了。这样吧，今日先传你两招防身吧。");
							local kflist={
											{162,10},
											{169,10},
											{171,10},
											{172,10},
										};
							LearnKF(0,261,kflist);
							script_say("萧峰：日后你我若有缘再聚，我再教你。还有，乔某已经不是帮主了，若不嫌弃，便称我一声大哥吧。")
							script_say("主角：嗯！大哥！")
							script_say("萧峰：哈哈哈！想不到今日乔某变成了受天下人所痛恨的契丹人，却仍能交到这么一位好兄弟，哈哈哈，老天待我不薄啊！兄弟，你好生练武，大哥去了。")
							--【萧峰消失】
							Dark();
								set(s1[1]);
							Light();
							script_say("主角：（大哥，我一定会帮你查明真相的！）")
							JY.Person[0]["门派"]=0;
							--【主角成为丐帮叛徒】
							--【事件结束】
						end
					end,
				
			};
	SE[55]={
				kind="会面",
				trigger=function()
							if GetFlag(19005)==1 and JY.Da==261 then
								if DrawStrBoxYesNo(-1,-1,"是否向萧峰请教武功") then
									return 1;
								else
									return 0;
								end
							end
							return 0;
						end,
				go=	function()
						script_say("主角：大哥！可算找到你了。")
						script_say("萧峰：哈哈，想不到在这碰到你了！")
						script_say("萧峰：最近在武学上可有什么疑难吗？")
						local kflist={
											{162,10},
											{169,10},
											{171,10},
											{172,10},
										};
						LearnKF(0,261,kflist);
						script_say("萧峰：小兄弟，有缘再见！")
					end,
			};
	SE[101]={
				kind="对话",
				trigger=function()
							if 	GetFlag(20001)==0 and
								JY.Person[0]["门派"]==-1 and
								JY.Person[JY.Da]["门派"]==10 and
								JY.Person[JY.Da]["友好"]>30 and 
								Rnd(4)==1 and 
								(JY.Person[JY.Da]["姓名"]=="慕容复" or
								JY.Person[JY.Da]["姓名"]=="包不同" or
								JY.Person[JY.Da]["姓名"]=="公冶乾" or
								JY.Person[JY.Da]["姓名"]=="风波恶" or
								JY.Person[JY.Da]["姓名"]=="邓百川") then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(20001,1)
						local name=JY.Person[JY.Da]["姓名"];
						script_say(name.."：小兄弟，我们一见如故，相交甚欢，你何不加入我们慕容家，日后相见也更容易些。")
						script_say("主角：正有此意，只是不知如何才能加入慕容家呢？")
						script_say(name.."：小兄弟何不早说？你去姑苏城，那有一慕容家将，你说明来意，他自会带你前去燕子坞的。")
						script_say("主角：好。我现在就去。")
					end,
				
			};
	SE[102]={
				kind="会面",
				trigger=function()
							if 	GetFlag(20003)==0 and
								GetFlag(20002)==1 and
								JY.Person[0]["门派"]==10 and
								JY.Person[JY.Da]["姓名"]=="王语嫣" then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(20003,1)
						script_say("主角：参见表小姐。")
						script_say("王语嫣：有什么事吗？")
						script_say("主角：是这样的。小人向公子言及还施水阁中并没有高深心法，公子说表小姐熟知天下武学，让我向表小姐请教。")
						script_say("王语嫣：既然是表哥的要求，那我便传你一套[神元功]吧。")
						script_say("主角：谢表小姐！")
						script_say("王语嫣：我不过是听表哥的话，要谢你要去谢表哥。")
					end,
			};
	SE[801]={
				kind="对话",
				trigger=function()
							if 	GetFlag(65001)==0 and
								Rnd(50)==1 and
								JY.Person[0]["等级"]>JY.Person[JY.Da]["等级"]+10 and
								JY.Person[JY.Da]["姓名"]=="胡斐" then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(65001,1);
						script_say("胡斐：唉……要不是我家传刀谱缺了两页……")
						script_say("主角：咦？胡大哥，这是怎么事？")
						script_say("胡斐：唉，说来惭愧。当年家中遭逢大难，我尚年幼，有心无力，只想拼命保住家传的刀谱，以期日后能练成武功，以报家仇。孰知竟有一跌打医生，在慌乱之中，却是将刀谱中的两页撕下带走。导致我现在所练的，乃是残缺的刀法。要是我当年……唉……不提也罢……")
						script_say("主角：（一名跌打医生？我日后需留意，看看能不能帮胡大哥寻回刀谱。）")
					end,
			};
	SE[802]={
				kind="袭击",
				trigger=function(flag)
							if flag and GetFlag(65001)~=0 and GetFlag(65002)==0 and JY.Person[JY.Da]["姓名"]=="阎基" and Rnd(2)==1 then
								return 1;
							end
							return 0;
						end,
				go=	function(flag)
						SetFlag(65002,1);
						script_say("主角：（咦？这两张纸是……刀谱？）");
						DrawStrBoxWaitKey("得到两页刀谱")
					end,
			};
	SE[803]={
				kind="会面",
				trigger=function()
							if 	GetFlag(65002)~=0 and
								GetFlag(65003)==0 and
								JY.Person[JY.Da]["姓名"]=="胡斐" then
								return 1;
							end
							return 0;
						end,
				go=	function()
						SetFlag(65003,1);
						script_say("主角：胡大哥！这是我在江湖中游历，偶然得来的两页刀谱，你看……")
						script_say("胡斐：咦？我看看……啊！这正是我胡家刀法所遗失的那两页刀谱！兄弟你这是从何而得来的？")
						script_say("主角：我曾与一人打斗，那人不敌而逃，慌乱中落下这两页刀谱。莫非那人便是当年的跌打医生？")
						script_say("胡斐：不管他是与不是，这刀谱说明了他与当年之事必有联系。哼！待我将这两页刀法融入我现在所学之中，我定要找他问个水落石出！")
						script_say("主角：助胡大哥早日查明真相。")
						script_say("主角：兄弟，大恩不言谢！")
						JY.Person[JY.Da]["外出"]=6;
						for i=1,60 do
							AddPersonAttrib(JY.Da,"经验",math.modf(JY.Person[JY.Da]["等级"]*5000/(120-JY.Person[JY.Da]["资质"])));
							War_AddPersonLevel(JY.Da,false); 
						end
						
					end,
			};
	SE[804]={
				kind="会面",
				trigger=function()
							if 	GetFlag(65003)~=0 and
								JY.Person[JY.Da]["姓名"]=="阎基" then
								return 1;
							end
							return 0;
						end,
				go=	function()
						script_say("主角：阎基！你为什么会有我胡大哥的家传刀谱？你是不是就是当年的那个跌打医生？")
						script_say("阎基：不好！仇人找上门来了！我闪！")
						Dark();
								SetD(JY.SubScene,JY.CurrentD,0,0);
								SetD(JY.SubScene,JY.CurrentD,3,-1);
								SetD(JY.SubScene,JY.CurrentD,5,0);
								SetD(JY.SubScene,JY.CurrentD,6,0);
								SetD(JY.SubScene,JY.CurrentD,7,0);
						Light();
						script_say("主角：什么！可恶，居然让他给跑了！")
					end,
			};

	SE[901]={
				kind="袭击",
				trigger=function(flag)
							if flag and (	JY.Person[JY.Da]["姓名"]=="杨过" or
											JY.Person[JY.Da]["姓名"]=="小龙女" or
											JY.Person[JY.Da]["姓名"]=="李莫愁" or
											JY.Person[JY.Da]["姓名"]=="岳不群" or
											JY.Person[JY.Da]["姓名"]=="慕容复" or
											JY.Person[JY.Da]["姓名"]=="何足道" or
											JY.Person[JY.Da]["姓名"]=="郭襄" or
											JY.Person[JY.Da]["姓名"]=="灭绝师太" or
											JY.Person[JY.Da]["姓名"]=="枯荣禅师" or
											JY.Person[JY.Da]["姓名"]=="一灯" or
											JY.Person[JY.Da]["姓名"]=="萧峰") then
								return 1;
							end
							return 0;
						end,
				go=	function(flag)
						local n=0;
						local kflist={};
						for i=1,10 do
							if JY.Person[JY.Da]["所会武功"..i]>0 then
								n=n+1;
								table.insert(kflist,{JY.Person[JY.Da]["所会武功"..i],limitX(1+math.modf(JY.Person[JY.Da]["所会武功经验"..i]/100),1,100)})
							end
						end
						if n>0 then
							say("好凶险的一战，刚刚他使的武功真是厉害！我赶紧记下来！");
							LearnKF(0,JY.Da,kflist);
						end
					end,
				
			};
	SE[902]={
				kind="进入",
				trigger=function()
							if JY.SubScene==99 then
								return 1;
							end
							return 0;
						end,
				go=	function()
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
					--JY.Base["人X1"]=JY.Base["人X1"]-1
					Light();
				end,
			};
	SE[999]={
				kind="",
				trigger=function()
							return 0;
						end,
				go=	function()
					end,
				
			};
	
	
	
	
	
	
	
	for i,v in pairs(SE) do
		if v.kind=='会面' then
			table.insert(PE.meet,v);
		elseif v.kind=='对话' then
			table.insert(PE.talk,v);
		elseif v.kind=='袭击' then
			table.insert(PE.fight,v);
		elseif v.kind=='进入' then
			table.insert(PE.entrance,v);
		else
		
		end
	end
end