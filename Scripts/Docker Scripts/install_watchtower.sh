#Docker Watchtower:
# Checks for and applies image updates once a day at 02:50 local time (6-field cron:
# sec min hour day month weekday). 02:50 falls between the hourly Semaphore checks,
# so a container restart (Semaphore's included) never interrupts a long job.
# TZ makes the schedule local time; without it Watchtower uses UTC.
sudo docker run -d \
    --name watchtower \
    --restart=always \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    -e TZ=America/Los_Angeles \
    -e WATCHTOWER_SCHEDULE="0 50 2 * * *" \
    nickfedor/watchtower
