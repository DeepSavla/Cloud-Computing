TASK 1:
1. What is the output of “nodes” and “net”

Output for nodes:

available nodes are: 
h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7

Output for net:

h1 h1-eth0:s3-eth2
h2 h2-eth0:s3-eth3
h3 h3-eth0:s4-eth2
h4 h4-eth0:s4-eth3
h5 h5-eth0:s6-eth2
h6 h6-eth0:s6-eth3
h7 h7-eth0:s7-eth2
h8 h8-eth0:s7-eth3
s1 lo:  s1-eth1:s2-eth1 s1-eth2:s5-eth1
s2 lo:  s2-eth1:s1-eth1 s2-eth2:s3-eth1 s2-eth3:s4-eth1
s3 lo:  s3-eth1:s2-eth2 s3-eth2:h1-eth0 s3-eth3:h2-eth0
s4 lo:  s4-eth1:s2-eth3 s4-eth2:h3-eth0 s4-eth3:h4-eth0
s5 lo:  s5-eth1:s1-eth2 s5-eth2:s6-eth1 s5-eth3:s7-eth1
s6 lo:  s6-eth1:s5-eth2 s6-eth2:h5-eth0 s6-eth3:h6-eth0
s7 lo:  s7-eth1:s5-eth3 s7-eth2:h7-eth0 s7-eth3:h8-eth0


2. What is the output of “h7 ifconfig”

h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
        inet6 fe80::1cbc:58ff:fe03:5658  prefixlen 64  scopeid 0x20<link>
        ether 1e:bc:58:03:56:58  txqueuelen 1000  (Ethernet)
        RX packets 268  bytes 28527 (28.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 12  bytes 936 (936.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

-----------------------------------------------------------------------------------------------------------------------------------

TASK 2:

1. Draw the function call graph of this controller. For example, once a packet comes to the
controller, which function is the first to be called, which one is the second, and so forth?

A. 
start switch : _handle_PacketIn() -> act_like_hub() -> resend_packet() -> send(msg)

 packet comes in to controller
	
        |
        V
	 __________________
	|                  |
	| _handle_PacketIn |
	|__________________|
	
	    |
	    V
	 __________________
	|                  |
	|   act_like_hub   | 
	|__________________|
	
	    |
	    V
	 __________________
	|                  |
	|  resend_packet   |
	|__________________|
		
	    |
	    V

     forward message to desired port



2. Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).
a. How long does it take (on average) to ping for each case?
b. What is the minimum and maximum ping you have observed?
c. What is the difference, and why?

Ans.
h1 ping -c100 h2
100 packets transmitted, 100 received, 0% packet loss, time 99252ms
rtt min/avg/max/mdev = 1.061/1.834/5.665/0.653 ms

h1 ping -c100 h8
100 packets transmitted, 100 received, 0% packet loss, time 99179ms
rtt min/avg/max/mdev = 4.084/6.229/14.161/1.674 ms



a. 	h1 ping h2 - On average the ping time was 1.834ms.
	h1 ping h8 - On average the ping time was 6.229ms.


b. 	h1 ping h2:
		Minimum ping: 1.061 ms
		Maximum ping: 5.665 ms
	h1 ping h8:
		Minimum ping: 4.084 ms
		Maximum ping: 14.161 ms


c. The ping time for h1 to h8 is much longer as compared to h1 ping h2 because in case of h1 ping h2 there is only one switch in between (i.e. s3) whereas in case of h1 ping h8 there are several switches(s3, s2, s1, s5, s7) in between which explains for the increased time taken.


3. Run “iperf h1 h2” and “iperf h1 h8”
a. What is “iperf” used for?
b. What is the throughput for each case?
c. What is the difference, and explain the reasons for the difference.

Ans.
a.	Iperf is a tool that helps admins measure the bandwidth for network performance and quality of a network line. It is used to measure the throughput between any two nodes in a network.

b.	
mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2 
.*** Results: ['15.6 Mbits/sec', '17.6 Mbits/sec']
mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8 
*** Results: ['5.26 Mbits/sec', '6.17 Mbits/sec']


c. The throughput for h1 h2 is higher because there is only one switch between them. Whereas for h1 h8 the packet needs to be moved through several switches that are there between them hence it takes more time.



4. Which of the switches observe traffic? Please describe your way for observing such
traffic on switches (e.g., adding some functions in the “of_tutorial” controller).

Ans.	We can inspect the information that aids in traffic observation by adding log.info("Switch observing traffic:%s"% (self.connection) to the line 107 "of tutorial" controller. 
Hence, all switches observe traffic.


-------------------------------------------------------------------------------------------------------------------------------------

TASK 3:

1. Describe how the above code works, such as how the "MAC to Port" map is established.
You could use a ‘ping’ example to describe the establishment process (e.g., h1 ping h2).

A.	For the operation where h1 pings h2, we know that the packet must be routed through switch s3. Here, mac_to_port is verified to see if packet.src is present as the key and the input port when the packet arrives from h1 on one of its input ports.
This indicates that whenever a packet is being sent to the host supplied in the key, the port may be used. If the pair is present, the packet is then sent to the specified port. This improves the performance when sending packets to known addresses. If pair is not present, the packet is sent to all ports while the switch learns by adding the key-value pair to the port's mac address.


2. (Comment out all prints before doing this experiment) Have h1 ping h2, and h1 ping
h8 for 100 times (e.g., h1 ping -c100 p2).
a. How long did it take (on average) to ping for each case?
b. What is the minimum and maximum ping you have observed?
c. Any difference from Task 2 and why do you think there is a change if there is?

Ans.

a. 	h1 ping h2 - On average the ping time was 1.55ms.
	h1 ping h8 - On average the ping time was 4.199ms.


b. 	h1 ping h2:
		Minimum ping: 1.001 ms
		Maximum ping: 5.005 ms
	h1 ping h8:
		Minimum ping: 4.524 ms
		Maximum ping: 12.351 ms


c. The average, min amd max ping time are slightly lower that that in task 2. This is because the swith no longer has to broadcast incoming packets every time, as it has a better understanding of the network due to the storage of known mac addresses. Since the address may be known, the ping time may get reduced.


Q.3 Run “iperf h1 h2” and “iperf h1 h8”.
a. What is the throughput for each case?
b. What is the difference from Task 2 and why do you think there is a change if
there is?


Ans.
a.	
mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2 
*** Results: ['28.3 Mbits/sec', '30.2 Mbits/sec']
mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8
*** Results: ['6.48 Mbits/sec', '6.87 Mbits/sec']


b. The throughput for task 3 is more than that for task 2 as there is almost no flooding of packets. Once all the mac addresses are known, the switched will not be burdened as the routhe are known.





