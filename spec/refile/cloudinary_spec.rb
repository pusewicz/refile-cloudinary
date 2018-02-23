require "spec_helper"
require "refile/cloudinary"

config = {
  cloud_name: "hfkkd49r3",
  api_key: "some-key",
  api_secret: "some-secret"
}

RSpec.describe Refile::Cloudinary do
  it "has a version number" do
    expect(Refile::Cloudinary::VERSION).not_to be nil
  end
  
  describe "behavior Refile::Cloudinary" do
    let(:backend) { Refile::Cloudinary.new({**config}, max_size: 100 )}
    it "expect backend max size equal 100" do
      expect(backend.max_size).to eq 100
    end

    it "object not nil" do
      expect(backend).to be_truthy 
    end
  end
end
