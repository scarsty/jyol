

-- �����ļ�
--Ϊ�˼򻯴����������ļ�Ҳ��lua��д
--����C�����ȡ�Ĳ�����lua��������Ҫ���������Ĳ�����lua������������Ȼ����jyconst.lua��

CONFIG={};

CONFIG.Debug=1;         --������Ժʹ�����Ϣ��=0����� =1 �����Ϣ��debug.txt��error.txt����ǰĿ¼

--�����������С��640*480(��СΪ320*240) ��Ϊ0�����ڵ���640*480 ��Ϊ1
--Ŀǰֻ������������������ֱ�����Ȼ���ã���Ϣ���ܹ���ʾ��������ʾЧ����һ���ÿ���
--������������ֱ�����������ʾЧ��������������jyconst.lua���޸���Ӧ������
CONFIG.Type= 1;

CONFIG.Rotate=0;         --��Ļ�Ƿ���ת  0 ����ת 1 ��ת90�ȡ�CONFIG.Width/Height��ȻΪδ��תǰ����Ļ����
                         --Ŀǰ��ת��ʱ��֧�ֲ���mpeg

CONFIG.Width  = 800;       -- ��Ϸͼ�δ��ڿ�
CONFIG.Height = 600;      -- ��Ϸͼ�δ��ڿ�

CONFIG.bpp  =32          -- ȫ��ʱ����ɫ�һ��Ϊ16����32���ڴ���ģʽʱֱ�Ӳ��õ�ǰ��Ļɫ���������Ч
                         -- ��֧��8λɫ�Ϊ����ٶȣ�����ʹ��16λɫ�
						 -- 24λδ�������ԣ�����֤��ȷ��ʾ

CONFIG.FullScreen=0      -- ����ʱ�Ƿ�ȫ��  1 ȫ�� 0 ����
CONFIG.EnableSound=1    -- �Ƿ������    1 �� 0 �ر�   �ر�������Ϸ���޷���

CONFIG.KeyRepeat=0       -- �Ƿ񼤻�����ظ� 0 �����ֻ����·�˵�ʱ�����ظ���1��������Ի�������ʱ����̾��ظ�
CONFIG.KeyRepeatDelay =300;   --��һ�μ����ظ��ȴ�ms��
CONFIG.KeyRePeatInterval=30;  --һ�����ظ�����

CONFIG.Zoom=1;
if CONFIG.Zoom==1 then
	CONFIG.XScale = 36		-- ��ͼ���ȵ�һ��
	CONFIG.YScale = 18		-- ��ͼ�߶ȵ�һ��
else
	CONFIG.XScale = 18		-- ��ͼ���ȵ�һ��
	CONFIG.YScale = 9		-- ��ͼ�߶ȵ�һ��
end

--���ø��������ļ���·�������������Ŀ¼��־��windows��ͬ��OS, ��linux�����Ϊ���ʵ�·��
CONFIG.CurrentPath =".\\"
CONFIG.DataPath=CONFIG.CurrentPath .. "data\\";
CONFIG.FightPath=CONFIG.CurrentPath .. "fight\\";
CONFIG.SavePath=CONFIG.CurrentPath .. "save\\";
CONFIG.PicturePath=CONFIG.CurrentPath .. "pic\\";
CONFIG.SoundPath=CONFIG.CurrentPath .. "sound\\";
CONFIG.MusicPath=CONFIG.CurrentPath .. "music\\";
CONFIG.ScriptPath=CONFIG.CurrentPath .. "script\\";
CONFIG.OldEventPath=CONFIG.ScriptPath .. "oldevent\\";
CONFIG.NewEventPath=CONFIG.ScriptPath .. "newevent\\";

CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua";   --lua��������

--��ʾ�����ļ��������windows����ֱ�Ӹ���ϵͳĿ¼�µ���������
--����ϵͳ�����Ҹ����ʵ�truetype���帴�Ƶ���Ϸdata������Ŀ¼�£����������·�����ļ���
--CONFIG.FontName="c:\\windows\\fonts\\simsun.ttc"--�����Ϲ����.ttf"--SIMHEI.TTf"--".\\������������.ttf";
--CONFIG.FontName="f:\\font\\���䷱����.ttf"
--CONFIG.FontName="c:\\windows\\fonts\\simkai.TTF";
--CONFIG.FontName="f:\\font\\������������.ttf"
CONFIG.OSCharSet=0      -- ��ʾ�ַ��� 0 ���� 1 ����

--��ʾ����ͼx��y�������ӵ���ͼ�����Ա�֤������ͼ��ȫ����ʾ
CONFIG.MMapAddX=2;
CONFIG.MMapAddY=2;
CONFIG.SMapAddX=2;
CONFIG.SMapAddY=16;
CONFIG.WMapAddX=2;
CONFIG.WMapAddY=18;

CONFIG.MusicVolume=64;            --���ò������ֵ�����(0-128)
CONFIG.SoundVolume=64;            --���ò�����Ч������(0-128)

local LargeMemory=1;             --�����ڴ�ʹ�÷�ʽ 1 ��ʹ���ڴ棬0 ��ʹ���ڴ�

    CONFIG.MAXCacheNum=9999;
	CONFIG.CleanMemory=1;         --�����л�ʱ�Ƿ�����lua�ڴ档0 ������ 1 ����
	CONFIG.LoadFullS=1;           --1 ����S*�ļ������ڴ� 0 ֻ���뵱ǰ����������S*��4M�࣬�������Խ�Լ�ܶ��ڴ�
	CONFIG.LoadMMapType=0;        --��������ͼ�ļ�(5��002�ļ�)������  0 ȫ������ 1 �������Ǹ������� 2 �������Ǹ������к���
	                              --����2ռ���ڴ����٣��������ֻ����豸������ʱ��ϳ����������߶�ʱ�Ῠһ��
								  --����1ռ���ڴ�϶࣬����ʱ���2Ҫ�٣�һ�㲻���п��ĸо�

	CONFIG.PreLoadPicGrp=1;       --1 Ԥ������ͼ�ļ�*.grp, 0 ��Ԥ���ء�Ԥ���ؿ��Ա�����·ż��ͣ�ٺ�ս������ͣ�١���ռ���ڴ�
--[[
if LargeMemory==1 then
     --��ͼ����������һ��500-1000�������debug.txt�о�������"pic cache is full"�������ʵ�����
    CONFIG.MAXCacheNum=8192;
	CONFIG.CleanMemory=0;         --�����л�ʱ�Ƿ�����lua�ڴ档0 ������ 1 ����
	CONFIG.LoadFullS=1;           --1 ����S*�ļ������ڴ� 0 ֻ���뵱ǰ����������S*��4M�࣬�������Խ�Լ�ܶ��ڴ�
	CONFIG.LoadMMapType=0;        --��������ͼ�ļ�(5��002�ļ�)������  0 ȫ������ 1 �������Ǹ������� 2 �������Ǹ������к���
	                              --����2ռ���ڴ����٣��������ֻ����豸������ʱ��ϳ����������߶�ʱ�Ῠһ��
								  --����1ռ���ڴ�϶࣬����ʱ���2Ҫ�٣�һ�㲻���п��ĸо�

	CONFIG.PreLoadPicGrp=1;       --1 Ԥ������ͼ�ļ�*.grp, 0 ��Ԥ���ء�Ԥ���ؿ��Ա�����·ż��ͣ�ٺ�ս������ͣ�١���ռ���ڴ�
else
    CONFIG.MAXCacheNum=500;
	CONFIG.CleanMemory=1;
	CONFIG.LoadFullS=0;
	CONFIG.LoadMMapType=1;
	CONFIG.PreLoadPicGrp=0;
end
]]--
CONFIG.LoadMMapScope=0;          --���ּ�������ͼ�ļ�ʱ�ļ��ط�Χ������仯������ֵʱ�����¼��ء���ֵ*4��Ϊʵ�ʼ��ص����ݴ�С��
                                 --һ�����ȡΪ0���ɳ����Զ����㡣
								 --����ȳ���������ֵС����ʹ���Զ������ֵ

--������Ļ��ʾˢ�·�ʽ 0 ȫ��ˢ����ʾ�� 1 ֻˢ����Ļ�仯���֡�
--��Ϊ1 �������������겻��ʱ�ӿ���ʾ����ͼ�ͳ�����ͼ���ٶȣ��Լ�ս�����к�Ч���ٶȣ��Ӷ�����CPUռ���ʡ�
--��ʱΪ�ӿ���ʾ�ٶȣ����������ĵ�Ʈ������ֹ��ս���Զ�����ʱҲ������ʾ����ͷ��
CONFIG.FastShowScreen=0;

