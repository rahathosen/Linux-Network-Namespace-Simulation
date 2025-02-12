#!/bin/bash

echo "[+] Testing connectivity..."

echo "[+] Ping from ns1 to router-ns..."
ip netns exec ns1 ping -c 3 192.168.1.1

echo "[+] Ping from ns2 to router-ns..."
ip netns exec ns2 ping -c 3 192.168.2.1

echo "[+] Ping from ns1 to ns2..."
ip netns exec ns1 ping -c 3 192.168.2.2

echo "[✓] Connectivity tests completed!"
