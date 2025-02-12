#!/bin/bash

echo "[+] Cleaning up network namespaces and bridges..."

ip netns del ns1 2>/dev/null || true
ip netns del ns2 2>/dev/null || true
ip netns del router-ns 2>/dev/null || true

ip link del br0 2>/dev/null || true
ip link del br1 2>/dev/null || true

ip link del veth-ns1 2>/dev/null || true
ip link del veth-ns2 2>/dev/null || true
ip link del veth-router0 2>/dev/null || true
ip link del veth-router1 2>/dev/null || true

echo "[✓] Cleanup complete!"
