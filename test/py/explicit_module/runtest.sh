#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

rm -rf gen-py simple thediffs ttest
../../../compiler/cpp/thrift --gen py test1.thrift || exit 1
../../../compiler/cpp/thrift --gen py test2.thrift || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.baz' || exit 1
PYTHONPATH=./gen-py python -c 'import test2' || exit 1
PYTHONPATH=./gen-py python -c 'import test1' &>/dev/null && exit 1  # Should fail.
cp -r gen-py simple
../../../compiler/cpp/thrift -r --gen py test2.thrift || exit 1
PYTHONPATH=./gen-py python -c 'import test2' || exit 1
diff -ur simple gen-py > thediffs
file thediffs | grep -s -q empty || exit 1
rm -rf simple thediffs

# relative_imports basic generation
rm -rf gen-py
../../../compiler/cpp/thrift -r --gen py:relative_imports test3x.thrift || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3' || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3.ttypes' || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3.constants' || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3.Service13' || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3.Service23' || exit 1
PYTHONPATH=./gen-py python -c 'import foo.bar.test3.Service13x' || exit 1
cp -r gen-py simple
../../../compiler/cpp/thrift --gen py:relative_imports test1.thrift || exit 1
../../../compiler/cpp/thrift --gen py:relative_imports test2.thrift || exit 1
../../../compiler/cpp/thrift --gen py:relative_imports test3.thrift || exit 1
../../../compiler/cpp/thrift --gen py:relative_imports test3x.thrift || exit 1
diff -ur simple gen-py > thediffs
file thediffs | grep -s -q empty || exit 1
rm -rf simple thediffs

# relative_imports - should work for any Python Path
rm -rf ttest
mkdir ttest
mv gen-py ttest/sub
touch ttest/__init__.py
echo "from .sub.foo.bar import test3" > ttest/test3.py
python -c "import ttest.test3" || exit 1
rm -rf ttest

echo 'All tests pass!'
