# Copyright 2019 Aaron Namba
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

require "liquid"

module Lender
  VERSION = "0.1.0"

  # For frameworks, where lender_context and lender_base_path will typically be preset
  # by controllers, we define macros, to avoid the need for the extra arguments.
  macro lender(file)
    lender_file({{file}}, ctx: lender_context, base_path: lender_base_path)
  end

  # For frameworks, where lender_context and lender_base_path will typically be preset
  # by controllers, we define macros, to avoid the need for the extra arguments.
  macro lender_string(string)
    lender_content(content: {{string}}, ctx: lender_context)
  end

  def lender_content(content : String, ctx : Liquid::Context) : String
    Liquid::Template.parse(content).render(ctx)
  end

  # base_path arg not used in this variant, just there to make signatures match
  def lender_file(file : File, ctx : Liquid::Context, base_path : String = ".") : String
    Liquid::Template.parse(file).render(ctx)
  end

  def lender_file(path : String, ctx : Liquid::Context, base_path : String = ".") : String
    unless (viewpath = File.join(base_path, path)) && File.exists?(viewpath)
      ex = Errno.new("File '#{path}' not found in base path '#{base_path}'")
      # ex.value = Errno::ENOENT
      raise ex
    end

    Liquid::Template.parse(File.new(viewpath)).render(ctx)
  end
end
