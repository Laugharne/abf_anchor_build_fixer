# Function to display error and fix command
function __abf_display_cmd() {
	# Color codes
	RED='\033[0;31m'
	GREEN='\033[1;32m'
	NO_COLOR='\033[0m'

	$line_err=$1          # Error message
	$fix_cmd=$2           # Fix command
	echo -e -n "${RED}";	echo "    $line_err";  # Display error message in red
	echo -e -n "${GREEN}";	echo "    $fix_cmd";   # Display fix command in green
	echo -e -n "${NO_COLOR}"
	echo ""
	eval "$fix_cmd"      # Execute the fix command
}


# Main function for abfb
function abfb() {
	# Color codes
	# YELLOW='\033[1;33m'
	# BLUE='\033[1;34m'
	RED='\033[0;31m'
	GREEN='\033[1;32m'
	NO_COLOR='\033[0m'

	anchor build &> .abf.log   # Build anchor and log output to `.abf.log` file

	# cargo update -p solana-program@1.18.4 --precise ver
	# where `ver` is the latest version of `solana-program` supporting rustc 1.68.0-dev
	# 
	line_err="$(cat .abf.log | grep 'cargo update -p ')"   # Check for error related to cargo update
	if [[ $line_err != "" ]];then   # If error is found
		echo "abf: try to fix version..."

		version_solana="$(solana --version | awk '{print $2}')" # (Get Solana version) extract string like '1.9.15'
		precise_version="--precise $version_solana"             # Define precise version for cargo update
		fix_cmd="${line_err/--precise ver/$precise_version}"    # Build command to fix issue

		#echo -e -n "${RED}";	echo "    $line_err";	echo -e -n "${NO_COLOR}"
		#echo -e -n "${GREEN}";	echo "    $fix_cmd";	echo -e -n "${NO_COLOR}"
		#echo ""
		#eval "$fix_cmd"
		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		return -1
	fi;

	# error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'
	# cargo update -p ahash@0.8.11 --precise 0.8.6
	#
	line_e0658="$(cat .abf.log | grep 'E0658' | head -n 1)"      # Check for error E0658
	line_hasher="$(echo $line_e0658 | grep 'build_hasher_simple_hash_one')"  # Check for use of unstable library feature
	if [[ $line_hasher != "" ]];then   # If error is found
		echo "abf: try to fix unstable 'ahash' library feature..."
		line_err=$line_hasher

		VERSION_AHASH_FIX="0.8.6"   # Define fixed version for ahash library

		line_err="error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'"
		get_ahash="$(cargo search ahash --limit 1 | grep 'ahash = \"')" # look for something like : 'ahash = "'.
		version_ahash="$(echo $get_ahash | awk -F'\"' '$0=$2')"         # Extract `ahash` version string between double quotes (")
		fix_cmd="cargo update -p ahash@$version_ahash --precise $VERSION_AHASH_FIX" # Build command to fix issue

		#echo -e -n "${RED}";	echo "    $line_err";	echo -e -n "${NO_COLOR}"
		#echo -e -n "${GREEN}";	echo "    $fix_cmd";	echo -e -n "${NO_COLOR}"
		#echo ""
		#eval "$fix_cmd"
		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		return -1
	fi;

	return 0
}


# Function to loop until successful compilation
function __abfb_loop() {
	r=-1
	until [ $r -eq 0 ]; do
		abfb
		r=$?
	done
}


# Main function for abfi
function abfi() {
	project_name=$1;
	if [[ $project_name != "" ]];then
		rustc --version
		cargo --version
		solana --version
		node --version
		anchor --version
		abf_version="v0.5.0 (2024-03-12)"
		echo "abf $abf_version"
		echo ""
		anchor init $project_name && cd $project_name && echo ".abf.log" >> .gitignore
		__abfb_loop
		echo ""
		tree --gitignore
		echo ""
		echo -e "👍 DONE"
		echo ""
	else
		echo "abf: argument `project_name` is missing";
	fi;
}
