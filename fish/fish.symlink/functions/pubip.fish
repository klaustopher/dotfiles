function pubip --description 'Show current public IP and location'
    if not type -q curl
        echo "Error: curl is not installed" >&2
        return 1
    end

    set -l json (curl -s https://ipinfo.io)

    if type -q jq
        set -l ip (echo $json | jq -r '.ip')
        set -l location (echo $json | jq -r '[.city, .region, .country] | map(select(. != null and . != "")) | join(", ")')
        printf "Current IP "; set_color --bold yellow; printf "%s" $ip; set_color normal
        printf ", located in "; set_color --bold yellow; printf "%s" $location; set_color normal
        echo "."
    else
        # jq not available — just show the raw IP
        echo $json | string match -rg '"ip":"?([^",]+)"?' | head -1
    end
end
