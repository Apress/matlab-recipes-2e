function SetPath

p = mfilename('fullpath');
cd0 = cd;
cd(fileparts(p));
addpath(pwd);

w = what('Ch01-Primer');
addpath(w.path);
w = what('Ch02-Style');
addpath(w.path);
w = what('Ch03-Visualization');
addpath(w.path);
w = what('Ch04-GUI');
addpath(w.path);
w = what('Ch05-Debugging');
addpath(w.path);
w = what('Ch06-DoubleIntegrator');
addpath(w.path);
w = what('Ch07-SCARA');
addpath(w.path);
w = what('Ch08-ElectricMotor');
addpath(w.path);
w = what('Ch09-FaultDetection');
addpath(w.path);
w = what('Ch10-Chemical');
addpath(w.path);
w = what('Ch11-Aircraft');
addpath(w.path);
w = what('Ch12-Spacecraft');
addpath(w.path);
w = what('Documentation');
addpath(w.path);

cd(cd0);

end

