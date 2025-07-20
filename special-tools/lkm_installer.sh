#!/bin/bash

# =============================================================================
#
#   The "Bulletproof" Final Module Preparation Script v8
#
#                       - ravindu644
#
#   This script uses a robust `while read` loop to iterate through the
#   master module list, fixing the "only one loop" bug from the previous
#   version. This is the gold standard for processing line-by-line input.
#
#   It correctly uses the stock modules.dep as a blueprint, builds the
#   module directory, strips the modules, and regenerates all metadata.
#
# =============================================================================

# --- 1. SETUP LOGGING AND INTERACTIVE INPUT ---

LOG_FILE="$(pwd)/finalize_modules.log"
rm -f "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

set -x # Enable command tracing for detailed debugging

echo "### Final Module Preparation Script (Interactive, v8 - Bulletproof Loop) ###"
echo "### LOGGING TO: ${LOG_FILE} ###"
echo ""

read -p "Enter the full path to the STOCK modules.dep file: " STOCK_MODULES_DEP
read -p "Enter the full path to the STOCK modules.load file (for the final step): " STOCK_MODULES_LOAD
read -p "Enter the full path to the CUSTOM compiled module directory (.../staging/lib/modules/kernel_version folder): " CUSTOM_MODULE_DIR
read -p "Enter the full path to the System.map file: " SYSTEM_MAP_FILE
read -p "Enter the full path to the llvm-strip tool: " STRIP_TOOL
read -p "Enter the full path for the FINAL output directory: " FINAL_OUTPUT_DIR

# --- 2. VALIDATION ---
set +x; echo ""; echo "--> Validating inputs..."; set -x
if [ ! -f "$STOCK_MODULES_DEP" ]; then echo "!! ERROR: Stock modules.dep file not found!"; exit 1; fi
if [ ! -f "$STOCK_MODULES_LOAD" ]; then echo "!! ERROR: Stock modules.load file not found!"; exit 1; fi
if [ ! -d "$CUSTOM_MODULE_DIR" ]; then echo "!! ERROR: Custom module build directory not found!"; exit 1; fi
if [ ! -f "$SYSTEM_MAP_FILE" ]; then echo "!! ERROR: System.map not found!"; exit 1; fi
if [ ! -x "$STRIP_TOOL" ]; then echo "!! ERROR: llvm-strip tool not found or is not executable!"; exit 1; fi
if [ -z "$FINAL_OUTPUT_DIR" ]; then echo "!! ERROR: Output directory path cannot be empty."; exit 1; fi
set +x; echo "--> Inputs validated successfully."; set -x

# --- 3. PREPARE DIRECTORY AND INDEX MODULES ---
KERNEL_VERSION=$(basename "$CUSTOM_MODULE_DIR")
FINAL_MODULE_DIR="${FINAL_OUTPUT_DIR}/lib/modules/${KERNEL_VERSION}"
set +x; echo "--> Preparing clean output directory..."; set -x
rm -rf "$FINAL_OUTPUT_DIR"
mkdir -p "$FINAL_MODULE_DIR"
set +x; echo "--> Indexing all available custom .ko files for fast lookup..."; set -x
declare -A MODULE_MAP
while IFS= read -r -d $'\0' file_path; do
    MODULE_MAP["$(basename "$file_path")"]="$file_path"
done < <(find "$CUSTOM_MODULE_DIR" -type f -name "*.ko" -print0)
set +x; echo "--> Index created with ${#MODULE_MAP[@]} modules."; set -x

# --- 4. COPY AND STRIP MODULES FROM MASTER LIST (USING BULLETPROOF LOOP) ---
set +x; echo "--> Copying and STRIPPING required modules from master list..."; set -x
MODULE_COUNT=0

# This robust 'while read' loop is the core fix. It processes the list of modules
# line by line without any word-splitting issues.
while read -r module_name; do
    # Skip empty lines that might result from parsing
    if [[ -z "$module_name" ]]; then continue; fi

    if [[ -v MODULE_MAP["$module_name"] ]]; then
        # Copy the module
        cp "${MODULE_MAP["$module_name"]}" "$FINAL_MODULE_DIR/"
        # Strip the debugging symbols
        ${STRIP_TOOL} --strip-debug "${FINAL_MODULE_DIR}/${module_name}"
        ((MODULE_COUNT++))
    else
        set +x; echo "    [!!] WARNING: ${module_name} from master list not found in custom build!"; set -x
    fi
# This complex command parses modules.dep to create the master list of unique module names
# and feeds it directly into our 'while read' loop.
done < <(tr ' :' '\n' < "$STOCK_MODULES_DEP" | grep '\.ko' | xargs -n1 basename | sort -u)

set +x; echo "--> Copied and stripped ${MODULE_COUNT} modules."; set -x

# --- 5. REGENERATE METADATA ---
set +x; echo "--> Creating and regenerating all module metadata..."; set -x
cp "${CUSTOM_MODULE_DIR}/modules.builtin" "${FINAL_MODULE_DIR}/"
(
    set +x; echo "    Running depmod for kernel version ${KERNEL_VERSION}..."; set -x
    cd "${FINAL_OUTPUT_DIR}" && \
    depmod -a -b . -F "${SYSTEM_MAP_FILE}" "${KERNEL_VERSION}"
) || { set +x; echo "!! ERROR: depmod failed."; exit 1; }
set +x; echo "--> Metadata regenerated successfully."; set -x

# --- 6. CREATE FINAL modules.load and modules.order ---
set +x; echo "--> Creating final modules.load and modules.order from stock blueprint..."; set -x
# CRITICAL: Use the original stock modules.load to perfectly replicate boot behavior.
cp "${STOCK_MODULES_LOAD}" "${FINAL_MODULE_DIR}/modules.load"
# Make sure the paths are flat in the final version.
sed -i 's#.*/##' "${FINAL_MODULE_DIR}/modules.load"
# The modules.order file should also match the load order for consistency.
cp "${FINAL_MODULE_DIR}/modules.load" "${FINAL_MODULE_DIR}/modules.order"


# --- 7. SUCCESS ---
set +x
echo ""
echo "#####################################################################"
echo "###                      SUCCESS!                                 ###"
echo "#####################################################################"
echo ""
echo "A perfect, STRIPPED, flat module directory has been created based on"
echo "your stock modules.dep blueprint. It is ready for packaging."
echo ""
echo "  Final Directory Location: ${FINAL_OUTPUT_DIR}"
echo "  A detailed log was saved to: ${LOG_FILE}"
echo ""
