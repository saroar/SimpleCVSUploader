require "SimpleCSVUploder/version"

module SimpleCSVUploder
  def initialize(params = {})
    @file = params.delete(:file)
    super
    if @file
      self.filename = sanitize_filename(@file.original_filename)
      self.content_type = @file.content_type
      self.file_contents = @file.read
    end
  end

  def upload_local
    path = "#{Rails.root}/public/uploads/csv"
    FileUtils.mkdir_p(path) unless File.exists?(path)
    FileUtils.copy(@file.tempfile, path)
  end

  private

  def sanitize_filename(filename)
    return File.basename(filename)
  end

  def csv_file_format
    if self.content_type != "text/csv"
     errors.add(:file, 'File format should be only CSV.')
    end
  end

  NUM_BYTES_IN_MEGABYTE = 1048576
  def file_size_under_one_mb
    if (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
      errors.add(:file, 'File size cannot be over one megabyte.')
    end
  end
end
