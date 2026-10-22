#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
build_dir=$(mktemp -d /tmp/bma580-tests.XXXXXX)
trap 'rm -rf "$build_dir"' EXIT
for source in src/bosch/*.c; do
    cc -std=c99 -I src/bosch -c "$source" -o "$build_dir/$(basename "$source").o"
done
c++ -std=c++11 -Wall -Wextra -Werror -I test/stubs -I src \
    test/test_driver.cpp src/BMA580.cpp "$build_dir/"*.o -lm -o "$build_dir/test"
"$build_dir/test"
