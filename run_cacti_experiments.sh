#!/bin/bash

# Paths and variables
CACTI_REPO_PATH="."
CACTI_EXEC="$CACTI_REPO_PATH/cacti"
CONFIG_FILE="$CACTI_REPO_PATH/cache.cfg"
OUTPUT_DIR="$CACTI_REPO_PATH/results"
CACHE_SIZES=(65536 262144 524288)
ASSOCIATIVITIES=(1 2 4 8 16 32 64)
SPECIFIC_ASSOCIATIVITY=4
SPECIFIC_CACHE_SIZE=524288 # 512KB in bytes

# Create results directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Function to modify config file
modify_config() {
    local size=$1
    local assoc=$2
    sed -i "s/^.*-size (bytes).*/-size (bytes) $size/" $CONFIG_FILE
    sed -i "s/^.*-associativity.*/-associativity $assoc/" $CONFIG_FILE
}

# Run experiments for varying cache sizes with associativity 4
run_experiments_varying_sizes() {
    for size in "${CACHE_SIZES[@]}"; do
        modify_config $size $SPECIFIC_ASSOCIATIVITY
        OUTPUT_FILE="$OUTPUT_DIR/result_cache_${size}B_assoc_${SPECIFIC_ASSOCIATIVITY}.txt"
        $CACTI_EXEC -infile $CONFIG_FILE > $OUTPUT_FILE
        echo "Ran experiment for cache size ${size} bytes and associativity ${SPECIFIC_ASSOCIATIVITY}. Output saved to ${OUTPUT_FILE}."
    done
}

Run experiments for 128KB cache size with varying associativities
run_experiments_varying_associativities() {
    for assoc in "${ASSOCIATIVITIES[@]}"; do
        modify_config $SPECIFIC_CACHE_SIZE $assoc
        OUTPUT_FILE="$OUTPUT_DIR/result_cache_${SPECIFIC_CACHE_SIZE}B_assoc_${assoc}.txt"
        $CACTI_EXEC -infile $CONFIG_FILE > $OUTPUT_FILE
        echo "Ran experiment for cache size ${SPECIFIC_CACHE_SIZE} bytes and associativity ${assoc}. Output saved to ${OUTPUT_FILE}."
    done
}

# Main function to coordinate the script
main() {
    run_experiments_varying_sizes
    #run_experiments_varying_associativities
}

# Run the main function
main
