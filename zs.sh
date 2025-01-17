#!/bin/bash

if [ -e "/var/log/zabbix/zabbix_server.log" ]; then
LOG="/var/log/zabbix/zabbix_server.log"
else
LOG=$1
fi

if [ -z "$2" ]; then
WORKDIR="/tmp"
else
WORKDIR="$2"
fi


OUT="$WORKDIR/autozbx"

mkdir -p "$OUT"

echo 'query failed messages - database problems'
grep "query failed" "$LOG" > "$OUT/query.failed.log"

echo 'looking for "please increase" meassages'
grep "increase" "$LOG" > "$OUT/increase.log"

echo 'identify restarts'
grep " Zabbix Server" "$LOG" > "$OUT/Zabbix.Server.restart.log"

echo 'proxy restarts'
grep " Zabbix Proxy" "$LOG" > "$OUT/Zabbix.Proxy.restart.log"

echo 'failed to accept incoming connections'
grep " failed to accept an incoming connection" "$LOG" > "$OUT/failed.to.accept.an.incoming.connection.log"

echo 'how many proxies. describe names'
grep " sending configuration data to proxy" "$LOG" > "$OUT/sending.configuration.data.to.proxy.log"

echo 'housekeeper statistics. how many records delete'
grep "housekeeper" "$LOG" > "$OUT/housekeeper.log"

echo 'evidence of increasing or decreasing log level'
grep "log level has been increased" "$LOG" | grep -Eo "[0-9]+:[0-9]+:" | sort | uniq > "$OUT/PIDs.log.level.log"

echo 'slow query'
grep "slow query" "$LOG" > "$OUT/slow.log"

echo "filter out any message without slow query"
grep -v "slow query" "$LOG" > "$OUT/without.slow.log"

echo 'timeout issues'
grep -i timeout "$LOG" > "$OUT/timeout.log"

echo 'Invalid regular expression'
grep " Invalid regular expression " "$LOG" > "$OUT/Invalid.regular.expression.log"

echo 'SIGTEERM restarts'
grep SIGTERM "$LOG" > "$OUT/SIGTERM.log"

echo 'table metadata lock'
grep "table metadata lock" "$LOG" > "$OUT/table.metadata.lock.log"

echo 'how much time spend on shutdown'
grep " syncing " "$LOG" > "$OUT/syncing.log"

echo 'Permission denied'
grep "Permission denied" "$LOG" > "$OUT/Permission.denied.log"

echo 'serious network issue'
grep "reading first byte from connection failed" "$LOG" > "$OUT/reading.first.byte.from.connection.failed.log"

echo 'frequency of configuration syncer'
grep " configuration data " "$LOG" > "$OUT/configuration.data.log"

echo 'Message ignored'
grep "  Message ignored" "$LOG" > "$OUT/Message.ignored.log"

echo 'Something impossible has just happened'
grep " Something impossible has just happened" "$LOG" > "$OUT/Something.impossible.has.just.happened.log"

echo 'cannot extract value from json by path'
grep "cannot extract value from json by path" "$LOG" > "$OUT/cannot.extract.value.from.json.by.path.log"

echo 'problem with device onboarding conflicting item key'
grep " conflicting item key " "$LOG" > "$OUT/conflicting.item.key.log"

echo 'problem with onboarding'
grep "cannot link template" "$LOG" > "$OUT/cannot.link.template.log"

echo 'engagemetn with active proxy'
grep -Eo "sending configuration data to proxy \S+" "$LOG" | sort | uniq > "$OUT/proxy.list.log"

echo 'booting up server process'
grep " Starting Zabbix Server. " "$LOG" > "$OUT/Starting.Zabbix.Server.log"

echo 'Cannot evaluate expression'
grep "Cannot evaluate expression" "$LOG" > "$OUT/Cannot.evaluate.expression.log"

echo 'limitations per vmware. Error of query maxQueryMetrics'
grep "Error of query maxQueryMetrics" "$LOG" > "$OUT/maxQueryMetrics.log"

echo 'active checks not completed'
grep -Eo "cannot send list of active checks.*" "$LOG" | sort | uniq > "$OUT/cannot.send.list.of.active.checks.log"

echo 'indicate amount of process list and PIDs'
grep " server #.* started" "$LOG" > "$OUT/PID.translation.log"

echo 'lines which does not match popular patters'
grep -v "housekeeper\|cannot extract value from json by path\|cannot send list of active checks\|Cannot evaluate expression\|became not supported\|became supported\|slow query\|sending configuration data to proxy\|conflicting item key" "$LOG" > "$OUT/new.log"

echo 'network error'
grep -Eo "host.*network error" "$LOG" > "$OUT/host.network.error.log"

grep "slow query.*insert into history_str" "$LOG" > "$OUT/slow.query.insert.into.history_str.log"
grep "slow query.*insert into history_log" "$LOG" > "$OUT/slow.query.insert.into.history_log.log"
grep "slow query.*insert into history_text" "$LOG" > "$OUT/slow.query.insert.into.history_text.log"
grep "slow query.*insert into history_uint" "$LOG" > "$OUT/slow.query.insert.into.history_uint.log"
grep "slow query.*insert into history " "$LOG" > "$OUT/slow.query.insert.into.history.log"
grep "slow query.*select distinct t.triggerid" "$LOG" > "$OUT/slow.query.select.distinct.t.triggerid.log"
grep "slow query.*select i.itemid,i.value_type,i.history" "$LOG" > "$OUT/slow.query.select.distinct.i.itemid.log"
grep "slow query.*delete from events" "$LOG" > "$OUT/slow.query.delete.from.events.log"

echo 'slow queries more than 10 seconds'
grep -Eo "slow query: [0-9][0-9]+\.[0-9]+ sec" "$LOG" > "$OUT/slow.query.more.than.10.seconds.log"

echo 'slow queries more than 100 seconds'
grep -Eo "slow query: [0-9][0-9][0-9]+\.[0-9]+ sec" "$LOG" > "$OUT/slow.query.more.than.100.seconds.log"

# remove all empty files in working directory
if [ -d "$OUT" ]; then
    # Find and remove all files with size 0
    find "$OUT" -type f -size 0 -exec rm -f {} +
    echo "All 0-byte files in '$OUT' have been removed."
else
    echo "Directory '$OUT' does not exist."
fi
