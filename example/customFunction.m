function [ customCost ] = customFunction( input )

    wallArea = 74.6 - 11.9 * input(2)^2 - 8.7 * input(2);
    ceilingArea = 48;
    modelIds = floor([input(4), input(5)]) + 1;
    
    wallModelCosts = [
        286.037,...
        274.789,...
        267.833,...
        269.752,...
        277.250,...
        281.280,...
        261.000,...
        261.456,...
        329.000,...
        270.053,...
        273.710,...
        351.272,...
        624.000,...
        419.454,...
        489.000,...
        249.000,...
        386.722,...
        231.516,...
        212.072,...
        382.650,...
        227.344,...
        207.900,...
        370.036,...
        214.730,...
        201.602,...
        026.852,...
        362.204,...
        206.898,...
        191.469,...
        017.980,...
        170.454
    ];

    ceilingModelCosts = [
        515.845,...
        237.22,...
        34.745,...
        30.441,...
        41.177,...
        512.879,...
        234.254,...
        31.779,...
        27.475,...
        38.211,...
        996,...
        219.375
    ];

    wallCost = wallArea * wallModelCosts(modelIds(1));
    ceilingCost = ceilingArea * ceilingModelCosts(modelIds(2));
    
    customCost = wallCost + ceilingCost;
end
