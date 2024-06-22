P_r = C*r*exp(F_r/D);

% C is a normalization constant (makes sure the area under the graph is 1 - makes sure it's in the proper form of a PDF)
% F_r is the antiderivative of f_r
% f_r is the direction of the radial motion. All we know about it is that
% the first derivative's polarity relates to the stability of the fixed point
% D has something to do with fokker-plack