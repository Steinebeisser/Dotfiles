# mpv_yt_mix

This is a small script that allows to listen to youtube mix playlists using yt-dlp and mpv

## Arguments

- `--video`: Shows the video (default is audio only)
- `--start-index <index>`: Starts the playlist at the specified index
- `--download <path>`: Downloads each song that gets played to the specified directory

---

## Example

```bash
mpv_yt_mix https://www.youtube.com/watch?v=9buluPWlkAA&list=RD9buluPWlkAA --download "/home/test/videos" --video --start-index 3
```

## Installation

To install the script and its dependencies, execute the following command:

```bash
./install.sh
```

This will install all necessary dependencies and place the script in your system's PATH.
