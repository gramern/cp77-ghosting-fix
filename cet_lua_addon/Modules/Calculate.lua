--FrameGen Ghosting Fix 3.0.0

local Calculate = {
    ScreenDetection = {
		FGGFreswidth = nil,
		FGGFresheight = nil,
		FGGFaspectratio = 1.78,
        FGGFscreentype = "16:9"
    },
    FPPBikeELG = {
        handlebarsHeight = 170,
        windshieldWidth = 120,
        windshieldHeight = 300,
        originalHandlebarsHeightPx = 950,
        originalWindshieldWidthPx = 1800,
        originalWindshieldHeightPx = 800,
		newHandlebarsHeightPx = nil,
        newWindshieldWidthPx = nil,
        newWindshieldHeightPx = nil,

    },
    FPPOnFoot = {
		VignetteEditor = {
			vignetteMinMarginX = 50,
			vignetteMaxMarginX = 150,
			vignetteMinSizeX = 80,
			vignetteMaxSizeX = 130,
			vignetteMinMarginY = 55,
			vignetteMaxMarginY = 145,
			vignetteMinSizeY = 85,
			vignetteMaxSizeY = 130,
		},
        vignetteFootMarginLeft = 100,
        vignetteFootMarginTop = 80,
        vignetteFootSizeX = 120,
        vignetteFootSizeY = 120,
        originalVignetteFootMarginLeftPx = 1920,
        originalVignetteFootMarginTopPx = 1080,
        originalVignetteFootSizeXPx = 4840,
        originalVignetteFootSizeYPx = 2560,
		newVignetteFootMarginLeftPx = nil,
        newVignetteFootMarginTopPx = nil,
        newVignetteFootSizeXPx = nil,
        newVignetteFootSizeYPx = nil,
		vignetteAimFootSizeXPx = 3840,
        vignetteAimFootSizeYPx = 2440
    }
}

function Calculate.CalcAspectRatio()
    Calculate.ScreenDetection.FGGFreswidth, Calculate.ScreenDetection.FGGFresheight = GetDisplayResolution();
	Calculate.ScreenDetection.FGGFaspectratio = Calculate.ScreenDetection.FGGFreswidth / Calculate.ScreenDetection.FGGFresheight
end

--get the game's aspect ratio
function Calculate.GetAspectRatio()
	if Calculate.ScreenDetection.FGGFaspectratio <= 1.59 then
		Calculate.ScreenDetection.FGGFscreentype = "4:3"
	elseif Calculate.ScreenDetection.FGGFaspectratio >= 1.6 and Calculate.ScreenDetection.FGGFaspectratio <= 1.7 then
		Calculate.ScreenDetection.FGGFscreentype = "16:10"
	elseif Calculate.ScreenDetection.FGGFaspectratio >= 2.2 and Calculate.ScreenDetection.FGGFaspectratio <= 3.4 then
		Calculate.ScreenDetection.FGGFscreentype = "21:9"
	elseif Calculate.ScreenDetection.FGGFaspectratio >= 3.41 then
		Calculate.ScreenDetection.FGGFscreentype = "32:9"
	end
	-- print("Aspect ratio:",Calculate.ScreenDetection.FGGFaspectratio)
end

function Calculate.SetMasksOrgSizes()
	if Calculate.ScreenDetection.FGGFscreentype == "16:10" then
		Calculate.FPPBikeELG.originalHandlebarsHeightPx = 1150
	elseif Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPBikeELG.originalHandlebarsHeightPx = 1200
		Calculate.FPPBikeELG.originalWindshieldHeightPx = 900
	end
end

function Calculate.SetVignetteOrgMinMax()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY = 95
	end
end

function Calculate.SetVignetteOrgSize()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1440
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 3072
	elseif Calculate.ScreenDetection.FGGFscreentype == "16:10" then
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1200
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 4840
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2880
	elseif Calculate.ScreenDetection.FGGFscreentype == "21:9" then
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 2560
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 6460
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
	elseif Calculate.ScreenDetection.FGGFscreentype == "32:9" then
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 3840
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 9680
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
	end
	-- print("Vignette position and size:",Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx,Calculate.FPPOnFoot.originalVignetteFootMarginTopPx,Calculate.FPPOnFoot.originalVignetteFootSizeXPx,Calculate.FPPOnFoot.originalVignetteFootSizeYPx)
end

function Calculate.SetVignetteAimSize()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 3840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 3072
	elseif Calculate.ScreenDetection.FGGFscreentype == "16:10" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 3840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2640
	elseif Calculate.ScreenDetection.FGGFscreentype == "21:9" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 5140
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2440
	elseif Calculate.ScreenDetection.FGGFscreentype == "32:9" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 7770
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2440
	end
	-- print("Aim vignette size:",Calculate.FPPOnFoot.vignetteAimFootSizeXPx,Calculate.FPPOnFoot.vignetteAimFootSizeYPx)
end

--calc dimensions of ELG masks
function Calculate.HandlebarsY()
	Calculate.FPPBikeELG.newHandlebarsHeightPx = Calculate.FPPBikeELG.originalHandlebarsHeightPx*(Calculate.FPPBikeELG.handlebarsHeight/100.0)
	Calculate.FPPBikeELG.newHandlebarsHeightPx = (math.floor(Calculate.FPPBikeELG.newHandlebarsHeightPx+0.5))
end

--calc dimensions of ELG masks
function Calculate.WindshieldX()
	Calculate.FPPBikeELG.newWindshieldWidthPx = Calculate.FPPBikeELG.originalWindshieldWidthPx*(Calculate.FPPBikeELG.windshieldWidth/100.0)
	Calculate.FPPBikeELG.newWindshieldWidthPx = (math.floor(Calculate.FPPBikeELG.newWindshieldWidthPx+0.5))
end

--calc dimensions of ELG masks
function Calculate.WindshieldY()
	Calculate.FPPBikeELG.newWindshieldHeightPx = Calculate.FPPBikeELG.originalWindshieldHeightPx*(Calculate.FPPBikeELG.windshieldHeight/100.0)
	Calculate.FPPBikeELG.newWindshieldHeightPx = (math.floor(Calculate.FPPBikeELG.newWindshieldHeightPx+0.5))
end

function Calculate.SetELGDefault()
	Calculate.FPPBikeELG.handlebarsHeight = 170
	Calculate.FPPBikeELG.windshieldWidth = 120
	Calculate.FPPBikeELG.windshieldHeight = 300
	Calculate.WindshieldX()
	Calculate.WindshieldY()
	Calculate.HandlebarsY()
end

--calc X margin for vignette
function Calculate.VignetteCalcMarginX()
	local vignetteSizeChangeX = nil

	vignetteSizeChangeX = Calculate.FPPOnFoot.vignetteFootSizeX - Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeX
	Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX = 100 - vignetteSizeChangeX
	Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX = 100 + vignetteSizeChangeX
	if Calculate.FPPOnFoot.vignetteFootMarginLeft < Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX then
		Calculate.FPPOnFoot.vignetteFootMarginLeft = Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginX
	end
	if Calculate.FPPOnFoot.vignetteFootMarginLeft > Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX  then
		Calculate.FPPOnFoot.vignetteFootMarginLeft = Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginX
	end
	Calculate.VignettePosX()
end

--calc Y margin for vignette
function Calculate.VignetteCalcMarginY()
	local vignetteSizeChangeY = nil

	vignetteSizeChangeY = Calculate.FPPOnFoot.vignetteFootSizeY - Calculate.FPPOnFoot.VignetteEditor.vignetteMinSizeY
	Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY = 100 - vignetteSizeChangeY
	Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY = 100 + vignetteSizeChangeY
	if Calculate.FPPOnFoot.vignetteFootMarginTop < Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY then
		Calculate.FPPOnFoot.vignetteFootMarginTop = Calculate.FPPOnFoot.VignetteEditor.vignetteMinMarginY
	end
	if Calculate.FPPOnFoot.vignetteFootMarginTop > Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY  then
		Calculate.FPPOnFoot.vignetteFootMarginTop = Calculate.FPPOnFoot.VignetteEditor.vignetteMaxMarginY
	end
	Calculate.VignettePosY()
end

--calc x size of vignette
function Calculate.VignetteX()
	Calculate.FPPOnFoot.newVignetteFootSizeXPx = Calculate.FPPOnFoot.originalVignetteFootSizeXPx*(Calculate.FPPOnFoot.vignetteFootSizeX/100.0)
	Calculate.FPPOnFoot.newVignetteFootSizeXPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeXPx+0.5))
	-- print("Vignette Size X",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.newVignetteFootSizeXPx)
end

--calc y size of vignette
function Calculate.VignetteY()
	Calculate.FPPOnFoot.newVignetteFootSizeYPx = Calculate.FPPOnFoot.originalVignetteFootSizeYPx*(Calculate.FPPOnFoot.vignetteFootSizeY/100.0)
	Calculate.FPPOnFoot.newVignetteFootSizeYPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeYPx+0.5))
	-- print("Vignette Size Y",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
end

--calc x margin of vignette
function Calculate.VignettePosX()
	Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx*(Calculate.FPPOnFoot.vignetteFootMarginLeft/100.0)
	Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx+0.5))
	-- print("Vignette Pos X",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.newVignetteFootMarginLeftPx)
end

--calc y margin of vignette
function Calculate.VignettePosY()
	Calculate.FPPOnFoot.newVignetteFootMarginTopPx = Calculate.FPPOnFoot.originalVignetteFootMarginTopPx*(Calculate.FPPOnFoot.vignetteFootMarginTop/100.0)
	Calculate.FPPOnFoot.newVignetteFootMarginTopPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginTopPx+0.5))
	-- print("Vignette Pos Y",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.newVignetteFootMarginTopPx)
end

function Calculate.SetVignetteDefault()
	Calculate.FPPOnFoot.vignetteFootMarginLeft = 100
	Calculate.FPPOnFoot.vignetteFootMarginTop = 80
	Calculate.FPPOnFoot.vignetteFootSizeX = 120
	Calculate.FPPOnFoot.vignetteFootSizeY = 120
	Calculate.VignettePosX()
	Calculate.VignettePosY()
	Calculate.VignetteX()
	Calculate.VignetteY()
end

return Calculate