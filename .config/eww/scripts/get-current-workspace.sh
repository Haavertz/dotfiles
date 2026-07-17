hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'
# get all worspaces -> "hyprctl workspaces -j | jq '.[] | select(.id != -98) | .id'"
