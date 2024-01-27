local function populateTable( newTable, path )
    -- Path for the file to read
    local path = system.pathForFile( path, system.ResourceDirectory )

    -- Open the file handle
    local file, errorString = io.open( path, "r" )

    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Output lines
        for line in file:lines() do
            table.insert( newTable, line )
            -- print( line )
        end
        -- Close the file handle
        io.close( file )
    end

    file = nil
end

local function shuffleTable( tbl )
    for i = #tbl, 2, -1 do
      local j = math.random( i )
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

return { populateTable = populateTable, shuffleTable = shuffleTable }
