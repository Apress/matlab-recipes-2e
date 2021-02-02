function drag = Drag(DensityModel,h,v,s)
drag = 0.5*DensityModel.LookUpDensity(h)*s*v^2;
end

