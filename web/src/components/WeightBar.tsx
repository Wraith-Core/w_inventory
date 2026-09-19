import { useRef, useEffect, useMemo } from 'react';
import { N, fmtWeight } from '../utils/items';
import { InventoryItem } from '../typings';
import { tr } from '../i18n';

interface WeightBarProps {
  grid: (InventoryItem | null)[];
  maxWeight: number;
}

function useGridWeight(grid: (InventoryItem | null)[]) {
  return useMemo(() => {
    let t = 0;
    for (const it of grid) {
      if (!it) continue;
      t += N(it.weight);
      if (it.isContainer && it.containerContentWeight) t += N(it.containerContentWeight);
    }
    return t;
  }, [grid]);
}

export default function WeightBar({ grid, maxWeight }: WeightBarProps) {
  const total = useGridWeight(grid);

  return (
    <div className="sub-info">
      <span className="weight-label">{tr('ui_weight', 'Weight')}</span>
      <span id="inv-weight-text">{fmtWeight(total)} / {fmtWeight(maxWeight)}</span>
    </div>
  );
}

export function WeightProgress({ grid, maxWeight }: WeightBarProps) {
  const progressRef = useRef<HTMLDivElement>(null);
  const total = useGridWeight(grid);
  const pct = Math.min(100, (total / maxWeight) * 100);
  // White up to 60%, then yellow, then red when full
  const tier = pct >= 85 ? 'critical' : pct >= 60 ? 'warning' : 'normal';
  const heavy = pct > 75;

  useEffect(() => {
    if (heavy && progressRef.current) {
      progressRef.current.classList.add('weight-shake');
      const t = setTimeout(() => progressRef.current?.classList.remove('weight-shake'), 400);
      return () => clearTimeout(t);
    }
  }, [heavy]);

  return (
    <div className="progress" ref={progressRef}>
      <div
        className={`progress-bar ${tier}`}
        style={{ width: `${pct}%` }}
      />
    </div>
  );
}
