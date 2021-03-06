
%this version works fine for the current actions and observations. 
%Node: change the nodes to d not sting because sometimes its assigned to
%d and sometimes its refered to originical as string 

%agent1 is robot,  agent 2 is human
agent1Loc = {'a','b', 'c','d','e','f','g','h','i','j','k','l'};
agent2Loc = {'a','b', 'c','d','e','f','g','h','i','j','k','l'};
dangerLoc = {'c','n'};%n means no danger
victimLoc = {'f','n'};%n means no victim 

victimLocState = 6;%the node 
dangerLocState = 3;

victimlocNode ='f';
dangerlocNode ='c';

agent1Actions     = {'right','left','up','down','stop','clear_danger'};
agent2Actions     = {'right','left','up','down','stop','extract_victim'};

agent1Observation = {'vic_noDan','noVic_dan','noVic_noDan'};
agent2Observation = {'vic_noDan','noVic_dan','noVic_noDan'};


%right,left,up, down,stop,clear/extract
%-----------------------------------------
%  g	|	|	|	|   f(H)|
%-----------------------------------------
%   	| xxxxxx|xxxxxx	|xxxxxx	|	|
%-----------------------------------------
%  h	|   i	|xxxxxxx|  d(V)(D)|   e|
%-----------------------------------------
%xxxxxxx|  j	| 	|  c	|xxxxxxx|
%-----------------------------------------
%  k	|xxxxxxx|xxxxxxx|	|xxxxxxx|
%-----------------------------------------
%  l	|	|	|   b(R)| a	|
%-----------------------------------------

%{right, left, up, down, stop, clear/extract}
%a=1,b=2,c=3,d=4,e=5,f=6. g=7 h=8, i=9, j=10, k=11, l=12  
network =[[1,2,1,1,1,1];[1,12,3,2,2,2];[3,10,4,2,3,3];[5,4,4,3,4,4];[5,4,6,5,5,5];[6,7,6,5,6,6];[6,7,7,8,7,7];[9,8,7,8,8,8];[9,8,9,10,9,9];[3,10,9,10,10,10];[11,11,11,12,11,11];[2,12,11,12,12,12]];

network_indices=[[6,5];[6,4];[4,4];[3,4];[3,5];[1,5];[1,1];[3,1];[3,2];[4,2];[5,1];[6,1]];

format long; 
% Multi-Agent Human Robot Collaboration
outputFile = 'MAHRC_6x5_priortiesObj_v2_1.dpomdp';  
fid = fopen(outputFile, 'wb');
% Write to File the top comments 
fprintf(fid,'# This DEC-POMDP Model svas generated MATLAB Script');
fprintf(fid,'\n# This script is still experimental and bugs might appear');
fprintf(fid,'\n# Tarek Taha & Hend Al Tair - KUSTAR\n');

fprintf(fid,'#The agents.');
fprintf(fid,'\nagents: 2');
fprintf(fid,'\ndiscount: 1.0');
fprintf(fid,'\nvalues: reward');
fprintf(fid,'\nstates:');

for x=1:length(agent1Loc)
        for z=1:length(agent2Loc)
            for sv=1:length(victimLoc)
                for sd=1:length(dangerLoc)
                    fprintf(fid,'%s_%s_%s_%s ',agent1Loc{x},agent2Loc{z},victimLoc{sv},dangerLoc{sd});
                end 
            end
        end
end
            
%Examples of this are:
%   start: 0.3 0.1 0.0 0.2 0.5
%   start: first-state
%   start: 5
%   start: uniform
%   start include: first-state third state
%   start include: 1 3
%   start exclude: fifth-state seventh-state

fprintf(fid,'\nstart:\nuniform');

%  fprintf(fid,'\nstart include: ');
%  for sv=1:length(victimLoc)
%     for sd=1:length(dangerLoc)
%   
%  	fprintf(fid,'1_7_5_%s_%s ',victimLoc{sv}, dangerLoc{sd});
%          
%     end 
%  end 
%The actions declarations
% ------------------------
% The  (number/list of) actions for each of the agents on a separate line
%    actions: 
%    [ %d, <list of actions> ] 
%    [ %d, <list of actions> ] 
%    ...
%    [ %d, <list of actions> ] 
fprintf(fid,'\nactions:'); 
fprintf(fid,'\n');
for a1=1:length(agent1Actions)
  fprintf(fid,'%s ',agent1Actions{a1});  
end
fprintf(fid,'\n');
for a2=1:length(agent2Actions)
  fprintf(fid,'%s ',agent2Actions{a2});
end

% The (number/list of) observations for each of the agents on a separate line
%    observations: 
%    [ %d, <list of observations> ]
%    [ %d, <list of observations> ]
%    ...
%    [ %d, <list of observations> ]
fprintf(fid,'\nobservations:'); 

fprintf(fid,'\n');
for o1=1:length(agent1Observation)
 fprintf(fid,'%s ',agent1Observation{o1});
end
fprintf(fid,'\n');

for o2=1:length(agent2Observation)
  fprintf(fid,'%s ',agent2Observation{o2}); 
end

% Transition probabilities
%   T: <a1 a2...an> : <start-state> : <end-state> : %f
% or
%    T: <a1 a2...an> : <start-state> :
%    %f %f ... %f                           P(s_1'|ja,s) ... P(s_sd'|ja,s)
% or
%    T: <a1 a2...an> :                      this is a |S| x |S| matrix
%    %f %f ... %f                           P(s_1'|ja,s_1) ... P(s_sd'|ja,s_1)
%    %f %f ... %f                           ...
%    ...                                            ...
%    %f %f ... %f                           P(s_1'|ja,s_sd) ... P(s_sd'|ja,s_sd)
% or
%    T: <a1 a2...an> 
%    [ identity, uniform ]
% T: * :
% uniform
% T:open-right open-right :
% uniform
% T: listen listen :
% identity 


%HencComment: remember array start the index from 1 not zero 

% How many actions per state:
a1StateSpace = size(agent1Loc)(2);
a2StateSpace = size(agent2Loc)(2);
dStateSpace  = size(dangerLoc)(2);
vStateSpace  = size(victimLoc)(2);


agents_certainty = 0.95; 
v_d_certainty =1; 
for a1=1:length(agent1Actions)
  for a2=1:length(agent2Actions)
  
    for s1=1:length(agent1Loc)
      for s2=1:length(agent2Loc)
        for sd=1:length(dangerLoc) 
	  for sv=1:length(victimLoc)
                sum = 0;
		  for s1p=1:length(agent1Loc)
		    for s2p=1:length(agent2Loc)
                      for sdp=1:length(dangerLoc) 
		        for svp=1:length(victimLoc)

			  if(s1p==network(s1,a1))
			    probx=agents_certainty;
			  else 
			    probx=(1-agents_certainty)/(a1StateSpace-1);
			  end 
              
			  if (s2p==network(s2,a2))
			    probz=agents_certainty;
			  else 
			    probz=(1-agents_certainty)/(a2StateSpace-1);
			  end
	     
			  if (s1== dangerLocState && strcmp(dangerLoc{sd},dangerlocNode) && strcmp(agent1Actions{a1},'clear_danger') && strcmp(dangerLoc{sdp},'n'))
			    probd=v_d_certainty;
			  elseif (s1== dangerLocState && strcmp(dangerLoc{sd},dangerlocNode) && !strcmp(agent1Actions{a1},'clear_danger') && strcmp(dangerLoc{sd},dangerLoc{sdp}))
			    probd=v_d_certainty;
			  elseif (s1== dangerLocState && strcmp(dangerLoc{sd},'n') && strcmp(dangerLoc{sd},dangerLoc{sdp}))
			    probd=v_d_certainty;
			  elseif (s1~= dangerLocState && strcmp(dangerLoc{sd},'n') &&  !strcmp(agent1Actions{a1},'clear_danger') && strcmp(dangerLoc{sd},dangerLoc{sdp}))
			    probd=v_d_certainty;
			  elseif (s1~= dangerLocState && strcmp(dangerLoc{sd},dangerLoc{sdp}))
			    probd=v_d_certainty;
			  else
			    probd=1-v_d_certainty/(dStateSpace-1);
			  end 


			  
			  if (s2== victimLocState && strcmp(victimLoc{sv}, victimlocNode) && strcmp(agent2Actions{a2},'extract_victim') && strcmp(victimLoc{svp},'n'))
			    probv=v_d_certainty;
			  elseif (s2== victimLocState && strcmp(victimLoc{sv},victimlocNode) && sv==svp && !strcmp(agent2Actions{a2},'extract_victim') )
			    probv=v_d_certainty;
			  elseif (s2== victimLocState && strcmp(victimLoc{sv},'n') && sv==svp)
			    probv=v_d_certainty;
			  elseif (s2~= victimLocState &&  strcmp(victimLoc{sv},'n') && sv==svp && !strcmp(agent2Actions{a2},'extract_victim') )
			    probv=v_d_certainty;
			  elseif (s2~= victimLocState && sv==svp )
			    probv=v_d_certainty;
			  else 
			    probv=1-v_d_certainty/(vStateSpace-1);
			  end 

			  
			  uniProb1= probx*probz*probd*probv;
                          sum = sum + uniProb1;
                          fprintf(fid,'\nT: %s %s : %s_%s_%s_%s : %s_%s_%s_%s : %f',agent1Actions{a1},agent2Actions{a2},agent1Loc{s1},agent2Loc{s2},victimLoc{sv},dangerLoc{sd},agent1Loc{s1p},agent2Loc{s2p},victimLoc{svp},dangerLoc{sdp},uniProb1);
			    
			   
			end 
		      end 
		     end
		   end 
               % Sanity Checsd: floating point comparison hacsd
               if (abs(sum-1.0)>0.00001)
                printf('\n Sum for T: %s %s : %s_%s_%s_%s is:%f',agent1Actions{a1},agent2Actions{a2},agent1Loc{s1},agent2Loc{s2},victimLoc{sv},dangerLoc{sd},sum);
               end
               end
            end
         end
      end
   end
end               

% Observation probabilities
%     O: <a1 a2...an> : <end-state> : <o1 o2 ... om> : %f
% or
%     O: <a1 a2...an> : <end-state> :
%     %f %f ... %f	    P(jo_1|ja,s') ... P(jo_x|ja,s')
% or
%     O:<a1 a2...an> :	    - a |S|x|JO| matrix
%     %f %f ... %f	    P(jo_1|ja,s_1') ... P(jo_x|ja,s_1') 
%     %f %f ... %f	    ... 
%     ...		    ...
%     %f %f ... %f	    P(jo_1|ja,s_sd') ... P(jo_x|ja,s_sd') 
%O: * : uniform

%O: * : f0_f0_f0_h1_h1 : flames flames : 0.04
%O: * : f0_f0_f0_h1_h1 : flames noFlames : 0.16
%O: * : f0_f0_f0_h1_h1 : noFlames flames : 0.16
%O: * : f0_f0_f0_h1_h1 : noFlames noFlames : 0.64

% In state a, I observe victim svith high probability
% In state b, I observe danger svith high probability


% Add uniformity just in case sve missed something
%   fprintf(fid,'\nO: * :\nuniform');

% How many observations:
a1ObservationSpace = size(agent1Observation)(2);
a2ObservationSpace = size(agent2Observation)(2);

obsCertainty =0.9;

for a1=1:length(agent1Actions)
  for a2=1:length(agent2Actions)
    for x=1:length(agent1Loc)
      for z=1:length(agent2Loc)
	for sv=1:length(victimLoc)
	  for sd=1:length(dangerLoc)
	  sum=0.0;
	    for o1=1:length(agent1Observation)
              for o2=1:length(agent2Observation)
              
		  probO1=0.0;
                  probO2=0.0;
		  uniProb1=0.0;  
		  
		  if(x==victimLocState && strcmp(victimLoc{sv},victimlocNode) && strcmp(agent1Observation{o1},'vic_noDan')) 
		    probO1= obsCertainty;
		  elseif(x==victimLocState && strcmp(victimLoc{sv},'n') && strcmp(agent1Observation{o1},'noVic_noDan'))
		     probO1= obsCertainty;
		  elseif ( x==dangerLocState && strcmp(dangerLoc{sd},dangerlocNode) && strcmp(agent1Observation{o1},'noVic_dan'))
		     probO1= obsCertainty;
		  elseif ( x==dangerLocState && strcmp(dangerLoc{sd},'n') && strcmp(agent1Observation{o1},'noVic_noDan'))
		     probO1= obsCertainty;
		  elseif (x~=dangerLocState && x~=victimLocState && strcmp(agent1Observation{o1},'noVic_noDan'))
		      probO1= obsCertainty;
		  else 
		     probO1= (1-obsCertainty)/(a1ObservationSpace-1);
		  end 

		  
		  if(z==victimLocState && strcmp(victimLoc{sv},victimlocNode) && strcmp(agent2Observation{o2},'vic_noDan'))
		    probO2= obsCertainty;
		  elseif(z==victimLocState && strcmp(victimLoc{sv},'n') && strcmp(agent2Observation{o2},'noVic_noDan'))
		     probO2= obsCertainty;
		  elseif ( z==dangerLocState && strcmp(dangerLoc{sd},dangerlocNode) && strcmp(agent2Observation{o2},'noVic_dan'))
		     probO2= obsCertainty;
		  elseif ( z==dangerLocState && strcmp(dangerLoc{sd},'n') && strcmp(agent2Observation{o2},'noVic_noDan'))
		     probO2= obsCertainty;
		  elseif (z~=dangerLocState && z~=victimLocState && strcmp(agent2Observation{o2},'noVic_noDan'))
		      probO2= obsCertainty;
		  else 
		     probO2= (1-obsCertainty)/(a2ObservationSpace-1);
		  end
		  
  
		  uniProb1=probO1*probO2;
		  sum = sum + uniProb1;
		  
		  fprintf(fid,'\nO: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent2Actions{a2},agent1Loc{x},agent2Loc{z},victimLoc{sv},dangerLoc{sd},agent1Observation{o1},agent2Observation{o2},uniProb1);
              
              
              
              end 
            end
            
             % Sanity Checsd: floating point comparison hacsd
               if (abs(sum-1.0)>0.00001)
                printf('\n Sum for O: %s %s : %s_%s_%s_%s :  %s %s :%f',agent1Actions{a1},agent2Actions{a2},agent1Loc{x},agent2Loc{z},victimLoc{sv},dangerLoc{sd},agent1Observation{o1},agent2Observation{o2},sum);
	      end
          end 
        end 
      end
    end 
  end 
end 




 
% Build Resvard Function
% Typical problems only use R(s,ja) svhich is specified by:
%   R: <a1 a2...an> : <start-state> : * : * : %f
%   or
%   R: <a1 a2...an> : <start-state> : <end-state> : <observation> %f

priority_order = {'clear_danger','extract_victim','dangerDistance','time'};


  for a1=1:length(agent1Actions)
    for a2=1:length(agent2Actions)
      for x=1:length(agent1Loc)
	for z=1:length(agent2Loc)
	  for v=1:length(victimLoc)
	    for d=1:length(dangerLoc)
	     
	      reward_clearDanger = 0; 
	      dangerZoneReward =0;
	      reward_extractVictim =0;
	      jointDistanceReward =0;

	      % -----------------Reward for clearing danger----------------------------------
  	      if(strcmp(agent1Actions{a1},'clear_danger')&& strcmp(dangerLoc{d},dangerlocNode)&& strcmp(agent1Loc(network(x,a1)),dangerlocNode))
		reward_clearDanger = 100; 
	      end
	      %----------------- penality for human go to danger_USING danger function-------
	      dangerPenalization=-50;
  	      if (strcmp(dangerLoc{d},dangerlocNode))
		distance = calculateDistance(network_indices,dangerLocState,network(z,a2));
		dangerZoneReward= dangerPenalization/distance; 
	      end   
	      %--------------- Extracting a victim is highly rewarderd-----------------------
  	      if (strcmp(agent2Actions{a2},'extract_victim')&& strcmp(victimLoc{v},victimlocNode)&& strcmp(agent2Loc(network(z,a2)),victimlocNode))
		reward_extractVictim = 100; 
	      end
	      %---------------- Useless motions are penalised---------------------------- 
	      uselessMotionPenalization = -2; 
	      distanceAgent1 = calculateDistance(network_indices,x,network(x,a1));
	      distanceAgent2 = calculateDistance(network_indices,z,network(z,a2));
	      jointDistanceReward= (uselessMotionPenalization/distanceAgent1)+(uselessMotionPenalization/distanceAgent2);

	       
	      jointReward = calculateSumRewards_v1_1(priority_order,jointDistanceReward,dangerZoneReward,reward_clearDanger,reward_extractVictim);

	      fprintf(fid,'\nR: %s %s : %s_%s_%s_%s : * :  * : %f', agent1Actions{a1}, agent2Actions{a2},agent1Loc{x},agent2Loc{z},victimLoc{v},dangerLoc{d},jointReward);    
	      
	      %---------save the rewards per objective-------------------
	      if(strcmp(agent1Actions{a1},'right')&&strcmp(agent2Actions{a2},'up')&&strcmp(agent1Loc{x},'l')&&strcmp(agent2Loc{z},'h')&&strcmp(victimLoc{v},'f')&&strcmp(dangerLoc{d},'c'))
		x_ep0= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'up')&&strcmp(agent2Actions{a2},'right')&&strcmp(agent1Loc{x},'b')&&strcmp(agent2Loc{z},'g')&&strcmp(victimLoc{v},'f')&&strcmp(dangerLoc{d},'c'))
		x_ep1= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'clear_danger')&&strcmp(agent2Actions{a2},'up')&&strcmp(agent1Loc{x},'c')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'f')&&strcmp(dangerLoc{d},'c'))
		x_ep2= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'down')&&strcmp(agent2Actions{a2},'extract_victim')&&strcmp(agent1Loc{x},'c')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'f')&&strcmp(dangerLoc{d},'n'))
		x_ep3= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'left')&&strcmp(agent2Actions{a2},'down')&&strcmp(agent1Loc{x},'b')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep4= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'right')&&strcmp(agent2Actions{a2},'up')&&strcmp(agent1Loc{x},'l')&&strcmp(agent2Loc{z},'e')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep5= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'left')&&strcmp(agent2Actions{a2},'down')&&strcmp(agent1Loc{x},'b')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep6= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'right')&&strcmp(agent2Actions{a2},'up')&&strcmp(agent1Loc{x},'l')&&strcmp(agent2Loc{z},'e')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep7= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'left')&&strcmp(agent2Actions{a2},'down')&&strcmp(agent1Loc{x},'b')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep8= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'right')&&strcmp(agent2Actions{a2},'up')&&strcmp(agent1Loc{x},'l')&&strcmp(agent2Loc{z},'e')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep9= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      if(strcmp(agent1Actions{a1},'left')&&strcmp(agent2Actions{a2},'down')&&strcmp(agent1Loc{x},'b')&&strcmp(agent2Loc{z},'f')&&strcmp(victimLoc{v},'n')&&strcmp(dangerLoc{d},'n'))
		x_ep10= [reward_clearDanger reward_extractVictim dangerZoneReward jointDistanceReward];
	      end
	      %----------------------------------------------------------
	      
	    end
	   end
	  end
	 end
	end
      end 

%==================================================================================================================================================


fprintf(fid,'\n');

fclose(fid);

%--------------Save rewards in file------
outputFile = 'priortiesObj_v2_1_TC50_lhfc.txt';  
fid = fopen(outputFile, 'wb');
% Write to File the top comments 
fprintf(fid,'\n TC50 starting state is l_h_f_c');
fprintf(fid,'\n For each episode of time it will have 4 objectives: clear danger, extract victim, distance to danger, and distance (time)');
fprintf(fid,'\n Ep0: %f',x_ep0);
fprintf(fid,'\n Ep1: %f',x_ep1);
fprintf(fid,'\n Ep2: %f',x_ep2);
fprintf(fid,'\n Ep3: %f',x_ep3);
fprintf(fid,'\n Ep4: %f',x_ep4);
fprintf(fid,'\n Ep5: %f',x_ep5);
fprintf(fid,'\n Ep6: %f',x_ep6);
fprintf(fid,'\n Ep7: %f',x_ep7);
fprintf(fid,'\n Ep8: %f',x_ep8);
fprintf(fid,'\n Ep9: %f',x_ep9);
fprintf(fid,'\n Ep10: %f',x_ep10);
fprintf(fid,'\n');
fclose(fid);

%--------------Plot----------------------
figure 
  
bar([x_ep0;x_ep1;x_ep2;x_ep3;x_ep4;x_ep5;x_ep6;x_ep7;x_ep8;x_ep9;x_ep10]); 
grid on
title('Rewards per Objective at Each Time Step')
xlabel('Episode');
ylabel('Joint Rewards');
lngd=legend('Clear Danger', 'Extract Victim','Distance from Danger','Time of Travel');
set(lngd,'Location','NorthEast');
set(lngd,'interpreter','latex','fontsize',8);
