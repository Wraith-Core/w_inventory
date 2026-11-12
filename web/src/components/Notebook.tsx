import { useState, type ReactNode } from 'react';

/** The readiness line over an action: what is still missing (with «أصلحه» when it can be fixed here),
 *  or a plain sentence of what the action will do. */
export function Ready({ missing, note, fix, onFix }: { missing?: string; note?: ReactNode; fix?: string; onFix?: () => void }) {
  if (missing) {
    return (
      <div className="nb-ready is-missing">
        <span className="nb-ready-text">{missing}</span>
        {onFix && <button type="button" className="nb-fix" onClick={onFix}>{fix}</button>}
      </div>
    );
  }
  return <div className="nb-ready"><span className="nb-ready-text">{note}</span></div>;
}

/** A fold that starts closed («خيارات متقدمة»). */
export function Fold({ title, children }: { title: string; children: ReactNode }) {
  const [open, setOpen] = useState(false);
  return (
    <div className={'nb-fold' + (open ? ' is-open' : '')}>
      <button type="button" className="nb-fold-head" onClick={() => setOpen((v) => !v)} aria-expanded={open}>
        <span>{title}</span>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" aria-hidden="true"><path d="M6 9l6 6 6-6" /></svg>
      </button>
      {open && <div className="nb-fold-body">{children}</div>}
    </div>
  );
}

/** The keys row at the bottom of a window: [key, what it does] pairs. */
export function Keys({ keys }: { keys: Array<[string, string]> }) {
  return (
    <div className="nb-keys">
      {keys.map(([key, label]) => (
        <span className="nb-key" key={key + label}>
          <kbd className="nb-keychip">{key}</kbd>
          <span>{label}</span>
        </span>
      ))}
    </div>
  );
}
