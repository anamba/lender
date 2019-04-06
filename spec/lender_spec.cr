require "./spec_helper"

describe Lender do
  context "lender_content" do
    # FIXME: write better spec
    it "lenders strings given context" do
      lender_content("asdf", Liquid::Context.new).should eq "asdf"
    end
  end

  context "lender_file" do
    # FIXME: write better spec
    it "lenders File given context" do
      lender_file(File.new("src/views/mycontroller/index.html"), Liquid::Context.new).should eq "This is a  view."
    end
  end

  context "lender_string macro" do
    # FIXME: write better spec
    it "lenders Strings" do
      lender_context = Liquid::Context.new

      lender_string("asdf").should eq "asdf"
      lender_context.set("example", "fdsa")
      lender_string("asdf {{ example }}").should eq "asdf fdsa"
    end
  end

  context "lender macro" do
    it "lenders Files, given path" do
      lender_context = Liquid::Context.new
      lender_base_path = "src/views"

      lender("mycontroller/index.html").should eq "This is a  view."

      lender_base_path = "src/views/mycontroller"
      lender("index.html").should eq "This is a  view."

      lender_context.set("myvar", "cool")
      lender("index.html").should eq "This is a cool view."
    end

    it "lenders Files, given File" do
      lender_context = Liquid::Context.new
      lender_base_path = "src/views" # not used, but still needs to be defined
      lender(File.new("src/views/mycontroller/index.html")).should eq "This is a  view."
    end
  end
end
