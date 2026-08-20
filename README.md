# Enterprise Network Topology

## 1. Giới thiệu Dự án
Dự án thiết kế và triển khai hạ tầng mạng doanh nghiệp đa hãng (Cisco, MikroTik, FortiGate) theo mô hình 3 lớp chuẩn, tích hợp cơ chế dự phòng cao và cân bằng tải đa đường WAN.

---

## 2. Phân hoạch Vùng Mạng & VLAN
- VLAN 10 (Win PC / User LAN): Dải mạng 192.168.10.0/24, Gateway 192.168.10.1 do cặp CORE5 và CORE6 đảm nhận qua giao thức HSRP v2.
- VLAN 20 (Phòng Khách A): Dải mạng 192.168.20.0/24, Gateway 192.168.20.1 do cặp CORE5 và CORE6 đảm nhận.
- VLAN 30 (Phòng Khách B): Dải mạng 192.168.30.0/24, Gateway 192.168.30.1 do cặp CORE5 và CORE6 đảm nhận.
- VLAN 40 (Phòng Khách C): Dải mạng 192.168.40.0/24, Gateway 192.168.40.1 do cặp CORE5 và CORE6 đảm nhận.
- Phân vùng DMZ Web Server: Dải mạng 172.16.16.0/24, Gateway 172.16.16.1 do cặp Mikrotik1 và Mikrotik2 đảm nhận qua VRRP v2.
- Phân vùng AD / Internal DNS: Dải mạng 192.168.100.0/30, Gateway 192.168.100.1 do FortiGate NGFW kiểm soát qua port2.

---

## 3. Tổng hợp Công nghệ & Kiến trúc Chính
- Lớp Switch Core (Cisco CORE5 & CORE6): Triển khai HSRP v2 cho gateway ảo, Rapid-PVST+ chống vòng lặp Layer 2 và LACP EtherChannel Port-channel1 gộp băng thông liên kết.
- Lớp Router Biên (MikroTik Cluster): Triển khai VRRP v2 dự phòng gateway DMZ, cân bằng tải Dual-WAN PCC 50/50 qua ISP3/ISP4 và tự động chuyển mạch nhờ Check-Gateway Ping.
- Lớp Bảo mật NGFW (FortiGate): Phân vùng an ninh và thiết lập bộ chính sách kiểm soát truy cập (Stateful Firewall Policies) giữa LAN và máy chủ Active Directory / DNS.
- Định tuyến Động Nội bộ (OSPF Area 0): Tự động đồng bộ và tính toán bảng đường đi giữa Core Switch Cisco, Router MikroTik và FortiGate.
- Mạng Ngoại vi & Chi nhánh (ISP Core & R22): Thiết lập kết nối eBGP giữa các AS 20, AS 30, AS 100 mô phỏng nhà mạng và liên kết Router chi nhánh xa R22.

---

## 4. Thư mục Cấu hình & Tài liệu
- Thư mục configs: Chứa toàn bộ file cấu hình thiết bị gồm CORE5.txt, CORE6.txt, Mikrotik1.rsc, Mikrotik2.rsc, FortiGate.conf, ISP3.txt, ISP4.txt, ISP5.txt, R22.txt và các Access Switch sw7.txt đến sw12.txt.
- Thư mục topology: Chứa các ảnh sơ đồ tổng quan và sơ đồ chi tiết từng phân vùng mạng.


