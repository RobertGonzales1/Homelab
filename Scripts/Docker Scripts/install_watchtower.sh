#Docker Watchtower:
# Checks for and applies image updates once a day at 02:50 local time (6-field cron:
# sec min hour day month weekday). 02:50 falls between the hourly Semaphore checks,
# so a container restart (Semaphore's included) never interrupts a long job.
# TZ makes the schedule local time; without it Watchtower uses UTC.
#
# Discord notifications (optional): set DISCORD_WEBHOOK_URL when running the script.
# Start the command with a space so the webhook stays out of your shell history
# (Ubuntu's default HISTCONTROL=ignoreboth skips space-prefixed commands):
#     curl -fsSL <this script's raw URL> | DISCORD_WEBHOOK_URL='https://discord.com/api/webhooks/<id>/<token>' bash
# Never put the webhook in this file - the repo is public. Without it Watchtower runs
# without notifications; the Semaphore template Docker_Watchtower_Schedule adds them
# later (it uses the same webhook as the playbooks).
# Watchtower then posts only when it updates something or hits an error; no startup
# message, so reboots stay quiet. Messages are titled with this VM's hostname.

WATCHTOWER_ENV=(-e TZ=America/Los_Angeles -e WATCHTOWER_SCHEDULE="0 50 2 * * *")
ENV_FILE=""

if [ -n "${DISCORD_WEBHOOK_URL:-}" ]; then
    # https://discord.com/api/webhooks/<id>/<token>  ->  discord://<token>@<id>
    if [[ "$DISCORD_WEBHOOK_URL" =~ ^https://(discord|discordapp)\.com/api/webhooks/([0-9]+)/([A-Za-z0-9_-]+) ]]; then
        # Passed through a root-only env file so the webhook isn't on the command line.
        ENV_FILE=$(sudo mktemp /root/watchtower.env.XXXXXX)
        printf 'WATCHTOWER_NOTIFICATION_URL=discord://%s@%s?username=Watchtower\nWATCHTOWER_NOTIFICATIONS_HOSTNAME=%s\nWATCHTOWER_NO_STARTUP_MESSAGE=true\n' \
            "${BASH_REMATCH[3]}" "${BASH_REMATCH[2]}" "$(hostname)" | sudo tee "$ENV_FILE" > /dev/null
        WATCHTOWER_ENV+=(--env-file "$ENV_FILE")
        echo "Watchtower: Discord notifications on."
    else
        echo "Watchtower: DISCORD_WEBHOOK_URL isn't a https://discord.com/api/webhooks/<id>/<token> URL - installing without notifications."
    fi
else
    echo "Watchtower: no DISCORD_WEBHOOK_URL - installing without notifications (run the Docker_Watchtower_Schedule template in Semaphore to add them)."
fi

sudo docker run -d \
    --name watchtower \
    --restart=always \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    "${WATCHTOWER_ENV[@]}" \
    nickfedor/watchtower

if [ -n "$ENV_FILE" ]; then
    sudo rm -f "$ENV_FILE"
fi
