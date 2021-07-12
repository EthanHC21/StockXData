import HTTP
import JSON
import DataStructures

function pullFromURL(url) # pulls SKUs and corresponding sizes from given StockX URL

    # DEBUG
    #println("The URL is " , url);

    # get the HTTP response from the page
    resp = HTTP.request("GET", url);
    # extract body and convert it to string
    httpBody = String(resp.body);

    # store the SKUs
    SKUs = DataStructures.MutableLinkedList{String}()
    # store the sizes
    sizes = DataStructures.MutableLinkedList{Float32}()

    # check whether there's an SKU in the thing (true here for valid link)
    contLoop = occursin("\"sku\":", httpBody);

    # hold the number of skus
    numSKUs = 0;

    # hold the ending location of the last SKU
    endSKU = 1;
    
    # find all locations of the SKU
    while(contLoop)
        
        # if the loop runs, we have an additional SKU, so increment
        numSKUs += 1;

        # get location of the string "SKU":
        skuLoc = findnext("\"sku\":", httpBody, endSKU);
        # store SKU (36 characters long (32 with 4 dashes))
        tempSKU = httpBody[(skuLoc[6] + 2):(skuLoc[6] + 37)];
        # add this to the linked list
        DataStructures.append!(SKUs, tempSKU);

        # make the string contain only the characters after the SKU
        endSKU = skuLoc[6] + 38;

        # assuming this is a shoe, we check if this isn't the first SKU, as it's the only one without a size
        if (numSKUs != 1)
            
            # get the location of the string "descripton":
            sizeLoc = findnext("\"description\":", httpBody, endSKU);
            # store a string that can contain a fractional size (max 4 characters)
            tempSize = httpBody[(sizeLoc[14] + 2):sizeLoc[14] + 5];

            # hold the location of the quote in the string
            quoteLoc = findfirst('\"', tempSize);
            # extract only what's before that
            if (!isnothing(quoteLoc))
                tempSize = tempSize[1:(quoteLoc - 1)];
            end
            
            # parse the float and add it to the list of sizes
            DataStructures.append!(sizes, parse(Float32, tempSize));
            
            # update the value of endSKU
            endSKU = sizeLoc[14] + 6;

        end

        # check if there's another SKU
        contLoop = occursin("\"sku\":", httpBody[endSKU:lastindex(httpBody)]);

    end

    # convert linked lists to arrays because linked lists are gross
    # counter
    cnt = 1;
    # preallocate SKU array
    retSKUs = zeros(Int16, numSKUs);
    # convert to a string (because that's what the SKUs are)
    retSKUs = string.(retSKUs);
    # loop
    for sku in SKUs

        # store this SKU in the non-gross array
        retSKUs[cnt] = sku;

        # increment counter
        cnt += 1;

    end

    # reset counter
    cnt = 1;
    # preallocate size array
    retSizes = zeros(Float32, numSKUs);
    # loop
    for size in sizes

        # store this SKU in the non-gross array
        retSizes[cnt+1] = size;

        # increment counter
        cnt += 1;

    end

    println("Pulled ", numSKUs, " SKUs")

    return [retSKUs, retSizes]
end