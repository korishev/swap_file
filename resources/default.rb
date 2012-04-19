#
# Cookbook Name:: swap_file
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
#

actions :create, :delete

def initialize(*args)
  super
  @action = :create
end

attribute :size_in_mb,     :kind_of => Numeric, :default => 2000
attribute :prio,           :kind_of => Numeric, :default => -1

attribute :auto_allocate,  :default => false                        # Determine size of swap based on system memory?
attribute :multiplier,     :kind_of => Numeric, :default => 2       # how many times system memory should swap be if auto allocating?
attribute :max_swap_in_mb, :kind_of => Numeric, :default => 30000   # default max swap size 30G
attribute :min_swap_in_mb, :kind_of => Numeric, :default => 4000    # default min swap size 4G
