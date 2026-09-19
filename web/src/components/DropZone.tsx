import { useDroppable } from '@dnd-kit/core';
import { tr } from '../i18n';

interface DropZoneProps {
  active: boolean;
}

export default function DropZone({ active }: DropZoneProps) {
  const { setNodeRef, isOver } = useDroppable({
    id: 'ground-drop',
    data: { type: 'ground' },
  });

  return (
    <div
      id="inv-ground-zone"
      ref={setNodeRef}
      className={`${active ? 'active' : ''} ${isOver ? 'hover' : ''}`}
    >
      <svg viewBox="0 0 24 24">
        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 14l-4-4h3V8h2v4h3l-4 4z" />
      </svg>
      {tr('ui_drop_ground', 'Drop on the ground')}
    </div>
  );
}
