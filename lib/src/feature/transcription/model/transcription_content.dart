enum TranscriptionContent(final String pattern) {
  youtube(
    r'(https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/'
    r'(watch\?.*v=|embed/|v/|.+\?v=)?([^&=%\?]{11})',
  ),
  rutube(r'^https?://(?:www\.)?rutube\.ru/video/[a-zA-Z0-9_-]+/?(\?.*)?$'),
  googleDrive(r'^https?://(www\.)?drive\.google\.com/file/d/([a-zA-Z0-9_-]+)(/.*)?(\?.*)?$'),
  yandexDisk(r'^https?://(?:www\.)?(?:disk\.yandex\.ru/(?:[a-z]|client/disk)|yadi\.sk/d)/[a-zA-Z0-9_-]+(/.*)?(\?.*)?$'),
  zoom(r'^https?://(?:www\.)?zoom\.us/j/[0-9]+(\?.*)?$'),
}
