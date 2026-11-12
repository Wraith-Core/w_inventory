import { useRef, useEffect, useMemo } from 'react';
import { N, fmtWeight } from '../utils/items';
import { InventoryItem } from '../typings';
import { trf } from '../i18n';
import { formatCompact } from '../utils/formatNumber';
import { iso, kgShort, fullnessWord } from '../utils/words';

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

/** The bag's opening sentence: «حقيبتك · 18 من 40 كجم · معك $85», and «تكاد تمتلئ» in red when near full. */
export default function WeightBar({ grid, maxWeight, cash }: WeightBarProps & { cash?: number }) {
  const total = useGridWeight(grid);
  const pct = maxWeight > 0 ? (total / maxWeight) * 100 : 0;
  const full = fullnessWord(pct);
  const lead = trf('ui_nb_bag_lead', 'Your bag · %s of %s kg', iso(kgShort(total)), iso(kgShort(maxWeight)));
  const money = cash != null ? trf('ui_nb_bag_cash', 'you carry %s', iso('$' + formatCompact(cash))) : '';

  return (
    <div className="sub-info nb-lead" title={`${fmtWeight(total)} / ${fmtWeight(maxWeight)}`}>
      <span className="nb-lead-text">
        {lead}
        {money && <> · {money}</>}
        {full && <> · <b className="nb-critical">{full}</b></>}
      </span>
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
