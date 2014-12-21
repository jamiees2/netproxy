PWD=$(pwd)
apt-get update -qq && apt-get install -y software-properties-common
add-apt-repository -y ppa:vbernat/haproxy-1.5
apt-get update -qq && apt-get install -y haproxy iptables git supervisor
git clone https://github.com/jamiees2/tunlr-style-dns-unblocking.git tunlr

cd $PWD/tunlr/

cp $PWD/config.json $PWD/tunlr/
python genconf.py pure-sni -d
sed -i "s/\/dev\/log/127.0.0.1/" haproxy.conf
sed -i "s/bind [0-9\.]\+/bind */" haproxy.conf
sed -i "s/daemon//" haproxy.conf
mv haproxy.conf /etc/haproxy/haproxy.cfg

cp $PWD/supervisord/haproxy.conf /etc/supervisor/conf.d/

/usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
