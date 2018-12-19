# shunit-test-handler

Light wrapper script over [kward/shlib](https://github.com/kward/shlib) and
[kward/shunit2](https://github.com/kward/shunit2). Provides some shell script
unit testing granularity.

## Table Of Contents
* [Features](#features)
* [Dependencies](#dependencies)
* [Setup](#setup)
* [Examples](#examples)
* [Usage](#usage)
* [Todo](#todo)
* [Meta](#meta)
  * [Developers](#developers)
  * [License](#license)

## Features

* Adds option for running only one specific test from one unit test file.
* Enables separation of _shlib_ and a directory containing unit tests.
* Passes through options for specifying which shells to test with, and for
  narrowing which unit test files to run.
* Just like _shunit2_, it runs in most shells.

## Dependencies

* [kward/shlib](https://github.com/kward/shlib)
* [kward/shunit2](https://github.com/kward/shunit2) (for your individual unit
  test files)

## Setup

1. Create a script (e.g. `myscript.sh`) that you want to test.
2. Copy the `shunit-test-handler.sh` script from this repo into your project.
3. Create a `unit_tests` directory in your project.
4. Add some _shunit2_ unit test files to the `unit_tests` directory.
5. Ensure you have both _shlib_ and _shunit2_ somewhere in your project.

At this point, your project should look something like this:

```
└─┬ my_project/
  ├── myscript.sh
  ├─┬ tests/
  │ ├── shunit-test-handler.sh
  │ └─┬ unit_tests/
  │   ├── test_a.sh
  │   └── test_b.sh
  └─┬ third_party/
    ├── shlib/
    └── shunit2/
```

## Examples

* Run all unit test files, with all available shells.

   ```bash
   $ ./shunit-test-handler ../third_party/shlib ./unit_tests
   ```

* Only test with the bash shell.

   ```bash
   $ ./shunit-test-handler -s /bin/bash ../third_party/shlib ./unit_tests
   ```

* Only run a specified list of unit test files.

   ```bash
   $ ./shunit-test-handler -t test_a.sh ../third_party/shlib ./unit_tests
   ```

* Only run one specified test function within a unit test file.

   ```bash
   $ ./shunit-test-handler -t test_a.sh -x someTestFunc ../third_party/shlib ./unit_tests
   ```

## Usage

SYNOPSIS

`test_driver.sh  -h`

`test_driver.sh  [-s "<path> [<path> ...]"]  [-t "<file> [<file> ...]"]`  
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; `[-x <function_name>]  <path_to_shlib_dir>`  
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; `<path_to_unit_tests_dir>`

OPTIONS:

`-h, --help`  
&nbsp; &nbsp; &nbsp; &nbsp; print this help message

`-s "<path> [<path> ...]", --test-shells="<path> [<path> ...]"`  
&nbsp; &nbsp; &nbsp; &nbsp; use specified list of shells for tests (default is sys shell)

`-t "<file> [<file> ...]", --unit-test-files="<file> [<file> ...]"`  
&nbsp; &nbsp; &nbsp; &nbsp; only run specified list of unit test files

`-x "<function_name>", --unit-test-function="<function_name>"`  
&nbsp; &nbsp; &nbsp; &nbsp; only run single specified unit test function

## Todo

* Pass through environment vars to _test_runner_.
* Allow running multiple test functions within a unit test file.

## Meta

### Developers

* [__digimokan__](https://github.com/digimokan)

### License

Distributed under the [MIT](LICENSE.txt) License

