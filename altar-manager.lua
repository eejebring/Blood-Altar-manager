local chestName = "top"
local altarName = "left"

local chest = peripheral.wrap(chestName)
local altar = peripheral.wrap(altarName)

local slates = {
    { id = 'AWWayofTime:blankSlate', amount = 16, essence = 1000, input = 'forge:stone', slotNr = 20 },
    { id = 'AWWayofTime:reinforcedSlate', amount = 16, essence = 2000, input = 'AWWayofTime:blankSlate', slotNr = 21},
    { id = 'AWWayofTime:imbuedSlate', amount  =  16, essence = 5000, input = 'AWWayofTime:reinforcedSlate', slotNr= 22 },
    { id = 'AWWayofTime:demonicSlate', amount  =  16, essence = 15000, input = 'AWWayofTime:imbuedSlate', slotNr = 23 },
    { id = 'AWWayofTime:bloodMagicBaseItems:27', amount = 16, essence = 30000, input = 'AWWayofTime:demonicSlate', slotNr = 24 }
}

local function slotHasTag(invSlot, itemTag)
    if invSlot == nil and itemTag == nil then
        return true
    elseif invSlot == nil then
        return false
    elseif itemTag == nil then
        return false
    end
    for tagId, state in pairs(invSlot.tags) do
        if state and tagId == itemTag then
            return true
        end
    end
    return false
end

local function findSlotWithTag(itemTag, inv)
    for slotNr, slot in pairs(inv.list()) do
        if slotHasTag(slot, itemTag) then
            return slotNr
        end
    end
end

local function makeSlate (output, input, slotNr)
    local componentSlotNr = findSlotWithTag(input, chest)
    chest.pushItems(altarName, componentSlotNr, 1, 1)
    while altar.getItemDetail(1).name ~= output do
        sleep(0.4)
    end
    chest.pullItems(altarName        , 1, 1, slotNr)
end

while true do
    local madeSlate = false
    for index, slate in pairs(slates) do
        outputSlot = chest.getItemDetail(slate.slotNr)

        local needMoreSlate = outputSlot == nil or outputSlot.count < slate.amount
        local AlterEssence = altar.tanks()[1].amount

        if needMoreSlate and slate.essence < AlterEssence then
            makeSlate(slate.id, slate.input, slate.slotNr)
            madeSlate = true
            break
        end
    end     
    if not madeSlate then
        sleep(5)
    end
end