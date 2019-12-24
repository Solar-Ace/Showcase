--[[ 
	Written by Hellhawk on Roblox.
--]]

local mlengthx = 25
local mlengthz = 25 -- these define the dimensions of the maze in cells (x for X axis, z for Z axis...)

function generatewalls(lengthx,lengthz) -- physically generates walls
	local maze = Instance.new("Model")  --create maze container model
	maze.Name = "Maze"
	maze.Parent = game.Workspace
	local posz = 0
	for b = 1,lengthz do
		posz = posz + 8
		for i = 1,lengthx do -- physically create the maze parts. initially, create a fully populated "grid". 
			local cell = Instance.new("Model") --Step1: make the floor/parent model of each maze cell.
			cell.Name = "Cell"
			cell.Parent = maze
			local floor = Instance.new("Part")
			floor.Name = "Floor"
			floor.Parent = cell
			floor.FormFactor = "Symmetric"
			floor.Size = Vector3.new(8,1,8)
			floor.Anchored = true
			floor.BrickColor = BrickColor.new("Bright blue")
			floor.TopSurface = "Smooth"
			floor.BottomSurface = "Smooth"
			floor.CFrame = CFrame.new(Vector3.new(0+(i*8),1,posz))
			local visited = Instance.new("IntValue") -- for checking whether or not the maze is "complete", check that all parts have been connected
			visited.Value = 0
			visited.Name = "Visited"
			visited.Parent = cell
			if b == 1 and i == 1 then -- distinguish first and last elements
				cell.Name = "Firstcell"
				elseif b == lengthz and i == lengthx then
				cell.Name = "Lastcell"
			end
			for u = 1,4 do -- Step 2: create walls for each cell.
				local wall = Instance.new("Part")
				wall.Name = "Wall" .. u
				wall.Parent = cell
				wall.BrickColor = BrickColor.new("Bright blue")
				wall.FormFactor = "Symmetric"
				wall.Size = Vector3.new(8,12,1)
				wall.CFrame = floor.CFrame * CFrame.new(0,wall.Size.Y/2,0)
				wall.Anchored = true
				wall.CFrame = wall.CFrame * CFrame.Angles(0,math.rad(90*u),0)
				wall.CFrame = wall.CFrame * CFrame.new(0,0,3.5)
				wall.TopSurface = "Smooth"
				wall.BottomSurface = "Smooth"
				if posz == 8 then -- IF STATEMENTS TO CHECK FOR BORDERS, i.e edge of map
					if u == 2 then
						wall.BrickColor = BrickColor.new("Medium stone grey")
						wall.Name = "Border"
					end
				end
				if i == 1 then
					if u == 3 then
						wall.BrickColor = BrickColor.new("Medium stone grey")
						wall.Name = "Border"
					end
				end
				if i == lengthx then
					if u == 1 then
						wall.BrickColor = BrickColor.new("Medium stone grey")
						wall.Name = "Border"
					end
				end
				if posz%(8*lengthz) == 0 then 
					if u == 4 then
						wall.BrickColor = BrickColor.new("Medium stone grey")
						wall.Name = "Border"
					end
				end  -- end if statements to check for borders
			end
			if i%7 == 0 then -- make it wait a little every 7 cell generations so it doesnt blow up
				wait()
			end
		end
	end
end

function generatemaze()  --the actual maze gen algorithm
	local m = game.Workspace.Maze 
	local startcell = nil
	local visitedcells = 0
	local totalcells = mlengthx * mlengthz
	local oldcells = {}

	if m ~= nil then  
		local c = m:children()
		local randnum = math.random(1,#c)
		for i = 1,#c do
			if i == randnum then
			--	c[i].Name = "Startcell"
				c[i].Floor.BrickColor = BrickColor.new("Bright green")
				c[i].Visited.Value = 1
				visitedcells = visitedcells +1
				startcell = c[i]
				table.insert(oldcells, 1,c[i]) 
			end
		end
		
		-- time to start 'cutting' the maze. WARNING: CONFUSION INBOUND
		local curcell = startcell 
		while visitedcells < totalcells do
			local nearbycells = {}

			for o = 1,#c do 
				-- check to see if this part of the list is adjacent to the currently evaluated cell, and has not been touched already:
				if (c[o].Floor.Position - curcell.Floor.Position).Magnitude <= c[o].Floor.Size.X and c[o].Visited.Value == 0 then 
					table.insert(nearbycells, #nearbycells+1, c[o]) 
				end
			end

			if #nearbycells >= 1 then --if untouched cell is adjacent,
				local pickcell = math.random(1,#nearbycells+1)	-- pick a random cell
				for ii = 1,#nearbycells do
					if ii == pickcell then
						nearbycells[ii].Visited.Value = 1
						visitedcells = visitedcells + 1
						nearbycells[ii].Floor.BrickColor = BrickColor.new("Bright red")
						--remove the appropriate walls (find which side based on position)
						if curcell.Floor.Position.X < nearbycells[ii].Floor.Position.X then
							curcell.Wall1:Remove()
							nearbycells[ii].Wall3:Remove()
							elseif curcell.Floor.Position.X > nearbycells[ii].Floor.Position.X then
							curcell.Wall3:Remove()
							nearbycells[ii].Wall1:Remove()
							elseif curcell.Floor.Position.Z > nearbycells[ii].Floor.Position.Z then
							curcell.Wall2:Remove()
							nearbycells[ii].Wall4:Remove()
							elseif curcell.Floor.Position.Z < nearbycells[ii].Floor.Position.Z then
							curcell.Wall4:Remove()
							nearbycells[ii].Wall2:Remove()
						end
						--"move" to the newly cut cell and repeat
						curcell = nearbycells[ii]
						table.insert(oldcells, #oldcells,curcell)
					end
				end
			end
			if #nearbycells == 0 then -- "backpedal", go backwards until an untouched cell is found.
				curcell.Floor.BrickColor = BrickColor.new("Bright yellow") --indicate backpedalling
				table.remove(oldcells, #oldcells)
				if #oldcells >= 1 then
					curcell = oldcells[#oldcells - 1]
					else
					curcell = oldcells[#oldcells + 1]
				end
			end
			if visitedcells%7 == 0 then -- make it wait a little every 7 cell generations so it doesnt crash the game
				wait()
			end
		end
	end
end

--[[  unfinished code
function createspawns() 
	local maze = game.Workspace.Maze
	if maze ~=nil then
		local c = maze:children()
		for i = 1,#c do
			
		end
	end
end
]]-- 

--create maze
generatewalls(mlengthx,mlengthz)
wait()
generatemaze()
wait()
createspawns()

print("Finished! :D")