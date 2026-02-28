function download-mp3 --description 'Download audio as MP3 using yt-dlp'
    if not type -q yt-dlp
        echo "Error: yt-dlp is not installed" >&2
        return 1
    end
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 $argv
end
