# ブリッジ作成及び起動、IPアドレス設定
sudo brctl addbr br0
sudo ip link set br0 up
sudo ip addr add 192.168.1.100/24 dev br0

# 仮想インタフェースのペア作成及びホスト側の仮想インターフェース起動後ブリッジに接続
sudo ip link add name veth0 type veth peer name veth1
sudo ip link set veth0 up
sudo brctl addif br0 veth0

# 名前空間の作成、コンテナ側のインターフェースを名前空間に設定
sudo ip netns add netns0
sudo ip link set veth1 netns netns0

# コンテナ側のインターフェースにIPアドレスの設定、
sudo ip netns exec netns0 ip addr add 192.168.1.110/24 dev veth1
sudo ip netns exec netns0 ip link set veth1 up
sudo ip netns exec netns0 ip route add default via 192.168.1.100
