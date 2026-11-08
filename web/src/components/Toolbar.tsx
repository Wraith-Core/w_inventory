import { tr } from '../i18n';

interface ToolbarProps {
  onSort: () => void;
  onQuickStack?: () => void;
  containerOpen: string | null;
}

export default function Toolbar({ onSort, onQuickStack, containerOpen }: ToolbarProps) {
  return (
    <div className="inv-toolbar">
      <div className="tb-btn" onClick={onSort} title={tr('ui_sort_title', 'Sort by type and rarity (S)')}>
        <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 18h6v-2H3v2zM3 6v2h18V6H3zm0 7h12v-2H3v2z"/></svg>
        {tr('ui_sort', 'Sort')}
        <kbd className="tb-key">S</kbd>
      </div>
      {containerOpen !== null && onQuickStack && (
        <div className="tb-btn" onClick={onQuickStack} title={tr('ui_quick_stack_title', 'Move matching items to the container')}>
          <svg viewBox="0 0 24 24" fill="currentColor"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9h-4v4h-2v-4H9V9h4V5h2v4h4v2z"/></svg>
          {tr('ui_quick_stack', 'Quick stack')}
        </div>
      )}
    </div>
  );
}
