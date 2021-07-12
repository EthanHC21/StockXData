function remUndef(JSONs, sizes)

    # counter to store how many real values there are
    cnt = 0;

    # loop through JSONs to find how many are assigned
    for i = 1:length(JSONs)
        
        if (isassigned(JSONs, i))
            cnt += 1;
        end

    end

    # preallocate new arrays
    retJSONs = Array{Dict{String,Any}, 1}(undef, cnt);
    retSizes = zeros(Float32, cnt);

    # reset count
    cnt = 0;

    # loop again and this time copy the values
    for i = 1:length(JSONs)
        
        if (isassigned(JSONs, i))

            cnt += 1;

            retJSONs[cnt] = JSONs[i];
            retSizes[cnt] = sizes[i];

        end

    end

    return[retJSONs, retSizes];

end