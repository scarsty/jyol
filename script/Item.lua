JY.Item=	{
					[0]=	{--华山弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=333;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[1]=	{--青城弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=394;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[2]=	{--衡山弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=335;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[3]=	{--泰山弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=332;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[4]=	{--恒山弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=334;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[5]=	{--嵩山弟子装
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												SetFlag(120,JY.Person[pid]["战斗动作"]);
												JY.Person[pid]["战斗动作"]=336;
												return;
											end,
								unuse=	function(pid)--卸下效果
												JY.Person[pid]["战斗动作"]=GetFlag(120);
												return;
											end,
							},
					[999]=	{--Bak
								SR=	function(pid)--特别使用条件
											return true;
										end,
								onuse=	function(pid)--使用效果
												return;
											end,
								unuse=	function(pid)--卸下效果
												return;
											end,
							},
				}