function MakeAllHelp

p = mfilename('fullpath');
cd0 = cd;
cd(fileparts(p));

MakeHelp('./Ch01-Primer')
MakeHelp('./Ch02-Style')
MakeHelp('./Ch03-Visualization')
MakeHelp('./Ch04-GUI')
MakeHelp('./Ch05-Debugging')
MakeHelp('./Ch06-DoubleIntegrator')
MakeHelp('./Ch07-SCARA')
MakeHelp('./Ch08-ElectricMotor')
MakeHelp('./Ch09-FaultDetection')
MakeHelp('./Ch10-Chemical')
MakeHelp('./Ch11-Aircraft')
MakeHelp('./Ch12-Spacecraft')

builddocsearchdb ./Documentation

cd(cd0);

end


