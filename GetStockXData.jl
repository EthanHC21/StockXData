include("PullSKUsAndSizes.jl");
include("PullJSONs.jl");
include("PullGraphData.jl");
include("RemUndef.jl");
import Dates;

# get the frequency
println("Enter desired frequency (number of data points): ")
frequency = parse(Int64, readline());

# get URL
println("Enter StockX Shoe URL:");
URL = readline();

# get the SKUs and Sizes
pulled = pullFromURL(URL);
SKUs = pulled[1];
sizes = pulled[2];

# pull the JSONs from the SKUs
JSONs = pullJSONs(SKUs, frequency);

# remove undefined JSONs (for no sales)
rmvd = remUndef(JSONs, sizes);
JSONs = rmvd[1];
sizes = rmvd[2];

# get pricing graph data
priceData = getGraph(JSONs);

# check if output directory exists
if (!isdir("out"))
    mkdir("out")
end

# get optimization type from user
println("Format date values for spreadsheets (S), Raw Unix (U), or None (N)?");
optimizeVal = readline();
# check if this input was valid. 
if (lowercase(optimizeVal) == "s" || lowercase(optimizeVal) == "u" || lowercase(optimizeVal) == "n")
    validInput = true;
else
    validInput = false;
end
# keep asking them until it's valid
while(!validInput)
    println("Invalid input. Please enter \"S\" for spreadsheets, \"U\" for Unix, or \"N\" for no optimization.");
    global optimizeVal = readline();

    # check again
    if (lowercase(optimizeVal) == "s" || lowercase(optimizeVal) == "u" || lowercase(optimizeVal) == "n")
        global validInput = true;
    end
end

# print to text file
for i = 1:length(sizes)

    # declare output file
    outfile = string("out\\", string(sizes[i]), ".csv");
    f = open(outfile, "w")

    # print the data
    for j = 1:frequency
        
        if (lowercase(optimizeVal) == "s") # spreadsheet optimization (1970-01-01 = 25569)

            println(f, string((Dates.datetime2unix(priceData[i][1][j])/86400 + 25569), ",", priceData[i][2][j]));

        elseif (lowercase(optimizeVal) == "u") # Unix optimization

            println(f, string(Dates.datetime2unix(priceData[i][1][j]), ",", priceData[i][2][j]));

        else # no optimization

            println(f, string(priceData[i][1][j], ",", priceData[i][2][j]));

        end
        
    end

end