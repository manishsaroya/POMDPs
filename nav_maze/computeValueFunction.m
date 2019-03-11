noise = 0.2;
discount = 0.9;
%load maze
m0 = load_maze('maze0.txt');
[cur, num_nodes] = get_start(m0);

%set initial reward
reward = 0;
%set initial discount
curDiscount = discount;
%display maze
draw_maze(m0,cur);

values = zeros(num_nodes,1)

Q_values = zeros(num_nodes, 4)

for i=1:100
    
    for state = 1:num_nodes
        for action = 1:4
            % Taking selected action
            qstate_ = is_move_valid(m0,state,action)
            if qstate_ == -1
                qstate_ = state
            end 
            % Taking left adjacent action because of noise
            if action ==1 
                action_left = 4
            else
                action_left = action - 1
            end
            qstate_left = is_move_valid(m0,state,action_left)
            if qstate_left == -1
                qstate_left = state
            end
            
            %Taking right adjacent action because of noise
            if action ==4
                action_right = 1
            else
                action_right = action + 1
            end
            qstate_right = is_move_valid(m0,state,action_right)
            if qstate_right == -1
                qstate_right = state
            end
            
            %update Q values by bellman equation
%             Q_values(state,action) = noise * (m0.reward(qstate_left) + discount * values(qstate_left)) + ...
%                                      noise * (m0.reward(qstate_right) + discount * values(qstate_right)) + ...
%                                      (1 - 2 * noise) * (m0.reward(qstate_) + discount * values(qstate_))
            Q_values(state,action) = noise * (m0.reward(state) + discount * values(qstate_left)) + ...
                                     noise * (m0.reward(state) + discount * values(qstate_right)) + ...
                                     (1 - 2 * noise) * (m0.reward(state) + discount * values(qstate_))
        end
        values(state) = max(Q_values(state,:))
    end
    
    draw_maze(m0,1, values)
    %Move in random direction (replace with your MDP policy)
    %dir = floor(rand()*4)+1;
    
    %try to move in the direction
    %cur = move_maze(m0,cur,dir,noise);
    %visualize maze
    %draw_maze(m0,cur);
    %receive discounted reward
    %reward = reward+get_reward(m0,cur)*curDiscount;
    %update discount
    curDiscount = curDiscount*discount;
    %pause(0.1);
end