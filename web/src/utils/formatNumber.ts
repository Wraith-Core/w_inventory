/**
 * Format large numbers into compact form:
 * 999 → "999"
 * 1000 → "1K"
 * 1500 → "1.5K"
 * 10000 → "10K"
 * 100000 → "100K"
 * 1000000 → "1M"
 */
export function formatCompact(n: number): string {
  n = Number(n) || 0;
  if (n < 0) return '-' + formatCompact(-n);
  if (n < 1000) return n % 1 === 0 ? n.toString() : n.toFixed(2);
  if (n < 1_000_000) {
    const k = n / 1000;
    return k % 1 === 0 ? `${k}K` : `${parseFloat(k.toFixed(1))}K`;
  }
  if (n < 1_000_000_000) {
    const m = n / 1_000_000;
    return m % 1 === 0 ? `${m}M` : `${parseFloat(m.toFixed(1))}M`;
  }
  const b = n / 1_000_000_000;
  return b % 1 === 0 ? `${b}B` : `${parseFloat(b.toFixed(1))}B`;
}
