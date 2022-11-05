local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)

local integrator = peripheral.find("colonyIntegrator")

if integrator == nil then error("colonyIntegrator not found") end
if not integrator.isInColony then error("Block is not in a colony") end

function ClearMonitor()
    monitor.clear()
    monitor.setCursorPos(1,1)
end

function NewLine(currentLine)
    monitor.setCursorPos(1, currentLine) 
    return currentLine + 1
end

debug = false

if debug then
    ClearMonitor()
    local workOrders = integrator.getWorkOrders()
    local i = 0
    for index, value in pairs(workOrders[1]) do
        monitor.write(index .. ": " .. tostring(value))
        i = NewLine(i)
    end

    local workItems = integrator.getWorkOrderResources(workOrders[1]["id"])
    for index, value in pairs(workItems[1]) do
        monitor.write(index .. ": " .. tostring(value))
        i = NewLine(i)
    end
end

if not debug then
    while true do
        ClearMonitor()
        local workOrders = integrator.getWorkOrders()
        local i = 1
        for _, table in pairs(workOrders) do
            local workItems = integrator.getWorkOrderResources(table["id"])
            if workItems ~= nil then
                monitor.blit(table["buildingName"], string.rep("f", string.len(table["buildingName"])), string.rep("d", string.len(table["buildingName"])))
                i = NewLine(i)
                for _, value in pairs(workItems) do
                    if value["status"] ~= "NOT_NEEDED" then
                        monitor.write(value["displayName"] .. ": " .. value["available"] .. "/" .. value["needed"])
                        i = NewLine(i)
                    end
                end
            end
            
        end
        sleep(5) 
    end
    
end
