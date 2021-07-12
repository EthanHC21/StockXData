include("PullSKUsAndSizes.jl");
include("PullJSONs.jl");
include("PullGraphData.jl");
include("RemUndef.jl");
import Dates;

# get the frequency
print("Enter desired frequency (number of data points): ")
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

# print to text file
for i = 1:length(sizes)

    # declare output file
    outfile = string("out\\", string(sizes[i]), ".csv");
    f = open(outfile, "w")

    # print the data
    for j = 1:frequency
        println(f, string(Dates.datetime2unix(priceData[i][1][j]), ",", priceData[i][2][j]));
    end

end