
# #######################
# ABF: Anchor Build Fixer
# -----------------------


# Function to display error and fix command
function __abf_display_cmd() {
	# Define color codes for error and fix command
	RED='\033[0;31m'
	GREEN='\033[1;32m'
	NO_COLOR='\033[0m'

	# Assign function parameters to variables
	$line_err=$1          # Error message
	$fix_cmd=$2           # Fix command
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
	# cargo update -p solana-program@1.18.4 --precise ver
	# where `ver` is the latest version of `solana-program` supporting rustc 1.68.0-dev
	# 
	line_err="$(cat .abf_build.log | grep 'cargo update -p ')"   # Check for error related to cargo update
	if [[ $line_err != "" ]];then   # If error is found
		echo ""
		echo "abf: try to fix crate version..."

		version_solana="$(solana --version | awk '{print $2}')" # (Get Solana version) extract string like '1.9.15'
		precise_version="--precise $version_solana"             # Define precise version for cargo update
		fix_cmd="${line_err/--precise ver/$precise_version}"    # Build command to fix issue
																	  # (replace `ver` with current Solana version)

		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		__abf_build_log;
		return -1
	fi;

	return 0;
}


# Function to fix `ahash library feature` issue
function __abf_fix_ahash_issue() {
	# error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'
	# cargo update -p ahash@0.8.11 --precise 0.8.6
	#
	line_e0658="$(cat .abf_build.log | grep 'E0658' | head -n 1)"            # Check for error E0658
	line_hasher="$(echo $line_e0658 | grep 'build_hasher_simple_hash_one')"  # Check for use of unstable library feature
	if [[ $line_hasher != "" ]];then   # If error is found
		echo ""
		echo "abf: try to fix unstable 'ahash' library feature..."
		line_err=$line_hasher

		VERSION_AHASH_FIX="0.8.6"   # Define fixed version for ahash library

		line_err="error[E0658]: use of unstable library feature 'build_hasher_simple_hash_one'"
		get_ahash="$(cargo search ahash --limit 1 | grep 'ahash = \"')" # look for something like : 'ahash = "'.
		version_ahash="$(echo $get_ahash | awk -F'\"' '$0=$2')"         # Extract `ahash` version string between double quotes (")
		fix_cmd="cargo update -p ahash@$version_ahash --precise $VERSION_AHASH_FIX" # Build command to fix issue

		__abf_display_cmd $line_err $fix_cmd   # Display error and fix command
		__abf_build_log;
		return -1
	fi;

	return 0;
}


# Build anchor project and try to fix current errors
function abf_build() {
	__abf_git_ignore;
	__abf_build_log;
	err=0;

	__abf_fix_cargo_update_ver
	if [ $? -ne 0 ]; then
		err=$((err+=1));
	fi;

	__abf_fix_ahash_issue
	if [ $? -ne 0 ]; then
		err=$((err+=1));
	fi;

	return $err;
}


# Build anchor project and log output to `.abf_build.log` file
function __abf_build_log() {
	anchor build &> .abf_build.log
}


# Function to loop until successful project compilation
function __abf_build_loop() {
	local returned=-1;
	local loop=0;
	until [ $returned -eq 0 ]; do
		abf_build;
		loop=$((loop+=1));
		returned=$?
	done
}


# Main function for abf_init (abf init)
function abf_init() {
	if [[ $1 != "" ]];then
		__abf_versions
		anchor init $1 && cd $1
		__abf_build_loop
		echo ""
		tree --gitignore
		echo ""
		echo -e "👍 DONE"
		echo ""
		return 0;
	fi;
	echo "abf: argument `project_name` is missing";
	return -1;
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
	ABF_VERSION="v0.0.13 (2024-04-07)"
	echo "abf $ABF_VERSION"
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


# Entry point of the tool
function abf() {

	if [[ $1 == "" ]];then
		echo "abf: no command ?\n"
		__abf_help
		return -1;
	fi;

	if [[ $1 == "init" ]];then
		abf_init $2 # $project_name
		return 0;
	fi;

	if [[ $1 == "build" ]];then
		abf_build
		return 0;
	fi;

	if [[ $1 == "help" ]];then
		__abf_help
		return 0;
	fi;

	if [[ $1 == "version" ]];then
		__abf_version
		return 0;
	fi;

	if [[ $1 == "versions" ]];then
		__abf_versions
		return 0;
	fi;

	return 0;
}


# ABF: Anchor Build Fixer
# -----------------------
# #######################

