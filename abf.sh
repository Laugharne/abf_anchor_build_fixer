
# #######################
# ABF: Anchor Build Fixer
# -----------------------

# Function to display error and fix command
function __abf_display_cmd() {
	# Define color codes for error and fix command
	local RED='\033[0;31m'
	local GREEN='\033[1;32m'
	local NO_COLOR='\033[0m'

	# Assign function parameters to local variables
	local $line_err=$1          # Error message
	local $fix_cmd=$2           # Fix command
	echo -e -n "${RED}";	echo "    $line_err";  # Display error message in red
	echo -e -n "${GREEN}";	echo "    $fix_cmd";   # Display fix command in green
	echo -e -n "${NO_COLOR}"    # Reset color to no color
	echo ""
	eval "$fix_cmd"      # Execute the fix command
}


# Function to manage `.gitignore` file
function __abf_git_ignore() {
	# Check if `.gitignore` file exists
	if [ -f ".gitignore" ]; then
		# Check if `.abf_build.log` is already in `.gitignore`
		if grep -q ".abf_build.log" .gitignore; then
			echo -n ""
		else
			# Update `.gitignore` with `.abf_build.log`
			echo "abf: ➕ update '.gitignore'"
			echo "\n# Anchor Build Fixer (abf)\n.abf_build.log" >> .gitignore
		fi
	else
		echo "💀 no '.gitignore' file !"
		exit
	fi
}


# Function to fix `crate version update` issue
function __abf_fix_cargo_update_ver() {
	echo "* CARGO UPDATE VER";
	# cargo update -p solana-program@1.18.4 --precise ver
	# where `ver` is the latest version of `solana-program` supporting rustc 1.68.0-dev
	# 
	local line_err="$(cat .abf_build.log | grep 'cargo update -p ')"   # Check for error related to cargo update
	if [[ $line_err != "" ]];then   # If error is found
		echo ""
		echo "abf: try to fix crate version..."

		local version_solana="$(solana --version | awk '{print $2}')" # (Get Solana version) extract string like '1.9.15'
		local precise_version="--precise $version_solana"             # Define precise version for cargo update
		local fix_cmd="${line_err/--precise ver/$precise_version}"    # Build command to fix issue
																	  # (replace `ver` with current Solana version)

		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		return -1
	fi;

	return 0;
}


# Function to fix `ahash library feature` issue
function __abf_fix_ahash_issue() {
	echo "* AHASH ISSUE";
	# error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'
	# cargo update -p ahash@0.8.11 --precise 0.8.6
	#
	local line_e0658="$(cat .abf_build.log | grep 'E0658' | head -n 1)"            # Check for error E0658
	local line_hasher="$(echo $line_e0658 | grep 'build_hasher_simple_hash_one')"  # Check for use of unstable library feature
	if [[ $line_hasher != "" ]];then   # If error is found
		echo ""
		echo "abf: try to fix unstable 'ahash' library feature..."
		local line_err=$line_hasher

		VERSION_AHASH_FIX="0.8.6"   # Define fixed version for ahash library

		local line_err="error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'"
		local get_ahash="$(cargo search ahash --limit 1 | grep 'ahash = \"')" # look for something like : 'ahash = "'.
		local version_ahash="$(echo $get_ahash | awk -F'\"' '$0=$2')"         # Extract `ahash` version string between double quotes (")
		local fix_cmd="cargo update -p ahash@$version_ahash --precise $VERSION_AHASH_FIX" # Build command to fix issue

		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		return -1
	fi;

	return 0;
}

# Main function for abf_build
function abf_build() {
	echo "* BUILD";
	__abf_git_ignore;
	local err=0;
	anchor build &> .abf_build.log   # Build anchor and log output to `.abf_build.log` file

	__abf_fix_cargo_update_ver
	echo "* update ver: $?";
	if [ "$?" != "0" ]; then
		#--return $?
		((err+=1));
	fi;

	__abf_fix_ahash_issue
	echo "* ahash issue: $?";
	if [ "$?" != "0" ]; then
		#--return $?
		((err+=1));
	fi;

	return $err;
}


# Function to loop until successful compilation
function __abf_build_loop() {
	echo "* BUILD LOOP";
	local r=-1
	until [ $r -eq 0 ]; do
		abf_build
		echo "* loop: $?";
		r=$?
	done
}


# Main function for abf_init (abf init)
function abf_init() {
	local project_name=$1;
	if [[ $project_name != "" ]];then
		__abf_versions
		anchor init $project_name && cd $project_name
		__abf_build_loop
		echo ""
		tree --gitignore
		echo ""
		echo -e "👍 DONE"
		echo ""
	else
		echo "abf: argument `project_name` is missing";
	fi;
}


function __abf_versions() {
	rustc  --version
	cargo  --version
	solana --version
	node   --version
	anchor --version
	__abf_version
}

function __abf_version() {
	abf_version="v0.5.11 (2024-04-07)"
	echo "abf $abf_version"
	echo ""
}


function __abf_help() {
	echo "Usage: abf <command>"
	echo ""
	echo "Commands:"
	echo "  init      Initializes a workspace"
	echo "  build     Build a workspace"
	echo "  version   Print 'abf' version"
	echo "  versions  Print assets versions"
	echo "  help      Print this message"
	echo ""

}

function abf() {
	local $command=$1;

	if [[ $command == "" ]];then
		echo "abf: no command ?\n"
		__abf_help
		exit
	fi;

	if [[ $command == "init" ]];then
		abf_init $2 # $project_name
		exit
	fi;

	if [[ $command == "build" ]];then
		abf_build
		exit
	fi;

	if [[ $command == "help" ]];then
		__abf_help
		exit
	fi;

	if [[ $command == "version" ]];then
		__abf_version
		exit
	fi;

	if [[ $command == "versions" ]];then
		__abf_versions
		exit
	fi;

}

# ABF: Anchor Build Fixer
# -----------------------
# #######################

