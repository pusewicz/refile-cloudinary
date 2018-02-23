require "spec_helper"
require "refile/cloudinary"

RSpec.describe Refile::Cloudinary do
  let(:config) {{
    cloud_name: "hfkkd49r3",
    api_key: "some-key",
    api_secret: "some-secret"
  }}

  it "has a version number" do
    expect(Refile::Cloudinary::VERSION).not_to be nil
  end
  
  describe "behavior Refile::Cloudinary" do
<<<<<<< 9112dbff7089e96cfaef66f5e77abff8f095ae67
    let(:backend) { Refile::Cloudinary.new({**config}, max_size: 100 )}
    it "expect backend max size equal 100" do
      expect(backend.max_size).to eq 100
    end

    it "object not nil" do
      expect(backend).to be_truthy 
=======
    let(:backend) { Refile::Cloudinary.new({**config}, max_size: 10_485_760 )}

    it "object not nil" do
      expect(backend).not_to be_nil 
    end

    it "file max size 10 megabytes" do
      expect(backend.max_size).to be <= 10_485_760
    end

    it "file great than 10 megabytes is invalid" do
      expect(backend.max_size).to_not be > 10_485_760
>>>>>>> added test to file size
    end
  end
end