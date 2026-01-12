gogcli manifest generate --lang=english --os=windows
gogcli storage plan --empty-checksum
gogcli storage apply manifest --empty-checksum
gogcli storage execute-actions
