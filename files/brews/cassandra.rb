require 'formula'

class Cassandra < Formula
  homepage 'http://cassandra.apache.org'
  url 'http://archive.apache.org/dist/cassandra/1.2.9/apache-cassandra-1.2.9-bin.tar.gz'
  version '1.2.9-boxen1'
  sha1 'f6a5738200b281ef098e90be3fa30cf2'

  def install
    (etc+"cassandra").mkpath

    inreplace "conf/cassandra.yaml", "/var/lib/cassandra", "#{var}/lib/cassandra"
    inreplace "conf/log4j-server.properties", "/var/log/cassandra", "#{var}/log/cassandra"
    inreplace "conf/cassandra-env.sh", "/lib/", "/"

    inreplace "bin/cassandra.in.sh" do |s|
      s.gsub! "CASSANDRA_HOME=`dirname $0`/..", "CASSANDRA_HOME=#{prefix}"
      # Store configs in etc, outside of keg
      s.gsub! "CASSANDRA_CONF=$CASSANDRA_HOME/conf", "CASSANDRA_CONF=#{etc}/cassandra"
      # Jars installed to prefix, no longer in a lib folder
      s.gsub! "$CASSANDRA_HOME/lib/*.jar", "$CASSANDRA_HOME/*.jar"
    end

    rm Dir["bin/*.bat"]

    (etc+"cassandra").install Dir["conf/*"]
    prefix.install Dir["*.txt"] + Dir["{bin,interface,javadoc,pylib,lib/licenses}"]
    prefix.install Dir["lib/*.jar"]
  end
end
