module StreamingDownload
  extend ActiveSupport::Concern

  def set_streaming_headers(filename)
    headers['Content-Type'] = 'text/csv'
    headers['Content-Disposition'] = 'attachment;'
    headers['Content-Disposition'] += " filename=\"#{filename}\""
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] = "no-cache"
    headers.delete("Content-Length")
  end
end