# aug/20/2026 03:06:46 by RouterOS 7.1.1
# software id = 
#
/interface vrrp
add authentication=simple interface=ether3 name=vrrp1 priority=200 version=2
/interface list
add name=WAN_List
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
/routing ospf instance
add name=ospf-instance-1 originate-default=if-installed redistribute=static \
    router-id=1.1.1.1
/routing ospf area
add instance=ospf-instance-1 name=ospf-area-1
/routing table
add disabled=no fib name=to_ISP3
add disabled=no fib name=to_ISP4
/interface list member
add interface=ether4 list=WAN_List
add interface=ether7 list=WAN_List
/ip address
add address=10.0.0.1/29 interface=ether5 network=10.0.0.0
add address=10.0.5.1/30 interface=ether2 network=10.0.5.0
add address=20.0.0.1/30 interface=ether4 network=20.0.0.0
add address=172.16.16.1 interface=vrrp1 network=172.16.16.0
add address=172.16.16.2/24 interface=ether3 network=172.16.16.0
add address=30.0.1.1/30 interface=ether7 network=30.0.1.0
/ip dhcp-client
add interface=ether1
/ip firewall address-list
add address=192.168.0.0/16 list=LANlist
add address=172.16.16.0/24 list=LANlist
/ip firewall filter
add action=accept chain=forward connection-state=established,related
add action=accept chain=forward dst-address=100.100.100.2 dst-port=53 \
    protocol=udp src-address=192.168.100.2
add action=accept chain=forward dst-address=100.100.100.2 protocol=icmp \
    src-address=192.168.100.2
add action=accept chain=forward src-address=192.168.10.0/24
add action=accept chain=forward src-address=192.168.20.0/24
add action=accept chain=forward src-address=192.168.30.0/24
add action=accept chain=forward src-address=192.168.40.0/24
add action=accept chain=forward dst-address=172.16.16.100 dst-port=80 \
    protocol=tcp
add action=accept chain=forward dst-address=100.100.100.2 dst-port=53 \
    protocol=udp src-address=192.168.100.2
add action=drop chain=forward
/ip firewall mangle
add action=accept chain=prerouting dst-address-list=LANlist
add action=mark-connection chain=prerouting dst-address-list=!LANlist \
    new-connection-mark=ISP3_conn passthrough=yes per-connection-classifier=\
    both-addresses-and-ports:2/0
add action=mark-connection chain=prerouting dst-address-list=!LANlist \
    new-connection-mark=ISP4_conn passthrough=yes per-connection-classifier=\
    both-addresses-and-ports:2/1
add action=mark-routing chain=prerouting connection-mark=ISP3_conn log=yes \
    new-routing-mark=to_ISP3 passthrough=no src-address-list=LANlist
add action=mark-routing chain=prerouting connection-mark=ISP4_conn log=yes \
    new-routing-mark=to_ISP4 passthrough=no src-address-list=LANlist
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN_List
add action=dst-nat chain=dstnat dst-address=20.0.0.1 dst-port=80 log=yes \
    protocol=tcp to-addresses=172.16.16.100 to-ports=80
add action=dst-nat chain=dstnat dst-address=30.0.1.1 dst-port=80 log=yes \
    protocol=tcp to-addresses=172.16.16.100 to-ports=80
/ip route
add check-gateway=ping disabled=no distance=2 dst-address=0.0.0.0/0 gateway=\
    20.0.0.2 pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add check-gateway=ping disabled=no distance=10 dst-address=0.0.0.0/0 gateway=\
    30.0.1.2 pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10
add check-gateway=ping disabled=no dst-address=0.0.0.0/0 gateway=20.0.0.2 \
    routing-table=to_ISP3 suppress-hw-offload=no
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    30.0.1.2 pref-src="" routing-table=to_ISP4 scope=30 suppress-hw-offload=\
    no target-scope=10
/routing ospf interface-template
add area=ospf-area-1 interfaces=ether2
add area=ospf-area-1 interfaces=ether3
add area=ospf-area-1 interfaces=ether5
add area=ospf-area-1 interfaces=ether6
