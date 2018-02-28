#!/bin/bash

if [[ $# != 3 ]]; then
  echo "Usage: $0 <interpreter> <requirements-file> <output-dir>"
  exit 1
fi

py=$1
req_file=$2
tmp_dir=$3

$py -m pip wheel -q --no-cache-dir --wheel-dir=$tmp_dir -r $req_file

for pkg in "${tmp_dir}/"*; do
  if [[ "${pkg}" == *"manylinux1_x86_64"* ]]; then
    mv "${pkg}" "${pkg/manylinux1_x86_64/linux_x86_64}"
  fi
done
