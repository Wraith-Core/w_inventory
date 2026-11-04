import type { CSSProperties } from 'react';

const PIECES = ['t', 'b', 'l', 'r', 'tl', 'tr', 'bl', 'br'] as const;

/**
 * The crafting frame itself (crafting_highlight in eight pieces) stuck to the edges of the nearest positioned
 * ancestor. Decoration only - with no pointer events, and mirrored in RTL.
 */
export default function Frame({
  color,
  px,
  opacity,
}: {
  color?: string;
  px?: number;
  opacity?: number;
}) {
  const style = {
    ...(color ? { '--fr-c': color } : null),
    ...(px ? { '--fr-px': `calc(${px} * var(--ws-px))` } : null),
    ...(opacity !== undefined ? { '--fr-o': opacity } : null),
  } as CSSProperties;
  return (
    <span className="wc-frame wst-frame" style={style} aria-hidden="true">
      {PIECES.map((p) => (
        <span key={p} className={`wc-fr-${p} wst-fr-${p}`} />
      ))}
    </span>
  );
}
