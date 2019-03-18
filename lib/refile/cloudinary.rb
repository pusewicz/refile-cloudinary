require 'open-uri'
require 'cloudinary'
require 'refile'
require 'refile/cloudinary/version'

module Refile
  # A refile backend which stores files in Cloudinary
  #
  # @example
  #   backend = Refile::Cloudinary.new(
  #     cloud_name: "hfkkd49r3",
  #     api_key: "some-key",
  #     api_secret: "some-secret"
  #   )
  #   file = backend.upload(StringIO.new("hello"))
  #   backend.read(file.id) # => "hello"
  class Cloudinary
    extend Refile::BackendMacros

    attr_reader :max_size

    # Sets up an Cloudinary backend
    #
    # @param [String] cloud_name The Cloudinary cloud name
    # @param [String] api_key The Cloudinary api key
    # @param [String] api_secret The Cloudinary api secret
    def initialize(auth, max_size: 10_485_760)
      @max_size = max_size
      @auth = auth
    end

    # Upload a file into this backend
    #
    # @param [IO] uploadable An uploadable IO-like object.
    # @return [Refile::File] The uploaded file
    verify_uploadable def upload(uploadable)
      file = Tempfile.new('upload')
      file.binmode
      file.write(uploadable.read)
      file.close
      upload = ::Cloudinary::Uploader.upload(
        file.path,
        @auth.merge(tags: file.size)
      )
      Refile::File.new(self, upload['public_id'])
    end

    # Get a file from this backend.
    #
    # Note that this method will always return a {Refile::File} object, even
    # if a file with the given id does not exist in this backend. Use
    # {FileSystem#exists?} to check if the file actually exists.
    #
    # @param [String] id The id of the file
    # @return [Refile::File] The retrieved file
    verify_id def get(id)
      Refile::File.new(self, id)
    end

    # Delete a file from this backend
    #
    # @param [String] id The id of the file
    # @return [void]
    verify_id def delete(id)
      ::Cloudinary::Api.delete_resources([id], @auth)
    end

    # Return an IO object for the uploaded file which can be used to read its
    # content.
    #
    # @param [String] id The id of the file
    # @return [IO] An IO object containing the file contents
    verify_id def open(id)
      contents = ::Cloudinary::Downloader.download(id, @auth)
      file = Tempfile.new('file')
      file.binmode
      file.write(contents)
      file.close
      file.open
    end

    # Return the entire contents of the uploaded file as a String.
    #
    # @param [String] id The id of the file
    # @return [String] The file's contents
    verify_id def read(id)
      contents = ::Cloudinary::Downloader.download(id, @auth)
      contents == '' ? nil : contents
    end

    # Return the size in bytes of the uploaded file.
    #
    # @param [String] id The id of the file
    # @return [Integer] The file's size
    verify_id def size(id)
      resource = object(id)
      resource ? resource['bytes'] : nil
    end

    # Return whether the file with the given id exists in this backend.
    #
    # @param [String] id The id of the file
    # @return [Boolean]
    verify_id def exists?(id)
      ::Cloudinary::Api.resource(id, @auth)
      true
    rescue ::Cloudinary::Api::NotFound
      false
    end

    # Remove all files in this backend. You must confirm the deletion by
    # passing the symbol `:confirm` as an argument to this method.
    #
    # @example
    #   backend.clear!(:confirm)
    # @raise [Refile::Confirm] Unless the `:confirm` symbol has been passed.
    # @param [:confirm] confirm Pass the symbol `:confirm` to confirm deletion.
    # @return [void]
    def clear!(confirm = nil)
      raise Refile::Confirm unless confirm == :confirm
      ::Cloudinary::Api.delete_all_resources(@auth)
    end

    verify_id def object(id)
      ::Cloudinary::Api.resource(id, @auth)
    rescue ::Cloudinary::Api::NotFound
      nil
    end
  end
end
