# Set base URL
base_url="https://rest.cosmos.directory:443"

# Set endpoints
endpoints=("akash" "shentu" "comdex" "desmos" "firmachain" "gravitybridge" "lumnetwork" "stargaze" "cryptoorgchain" "evmos" "juno" "osmosis" "regen" "umee")

# Loop through endpoints
for endpoint in "${endpoints[@]}"; do

  # Get annual provisions
  annual_provisions=$(curl -s "$base_url/$endpoint/cosmos/mint/v1beta1/annual_provisions" | jq .annual_provisions | bc -l)

  # Get blocks per year
  blocks_per_year=$(curl -s "$base_url/$endpoint/cosmos/mint/v1beta1/params" | jq .params.blocks_per_year | bc -l)

  # Get inflation
  inflation=$(curl -s "$base_url/$endpoint/cosmos/mint/v1beta1/inflation" | jq .inflation | bc -l)

  # Get bonded tokens
  bonded_tokens=$(curl -s "$base_url/$endpoint/cosmos/staking/v1beta1/pool" | jq .pool.bonded_tokens | bc -l)

  # Get community tax
  community_tax=$(curl -s "$base_url/$endpoint/cosmos/distribution/v1beta1/params" | jq .params.community_tax | bc -l)

  # Set scale to 10
  scale=10

  # Calculate nominal APR
  nominal_apr=$(echo "scale=$scale; $annual_provisions * (1 - $community_tax) / $bonded_tokens * 100" | bc -l)

  # Get latest block
  block1=$(curl -s "$base_url/$endpoint/cosmos/base/tendermint/v1beta1/blocks/latest" | jq .block.header)

  # Get height from block1
  height=$(echo "$block1" | jq .height | bc -l)

  # Determine block range
  block_range=$(awk "BEGIN {print ($height > 10000 ? 10000 : 1)}")

  # Get previous block
  previous_block=$(echo "$((height - block_range))" | bc)
  block2=$(curl -s "$base_url/$endpoint/cosmos/base/tendermint/v1beta1/blocks/$previous_block" | jq .block.header)

  # Calculate year in milliseconds
  year_milisec=31536000000

  # Get delta time
  time1=$(echo "$block1" | jq .time) && time1_no_quotes=$(sed -e 's/\"//g' <<< "$time1") && time1=$(date -d "$time1_no_quotes" +%s%3N)
  time2=$(echo "$block2" | jq .time) && time2_no_quotes=$(sed -e 's/\"//g' <<< "$time2") && time2=$(date -d "$time2_no_quotes" +%s%3N)

  # Calculate block in milliseconds
  block_milisec=$(echo "($time1 - $time2) / $block_range" | bc)

  # Calculate blocks per year in real time
  blocks_year_real=$(echo "$year_milisec / $block_milisec" | bc -l)

  # Calculate real APR
  real_apr=$(echo "scale=$scale; $nominal_apr * $blocks_year_real / $blocks_per_year" | bc -l)

  # Capitalize first letter of endpoint
  endpoint=$(sed -e 's/^./\U&/' <<< "$endpoint")

  # Print results
  printf "$endpoint ➤ Nominal APR: %.2f%% & RealTime APR: %.2f%%\n" $nominal_apr $real_apr

done
