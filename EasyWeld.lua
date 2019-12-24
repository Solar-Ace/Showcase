local ChangeHistoryService = game:GetService("ChangeHistoryService")

local toolbar = plugin:CreateToolbar("EasyWeld")
local partWeldButton = toolbar:CreateButton("Weld To Selected Part", "Weld the rest of the parts in the selected part's model to the selected part", "http://www.roblox.com/asset/?id=2662516609")
local pointerWeldButton = toolbar:CreateButton("Weld To Clicked Part","Weld the rest of the parts in the mouse clicked part's model to the part","http://www.roblox.com/asset/?id=2662489714")

local mouse = plugin:GetMouse()

local selectionService = game:GetService("Selection")

local function primeForPartWeld()
	local selected = selectionService:Get()
	if #selected == 1 then
		if selected[1].Parent ~= nil  then
			if selected[1].Parent.ClassName == "Model" then
				if selected[1]:IsA("BasePart") then
					ChangeHistoryService:SetWaypoint("Welded model")
					recursiveWeld(selected[1].Parent, selected[1])
					print('EasyWeld: Successfully welded model.')
				else
					warn('!! EasyWeld: Selected object is not a part. Please select a part inside a model! (Plugin requires selection of a main part to weld other parts to.')
				end
			else
				warn('!! EasyWeld: Selected object is not inside a model! Please select a part inside a model! (Plugin requires that parts are stored inside a model.')
			end
		else
			warn('!! EasyWeld: Selected object is not inside a model! Please select a part inside a model! (Plugin requires a parent model to search for other parts.)')
		end
	else
		warn('!! EasyWeld: Selected more than one object! Please select a SINGLE part inside a model. (Plugin requires a main part to weld other parts to.)')
	end
end

local function primeMouse()
	if plugin:IsActivated() == false then
		plugin:Activate(true)
		if mouse ~= nil then
			mouse.Button1Down:Connect(function()
				local target = mouse.Target
				if target ~= nil then
					if target.Parent ~= nil and target.Parent.ClassName == "Model" then
						if target:IsA("BasePart") then
							recursiveWeld(target.Parent,target)
							plugin:Deactivate()
						end
					else
						warn('!! EasyWeld: Targetted object is not inside a model. Please select a part inside a model to weld to. (Plugin requires a main part to weld other parts to.)')
					end
				else
					warn('!! EasyWeld: No object clicked. Please reactivate welding to mouse target and click on a part in a model to weld. (Plugin requires a selected part.)')
				end
			end)
		else
			print('!! EasyWeld: CRITICAL: Could not find mouse! Something has gone wrong. Please relaunch EasyWeld or restart Roblox Studio. Sorry! (ROBLOX Studio error)')
		end
	else
		plugin:Deactivate()
	end
end


-- NO ERROR CHECKS! ASSUMES VALID INPUTS. DEVELOP TO HAVE CHECKS IF USED ELSEWHERE!!!
function recursiveWeld(model,mainPart)  --scrape every part in the model and weld it to main.
	for i,part in pairs(model:GetChildren()) do
		
		-- check for parts in parts...		
		if #part:GetChildren() ~= 0 then
			for j,child in pairs(part:GetChildren()) do
				recursiveWeld(child,mainPart)
			end
		end		
		
		if part:IsA("BasePart") and part ~= mainPart then
			local weld = Instance.new("WeldConstraint")
			weld.Parent = mainPart
			weld.Part0 = mainPart
			weld.Part1 = part

		end
	end
end

partWeldButton.Click:Connect(primeForPartWeld)
pointerWeldButton.Click:Connect(primeMouse)
--[[local mouse = plugin:GetMouse()


mouse.Button1Down:connect(function() -- Binds function to left click
	local target = mouse.Target
	if target then
		print("Target: " .. target.Name)
	end
	print("X: " .. mouse.X .. " Y: " .. mouse.Y)
end)]]
 