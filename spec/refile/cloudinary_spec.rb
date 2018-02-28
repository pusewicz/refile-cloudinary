require "spec_helper"
require "refile/cloudinary"

RSpec.describe Refile::Cloudinary do
  let(:config) { {
    cloud_name: "hfkkd49r3",
    api_key: "some-key",
    api_secret: "some-secret"
  } }

  it "has a version number" do
    expect(Refile::Cloudinary::VERSION).not_to be nil
  end
  
  describe "behavior Refile::Cloudinary" do
    let(:backend_default) { Refile::Cloudinary.new(config) }
    let(:backend_max_size_100) { Refile::Cloudinary.new({ **config }, max_size: 100) }  
    it "expect backend max size equal 10_485_760" do
      expect(backend_default.max_size).to eq 10_485_760
    end

    it "object not nil" do
      expect(backend_default).not_to be_nil 
    end

    it "change to 100 max_size" do
      expect(backend_max_size_100.max_size).to eq 100
    end
  end
end
