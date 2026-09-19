import React, { useMemo } from 'react';

interface WeightBarProps {
  percent: number;
  current?: number;
  max?: number;
  durability?: boolean;
}

const WeightBar: React.FC<WeightBarProps> = ({ 
  percent, 
  current, 
  max, 
  durability 
}) => {
  const weightClass = useMemo(() => {
    if (durability) return '';
    
    if (percent <= 60) return 'normal';
    if (percent <= 85) return 'warning';
    return 'critical';
  }, [percent, durability]);

  if (durability) {
    // A weapon's condition and food's freshness: white sound -> yellow -> red
    const gauge = percent < 30
      ? 'var(--gauge-low)'
      : percent < 70
      ? 'var(--gauge-mid)'
      : 'var(--gauge-full)';

    return (
      <div className="absolute bottom-0 left-0 right-0 h-[3px] bg-black/50 rounded-b-md overflow-hidden">
        <div
          style={{
            visibility: percent > 0 ? 'visible' : 'hidden',
            height: '100%',
            width: `${percent}%`,
            background: gauge,
            transition: 'width 0.3s ease, background 0.3s ease',
          }}
        />
      </div>
    );
  }

  return (
    <div className="weight-bar-container">
      <div className="weight-bar">
        <div
          className={`weight-bar-fill ${weightClass}`}
          style={{
            width: `${Math.min(percent, 100)}%`,
          }}
        />
      </div>
    </div>
  );
};
export default WeightBar;
