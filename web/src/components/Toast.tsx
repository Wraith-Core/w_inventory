import { Toast as ToastType } from '../hooks/useToast';

interface ToastContainerProps {
  toasts: ToastType[];
}

export default function ToastContainer({ toasts }: ToastContainerProps) {
  return (
    <div id="inv-toasts">
      {toasts.map((t) => (
        <div key={t.id} className={`inv-toast ${t.type} ${t.phase === 'show' ? 'show' : ''} ${t.phase === 'fade-out' ? 'fade-out' : ''}`}>
          <span className="toast-text">{t.message}</span>
        </div>
      ))}
    </div>
  );
}
