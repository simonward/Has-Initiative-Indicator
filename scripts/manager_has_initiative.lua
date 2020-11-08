--
-- Has Initiative Indicator
--
--

function onInit()
  if User.isHost() then
    DB.addHandler("combattracker.list.*.active", "onUpdate", updateInititiativeIndicator);
    updateAllInititiativeIndicators();
  end
end

-- get widget
function getHasInitiativeWidget(nodeField)
  local widgetInitIndicator = nil;
  local nodeCT = nodeField;
  local tokenCT = CombatManager.getTokenFromCT(nodeCT);
  if (tokenCT) then
    widgetInitIndicator = tokenCT.findWidget("initiativeindicator");
    if not widgetInitIndicator then
      widgetInitIndicator = createWidget(tokenCT,nodeCT);
    end
  end
  return widgetInitIndicator;
end
-- create has initiative indicator widget if it doesn't exist.
function createWidget(tokenCT,nodeCT)
  local sInitiativeIconName = "token_has_initiative";
  local nWidth, nHeight = tokenCT.getSize();
  local nScale = tokenCT.getScale();
  local sName = DB.getValue(nodeCT,"name","Unknown");
  widgetInitIndicator = tokenCT.addBitmapWidget(sInitiativeIconName);
  widgetInitIndicator.setBitmap(sInitiativeIconName);
  widgetInitIndicator.setName("initiativeindicator");
  widgetInitIndicator.setTooltipText(sName .. " has initiative.");
  widgetInitIndicator.setPosition("top", 0, -2);

  if UtilityManager.isClientFGU() then
    widgetInitIndicator.setSize(110, 110); -- 110% size (slightly bigger than token)
  else
	widgetInitIndicator.setSize(nWidth-20, nHeight-20);
    --widgetInitIndicator.setSize(nWidth*3, nHeight*3);
  end
  
  return widgetInitIndicator;
end

-- show/hide widget
function setInitiativeIndicator(widgetInitIndicator,bShowINIT)
  if widgetInitIndicator then
    widgetInitIndicator.setVisible(bShowINIT);
  end
end

-- update has initiative first time start up
function updateAllInititiativeIndicators()
  for _,vChild in pairs(CombatManager.getCombatantNodes()) do
    local bActive = (DB.getValue(vChild,"active",0) == 1);
    setInitiativeIndicator(getHasInitiativeWidget(vChild),bActive);
  end
end
-- update has initiative for specific user
function updateInititiativeIndicator(nodeField)
  local nodeCT = nodeField.getParent();
  local bActive = (DB.getValue(nodeCT,"active",0) == 1);
  setInitiativeIndicator(getHasInitiativeWidget(nodeCT),bActive);
end
