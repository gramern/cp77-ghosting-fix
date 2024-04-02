--FrameGen Ghosting Fix 2.18.0-alpha

local Calculate = {
    ScreenDetection = {
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

local defaultLogTitle = "[FrameGen Ghosting 'Fix']"

function Calculate.CalcAspectRatio()
    FGGFreswidth, FGGFresheight = GetDisplayResolution();
	FGGFaspectratio = FGGFreswidth / FGGFresheight
end

--get the game's aspect ratio
function Calculate.GetAspectRatio()
	if FGGFaspectratio <= 1.59 then
		Calculate.ScreenDetection.FGGFscreentype = "4:3"
	elseif FGGFaspectratio >= 1.6 and FGGFaspectratio <= 1.7 then
		Calculate.ScreenDetection.FGGFscreentype = "16:10"
	elseif FGGFaspectratio >= 2.2 and FGGFaspectratio <= 3.4 then
		Calculate.ScreenDetection.FGGFscreentype = "21:9"
	elseif FGGFaspectratio >= 3.41 then
		Calculate.ScreenDetection.FGGFscreentype = "32:9"
	end
	-- print(defaultLogTitle,FGGFreswidth,"x",FGGFresheight,"is your screen resolution. Make sure you're using the",FGGFscreentype,"edition of the mod.")
end

function Calculate.SetMasksOrgSizes()
	if Calculate.ScreenDetection.FGGFscreentype == "16:10" then
		Calculate.FPPBikeELG.originalHandlebarsHeightPx = 1150
	elseif Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPBikeELG.originalHandlebarsHeightPx = 1200
		Calculate.FPPBikeELG.originalWindshieldHeightPx = 900
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
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 6460
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
	elseif Calculate.ScreenDetection.FGGFscreentype == "32:9" then
		Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx = 1920
		Calculate.FPPOnFoot.originalVignetteFootMarginTopPx = 1080
		Calculate.FPPOnFoot.originalVignetteFootSizeXPx = 9680
		Calculate.FPPOnFoot.originalVignetteFootSizeYPx = 2560
	end
end

function Calculate.SetVignetteAimSize()
	if Calculate.ScreenDetection.FGGFscreentype == "4:3" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 3840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 3072
	elseif Calculate.ScreenDetection.FGGFscreentype == "16:10" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 3840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2640
	elseif Calculate.ScreenDetection.FGGFscreentype == "21:9" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 4840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2440
	elseif Calculate.ScreenDetection.FGGFscreentype == "32:9" then
		Calculate.FPPOnFoot.vignetteAimFootSizeXPx = 4840
		Calculate.FPPOnFoot.vignetteAimFootSizeYPx = 2440
	end
end

--calc dimensions of ELG masks
function Calculate.HandlebarsY()
	Calculate.FPPBikeELG.newHandlebarsHeightPx = Calculate.FPPBikeELG.originalHandlebarsHeightPx*(Calculate.FPPBikeELG.handlebarsHeight/100.0)
	Calculate.FPPBikeELG.newHandlebarsHeightPx = (math.floor(Calculate.FPPBikeELG.newHandlebarsHeightPx+0.5))
	-- print(defaultLogTitle,"Handelbars AG mask height is scaled",handlebarsHeight,"%",'(',newHandlebarsHeightPx,'px)')
end

function Calculate.WindshieldX()
	Calculate.FPPBikeELG.newWindshieldWidthPx = Calculate.FPPBikeELG.originalWindshieldWidthPx*(Calculate.FPPBikeELG.windshieldWidth/100.0)
	Calculate.FPPBikeELG.newWindshieldWidthPx = (math.floor(Calculate.FPPBikeELG.newWindshieldWidthPx+0.5))
	-- print(defaultLogTitle,"Windshield AG mask width is scaled",windshieldWidth,"%.",'(',newWindshieldWidthPx,'px)')
end

function Calculate.WindshieldY()
	Calculate.FPPBikeELG.newWindshieldHeightPx = Calculate.FPPBikeELG.originalWindshieldHeightPx*(Calculate.FPPBikeELG.windshieldHeight/100.0)
	Calculate.FPPBikeELG.newWindshieldHeightPx = (math.floor(Calculate.FPPBikeELG.newWindshieldHeightPx+0.5))
	-- print(defaultLogTitle,"Windshield AG mask height is scaled",windshieldHeight,"%.",'(',newWindshieldHeightPx,'px)')
end

function Calculate.SetELGDefault()
	Calculate.FPPBikeELG.handlebarsHeight = 170
	Calculate.FPPBikeELG.windshieldWidth = 120
	Calculate.FPPBikeELG.windshieldHeight = 300
	Calculate.WindshieldX()
	Calculate.WindshieldY()
	Calculate.HandlebarsY()
end

-- calc dimensions of vignette
function Calculate.VignettePosX()
	Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = Calculate.FPPOnFoot.originalVignetteFootMarginLeftPx*(Calculate.FPPOnFoot.vignetteFootMarginLeft/100.0)
	Calculate.FPPOnFoot.newVignetteFootMarginLeftPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginLeftPx+0.5))
	print(defaultLogTitle,"Vignette scaled",Calculate.FPPOnFoot.vignetteFootMarginLeft, Calculate.FPPOnFoot.newVignetteFootMarginLeftPx)
end

function Calculate.VignettePosY()
	Calculate.FPPOnFoot.newVignetteFootMarginTopPx = Calculate.FPPOnFoot.originalVignetteFootMarginTopPx*(Calculate.FPPOnFoot.vignetteFootMarginTop/100.0)
	Calculate.FPPOnFoot.newVignetteFootMarginTopPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootMarginTopPx+0.5))
	print(defaultLogTitle,"Vignette scaled",Calculate.FPPOnFoot.vignetteFootMarginTop, Calculate.FPPOnFoot.newVignetteFootMarginTopPx)
end

function Calculate.VignetteX()
	Calculate.FPPOnFoot.newVignetteFootSizeXPx = Calculate.FPPOnFoot.originalVignetteFootSizeXPx*(Calculate.FPPOnFoot.vignetteFootSizeX/100.0)
	Calculate.FPPOnFoot.newVignetteFootSizeXPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeXPx+0.5))
	print(defaultLogTitle,"Vignette scaled",Calculate.FPPOnFoot.vignetteFootSizeX, Calculate.FPPOnFoot.newVignetteFootSizeXPx)
end

function Calculate.VignetteY()
	Calculate.FPPOnFoot.newVignetteFootSizeYPx = Calculate.FPPOnFoot.originalVignetteFootSizeYPx*(Calculate.FPPOnFoot.vignetteFootSizeY/100.0)
	Calculate.FPPOnFoot.newVignetteFootSizeYPx = (math.floor(Calculate.FPPOnFoot.newVignetteFootSizeYPx+0.5))
	print(defaultLogTitle,"Vignette scaled",Calculate.FPPOnFoot.vignetteFootSizeY, Calculate.FPPOnFoot.newVignetteFootSizeYPx)
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