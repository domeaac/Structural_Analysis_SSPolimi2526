%%%%%%%%%% SOURCE CODE
NewActions = subs(NewActions, solution);

dWi = [];

for i = 1:max(size(Dummies))
    da = diff(NewActions, Dummies(i), 1);

    inte = 0;
    for j = 1:max(size(NewActions)) 
         inte = inte + int(actions(j)*da(j)/conj_stiffness(j), x, 0, ls(j));
    end

    dWi = [dWi; inte];
end


displacements = dWi;






