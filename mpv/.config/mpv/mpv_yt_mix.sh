#!/bin/bash

SHOW_VIDEO=false
DOWNLOAD_PATH=""
MIX_LINK=""
START_INDEX=0
SUBTITLES=false

yell() {
    echo "ERROR: [ $@ ]" >&2
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --video)
            SHOW_VIDEO=true
            shift
            ;;
        --start-index)
            START_INDEX=$2
            shift 2
            ;;
        --subtitles)
            SUBTITLES=true
            shift
            ;;
        --download)
            DOWNLOAD_PATH=$2
            shift 2
            ;;
        *)
            if [[ "$1" =~ ^https?:// ]]; then
                MIX_LINK="$1"
            fi
            shift
            ;;
    esac
done



check_command() {
    local command_name=$1
    command -v "$command_name" &>/dev/null
}

if ! check_command "mpv"; then
    yell "mpv is not installed, run the install script or install it using ur packet manager"
    exit 1
fi

if ! check_command "yt-dlp"; then
    yell "yt-dlp is not installed, run the install script or install it using ur packet manager"
    exit 1
fi

if [[ -z "$MIX_LINK" ]]; then
    yell "You must provide a YouTube mix link."
    exit 1
fi

MPV_CMD="mpv"
$SHOW_VIDEO || MPV_CMD+=" --no-video"
if $SUBTITLES; then
    MPV_CMD+=" --sub-ass"
fi

DOWNLOAD_PIDS=()

cleanup() {
    echo -e "\nCleaning up..."
    for pid in "${DOWNLOAD_PIDS[@]}"; do
        kill "$pid" 2>/dev/null
    done
    exit 1
}
trap cleanup INT TERM

if [[ -n "$DOWNLOAD_PATH" ]]; then
    echo "Streaming and downloading simultaneously..."

    mapfile -t playlist_ids < <(yt-dlp --flat-playlist --print "%(id)s" "$MIX_LINK")

    total_ids=${#playlist_ids[@]}
    echo "Total videos: $total_ids"
    echo "Starting at index: $START_INDEX"

    for ((i=START_INDEX; i<total_ids; i++)); do
        id="${playlist_ids[i]}"
        VIDEO_URL="https://www.youtube.com/watch?v=$id"
        OUTFILE="$DOWNLOAD_PATH/$(yt-dlp --get-filename -o "%(title)s.%(ext)s" "$VIDEO_URL")"

        TITLE=$(yt-dlp --get-title "$VIDEO_URL")
        echo "[$i/$total_ids] Now playing: \"$TITLE\""
        if [[ ! -f "$OUTFILE" ]]; then
            yt-dlp -o "$DOWNLOAD_PATH/%(title)s.%(ext)s" "$VIDEO_URL" &
            DOWNLOAD_PIDS+=($!)
        fi

        $MPV_CMD "$VIDEO_URL"
    done
else
    mapfile -t playlist_ids < <(yt-dlp -q --flat-playlist --print "%(id)s" "$MIX_LINK")

    total_ids=${#playlist_ids[@]}
    echo "Total videos: $total_ids"
    echo "Starting at index: $START_INDEX"

    for ((i=START_INDEX; i<total_ids; i++)); do
        id="${playlist_ids[i]}"
        VIDEO_URL="https://www.youtube.com/watch?v=$id"
        TITLE=$(yt-dlp --get-title "$VIDEO_URL")
        echo "[$i/$total_ids] Now playing: \"$TITLE\""
        $MPV_CMD "https://www.youtube.com/watch?v=$id"
    done
fi
