import DataStructures
import JSON
import HTTP

function pullJSONs(SKUs, interval)

    # preallocate return array
    JSONs = Array{Dict{String,Any}, 1}(undef, length(SKUs));

    # counter
    cnt = 1;

    for skuNum in SKUs

        # create the URL string
        urlStr = string("https://stockx.com/api/products/", skuNum, "/chart?start_date=all&end_date=2021-07-11&intervals=", interval, "&format=highstock&currency=USD&country=US");

        # actually get the response of the chart data
        resp = HTTP.request("GET", urlStr);

        # extract the body
        jsonBody = String(resp.body);
        # parse as JSON
        jsonChart = JSON.parse(jsonBody);

        if (!isnothing(jsonChart))
            # store this
            JSONs[cnt] = jsonChart;
        end

        # increment count
        cnt += 1;

    end

    return JSONs

end