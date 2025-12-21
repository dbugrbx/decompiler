for _, Website in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("main"):WaitForChild("UI"):GetChildren()) do
	if typeof(Website) == "Instance" and string.sub(Website.Name, 1, 1) == "{" and string.sub(Website.Name, -1) == "}" and Website:GetAttribute("webcontent") == true then
		local FontMap = {
			["AmaticSC.json"] = "AmaticSC",
			["RomanAntique.json"] = "Antique",
			["PressStart2P.json"] = "Arcade",
			["Arial.json"] = "Arial",
			["Arimo.json"] = "Arimo",
			["Bangers.json"] = "Bangers",
			["AccanthisADFStd.json"] = "Bodoni",
			["BuilderSans.json"] = "BuilderSans",
			["ComicNeueAngular.json"] = "Cartoon",
			["Inconsolata.json"] = "Code",
			["Creepster.json"] = "Creepster",
			["DenkOne.json"] = "DenkOne",
			["Balthazar.json"] = "Fantasy",
			["Fondamento.json"] = "Fondamento",
			["FredokaOne.json"] = "FredokaOne",
			["Guru.json"] = "Garamond",
			["GothamSSm.json"] = "Gotham",
			["GrenzeGotisch.json"] = "GrenzeGotisch",
			["HighwayGothic.json"] = "Highway",
			["IndieFlower.json"] = "IndieFlower",
			["JosefinSans.json"] = "JosefinSans",
			["Jura.json"] = "Jura",
			["Kalam.json"] = "Kalam",
			["LegacyArial.json"] = "Legacy",
			["LuckiestGuy.json"] = "LuckiestGuy",
			["Merriweather.json"] = "Merriweather",
			["Michroma.json"] = "Michroma",
			["Nunito.json"] = "Nunito",
			["Oswald.json"] = "Oswald",
			["PatrickHand.json"] = "PatrickHand",
			["PermanentMarker.json"] = "PermanentMarker",
			["Roboto.json"] = "Roboto",
			["RobotoCondensed.json"] = "RobotoCondensed",
			["RobotoMono.json"] = "RobotoMono",
			["Sarpanch.json"] = "Sarpanch",
			["SciFi.json"] = "SciFi",
			["SourceSansPro.json"] = "SourceSans",
			["SpecialElite.json"] = "SpecialElite",
			["TitilliumWeb.json"] = "TitilliumWeb",
			["Ubuntu.json"] = "Ubuntu",
		}
		local FontWeightMap = {
			[Enum.FontWeight.Thin]       = "Thin",
			[Enum.FontWeight.ExtraLight] = "ExtraLight",
			[Enum.FontWeight.Light]      = "Light",
			[Enum.FontWeight.Regular]    = "Regular",
			[Enum.FontWeight.Medium]     = "Medium",
			[Enum.FontWeight.SemiBold]   = "SemiBold",
			[Enum.FontWeight.Bold]       = "Bold",
			[Enum.FontWeight.ExtraBold]  = "ExtraBold",
			[Enum.FontWeight.Heavy]      = "Heavy",
		}
		local FontStyleMap = {
			[Enum.FontStyle.Normal] = "Normal",
			[Enum.FontStyle.Italic] = "Italic",
		}
		local function Encode(Value)
			local function IsArray(Table)
				local Index = 1
				for Key in pairs(Table) do
					if Key ~= Index then return false end
					Index += 1
				end
				return true
			end
			local TableType = typeof(Value)
			if TableType == "nil" then return "null"
			elseif TableType == "boolean" then return tostring(Value)
			elseif TableType == "number" then return tostring(Value)
			elseif TableType == "string" then
				return "\"" .. string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(Value, "\\", "\\\\"), "\"", "\\\""), "\n", "\\n"), "\r", "\\r"), "\t", "\\t") .. "\""
			elseif TableType == "table" then
				if IsArray(Value) then
					local Out = {}
					for Index = 1, #Value do
						Out[#Out + 1] = Encode(Value[Index])
					end
					return "[" .. table.concat(Out, ",") .. "]"
				else
					local Out = {}
					for Key, Value in pairs(Value) do
						Out[#Out + 1] = "\"" .. string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tostring(Key), "\\", "\\\\"), "\"", "\\\""), "\n", "\\n"), "\r", "\\r"), "\t", "\\t") .. "\":" .. Encode(Value)
					end
					return "{" .. table.concat(Out, ",") .. "}"
				end
			end
		end
		local function Color3ToHexadecimal(Color)
			return string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
		end
		local function UDim2ToString(UDim2)
			return "{" .. UDim2.X.Scale .. ", " .. UDim2.X.Offset .. "},{" .. UDim2.Y.Scale .. ", " .. UDim2.Y.Offset .. "}"
		end
		local function GenerateGlobalIdentification()
			local Character1 = string.char(math.random(32, 126))
			local Character2 = string.char(math.random(32, 126))
			return Character1 .. Character2
		end
		local function GetFontIdentifier(FontFace)
			local Family = tostring(FontFace.Family)
			local JavaScriptObjectNotation = string.match(Family, "fonts/families/(.+%.json)")
			if JavaScriptObjectNotation then
				return JavaScriptObjectNotation
			end
			local Identifier = string.match(Family, "rbxassetid://(%d+)")
			if Identifier then
				return Identifier
			end
			return Family
		end
		local function ResolveFontFamily(FontFace)
			local Identifier = GetFontIdentifier(FontFace)
			if tonumber(Identifier) then
				return Identifier
			end
			return FontMap[Identifier] or Identifier
		end
		local function GetImageInfo(Image)
			if typeof(Image) ~= "string" or Image == "" then
				return nil, nil
			end
			local Identifier = string.match(tostring(Image), "rbxassetid://(%d+)")
			if Identifier then
				return Image, Identifier
			end
			Identifier = string.match(tostring(Image), "asset/%?id=(%d+)")
			if Identifier then
				return Image, Identifier
			end
			if string.match(tostring(Identifier), "^rbxasset://") then
				return Image, nil
			end
			return Image, nil
		end
		local function BuildElementJavaScriptObjectNotation(Element)
			if Element.Name == "_donation" or Element.Name == "_link" or Element.ClassName == "Sound" or Element.ClassName == "SoundGroup" then
				return nil
			end
			local ElementJavaScriptObjectNotation = {globalid = GenerateGlobalIdentification()}
			if Element:GetAttribute("type") == "donation" then
				ElementJavaScriptObjectNotation["class"] = Element.ClassName .. "?donation"
			elseif Element:GetAttribute("type") == "link" then
				ElementJavaScriptObjectNotation["class"] = Element.ClassName .. "?link"
			elseif Element.ClassName == "ModuleScript" then
				ElementJavaScriptObjectNotation["class"] = "script"
			else
				ElementJavaScriptObjectNotation["class"] = Element.ClassName
			end
			if Element.Name ~= "WebRendererObject" then
				ElementJavaScriptObjectNotation["alias"] = Element.Name
			end
			if Element.ClassName == "Frame" then
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "TextLabel" then
				if ResolveFontFamily(Element.FontFace) ~= "SourceSans" then
					ElementJavaScriptObjectNotation["font"] = ResolveFontFamily(Element.FontFace)
				end
				if FontStyleMap[Element.FontFace.Style] ~= "Normal" then
					ElementJavaScriptObjectNotation["font_style"] = FontStyleMap[Element.FontFace.Style]
				end
				if FontWeightMap[Element.FontFace.Weight] ~= "Regular" then
					ElementJavaScriptObjectNotation["font_weight"] = FontWeightMap[Element.FontFace.Weight]
				end
				if Element.TextScaled then
					ElementJavaScriptObjectNotation["font_size"] = "scaled"
				else
					ElementJavaScriptObjectNotation["font_size"] = tostring(Element.TextSize)
				end
				if Element.TextColor3 ~= Color3.new(0, 0, 0) then
					ElementJavaScriptObjectNotation["font_color"] = Color3ToHexadecimal(Element.TextColor3)
				end
				if Element.TextTransparency ~= 0 then
					ElementJavaScriptObjectNotation["font_transparency"] = tostring(Element.TextTransparency)
				end
				if Element.TextXAlignment == Enum.TextXAlignment.Left then
					ElementJavaScriptObjectNotation["align_x"] = "Left"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Center then
					ElementJavaScriptObjectNotation["align_x"] = "Center"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Right then
					ElementJavaScriptObjectNotation["align_x"] = "Right"
				end
				if Element.TextYAlignment == Enum.TextYAlignment.Top then
					ElementJavaScriptObjectNotation["align_y"] = "Top"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Center then
					ElementJavaScriptObjectNotation["align_y"] = "Center"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Bottom then
					ElementJavaScriptObjectNotation["align_y"] = "Bottom"
				end
				if Element.LineHeight ~= 1 then
					ElementJavaScriptObjectNotation["line_height"] = tostring(Element.LineHeight)
				end
				if Element.TextWrapped ~= true then
					ElementJavaScriptObjectNotation["wrap"] = tostring(Element.TextWrapped)
				end
				if Element.TextTruncate == Enum.TextTruncate.None then
					ElementJavaScriptObjectNotation["truncate"] = "None"
				elseif Element.TextTruncate == Enum.TextTruncate.SplitWord then
					ElementJavaScriptObjectNotation["truncate"] = "SplitWord"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				ElementJavaScriptObjectNotation["text"] = Element.Text
				ElementJavaScriptObjectNotation["rich"] = tostring(Element.RichText)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "ImageLabel" then
				if Element.ImageTransparency ~= 0 then
					ElementJavaScriptObjectNotation["image_transparency"] = tostring(Element.ImageTransparency)
				end
				if Element.ImageColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["image_color"] = Color3ToHexadecimal(Element.ImageColor3)
				end
				if Element.ScaleType == Enum.ScaleType.Crop then
					ElementJavaScriptObjectNotation["scale_type"] = "Crop"
				elseif Element.ScaleType == Enum.ScaleType.Fit then
					ElementJavaScriptObjectNotation["scale_type"] = "Fit"
				elseif Element.ScaleType == Enum.ScaleType.Slice then
					ElementJavaScriptObjectNotation["scale_type"] = "Slice"
				elseif Element.ScaleType == Enum.ScaleType.Tile then
					ElementJavaScriptObjectNotation["scale_type"] = "Tile"
				end
				if Element.ResampleMode == Enum.ResamplerMode.Pixelated then
					ElementJavaScriptObjectNotation["resample_mode"] = "Pixelated"
				else
					ElementJavaScriptObjectNotation["resample_mode"] = "Default"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				ElementJavaScriptObjectNotation["image"] = Element.Image
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "TextButton" and Element:GetAttribute("type") == "link" then
				if Element:GetAttribute("href") then
					ElementJavaScriptObjectNotation["href"] = Element:GetAttribute("href")
				end
				if Element:GetAttribute("new_tab") then
					ElementJavaScriptObjectNotation["new_tab"] = tostring(Element:GetAttribute("new_tab"))
				end
				if ResolveFontFamily(Element.FontFace) ~= "SourceSans" then
					ElementJavaScriptObjectNotation["font"] = ResolveFontFamily(Element.FontFace)
				end
				if FontStyleMap[Element.FontFace.Style] ~= "Normal" then
					ElementJavaScriptObjectNotation["font_style"] = FontStyleMap[Element.FontFace.Style]
				end
				if FontWeightMap[Element.FontFace.Weight] ~= "Regular" then
					ElementJavaScriptObjectNotation["font_weight"] = FontWeightMap[Element.FontFace.Weight]
				end
				if Element.TextScaled then
					ElementJavaScriptObjectNotation["font_size"] = "scaled"
				else
					ElementJavaScriptObjectNotation["font_size"] = tostring(Element.TextSize)
				end
				if Element.TextColor3 ~= Color3.new(0, 0, 0) then
					ElementJavaScriptObjectNotation["font_color"] = Color3ToHexadecimal(Element.TextColor3)
				end
				if Element.TextTransparency ~= 0 then
					ElementJavaScriptObjectNotation["font_transparency"] = tostring(Element.TextTransparency)
				end
				if Element.TextXAlignment == Enum.TextXAlignment.Left then
					ElementJavaScriptObjectNotation["align_x"] = "Left"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Center then
					ElementJavaScriptObjectNotation["align_x"] = "Center"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Right then
					ElementJavaScriptObjectNotation["align_x"] = "Right"
				end
				if Element.TextYAlignment == Enum.TextYAlignment.Top then
					ElementJavaScriptObjectNotation["align_y"] = "Top"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Center then
					ElementJavaScriptObjectNotation["align_y"] = "Center"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Bottom then
					ElementJavaScriptObjectNotation["align_y"] = "Bottom"
				end
				if Element.LineHeight ~= 1 then
					ElementJavaScriptObjectNotation["line_height"] = tostring(Element.LineHeight)
				end
				if Element.TextTruncate == Enum.TextTruncate.None then
					ElementJavaScriptObjectNotation["truncate"] = "None"
				elseif Element.TextTruncate == Enum.TextTruncate.SplitWord then
					ElementJavaScriptObjectNotation["truncate"] = "SplitWord"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				if Element.TextWrapped ~= true then
					ElementJavaScriptObjectNotation["wrap"] = tostring(Element.TextWrapped)
				end
				ElementJavaScriptObjectNotation["text"] = Element.Text
				ElementJavaScriptObjectNotation["auto_color"] = tostring(Element.AutoButtonColor)
				ElementJavaScriptObjectNotation["rich"] = tostring(Element.RichText)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			elseif Element.ClassName == "TextButton" and Element:GetAttribute("type") == "donation" then
				if Element:GetAttribute("product") ~= 0 then
					ElementJavaScriptObjectNotation["product"] = Element:GetAttribute("product")
				end
				if Element:GetAttribute("product_type") == 0 then
					ElementJavaScriptObjectNotation["product_type"] = "Asset"
				elseif Element:GetAttribute("product_type") == 1 then
					ElementJavaScriptObjectNotation["product_type"] = "GamePass"
				elseif Element:GetAttribute("product_type") == 2 then
					ElementJavaScriptObjectNotation["product_type"] = "Product"
				end
				if Element:GetAttribute("href") then
					ElementJavaScriptObjectNotation["thanks_href"] = Element:GetAttribute("href")
				end
				if ResolveFontFamily(Element.FontFace) ~= "SourceSans" then
					ElementJavaScriptObjectNotation["font"] = ResolveFontFamily(Element.FontFace)
				end
				if FontStyleMap[Element.FontFace.Style] ~= "Normal" then
					ElementJavaScriptObjectNotation["font_style"] = FontStyleMap[Element.FontFace.Style]
				end
				if FontWeightMap[Element.FontFace.Weight] ~= "Regular" then
					ElementJavaScriptObjectNotation["font_weight"] = FontWeightMap[Element.FontFace.Weight]
				end
				if Element.TextScaled then
					ElementJavaScriptObjectNotation["font_size"] = "scaled"
				else
					ElementJavaScriptObjectNotation["font_size"] = tostring(Element.TextSize)
				end
				if Element.TextColor3 ~= Color3.new(0, 0, 0) then
					ElementJavaScriptObjectNotation["font_color"] = Color3ToHexadecimal(Element.TextColor3)
				end
				if Element.TextTransparency ~= 0 then
					ElementJavaScriptObjectNotation["font_transparency"] = tostring(Element.TextTransparency)
				end
				if Element.TextXAlignment == Enum.TextXAlignment.Left then
					ElementJavaScriptObjectNotation["align_x"] = "Left"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Center then
					ElementJavaScriptObjectNotation["align_x"] = "Center"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Right then
					ElementJavaScriptObjectNotation["align_x"] = "Right"
				end
				if Element.TextYAlignment == Enum.TextYAlignment.Top then
					ElementJavaScriptObjectNotation["align_y"] = "Top"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Center then
					ElementJavaScriptObjectNotation["align_y"] = "Center"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Bottom then
					ElementJavaScriptObjectNotation["align_y"] = "Bottom"
				end
				if Element.LineHeight ~= 1 then
					ElementJavaScriptObjectNotation["line_height"] = tostring(Element.LineHeight)
				end
				if Element.TextTruncate == Enum.TextTruncate.None then
					ElementJavaScriptObjectNotation["truncate"] = "None"
				elseif Element.TextTruncate == Enum.TextTruncate.SplitWord then
					ElementJavaScriptObjectNotation["truncate"] = "SplitWord"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				if Element.TextWrapped ~= true then
					ElementJavaScriptObjectNotation["wrap"] = tostring(Element.TextWrapped)
				end
				ElementJavaScriptObjectNotation["text"] = Element.Text
				ElementJavaScriptObjectNotation["auto_color"] = tostring(Element.AutoButtonColor)
				ElementJavaScriptObjectNotation["rich"] = tostring(Element.RichText)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			elseif Element.ClassName == "TextButton" then
				if ResolveFontFamily(Element.FontFace) ~= "SourceSans" then
					ElementJavaScriptObjectNotation["font"] = ResolveFontFamily(Element.FontFace)
				end
				if FontStyleMap[Element.FontFace.Style] ~= "Normal" then
					ElementJavaScriptObjectNotation["font_style"] = FontStyleMap[Element.FontFace.Style]
				end
				if FontWeightMap[Element.FontFace.Weight] ~= "Regular" then
					ElementJavaScriptObjectNotation["font_weight"] = FontWeightMap[Element.FontFace.Weight]
				end
				if Element.TextScaled then
					ElementJavaScriptObjectNotation["font_size"] = "scaled"
				else
					ElementJavaScriptObjectNotation["font_size"] = tostring(Element.TextSize)
				end
				if Element.TextColor3 ~= Color3.new(0, 0, 0) then
					ElementJavaScriptObjectNotation["font_color"] = Color3ToHexadecimal(Element.TextColor3)
				end
				if Element.TextTransparency ~= 0 then
					ElementJavaScriptObjectNotation["font_transparency"] = tostring(Element.TextTransparency)
				end
				if Element.TextXAlignment == Enum.TextXAlignment.Left then
					ElementJavaScriptObjectNotation["align_x"] = "Left"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Center then
					ElementJavaScriptObjectNotation["align_x"] = "Center"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Right then
					ElementJavaScriptObjectNotation["align_x"] = "Right"
				end
				if Element.TextYAlignment == Enum.TextYAlignment.Top then
					ElementJavaScriptObjectNotation["align_y"] = "Top"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Center then
					ElementJavaScriptObjectNotation["align_y"] = "Center"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Bottom then
					ElementJavaScriptObjectNotation["align_y"] = "Bottom"
				end
				if Element.LineHeight ~= 1 then
					ElementJavaScriptObjectNotation["line_height"] = tostring(Element.LineHeight)
				end
				if Element.TextTruncate == Enum.TextTruncate.None then
					ElementJavaScriptObjectNotation["truncate"] = "None"
				elseif Element.TextTruncate == Enum.TextTruncate.SplitWord then
					ElementJavaScriptObjectNotation["truncate"] = "SplitWord"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				if Element.TextWrapped ~= true then
					ElementJavaScriptObjectNotation["wrap"] = tostring(Element.TextWrapped)
				end
				ElementJavaScriptObjectNotation["text"] = Element.Text
				ElementJavaScriptObjectNotation["auto_color"] = tostring(Element.AutoButtonColor)
				ElementJavaScriptObjectNotation["rich"] = tostring(Element.RichText)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "TextBox" then
				if ResolveFontFamily(Element.FontFace) ~= "SourceSans" then
					ElementJavaScriptObjectNotation["font"] = ResolveFontFamily(Element.FontFace)
				end
				if FontStyleMap[Element.FontFace.Style] ~= "Normal" then
					ElementJavaScriptObjectNotation["font_style"] = FontStyleMap[Element.FontFace.Style]
				end
				if FontWeightMap[Element.FontFace.Weight] ~= "Regular" then
					ElementJavaScriptObjectNotation["font_weight"] = FontWeightMap[Element.FontFace.Weight]
				end
				if Element.TextScaled then
					ElementJavaScriptObjectNotation["font_size"] = "scaled"
				else
					ElementJavaScriptObjectNotation["font_size"] = tostring(Element.TextSize)
				end
				if Element.TextColor3 ~= Color3.new(0, 0, 0) then
					ElementJavaScriptObjectNotation["font_color"] = Color3ToHexadecimal(Element.TextColor3)
				end
				if Element.TextTransparency ~= 0 then
					ElementJavaScriptObjectNotation["font_transparency"] = tostring(Element.TextTransparency)
				end
				if Element.TextXAlignment == Enum.TextXAlignment.Left then
					ElementJavaScriptObjectNotation["align_x"] = "Left"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Center then
					ElementJavaScriptObjectNotation["align_x"] = "Center"
				elseif Element.TextXAlignment == Enum.TextXAlignment.Right then
					ElementJavaScriptObjectNotation["align_x"] = "Right"
				end
				if Element.TextYAlignment == Enum.TextYAlignment.Top then
					ElementJavaScriptObjectNotation["align_y"] = "Top"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Center then
					ElementJavaScriptObjectNotation["align_y"] = "Center"
				elseif Element.TextYAlignment == Enum.TextYAlignment.Bottom then
					ElementJavaScriptObjectNotation["align_y"] = "Bottom"
				end
				if Element.LineHeight ~= 1 then
					ElementJavaScriptObjectNotation["line_height"] = tostring(Element.LineHeight)
				end
				if Element.TextWrapped ~= true then
					ElementJavaScriptObjectNotation["wrap"] = tostring(Element.TextWrapped)
				end
				if Element.TextTruncate == Enum.TextTruncate.None then
					ElementJavaScriptObjectNotation["truncate"] = "None"
				elseif Element.TextTruncate == Enum.TextTruncate.SplitWord then
					ElementJavaScriptObjectNotation["truncate"] = "SplitWord"
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.ClipsDescendants then
					ElementJavaScriptObjectNotation["canvas"] = tostring(Element.ClipsDescendants)
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				ElementJavaScriptObjectNotation["text"] = Element.Text
				ElementJavaScriptObjectNotation["placeholder"] = Element.PlaceholderText
				ElementJavaScriptObjectNotation["placeholder_color"] = Color3ToHexadecimal(Element.PlaceholderColor3)
				ElementJavaScriptObjectNotation["rich"] = tostring(Element.RichText)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "ScrollingFrame" then
				if Element.ScrollBarImageColor3 then
					ElementJavaScriptObjectNotation["scrollbar_color"] = Color3ToHexadecimal(Element.ScrollBarImageColor3)
				end
				if Element.ScrollBarImageTransparency ~= 0 then
					ElementJavaScriptObjectNotation["scrollbar_transparency"] = tostring(Element.ScrollBarImageTransparency)
				end
				if Element.ScrollBarThickness ~= 12 then
					ElementJavaScriptObjectNotation["scrollbar_thickness"] = tostring(Element.ScrollBarThickness)
				end
				if Element.BackgroundTransparency ~= 0 then
					ElementJavaScriptObjectNotation["background_transparency"] = tostring(Element.BackgroundTransparency)
				end
				if Element.BackgroundColor3 ~= Color3.new(1, 1, 1) then
					ElementJavaScriptObjectNotation["background_color"] = Color3ToHexadecimal(Element.BackgroundColor3)
				end
				if Element.Position ~= UDim2.new(0, 0, 0, 0) then
					ElementJavaScriptObjectNotation["position"] = UDim2ToString(Element.Position)
				end
				if Element.Rotation ~= 0 then
					ElementJavaScriptObjectNotation["rotation"] = tostring(Element.Rotation)
				end
				if Element.AnchorPoint ~= Vector2.new(0, 0) then
					ElementJavaScriptObjectNotation["anchor"] = Element.AnchorPoint.X .. ", " .. Element.AnchorPoint.Y
				end
				if Element.ZIndex ~= 0 then
					ElementJavaScriptObjectNotation["z_index"] = tostring(Element.ZIndex)
				end
				if Element:GetAttribute("Tooltip") then
					ElementJavaScriptObjectNotation["tooltip"] = Element:GetAttribute("Tooltip")
				end
				if Element.Visible then
					ElementJavaScriptObjectNotation["visible"] = tostring(Element.Visible)
				end
				ElementJavaScriptObjectNotation["canvassize"] = UDim2ToString(Element.CanvasSize)
				ElementJavaScriptObjectNotation["size"] = UDim2ToString(Element.Size)
			end
			if Element.ClassName == "UIAspectRatioConstraint" then
				if Element.AspectRatio ~= 1 then
					ElementJavaScriptObjectNotation["ratio"] = tostring(Element.AspectRatio)
				end
			end
			if Element.ClassName == "UIAspectRatioConstraint" then
				if Element.AspectRatio ~= 1 then
					ElementJavaScriptObjectNotation["ratio"] = tostring(Element.AspectRatio)
				end
			end
			if Element.ClassName == "UICorner" then
				ElementJavaScriptObjectNotation["radius"] = Element.CornerRadius.Scale .. ", " .. Element.CornerRadius.Offset
			end
			local ChildrenList = {}
			for _, Child in pairs(Element:GetChildren()) do
				local ChildJSON = BuildElementJavaScriptObjectNotation(Child)
				if ChildJSON then
					table.insert(ChildrenList, ChildJSON)
				end
			end
			if #ChildrenList > 0 then
				ElementJavaScriptObjectNotation["children"] = ChildrenList
			end
			return ElementJavaScriptObjectNotation
		end
		local JavaScriptObjectNotation = {background = Color3ToHexadecimal(Website.BackgroundColor3), webcontent = {}}
		for _, Element in pairs(Website:GetChildren()) do
			local ElementJavaScriptObjectNotation = BuildElementJavaScriptObjectNotation(Element)
			if ElementJavaScriptObjectNotation then
				table.insert(JavaScriptObjectNotation["webcontent"], ElementJavaScriptObjectNotation)
			end
		end
		setclipboard(Encode(JavaScriptObjectNotation))
	end
end
