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

grep "query failed" "$LOG" > "$OUT/query.failed.log"
grep increase "$LOG" > "$OUT/increase.log"
grep " Zabbix Server" "$LOG" > "$OUT/Zabbix.Server.restart.log"
grep " Zabbix Proxy" "$LOG" > "$OUT/Zabbix.Proxy.restart.log"
grep " failed to accept an incoming connection" "$LOG" > "$OUT/failed.to.accept.an.incoming.connection.log"
grep " sending configuration data to proxy" "$LOG" > "$OUT/sending.configuration.data.to.proxy.log"
grep housekeeper "$LOG" > "$OUT/housekeeper.log"
grep "log level has been increased" "$LOG" | grep -Eo "[0-9]+:[0-9]+:" | sort | uniq > "$OUT/PIDs.log.level.log"
grep "slow query" "$LOG" > "$OUT/slow.log"
grep -v "slow query" "$LOG" > "$OUT/without.slow.log"
grep -i timeout "$LOG" > "$OUT/timeout.log"
grep " Invalid regular expression " "$LOG" > "$OUT/Invalid.regular.expression.log"
grep SIGTERM "$LOG" > "$OUT/SIGTERM.log"
grep "table metadata lock" "$LOG" > "$OUT/table.metadata.lock.log"
grep " syncing " "$LOG" > "$OUT/syncing.log"
grep "Permission denied" "$LOG" > "$OUT/Permission.denied.log"
grep "reading first byte from connection failed" "$LOG" > "$OUT/reading.first.byte.from.connection.failed.log"
grep " configuration data " "$LOG" > "$OUT/configuration.data.log"
grep "  Message ignored" "$LOG" > "$OUT/Message.ignored.log"
grep " Something impossible has just happened" "$LOG" > "$OUT/Something.impossible.has.just.happened.log"
grep "cannot extract value from json by path" "$LOG" > "$OUT/cannot.extract.value.from.json.by.path.log"
grep " conflicting item key " "$LOG" > "$OUT/conflicting.item.key.log"
grep "cannot link template" "$LOG" > "$OUT/cannot.link.template.log"
grep -Eo "sending configuration data to proxy \S+" "$LOG" | sort | uniq > "$OUT/proxy.list.log"
grep " Starting Zabbix Server. " "$LOG" > "$OUT/Starting.Zabbix.Server.log"
grep "Cannot evaluate expression" "$LOG" > "$OUT/Cannot.evaluate.expression.log"
grep "Error of query maxQueryMetrics" "$LOG" > "$OUT/maxQueryMetrics.log"
grep -Eo "cannot send list of active checks.*" "$LOG" | sort | uniq > "$OUT/cannot.send.list.of.active.checks.log"
grep " server #.* started" "$LOG" > "$OUT/PID.translation.log"
grep -v "housekeeper\|cannot extract value from json by path\|cannot send list of active checks\|Cannot evaluate expression\|became not supported\|became supported\|slow query\|sending configuration data to proxy\|conflicting item key" "$LOG" > "$OUT/new.log"
grep -Eo "host.*network error" "$LOG" > "$OUT/host.network.error.log"
grep "slow query.*insert into history_str" "$LOG" > "$OUT/slow.query.insert.into.history_str.log"
grep "slow query.*insert into history_log" "$LOG" > "$OUT/slow.query.insert.into.history_log.log"
grep "slow query.*insert into history_text" "$LOG" > "$OUT/slow.query.insert.into.history_text.log"
grep "slow query.*insert into history_uint" "$LOG" > "$OUT/slow.query.insert.into.history_uint.log"
grep "slow query.*insert into history " "$LOG" > "$OUT/slow.query.insert.into.history.log"
grep "slow query.*select distinct t.triggerid" "$LOG" > "$OUT/slow.query.select.distinct.t.triggerid.log"
grep "slow query.*select i.itemid,i.value_type,i.history" "$LOG" > "$OUT/slow.query.select.distinct.i.itemid.log"
grep "slow query.*delete from events" "$LOG" > "$OUT/slow.query.delete.from.events.log"
grep -Eo "slow query: [0-9][0-9]+\.[0-9]+ sec" "$LOG" > "$OUT/slow.query.more.than.10.seconds.log"
grep -Eo "slow query: [0-9][0-9][0-9]+\.[0-9]+ sec" "$LOG" > "$OUT/slow.query.more.than.100.seconds.log"

# remove all empty files in working directory
if [ -d "$OUT" ]; then
    # Find and remove all files with size 0
    find "$OUT" -type f -size 0 -exec rm -f {} +
    echo "All 0-byte files in '$OUT' have been removed."
else
    echo "Directory '$OUT' does not exist."
fi
