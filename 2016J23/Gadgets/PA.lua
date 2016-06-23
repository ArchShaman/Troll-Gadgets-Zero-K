  --Game Rules:
  -- * Loss of PAHQ results in termination.
  -- * PAHQ Spawns troll shit reinforcements every 90 seconds.
  -- * FFA causes "zombie" outbreak (cuz fun!)
  -- * ???

function gadget:GetInfo()
    return {
      name      = "Planetary Assault",
      desc      = "Kill the headquarters for fun and profit!",
      author    = "_Shaman",
      date      = "6/7/2016",
      license   = "Give credit or ELSE",
      layer     = 15,
      enabled   = true,
    }
end

local compatibility = false
local ffamode = false -- >:)

local defeatedteams = {}
local reinforcementtimer = {}
local teamstartpos = {}
local hqs = {}


local function DefeatTeam(id)
  
end


function gadget:Initialize()
  --First thing to do is to figure out the game's major version.
  local version = {}
  version[1],version[2],version[3] = string.byte(Game.version,1,3) -- take first three characters.
  local vers = string.char(version[1],version[2],version[3]) -- rebuild string
  vers = string.gsub(vers,".","") -- Got the version! As long as spring
  vers = tonumber(vers)
  if vers > 101 then
    compatibility = true
  end
end
    
  
function gadget:GameStart()
  -- Pick a random player from the ally team to act as the controller of the Planetary Assault Headquarters.
  local teamcount = #Spring.GetAllyTeamList()
  local chosenid = 0
  for i=1, teamcount do
    reinforcementtimer[i] = 5400
    local teamlist = Spring.GetTeamList(i)
    chosenid = teamlist[math.random(1,#teamlist)]
    local spawnpos = {}
    spawnpos[1],spawnpos[2],spawnpos[3] = Spring.GetTeamStartPosition(chosenid)
    local hqid = Spring.CreateUnit("headquarters",spawnpos[1],spawnpos[2],spawnpos[3],0,chosenid)
    hqs[hqid] = i
  end
end

function gadget:GameFrame(f)
  -- reinforcement counter --
  if f%30 == 0 then
  for i=1,#reinforcementtimer do
    if reinforcementtimer[i] == 0 and defeatedteams[i] == nil then
      reinforcementtimer[i] = 180
      Reinforce(i)
    elseif reinforcementtimer[i] > 0 then
      reinforcementtimer[i] = reinforcementtimer[i] - 1
    end
  end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
  if hqs[unitID] then
    Spring.Echo("game_message: WARNING: Ally Team " .. hq[unitID] .. "has lost their HQ!")
    defeatedteams[hqs[unitID]] = 1
    DefeatTeam(hqs[unitID])
    hqs[unitID] = nil
  end
end
