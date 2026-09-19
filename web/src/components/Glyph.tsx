import type { CSSProperties } from 'react';

/**
 * An RDR2 texture, white on transparent, coloured through a CSS mask.
 * `tex` is the texture's name registered as --tex-<name> in main.tsx, and the colour comes from currentColor.
 */
export default function Glyph({
  tex,
  className,
  style,
}: {
  tex: string;
  className?: string;
  style?: CSSProperties;
}) {
  const mask: CSSProperties = {
    WebkitMaskImage: `var(--tex-${tex})`,
    maskImage: `var(--tex-${tex})`,
    ...style,
  };
  return <span className={`wc-glyph${className ? ` ${className}` : ''}`} style={mask} aria-hidden="true" />;
}
