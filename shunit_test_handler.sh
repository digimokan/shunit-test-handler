#!/bin/sh

CMD_NAME="$(basename "${0}")"
path_to_shlib_dir=''      # relative path to shlib
path_to_unit_tests_dir='' # relative path to dir with shunit2 unit test files
exit_code=0               # stored exit code of shlib's test_runner execution
shells=''                 # optional list of shells to test with
unit_test_files=''        # optional list of unit test files to use
unit_test_function=''     # optional single unit test function to run

print_leading_spaces() {
  # shellcheck disable=SC2034
  for i in $(seq 1 "$((${1} + ${2} + ${3}))"); do
    printf ' '
  done
}

print_cmd_line() {
  printf "  %s  %s\\n" "${CMD_NAME}" "${1}"
}

print_arg_line() {
  print_leading_spaces 2 ${#CMD_NAME} 2
  printf "%s\\n" "${1}"
}

print_usage() {
  echo 'USAGE:'
  print_cmd_line '-h'
  print_cmd_line '[-s "<path> [<path> ...]"]  [-t "<file> [<file> ...]"]'
  print_arg_line '[-x <function_name>]  <path_to_shlib_dir>'
  print_arg_line '<path_to_unit_tests_dir>'
  echo 'OPTIONS:'
  echo '  -h, --help'
  echo '      print this help message'
  echo '  -s "<path> [<path> ...]", --test-shells="<path> [<path> ...]"'
  echo '      only use specified list of shells for tests'
  echo '  -t "<file> [<file> ...]", --unit-test-files="<file> [<file> ...]"'
  echo '      only run specified list of unit test files'
  echo '  -x "<function_name>", --unit-test-function="<function_name>"'
  echo '      only run single specified unit test function'
  exit "${1}"
}

get_cmd_opts_and_args() {
  while getopts ':hs:t:x:-:' option; do
    case "${option}" in
      h)  handle_help ;;
      s)  handle_test_shells "${OPTARG}" ;;
      t)  handle_unit_test_files "${OPTARG}" ;;
      x)  handle_unit_test_function "${OPTARG}" ;;
      \?) handle_unknown_option "${OPTARG}" ;;
      -)  LONG_OPTARG="${OPTARG#*=}"
          case ${OPTARG} in
            help)                   handle_help ;;
            help=*)                 handle_illegal_option_arg "${OPTARG}" ;;
            test-shells=?*)         handle_test_shells "${LONG_OPTARG}" ;;
            test-shells*)           handle_missing_option_arg "${OPTARG}" ;;
            unit-test-files=?*)     handle_unit_test_files "${LONG_OPTARG}" ;;
            unit-test-files*)       handle_missing_option_arg "${OPTARG}" ;;
            unit-test-function=?*)  handle_unit_test_function "${LONG_OPTARG}" ;;
            unit-test-function*)    handle_missing_option_arg "${OPTARG}" ;;
            '')                     break ;; # non-option arg starting with '-'
            *)                      handle_unknown_option "${OPTARG}" ;;
          esac ;;
    esac
  done
  shift $((OPTIND - 1))
  path_to_shlib_dir="${1}"
  path_to_unit_tests_dir="${2}"
}

handle_help() {
  print_usage 0
}

handle_test_shells() {
  shells="${1}"
}

handle_unit_test_files() {
  unit_test_files="${1}"
}

handle_unit_test_function() {
  unit_test_function="unit_test_function=${1}"
}

handle_unknown_option() {
  err_msg="unknown option \"${1}\""
  print_error_msg "${err_msg}" 1
}

handle_illegal_option_arg() {
  err_msg="illegal argument in \"${1}\""
  print_error_msg "${err_msg}" 1
}

handle_missing_option_arg() {
  err_msg="missing argument for option \"${1}\""
  print_error_msg "${err_msg}" 1
}

print_error_msg() {
  echo 'ERROR:'
  printf "$(basename "${0}"): %s\\n\\n" "${1}"
  print_usage "${2}"
}

check_required_args() {
  if [ "${path_to_shlib_dir}" = '' ] || [ "${path_to_unit_tests_dir}" = '' ]; then
    print_error_msg "must specify <path_to_shlib_dir> and <path_to_unit_tests_dir>" 2
  fi
  if [ ! -d "${path_to_shlib_dir}" ]; then
    print_error_msg "<path_to_shlib_dir> not valid" 2
  fi
  if [ ! -d "${path_to_unit_tests_dir}" ]; then
    print_error_msg "<path_to_unit_tests_dir> not valid" 2
  fi
}

check_unit_test_files_and_function() {
  if [ "${unit_test_files}" = ''  ] && [ "${unit_test_function}" != '' ]; then
    print_error_msg "must specify -t <file> when specifying -x <function_name>" 2
  fi
}

copy_test_runner_files() {
  cp "${path_to_shlib_dir}/standalone/versions"    "${path_to_unit_tests_dir}"
  cp "${path_to_shlib_dir}/standalone/test_runner" "${path_to_unit_tests_dir}"
}

change_to_unit_tests_dir() {
  cd "${path_to_unit_tests_dir}" || exit 1
}

run_unit_tests() {
  ./test_runner -s "${shells}" -t "${unit_test_files}" -e "${unit_test_function}"
  exit_code="${?}"
}

cleanup_copied_files() {
  rm versions test_runner
}

main() {
  get_cmd_opts_and_args "$@"
  check_required_args
  check_unit_test_files_and_function
  copy_test_runner_files
  change_to_unit_tests_dir
  run_unit_tests
  cleanup_copied_files
  exit "${exit_code}"
}

main "$@"

