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

action :create do
  add_swap_file unless ::File.exists?(full_path)
end

action :delete do
  remove_swap_file if ::File.exists?(full_path)
end

def add_swap_file
  mount_swap_file if create_swap_file
end

def create_swap_file
  execute "create the swap file" do
    command "dd if=/dev/zero of=#{full_path} bs=1M count=#{swap_file_size} && mkswap #{full_path}"
    not_if full_path.nil? || full_path.empty?
  end
end

def mount_swap_file
  execute "activate swap" do
    command "swapon #{full_path}"
  end
end

def remove_swap_file
  delete_swap_file if unmount_swap_file
end

def unmount_swap_file
  execute "deactivate swap" do
    command "swapoff #{full_path})"
  end
end

def delete_swap_file
  file "#{full_path}" do
    action :delete
    only_if ::File.exists?(full_path)
  end
end

def full_path
  new_resource.name.nil? || new_resource.name.empty? ?  ::File.join(new_resource.path, new_resource.filename) : new_resource.name
end

def swap_file_size
  new_resource.auto_allocate ? auto_size_swap : new_resource.size_in_mb
end

def auto_size_swap
  check_min_max
  get_final_size
end

def get_final_size
  case
  when [new_resource.min_swap_in_mb..new_resource.max_swap_in_mb].include?(multiply_memory)
    multiply_memory
  when new_resource.min_swap_in_mb > multiply_memory
    new_resource.min_swap_in_mb
  when new_resource.max_swap_in_mb < multiply_memory
    new_resource.max_swap_in_mb
  end
end

def check_min_max
  if new_resource.max_swap_in_mb < new_resource.min_swap_in_mb
    raise "Min swapfile size cannot be larger than Max swapfile size"
  end
end

def multiply_memory
  @memory ||= node["memory"]["total"][0..-3].to_i * new_resource.multiplier
end

