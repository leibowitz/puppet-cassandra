require 'formula'

class Cassandra < Formula
  homepage 'http://cassandra.apache.org'
  url 'http://archive.apache.org/dist/cassandra/1.2.9/apache-cassandra-1.2.9-bin.tar.gz'
  version '1.2.9-boxen1'
  sha1 '217b3731784899f0228ea6f5bf98c9821e7f750e'

  def install
    puts "creating config dif"
    (etc+"cassandra").mkpath

    puts "replacing 1"
    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    puts "replacing 2"
    inreplace "conf/log4j-server.properties", "/var/log/cassandra", "#{var}/log/cassandra"
    puts "replacing 3"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    puts "replacing 4"
    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=\"`dirname $0`/..\"", "CASSANDRA_HOME=\"#{prefix}\""
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=\"$CASSANDRA_HOME/conf\"", "CASSANDRA_CONF=\"#{etc}/cassandra\""
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "\"$CASSANDRA_HOME\"/lib/*.jar", "\"$CASSANDRA_HOME\"/*.jar"
    end

    puts "deleting"
    rm Dir["bin/*.bat"]

    puts "installing config"
    (etc+"cassandra").install Dir["conf/*"]
    puts "installing txt files"
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc,pylib,lib/licenses}"]
    puts "installing jar files"
    prefix.install Dir["lib/*.jar"]
  end
end
