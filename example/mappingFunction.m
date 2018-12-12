function [ mappedInput ] = mappingFunction( input )

    x = sind(input(1));
    z = cosd(input(1));
    
    inputOne = {x z};

    centerPoint = [0 1.35];
    minSize = [1 1] / 2;
    maxSize = [8 2.7] / 2;
    delta = maxSize - minSize;
    
    leftmostBorder  = centerPoint(1) - minSize(1) - input(2) * delta(1);
    rightmostBorder = centerPoint(1) + minSize(1) + input(2) * delta(1);
    lowerBorder     = centerPoint(2) - minSize(2) - input(2) * delta(2);
    upperBorder     = centerPoint(2) + minSize(2) + input(2) * delta(2);
    
    inputTwo = {leftmostBorder, rightmostBorder, lowerBorder, upperBorder};
    
    baseSchedule = [5 14];
    startingHour = baseSchedule(1) + floor(input(3));
    endingHour = baseSchedule(2) + floor(input(3));
    
    inputThree = {startingHour, endingHour};
    
    models = evalin('base', 'models');
    index = evalin('base', 'index');
    usedMaterialIds = [4 11 12];
    modelIds = floor([input(4), 31 + input(5)]) + 1;
    materialConfigurations = {};
    
    for modelId = modelIds
        model = models(modelId);
        numMaterials = numel(model.materials);
        materialConfiguration = strcat(num2str(numMaterials));
        
        for i = 1:numel(model.materials)
            material = model.materials(i);
            materialConfiguration = strcat(materialConfiguration, ',', index(material.id).name, ',');
            materialConfiguration = strcat(materialConfiguration, num2str(material.mesh), ',');
            materialConfiguration = strcat(materialConfiguration, num2str(material.width * 10));
            
            if ~any(usedMaterialIds == material.id)
                usedMaterialIds = cat(2, usedMaterialIds, material.id);
            end
        end

        materialConfigurations = cat(2, materialConfigurations, materialConfiguration);
    end
    
    materialList = strcat('i,Domus:Materiais,', num2str(numel(usedMaterialIds)));
    materialSpecifications = '';
    
    for materialId = usedMaterialIds
        material = index(materialId);
        
        materialList = strcat(materialList, ',', material.name);
        
        materialSpecifications = strcat(materialSpecifications, sprintf('%s%s%s', char(13), newline(), 'i,Domus:Material,'), material.name, ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.density), ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.porosity), ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.specificHeat), ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.thermalConductivity), ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.isothermsTable), ',');
        materialSpecifications = strcat(materialSpecifications, num2str(material.isothermsGranularity), ',');
        materialSpecifications = strcat(materialSpecifications, material.dataFile, ',');
        materialSpecifications = strcat(materialSpecifications, material.isothermsFile, ',');
        materialSpecifications = strcat(materialSpecifications, material.isothermsFunction, ',0;');
    end
    
    materialList = strcat(materialList, ';');
    
    mappedInput = cat(2, inputOne, inputTwo, inputThree, materialConfigurations, materialList, materialSpecifications);
end
