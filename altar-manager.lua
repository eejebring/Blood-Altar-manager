local chestName = "top"
local altarName = "left"

local chest = peripheral.wrap(chestName)
local altar = peripheral.wrap(altarName)

local slates = {
    { id = 'bloodmagic:blankslate', amount = 16, essence = 1000, input = 'forge:stone', slotNr = 19 },
    { id = 'bloodmagic:reinforcedslate', amount = 16, essence = 2000, input = 'bloodmagic:blankslate', slotNr = 20},
    { id = 'bloodmagic:imbuedslate', amount  =  16, essence = 5000, input = 'bloodmagic:reinforcedslate', slotNr= 21 },
    { id = 'bloodmagic:demonicslate', amount  =  16, essence = 15000, input = 'bloodmagic:imbuedslate', slotNr = 22 },
    { id = 'bloodmagic:etherealslate', amount = 16, essence = 30000, input = 'bloodmagic:demonicslate', slotNr = 23 }
}

local function slotHasTag(invSlot, itemTag)
    if invSlot == nil and itemTag == nil then
        return true
    elseif invSlot == nil then
        return false
    elseif itemTag == nil then
        return false
    end
    if invSlot.name == itemTag then
        return true
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
        if slotHasTag(inv.getItemDetail(slotNr), itemTag) then
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
    chest.pullItems(altarName, 1, 1, slotNr)
end

while true do
    local madeSlate = false
    if altar.getItemDetail(1) == nil then
        for index, slate in pairs(slates) do
            outputSlot = chest.getItemDetail(slate.slotNr)

            local needMoreSlate = outputSlot == nil or outputSlot.count < slate.amount
            local bloodTank = altar.tanks()
            local altarEssence = 0
            if #bloodTank ~= 0 then
                altarEssence = bloodTank[1].amount
            end
            if needMoreSlate and slate.essence < altarEssence then
                makeSlate(slate.id, slate.input, slate.slotNr)
                madeSlate = true
                break
            end
        end
        if not madeSlate then
            sleep(5)
        end
    end
end