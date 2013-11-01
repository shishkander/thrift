/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

include "test1.thrift"
include "test2.thrift"
// test1 contains foo.bar.baz namespace
// test2 is namespace-less, thus it'll just be called test2
// this (test3) namespace will share some part with test1
namespace py foo.bar.test3

struct relative {
  1: test1.astruct x;
  2: test2.another y;
}

service Service13 extends test1.Service1{
    void test3();
}

service Service23 extends test2.Service2{
    void test3();
}
