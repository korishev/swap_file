#
# Cookbook Name:: swap_file
# Recipe:: default
#
# Copyright 2012, Morgan Nelson
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

swap_file "/mnt/swapfile" do
  action :create
  size_in_mb node["swap_file"]["size_in_mb"] if node["swap_file"] && node["swapfile"]["size_in_mb"]
end
