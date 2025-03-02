% Input as facts of the form cell(1,1,"c")
cell(1,1,"c").
cell(1,2,"e").
cell(1,3,"b").
cell(1,4,"b").
cell(1,5,"c").
cell(2,1,"b").
cell(2,2,"c").
cell(2,3,"a").
cell(2,4,"d").
cell(2,5,"e").
cell(3,1,"a").
cell(3,2,"d").
cell(3,3,"a").
cell(3,4,"c").
cell(3,5,"e").
cell(4,1,"d").
cell(4,2,"c").
cell(4,3,"b").
cell(4,4,"e").
cell(4,5,"a").
cell(5,1,"a").
cell(5,2,"b").
cell(5,3,"c").
cell(5,4,"d").
cell(5,5,"d").
cell(6,1,"c").
cell(6,2,"e").
cell(6,3,"d").
cell(6,4,"a").
cell(6,5,"b").


%% For each cell, guess whether to cross it out.
{ crossedout(R,C,S) } :- cell(R,C,S).

%% A cell is active if it is not crossed out.
active(R,C) :- cell(R,C,S), not crossedout(R,C,S).

%% --- Condition 1: No duplicate symbols in any row and column
:- cell(R,C1,S), cell(R,C2,S), not crossedout(R,C1,S), not crossedout(R,C2,S), C1 < C2.
:- cell(R1,C,S), cell(R2,C,S), not crossedout(R1,C,S), not crossedout(R2,C,S), R1 < R2.

%% --- Define adjacent cells (neighbors horizontally or vertically).
adj(R,C,R,C2) :- cell(R,C,_), cell(R,C2,_), C2 = C+1.    % vertically - right
adj(R,C,R,C2) :- cell(R,C,_), cell(R,C2,_), C2 = C-1.    % vertically - left
adj(R,C,R2,C) :- cell(R,C,_), cell(R2,C,_), R2 = R+1.    % horizontally - up
adj(R,C,R2,C) :- cell(R,C,_), cell(R2,C,_), R2 = R-1.    % horizontally - down

%% --- Condition 2: No two crossed-out cells may be adjacent.
:- crossedout(R,C,_), adj(R,C,R2,C2), crossedout(R2,C2,_).

%% --- Condition 3: The active cells must be connected.
%% Choose exactly one active cell as the starting point.
1 { start(R,C) : active(R,C) } 1.
%% Mark the starting cell as reachable.
reachable(R,C) :- start(R,C).
%% Propagate reachability through adjacent active cells.
reachable(R2,C2) :- reachable(R,C), adj(R,C,R2,C2), active(R2,C2).
%% Every active cell must be reachable.
:- active(R,C), not reachable(R,C).

%% (Optional) Enforce that at least one cell remains active.
:- not active(_,_).

% Output predicate crossedout/3

#show cell/3.
#show crossedout/3.