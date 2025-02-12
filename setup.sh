#!/bin/bash

set -e  # Exit on error

echo "[+] Cleaning up previous configurations..."
ip netns del ns1 2>/dev/null || true
ip netns del ns2 2>/dev/null || true
ip netns del router-ns 2>/dev/null || true
ip link del br0 2>/dev/null || true
ip link del br1 2>/dev/null || true
ip link del veth-ns1 2>/dev/null || true
ip link del veth-ns2 2>/dev/null || true
ip link del veth-router0 2>/dev/null || true
ip link del veth-router1 2>/dev/null || true

echo "[+] Creating network namespaces..."
ip netns add ns1
ip netns add ns2
ip netns add router-ns

echo "[+] Creating network bridges..."
ip link add br0 type bridge
ip link add br1 type bridge
ip link set br0 up
ip link set br1 up

echo "[+] Creating virtual Ethernet pairs..."
ip link add veth-ns1 type veth peer name veth-br0
ip link add veth-ns2 type veth peer name veth-br1
ip link add veth-router0 type veth peer name veth-br0-router
ip link add veth-router1 type veth peer name veth-br1-router

echo "[+] Assigning interfaces to namespaces..."
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2
ip link set veth-router0 netns router-ns
ip link set veth-router1 netns router-ns

echo "[+] Connecting interfaces to bridges..."
ip link set veth-br0 master br0
ip link set veth-br1 master br1
ip link set veth-br0-router master br0
ip link set veth-br1-router master br1
ip link set veth-br0 up
ip link set veth-br1 up
ip link set veth-br0-router up
ip link set veth-br1-router up

echo "[+] Assigning IP addresses..."
ip netns exec ns1 ip addr add 192.168.1.2/24 dev veth-ns1
ip netns exec ns2 ip addr add 192.168.2.2/24 dev veth-ns2
ip netns exec router-ns ip addr add 192.168.1.1/24 dev veth-router0
ip netns exec router-ns ip addr add 192.168.2.1/24 dev veth-router1

echo "[+] Bringing up interfaces..."
ip netns exec ns1 ip link set veth-ns1 up
ip netns exec ns2 ip link set veth-ns2 up
ip netns exec router-ns ip link set veth-router0 up
ip netns exec router-ns ip link set veth-router1 up
ip netns exec ns1 ip link set lo up
ip netns exec ns2 ip link set lo up
ip netns exec router-ns ip link set lo up

echo "[+] Enabling IP forwarding..."
ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1

echo "[+] Configuring routing..."
ip netns exec ns1 ip route add default via 192.168.1.1
ip netns exec ns2 ip route add default via 192.168.2.1

echo "[✓] Network setup complete!"
