function migong(x,y)
	local mg={};
	local cx,cy;
	x=limitX(x,1,30);
	y=limitX(y,1,30);
	cx=math.random(32-x,32+x);
	cy=math.random(32-y,32+y);
	--标记0,不通 1,通 2,等待访问
	--已经访问,正要访问,还没访问
	for i=0,63 do--32-x,32+x do
		mg[i]={}
		for j=0,63 do--32-y,32+y do
			mg[i][j]=0
		end
	end
	mg[cx][cy]=1;
	local data={[0]=0};
	for i=1,4 do
		local nx,ny=cx+CC.DirectX[i]*2,cy+CC.DirectY[i]*2;
		if between(nx,32-x,32+x) and between(ny,32-y,32+y) then
			mg[nx][ny]=2;
			data[0]=data[0]+1;
			data[data[0]]={nx,ny};
		end
	end
	local function ranselect()
		if data[0]==0 then return end
		local select=math.random(data[0]);
		local xy=data[select];
		mg[xy[1]][xy[2]]=1;
		data[select],data[data[0]]=data[data[0]],data[select];
		data[data[0]]=nil;
		data[0]=data[0]-1;
		local point={[0]=0,};
		for i=1,4 do
			local nx,ny=xy[1]+CC.DirectX[i]*2,xy[2]+CC.DirectY[i]*2;
			if between(nx,32-x,32+x) and between(ny,32-x,32+x) then
				if mg[nx][ny]==1 then
					point[0]=point[0]+1;
					point[point[0]]={xy[1]+CC.DirectX[i],xy[2]+CC.DirectY[i]};
				elseif mg[nx][ny]==0 then
					data[0]=data[0]+1;
					data[data[0]]={nx,ny};
					mg[nx][ny]=2;
				end
			end
		end
		if point[0]>0 then
			local sss;
			if point[0]==1 then
				sss=1;
			else
				sss=math.random(point[0]);
			end
			local nx,ny=point[sss][1],point[sss][2];
			mg[nx][ny]=1;
		end
		
		ranselect()
		--return num
	end
	
	ranselect()
	for i=0,63 do--32-x,32+y do
		for j=0,63 do--32-y,32+y do
			local pic
			if mg[i][j]==1 then 
				pic=-1;
			else
				local ran=math.random(15);
				if ran==1 then
					pic =2*(1394+math.random(10));
				elseif ran<9 then
					pic=2288;
				else
					pic=2308;
				end
			end
			lib.SetS(JY.SubScene,i,j,0,12);
			lib.SetS(JY.SubScene,i,j,1,pic);
		end
	end
end
