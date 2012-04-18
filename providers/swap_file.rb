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

# Resource Attributes
#actions :create, :delete
#
#attribute :path, :kind_of => String, :default => "/mnt"
#attribute :filename, :kind_of => String, :default => "swapfile"
#attribute :auto_allocate, :default => false
#attribute :multiplier, :kind_of => Numeric, :default => 2
#attribute :max_swap_in_mb, :kind_of => Numeric, :default => 30000
#attribute :min_swap_in_mb, :kind_of => Numeric, :default => 4000
#attribute :size_in_mb, :kind_of => Numeric
#attribute :prio, :kind_of => Numeric, :default => -1

def initialize(*args)
  super
  @action = :create
end

action :create do
   File.exists?(full_path)
end

action :delete do
    not_if !File.exists?(full_path)
end

def mount_swap_file
  execute "activate swap" do
    command "swapon #{full_path}"
  end
end

def unmount_swap_file
  execute "deactivate swap" do
    command "swapoff #{full_path})"
  end
end

def delete_swap_file
end

def full_path
  File.join(new_resource.path, new_resource.filename)
end

def create_swap_file
  execute "create the swap file" do
    command "dd if=/dev/zero of=#{full_path} bs=1M count=#{swap_file_size}) && mkswap #{full_path}"
    not_if full_path.nil? || full_path.empty?
  end
end

def swap_file_size
  new_resource.auto_allocate ? auto_size_swap : new_resource.size_in_mb
end

def auto_size_swap
  check_min_max
  get_final_size
end

def get_final_size
  multiply_memory if [new_resource.min_swap_in_mb..new_resource.max_swap_in_mb].include?(multiply_memory)
  new_resource.min_swap_in_mb if new_resource.min_swap_in_mb > multiply_memory
  new_resource.max_swap_in_mb if new_resource.max_swap_in_mb < multiply_memory
end

def check_min_max
  if new_resource.max_swap_in_mb < new_resource.min_swap_in_db
    raise "Min swapfile size cannot be larger than Max swapfile size"
  end
end

def multiply_memory
  @memory ||= node["memory"]["total"][0..-3] * new_resource.multiplier
end

