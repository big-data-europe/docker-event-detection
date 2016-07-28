#!/usr/bin/env bash

# get all jars to the classpath
# filter out conflicting jars
conflictingJars="httpcore-4.1.2.jar httpclient-4.1.2.jar cassandra-driver-core-2.1.7.1.jar guava-14.0.1.jar"
find * -name *.jar  > temp
jarcount="$(wc -l <  temp)"
for confl in $conflictingJars; do
	cat temp | grep -v $confl > temp2
	cat temp2 > temp
done

echo "Dropped $(( $jarcount - $( wc -l < temp ) )) conflicting jarfile occurencies."

echo "$(cat temp | tr '\n' ':')" > "$CLASSPATHFILE"
rm temp temp2




