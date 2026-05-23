function [dist, ix, iy, D] = mydtw(A, B)
% i was getting erron on installing (Speech Processing Tool) so i wrote
% manual for all functions source from internet

% A: 39 x T1
% B: 39 x T2

T1 = size(A,2);
T2 = size(B,2);

% Cost matrix
D = zeros(T1, T2);

for i = 1:T1
    for j = 1:T2
        D(i,j) = norm(A(:,i) - B(:,j));
    end
end

% Accumulated cost
C = zeros(T1, T2);
C(1,1) = D(1,1);

% First row
for j = 2:T2
    C(1,j) = D(1,j) + C(1,j-1);
end

% First column
for i = 2:T1
    C(i,1) = D(i,1) + C(i-1,1);
end

% Fill matrix
for i = 2:T1
    for j = 2:T2
        C(i,j) = D(i,j) + min([C(i-1,j), C(i,j-1), C(i-1,j-1)]);
    end
end

% Final distance
dist = C(T1, T2);

% Backtracking → DTW path
i = T1;
j = T2;

ix = i;
iy = j;

while i > 1 || j > 1

    if i == 1
        j = j - 1;
    elseif j == 1
        i = i - 1;
    else
        [~, idx] = min([C(i-1,j), C(i,j-1), C(i-1,j-1)]);
        
        if idx == 1
            i = i - 1;
        elseif idx == 2
            j = j - 1;
        else
            i = i - 1;
            j = j - 1;
        end
    end

    ix = [i ix];
    iy = [j iy];
end

end