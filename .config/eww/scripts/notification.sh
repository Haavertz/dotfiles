# #!/bin/bash

# get_audio="$1"

# eww open notification-audio

# val=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
# step="0.05"

# if [[ "$get_audio" == "+" ]]; then
#     new_val=$(echo "$val + $step" | bc)
# elif [[ "$get_audio" == "-" ]]; then
#     new_val=$(echo "$val - $step" | bc)
# else
#     new_val="$val"
# fi

# if (( $(echo "$new_val > 1.0" | bc -l) )); then
#     new_val=1.0
# elif (( $(echo "$new_val < 0.0" | bc -l) )); then
#     new_val=0.0
# fi

# wpctl set-volume @DEFAULT_SINK@ "$new_val"
# eww -c ~/.config/eww/ update current-sound-value="$new_val"
