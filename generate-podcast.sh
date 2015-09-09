#!/bin/bash

feed=feed.xml
base_url=http://salomvary.github.io/podcast-generator/example

function say_to_mp3() {
  tmp_file="$(mktemp -t episode).aiff"
  file="$(basename -s .aiff "$tmp_file").mp3"

  say "$1" -o "$tmp_file"
  lame --quiet --tg spoken -m m "$tmp_file" "$file"
  rm "$tmp_file"
  echo "$file"
}

echo "<?xml version='1.0' encoding='utf-8'?>
<rss xmlns:itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' xmlns:atom='http://www.w3.org/2005/Atom' version='2.0'>
  <channel>
    <title>Generated Podcast</title>
    <description>Feed of randomly generated podcasts</description>
    <atom:link href='$base_url/$feed' rel='self' type='application/rss+xml' />
    <link>http://example.org/</link>" > "$feed"

for i in {1..5}; do
  fortune=$(fortune -s)
  mp3=$(say_to_mp3 "$fortune")
  length=$(stat -f %z "$mp3")
  echo "    <item>
      <title><![CDATA[$(echo "$fortune" | head -n 1)]]></title>
      <link>http://example.org/2003/12/13/atom03'</link>
      <guid isPermaLink='false'>$(uuidgen)</guid>
      <enclosure url='$base_url/$mp3' length='$length' type='audio/mpeg'/>
			<pubDate>$(date +"%a, %d %b %Y %T %z")</pubDate>
    </item>" >> "$feed"
done

echo '  </channel>
</rss>' >> "$feed"

echo "$feed written."
