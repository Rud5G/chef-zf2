# Author:: James M. Greene (<james.m.greene@gmail.com>)
# Copyright:: Copyright (c) 2015, James M. Greene
# License:: MIT

#
# Adapted from:
#   https://github.com/chef/chef/blob/11.10.0/lib/chef/provider/git.rb
#
# Author:: Daniel DeLeo (<dan@kallistec.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
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

class Chef
  class Provider
    class Deploy
      class Workstation < Chef::Provider::Deploy
        provides :workstation_dir
        provides :deploy

        protected

        def release_slug
          'workstation'
        end
      end
    end
  end
end

