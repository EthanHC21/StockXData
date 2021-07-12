import JSON
import Dates

function getGraph(JSONs)

    # preallocate return array
    graphs = Array{Array{Array{T,1} where T,1}, 1}(undef, length(JSONs));

    # count
    cnt = 1;

    for i = 1:length(JSONs)

        f = JSONs[i];

        # preallocate size of arrays for sale price and time
        salePrice = zeros(Float32, length(f["series"][1]["data"])) # max for UInt16 is 65535
        saleDate = zeros(Dates.DateTime, length(f["series"][1]["data"]))

        # loop through the array and get the data
        for i = 1:(length(f["series"][1]["data"]))
            saleDate[i] = Dates.unix2datetime(floor(f["series"][1]["data"][i][1]/1000)) # scope issue, will be fixed later
            salePrice[i] = f["series"][1]["data"][i][2] # scope issue, will be fixed later
        end

        # add these to the return array
        graphs[cnt] = [saleDate, salePrice];

        # C O U N T regardless
        cnt += 1;

    end

    return graphs;

end